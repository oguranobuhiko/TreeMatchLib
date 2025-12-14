
## TreeMatchLib

What is this?

This is a library that allows you to process trees in the same intuitive way that a regular expression library allows matching and manipulating strings by pattern.

For instance, when using a regular expression library, you can intuitively write matching, extracting, and transforming operations like that:
```
if ('tel=01-2345-6789' =~ /tel=(.*)$/)
{
   $no = $1;                     # expected: $no == '01-2345-6789'
}
$s = 'abcd'; $s =~ s/(.)(...)/\1=\2/;  # expected $s == 'a=bcd'
@a = 'x:10,y:20,z:30' =~ /[0-9]+/g;    # expected @a == ('10','20','30');

# where .:any single character, and */+: zero/one-or-more repetitions
#   \1: the matched content of the first capture group ()
#   [0-9]: matches any single digit character from 0 to 9.
```

In the TreeMatchLib library, you can perform matching, extraction, and transformation using tree-pattern notation.
The goal is to make it easier to write codes for analysis and transformation of syntax trees.

For example, the pattern `A > B C` matches the following tree where the root node A has child nodes B and C:
```
A
 +- B
 +- C
```



## Runtime environment requirements

You need an environment Perl installed.
You can check Perl availability by `perl -v` command in your terminal.
This library will probably work with version 5.18 or later (not confirmed).

On Linux and Mac, Perl is usually installed by default.
On Windows, consider installing Strawberry Perl.



## First run

Place the downloaded `TreeMatchLib.pm` and `TreeWrapperBase.pm` (from `perl_deploy` directory) in somewhere same directory.
Then create the following Perl script (filename=`sample.pl` here) in the directory.
And run it in a Perl-executable environment using the following command.
```
perl -I. sample.pl
```
(`-I.` is an option that specifies the modules(`.pm`s) search directory.)


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
Output
```
A
 +- B
 +- C
 |   +- D
 +- E
MATCH
D
```

Note that the first four use lines will be omitted from the program examples listed in the rest of this document.
```
use strict;
use warnings;
use TreeMatchLib;
useNewTreeClass Tree1 => 'key0', 'key1';
```



## TreeConstruct

`TreeConstruct()` is a function that creates a tree.
It is called with two parameters, the tree class name and the pattern string.

In the previous example, `'Tree1'` was used as the tree class name, which was defined using `useNewTreeClass`.



Parent-child relationships between nodes are expressed with `>`.
Nodes can be written as alphanumeric strings such as `ABC_012`, or as quoted strings such as `"abc012&*"` or `'abc012&*'`. When quoted, symbol characters may also be included in node names.

Below, an example with a little complex structure is shown, so check how precedence is interpreted.
```
TreeConstruct('Tree1', 'A >(B>C) D "*>&\\"(?" > (B>C) E')->Tree->TreePrint;
=== OUTPUT ===
A
 +- B
 |   +- C
 +- D
 +- *>&"(?
     +- B
     |   +- C
     +- E
```
The return value of `TreeConstruct()` is a `TreePatternMatchResult` object, and by writing like,
```
my $result = TreeConstruct(...);
my $tree = $result->Tree();
my $root_node = $result->Node();
```
you can obtain the constructed tree and its root node.

In Perl, when calling a member function with zero parameter, the parentheses `()` can be omitted, so you can write code as `TreeConstruct('Tree1', 'A >B C')->Tree->TreePrint;`.

(Note that in this library, trees and nodes are treated as different entities. For trees, operations such as replacing or deleting the root node are available.)



## TreeMatch and TreeMatchFind

`TreeMatch()` is a function that determines whether the target tree matches the given pattern from its root.
It returns a TreePatternMatchResult object if the match succeeds, and undef if it fails. When evaluated as a boolean value, these return values become true and false, respectively.


