use strict;
use warnings;
# TreeWrapper1;
#
# 変換用一時 VIMCMD(1): let @/ = "\\<" . @* .  "\\>" | normal n
#

# parserGen\emit_helper_functions\emit_helper2.pl
# と parserGen\aa_tree_gen の結果を少し取り込む
#    できて、TreePrint を作ったので、テストコードを書く


###############################################################
package TreeWrapperBase::NodeBox;

use Carp;
use MyAssertType;

sub NodeClass { 'TreeWrapperBase::Node'    };
sub BoxClass  { 'TreeWrapperBase::NodeBox' };
sub TreeClass { 'TreeWrapperBase'    };

sub newByNode
{
    my $class= shift;
    my ($node) = @_;  # undef を許容する
    MyAssertArgNum(1,1,scalar (@_));

    MyAssertClass($class->NodeClass(), $node) if defined $node;

    return bless {node => $node}, $class;
}

sub GetNode
{
    my $self = shift @_;
    my $return_node = $self->{node};
    MyAssertClass($self->NodeClass(), $return_node, 'return node')
        if defined $return_node;

    return $return_node;
}
sub SetNode
{
    # arg: node or undef
    # return: detached node

    my ($self, $arg_node) = @_;
    my $detached_node = $self->GetNode();
    # MyAssertClass($nodeclass, $detached_node, 'detached node')
    #     if defined $detached_node;
    MyAssertClass($self->NodeClass(), $arg_node, 'arg node')
        if defined $arg_node;

    $self->{node} = $arg_node;
    return $detached_node;
}

###############################################################
package TreeWrapperBase::Node;

use Carp;
use MyAssertType;

sub NodeClass { 'TreeWrapperBase::Node'    };
sub BoxClass  { 'TreeWrapperBase::NodeBox' };
sub TreeClass { 'TreeWrapperBase'    };

sub GetPrimaryAttributeKey0 { return '__key0'; }
sub GetPrimaryAttributeKey1 { return '__key1'; }
sub IsPrimaryAttributeKey
{ my ($self, $k) = @_; return $k =~ /^\A(__key0|__key1)\z/; }


