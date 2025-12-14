# 
# vim: set et sw=4 sts=4 ai : 
use utf8;
use strict;
use warnings;
# use Encode;
use Scalar::Util;


#   {use Dumpvalue; Dumpvalue->new->dumpValue($node_term_123);}

{
    package TLTreePatternAST;
    use TreeWrapperBase;

    # 現状、最終段の変換のみに使っている
    useNewTreeClass TreePatternAST => 'id', 'val';

    no warnings 'recursion';

    use Carp;

    sub ToTreePatternAST
    {
        my ($src_tree) = @_;
        # 複製したものを破壊的に変換する

        my $ret_tree = &aux_DupTree($src_tree);

        # NodeFactor のうち NodeBlock 以外を処理
        $ret_tree = &ToTreePatternAST_20_NodeFactor($ret_tree);

        # NodeFactor の NodeBlock を処理  ←やった
        # NodeTerm の 右辺を処理                       ←やった 
        # NodeTerm012 の 右辺を処理    (Seq へ)        ← やった
        $ret_tree = &ToTreePatternAST_40($ret_tree);

        # NodeTerm012Joint の処理
        $ret_tree = &ToTreePatternAST_60($ret_tree);

        # a_Parent_Child を削除する ??? ()
        $ret_tree = &ToTreePatternAST_80($ret_tree);

        # a_Child -> a_Non_Order を処理する
        $ret_tree = &ToTreePatternAST_90($ret_tree);

        # 最上位の PathPattern/TreePattern を整理する
        $ret_tree = &ToTreePatternAST_95($ret_tree);

        $ret_tree = TreePatternAST->newImportFromFlatHashTree($ret_tree, 'child', 'id', 'val');

        return $ret_tree;
    }

    sub aux_DupTree
    {
        my ($tree) = @_;
        my $ra_src_child = $tree->{child};

        my $n_child = @{$ra_src_child};
        my (@dst_child) = (undef) x $n_child;

        for my $i(0 .. $n_child - 1)
        {
            $dst_child[$i] = aux_DupTree($ra_src_child->[$i]);
        }
        my $dst_tree = {%$tree};
        $dst_tree->{child} = \@dst_child;

        return $dst_tree;
    }
    sub aux_NodeIDsEq
    {
        my ($node, @arg) = @_;
        {
            my $node_datatype = Scalar::Util::reftype($node);
            if (!defined $node_datatype)
            { confess "Error: wrong arg (arg0)\n"; }
            if ($node_datatype ne 'HASH')
            { confess "Error: wrong arg (arg0)\n"; }
        }
        my ($i, $s);
        while(@arg)
        {
            if (@arg < 2)
            {
                confess "Error: Wrong Args of aux_NodeIDsEq\n";
            }
            $i = shift(@arg);
            $s = shift(@arg);
            if ($i < 0) {
                return 0 if $node->{id} ne $s;
            }
            else
            {
                return 0 if $i > @{$node->{child}} - 1;
                return 0 if $node->{child}->[$i]->{id} ne $s;
            }
        }
        return 1;
    }
    sub aux_AllNodeIDsEq
    {
        my ($node, $root_id ,@arg) = @_;

        {
            my $node_datatype = Scalar::Util::reftype($node);
            if (!defined $node_datatype)
            { confess "Error: wrong arg (arg0)\n"; }
            if ($node_datatype ne 'HASH')
            { confess "Error: wrong arg (arg0)\n"; }
        }


        if (defined $root_id)
        {
            if ($node->{id} ne $root_id) { return 0; }
        }

        if (@arg != @{$node->{child}}) { return 0; }

        for my $i (0 ..$#arg)
        {
            if (!defined $arg[$i]) { next; }
            if ($node->{child}->[$i]->{id} ne $arg[$i]) { return 0; }
        }
        return 1;
    }
    sub aux_GetChild
    {
        my ($node, $i, $s) = @_;
        {
            my $node_datatype = Scalar::Util::reftype($node);
            if (!defined $node_datatype)
            { confess "Error: wrong arg (arg0)\n"; }
            if ($node_datatype ne 'HASH')
            { confess "Error: wrong arg (arg0)\n"; }
        }
        if ($i > @{$node->{child}} - 1)
        { confess "Error: index out of range in aux_GetChild\n"; }
        if ($node->{child}->[$i]->{id} ne $s)
        { confess "Error: wrong id in aux_GetChild\n"; }

        return $node->{child}->[$i];
    }

    sub ToTreePatternAST_20_NodeFactor
    {
        my ($tree) = @_;
        # 1. NodeFactor --> NodeFactorWithCond
        #    NodeFactor --> '-' NodeFactorWithCond
        #    を a_Node に変更する
        #        ( NodeFactor --> NodeBlock ) ←これは別
        # 2. NodeFactor --> NodeBlock
        #    を a_Block に変換する

        my @ci = map {$_->{id}} @{$tree->{child}};

        if ($tree->{id} ne 'NodeFactor')
        {
            for my $c(@{$tree->{child}})
            { $c = ToTreePatternAST_20_NodeFactor($c); }
            return $tree;
        }


        my $down_node = undef;

        # # NodeFactor --> NodeFactorWithCond
        # if ($tree->{id} eq 'NodeFactor' && $ci[0] eq 'NodeFactorWithCond')
        # { $down_node = $tree->{child}->[0]; }
        # # NodeFactor --> '-' NodeFactorWithCond
        # elsif ($tree->{id} eq 'NodeFactor' && $ci[0] eq '-')
        # { $down_node = $tree->{child}->[1]; }
        # # else  ( NodeFactor --> NodeBlock  と NodeFactor 以外)

        # NodeFactor --> NodeFactorWithCond
        if (aux_AllNodeIDsEq($tree, 'NodeFactor', 'NodeFactorWithCond'))
        { $down_node = aux_GetChild($tree, 0, 'NodeFactorWithCond'); }
        # NodeFactor --> '-' NodeFactorWithCond
        elsif (aux_AllNodeIDsEq($tree, 'NodeFactor', '-', 'NodeFactorWithCond'))
        { $down_node = aux_GetChild($tree, 1, 'NodeFactorWithCond'); }
        ## else  ( NodeFactor --> NodeBlock  と NodeFactor 以外)

        if (! defined $down_node)
        {
            # a_Node に変換しないパターン
            # block の処理をする
            if (aux_AllNodeIDsEq($tree, 'NodeFactor', 'NodeBlock'))
            {
                my $block_node = aux_GetChild($tree, 0, 'NodeBlock');
                # NodeBlock  --> t_LABEL '(' NodeTerm012Joint ')'
                # NodeBlock  --> '(' NodeTerm012Joint ')'
                # NodeBlock  --> '(?' '-' t_LITERAL ')'
                #
                my $dst_tree;
                if (aux_AllNodeIDsEq($block_node, 'NodeBlock', 't_LABEL', '(', 'NodeTerm012Joint', ')'))
                {
                    $dst_tree = {
                        id => 'a_Block',
                        val =>undef,
                        label => aux_GetChild($block_node, 0, 't_Label'),
                        child => [aux_GetChild($block_node, 2, 'NodeTerm012Joint')],
                    };
                    $dst_tree->{child}->[0] = ToTreePatternAST_20_NodeFactor($dst_tree->{child}->[0]);
                }
                elsif (aux_AllNodeIDsEq($block_node, 'NodeBlock', '(', 'NodeTerm012Joint', ')'))
                {
                    $dst_tree = {
                        id => 'a_Block',
                        val => undef,
                        child => [aux_GetChild($block_node ,1, 'NodeTerm012Joint')],
                    };
                    $dst_tree->{child}->[0] = ToTreePatternAST_20_NodeFactor($dst_tree->{child}->[0]);
                }
                elsif (aux_AllNodeIDsEq($block_node, 'NodeBlock', '(?', '-', 't_LITERAL', ')'))
                {
                    $dst_tree = {
                        id => 'a_Rec_Ref',
                        val => undef,
                        num => aux_GetChild($block_node, 2, 't_LITERAL')->{val},
                        child => [],
                    };
                    if ($dst_tree->{num}!~/\A\d+\z/)
                    {die "Error: wrong recursive ref num '$dst_tree->{num}'!\n";}
                }
                else
                { die "Error: Trap internal error (cc05da79_f2fb1fed)!\n"; }


                return $dst_tree;
            }
            else
            {
                confess "Error: internal error (6362f77a_8dd863a7)\n";
                #
                #
                #    NodeFactor --> NodeFactorWithCond
                #    NodeFactor --> '-' NodeFactorWithCond
                #       は最初の if で弾かれる
                #    NodeFactor --> NodeBlock は2段目の if で弾かれる
                #
                # for my $c(@{$tree->{child}})
                # { $c = ToTreePatternAST_20_NodeFactor($c); }
                # return $tree;
            }
        }
        else
        {
            # a_Node に変換するケース
            # $down_node は NodeFactorWithCond
            my $dst_tree = { id => 'a_Node', val => undef, child =>[
                    {id =>'a_Attr_Cond_List', val => undef, child => []},
                    {id =>'a_Place_List', val => undef, child => []},
                    {id =>'a_Child', val => undef, child => []},
                ]};
            if ($ci[0] eq '-') { $dst_tree->{exclude_mached} =  1;}
            else               { $dst_tree->{exclude_mached} =  0;}
            $tree = $down_node;

            # $tree は NodeFactorWithCond
            #     NodeFactorWithCond --> '!' NodeFactorWithPostCond
            #     NodeFactorWithCond --> NodeFactorWithPostCond
            @ci = map {$_->{id}} @{$tree->{child}};
            if ($ci[0] eq '!')
            { $down_node = $tree->{child}->[1]; $dst_tree->{neg} = 1;}
            else 
            { $down_node = $tree->{child}->[0]; $dst_tree->{neg} = 0;}
            $tree = $down_node;

            # $tree は NodeFactorWithPostCond
            #     NodeFactorWithPostCond -->  Node  NodeCond012
            my $node_node = aux_GetChild($tree, 0, 'Node');
            my $node_cond_012_node = aux_GetChild($tree, 1, 'NodeCond012');

            my $node_RHS = $node_node->{child}->[0];
            # $node_node は Node
            #     $node_RHS は . _ $ t_LITERAL t_PATTERN_LITERAL

            # node_node の処理
            #
            #     Node  --> '.'
            #     Node  --> '_'
            #     Node  --> '$'         ########追加
            #     Node  --> t_LITERAL
            #     Node  --> t_PATTERN_LITERAL
            #
            if ($node_RHS->{id} eq '.') { $dst_tree->{node_type} = 'any'; }
            elsif ($node_RHS->{id} eq '_') { $dst_tree->{node_type} = 'none'; }
            elsif ($node_RHS->{id} eq '$') { $dst_tree->{node_type} = 'end'; }
            elsif ($node_RHS->{id} eq 't_LITERAL')
            {
                $dst_tree->{node_type} = 'id';
                $dst_tree->{val} = $node_RHS->{val};
            }
            elsif ($node_RHS->{id} eq 't_PATTERN_LITERAL')
            {
                $dst_tree->{node_type} = 'id_regexp';
                $dst_tree->{val} = $node_RHS->{val};

                if (!exists $node_RHS->{option_str})
                { confess "Error: internal error (9fd251fc_e53eb3a1)\n"; }
                $dst_tree->{option_str} = $node_RHS->{option_str};
            }
            else { die "Error: Trap internal error (36dfa805_402cfce5)!\n"; }

            # node_cond_012_node  の処理
            #
            #     NodeCond012   --> NodeCond NodeCond012
            #     NodeCond012   --> (none)
            #     NodeCond      --> '#' t_LITERAL
            #     NodeCond      --> '#' t_PATTERN_LITERAL
            #     NodeCond      --> '#' '{' t_LITERAL '}' t_LITERAL
            #     NodeCond      --> '#' '{' t_LITERAL '}' t_PATTERN_LITERAL
            #     NodeCond      --> '##' t_LITERAL
            #     NodeCond      --> '##@' t_LITERAL
            #
            my $dst_cond_list = $dst_tree->{child}->[0];
            if ($dst_cond_list->{id} ne 'a_Attr_Cond_List')
            {die "Error: Trap internal error (658c0d9b_f4641aea)!\n";}

            my $dst_place_list = $dst_tree->{child}->[1];
            if ($dst_place_list->{id} ne 'a_Place_List')
            { die "Error: Trap internal error (1627d4e4_9eeb1f3c!\n";}


            while (@{$node_cond_012_node->{child}})
            {
                my $node_cond = $node_cond_012_node->{child}->[0];

                my $dst_node_cond = {id => 'a_Attr_Cond', val=> undef, child=>[]};
                my $dst_place_node = {id => undef, val=> undef, child=>[]};

                if ($node_cond->{id} ne 'NodeCond')
                {die "Error: Trap internal error (68e161cf_8c62ad95)!\n";}

                @ci = map {$_->{id}} @{$node_cond->{child}};
                if ($ci[0] eq '#' and $ci[1] eq 't_LITERAL' )
                {
                    $dst_node_cond->{key_type} = 'sec';
                    $dst_node_cond->{match_type} = 'str';
                    $dst_node_cond->{val} = $node_cond->{child}->[1]->{val};
                    push @{$dst_cond_list->{child}}, $dst_node_cond;
                }
                elsif ($ci[0] eq '#' and $ci[1] eq 't_PATTERN_LITERAL' )
                {
                    $dst_node_cond->{key_type} = 'sec';
                    $dst_node_cond->{match_type} = 'regexp';
                    $dst_node_cond->{val} = $node_cond->{child}->[1]->{val};

                    if (!exists $node_cond->{child}->[1]->{option_str})
                    { confess "Error: internal error (8bf5ae2e_b4ef31f8)\n"; }
                    $dst_node_cond->{option_str} = $node_cond->{child}->[1]->{option_str};

                    push @{$dst_cond_list->{child}}, $dst_node_cond;
                }
                elsif ($ci[0] eq '#' and $ci[1] eq '{' and $ci[4] eq 't_LITERAL' )
                {
                    $dst_node_cond->{key_type} = 'other';
                    $dst_node_cond->{match_type} = 'str';
                    $dst_node_cond->{key_val} = $node_cond->{child}->[2]->{val};
                    $dst_node_cond->{val} = $node_cond->{child}->[4]->{val};
                    push @{$dst_cond_list->{child}}, $dst_node_cond;
                }
                elsif ($ci[0] eq '#' and $ci[1] eq '{' and $ci[4] eq 't_PATTERN_LITERAL' )
                {
                    $dst_node_cond->{key_type} = 'other';
                    $dst_node_cond->{match_type} = 'regexp';
                    $dst_node_cond->{key_val} = $node_cond->{child}->[2]->{val};
                    $dst_node_cond->{val} = $node_cond->{child}->[4]->{val};
                    push @{$dst_cond_list->{child}}, $dst_node_cond;
                }
                elsif ($ci[0] eq '##')
                {
                    $dst_place_node->{id} = 'a_Single_Place';
                    $dst_place_node->{val} = $node_cond->{child}->[1]->{val};
                    push @{$dst_place_list->{child}}, $dst_place_node;
                }
                elsif ($ci[0] eq '##@')
                {
                    $dst_place_node->{id} = 'a_Multi_Place';
                    $dst_place_node->{val} = $node_cond->{child}->[1]->{val};
                    push @{$dst_place_list->{child}}, $dst_place_node;
                }
                else {die "Error: Trap internal error (1273ad1c_c73f56c9)!\n";}

                # 次のノードに進む
                $node_cond_012_node = $node_cond_012_node->{child}->[1];
            }

            # 一律に ordered にしておいて、後で変更する。
            $dst_tree->{ordered} = 1;

            # 暫定

            return $dst_tree;
        }
    }

    sub ToTreePatternAST_40
    {
        my ($tree) = @_;
        #   (  NodeFactor の NodeBlock を処理 ← ToTreePatternAST_20 に移した )
        # NodeTerm の 右辺を処理
        # NodeTerm012 の 右辺を処理


        # NodeTerm  --> NodeFactor --> ??? == から
        #     NodeTerm  --> a_Node に変換されたもの
        # NodeTerm  --> NodeFactor --> NodeBlock
        # NodeTerm  --> NodeFactor== '*'
        # NodeTerm  --> NodeFactor== '+'
        if ($tree->{id} eq 'NodeTerm')
        {
            my $factor_node = $tree->{child}->[0];
            my $dst_tree = undef;
            if (@{$tree->{child}} == 1)
            {
                # NodeTerm  --> NodeFactor==
                $dst_tree = ToTreePatternAST_40($factor_node);
            }
            elsif (aux_AllNodeIDsEq($tree, 'NodeTerm', undef, '*'))
            {
                $dst_tree = {
                    id => 'a_Rep0',
                    val => undef,
                    child => [$factor_node],
                    shortest => 0,
                };
                $dst_tree->{child}->[0] = ToTreePatternAST_40($dst_tree->{child}->[0]);
            }
            elsif (aux_AllNodeIDsEq($tree, 'NodeTerm', undef, '*', '?'))
            {
                $dst_tree = {
                    id => 'a_Rep0',
                    val => undef,
                    child => [$factor_node],
                    shortest => 1,
                };
                $dst_tree->{child}->[0] = ToTreePatternAST_40($dst_tree->{child}->[0]);
            }
            elsif (aux_AllNodeIDsEq($tree, 'NodeTerm', undef, '+'))
            {
                $dst_tree = {
                    id => 'a_Rep1',
                    val => undef,
                    child => [$factor_node],
                    shortest => 0,
                };
                $dst_tree->{child}->[0] = ToTreePatternAST_40($dst_tree->{child}->[0]);
            }
            elsif (aux_AllNodeIDsEq($tree, 'NodeTerm', undef, '+', '?'))
            {
                $dst_tree = {
                    id => 'a_Rep1',
                    val => undef,
                    child => [$factor_node],
                    shortest => 1,
                };
                $dst_tree->{child}->[0] = ToTreePatternAST_40($dst_tree->{child}->[0]);
            }
            else
            { die "Error: Trap internal error (94c0a497_3565def5)!\n"; }

            return $dst_tree;
        }
        # # NodeTerm012 の 右辺を処理    (Seq へ)        ←まだ 
        #     NodeTerm012       --> NodeTerm NodeTerm012
        #     NodeTerm012       -->
        elsif ($tree->{id} eq 'NodeTerm012')
        {
            my $ra_term_nodes = [];
            my $node_term_012 = $tree;
            my $dst_node = undef;

            while (aux_AllNodeIDsEq($node_term_012, 'NodeTerm012', undef, 'NodeTerm012'))
            {
                push @$ra_term_nodes, $node_term_012->{child}->[0];
                $node_term_012 = aux_GetChild($node_term_012, 1, 'NodeTerm012');
            }
            if (@{$node_term_012->{child}} !=0)
            { die "$node_term_012->{child}->[0]->{id} Error: Trap internal error (83877cae_df9bd754)!\n"; }

            # # 以下は 123 -> 012 になったので削除
            # push @$ra_term_nodes, $node_term_012->{child}->[0];
            # if ( @$ra_term_nodes == 0)
            # { die "Error: Trap internal error (f54d7dc0_70412575)!\n"; }
            # # elsif ( @ra_term_nodes == 1)
            # # {
            # #     $dst_node = $ra_term_nodes->[0];
            # # }
            # else
            {
                $dst_node = {
                    id => 'a_Seq',
                    val => undef,
                    child => $ra_term_nodes,
                };
            }
            for my $c (@{$dst_node->{child}})
            { $c = ToTreePatternAST_40($c); }
            return $dst_node;
        }
        else
        {
            # a_Node に変換しないパターン
            for my $c(@{$tree->{child}})
            { $c = ToTreePatternAST_40($c); }
            return $tree;
        }

    }
    # NodeTerm012Joint の処理
    sub ToTreePatternAST_60
    {
        my ($tree) = @_;
        #     NodeTerm012Joint   -->  NodeTerm012 '>' NodeTerm012Joint
        #     NodeTerm012Joint   -->  NodeTerm012 '>' '~' NodeTerm012Joint
        #     NodeTerm012Joint   -->  NodeTerm012 '|' NodeTerm012Joint
        #     NodeTerm012Joint   -->  NodeTerm012

    # L(x > L(y > L(z > L(w))))
    # L(x > L(y > L(z > L(w))))
    #     x : x > L(y > L(z > L(w)))
    #     P+(x, L(y + L(z + L(w)))
    #
    # L(x +~ L(y + L(z + L(w))))
    #     x : x +~ L(y + L(z + L(w)))
    #     P+~(L(y + L(z + L(w)))
    #     P+~(L(~(y) + L(z + L(w)))
    #          さらに(unseq)
        if ($tree->{id} eq 'NodeTerm012Joint')
        {
            my $dst_node = undef;
            my @terms = ();

            my $down_next = $tree;

            while ($down_next)
            {
                if (aux_AllNodeIDsEq($down_next, 'NodeTerm012Joint', undef, '>', 'NodeTerm012Joint'))
                {
                    push @terms, {
                        node => $down_next->{child}->[0],
                        type => 'a_Parent_Child',
                    };
                    $down_next = aux_GetChild($down_next, 2, 'NodeTerm012Joint')
                }
                elsif (aux_AllNodeIDsEq($down_next, 'NodeTerm012Joint', undef, '>', '~', 'NodeTerm012Joint'))
                {
                    push @terms, {
                        node => $down_next->{child}->[0],
                        type => 'a_Non_Order',
                    };
                    $down_next = aux_GetChild($down_next, 3, 'NodeTerm012Joint')
                }
                elsif (aux_AllNodeIDsEq($down_next, 'NodeTerm012Joint', undef, '|', 'NodeTerm012Joint'))
                {
                    push @terms, {
                        node => $down_next->{child}->[0],
                        type => 'a_P_Or',
                    };
                    $down_next = aux_GetChild($down_next, 2, 'NodeTerm012Joint')
                }
                elsif (aux_AllNodeIDsEq($down_next, 'NodeTerm012Joint', undef))
                {
                    push @terms, {
                        node => $down_next->{child}->[0],
                        type => '',
                    };
                    $down_next = undef;
                }
                else
                { die "Error: Trap internal error (e13b5cbe_0ea85964)!\n"; }
            }

            $dst_node = $terms[@terms - 1]->{node};
            # 最後の leaf 以下を変換
            $dst_node = ToTreePatternAST_60($dst_node);
            for (my $i=@terms-2; $i >= 0; $i--)
            {
                my $parent_node = ToTreePatternAST_60($terms[$i]->{node});
                my $child_node = $dst_node;
                if ($terms[$i]->{type} ne 'a_Non_Order')
                {
                    # OR か ParentChild のとき
                    $dst_node = {
                        id =>$terms[$i]->{type},
                        child =>[$parent_node, $child_node],
                    };
                }
                else
                {
                    # a_Non_Order のとき
                    $dst_node = {
                        id =>'a_Parent_Child',

                        child =>[$parent_node, {
                            id =>'a_Non_Order',
                            child =>[$child_node],
                        } ],
                    };
                }
            }
            return $dst_node;

        }
        else
        {
            # a_Node に変換しないパターン
            for my $c(@{$tree->{child}})
            { $c = ToTreePatternAST_60($c); }
            return $tree;
        }
    }


    # a_Parent_Child を削除する ??? ()
    sub ToTreePatternAST_80
    {
        my ($tree) = @_;

        if ($tree->{id} eq 'a_Parent_Child')
        {
            if (@{$tree->{child}} !=2 )
            { die "Error: Trap internal error (b67640c9620f542c)!\n"; }

            if ($tree->{child}->[0]->{id} ne 'a_Seq')
            { die "Error: child '>' of Non-Seq/Node element is not supported yet!!\n"; }

            my $parent_node = aux_GetChild($tree, 0, 'a_Seq');

            if (@{$parent_node->{child}} == 0)
            { die "Error: no parent for child '>' (Seq has 0 element)\n"; }


            my $child_node = $tree->{child}->[1];

            $parent_node = ToTreePatternAST_80($parent_node);
            $child_node = ToTreePatternAST_80($child_node);



            my $parent_seq_last_node = $parent_node->{child}->[@{$parent_node->{child}} -1];
            if ($parent_seq_last_node->{id} ne  'a_Node')
            { die "Error: non Node parent for child '>' is not supported yet!\n"; }


            my $parent_seq_last_node_child = aux_GetChild($parent_seq_last_node, 2, 'a_Child');


            if (@{$parent_seq_last_node_child-> {child}} > 0)
            { die "Error: Conflict multiple children descriptor!\n";}

            $parent_seq_last_node_child->{child}->[0] = $child_node;
            return $parent_node;
        }
        else
        {
            # a_Node に変換しないパターン
            for my $c(@{$tree->{child}})
            { $c = ToTreePatternAST_80($c); }
            return $tree;
        }
    }

    # a_Child -> a_Non_Order を処理する
    sub ToTreePatternAST_90
    {
        my ($tree, $in_non_order) = @_;

        my $next_level_in_non_order;
        # a_Child -> a_Non_Order -> ... -> a_Child の間の a_Node を全て
        # {ordered} = 0 する

        if (!defined $in_non_order)
        {
            $in_non_order = 0;
        }

        if ($tree->{id} eq 'a_Non_Order') { $in_non_order = 1; }
        elsif ($tree->{id} eq 'a_Child')  { $in_non_order = 0; }
        elsif ($in_non_order && $tree->{id} eq 'a_Node')   { $tree->{ordered} = 0; }
        # else: do nothing


        # 再帰
        for my $c(@{$tree->{child}})
        { $c = ToTreePatternAST_90($c, $in_non_order); }

        return $tree;
    }

    # 最上位の PathPattern/TreePattern を整理する
    sub ToTreePatternAST_95
    {
        my ($tree) = @_;

        #     PathAndTreePattern --> TreePattern
        #     PathAndTreePattern --> ';' TreePattern
        #     PathAndTreePattern --> PathPattern ';' TreePattern
        #     PathAndTreePattern --> PathPattern ';'
        # から
        #     a_Root  -->  a_Path_Pat  a_Tree_Pat

        if ($tree->{id} ne 'TreePattern')
        { die "Error: Trap internal error (ccc2f075_79a0f2b5)!\n"; }

        my $tree_pat_orig_node = $tree;

        my $dst_node = { id=>'a_Tree_Pat', val=>undef, child=>[
                    @{ $tree_pat_orig_node->{child} }
        ]};

        return $dst_node;
    }


}


1;