For the tree(`$target`) created by
```
my $target = TreeConstruct('Tree1', 'A > (B>C) D A > B > C E')->Tree;
$target->TreePrint();
```
Output
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
following code will output T and F, respectively.
```
my $r1 = TreeMatch($target, 'A>B D');
print $r1 ? "T\n" : "F\n";

my $r2 = TreeMatch($target, 'A>D A');
print $r2 ? "T\n" : "F\n";
```
(The second `TreeMatch()` results false because the match of child elements is tested in order from the first sibling.)


### TreeMatchFind

`TreeMatchFind()` is a function that searches the target tree and finds all subtrees that match the given pattern. (Its return value is an array of `TreePatternMatchResult` objects --- one for each match.)

When applied to the tree used in the previous example (`$target`),

```
my @results = TreeMatchFind($target, 'B > C');
for my $r(@results)
{
    print "[" . $r->Node->Attr0() . "]\n";
    $r->Tree->TreePrint();
}
```
this code will produce the following output.
```
[B]
B
 +- C
[B]
B
 +- C
 +- E
```
Note that `->Attr0()` is a member function that returns the node's primary attribute (in this example, that is node name (`A`, `B`, etc.)).



## Pattern operators: choice, repetition, any, undef, end

In the pattern notation, operators similar to that of regular expression libraries can be used.
`|` represents ordered choice, `*` represents zero or more repetitions, `+` represents one or more repetitions, `.` matches any node, `_` matches an empty node, and `$` represents the end of sibling nodes.

Also, prefixing a node with `!`, such as `!A`, behaves similarly to `[^A]` in regular expressions, meaning it matches a node that does not match the following node pattern.

Example
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
Output
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
The combination of the `|` and `>` operators is interpreted such that:
`A > B C | D E | F G > H I | J K` is regarded as
 `A > B C| D E | F G > H I | J K` is regarded as `A > (B C | D E | (F G > (H I | J K)))`.

Note that `|` is different meaning from regular expressions': it is ordered selection (equivalent to `/` in parsing expression grammar(PEG)), not an alternation.
`*` and `+` match the longest possible sequence, but unlike regular expressions, 'longest' refers not to node count but to the maximum repeat count. The shortest forms, `*?` and `+?`, are also available.



## Capture

By appending `##capture_name` to a node in the pattern, you can access the matched node in the target tree.

For example, by using the following target tree and pattern,
you can access information about the mached nodes where `##???` was appended
via the return value of TreeMatch() (i.e. `$r1`)
```
my $target = TreeConstruct('Tree1', 'E >X "+" Y')->Tree;
$target->TreePrint();

my $r1 = TreeMatch($target, 'E> .##capL  ("+"##op | "-"##op) .##capR');
print $r1 ? "T\n" : "F\n";
print "op: " . $r1->Capture('op')->Node->Attr0 . "\n";
print "cap1: " . $r1->Capture('capL')->Node->Attr0 . "\n";
print "cap2: " . $r1->Capture('capR')->Node->Attr0 . "\n";
```
Output
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

Note that `"+"` and `"-"` in the pattern are not repetition or exclude pattern operators; they represent nodes whose names are literally `+` or `-`.



### Multiple capture

When a capture `##capture_name` corresponds to multiple nodes, it refers to only the last matched node (similar to group captures in regular expression libraries.).

By using the multi-capture form `##@capture_name`, you can access all matched nodes.
For example, for the target tree `"A > B C D E"` and the pattern `A > . .##@cap*`, you can access `C`, `D`, and `E` by using the capture name 'cap'.

This is useful when combined with repetition or recursive patterns (described later).

Example:
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
Output
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
(In this example, if you used `##term` instead, only `Z` would be captured.)

Note: Do not confuse capture notations `##a` or `##@a` with attribute notation `#a`(explained later).



## Excluding from already matched nodes

