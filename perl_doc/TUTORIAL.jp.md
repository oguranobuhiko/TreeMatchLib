
## TreeMatchLib

これは何?

文字列を直感的にマッチング/操作できる正規表現ライブラリのように木を処理できるライブラリ。


例えば正規表現ライブラリを使うと例えば次のように文字列のマッチ、抽出、加工を直感的に書くことができる。

```
if ('tel=01-2345-6789' =~ /tel=(.*)$/)
{
   $no = $1;                     # expected: $no == '01-2345-6789'
}
$s = 'abcd'; $s =~ s/(.)(...)/\1=\2/;  # expected $s == 'a=bcd'
@a = 'x:10,y:20,z:30' =~ /[0-9]+/g;    # expected @a == ('10','20','30');

# ただし .: 任意の1文字, *,+: 0,1回以上の繰り返し
# \1: 1個目のグループ()マッチ内容, [0-9]: 0,1,...,9 のいずれかの文字
```

TreeMatchLib ライブラリでは、木のパターン記法を使ってマッチ、抽出、加工ができる。
構文木を読みとって、解析/変換する処理を書きやすくすることを狙いとしている。

例えば、'A > B C' というパターンは、次のようなルートノード `A` が子ノード `B` `C` を持つ木とマッチする。
```
A
 +- B
 +- C
```



## 必要な環境
Perl が動作する環境が必要。
ターミナルで, `perl -v` などとして Perl が動くことを確認できる。
恐らく version 5.18 or later であれば動くだろう(未確認)。

Linux/Mac であれば多くの場合、Perl は最初からインストールされている。
Windows 環境では、Strawberry Perl などをインストールする。



## 動作確認

ダウンロードした `TreeMatchLib.pm` と `TreeWrapperBase.pm` (`perl_deploy` ディレクトリのもの) と同じディレクトリに以下の Perl のスクリプト (ここでは `sample.pl` とする) を作り Perl を実行できる環境で
```
perl -I. sample.pl
```
として実行する。(`-I.` はモジュールを探すディレクトリを指定するオプション)

`sample.pl`
```
use strict;
use warnings;
use TreeMatchLib;
useNewTreeClass Tree1 => 'key0', 'key1';

my $target = TreeConstruct('Tree1', 'A >B (C > D) E')->Tree();
$target->TreePrint();

if (my $result = TreeMatch($target, 'A > . C > .##x'))
{
    print "MATCH\n";
    print $result->Capture('x')->Node()->Attr0() . "\n";
}
```
出力
```
A
 +- B
 +- C
 |   +- D
 +- E
MATCH
D
```

なお、以降のプログラム例ではプログラムを示すときに、最初の use 4行を省略するので注意すること。
```
use strict;
use warnings;
use TreeMatchLib;
useNewTreeClass Tree1 => 'key0', 'key1';
```


## TreeConstruct

`TreeConstruct()` は木を作る関数である。
第1引数にツリークラス名を、第2引数にパターンを与えて呼びだす。

前項の例では、ツリークラス名は `useNewTreeClass` で作成した `'Tree1'` を用いている。

ノードの親子関係は `>` で表し、
ノードは ABC_012 のような英数字または、`"abc012&*"`、 `'abc012&*'` のような引用符で囲まれた文字列として記述する。引用符内では記号もノード名に使うことができる。

やや複雑な構造の例を示すので、優先度の解釈を読み取ってほしい
```
TreeConstruct('Tree1', 'A >(B>C) D "*>&\\"(?" > (B>C) E')->Tree->TreePrint;
の出力:
A
 +- B
 |   +- C
 +- D
 +- *>&"(?
     +- B
     |   +- C
     +- E
```

`TreeConstruct()` の戻り値は `TreePatternMatchResult` オブジェクトで、
```
my $result = TreeConstruct(...);
my $tree = $result->Tree();
my $root_node = $result->Node();
```
などとして、構築された木やそのルートノードを得ることができる。

Perl ではパラメータ0個でメンバ関数を呼び出す場合に `()` を省略できるので、
`TreeConstruct('Tree1', 'A >B C')->Tree->TreePrint;` のように書くことができる。

(なお、本ライブラリでは木とノードは区別される。木に対しては、ルートノードを置き換えたり削除する操作が可能である。)


## TreeMatch() と TreeMatchFind()