sub new
{
    my $class = shift @_;
    my $attr = shift @_;
    my @child_nodes = @_;

    MyAssertDataType('HASH', $attr, 'arg attr');

    for my $node(@child_nodes)
    {
        MyAssertClass($class->NodeClass(), $node, 'arg node')
            if defined $node;
    }

    my $actual_boxclass = $class->BoxClass();
    my @child_boxes = map {$actual_boxclass->newByNode($_);} @child_nodes;

    my $self = {attr => $attr, child_boxes=>\@child_boxes} ;
    return bless $self, $class;
}
sub GetAttribute
{
    my $self = shift @_;
    my ($key) = @_;
    MyAssertCondition(defined $key, "key must be defined. (key = (undef) )");
    MyAssertCondition('' eq ref $key, "key can't be reference but string. (key = $key )");
    if(!exists $self->{attr}->{$key}) {return undef;}
    return $self->{attr}->{$key};
}
sub SetAttribute
{
    my $self = shift @_;
    my ($key, $value) = @_;
    MyAssertCondition(defined $key, "key must be defined. (key = (undef) )");
    MyAssertCondition('' eq ref $key, "key can't be reference but string. (key = $key )");
    $self->{attr}->{$key} = $value;
}
sub HasAttribute
{
    my $self = shift @_;
    my ($key) = @_;
    MyAssertCondition(defined $key, "key must be defined. (key = (undef) )");
    MyAssertCondition('' eq ref $key, "key can't be reference but string. (key = $key )");
    return exists $self->{attr}->{$key};
}
sub DeleteAttribute
{
    my $self = shift @_;
    my ($key, $value) = @_;
    MyAssertCondition(defined $key, "key must be defined. (key = (undef) )");
    MyAssertCondition('' eq ref $key, "key can't be reference but string. (key = $key )");
    if(exists $self->{attr}->{$key}) { delete $self->{attr}->{$key}; }
}
sub AttributeKeys
{
    my $self = shift @_;
    return keys %{$self->{attr}};
}
sub AttributeKeysNonPrimary
{
    my $self = shift @_;
    return grep {!$self->IsPrimaryAttributeKey($_)} $self->AttributeKeys();
}
sub GetPrimaryAttribute0
{
    my $self = shift @_;
    my $key = $self->GetPrimaryAttributeKey0;
    return $self->GetAttribute($key);
}
sub SetPrimaryAttribute0
{
    my $self = shift @_;
    my ($val) = @_;
    my $key = $self->GetPrimaryAttributeKey0;
    $self->SetAttribute($key, $val);
    return;
}
sub Attr0
{
    my $self = shift @_;
    my $key = $self->GetPrimaryAttributeKey0;
    return $self->GetAttribute($key);
}
sub GetPrimaryAttribute1
{
    my $self = shift @_;
    my $key = $self->GetPrimaryAttributeKey1;
    return $self->GetAttribute($key);
}
sub SetPrimaryAttribute1
{
    my $self = shift @_;
    my ($val) = @_;
    my $key = $self->GetPrimaryAttributeKey1;
    $self->SetAttribute($key, $val);
    return;
}
sub Attr1
{
    my $self = shift @_;
    my $key = $self->GetPrimaryAttributeKey1;
    return $self->GetAttribute($key);
}
sub NumChildren
{
    my $self = shift @_;
    my $n = @{$self->{child_boxes}};
    return $n;
}
sub ChildrenKeys
{
    my $self = shift @_;
    return keys @{$self->{child_boxes}};
}
sub NthChildNode
{
    my $self = shift @_;
    my ($n) = @_;

    MyAssertCondition(((defined $n) and ($n >= 0 or $n < $self->NumChildren())), "index range error at NthChildNode($n)). NumChildren is ". $self->NumChildren(). ".");

    # Perl 以外では違う形になるか
    return $self->{child_boxes}->[$n]->GetNode();
}
sub NthChildBox
{
    my $self = shift @_;
    my ($n) = @_;
    MyAssertCondition(((defined $n) and ($n >= 0 or $n < $self->NumChildren())), "index range error at NthChildBox($n)). NumChildren is ". $self->NumChildren(). ".");

    # Perl 以外では違う形になるか
    return $self->{child_boxes}->[$n];
}
sub NthChildSubtree
{
    my $self = shift @_;
    my ($n) = @_;
    # MyAssertCondition((!defined $n) or $n < 0 or $n >= $self->NumChildren(), "index range error at NthChildSubtree($n)). NumChildren is ". $self->NumChildren();
    #     NthChildBox/Node/Subtree でチェックする

    return $self->TreeClass()->newByBox($self->NthChildBox($n));
}
sub ChildNodeList
{
    my $self = shift @_;
    return map { $_->GetNode(); } @{$self->{child_boxes}};
}
sub ChildSubtreeList
{
    my $self = shift @_;
    return map { $self->TreeClass()->newByBox($_); } @{$self->{child_boxes}};
}
sub ForEachChildNodes
{
    my $self = shift @_;
    my ($ref_func) = @_;
    my $i;
    for (my $i=0; $i < $self->NumChildren(); $i++)
    {
        $ref_func->($self->NthChildNode($i));
    }
}
sub ForEachChildSubtrees
{
    my $self = shift @_;
    my ($ref_func) = @_;
    my $i;
    for (my $i=0; $i < $self->NumChildren(); $i++)
    {
        $ref_func->($self->NthChildSubtree($i));
    }
}
sub SpliceChildrenNodes
{
    # returns list of nodes
    my $self = shift @_;
    if (@_ == 0) {return ();}
    if (@_ == 1)
    {
        return map{$_->GetNode();} splice(@{$self->{child_boxes}}, $_[0]);
    }
    if (@_ == 2)
    {
        return map{$_->GetNode();} splice(@{$self->{child_boxes}}, $_[0], $_[1]);
    }
    else
    {
        my $offset = shift @_;
        my $length = shift @_;

        my $actual_boxclass = $self->BoxClass();

        my @new_boxes = map {$actual_boxclass->newByNode($_);} @_;

        my @old_boxes = splice @{$self->{child_boxes}}, $offset, $length, @new_boxes;

        return map {$_->GetNode();} @old_boxes;
    }
}
sub PrependChildNodes
{
    my $self = shift @_;
    my @nodes = @_;

    for my $node(@_)
    {
        MyAssertClass($self->NodeClass(), $node, 'arg node')
            if defined $node;
    }

    $self->SpliceChildrenNodes(0, 0, @nodes);
}
sub AppendChildNodes
{
    my $self = shift @_;
    my @nodes = @_;

    for my $node(@_)
    {
        MyAssertClass($self->NodeClass(), $node, 'arg node')
            if defined $node;
    }

    my $n = $self->NumChildren();
    $self->SpliceChildrenNodes($n, 0, @nodes);
}
sub NodeSummary
{
    my $self = shift @_;
    my @kv_array = map {$_ . "=>|" . $self->GetAttribute($_) . "|" } $self->AttributeKeys();
    my $kv_string = join(', ', @kv_array);
    my $num_child = $self->NumChildren();
    return "$self(N_child=$num_child, attr=($kv_string))";
}
# # ↓返せるとは限らないから抜く
# sub ChildrenRef
# {
#     my $self = shift @_;
#     return $self->{children};
# }
# # ↓不要か?
# sub ChildrenBoxes
# {
#     my $self = shift @_;
#     return map {$self->NthChildBox($_);} $self->ChildrenKeys;
# }
# # ↓不要か?
# sub ChildrenSubtrees
# {
#     my $self = shift @_;
#     return map {$self->NthChildSubtree($_);} $self->ChildrenKeys;
# }