Nodes that matched a pattern once through `TreeMatchFind()` are treated as already matched, and are excluded from the further search.  Here is an example of such exclusion:
```
my $target = TreeConstruct('Tree1', 'E#e1 > (E#e2 > ((E#e3 > X) "+" Y)) "+" Z')->Tree;
$target->TreePrint();

my @results1 = TreeMatchFind($target, 'E> (E "+" .##term| .##term )$');
for my $r1 (@results1)
{
    print "results1 [" . $r1->Capture('term')->Node->Attr0 . "]\n";
}
```
Output
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
(In this example, `#e1` is used to specify an attribute, which will be explained later.)

At the point where the first match `E#e1 > E#e2 "+" Z` succeeds, the node `E#e2` is considered already matched, so note that `E#e2 > E#e3 "+" Y` does not match afterward.



By prefixing with `-`, you can exclude the node from the already-matched list and keep that as search candidate.

For the same target tree of the previous example, add `-` before the second `E` in the pattern, i.e.
```
my @results2 = TreeMatchFind($target, 'E> (-E "+" .##term| .##term )$');
for my $r2 (@results2)
{
    print "results2 [" . $r2->Capture('term')->Node->Attr0 . "]\n";
}
```
then `E#e2 > E#e3 "+" Y` is successfully matched without skipping it.

Output
```
results2 [Z]
results2 [Y]
results2 [X]
```



## Modifying trees using matching

You can use captures not only to access information on nodes, but also to modify the tree, such as replacing or inserting nodes at the capture location.

An example of connecting two trees (the symbol `_` is used to represent an empty node.):
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
Output
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

You can do the same thing using captures in match results. Example:
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
Output
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



## Node attributes

Nodes in a tree have a primary attribute, a secondary attribute, and additional attributes.
In the expression `A > ID#x1 B#{abc}pqr > C#1#{k}2`, the elements A, ID, B, and C represent primary attributes, and the values appended with `#value`, such as x1 and 1, represent secondary attributes.
Other attributes are written by specifying an attribute name and appending it in the form `#{attribute_name}value`.

To access attributes from a node, use `$node->Attr0` for the primary attribute, `$node->Attr1` for the secondary attribute, and `$node->GetAttribute(attribute_name)` for named attributes.


Example
```
my $target = TreeConstruct('Tree1', 'A > ID#x1 B#{abc}pqr > C#1#{k}2')->Tree;
$target->TreePrint;

my ($a, $id, $b, $c) = TreeMatchFind($target, '.');

print $a->Node->Attr0 . "\n";   # expect 'A'
print $id->Node->Attr0 . ' ' . $id->Node->Attr1 . "\n";   # expect 'ID x1'
print $b->Node->Attr0 . ' ' . $b->Node->GetAttribute('abc') . "\n";   # expect 'B pqr'
print $c->Node->Attr0 . ' ' . $c->Node->Attr1 . ' ' . $c->Node->GetAttribute('k') . "\n";   # expect 'C 1 2'
```
Output
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
(`$a`, `$id`, `$b`, and `$c` each contain a TreePatternMatchResult object of the four matched nodes.)

When using `useNewTreeClass Tree1 => 'key0', 'key1'; `, the names `key0` and `key1` are used as the attribute names for the primary and secondary attributes of the `Tree1` class, and can be freely chosen as long as they do not conflict with the names of other attributes.



## Regular expression match for names or attributes

For node names or attribute values matches, you can use a regular expression match as well as an exact match.
To use regular expression node/attribute-value match, write `/pattern/` instead of writing a name/value literal.


Example
```
my $target = TreeConstruct('Tree1', 'E1 > (E2 > ((E3 > ID#x1) "+" ID#x2)) "+" ID#x')->Tree;
$target->TreePrint();

# /^E/ denotes a string begin with 'E', /[0-9]/ denotes a string containing digit
my @results1 = TreeMatchFind($target, '/^E/##e > (-/^E/ "+"|) ID#/[0-9]/##term $');
for my $r1 (@results1)
{
    print "[results1]\n";
    print "    e: " . $r1->Capture('e')->Node->Attr0 . "\n";
    print "    term: " . $r1->Capture('term')->Node->Attr1 . "\n";
}
```
Output
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
(In this example, `ID#x` node does not match because its secondary attribute value `x` does not contain any digits, so the subtree rooted at `ID#x` is not matched.)