`TreeMatch()` は、対象の木が、ルートからみてパターンと同じ形かどうかを判定する関数である。(戻り値はマッチしたとき TreePatternMatchResult オブジェクト、失敗したときは undef を返す。論理値として評価するとそれぞれ真と偽になる。)

```
my $target = TreeConstruct('Tree1', 'A > (B>C) D A > B > C E')->Tree;
$target->TreePrint();
```
でできる木 (`$target`)
```
A
 +- B
 |   +- C
 +- D
 +- A
     +- B
         +- C
         +- E
```
に対して
```
my $r1 = TreeMatch($target, 'A>B D');
print $r1 ? "T\n" : "F\n";

my $r2 = TreeMatch($target, 'A>D A');
print $r2 ? "T\n" : "F\n";
```
はそれぞれ `T` と `F` を返す。(子要素は先頭から見るので後者は偽となる。)



### TreeMatchFind()

`TreeMatchFind()` は、対象の木から、パターンと同じ形となっている部分木を全て見つける関数である。(戻り値はマッチ毎の TreePatternMatchResult オブジェクトを並べた配列)

直前の例の木 (前項の `$target`) に対して
```
my @results = TreeMatchFind($target, 'B > C');
for my $r(@results)
{
    print "[" . $r->Node->Attr0() . "]\n";
    $r->Tree->TreePrint();
}
```
とすると次のように出力される。
```
[B]
B
 +- C
[B]
B
 +- C
 +- E
```
なお、`->Attr0()` はノードのプライマリ属性(ここではノード名 `A`、`B` など)を返すメンバ関数である。

## または、繰り返し、任意、undef、終端

パターン表記では正規表現ライブラリに似た表記が使える。
`|` は、またはを表し、`*` は 0回以上の組み合わせを、`+` は 1回以上の組み合わせを、`.` は任意のノード, `_` は空ノード、 `$` は兄弟ノードの終端を表す。

また、 `!A`など `!` をノードに前置したものは正規表現の`[^??]`に近く、後に続くノードパターンと適合しないノードにマッチする。

例
```
my $target = TreeConstruct('Tree1', 'A >B C C D>E _')->Tree;
$target->TreePrint();

my $r1 = TreeMatch($target, 'A>(B |B C) C D');
print $r1 ? "T\n" : "F\n";

my $r2 = TreeMatch($target, 'A>B C C$');
print $r2 ? "T\n" : "F\n";

my @results = TreeMatchFind($target, '.>E');
for my $r(@results)
{
    print "[" . $r->Node->Attr0() . "]\n";
    $r->Tree->TreePrint();
}

```
出力
```
A
 +- B
 +- C
 +- C
 +- D
     +- E
     +- (undef)
T
F
[D]
D
 +- E
 +- (undef)
```
`|` と `>` の演算子の結合は `A > B C| D E | F G > H I | J K` が `A > (B C | D E | (F G > (H I | J K)))` となるように解釈される。

なお、`|` は正規表現のそれとは異なり、選言ではなく順序付き選択(解析表現文法の `/` に相当)である。
`*` と `+` は最長一致であるが、正規表現と異なり、最長文字長(ノード数長)ではなく最長繰り返し回数である。またそれぞれに対応して最短を表す `*?` と `+?` も使うことができる。



## キャプチャ

ノードに `##capture_name` を後置することで、パターン中のノードに対応する対象木のノードにアクセスできる。


例えば、次のような対象木とパターンを使うと、TreeMatch() の戻り値(ここでは`$r1`)を用いて `##???` を後置したノードの情報にアクセスできる。
```
my $target = TreeConstruct('Tree1', 'E >X "+" Y')->Tree;
$target->TreePrint();

my $r1 = TreeMatch($target, 'E> .##capL  ("+"##op | "-"##op) .##capR');
print $r1 ? "T\n" : "F\n";
print "op: " . $r1->Capture('op')->Node->Attr0 . "\n";
print "cap1: " . $r1->Capture('capL')->Node->Attr0 . "\n";
print "cap2: " . $r1->Capture('capR')->Node->Attr0 . "\n";
```
出力
```
E
 +- X
 +- +
 +- Y
T
op: +
cap1: X
cap2: Y
```

なお、パターン中の `"+"` や `"-"` は繰り返しなどのパターンの機能ではなく `+` という名前を持つノードを表している。

### 複数キャプチャ

キャプチャ `##capture_name` は複数のノードに適合したときには最後のマッチしたノードを指す。 (これは正規表現のグループキャプチャとほぼ同じ。) 