###############################################################
package TreeWrapperBase;

# use Exporter 'import';
# our @EXPORT = ('useNewTreeClass');
sub force_import
{
    my ($pkg, $exp_to) = @_; no strict 'refs';
    $exp_to = caller(0) if (!defined $exp_to);
    for my $sym ( qw/ useNewTreeClass /)
    {  *{"${exp_to}::$sym"} = \&{"${pkg}::$sym"};  }
    # {  *{"${exp_to}::$sym"} = \&{"TreeMatchLib::$sym"};  }
}
sub import { my $callpkg = caller(0); __PACKAGE__->force_import($callpkg); }

use Carp;
use MyAssertType;

sub NodeClass { 'TreeWrapperBase::Node'    };
sub BoxClass  { 'TreeWrapperBase::NodeBox' };
sub TreeClass { 'TreeWrapperBase'    };


sub newByRootNode
{
    my $class = shift;
    my ($root_node) = @_; # undef を許容する

    # Perl 以外では違う形になるだろう
    my $actual_nodeclass = $class->NodeClass();
    my $actual_boxclass = $class->BoxClass();
    MyAssertClass($actual_nodeclass, $root_node) if defined $root_node;

    # 継承を考慮した形にしている
    my $box = $actual_boxclass->newByNode($root_node);

    return bless {root_node_box => $box}, $class;
}

sub newByBox
{
    my $class = shift @_;
    my ($root_node_box ) = @_;

    # Perl 以外では違う形になるだろう
    my $actual_boxclass = $class->BoxClass();
    MyAssertClass($actual_boxclass, $root_node_box);

    return bless {root_node_box => $root_node_box}, $class;
}
sub GetRootNodeBox
{
    my $self = shift;
    return $self->{root_node_box};
}
sub GetRootNode
{
    my $self = shift;
    return $self->GetRootNodeBox()->GetNode();
}
sub SetRootNode
{
    my $self = shift;
    my($root_node) = @_;
    return $self->GetRootNodeBox()->SetNode($root_node);
}


sub newImportByFuncs
{
    my $class = shift;
    my ($root_node, $rf_make_attribute_hash, $rf_num_children, $rf_nth_child) = @_;
    # root_node              : node
    # rf_make_attribute_hash : node --> new_hash_ref
    # rf_num_children        : node --> n
    # rf_children            : node, n --> node

    my @iter_stack = ();
    push @iter_stack, {
        src_node     => $root_node,
        num_children => $rf_num_children->($root_node),
        dst_children => [],
    };
    my $dst_root_node;
    my $current;
    while(@iter_stack)
    {
        $current = $iter_stack[-1];
        my $n_dst_children = @{$current->{dst_children}};
        if ( $n_dst_children < $current->{num_children} )
        {
            my $child = $rf_nth_child->($current->{src_node}, $n_dst_children);
            push (@iter_stack, {
                src_node     => $child,
                num_children => $rf_num_children->($child),
                dst_children => [],
            });
        }
        else
        {

            my $rh_attr = $rf_make_attribute_hash->($current->{src_node});
            # ノードを作る (ここも継承を考慮)
            my $actual_nodeclass = $class->NodeClass();
            my $node = $actual_nodeclass->new($rh_attr, @{$current->{dst_children}});

            pop @iter_stack;

            if(@iter_stack)
            {
                my $iter_next = $iter_stack[-1];
                push @{$iter_next->{dst_children}}, $node;
            }
            else
            {
                $dst_root_node = $node;
            }
        }

    }
    # ここも継承を考慮
    return $class->newByRootNode($dst_root_node);
}

sub ExportByFuncs
{
    my $self = shift;
    my ($rf_node_from_children, $rf_finish_root) = @_;

    # rf_node_from_children : current_src_node, child_node_0 ... -> node
    # rf_finish_root        : root_node -> result_tree

    my $root_node = $self->GetRootNode();
    my @iter_stack = ();
    push @iter_stack, {
        src_node     => $root_node,
        num_children => $root_node->NumChildren(),
        dst_children => [],
    };
    my $dst_root_node;
    my $current;
    while(@iter_stack)
    {
        $current = $iter_stack[-1];
        my $n_dst_children = @{$current->{dst_children}};
        if ( $n_dst_children < $current->{num_children} )
        {
            my $child = $current->{src_node}->NthChildNode($n_dst_children);
            push (@iter_stack, {
                src_node     => $child,
                num_children => $child->NumChildren(),
                dst_children => [],
            });
        }
        else
        {
            # ノードを作る
            my $node = $rf_node_from_children->($current->{src_node}, @{$current->{dst_children}});

            pop @iter_stack;

            if(@iter_stack)
            {
                my $iter_next = $iter_stack[-1];
                push @{$iter_next->{dst_children}}, $node;
            }
            else
            {
                $dst_root_node = $node;
            }
        }

    }
    if (defined $rf_finish_root)
    {
        return $rf_finish_root->($dst_root_node);
    }
    else
    {
        return $dst_root_node;
    }
}


