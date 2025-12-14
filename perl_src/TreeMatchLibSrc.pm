# 
# vim: set et sw=4 sts=4 ai : 
use utf8;
use strict;
use warnings;

# あ
# use Encode;
# binmode STDIN,":encoding(cp932)";
# binmode STDOUT,":encoding(cp932)";

# { use Dumpvalue; Dumpvalue->new->dumpValue(...);}

package MatchCapturePlace;
use Carp;

# ========================================
# データ構造
#   $self->{node}   : TreeWrapperBase::Node (キャプチャされたノード)
#   $self->{subtree}: TreeWrapperBase::Tree (部分木)
#   $self->{path}   : ArrayRef[ { node => ..., tree => ..., next_child_index => ... }, ... ]
# ========================================

sub new
{
    my $class = shift;
    my ($node, $tree, $path) = @_;

    $path = [{node=>$node, tree=> $tree}] if !defined $path;
       # $path->[0]->{next_child_index} は無し
    my $self = {
        node    => $node,
        subtree => $tree,
        path    => $path,
    };

    return bless $self, $class;
}

sub newByIterator {
    my $class = shift;
    my ($iter, $root_capture) = @_;

    confess "Error: MatchCapturePlace::newFromIter(): iterator is at end" if $iter->IsEnd();

    if (!defined $root_capture)
    {
        # my $rootnode = $tree->GetRootNode();
        # $root_capture = MatchCapturePlace->new($rootnode, $tree, undef);
        my $tree = $iter->{iter_stack}->[0]->{tree};
        my $rootnode = $tree->GetRootNode();
        $root_capture = MatchCapturePlace->new($rootnode, $tree, undef);
    }


    my $cur_tree = $iter->Tree();
    my $cur_node = $iter->Node();

    # パスを構築：ルートから現在まで

    # duplicate path of root_capture;
    my @path = map { { %$_ } } @{ $root_capture->{path} };

    $path[-1]->{tree} = $iter->{iter_stack}->[0]->{tree};
    $path[-1]->{node} = $path[-1]->{tree}->GetRootNode();

    my $level;
    for ($level = 1; $level <=$#{ $iter->{iter_stack} }; $level++)
    {
        $path[-1]->{next_child_index} = $iter->{iter_stack}->[$level]->{sibling_index};

        my $tree_l = $iter->{iter_stack}->[$level]->{tree};
        my $node_l = undef;
        if (defined $tree_l) { $node_l = $tree_l->GetRootNode(); }

        push @path, {node=>$node_l , tree=>$tree_l};
    }
    my $ret_capture = MatchCapturePlace->new($cur_node, $cur_tree, \@path);

    return $ret_capture;
}


# ========== 基本アクセサ ==========

sub Node      { my $self = shift; return $self->{node}; }
sub Tree      { my $self = shift; return $self->{subtree}; }
sub PathLength{
    my $self = shift;
    # root で 1, root の子で 2

    if (!defined $self->{path}) { return 0; }
    return scalar @{ $self->{path} };
}

# ========== パス系取得 ==========

sub PathNthUpNode {
    my ($self, $n) = @_;

    confess "Error: Wrong argument.\n" if !defined $n;
    confess "Error: Wrong argument.\n" if $n < 0;

    my $len = $self->PathLength();
    return undef if $n >= $len;

    my $entry = $self->{path}->[$n];
    return $entry->{node};
}

sub PathNthUpTree {
    my ($self, $n) = @_;
    confess "Error: Wrong argument.\n" if !defined $n;
    confess "Error: Wrong argument.\n" if $n < 0;

    my $len = $self->PathLength();
    return undef if $n >= $len;

    my $entry = $self->{path}->[$n];
    return $entry->{tree};
}

# ========== ノード操作 ==========

sub SetNode {
    my ($self, $new_node) = @_;

    return $self->Tree()->SetRootNode($new_node);
}

sub DetachNode {
    my ($self) = @_;
    return $self->Tree()->SetRootNode(undef);
}

sub RemoveNode {
    my ($self) = @_;

    if ($self->PathLength() <= 1)
    { confess "Error in MatchCapturePlace::RemoveNode(): can't remove root node (b6413fd0_bda73400)\n"; }

    # path [1] (親ノード分)の使用が必要
    my $parent_node = $self->{path}->[1]->{node};
    my $i = $self->{path}->[1]->{next_child_index};

    my $old_node;
    ($old_node) = $parent_node->SpliceChildrenNodes($i,1);
    return $old_node;
}

sub SpliceNode {
    my $self = shift @_;
    my (@nodes) = @_;

    if ($self->PathLength() <= 1)
    { confess "Error in MatchCapturePlace::SpliceNode(): can't remove root node (64e72ddf_88a72f22)\n"; }

    # path [1] (親ノード分)の使用が必要
    my $parent_node = $self->{path}->[1]->{node};
    my $i = $self->{path}->[1]->{next_child_index};

    my $old_node;
    ($old_node) = $parent_node->SpliceChildrenNodes($i, 1, @nodes);
    return $old_node;
}

sub InsertBefore {
    my ($self, @nodes) = @_;
    # 自身の直前に @nodes を挿入。失敗時 die。

    if ($self->PathLength() <= 1)
    { confess "Error in MatchCapturePlace::InsertBefore(): can't remove root node (2df0c046_ae0cd7b4)\n"; }

    # path [1] (親ノード分)の使用が必要
    my $parent_node = $self->{path}->[1]->{node};
    my $i = $self->{path}->[1]->{next_child_index};

    $parent_node->SpliceChildrenNodes($i, 0, @nodes);
}

sub InsertAfter {
    my ($self, @nodes) = @_;
    # 自身の直後に @nodes を挿入。失敗時 die。

    if ($self->PathLength() <= 1)
    { confess "Error in MatchCapturePlace::InsertAfter(): can't remove root node (360ef699_4df2dab3)\n"; }

    # path [1] (親ノード分)の使用が必要
    my $parent_node = $self->{path}->[1]->{node};
    my $i = $self->{path}->[1]->{next_child_index};

    $parent_node->SpliceChildrenNodes($i + 1, 0, @nodes);
}

# ========== Path 経由のノード操作 ==========

sub PathNthUpSetNode {
    my ($self, $n, $new_node) = @_;
    my $entry = $self->_nth_path_entry_or_die($n);

    confess "Error: not yet implemented.(TODO)\n";
}

sub PathNthUpDetachNode {
    my ($self, $n) = @_;
    my $entry = $self->_nth_path_entry_or_die($n);

    confess "Error: not yet implemented.(TODO)\n";
}

sub PathNthUpRemoveNode {
    my ($self, $n) = @_;
    my $entry = $self->_nth_path_entry_or_die($n);

    confess "Error: not yet implemented.(TODO)\n";
}

sub PathNthUpSpliceNode {
    my ($self, $n, @nodes) = @_;
    my $entry = $self->_nth_path_entry_or_die($n);

    confess "Error: not yet implemented.(TODO)\n";
}

sub PathNthUpInsertBefore {
    my ($self, $n, @nodes) = @_;
    my $entry = $self->_nth_path_entry_or_die($n);

    confess "Error: not yet implemented.(TODO)\n";
}

sub PathNthUpInsertAfter {
    my ($self, $n, @nodes) = @_;
    my $entry = $self->_nth_path_entry_or_die($n);

    confess "Error: not yet implemented.(TODO)\n";
}

# ========== 内部: パス取得（範囲外なら die） ==========

sub _nth_path_entry_or_die {
    my ($self, $n) = @_;

    confess "Error: Wrong argument.\n" if !defined $n;
    confess "Error: Wrong argument.\n" if $n < 0;

    my $len = $self->PathLength();
    confess "Error: Wrong argument(expected arg(=$n) < $len).\n" if $n >= $len;

    my $entry = $self->{path}->[$n];
    return $entry;
}

# ========== 内部: デバッグ用表示関数 ==========

sub aux_debug_print_capture_node_tree_str {
    my ($node, $tree) = @_;

    my $node_str;
    if (!defined $node) { $node_str = '(undef)'; }
    else { $node_str = $node->Attr0() . "($node)"; }

    my $tree_str;
    if (!defined $tree) { $tree_str = '(undef)'; }
    else {
        if (!defined $tree->GetRootNode())
        { $tree_str = "$tree(node = undef)"; }
        else
        {
            $tree_str = "$tree(node = "
            . $tree->GetRootNode()->Attr0()
            . "(" . $tree->GetRootNode() . ")"
            .")";
        }
    }

    return "node = $node_str / (sub)tree = $tree_str";
}
sub aux_debug_print_capture {
    my $self = shift;

    my $node_tree_str = aux_debug_print_capture_node_tree_str($self->{node}, $self->{subtree});

    print "Capture [ $node_tree_str ]\n";

    for my $i (keys @{ $self->{path} })
    {
        my $e = $self->{path}->[$i];
        $node_tree_str = aux_debug_print_capture_node_tree_str($e->{node}, $e->{tree});
        my $next_i = $e->{next_child_index};
        $next_i = '_' if !defined $next_i;
        print "  [$i] $next_i : $node_tree_str\n";
    }
}

sub aux_debug_short_print
{
    my $self = shift;
    my $node_str = 'undef';
    if (defined $self->Node()) { $node_str = $self->Node()->Attr0();
        if (defined $self->Node()->Attr1()) { $node_str .= "(" . $self->Node()->Attr1() . ")"; }
}

    my $tree_str = 'undef';
    if (defined $self->Tree()->GetRootNode())
    { $tree_str = $self->Tree()->GetRootNode()->Attr0(); }

    my $path_string = '';
    my $n = @{ $self->{path} };
    my $i;
    for ($i = 0; $i <= $n - 2; $i++)
    {
        my $e_node = $self->{path}->[$i]->{node};
        my $e_node_name = 'undef';
        if (defined $e_node) {$e_node_name = $e_node->Attr0();}

        my $next_index = $self->{path}->[$i]->{next_child_index};
        $path_string.= "$e_node_name-$next_index,";
    }
    my $e_node = $self->{path}->[$i]->{node};
    my $e_node_name = 'undef';
    if (defined $e_node) {$e_node_name = $e_node->Attr0();}
    $path_string.= "$e_node_name";

    print "$node_str / $tree_str / $path_string\n";
}

# =============================================================
package TreePatternMatchResult;
use Carp;
use Scalar::Util; # blessed, reftype

# ========================================
# データ構造
#   $self->{matched_subtree_capture}   : MatchCapturePlace 型（想定）- マッチしたサブツリー（ルートのキャプチャ）
#   $self->{single_captures}   : HashRef{ name => MatchCapturePlace }
#   $self->{multiple_captures} : HashRef{ name => ArrayRef[ MatchCapturePlace ] }
# ========================================

sub new {
    my $class = shift;
    my ($root_capture, $single_captures, $multiple_captures) = @_;

    if (defined $single_captures && ref($single_captures) ne 'HASH') {
        confess "Error: single_captures must be a HashRef";
    }
    if (defined $multiple_captures && ref($multiple_captures) ne 'HASH') {
        confess "Error: multiple_captures must be a HashRef";
    }
    $single_captures = {} if !defined $single_captures;
    $multiple_captures = {} if !defined $multiple_captures;

    my $self = {
        matched_subtree_capture   => $root_capture,                      # ここは MatchCapturePlace を想定
        single_captures   => $single_captures   // {},
        multiple_captures => $multiple_captures // {},
    };

    return bless $self, $class;
}

sub Capture {
    my ($self, $name) = @_;
    confess "Error: Capture(name) requires a capture name" unless defined $name;

    if (! exists $self->{single_captures}->{$name}) { return undef; }
    return $self->{single_captures}->{$name};
}

sub MultiCapture {
    my ($self, $name) = @_;
    confess "Error: MultiCapture(name) requires a capture name" unless defined $name;
    confess "Error: MultiCapture() is called in non wantarray context\n" if !wantarray;
    if ( !exists $self->{multiple_captures}->{$name})
    {
        my @ret = ();
        return @ret;
    }

    my $aref = $self->{multiple_captures}->{$name};
    return @$aref;
}

sub GetCaptureNames {
    my ($self) = @_;
    return sort keys %{ $self->{single_captures} };
}

sub GetMultiCaptureNames {
    my ($self) = @_;
    return sort keys %{ $self->{multiple_captures} };
}

sub GetRootCapture {
    my ($self) = @_;
    return $self->{matched_subtree_capture};
}

sub Node {
    my ($self) = @_;
    my $root_cap = $self->{matched_subtree_capture};

    return undef if !defined $root_cap;
    return $root_cap->Node();
}

sub Tree {
    my ($self) = @_;
    my $root_cap = $self->{matched_subtree_capture};

    return undef if !defined $root_cap;
    return $root_cap->Tree();
}

# ========== 内部: デバッグ用表示関数 ==========
sub aux_debug_short_print
{
    my $self = shift;

    print "Match: ";
    $self->{matched_subtree_capture}->aux_debug_short_print();
    my $k;
    for $k ($self->GetCaptureNames())
    {
        print "  ##$k: ";
        $self->Capture($k)->aux_debug_short_print();
    }
    for $k ($self->GetMultiCaptureNames())
    {
        my @multi_c = $self->MultiCapture($k);
        for (my $i = 0; $i < @multi_c; $i++)
        {
            print "  ##\@$k $i: ";
            $multi_c[$i]->aux_debug_short_print();
        }
    }
}


# =============================================================
package TreeMatchLib;

use TLLex;
use output_TreePatParser_p;
use output_PathPatParser_p;
use TLTreePatternAST;

use Scalar::Util;

use Carp;


# use Exporter 'import';
# our @EXPORT = qw/ TreeConstruct TreeMatch TreeMatchFind TreeIfMatchDo /;
sub force_import
{
    my ($pkg, $exp_to) = @_; no strict 'refs';
    $exp_to = caller(0) if (!defined $exp_to);
    for my $sym ( qw/ TreeConstruct TreeMatch TreeMatchFind TreeIfMatchDo /)
    {  *{"${exp_to}::$sym"} = \&{"${pkg}::$sym"};  }
    # {  *{"${exp_to}::$sym"} = \&{"TreeMatchLib::$sym"};  }
}
sub import
{
    my $callpkg = caller(0);
    __PACKAGE__->force_import($callpkg);
    TreeWrapperBase->force_import($callpkg)
}




sub TreeConstruct
{
    my ($tree_class, $pattern, $root_capture) = @_;
    # $root_capture can be undef

    if(defined($root_capture) and Scalar::Util::blessed($root_capture) ne 'MatchCapturePlace')
    { confess "Error: arg1(\$tree) must be MatchCapturePlace object!\n"; }

    if (!defined $pattern)
    {
        confess "Error: called with wrong type parameter (TreeConstruct(tree_class, pattern, root_capture?)). (f090d0e9_ad184645)\n";
    }

    my $tok = TokenizerSeparated->new($pattern);
    my $ast = TLTreePatternAST::ToTreePatternAST(TreePatternParser::parse($tok->{treepat}));

    # main::tree_output3($ast);


    my $tmp_tree = $tree_class->newByRootNode(undef);
    my $new_iter = TreeWrapperBaseIterator
                ->new($tmp_tree);

    $new_iter->{iter_stack}->[0]->{tree} = undef;
    $new_iter->{iter_stack}->[0]->{sibling_index} = 0;
    $new_iter->{iter_stack}->[0]->{sibling_num} = 0;
    # 強制的に空の木のイテレータとしている

    my $context = {
        tree_class => $tree_class,
        node_class => $tree_class->NodeClass(),
        target_tree => undef, # ルート木を設定したときに確定する
        target_iter => $new_iter,
        single_capture_list =>[],
        multi_capture_list =>[],
        root_capture => $root_capture, # undef if root of target tree
                                       # fixed when root node is generated
    };
    # $astは別に渡す


    aux_rec_TreeConstruct($context, $ast);
    if (!$context->{target_iter}->IsRoot())
    { confess "Error: internal error (d8929b96_d51c2c80)\n"; }
    if (!$context->{target_iter}->IsEnd())
    { confess "Error: internal error (b84d4136_b466e5e0)\n"; }

    $context->{target_iter}->_top()->{sibling_index} = 0; # root node position 
    $context->{target_iter}->_top()->{tree} = $context->{target_tree}; # root node position


    my %single_captures;
    my %multi_captures;
    {
        my $e;
        for $e (@{ $context->{single_capture_list} })
        {
            $single_captures{$e->{name}} = $e->{capture};
        }
        for $e (@{ $context->{multi_capture_list} })
        {
            my $name = $e->{name};
            if(!exists $multi_captures{$name}) { $multi_captures{$name} = []; }
            push @{ $multi_captures{$name} }, $e->{capture};
        }
    }

    return TreePatternMatchResult->new(
        MatchCapturePlace->newByIterator($context->{target_iter}, $context->{root_capture}),
        \%single_captures, \%multi_captures);
}

sub aux_TreeConstruct_add_node
{
    my ($context, $ast) = @_;
    my $ast_node = $ast->GetRootNode();

    if ($ast_node->Attr0() ne 'a_Node')
    { confess "Error: internal error (3721cd81_aec0c4a8)\n"; }

    # null/any/id/id_regexp/end

    # ノードの種類を確定しノードを作成
    #
    #
    #
    # 種類に関わる属性
    #   {exclude_matched}  '-' に対応
    #   {neg}  '!' に対応
    #   {node_type} = none/any/id/id_regexp/end  それぞれ _ . AA // $ に対応
    #   # {val} Attr1
    #

    my $neg = $ast_node->GetAttribute('neg');
    my $node_type = $ast_node->GetAttribute('node_type');

    my $new_node;
    if ($node_type eq 'none')
    {
        $new_node = undef;
    }
    elsif ($node_type eq 'any')
    { confess "Error: can't use any node in TreeConstruct.\n"; }
    elsif ($node_type eq 'id')
    {
        $new_node = $context->{node_class}->new({});
        my $new_node_id = $ast_node->Attr1();
        if (!defined $new_node_id)
        {
            $new_node_id = 'NEED_SOME_CODE'
        }
        $new_node->SetPrimaryAttribute0($new_node_id);
    }
    elsif ($node_type eq 'id_regexp')
    { confess "Error: can't use regexp node name in TreeConstruct.\n"; }
    elsif ($node_type eq 'end')
    {
        # just ignore
        # (属性やキャプチャは無視される、エラーにすべきか?)
        return;
    }
    else
    { confess "Error: internal error (node_type = $node_type) (b720a3af_0b832a0f)\n"; }





    # 属性を設定する
        # 属性を設定する

    my $a_attr_cond_list_node = aux_attr0_child($ast, 'a_Attr_Cond_List', 0)->GetRootNode();
    $a_attr_cond_list_node->ForEachChildNodes(sub {
        my ($attr_cond_node) = @_;
        #    {key_type} sec/other
        #    {match_type} str/regexp
        #    {val} Attr1
        #    {key_val}
        my $key_type = $attr_cond_node->GetAttribute('key_type');
        my $match_type = $attr_cond_node->GetAttribute('match_type');
        my $val = $attr_cond_node->GetPrimaryAttribute1(); # val

        if ($node_type eq 'null')
        { confess "Error: empty node can't have attribute"; }

        if (!defined $match_type)
        { confess "Error: internal error (544db9ae_a8b1855f)\n"; }
        if ( $match_type eq 'regexp' )
        { confess "Error: can't use regexp in construction pattern\n"; }
        if ( $match_type ne 'str' )
        { confess "Error: internal error (match_type = '$match_type') (006e4942_8ea8cc7c)\n"; }

        if (!defined $val)
        { confess "Error: internal error (db1dab8b_46900b43)\n"; }

        if ($key_type eq 'sec')
        {
            $new_node->SetPrimaryAttribute1($val);
        }
        elsif ($key_type eq 'other')
        {
            my $key_val = $attr_cond_node->GetAttribute('key_val');
            if (!defined $key_val)
            { confess "Error: internal error (da889092_1e96d385)\n"; }

            $new_node->SetAttribute($key_val, $val);
        }
        else
        { confess "Error: internal error (8332821d_c2265966)\n"; }

    } );


    # 追加する(ルートかどうかで場合分け)
    my $iter_top_frame = $context->{target_iter}->_top();
    if ($context->{target_iter}->IsRoot())
    {
        if (!$context->{target_iter}->IsFirst())
        { confess "Error: multiple root node (*)!\n"; }
        if ($iter_top_frame->{sibling_index} != 0)
        { confess "Error: multiple root node (**)!\n"; }

        my $root_tree = $context->{tree_class}->newByRootNode($new_node);

        $context->{target_tree} = $root_tree;

        if (!defined $context->{root_capture})
        {
            my $rootnode = $root_tree->GetRootNode();
            $context->{root_capture} = MatchCapturePlace->new($rootnode, $root_tree, undef);
        }

        $iter_top_frame->{tree} = $root_tree;
        $iter_top_frame->{sibling_index} = 0;
        $iter_top_frame->{sibling_num} = 1;
    }
    else
    {
        my $iter_parent_frame = $context->{target_iter}->_parent_frame();

        my $n = $iter_parent_frame->{tree}->GetRootNode()->NumChildren();

        if ($iter_top_frame->{sibling_index} != $n)
        { confess "Error: internal error (511212f8_3021e18b)\n"; }
        if ($iter_top_frame->{sibling_num} != $n)
        { confess "Error: internal error (4a983a88_00e09ee9)\n"; }

        my $parent_node = $iter_parent_frame->{tree}->GetRootNode();
        if (!defined $parent_node)
        { confess "Error: Can't add child to empty node (b04a02ef_8ec7d2db)\n"; }
        $parent_node->AppendChildNodes($new_node);

        $iter_top_frame->{tree} = $parent_node->NthChildSubtree($n);
        $iter_top_frame->{sibling_num} = $n + 1;
    }
    # Capture を生成する
    my $a_place_list_node = aux_attr0_child($ast, 'a_Place_List', 1)->GetRootNode();
    $a_place_list_node->ForEachChildNodes(sub {
        my ($place_node) = @_;
        my $place_type = $place_node->Attr0();
        my $place_name = $place_node->Attr1();

        if ($place_type eq 'a_Single_Place')
        {
            push @{ $context->{single_capture_list} }, {
                name => $place_name,
                capture => MatchCapturePlace->newByIterator(
                    $context->{target_iter}, $context->{root_capture}
                ),
            };
        }
        elsif ($place_type eq 'a_Multi_Place')
        {
            push @{ $context->{multi_capture_list} }, {
                name => $place_name,
                capture => MatchCapturePlace->newByIterator(
                    $context->{target_iter}, $context->{root_capture}
                ),
            };
        }
        else
        {
            confess "Error: internal error (place_type = $place_type) (baf31943_77ead180)\n";
        }
    } );

}
sub aux_rec_TreeConstruct
{
    my ($context, $ast) = @_;

    # print "[" . $ast->GetRootNode->Attr0 . "]\n";

    # ここでは反復制御は ast の再帰で行う。
    # TreeWrapperBaseIterator は対象木のキャプチャ生成も行う

    return if !defined $ast;

    my $cur_node = $ast->GetRootNode();
    return if !defined $cur_node;

    my $cur_node_id = $cur_node->Attr0();
    $cur_node_id = '' if !defined $cur_node_id;

    if ($cur_node_id eq 'a_PathPat')
    {
        if ($cur_node->NumChildren() > 0)
        { confess "Error: PathPattern must be empty in TreeConstruct()!\n"; }

        return; # no child
    }

    # ノードの種類によって場合分け
    if ($cur_node_id eq 'a_Node')
    {
        # これがルートノード
        aux_TreeConstruct_add_node($context, $ast);

        $context->{target_iter}->MoveDown();


        # # a_Child 以下を処理
        my $child_list_subtree = aux_attr0_child($ast, 'a_Child', 2);

        if (!defined $child_list_subtree)
        { confess "Error: internal error (dbf45ab5_f0ace36e)\n"; }
        my $child_list_node = $child_list_subtree->GetRootNode();

        my $i = 0;
        my $n = $child_list_node->NumChildren();
        for ($i = 0; $i < $n; $i++)
        {
            my $child_tree = $child_list_node->NthChildSubtree($i);
            aux_rec_TreeConstruct($context, $child_tree)
        }


        $context->{target_iter}->MoveUp();
        $context->{target_iter}->MoveNextSibling();

        return;
    }
    elsif ($cur_node_id eq 'a_P_Or')
    { confess "Error: Can't use OR in TreeConstruct Pattern!\n"; }
    elsif ($cur_node_id eq 'a_Parent_Child')
    { confess "Error: internal error (2e59eca7_8d044a5b)\n"; }
    elsif ($cur_node_id eq 'a_Rep0')
    { confess "Error: Can't use Repeat in TreeConstruct Pattern!\n"; }
    elsif ($cur_node_id eq 'a_Rep1')
    { confess "Error: Can't use Repeat(1) in TreeConstruct Pattern!\n"; }
    elsif ($cur_node_id eq 'a_Rec_ref')
    { confess "Error: Can't use recursive reference in TreeConstruct Pattern!\n"; }
    else
    {
        # $node が undef と 'a_PathPat' の場合は上で処理済み
        # いくつかの種類はここではじく必要がある。

        my @next_subtrees
            = map {$cur_node->NthChildSubtree($_)} $cur_node->ChildrenKeys();
        for my $t (@next_subtrees)
        {
            aux_rec_TreeConstruct($context, $t);
        }

    }
}

sub aux_is_valid_child_index
{
    my ($tree, $n) = @_;
    if(! UNIVERSAL::isa ($tree, 'TreeWrapperBase'))
    { confess "Error: arg0(\$tree) must be subclass of TreeWrapperBase!\n"; }

    my $root_node = $tree->GetRootNode();
    if (!defined($root_node)) { return 0; }

    if ($n < 0) { return 0; }

    my $num_child = $root_node->NumChildren();
    if ($n >= $num_child) { return 0; }
    return 1;
}

sub aux_nth_child_node_or_undef
{
    my ($tree, $n) = @_;
    if(! UNIVERSAL::isa ($tree, 'TreeWrapperBase'))
    { confess "Error: arg0(\$tree) must be subclass of TreeWrapperBase!\n"; }

    my $root_node = $tree->GetRootNode();
    if (!defined($root_node)) { return undef; }
    if (!aux_is_valid_child_index($tree, $n)) { return undef }

    return $root_node->NthChildNode($n);
}
sub aux_nth_child_subtree_or_undef
{
    my ($tree, $n) = @_;
    if(! UNIVERSAL::isa ($tree, 'TreeWrapperBase'))
    { confess "Error: arg0(\$tree) must be subclass of TreeWrapperBase!\n"; }

    my $root_node = $tree->GetRootNode();
    if (!defined($root_node)) { return undef; }
    if (!aux_is_valid_child_index($tree, $n)) { return undef }

    return $root_node->NthChildSubtree($n);
}
sub aux_attr0_child
{
    my ($tree, $value, $expected_n) = @_;
    # assertion of $tree will be conducted by subroutine

    my $child_node;

    if (aux_is_valid_child_index($tree, $expected_n))
    {
        $child_node = aux_nth_child_node_or_undef($tree, $expected_n);
        if (defined($child_node))
        {
            my $attr = $child_node->Attr0();
            if (defined($attr) && $attr eq $value)
            {
                return aux_nth_child_subtree_or_undef($tree, $expected_n);
            }
        }
    }
    my $root_node = $tree->GetRootNode();
    if (!defined($root_node)) { return undef; }

    my $n = $root_node->NumChildren();
    for my $i (0 .. $n - 1)
    {
        $child_node = aux_nth_child_node_or_undef($tree, $i);
        if (defined($child_node))
        {
            my $attr = $child_node->Attr0();
            if (defined($attr) && $attr eq $value)
            {
                return aux_nth_child_subtree_or_undef($tree, $expected_n);
            }
        }
    }
    return undef;
}

sub TreeMatch
{
    my ($tree, $pattern, $base_root_capture, $next_capture_list) = @_;

    if (!defined $pattern)
    {
        confess "Error: called with wrong type parameter (TreeMatch(tree, pattern, base_root_capture?, next_capture_list?)) (cc84cd58_50806541)\n";
    }

    if (!defined $base_root_capture)
    {
        my $rootnode = $tree->GetRootNode();
        $base_root_capture = MatchCapturePlace->new($rootnode, $tree, undef);
    }

    if (!defined $next_capture_list) { } # do nothing
    if (defined $next_capture_list && Scalar::Util::reftype($next_capture_list) ne 'ARRAY')
    {
        confess "Error: next_capture_list (argument 4) must be undef or ref of ARRAY!\n";
    }

    # $next_capture_list は MatchCapturePlase を要素とする配列への参照
    # または undef
    #
    #
    # パスパターンの処理をしてから、ツリーパターンの処理をする

    my $tok = new TokenizerSeparated($pattern);

    # 0a. パスパターンの AST を作る (まだパースして構文木を作るところまで)
    my $st_path_pattern = PathPatternParser::parse($tok->{pathpat});

    #
    # 
    # context =
    #     iter_pattern_ast  パターンASTイテレータ   (バックトラックでは要コピー)
    #     iter_target_tree  対象木ASTイテレータ     (バックトラックでは要コピー)
    # (不要か)    block_level       現在の括弧のレベル     (int:要コピー)
    #     backtrack_stack  バックトラックスタック [ マッチしなければ pop して復元 ]
    #     next_node_capture_list  次検索ノードキャプチャリスト (単調増加リスト)
    #     next_node_child_level  次検索ノードから何段階の子か?
    #                  '-' で exclude されたノードから何個下の子か
    #     single_capture_list            キャプチャリスト             (単調増加リスト)
    #     multi_capture_list            キャプチャリスト             (単調増加リスト)
    #
    #     non_order_matched_siblings_flame_stack (インデックス集合のハッシュのスタック)
    #     below_neg_node  0or1

    # backtrack_stack_element =
    #     iter_pattern_ast => TreeWrapperBaseIterator   書き戻し用の複製
    #     iter_target_tree => TreeWrapperBaseIterator   書き戻し用の複製
    #
    #     root_capture => MatchCapturePlace ルートノードのパス情報
    # (不要か) block_level      => Int                   書き戻し用
    #     next_node_capture_list_trim_length => 要素数:Int  切り詰め後の長さ
    #     next_node_child_level   => :Int
    #     single_capture_list_trim_length   => 要素数:Int   切り詰め後の長さ
    #     multi_capture_list_trim_length    => 要素数:Int   切り詰め後の長さ
    #
    #     non_order_matched_siblings_flame_stack 各ハッシュからのコピー
    #     below_neg_node  0 or 1                 単純値コピー
    #
    # _do_backtrack() ...


    # 1. ツリーパターンのAST を作る

    my $ast_tree_pattern_tree = TLTreePatternAST::ToTreePatternAST(TreePatternParser::parse($tok->{treepat}));
    my $ast_path_pattern_tree = undef;


    # if ($ast_path_pattern_tree->GetRootNode()->Attr0 ne 'a_Path_Pat')
    # { confess "Error: internal error (8e62129d_c660a265)\n"; }

    # if ($ast_tree_pattern_tree->GetRootNode()->Attr0 ne 'a_Tree_Pat')
    # { confess "Error: internal error (f62f34c3_528f21ad)\n"; }


    # # とりあえず path pattern が指定されていたらエラーにしておく
    # if ($ast_path_pattern_tree->GetRootNode()->NumChildren() > 0)
    # { confess "Error: path pattern is not yet implemented (TreeMatch) (3ec8111f_9507532b)\n"; }



    # 2. path pattern の matching の準備をする
    #
    my @single_capture_list = ();
    my @multi_capture_list = ();
    # 3. path pattern の matching をする
    #

    # do something

    # 4. コンテキスト変数を設定
    my $context = {
        # パターンASTイテレータ   (バックトラックでは要コピー)
        iter_pattern_ast => TreeWrapperBaseIterator->new($ast_tree_pattern_tree),

        # 対象木イテレータ     (バックトラックでは要コピー)
        iter_target_tree => TreeWrapperBaseIterator->new($tree),

        # (不要) block_level       現在の括弧のレベル     (int:要コピー)

        # バックトラックスタック [ マッチしなければ pop して復元 ]
        backtrack_stack => [],
        # 次検索ノードキャプチャリスト (単調増加リスト)
        next_node_capture_list => $next_capture_list,
        # 次検索ノード('-' で除外されたもの)から何段階の子か?
        next_node_child_level => 0,
        # キャプチャリスト             (単調増加リスト)
        single_capture_list => \@single_capture_list,
        multi_capture_list  => \@multi_capture_list,

        non_order_matched_siblings_flame_stack =>[],
        below_neg_node => 0,

        root_capture => $base_root_capture,
    };

    # 5. tree pattern の matching をする

    my $success = aux_TreeMatch_traverse_tree_pat($context);
    if (!$success)
    {
        # マッチに失敗したら、全ての子要素を次探索対象として
        # 結果オブジェクトの代わりに undef を返す
        if (defined $next_capture_list)
        {
            @{ $next_capture_list } = ();

            my $iter_target = TreeWrapperBaseIterator->new($tree);
            if(defined $iter_target->Node())
            {
                $iter_target->MoveDown();
                while (!$iter_target->IsEnd)
                {
                    push @{ $next_capture_list },
                        MatchCapturePlace->newByIterator($iter_target, $context->{root_capture});
                    $iter_target->MoveNextSibling();
                }
            }

        }
        return undef;
    }


    # 6. capture_list を設定する
    #
    my %single_captures;
    my %multi_captures;
    {
        my $e;
        for $e (@single_capture_list)
        {
            $single_captures{$e->{name}} = $e->{capture};
        }
        for $e (@multi_capture_list)
        {
            my $name = $e->{name};
            if(!exists $multi_captures{$name}) { $multi_captures{$name} = []; }
            push @{ $multi_captures{$name} }, $e->{capture};
        }
    }

    # 7. 結果オブジェクトを設定する

    return TreePatternMatchResult->new(
        MatchCapturePlace->newByIterator(
            TreeWrapperBaseIterator->new($tree),
            $context->{root_capture}
        ),
        \%single_captures, \%multi_captures );

}

sub aux_TreeMatch_traverse_tree_pat
{
    my ($context) = @_;

    # 返り値 マッチ:1 / マッチせず:0
    # TreeMatch の実際の反復部分


    while(1)
    {
        # $context->{iter...} が指す先はバックトラックすると変わるので、
        # 毎回 update する。
        my $iter_pat = $context->{iter_pattern_ast};
        my $iter_target = $context->{iter_target_tree};
        # print "[" . $ast->GetRootNode->Attr0 . "]\n";

        # ここでは反復制御は $context->{iter_pattern_ast} で行う。

        if ($iter_pat->IsEnd())
        {
            # Up して
            #   Root だったら 成功として return
            #   Root でなければ
            #       a_Child なら target を MoveUP する
            #       MoveNextSibling して継続




            $iter_pat->MoveUp();
            if ($iter_pat->IsRoot()) { return 1; }

            # Up 直後

            if ($iter_pat->Node()->Attr0 eq 'a_Child')
            {
                # a_Non_Order の親ではなく a_Child に遷移したばあい
                # target の UP をする前に残りの兄弟を next_capture に追加する

                if ($context->{next_node_child_level} ==0 && defined $context->{next_node_capture_list})
                {
                    while (!$iter_target->IsEnd())
                    {
                        push (@{ $context->{next_node_capture_list} },
                            MatchCapturePlace->newByIterator( $iter_target , $context->{root_capture})
                        );
                        $iter_target->MoveNextSibling();
                    }
                }

                if ($context->{next_node_child_level} > 0)
                {
                    $context->{next_node_child_level} --;
                }

                $iter_target->MoveUp();
                $iter_target->MoveNextSibling();
            }
            elsif ($iter_pat->Node()->Attr0() eq 'a_Non_Order')
            {
                # 順番なしのノードに Up した場合
                # a_Non_Order での処理から移した

                # (a_Child >) a_Non_Order
                # 親のID
                my $p_id = $iter_pat->{iter_stack}->[ @{ $iter_pat->{iter_stack}} - 2 ]->{tree}->GetRootNode()->Attr0();
                # # 親の親のID
                # my $pp_id = $iter_pat->{iter_stack}->{ @{ $iter_pat->{iter_stack}} - 3}->Node()->Attr0();;
                if ($p_id ne 'a_Child')
                {
                    confess "Error: Internal Error violated structure of AST 'a_Child > a_Non_Order'  (77da61d2_daeeffca)\n";
                }


                my $dup_iter_target = $iter_target->Duplicate();
                $dup_iter_target -> MoveUp();
                $dup_iter_target -> MoveDown();

                my $frame_top = pop @{ $context->{non_order_matched_siblings_flame_stack} };

                if ($context->{next_node_child_level} == 0 && defined $context->{next_node_capture_list})
                {
                    my $i = 0;
                    while (! $dup_iter_target->IsEnd())
                    {
                        if (!(exists $frame_top->{$i} && $frame_top->{$i}))
                        {
                            push (@{ $context->{next_node_capture_list} },
                                MatchCapturePlace->newByIterator( $dup_iter_target , $context->{root_capture})
                            );
                        }
                        $i++;

                        $dup_iter_target->MoveNextSibling();

                    }
                }
                if ($context->{next_node_child_level} > 0)
                {
                    $context->{next_node_child_level} --;
                }

                $iter_pat->MoveUp(); # a_Child に up してしまう。
                $iter_target->MoveUp();
                $iter_target->MoveNextSibling();
            }

            $iter_pat->MoveNextSibling();
            next;
        }

        my $node_id = $iter_pat->Node()->Attr0;

        if ($node_id eq 'a_Node')
        {
            if ($iter_pat->Node()->GetAttribute('ordered'))
            {
                # 順番ありのノード
                # ax_Non_Order_Node_Do_Match_Single と一部重複
                #

                # ノードがマッチするかチェックして
                my $result = aux_TreeMatch_match_single_node($context);

                # マッチしなければバックトラック
                #     バックトラックするものが無ければ return FALSE
                # マッチしたら
                #     ast を a_Child に MoveDown (3番目)jして
                #     a_Child が空なら
                #         next_captures をセットして
                #         ast を UP し MovNext
                #     a_Child が空でなければ
                #         パターンが '$'か'_' ならエラー(die)
                #         target を MoveDown して子要素の探索に進む
                if (! $result)
                {
                    # マッチしなかったのでバックトラック
                    # バックトラックするものが無ければ return FALSE
                    if (@{ $context->{backtrack_stack} } == 0) { return 0; }

                    aux_TreeMatch_do_backtrack($context);

                    # print "!!! BACKTRACK !!!\n";
                    #         $context->{iter_pattern_ast}->Tree()->TreePrint();
                    #         $context->{iter_target_tree}->Tree()->TreePrint();

                    next;
                }

                # 単一ノードのマッチに成功した場合 (子要素のマッチに進む)
                #
                # (ただし end ($: 幅0 マッチ) だった場合は
                #    パターンの次の要素に進める。
                #    (ターゲットの子要素は見れないはずなので。
                if ($iter_pat->Node()->GetAttribute('node_type') eq 'end')
                {
                    $iter_pat->MoveNextSibling();
                    next;
                }

                $iter_pat->MoveDown();
                # 1番目の子 = a_Attr_Cond_List
                if ($iter_pat->Node()->Attr0 ne 'a_Attr_Cond_List')
                { confess "Error: internal error (c9b1fe13_fe0d0288)\n"; }

                $iter_pat->MoveNextSibling();
                # 2番目の子 = a_Place_List
                if ($iter_pat->Node()->Attr0 ne 'a_Place_List')
                { confess "Error: internal error (86041b5e_963b0222)\n"; }

                $iter_pat->MoveNextSibling();
                # 3番目の子 = a_Child
                if ($iter_pat->Node()->Attr0 ne 'a_Child')
                { confess "Error: internal error (90ef8bd1_67a1417a)\n"; }


                # 対象木を子に移す
                $iter_target->MoveDown();

                # そして 子の a_Child から パターン木の探索を続ける
                # 親にもどるのは Up 時に a_Child をチェックして行う
                next;
            }
            else
            {
                # 順不動のノード 'a_Node' {ordered==0}

                # 'ax_Non_Order_Do_Match_Single' の処理時も
                #     ほぼ同じ

                #   Target を Up Down して先頭に巻き戻す

                $iter_target->MoveUp();
                $iter_target->MoveDown();

                #   パターンAST実行時ノードとして
                #   ax_Non_Order_Node_Next{cancelled=0, link_to_node_pat} を作り
                #       BackTrack Stack に積んだ ターゲットIterator をNextSiblingして
                #       BackTrack Stack に積んだ パターンIterator をそれに ForceDown しておく。
                #       (ただし最後のノードなら、次は積まない)
                #
                #     ax_Non_Order_Node_Do_Match_Single を作りメインのパターンイテレータを ForceDown(ax_Non_Order_Node_Do_Match_Single)する
                #         ただし、ax_Non_Order_Node_Do_Match_Single は a_Node{ordered==0} のほぼコピー
                #            + cancel_link を足したもの

                my $n_siblings = $iter_target->_top()->{sibling_num};

                if ($n_siblings == 0)
                {
                    # マッチするノードが無い
                    aux_TreeMatch_do_backtrack($context);
                    next;
                }
                else
                {
                    # else(順不動の a_Node) はここから

                    # ax_Non_Order_Node_Do_Match_Single にもほぼ同様の
                    #     内容


                    # ターゲットの兄弟が 1 or 2以上
                    my $pat_tree_class = $iter_pat->Node()->TreeClass();
                    my $pat_node_class = $iter_pat->Node()->NodeClass();

                    my $ax_node_single = $pat_node_class->new(
                            { %{$iter_pat->Node()->{attr}} }, # copy
                            $iter_pat->Node()->ChildNodeList()
                        );
                    $ax_node_single->SetPrimaryAttribute0('ax_Non_Order_Node_Do_Match_Single');
                    $ax_node_single->SetAttribute('cancel_link', undef);

                    # ターゲットの兄弟 2以上ならバックトラック対象を追加
                    if ($n_siblings >= 2 )
                    {
                        my $dup_iter_pat = $iter_pat->Duplicate();
                        my $dup_iter_target = $iter_target->Duplicate();

                        $dup_iter_target->MoveNextSibling();


                        my $ax_next = $pat_node_class->new( { cancelled => 0, a_node_pat_node => $iter_pat->Node() } );
                        $ax_next->SetPrimaryAttribute0('ax_Non_Order_Node_Next');
                        $ax_node_single->SetAttribute('cancel_link', $ax_next);

                        $dup_iter_pat->MoveDownForce($pat_tree_class->newByRootNode($ax_next));
                        aux_TreeMatch_push_backtrack_stack($context, $dup_iter_pat, $dup_iter_target);
                    }


                    $iter_pat->MoveDownForce($pat_tree_class->newByRootNode($ax_node_single));
                    $iter_pat->OnUpDo(
                        sub
                        {
                        # (2.5) MoveUp したらax_Non_Order_Node_Do_Match_Single
                        #      だったときマッチに成功したので、
                        #     cancel_link の先の ax_NonOrder_Node_Next の
                        #     {cancelled} をセットする   (枝切り)
                        #
                        #     Non_Order_Siblings フレームの候補にマッチ済みのマークをする
                        #     この実行時ASTノードに兄弟はいない(一応確認する)ので、さらに Up->Next する
                            if (defined $ax_node_single->{cancel_link})
                            {
                                $ax_node_single->{cancel_link}->{cancelled} = 1;
                            }

                            # (a_Node >) ax_Non_Order_Do_Match_Single
                            #     に戻ってきたところなので、
                            # a_Node までUp して、a_Node の次を指すようにする

                            $iter_pat->MoveUp();
                            # (ここはなにもしない。)
                        }
                    );

                }

                next;
                # else(順不動の a_Node) はここまで
            }
            # ここには到達しない ( if: next, else: next なので )
        }
        if ($node_id eq 'a_Non_Order')
        {
            # まだマッチした兄弟ノードは無いので、空の ハッシュを追加
            push @{ $context->{non_order_matched_siblings_flame_stack} }, {};
            $iter_pat->MoveDown();
            next;
        }
        if ($node_id eq 'ax_Non_Order_Node_Next')
        {
            # 順不動の a_Node と重複
            if ($iter_pat->Node()->GetAttribute('cancelled'))
            {
                # (2.3) ax_Non_Order_Node_Next{cancelled==1} に入ったら
                #     Fail and backtrack (過去にマッチして進んだものと同じ結果となるはず)
                aux_TreeMatch_do_backtrack($context);
                next;
            }


            # (2.2) ax_Non_Order_Node_Next{cancelled==0} に入ったら
            # (つまりSingleNodeMatch が否定されてバックトラックした直後)
            #     パターンAST実行時ノードとして
            #     ax_Non_Order_Node_Next{cancelled=0, a_node_pt_node} を作り
            #         BackTrack Stack に積んだ ターゲットIterator をNextSiblingして
            #         BackTrack Stack に積んだ パターンIterator を(Next はせずにい Node_Next が最上位のままにする。
            #         (ただし最後のノードなら、次は積まない)


            my $pat_tree_class = $iter_pat->Node()->TreeClass();
            my $pat_node_class = $iter_pat->Node()->NodeClass();

            my $a_node_pat_node = $iter_pat->Node()->GetAttribute('a_node_pat_node');

            my $ax_node_single = $pat_node_class->new(
                    { %{$a_node_pat_node->{attr}} }, # copy
                    $a_node_pat_node->ChildNodeList()
                );
            $ax_node_single->SetPrimaryAttribute0('ax_Non_Order_Node_Do_Match_Single');
            $ax_node_single->SetAttribute('cancel_link', undef);

            if ($iter_target->_top()->{sibling_num} - $iter_target->_top()->{sibling_index} > 1)
            {
                # 最後の候補ノードではないとき
                #     バックトラックに積む
                # 最後の候補ノードでは積まない。


                my $dup_iter_pat = $iter_pat->Duplicate();
                my $dup_iter_target = $iter_target->Duplicate();

                $dup_iter_target->MoveNextSibling();


                my $ax_next = $pat_node_class->new( { cancelled => 0, a_node_pat_node => $a_node_pat_node} );
                $ax_next->SetPrimaryAttribute0('ax_Non_Order_Node_Next');
                $ax_node_single->SetAttribute('cancel_link', $ax_next);

                $dup_iter_pat->MoveDownForce($pat_tree_class->newByRootNode($ax_next));
                aux_TreeMatch_push_backtrack_stack($context, $dup_iter_pat, $dup_iter_target);
            }


            $iter_pat->MoveDownForce($pat_tree_class->newByRootNode($ax_node_single));
            $iter_pat->OnUpDo(
                sub
                {
                # (2.5) MoveUp したらax_Non_Order_Node_Do_Match_Single
                #      だったときマッチに成功したので、
                #     cancel_link の先の ax_NonOrder_Node_Next の
                #     {cancelled} をセットする   (枝切り)
                #
                #     Non_Order_Siblings フレームの候補にマッチ済みのマークをする
                #     この実行時ASTノードに兄弟はいない(一応確認する)ので、さらに Up->Next する
                    if (defined $ax_node_single->{cancel_link})
                    {
                        $ax_node_single->{cancel_link}->{cancelled} = 1;
                    }

                    # (a_Node >) ax_Non_Order_Do_Match_Single
                    #     に戻ってきたところなので、
                    # a_Node までUp して、a_Node の次を指すようにする

                    $iter_pat->MoveUp();
                    # (ここはなにもしない。)
                }
            );

            next;
        }
        if ($node_id eq 'ax_Non_Order_Node_Do_Match_Single')
        {
            # a_Node {順序あり}と一部重複している

                # ノードがマッチするかチェックして
                my $result = aux_TreeMatch_match_single_node($context);

                # マッチしなければバックトラック
                #     バックトラックするものが無ければ return FALSE
                # マッチしたら
                #     ast を a_Child に MoveDown (3番目)jして
                #     a_Child が空なら
                #         next_captures をセットして
                #         ast を UP し MovNext
                #     a_Child が空でなければ
                #         パターンが '$'か'_' ならエラー(die)
                #         target を MoveDown して子要素の探索に進む
                if (! $result)
                {
                    # マッチしなかったのでバックトラック
                    # バックトラックするものが無ければ return FALSE
                    if (@{ $context->{backtrack_stack} } == 0) { return 0; }

                    aux_TreeMatch_do_backtrack($context);

                    # print "!!! BACKTRACK !!!\n";
                    #         $context->{iter_pattern_ast}->Tree()->TreePrint();
                    #         $context->{iter_target_tree}->Tree()->TreePrint();

                    next;
                }

                # 単一ノードのマッチに成功した場合 (子要素のマッチに進む)
                #
                # (ただし end ($: 幅0 マッチ) だった場合は
                #    パターンの次の要素に進める。
                #    (ターゲットの子要素は見れないはずなので。
                if ($iter_pat->Node()->GetAttribute('node_type') eq 'end')
                {
                    $iter_pat->MoveNextSibling();
                    next;
                }

                $iter_pat->MoveDown();
                # 1番目の子 = a_Attr_Cond_List
                if ($iter_pat->Node()->Attr0 ne 'a_Attr_Cond_List')
                { confess "Error: internal error (c9b1fe13_fe0d0288)\n"; }

                $iter_pat->MoveNextSibling();
                # 2番目の子 = a_Place_List
                if ($iter_pat->Node()->Attr0 ne 'a_Place_List')
                { confess "Error: internal error (86041b5e_963b0222)\n"; }

                $iter_pat->MoveNextSibling();
                # 3番目の子 = a_Child
                if ($iter_pat->Node()->Attr0 ne 'a_Child')
                { confess "Error: internal error (90ef8bd1_67a1417a)\n"; }


                # 対象木を子に移す
                $iter_target->MoveDown();

                # そして 子の a_Child から パターン木の探索を続ける
                # 親にもどるのは Up 時に a_Child をチェックして行う
            next;
        }
        # if ($node_id eq 'ax_Non_Order_Node_Do_Match_Single')
        # {
        #     ###これは、a_Node の直下に書く
        #     next;
        # }

        if ($node_id eq 'a_P_Or')
        {
            my $or_node = $iter_pat->Node();
            my $n_or = $or_node->NumChildren();

            if ($n_or == 0)
            { confess "Error: internal error (d5efc593_d47cf72f)\n"; }
            if ($n_or == 1)
            {
                # 「p_Or の下」に MoveDownForce する
                $iter_pat->MoveDownForce( $or_node->NthChildSubtree(0) );
                next;
            }

            # $n >=2 のとき
            #
            # (p_Or > (2番目以降の子...) ) を作ってバックトラックに積む
            # 「p_Or の1番目の子」に MoveDownForce する
            my $or_head_subtree = $or_node->NthChildSubtree(0);

            # バックトラック用の subtree を作成
            my @or_tail_nodes = ();
            # 先頭を除外した繰り返し
            for (my $i=1; $i<$n_or; $i++)
            {
                push @or_tail_nodes, $or_node->NthChildNode($i);
            }

            my $new_or_node = $or_node->NodeClass()->new({}, @or_tail_nodes);
            $new_or_node->SetPrimaryAttribute0('a_P_Or');
            my $new_or_tree =  $or_node->TreeClass()->newByRootNode($new_or_node);

            # バックトラック用のイテレータを作成し、バックトラックスタックにpush
            my $iter_pat_backtrack = $iter_pat->Duplicate();
            my $iter_target_backtrack = $iter_target->Duplicate();

            $iter_pat_backtrack->MoveDownForce($new_or_tree);

            # print "!!! BACKTRACK_PUSH !!!\n";
            #         $iter_pat_backtrack->Tree()->TreePrint();
            #         $iter_target_backtrack->Tree()->TreePrint();

            aux_TreeMatch_push_backtrack_stack($context, $iter_pat_backtrack, $iter_target_backtrack);

            # パターンAST の OR の一番目の子要素で探索を続ける。

            $iter_pat->MoveDownForce($or_head_subtree);

            # print "!!! (BACKTRACK) GO WITH !!!\n";
            #         $iter_pat->Tree()->TreePrint();

            next;
        }
        if ($node_id eq 'a_Rep0' || $node_id eq 'a_Rep1' )
        {
            my $rep_node = $iter_pat->Node();
            if ($rep_node->NumChildren() != 1)
            {
                confess "Error: internal error (repeat node must has exact one children) (6c108dd7_53125189)\n";
            }
            # rep0 longest なら
            #     or(seq(child, rep0), empty_seq )
            # rep0 shortest なら
            #     or(empty_seq, seq(child, rep0S))
            # rep1 longest なら
            #     seq (child, rep0L) )
            # rep1 shortest なら
            #     seq (child, rep0S)
            # にそれぞれ ForceDown する

            my $ast_node_class = $rep_node->NodeClass();
            my $ast_tree_class = $rep_node->TreeClass();

            my $rep_child = $rep_node->NthChildNode(0);
            
            if ($node_id eq 'a_Rep0')
            {
                # create seq(child, rep0) / seq(child, rep0S)
                my $seq_node = $ast_node_class->new({}, $rep_child, $rep_node);
                $seq_node->SetPrimaryAttribute0('a_Seq');

                # create empty_seq
                my $empty_seq_node = $ast_node_class->new({}); # no child
                $empty_seq_node->SetPrimaryAttribute0('a_Seq');

                my $or_node;
                if ($rep_node->GetAttribute('shortest'))
                {
                    # rep0 shortest:    or(empty_seq, seq(child, rep0S))
                    $or_node = $ast_node_class->new({}, $empty_seq_node, $seq_node);
                    $or_node->SetPrimaryAttribute0('a_P_Or');
                }
                else
                {
                    # Rep0 longest:    or(seq(child, rep0), empty_seq )
                    $or_node = $ast_node_class->new({}, $seq_node, $empty_seq_node);
                    $or_node->SetPrimaryAttribute0('a_P_Or');
                }
                $iter_pat->MoveDownForce($ast_tree_class->newByRootNode($or_node));
            }
            else
            {
                # in case $node_id eq 'a_Rep1'
                #     rep1 longest なら    seq (child, rep0L) )
                #     rep1 shortest なら   seq (child, rep0S)
                # create rep0L / rep0S
                my $rep0_node = $ast_node_class->new({}, $rep_child);
                $rep0_node->SetPrimaryAttribute0('a_Rep0');
                $rep0_node->SetAttribute('shortest', $rep_node->GetAttribute('shortest'));
                my $seq_node = $ast_node_class->new({}, $rep_child, $rep0_node);
                $seq_node->SetPrimaryAttribute0('a_Seq');
                $iter_pat->MoveDownForce($ast_tree_class->newByRootNode($seq_node));
            }
            next;
        }
        if ($node_id eq 'a_Rec_Ref')
        {
            # TODO: TODO :
            #     PatAST で a_RecRef の空の子要素が
            #     (誤って)生成されているようなので、
            #     Lex を修正しないといけない。
            #     (Sample35 には他のエラーもある)
            #     
            #     TreeConstruct で $ が入ってきたときのエラーが不適切
            #

            # 参照ブロックの番号(何個外のブロックか)を取り出す
 
            my $num_orig = $iter_pat->Node()->GetAttribute('num');
            my $num = $num_orig;
            if ($num <= 0)
            {
                confess "Error: (?-$num_orig): N of (?-N) (num of a_Rec_Rec) must not be zero   (e61e4ec5_c2d7a6d8)\n";
            }
            # print "[a_RecRef ->{num} = $num]\n";

            # 再帰参照ブロックの 部分木を探す
            # @{ $iter_pat->{iter_stack} } の先頭がRoot, 末尾が今の a_Rec_Ref
            my $ref_subtree = undef;
            for (my $i = @{ $iter_pat->{iter_stack} } - 2; $i >=0; $i--)
            {
                # print "  <$i / $num>\n";
                my $cur = $iter_pat->{iter_stack}->[$i]->{tree};
                if ($cur->GetRootNode()->Attr0() eq 'a_Block') { $num--; }
                if ($num == 0)
                {
                    $ref_subtree = $cur;
                    last;
                }
            }
            if (!defined $ref_subtree)
            {
                confess "Error: no ref block for (?-$num_orig) (609ffb07_7660c0fd)\n";
            }
            $iter_pat->MoveDownForce($ref_subtree);

            next;
        }
        if ($node_id eq 'a_Child'
            || $node_id eq 'a_Tree_Pat'
            # || $node_id eq 'a_Root'    # path パターンを分離したので不要に
            || $node_id eq 'a_Seq'
            || $node_id eq 'a_Block'
        )
        {
            $iter_pat->MoveDown();
            next;
        }

        confess "Error: not implemented (node_id = $node_id) (1a97f567_50bc11d6)\n";
    }
    confess "Error: internal error (96076321_3246bbf0)\n";
}
sub aux_TreeMatch_match_single_node
{
    my ($context) = @_;
    # 返り値 マッチ:1 / マッチせず:0
    # キャプチャの追加まではする。

    my $iter_pat = $context->{iter_pattern_ast};
    my $iter_target = $context->{iter_target_tree};

    my $pat_node = $iter_pat->Node();

    if ( $pat_node->Attr0 ne 'a_Node' && $pat_node->Attr0 ne 'ax_Non_Order_Node_Do_Match_Single')
    { confess "Error: internal error (" . $pat_node->Attr0 . ") (79d836bf_12406453)\n"; }

    my $neg = $pat_node->GetAttribute('neg');
    my $match_failed = 0; # 失敗したら 1 (neg が真ならあとで反転する)

    my $pat_node_type = $pat_node->GetAttribute('node_type');

    if ($pat_node_type eq 'end')
    {
        if (! $iter_target->IsEnd()) { $match_failed = 1; }
        # confess "Error: ?? (8f8ebd83_cb1bb4b4)\n";
    }
    elsif ($iter_target->IsEnd())
    {
        # none/any/id/id_regexp なのに IsEnd ならマッチせず
        # ここでは常にマッチせず
        # そして、処理するノードが無いので、neg でも失敗し、
        # exclude もキャプチャもできないので、即時 return する。
        # $match_failed = 1;
        return 0;
    }
    elsif ($pat_node_type eq 'none')
    {
        my $target_node = $iter_target->Node();
        if (defined $target_node) { $match_failed = 1; }
    }
    elsif ($pat_node_type eq 'any')
    {
        # 兄弟の終端ではないことは保証されているので常にマッチする
        # match!
    }
    elsif ($pat_node_type eq 'id')
    {
        # 兄弟の終端ではないことは保証されている
        my $target_node = $iter_target->Node();

        if (!defined $target_node) { $match_failed = 1; }
        elsif (!defined $target_node->Attr0) { $match_failed = 1; }
        elsif ($target_node->Attr0 ne $pat_node->Attr1) { $match_failed = 1; }
    }
    elsif ($pat_node_type eq 'id_regexp')
    {
        my $target_node = $iter_target->Node();

        if (!defined $target_node) { $match_failed = 1; }
        elsif (!defined $target_node->Attr0) { $match_failed = 1; }
        else
        {
            my $pat_str = $pat_node->Attr1();

            if ($pat_node->GetAttribute('option_str') ne '')
            { confess "Error: not yet implemented (option of regexp node) (1778c0c6_1eb8c8d6)\n"; }

            my $match_re = eval {$target_node->Attr0() =~ /$pat_str/;};
            if ($@)
            {
                # エラーで強制終了(throw)
                confess "Error: wrong RegExp pattern /$pat_str/ ($@) (e13e3cc6_ddb9bd79)\n";
            }
            else
            {
                if (! $match_re) { $match_failed = 1; }
                else { } # match!!
            }
        }
    }
    else
    { confess "Error:  internal error (pat_node_type = $pat_node_type) (083785d8_c02c205a)\n"; }


    # 2. 属性のチェック
    if (!$match_failed)
    {
        # ここまででマッチしていないことが確定している場合は属性のチェックをスキップする
        if ($pat_node_type ne 'end' && defined $iter_target->Node())
        {

            # end には属性がないはずなので end の場合はスキップする
            # end でなくここまででマッチしていれば、IsEnd ではない。
            # だがノードが空(undef/null) の場合はスキップする
            my $a_attr_cond_list_node = aux_attr0_child($iter_pat->Tree(), 'a_Attr_Cond_List', 0)->GetRootNode();
            for my $attr_cond_node ( $a_attr_cond_list_node->ChildNodeList() )
            {
                #    $attr_cond_node :
                #        {key_type} sec/other
                #        {match_type} str/regexp
                #        {val} Attr1
                #        {key_val}
                my $key_type = $attr_cond_node->GetAttribute('key_type');
                my $match_type = $attr_cond_node->GetAttribute('match_type');
                my $val = $attr_cond_node->GetPrimaryAttribute1(); # val


                my $target_val = undef;
                if ($key_type eq 'sec')
                {
                    $target_val = $iter_target->Node()->GetPrimaryAttribute1();
                }
                elsif ($key_type eq 'other')
                {
                    my $key_val = $attr_cond_node->GetAttribute('key_val');
                    if (!defined $key_val)
                    { confess "Error: internal error (c4ab0bd1_72026642)\n"; }

                    $target_val = $iter_target->Node()->GetAttribute($key_val);
                }
                else
                { confess "Error: internal error (86f76a74_7c2a3b3c)\n"; }



                if (!defined $match_type)
                { confess "Error: internal error (fe833894_21fd24aa)\n"; }

                if (!defined $val)
                { confess "Error: internal error (15dd0b4a_5aa64f16)\n"; }


                if ( $match_type eq 'str' )
                {
                    if (!defined $target_val) {$match_failed = 1; last; }
                    if ($target_val ne $val) {$match_failed = 1; last; }
                }
                elsif ( $match_type eq 'regexp' )
                {
                    if (!defined $target_val) {$match_failed = 1; last; }

                    if ($attr_cond_node->GetAttribute('option_str') ne '')
                    { confess "Error: not yet implemented (option of regexp attribute match) (ce85534b_da2560b2)\n"; }

                    my $pat_str = $val;
                    my $match_re = eval {$target_val =~ /$pat_str/;};
                    if ($@)
                    {
                        # エラーで強制終了(throw)
                        confess "Error: wrong RegExp pattern /$pat_str/ ($@) (ecf18fcd_01693345)\n";
                    }
                    else
                    {
                        if (! $match_re) { $match_failed = 1; last; }
                    }
                }
            }
        }
    }

    # 3. キャプチャの生成

    my $a_place_list_node = aux_attr0_child($iter_pat->Tree(), 'a_Place_List', 1)->GetRootNode();
    $a_place_list_node->ForEachChildNodes(sub {
        my ($place_node) = @_;
        my $place_type = $place_node->Attr0();
        my $place_name = $place_node->Attr1();

        if ($place_type eq 'a_Single_Place')
        {
            push @{ $context->{single_capture_list} }, {
                name => $place_name,
                capture => MatchCapturePlace->newByIterator( $iter_target, $context->{root_capture} )
            };
        }
        elsif ($place_type eq 'a_Multi_Place')
        {
            push @{ $context->{multi_capture_list} }, {
                name => $place_name,
                capture => MatchCapturePlace->newByIterator( $iter_target, $context->{root_capture} )
            };
        }
        else
        {
            confess "Error: internal error (place_type = $place_type) (baf31943_77ead180)\n";
        }
    } );

    # 4. next node の追加は、このノードだけやって、
    # 子/末弟については たぶん Up に任せれば OK

    if ($pat_node_type ne 'end')
    {
        # end (幅0マッチ) の場合はなにもしない

        if ($context->{next_node_child_level} == 0)
        {
            if ($iter_pat->Node()->GetAttribute('ordered'))
            {
                if ($iter_pat->Node()->GetAttribute('exclude_mached'))
                {
                    if (defined $context->{next_node_capture_list})
                    {
                        push (@{ $context->{next_node_capture_list} },
                            MatchCapturePlace->newByIterator( $iter_target, $context->{root_capture} )
                        );
                    }
                    $context->{next_node_child_level} ++;
                }
            }
            else
            {
                # 順序なしの場合
                if (! $iter_pat->Node()->GetAttribute('exclude_mached'))
                {
                    my $ra_matched_stack = $context->{non_order_matched_siblings_flame_stack};
                    $ra_matched_stack->[@$ra_matched_stack - 1]->{$iter_target->_top()->{sibling_index} } = 1;

                }
                else
                {
                    $context->{next_node_child_level} ++;
                }
            }
        }
        else
        {
                $context->{next_node_child_level} ++;
        }
    }

    if (!$match_failed) { return $neg ? 0 : 1; } # マッチしていた場合
    else  { return $neg ? 1 : 0; } # マッチに失敗した場合
}
sub aux_TreeMatch_push_backtrack_stack
{
    my ($context, $iter_pat_copy, $iter_target_copy) = @_;
    if(!exists $context->{iter_pattern_ast}
        || !defined($iter_pat_copy) || !defined($iter_target_copy))
    { confess "Error: internal error (wrong argument) (41017456_7d341182)\n"; }

    my $next_node_capture_list_length = undef;
    if (defined $context->{next_node_capture_list})
    {
        $next_node_capture_list_length = scalar @{ $context->{next_node_capture_list} };
    }

    my $entry = {
        iter_pattern_ast => $iter_pat_copy,
        iter_target_tree => $iter_target_copy,

        next_node_capture_list_trim_length
            => $next_node_capture_list_length,
        next_node_child_level => $context->{next_node_child_level},
        single_capture_list_trim_length
            => scalar @{ $context->{single_capture_list} },
        multi_capture_list_trim_length
            => scalar @{ $context->{multi_capture_list} },

        non_order_matched_siblings_flame_stack =>
            [map { my $ret = {%$_}; $ret; } @{ $context->{non_order_matched_siblings_flame_stack}}],
        below_neg_node => $context->{below_neg_node},
    };
    push @{ $context->{backtrack_stack} }, $entry;
}
sub aux_TreeMatch_do_backtrack
{
    my ($context) = @_;
     if (@{ $context->{backtrack_stack}} == 0)
     { confess "Error: internal error (5b592053_5eb2cc1c)\n"; }

    my $entry = pop @{ $context->{backtrack_stack}};

    $context->{iter_pattern_ast} = $entry->{iter_pattern_ast};
    $context->{iter_target_tree} = $entry->{iter_target_tree};

    if (defined $context->{next_node_capture_list})
    {
        splice @{ $context->{next_node_capture_list} },
            $entry->{next_node_capture_list_trim_length};
    }
    $context->{next_node_child_level} = $entry->{next_node_child_level};

    splice @{ $context->{single_capture_list} },
        $entry->{single_capture_list_trim_length};
    splice @{ $context->{multi_capture_list} },
        $entry->{multi_capture_list_trim_length};

    $context->{non_order_matched_siblings_flame_stack} = $entry->{non_order_matched_siblings_flame_stack};
    $context->{below_neg_node} = $entry->{below_neg_node};
}

sub TreeMatchFind
{
    my ($tree, $pattern) = @_;

    if (!defined $pattern)
    {
        confess "Error: called with wrong type parameter (TreeMatchFind(tree, pattern)) (05ffb745_72467f92)\n";
    }


    my @results = ();
    my $result;
    my @next_capture_list = ();

    my @next_capture_list_add = ();
    my $base_root_capture = undef;

    while(1)
    {
        $result = TreeMatch($tree, $pattern, $base_root_capture, \@next_capture_list_add);
        if ($result) { push @results, $result; }
        my $n = @next_capture_list_add;
        for (my $i = $n - 1; $i >=0; $i--)
        {
            push @next_capture_list, $next_capture_list_add[$i];
        }
        @next_capture_list_add = ();
        if (@next_capture_list == 0) { last; }
        $base_root_capture = pop @next_capture_list;
        $tree = $base_root_capture->Tree();
    }
    return @results;
}

sub TreeIfMatchDo
{
    my ($tree, @entries) = @_;
    # @entries: [{pattern=>'pattern1', pre=>\&ref_func_pre1, post=>\&ref_func_post1}...]
    #     pre: $result, $ra_next_captures --> $cancel_match
    #     post: $result, $ra_next_captures --> void

    confess "Error: not yet implemented (b449cd6d_3291b4c5)\n";
}

package TreeMatchLibSrc;

# 暫定的に違うファイル名でも Export されるようにしておく
sub import
{
    my $pkg = shift;
    my $callpkg = caller(0);
    TreeMatchLib->force_import($callpkg);
    #     no strict 'refs';
    #     for my $sym ( qw/ TreeConstruct TreeMatch TreeMatchFind TreeIfMatchDo /)
    #     {
    #         # *{"${callpkg}::$sym"} = \&{"${pkg}::$sym"};
    #         *{"${callpkg}::$sym"} = \&{"TreeMatchLib::$sym"};
    #     }
}

# end of package

1;