複数キャプチャを表わす `##@capture_name` を用いると、マッチした全てのノードにアクセスできる。
例えば対象木 `"A > B C D E"` に対してパターン `A > . .##@cap*` を使うと、'cap' というキャプチャ名で `C` `D`, `E` にアクセスできる。

繰り返しや再帰(後述)のパターンと組み合わせると便利である。

例
```
my $target = TreeConstruct('Tree1', 'E >X (E2 > "+" Y) E2 > "+" Z')->Tree;
$target->TreePrint();

my $r1 = TreeMatch($target, 'E> .##@term (E2 > "+" .##@term)*');
print $r1 ? "T\n" : "F\n";
for my $cap ($r1->MultiCapture('term'))
{
    print '##@term: ' . $cap->Node->Attr0 . "\n";
}
```
出力
```
E
 +- X
 +- E2
 |   +- +
 |   +- Y
 +- E2
     +- +
     +- Z
T
##@term: X
##@term: Y
##@term: Z
```
(この例で `##term` を使った場合、`Z` のみがキャプチャされる。)

なお、 `##a` や `##@a` に似た表記に、後述する属性を表す `#a` がある。まぎらわしいので注意されたい。



## マッチ済みノードからの除外

前項のように `TreeMatchFind()` で一度マッチしたパターンと対応するノードは全てマッチ済みのノードとして、次にマッチする部分木の探索対象から外される。外される例:
```
my $target = TreeConstruct('Tree1', 'E#e1 > (E#e2 > ((E#e3 > X) "+" Y)) "+" Z')->Tree;
$target->TreePrint();

my @results1 = TreeMatchFind($target, 'E> (E "+" .##term| .##term )$');
for my $r1 (@results1)
{
    print "results1 [" . $r1->Capture('term')->Node->Attr0 . "]\n";
}
```
出力
```
E  <e1>
 +- E  <e2>
 |   +- E  <e3>
 |   |   +- X
 |   +- +
 |   +- Y
 +- +
 +- Z
results1 [Z]
results1 [X]
```
(この例では属性を指定する `#e1` (後述)が使われている。)

最初のマッチで `E#e1 > E#e2 "+" Z` がマッチした段階で、
`E#e2` はマッチ済みとなったため `E#e2 > E#e3 "+" Y` がマッチしていないことに注意。


`-` を前置することでマッチ済みのノードから外して、探索対象に残すことができる。

直前の例と同じ対象木に対して、パターンの2番目の `E` の前に `-` を追加して
```
my @results2 = TreeMatchFind($target, 'E> (-E "+" .##term| .##term )$');
for my $r2 (@results2)
{
    print "results2 [" . $r2->Capture('term')->Node->Attr0 . "]\n";
}
```
とすると、
```
results2 [Z]
results2 [Y]
results2 [X]
```
のように `E#e2 > E#e3 "+" Y` も抜かさずにマッチさせることができる。




## 木の書き換え、つなぎ換え

キャプチャを使うと、ノード情報にアクセスできるが、キャプチャの置かれたノードの場所にノードをつなぐなど、木の変更に使うこともできる。

以下は2つの木をつなぐ例である。(空ノードを表す `_` が使われている。)
```
my $r1 = TreeConstruct('Tree1', 'E > _##x "*" X');
my $r2 = TreeConstruct('Tree1', 'E##y > R "+" S');
$r1->Tree->TreePrint();
$r2->Tree->TreePrint();

my $cap_x = $r1->Capture('x');
my $cap_y = $r2->Capture('y');

$cap_x->SetNode($cap_y->Node);
$r1->Tree->TreePrint();
```
出力例
```
E
 +- (undef)
 +- *
 +- X
E
 +- R
 +- +
 +- S
E
 +- E       <--(note: inserted)
 |   +- R   <--(note: inserted)
 |   +- +   <--(note: inserted)
 |   +- S   <--(note: inserted)
 +- *
 +- X
```