sub TreePrint
{
    my $self = shift;
    my ($limit_level, $rf_node_stringify, $level, $head, $head_c,$head_cc) = @_;
    if (@_ <= 2){ $level = 0;  $head = ''; $head_c = '' ; $head_cc =''; }
    if (! defined $limit_level){ $limit_level = -1; } # limit なし

    if (!defined $rf_node_stringify)
    {
        $rf_node_stringify = sub
        {
            my ($cur_node) = @_;

            my $node_str = '(undef)';
            if (defined $cur_node)
            {
                my $k_info = join ",",
                map {
                    (defined $cur_node->GetAttribute($_))
                    ?  $_ . "=" .  $cur_node->GetAttribute($_)
                    :  $_ . "=(undef)";
                }
                $cur_node->AttributeKeysNonPrimary();
                $k_info = "  {$k_info}" if $k_info ne '';

                my $v = '';
                if ( defined $cur_node->Attr1() )
                {
                    $v = "  <" . $cur_node->Attr1() . ">"
                }

                my $attr0 = '(Attr0=undef)';
                if (defined $cur_node->Attr0())
                {
                    $attr0 = $cur_node->Attr0();
                }
                $node_str = $attr0 . $v .$k_info;
            }
            return $node_str;
            # my ($node) = @_;
            # if (!defined $node) {return '(empty node)';}
            # my $a0 = $node->GetPrimaryAttribute0 // '(undef)';
            # my $a1 = $node->GetPrimaryAttribute1 // '(undef)';
            # return "$a0 / $a1";
        };
    };
    MyAssertDataType('CODE', $rf_node_stringify);


    # my $kei_u1 = { '|' => " \N{U+2502}  ", 'L' => " \N{U+2514}\N{U+2500} ",
    #     '|-' => " \N{U+251C}\N{U+2500} ", ' ' => "    ",
    #     '-' => " \N{U+2500}\N{U+2500} ", '|=' => " \N{U+255E}  " };
    # my $kei_u2 = { '|' => " \N{U+2502} ", 'L' => " \N{U+2514} ",
    #     '|-' => " \N{U+251C} ", ' ' => "    ", '-' => " \N{U+2500} ",
    #     '|=' => " \N{U+255E} " };
    # my $kei_a = { '|' => " |  ", 'L' => " +- ", '|-' => " +- ",
    #     ' ' => "    ", '-' => " -- ", '|=' => " |= " };
    my $k = { '|' => " |  ", 'L' => " +- ", '|-' => " +- ",
        ' ' => "    ", '-' => " -- ", '|=' => " |= " };

    my $root_node = $self->GetRootNode();
    my $node_str = $rf_node_stringify->($root_node);
    print $head . $head_c . $node_str . "\n";
    return if !defined $root_node;
    if ($limit_level < 0 || $level < $limit_level)
    {
        for my $i( $root_node->ChildrenKeys())
        {
            if ($i == $root_node->NumChildren() -1)
            {
                # last child
                $root_node->NthChildSubtree($i)->TreePrint($limit_level, $rf_node_stringify, $level + 1, $head.$head_cc, $k->{'L'}, $k->{' '});
            }
            else
            {
                $root_node->NthChildSubtree($i)->TreePrint($limit_level, $rf_node_stringify, $level + 1, $head.$head_cc, $k->{'|-'}, $k->{'|'});
            }
        }
    }
    else
    {
        my $n_child = $root_node->NumChildren();
        if ($n_child > 1)
        { print $head. $head_cc . $k->{'|-'} . " ...\n"; }
        elsif ($n_child == 1)
        { print $head. $head_cc . $k->{'L'}. " ...\n"; }
        # else (in case $n_child == 0) do nothing
    }
}