## Recursion

In Perl, PCRE, recursive matching is possible using notation like `(?-2)`.
This library supports the same sense of recursion.  `(?-2)` refers to the pattern enclosed by the parentheses two levels outside the current one.
Patterns with recursive notation can match recursive tree structures.

Example 1
```
my $target = TreeConstruct('Tree1', 'E1 > E2  > E3')->Tree;
$target->TreePrint();

my $r1 = TreeMatch($target, ' (/E/##@cap > (?-1)|$)');
for my $cap ($r1->MultiCapture('cap'))
{
    print "cap: " . $cap->Node->Attr0 . "\n";
}
```
Output 1
```
E1
 +- E2
     +- E3
cap: E1
cap: E2
cap: E3
```

Example 2
```
my $target = TreeConstruct('Tree1', 'E > (E  > (E > X) "+" Y) "+" Z')->Tree;
$target->TreePrint();

my $r1 = TreeMatch($target, ' E > (.##@t $ | (E > (?-2)) "+" .##@t)');
for my $cap ($r1->MultiCapture('t'))
{
    print "cap t: " . $cap->Node->Attr0 . "\n";
}
```
Output 2
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

Example 3
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
Output 3
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
(Also additional label notation for specifying recursion target is planned, but not yet implemented.)

## Export and import to/from other formats

In this library, tree data is handled through classes derived from `TreeWrapperBase` class.
By using `useNewTreeClass Tree1 => 'key0', 'key1';`, a ready-to-use tree class(`Tree1` in this case) is automatically created with the specified class name and the primary/secondary attribute names, inheriting from `TreeWrapperBase` class.

To use trees of other data structures, you must import/export the data, or create derived classes of `TreeWrapperBase`, `TreeWrapperBase::Node`, and `TreeWrapperBase::NodeBox`.


By using the following method
with parameters 'child key', and 'primary attribute name'(optional), and 'secondary attribute name'(optional),
```
$dst_tree = $src_tree->ExportToFlatHashTree('children', 'name', 'val');
```
the tree is exported into a tree of following format.
```
$tree = {name=>'A', children=>[
    {name=>'B', children=>[]},
    {name=>'C', children=>[]}
] };
```
For those not familiar with Perl, this format is almost the same as the following form in JavaScript and Python.
```
tree = {'name':'A', 'children':[
    {'name':'B', 'children':[]},
    {'name':'C', 'children':[]}
] }
```
If the primary key or secondary key is omitted, the same ones from `$src_tree` are used.

You can import from a tree of the same format using the following.
```
$tree = Tree1->newImportFromFlatHashTree($src_root_node, 'children', 'name', 'val');
```


For trees with the format of
```
$node = {attr=>{name=>'A', val=>'B'}, children=>[$child_node1, $child_node2]};
```
you can exports/imports by
```
$src_tree->ExportToAttrhashChildTree($children_key, $attr_key, $key0, $key1);
$tree = Tree1->newImportFromAttrhashChildTree($src_root_node, $children_key, $attr_key, $key0, $key1) = @_;
```

## Other features

### Order independent matching

In abstract syntax trees (ASTs), the order of nodes may not be specified (or unnecessary).
Unordered match childfen `>~` allows checking only for the presence of a node, not caring sibling order.

For example, `A >~ B C > D E` is similar to `A > B C > D E`, but the former pattern does not care about the order of `B`, `C`, or other siblings.

### Path pattern constraints

Functionality to apply conditions to ancestral nodes path above the match target node (work in progress).

### Parent path access

Functions to access ancestral nodes (the parent and grandparent nodes ...) of a match result node. (Methods exist in the MatchCapturePlace class but are currently unimplemented.)

## JavaScript version

Now available.

(EOF)