マッチ結果のキャプチャに対しても同じことができる。例:
```
my $target = TreeConstruct('Tree1', 'A > (B > C) D > B > E')->Tree;
$target->TreePrint();


my @results = TreeMatchFind($target, 'B > .');
for my $r (@results)
{
    my $match_root_capture = $r->GetRootCapture();

    my $ins = TreeConstruct('Tree1', 'if > cond _##body');
    my $ins_root_node = $ins->Node;
    my $body_capture = $ins->Capture('body');

    $match_root_capture->SetNode($ins_root_node);
    $body_capture->SetNode($match_root_capture->Node);
}

$target->TreePrint;
```
出力
```
A
 +- B
 |   +- C
 +- D
     +- B
         +- E
A
 +- if            <--(note: inserted)
 |   +- cond      <--(note: inserted)
 |   +- B
 |       +- C
 +- D
     +- if        <--(note: inserted)
         +- cond  <--(note: inserted)
         +- B
             +- E
```



## 属性

木のノードは、プライマリ属性とセカンダリ属性と、その他の属性を持っている。
`A > ID#x1 B#{abc}pqr > C#1#{k}2` と書いたときの A, ID, B, C はプライマリ属性で、 `#値` と後置されている x1,1 は各ノードのセカンダリ属性である。
その他の属性は属性名を指定して `#{属性名}値` と後置する。

ノードから各属性にアクセスする場合それぞれ `$node->Attr0`, `$node->Attr1`, `$node->GetAttribute(属性名)` としてアクセスする。


例
```
my $target = TreeConstruct('Tree1', 'A > ID#x1 B#{abc}pqr > C#1#{k}2')->Tree;
$target->TreePrint;

my ($a, $id, $b, $c) = TreeMatchFind($target, '.');

print $a->Node->Attr0 . "\n";   # expect 'A'
print $id->Node->Attr0 . ' ' . $id->Node->Attr1 . "\n";   # expect 'ID x1'
print $b->Node->Attr0 . ' ' . $b->Node->GetAttribute('abc') . "\n";   # expect 'B pqr'
print $c->Node->Attr0 . ' ' . $c->Node->Attr1 . ' ' . $c->Node->GetAttribute('k') . "\n";   # expect 'C 1 2'
```
出力
```
A
 +- ID  <x1>
 +- B  {abc=pqr}
     +- C  <1>  {k=2}
A
ID x1
B pqr
C 1 2
```
(`$a`、`$id`、`$b`、`$c` にはそれぞれ4つのノードのマッチ結果の TreePatternMatchResult オブジェクトが入る。)

なお、`useNewTreeClass Tree1 => 'key0', 'key1'; `としたときの `key0`, `key1` は、`Tree1`クラスのそれぞれプライマリ/セカンダリの属性名で、その他の属性の属性名と重複しない範囲で自由に設定できる。

## 正規表現による名前のマッチ

ノード名や属性値のマッチでは、名前や値を書く代わりに `/パターン/` と書くことで完全一致ではなく、正規表現でのマッチを用いることができる。

例
```
my $target = TreeConstruct('Tree1', 'E1 > (E2 > ((E3 > ID#x1) "+" ID#x2)) "+" ID#x')->Tree;
$target->TreePrint();

# /^E/ は E で始まる文字列、/[0-9]/ は数字を含む文字列
my @results1 = TreeMatchFind($target, '/^E/##e > (-/^E/ "+"|) ID#/[0-9]/##term $');
for my $r1 (@results1)
{
    print "[results1]\n";
    print "    e: " . $r1->Capture('e')->Node->Attr0 . "\n";
    print "    term: " . $r1->Capture('term')->Node->Attr1 . "\n";
}
```
出力
```
E1
 +- E2
 |   +- E3
 |   |   +- ID  <x1>
 |   +- +
 |   +- ID  <x2>
 +- +
 +- ID  <x>
[results1]
    e: E2
    term: x2
[results1]
    e: E3
    term: x1
```
(この例では `ID#x` はそのセカンダリ属性値 `x` が数字を含まないので、`ID#x` に対応する部分木はマッチしていない。)



## 再帰

Perl / PCRE などでは `(?-2)` のような記法を使って再帰的なマッチが可能である。
このライブラリでも同様の再帰が可能で、再帰記法をつかって木の再帰的な構造にマッチさせることができる。
例えば `(?-2)` とすると、2つ外側の括弧 '(...)' のパターンのマッチをする。

例1
```
my $target = TreeConstruct('Tree1', 'E1 > E2  > E3')->Tree;
$target->TreePrint();

my $r1 = TreeMatch($target, ' (/E/##@cap > (?-1)|$)');
for my $cap ($r1->MultiCapture('cap'))
{
    print "cap: " . $cap->Node->Attr0 . "\n";
}
```
出力1
```
E1
 +- E2
     +- E3
cap: E1
cap: E2
cap: E3
```