# # fromext_svg_tree_gen_js.js
#
# 最初 root の Down はどう呼ばれる?
sub TraverseEnterExit
{
    my $self = shift;
    my ($arg0, $enter_func, $exit_func) = @_;
    my $tree = $self;

    # enter_func: node, arg, ref_iter_stack ---> next_arg
    # exit_func:   node, enter_return_value, child_return_value_list, ref_iter_stack ---> next_arg
    my @iter_stack = ();
    push @iter_stack, {
        up_node => undef,
        node    => $tree->GetRootNode(),
        sibling_index => 0,
        sibling_num => 1,
        arg     => $arg0,
        sibling_values => []
    };
    while (1)
    {
        my $iter_top = $iter_stack[-1];
        if ($iter_top->{sibling_index} < $iter_top->{sibling_num})
        {
            # do down case

            my $next_arg = $iter_top->{arg};
            if (defined $enter_func)
            {

                $next_arg = $enter_func->($iter_top->{node}, $iter_top->{arg}, \@iter_stack);
            }
            $iter_top->{arg} = $next_arg;

            # 子がいない場合でも exit_func 発行のためダミーの子を入れておく
            my $child_num = 0;
            my $first_child_node = undef;
            if ($iter_top->{node}->NumChildren() > 0)
            {
                $child_num = $iter_top->{node}->NumChildren();
                $first_child_node =  $iter_top->{node}->NthChildNode(0);
            }
            push @iter_stack, {
                up_node => $iter_top->{node},
                node    => $first_child_node,
                sibling_index => 0,
                sibling_num => $child_num,
                arg => $next_arg,
                sibling_values => []
            };
        }
        else
        {
            # case do_up

            if ($iter_top->{sibling_index} >= $iter_top->{sibling_num})
            {
                # up after last child
                my $sibling_values = $iter_top->{sibling_values};

                pop @iter_stack;
                $iter_top = $iter_stack[-1];

                my $sibling_v = undef; # to return in case no up function.
                if (defined $exit_func)
                {
                    $sibling_v = $exit_func->($iter_top->{node}, $iter_top->{arg}, $sibling_values, \@iter_stack);
                    push @{$iter_top->{sibling_values}},  $sibling_v;
                }

                $iter_top->{sibling_index}++;
                if ( $iter_top->{sibling_index} < $iter_top->{sibling_num})
                {
                    $iter_top->{node} = $iter_top->{up_node}->NthChildNode($iter_top->{sibling_index});
                }
                else
                {
                    $iter_top->{node} = undef;
                }

                # iter_stack が 2個 で up したら、root node の up なので抜ける
                if (@iter_stack == 1)
                {
                    return $sibling_v;
                }
            }
        }
    }
}

sub useNewTreeClass($$$)
{
    my ($class_base, $key0, $key1) = @_;
    if (@_ != 3) {confess "Error: new_tree_class requires 3 arguments "
        . "'BaseClassName', 'primary key name', 'secondary key name'. @_= ("
        . join (", ", @_) . ")\n"; }

    my ($box_c, $node_c) = map {$class_base . '::' . $_} 'NodeBox', 'Node';
    my $tree_c = $class_base;


    no strict "refs";

    @{*{$box_c  . '::ISA'}{ARRAY}} = ( 'TreeWrapperBase::NodeBox' );
    @{*{$node_c . '::ISA'}{ARRAY}} = ( 'TreeWrapperBase::Node' );
    @{*{$tree_c . '::ISA'}{ARRAY}} = ( 'TreeWrapperBase' );
    for my $c ($box_c, $node_c, $tree_c)
    {
        *{$c  . '::BoxClass' } = sub { $box_c; };
        *{$c  . '::NodeClass'} = sub { $node_c;};
        *{$c  . '::TreeClass'} = sub { $tree_c };
    }

    *{$node_c . '::GetPrimaryAttributeKey0' } = sub { $key0; };
    *{$node_c . '::GetPrimaryAttributeKey1' } = sub { $key1; };
    *{$node_c . '::IsPrimaryAttributeKey' } = sub {
        my ($self, $k) = @_; return ($k eq $key0 or $k eq $key1);
    };
}
# 上記は以下とほぼ同等のことをしている
# {
#     package TreeA::NodeBox;
#     our @ISA =    ( 'TreeWrapperBase::NodeBox' );
#     sub NodeClass { 'TreeA::Node'    };
#     sub BoxClass  { 'TreeA::NodeBox' };
#     sub TreeClass { 'TreeA'    };
# 
#     package TreeA::Node;
#     our @ISA =    ( 'TreeWrapperBase::Node' );
#     sub NodeClass { 'TreeA::Node'    };
#     sub BoxClass  { 'TreeA::NodeBox' };
#     sub TreeClass { 'TreeA'    };
#     sub GetPrimaryAttributeKey0 { return 'key0'; }
#     sub GetPrimaryAttributeKey1 { return 'key1'; }
#     sub IsPrimaryAttributeKey
#     { my ($self, $k) = @_; return $k =~ /^A(key0|key1)^z/; }
# 
#     package TreeA;
#     our @ISA =    ( 'TreeWrapperBase' );
#     sub NodeClass { 'TreeA::Node'    };
#     sub BoxClass  { 'TreeA::NodeBox' };
#     sub TreeClass { 'TreeA'    };
# }



sub newImportFromFlatHashTree
{
    my $class = shift;
    my ($root_node, $children_key, $key0, $key1) = @_;

    MyAssertDataType('HASH', $root_node, "Wrong 1st argument(\$root_node)." );
    MyAssertDataType('SCALAR', \$children_key, "Wrong 1st argument(\$root_node)." );

    my $actual_nodeclass = $class->NodeClass();

    my $key0c = $actual_nodeclass->GetPrimaryAttributeKey0();
    my $key1c = $actual_nodeclass->GetPrimaryAttributeKey1();
    $key0 = $key0c if !defined $key0;
    $key1 = $key1c if !defined $key1;

    return $class->newImportByFuncs($root_node,
        # rf_make_attribute_hash : node --> new_hash_ref
        sub {
            my ($node) = @_;
            my $rh_attr = {};
            %$rh_attr = %$node; # clone hash

            delete $rh_attr->{$children_key} if exists $rh_attr->{$children_key};

            if (exists $node->{$key0})
            { $rh_attr->{$key0c} = $node->{$key0};}
            if (exists $node->{$key1})
            { $rh_attr->{$key1c} = $node->{$key1};}
            if ($key0 ne $key0c and $key0 ne $key1c)
            { delete $rh_attr->{$key0}; }
            if ($key1 ne $key0c and $key1 ne $key1c)
            { delete $rh_attr->{$key1}; }

            return $rh_attr;
        },
        # rf_num_children        : node --> n
        sub {
            my ($node) = @_;
            return 0 if ! exists $node->{$children_key};
            return scalar @{$node->{$children_key}}
        },
        # rf_children            : node, n --> node
        sub {
            my ($node, $n) = @_;
            return $node->{$children_key}->[$n];
        }
    );
}


sub ExportToFlatHashTree
{
    my $self = shift;
    my ($children_key, $key0, $key1) = @_;

    MyAssertDataType('SCALAR', \$children_key, "Wrong 1st argument(\$children_key)." );

    my $actual_nodeclass = $self->NodeClass();

    my $key0c = $actual_nodeclass->GetPrimaryAttributeKey0();
    my $key1c = $actual_nodeclass->GetPrimaryAttributeKey1();
    $key0 = $key0c if !defined $key0;
    $key1 = $key1c if !defined $key1;

    return $self->ExportByFuncs(
        # rf_node_from_children : current_src_node, child_node_0 ... -> node
        sub {
            my $src_node = shift;
            my @child_nodes = @_;
            my $new_node = {};

            for my $k ($src_node->AttributeKeysNonPrimary())
            {
                $new_node->{$k} = $src_node->GetAttribute($k);
            }
            $new_node->{$key0} = $src_node->GetPrimaryAttribute0();
            $new_node->{$key1} = $src_node->GetPrimaryAttribute1();

            $new_node->{$children_key} = [@child_nodes]; # clone array and make ref
            return $new_node;
        },
        # rf_finish_root : root_node -> result_tree
        sub { return $_[0]; }
    );
}


sub newImportFromAttrhashChildTree
{
    my $class = shift;
    my ($root_node, $children_key, $attr_key, $key0, $key1) = @_;

    MyAssertDataType('HASH', $root_node, "Wrong 1st argument(\$root_node)." );
    MyAssertDataType('SCALAR', \$children_key, "Wrong 1st argument(\$children_key)." );
    MyAssertDataType('SCALAR', \$attr_key, "Wrong 1st argument(\$attr_key)." );

    my $actual_nodeclass = $class->NodeClass();

    my $key0c = $actual_nodeclass->GetPrimaryAttributeKey0();
    my $key1c = $actual_nodeclass->GetPrimaryAttributeKey1();
    $key0 = $key0c if !defined $key0;
    $key1 = $key1c if !defined $key1;

    return $class->newImportByFuncs($root_node,
        # rf_make_attribute_hash : node --> new_hash_ref
        sub {
            my ($node) = @_;

            my $node_attr = $node->{$attr_key};
            my $rh_attr = {};
            %$rh_attr = %$node_attr; # clone hash

            # delete $rh_attr->{$children_key} if exists $rh_attr->{$children_key};

            if (exists $node_attr->{$key0})
            { $rh_attr->{$key0c} = $node_attr->{$key0};}
            if (exists $node_attr->{$key1})
            { $rh_attr->{$key1c} = $node_attr->{$key1};}
            if ($key0 ne $key0c and $key0 ne $key1c)
            { delete $rh_attr->{$key0};} 
            if ($key1 ne $key0c and $key1 ne $key1c)
            { delete $rh_attr->{$key1};} 

            return $rh_attr;
        },
        # rf_num_children        : node --> n
        sub {
            my ($node) = @_;
            return 0 if ! exists $node->{$children_key};
            return scalar @{$node->{$children_key}}
        },
        # rf_children            : node, n --> node
        sub {
            my ($node, $n) = @_;
            return $node->{$children_key}->[$n];
        }
    );
}