例2
```
my $target = TreeConstruct('Tree1', 'E > (E  > (E > X) "+" Y) "+" Z')->Tree;
$target->TreePrint();

my $r1 = TreeMatch($target, ' E > (.##@t $ | (E > (?-2)) "+" .##@t)');
for my $cap ($r1->MultiCapture('t'))
{
    print "cap t: " . $cap->Node->Attr0 . "\n";
}
```
出力2
```
E
 +- E
 |   +- E
 |   |   +- X
 |   +- +
 |   +- Y
 +- +
 +- Z
cap t: X
cap t: Y
cap t: Z
```

例3
```
my $target = TreeConstruct('Tree1', 'E1 > (E2  > (E3 > X) "+" Y) "+" E4> (E5>Z) "*" W')->Tree;
$target->TreePrint();

my @result1 = TreeMatchFind($target, ' /^E/##root > (.##@t $ | (/^E/ > (?-2)) ("+"|"*") -.##@t)');
for my $r1 (@result1)
{
    print "root = " . $r1->Capture('root')->Node->Attr0 . "\n";
    for my $cap ($r1->MultiCapture('t'))
    {
        print "  term: " . $cap->Node->Attr0 . "\n";
    }
}
```
出力3
```
E1
 +- E2
 |   +- E3
 |   |   +- X
 |   +- +
 |   +- Y
 +- +
 +- E4
     +- E5
     |   +- Z
     +- *
     +- W
root = E1
  term: X
  term: Y
  term: E4
root = E4
  term: Z
  term: W
```
(他にラベルを付けてラベル名で再帰先を指定する方法を準備しているが、未実装。)



## 木のデータ形式、インポート、エクスポート

このライブラリでは `TreeWrapperBase` クラスを継承して作った木のデータを扱う。
`useNewTreeClass Tree1 => 'key0', 'key1';` などすると、指定したクラス名、プライマリ/セカンダリの属性名で `TreeWrapperBase` クラスを継承した、すぐに使える木クラス(この例では `Tree1`)を自動的に作る。

データ格納方法などが全く異なる木を扱うためには、インポート/エクスポートするか、 `TreeWrapperBase`、 `TreeWrapperBase::Node`、 `TreeWrapperBase::NodeBox`  それぞれの派生クラスを作る。


```
$dst_tree = $src_tree->ExportToFlatHashTree('children', 'name', 'val');
```
とすると、子のキーと、プライマリキー(省略可)、セカンダリキー(省略可) を指定して
```
$tree = {name=>'A', children=>[
    {name=>'B', children=>[]},
    {name=>'C', children=>[]}
] };
```
の形式の木にエクスポートする。Perl に詳しくない人向けに補足すると、これは JavaScript や Python の
```
tree = {'name':'A', 'children':[
    {'name':'B', 'children':[]},
    {'name':'C', 'children':[]}
] }
```
とほぼ同じである。プライマリキーやセカンダリキーが省略されると、`$src_tree` のものと同じものが使われる。

同形式からは次でインポートできる。
```
$tree = Tree1->newImportFromFlatHashTree($src_root_node, 'children', 'name', 'val');
```

また、次の形式を使いたい場合、
```
$node = {attr=>{name=>'A', val=>'B'}, children=>[$child_node1, $child_node2]};
```
エクスポート/インポートは次で可能である。
```
$src_tree->ExportToAttrhashChildTree($children_key, $attr_key, $key0, $key1);
$tree = Tree1->newImportFromAttrhashChildTree($src_root_node, $children_key, $attr_key, $key0, $key1) = @_;
```


## その他の機能

### 順序なしマッチ

抽象構文木(AST) では部分的に木の順序が不定 (もしくは不要) であることがある。
順序なしマッチ `>~`を用いると、兄弟の順序を問わないで、ノードの存在だけを調べることができる。

例えば `A >~ B C > D E` とすると、`A > B C > D E` とほぼ同じだが、`B` `C` は兄弟の何番目に出てきてもマッチする。

(プログラム例は省略)

### パスパターン

マッチ対象の部分木の上(よりルート側)に条件を掛ける機能(実装未完了)

### パスアクセス

マッチ結果のノードの親や親の親にアクセスする機能(MatchCapturePlace 型にメソッドが生えているが、未実装)

## (ついでに) JavaScript版

(作成中→できました)

(EOF)