sub ExportToAttrhashChildTree
{
    my $self = shift;
    my ($children_key, $attr_key, $key0, $key1) = @_;

    MyAssertDataType('SCALAR', \$children_key, "Wrong 1st argument(\$children_key)." );
    MyAssertDataType('SCALAR', \$attr_key, "Wrong 1st argument(\$attr_key)." );

    my $actual_nodeclass = $self->NodeClass();

    my $key0c = $actual_nodeclass->GetPrimaryAttributeKey0();
    my $key1c = $actual_nodeclass->GetPrimaryAttributeKey1();
    $key0 = $key0c if !defined $key0;
    $key1 = $key1c if !defined $key1;

    return $self->ExportByFuncs(
        # rf_node_from_children : current_src_node, child_node_0 ... -> node
        sub {
            my $src_node = shift;
            my @child_nodes = @_;
            my $new_node_attr = {};

            for my $k ($src_node->AttributeKeysNonPrimary())
            {
                $new_node_attr->{$k} = $src_node->GetAttribute($k);
            }
            $new_node_attr->{$key0} = $src_node->GetPrimaryAttribute0();
            $new_node_attr->{$key1} = $src_node->GetPrimaryAttribute1();

            my $new_node = { $attr_key => $new_node_attr };
            $new_node->{$children_key} = [@child_nodes]; # clone array and make ref
            return $new_node;
        },
        # rf_finish_root : root_node -> result_tree
        sub { return $_[0]; }
    );


}

# =============================================================
package TreeWrapperBaseIterator;
use Carp;
use Scalar::Util; # blessed, reftype

# やはり、TreeWrapperBaseIterator は Matchライブラリに移そう。
# (MatchCapturePlace に依存しているから)

# ========================================
# データ構造
#   #(削除) $self->{root_capture} : MatchCapturePlace | undef
#   $self->{iter_stack}   : ArrayRef[
#       { tree => <current-subtree-or-undef-for-virtual-root>,
#         sibling_index => <int>  # 現在注目している子のインデックス
#         sibling_num   => <int>,
#         on_up_do? => ref_func (void → void)
#       }, ...
#   ]
#   # root_capture は MatchCapturePlace::newByIterator に移した
#
# スタックの各フレームは「親の子リスト」を表します。
#   - その親の子のうち sibling_index 番目が「現在のノード（部分木）」です。
#   - ルートは仮想親（undef）配下に子が1つだけ（＝ルート部分木）あるものとして扱います。
# ========================================

# -------- コンストラクタ --------

sub new {
    my $class = shift;
    my ($tree, $on_up_do) = @_;
    # root_capture は MatchCapturePlace::newByIterator に移した
    # my ($tree, $rootcapture) = @_;

    # if (!defined $rootcapture)
    # {
    #     my $rootnode = $tree->GetRootNode();
    #     $rootcapture = new MatchCapturePlace($rootnode, $tree, undef);
    # }

    my $self = bless {
        # root_capture => $rootcapture,
        iter_stack   => [],
    }, $class;

    # ルートの仮想親フレームを積む（ルートでは兄弟が1つ）
    $self->{iter_stack} = [
        { tree => $tree, sibling_index => 0, sibling_num => 1 },
    ];
    if (defined $on_up_do)
    {
        $self->{iter_stack}->[0]->{on_up_do} = $on_up_do;
    }

    return $self;
}

# -------- ナビゲーション系 --------

# 現在のフレーム（トップ）を返す
sub _top { my $self = shift; return $self->{iter_stack}->[-1]; }

# 親フレーム（トップの一つ上）を返す（なければ undef）
sub _parent_frame {
    my $self = shift;
    my $n = @{ $self->{iter_stack} };
    return undef if $n < 2;
    return $self->{iter_stack}->[$n - 2];
}

# ---- 公開メソッド：位置問い合わせ ----

sub IsRoot { my ($self) = @_; return @{ $self->{iter_stack} } == 1 ? 1 : 0; }

sub IsEnd  {
    my ($self) = @_;
    my $top = $self->_top;
    return ($top->{sibling_index} >= $top->{sibling_num}) ? 1 : 0;
}

sub IsFirst  {
    my ($self) = @_;
    my $top = $self->_top;
    return ($top->{sibling_index} == 0) ? 1 : 0;
}
sub IsLast  {
    my ($self) = @_;
    my $top = $self->_top;
    return ($top->{sibling_index} == $top->{sibling_num} - 1) ? 1 : 0;
}

# ---- 公開メソッド：現在/親の Tree/Node ----

sub Tree
{
    my ($self) = @_;
    my $t = $self->_top
        or confess "Error: Wrong state Iterator (a0923d9f_e9017d9d)\n";
    return $t->{tree};
}
sub Node
{
    my ($self) = @_;
    my $t = $self->Tree();
    return undef if !defined $t;
    return $t->GetRootNode();
}

sub UpTree
{
    my ($self) = @_;
    my $f = $self->_parent_frame;
    return undef if !defined $f;
    return $f->{tree};
}
sub UpNode
{
    my ($self) = @_;
    my $t = $self->UpTree();
    return undef if !defined $t;
    return $t->GetRootNode();
}

# ---- 公開メソッド：移動 ----
# MoveNextSibling: 同じ親の次の兄弟へ
sub MoveNextSibling {
    my ($self) = @_;
    my $t = $self->_top
        or confess "Error: Wrong state Iterator (a0ed8583_4adf9fe2)\n";

    $t->{sibling_index}++;

    if ($self->IsEnd())
    {
        # Root ならこちら側に入る
        # MoveDownForce() した場合は単一ノードなのでこちら側に入る
        $t->{tree} = undef;
    }
    else
    {
        # else なら Root ではないので $self->_parent_frame が有効な値を返す

        my $up_node = $self->UpNode();
        if (defined $up_node)
        {
            $t->{tree} = $up_node->NthChildSubtree($t->{sibling_index});
        }
        else
        {
            $t->{tree} = undef;
        }
    }
}

# MoveDown: 現在ノードの最初の子へ降りる
sub MoveDown {
    my ($self) = @_;

    confess "Error: MoveDown: at end position" if $self->IsEnd();

    my $cur_node = $self->Node();

    # 子数を取得（Tree API 統合が必要）
    #     $cur_node が undef の場合は必ずゼロ
    my $cnt = 0;
    if (defined $cur_node)
    {
        $cnt = $cur_node->NumChildren();
    }
    my $child_subtree = undef;
    if ($cnt > 0) { $child_subtree = $cur_node->NthChildSubtree(0); }

    my $new_entry = {
        tree          => $child_subtree,   # 親ツリー
        sibling_index => 0,
        sibling_num   => $cnt,
    };

    push @{ $self->{iter_stack} }, $new_entry;
}
# MoveDownForce: 実際の子ノードは無視して、指定の部分木を単一子要素と見て無理矢理 MoveDown する
sub MoveDownForce {
    my ($self, $pseudo_child_subtree) = @_;

    if(! UNIVERSAL::isa ($pseudo_child_subtree, 'TreeWrapperBase'))
    { confess "Error: arg0(\$pseudo_child_subtree) must be subclass of TreeWrapperBase!\n"; }

    # # IsEnd() (最終ノード処理後) でもエラーにしないが、
    # #     この場合に反復が上手く働くためには注意が必要
    # confess "Error: MoveDown: at end position" if $self->IsEnd();

    my $new_entry = {
        tree          => $pseudo_child_subtree,   # 親ツリー
        sibling_index => 0,
        sibling_num   => 1,
    };

    push @{ $self->{iter_stack} }, $new_entry;
}

# MoveUp: 親へ上がる
sub MoveUp {
    my ($self) = @_;
    confess "Error: MoveUp called at root!" if @{ $self->{iter_stack} } == 1;

    pop @{ $self->{iter_stack} };

    my $top_entry = $self->_top();
    if (exists $top_entry->{on_up_do} && defined $top_entry->{on_up_do}) {
        $top_entry->{on_up_do}->();
    }

}
# OnUpDo: 現在のノードにいつか Up して到達したときにする処理をクロージャー(関数)で指定する
sub OnUpDo
{
    my ($self, $on_up_do) = @_;

    my $t = $self->_top
        or confess "Error: Wrong state Iterator (1a23e120_b62931a6)\n";

    if (exists $t->{on_up_do} && defined $t->{on_up_do})
    {
        confess "Error: current node already has on_up_do (88e6e8ff_488de0d7)\n";
    }

    $t->{on_up_do} = $on_up_do;
}


# MoveUp: 親へ上がる  ただし on_up_do の実行をスキップする
sub MoveUpNoDo {
    my ($self) = @_;
    confess "Error: MoveUp called at root!" if @{ $self->{iter_stack} } == 1;

    pop @{ $self->{iter_stack} };
}

# ---- 公開メソッド：複製 ----
sub Duplicate {
    my ($self) = @_;
    my $copy = bless {
        # root_capture => $self->{root_capture},
        iter_stack   => [ map { { %$_ } } @{ $self->{iter_stack} } ],
    }, ref($self);
    return $copy;
}


sub aux_debug_print_iter_stack_tree_str
{
    my ($tree) = @_;

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

    return $tree_str;
}
sub aux_debug_print_iter_stack
{
    my $self = shift;

    print " [ Iter Stack]\n";

    for my $i (keys @{ $self->{iter_stack} })
    {
        my $e = $self->{iter_stack}->[$i];

        my $tree_str = aux_debug_print_iter_stack_tree_str($e->{tree});

        my $index = '-';
        if (exists $e->{sibling_index} && defined $e->{sibling_index} )
        { $index = $e->{sibling_index};}

        print "  [$i] $index / $e->{sibling_num} : $tree_str\n";
    }
}
sub aux_debug_short_print
{
    my $self = shift;
    print join(" ", map {
        my $node_name = defined $_->{tree}->GetRootNode() ?
            $_->{tree}->GetRootNode()->Attr0
            : 'undef';
        "$node_name($_->{sibling_index}/$_->{sibling_num})"
    } @{ $self->{iter_stack} } )
    . "\n";
}




# # checking function for circular reference may be useful...

1;
