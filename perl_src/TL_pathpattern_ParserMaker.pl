# 
# vim: set et sw=4 sts=4 ai : 
# utf-8  (あ)
use utf8;
use strict;
use warnings;
use Carp;

# use Encode;
# binmode STDIN,":encoding(cp932)";
# binmode STDOUT,":encoding(cp932)";
#
use List::Util qw/ any all none notall first /;

use Dumpvalue;
my $dumpvalue = Dumpvalue->new;
sub dumpv
{
    die "Error: need 2 arg for main::dumpv!(@_)\n" if @_ != 2;
    my $ref_id = ref($_[1]);
    print "(dump: $_[0] : $ref_id)\n"; $dumpvalue->dumpValue($_[1]);
}
# dumpv('result_rhs 2', $result_of_rhs);

{
    package DebugPrint;

    our $n_nest = 0;
    our $indent_str = " |  ";
    our $debug_prefix = "(debug)";
    sub indent{return $debug_prefix . $indent_str x $n_nest;}
    sub new
    {
        my ($class, $id, @args) = @_;
        my $self = {id => $id};
        bless $self, "DebugPrint";

        print $self->indent() . "{ (enter $n_nest '$id'";
        print ": " . join(" ", map {"'$_'"} @args) if @args;
        print ")\n";

        $n_nest++;
        return $self;
    }
    sub DESTROY
    {
        my ($self) = @_;

        $n_nest--;

        print $self->indent() . "} (leave $n_nest '$self->{id}')\n";
    }
    sub msg
    {
        my ($self, $msg) = @_;
        print $self->indent() . "$msg\n";
    }
    sub msgv
    {
        my ($self, $var_s, $var_r) = @_;
        die "Error: need 3 arg for DebugPrint::msgv!(@_)\n" if @_ != 3;
        if(!defined $var_r) { $var_r = 'undef'; }
        else {$var_r = qq{'$var_r'};}
        print $self->indent() . "$var_s = $var_r\n";
    }
    sub dumpv
    {
        my ($self, $ref_s, $ref_r) = @_;
        die "Error: need 3 arg for DebugPrint::dumpv!(@_)\n" if @_ != 3;
        my $i = $self->indent();
        my $ref_r_id = ref $ref_r;

        print $i . "BEGIN: $ref_s ($ref_r_id) : =======================\n";
        $dumpvalue->dumpValue($ref_r);
        print $i . "==END: $ref_s : =======================\n";
    }
    1;
    # my $dp = DebugPrint->new('has', @_);
}

use Carp; # for  carp, croak, confess;
sub assert_args(@)
{
    for (my $n = 0; $n+1 < @_; $n+=2)
    {
        if (ref($_[$n+1]) ne $_[$n])
        {
            my @arg_strs;
            my $m;
            for ($m = 0; $m+1 < @_; $m+=2)
            {
                push @arg_strs, $_[$n] . "=>" .ref($_[$n+1]);
            }
            push @arg_strs, $_[$m] if $m<@_;

            confess "Error: Wrong argument (" .  join(", ", @arg_strs) . ")\n";
        }
    }
}



###############################################################
# 
###############################################################

sub add_rule($$); sub add_rule_full($$$$); # prototypes

# # Terminal Symbols
# my @Vt = qw{i + * ( )};
# my $start_symbol='E';
# my @rules_src = ();
# add_rule 'E', [qw/E + T/];
# add_rule 'E', [qw/T/];
# add_rule 'T', [qw/T * F/];
# add_rule 'T', [qw/F/];
# add_rule 'F', [qw/( E )/];
# add_rule 'F', [qw/i/];
# # (0..5)

# # Terminal Symbols
# my @Vt = qw{= i ^ + @};
# my $start_symbol='A';
# my @rules_src = ();
# add_rule 'A', [qw/L = E/];
# add_rule 'L', [qw/i/];
# add_rule 'L', [qw/R ^ i/];
# add_rule 'E', [qw/E + R/];
# add_rule 'E', [qw/R/];
# add_rule 'E', [qw/@ L/];
# add_rule 'R', [qw/i/];
# # (0..6)

# # # IF-THEN-ELSE
# # Terminal Symbols
# my @Vt = qw{if then else stmt expr};
# my $start_symbol='S';
# my @rules_src = ();
# add_rule 'S', [qw/S STMT/];
# add_rule 'S', [qw/STMT/];
# add_rule 'STMT', [qw/stmt/];
# add_rule_full 'STMT', [qw/if C then STMT/], {
#         perl =>
#         '$LHS_SV = {id => $LHS_ID, child => \@SVs};print "  [ $LHS_ID $#SVs ] ";',
#         javascript =>
#         'LHS_SV = {id : LHS_ID, child : SVs}; console.log( `  [ ${LHS_ID} ${SVs.length} ] ` );'
#     }
#     , -10;
# add_rule 'STMT', [qw/if C then STMT else STMT/];
# add_rule 'C', [qw/expr/];
# # (0..5)

###############################################################
# # # AA Tree Gen
# # Terminal Symbols
# my @Vt = qw{ t_Node > ( ) };
# my $start_symbol='Tree';
# my @rules_src = ();
# add_rule 'Tree', [qw/t_Node > SubTreeSeq/];
# add_rule 'Tree', [qw/t_Node/];
# 
# #  SubTreeSeq ::= { PT | t_node }* {PT | Tree }
# #  ↑これは conflict して難しいので、Semantic に弾くことにする
# ##  SubTreeSeq ::= { PT | t_node }+ {> SubTreeSeq}?
# #   (最後の Child は後からむりやり子に付ける。
# #    その際 Seq 最後のノードが子を持っていたらエラー)
# add_rule 'SubTreeSeq', [qw/PT_Node_123 Children_01/];
# add_rule 'PT_Node_123', [qw/PT_Node PT_Node_123/];
# add_rule 'PT_Node_123', [qw/PT_Node/];
# add_rule 'PT_Node', [qw/PT/];
# add_rule 'PT_Node', [qw/t_Node/];
# # add_rule 'PT', [qw/( Tree )/];
# add_rule 'PT', [qw/( SubTreeSeq )/];
# add_rule 'Children_01', [qw/> SubTreeSeq/];
# add_rule 'Children_01', [];
###############################################################


# # AA Tree Gen
# Terminal Symbols
# my @Vt = qw{ t_Node > ( ) };

my @Vt = ('##@', '##', '(?',
    split('', '|>,(){}*#.?-$!'),
    split('', '+~_;' ),
    qw{t_LITERAL  t_PATTERN_LITERAL  t_LABEL}
);

my $start_symbol='PathPattern';
my @rules_src = ();

# 生成規則
#
#

add_rule 'PathPattern', [qw/Node012/]; #暫定
add_rule 'Node012', [qw/Node012 NodeFactorWithPostCond/]; #暫定
add_rule 'Node012', []; #暫定
# 


    add_rule 'NodeFactorWithPostCond', [qw/Node NodeCond012/];

        add_rule 'NodeCond012', [qw/NodeCond NodeCond012/];
        add_rule 'NodeCond012', [qw//];

        add_rule 'NodeCond', [qw/# t_LITERAL/];
        add_rule 'NodeCond', [qw/# t_PATTERN_LITERAL/];
        add_rule 'NodeCond', [qw/# { t_LITERAL } t_LITERAL/];
        add_rule 'NodeCond', [qw/# { t_LITERAL } t_PATTERN_LITERAL/];
        add_rule 'NodeCond', [qw/## t_LITERAL/];
        add_rule 'NodeCond', [qw/##@ t_LITERAL/];

    add_rule 'Node', [qw/./];
    add_rule 'Node', [qw/_/];
    add_rule 'Node', [qw/t_LITERAL/];
    add_rule 'Node', [qw/t_PATTERN_LITERAL/];
    add_rule 'Node', [qw/$/];



# add_rule 'S', [qw/STMT/];
# add_rule 'STMT', [qw/stmt/];
# add_rule_full 'STMT', [qw/if C then STMT/], {
#         perl =>
#         '$LHS_SV = {id => $LHS_ID, child => \@SVs};print "  [ $LHS_ID $#SVs ] ";'
#     }
#     , -10;
# add_rule 'STMT', [qw/if C then STMT else STMT/];
# add_rule 'C', [qw/expr/];
# # (0..5)





sub add_rule($$)
{ push @rules_src, {lhs=>$_[0], rhs=>$_[1], action=>undef, r_pri=>0}; }
sub add_rule_full($$$$)
{ push @rules_src, {lhs=>$_[0], rhs=>$_[1], action=>$_[2], r_pri=>$_[3]}; }

###############################################################
# 
# my @PG_TARGETS = qw/perl/;
my @PG_TARGETS = qw/perl javascript/;

my $PG_PARSER_ID = 'PathPatternParser';

my $PG_OUTPUT_FILE = {};
my $PG_PRE = {};
my $PG_POST = {};
my $PG_GENERAL_ACTION = {};
my $PG_SKIP_DEBUG_DESC = 1;

$PG_OUTPUT_FILE->{perl} = 'output_PathPatParser_p.pm';
$PG_OUTPUT_FILE->{javascript} = '../js_src/TLParser_pathpat_generated.js';

# for perl ####################################################

$PG_PRE->{perl} = <<'EOT';
# pre here...

use utf8;
use strict;
use warnings;
use Encode;

# binmode STDIN,":encoding(cp932)";
# binmode STDOUT,":encoding(cp932)";

# generated from treelib -> parserGen -> aa_tree_gen

EOT

$PG_POST->{perl} = <<'EOT';
# post here...

EOT

$PG_GENERAL_ACTION->{perl} = <<'EOT';
# perl_action_here...
#     $LHS_SV = {id => $LHS_ID, child => \@SVs};
    $LHS_SV = {id => $LHS_ID, val => undef, child => \@SVs};
EOT

# for javascript ##############################################

$PG_PRE->{javascript} = <<'EOT';
// pre here...

'use strict';
// ↑ これも pre に書く前提

// generated from ...

EOT

$PG_POST->{javascript} = <<'EOT';
// 
// 


///////////////////////////////////////////////////////////////

EOT

$PG_GENERAL_ACTION->{javascript} = <<'EOT';
// javascript_action_here...
//     LHS_SV = {id : LHS_ID, child : SVs};
     LHS_SV = {id : LHS_ID, val : null, child : SVs};
EOT

# PG_TEMPLATE ???
###############################################################






##############################################################
sub list_has_string($$) { my ($ra, $s) = @_; return any {$_ eq $s} @$ra; }
sub list_has_int($$) { my ($ra, $s) = @_; return any {$_ == $s} @$ra; }
# sub list_in_index_range($$)  { my ($ra, $i) = @_; return $i < @$ra && $i >= 0; }


sub intlistset_add_element($$)
{
    my ($target, $n) = @_;
    push @$target, $n if ! list_has_int($target, $n)
}
sub intlistset_remove_element($$)
{
    my ($target, $n) = @_;

    my $i = 0;
    while ($i < @$target)
    {
        if($target->[$i] == $n) { splice(@$target,$i,1); }
        else {$i++;}
    }
}
sub intlistset_add($$)
{
    my ($target, $b) = @_;
    for my $n(@$b) { intlistset_add_element($target, $n); }
}
sub intlistset_sub($$)
{
    my ($target, $b) = @_;
    for my $n(@$b) { intlistset_remove_element($target, $n); }
}
sub intlistset_eq($$)
{
    my ($a, $b) = @_;
    for my $n(@$b) { return 0 if !list_has_int($a, $n); }
    for my $n(@$a) { return 0 if !list_has_int($b, $n); }
    return 1;
}
sub intlistset_has_intersection($$)
{
    my ($a, $b) = @_;
    for my $n(@$b) { return 1 if list_has_int($a,$n); }
    return 0;
}

##############################################################
# IntSet
{
    package IntSet;
    sub new
    {
        my ($class, @nums)=@_;
        my $self = {
            elements =>[],
            i=>{},
        };
        push @{$self->{elements}}, @nums;
        while (my ($i, $n) = each(@nums)) { $self->{i}->{$n}=$i; }

        bless $self, "IntSet"
    }
    sub has
    {
        my ($self, $num) = @_;
        my $i = $self->{i};
        return exists $i->{$num};
    }
    sub clone
    {
        my ($self) = @_;

        return IntSet->new( @{$self->{elements}} );
    }
    sub is_empty
    {
        my ($self) = @_;
        return scalar(@{$self->{elements}}) == 0;
    }
    sub to_array
    {
        my ($self) = @_;

        return @{$self->{elements}};
    }
    sub to_str
    {
        my ($self) = @_;

        return join(' ', @{$self->{elements}});
    }
    sub add_elements
    {
        my ($self, @nums) = @_;
        my $modified = 0;

        for my $n(@nums)
        {
            if (! $self->has($n))
            {
                push @{$self->{elements}}, $n;
                $self->{i}->{$n} = scalar(@{$self->{elements}}) - 1;
                $modified = 1;
            }
        }
        return $modified;
    }
    sub remove_elements
    {
        my ($self, @nums) = @_;
        my $modified = 0;

        my $i = $self->{i};
        for my $n(@nums)
        {
            if ($self->has($n))
            {
                splice(@{$self->{elements}}, $i->{$n}, 1);
                delete $i->{$n};
                $modified = 1;
            }
        }
        return $modified;
    }
    sub add
    {
        my ($self, $b) = @_;
        return $self->add_elements($b->to_array());
    }
    sub sub
    {
        my ($self, $b) = @_;
        return $self->remove_elements($b->to_array());
    }
    sub equal
    {
        my ($self, $b) = @_;
        for my $n(@{$b->{elements}})    { return 0 if !  $self->has($n); }
        for my $n(@{$self->{elements}}) { return 0 if !  $b->has($n);    }
        return 1;
    }
    sub has_intersection
    {
        my ($self, $b) = @_;
        for my $n(@{$b->{elements}}) { return 1 if $self->has($n); }
        return 0;
    }

    1;
}
##############################################################
# TokensSet
{
    package TokensSet;
    sub new
    {
        my ($class) = shift;
        my $self = {
            tmp_nt_symbols=>[],
            tmp_nt_symbol_index=>{},
            tmp_terminal_symbols=>[],
            tmp_terminal_symbol_index=>{},

            all_symbols=>[],
            all_symbol_index=>{},
            nt_symbol_i_min=>{},
            nt_symbol_i_max=>{},
            terminal_symbol_i_min=>{},
            terminal_symbol_i_max=>{},
        };
        # 後で tmp_nt_symbols、 tmp_nt_symbols_index、
        #     tmp_terminal_symbols_index は消して、
        # all_symbols, all_symbols_index を作る
        # 他、nt_symbols_i_min/max, terminal_symbols_min/max も作る
        #     all_symbol_i_min/max, も作る
        # 他、start_symbol, original_start_symbol, eot_symbol も作る
        #     start_symbol_i, original_start_symbol_i, eot_symbol_i も作る
        bless $self, "TokensSet"
    }
    sub add_terminal_symbols
    {
        my ($self, @slist) = @_;
        my $t_i = $self->{tmp_terminal_symbol_index};
        my $nt_i = $self->{tmp_nt_symbol_index};

        for my $s(@slist)
        {
            die "Error: Symbol '$s' conflicts\n" if (exists $t_i->{$s});
            die "Error: Symbol '$s' conflicts\n" if (exists $nt_i->{$s});

            push @{$self->{tmp_terminal_symbols}}, $s;
            $t_i->{$s} = scalar(@{$self->{tmp_terminal_symbols}}) -1;
        }
    }
    sub add_nt_symbols
    {
        my ($self, @slist) = @_;
        my $t_i = $self->{terminal_symbol_index};
        my $nt_i = $self->{tmp_nt_symbol_index};

        for my $s(@slist)
        {
            die "Error: Symbol '$s' conflicts\n" if (exists $t_i->{$s});
            die "Error: Symbol '$s' conflicts\n" if (exists $nt_i->{$s});

            push @{$self->{tmp_nt_symbols}}, $s;
            $nt_i->{$s} = scalar(@{$self->{tmp_nt_symbols}}) -1;
        }
    }
    sub set_start_symbol          { $_[0]->{start_symbol} = $_[1]; }
    sub set_original_start_symbol { $_[0]->{original_start_symbol} = $_[1]; }
    sub set_eot_symbol            { $_[0]->{eot_symbol} = $_[1]; }


    sub fix_terminal_symbols
    {
        my ($self) = @_;
        $self->{all_symbol_i_min} = scalar( @{$self->{all_symbols}} );
        $self->{terminal_symbol_i_min} = scalar( @{$self->{all_symbols}} );
        push @{$self->{all_symbols}}, @{$self->{tmp_terminal_symbols}};
        $self->{terminal_symbol_i_max} = scalar( @{$self->{all_symbols}} ) - 1;

        while (my ($i,$s) = each @{$self->{all_symbols}})
        {
            $self->{all_symbol_index}->{$s}=$i;
        }
    }

    sub finalize
    {
        my ($self) = @_;


        $self->{nt_symbol_i_min} = scalar( @{$self->{all_symbols}} );
        push @{$self->{all_symbols}}, @{$self->{tmp_nt_symbols}};
        $self->{nt_symbol_i_max} = scalar( @{$self->{all_symbols}} ) - 1;
        $self->{all_symbol_i_max} = scalar( @{$self->{all_symbols}} ) - 1;

        while (my ($i,$s) = each @{$self->{all_symbols}})
        {
            $self->{all_symbol_index}->{$s}=$i;
        }

        if(exists $self->{start_symbol})
        { $self->{start_symbol_i} = $self->str_to_i( $self->{start_symbol} ); }
        if(exists $self->{original_start_symbol})
        { $self->{original_start_symbol_i} = $self->str_to_i( $self->{original_start_symbol} ); }
        if(exists $self->{eot_symbol})
        { $self->{eot_symbol_i} = $self->str_to_i( $self->{eot_symbol} ); }

    }


    sub i_to_str
    {
        my ($self, $i) = @_;
        die "Error: Wrong symbol $i\n"
            if $i< $self->{all_symbol_i_min}
                or $i> $self->{all_symbol_i_max};
        return $self->{all_symbols}->[$i];
    }
    sub i_to_str_2
    {
        my ($self, $i) = @_;
        return -1 if $i == -1;
        die "Error: Wrong symbol $i\n"
            if $i< $self->{all_symbol_i_min}
                or $i> $self->{all_symbol_i_max};
        return $self->{all_symbols}->[$i];
    }
    sub str_to_i
    {
        my ($self, $s) = @_;
        die "Error: Wrong symbol '$s'\n"
            if ! exists $self->{all_symbol_index}->{$s};
        return $self->{all_symbol_index}->{$s};
    }
    sub is_terminal_symbol_i
    {
        my ($self, $i) = @_;
        return ($i >= $self->{terminal_symbol_i_min}
            and $i <= $self->{terminal_symbol_i_max});
    }
    sub is_terminal_symbol
    {
        my ($self, $s) = @_;
        return exists $self->{all_symbol_index}->{$s};
    }
    sub is_nt_symbol_i
    {
        my ($self, $i) = @_;
        return ($i >= $self->{nt_symbol_i_min}
            and $i <=$self->{nt_symbol_i_max});
    }
    sub is_symbol_i
    {
        my ($self, $i) = @_;
        return ($i >= $self->{all_symbol_i_min}
            and $i <=$self->{all_symbol_i_max});
    }


    sub terminal_symbols_i_list
    {
        my ($self, $rf) = @_;
        return ($self->{terminal_symbol_i_min} .. $self->{terminal_symbol_i_max});
    }
    sub nt_symbols_i_list
    {
        my ($self, $rf) = @_;
        return ($self->{nt_symbol_i_min} .. $self->{nt_symbol_i_max});
    }
    sub all_symbols_i_list
    {
        my ($self, $rf) = @_;
        return ($self->{all_symbol_i_min} .. $self->{all_symbol_i_max});
    }


    sub forall_terminal_symbols_i
    {
        my ($self, $rf) = @_;
        for my $i ($self->{terminal_symbol_i_min} .. $self->{terminal_symbol_i_max})
        {$rf->($i)}
    }
    sub forall_nt_symbols_i
    {
        my ($self, $rf) = @_;
        for my $i ($self->{nt_symbol_i_min} .. $self->{nt_symbol_i_max})
        {$rf->($i)}
    }
    sub forall_symbols_i
    {
        my ($self, $rf) = @_;
        for my $i ($self->{all_symbol_i_min} .. $self->{all_symbol_i_max})
        {$rf->($i)}
    }
    1;
}


my $TS = TokensSet->new();

sub symbols_i_set_to_str
{return join (" ",map {$TS->i_to_str_2($_)} $_[0]->to_array());}

##############################################################
#
# ルールを追加して開始記号を付け替え

my $eot_terminal_symbol = '(eot)';

my $original_start_symbol = $start_symbol;
$start_symbol = '(ADDED_START)';
unshift @rules_src, {lhs=>'(ADDED_START)', rhs=>[$original_start_symbol, $eot_terminal_symbol], action=>undef, r_pri=>0};

$TS->add_terminal_symbols(@Vt);
$TS->add_terminal_symbols($eot_terminal_symbol);
$TS->fix_terminal_symbols();

$TS->set_start_symbol($start_symbol);
$TS->set_original_start_symbol($original_start_symbol);
$TS->set_eot_symbol($eot_terminal_symbol);


our @rules;

# 上記変数(symbol.../rules)の初期化 (nonterminal symbol は start_symbol だけ)
{

    $TS->add_nt_symbols($start_symbol);

    ###############################################################
    # ここから rules の処理

    # まず左辺で nonterminal symbol を登録する
    # とともに rule_i, rule_no_by_nt を設定する
    {
        # rule_計算用
        my %nt_rule_count=();   # rule_計算用# rule_計算用

        $nt_rule_count{$start_symbol} = 0; # $start_symbol は登録済み
                                           # 後で key がなければ nt を新規登録
                                           #    するため

        while (my ($i,$src_rule) = each @rules_src)
        {
            my $nt = $src_rule->{lhs};

            if ($TS->is_terminal_symbol($nt))
            { die "Error: (rule[$i]) LHS of this rule must not be terminal symbol('$nt')!\n"; }

            if (exists $nt_rule_count{$nt})
            {
                $nt_rule_count{$nt}++;
            }
            else
            {
                # 非終端記号が登録済みでない場合
                $nt_rule_count{$nt} = 1;
                $TS->add_nt_symbols($nt);
            }

            $src_rule->{rule_i} = $i;
            $src_rule->{rule_no_by_nt} = $nt_rule_count{$nt},

            $rules[$i] = {
                rule_i => $i,
                rule_no_by_nt => $nt_rule_count{$nt},
                src => $src_rule,
            };

        }

        # all_symbols / all_symbol_index を設定
    }
    $TS->finalize();

    $TS->forall_symbols_i(sub{print $TS->i_to_str($_[0])." "});
    print "\n";


    # $rules_src から $rules に転記する (lhs, rhs, action, r_pri)
    while (my ($i,$src_rule) = each @rules_src)
    {
        $rules[$i]->{lhs} = $TS->str_to_i($src_rule->{lhs});
        # rhs は後で
        $rules[$i]->{action} = $src_rule->{action};
        $rules[$i]->{r_pri} = $src_rule->{r_pri};

        # 他に src, rule_i, rule_no_by_nt を置く(事前に配置済み)

        my $rhs_src = $src_rule->{rhs};

        my $rhs = [];
        @$rhs = map {$TS->str_to_i($_);} @$rhs_src;
        $rules[$i]->{rhs} = $rhs;
    }

    for my $i (0 .. $#rules)
    {
        my $rule = $rules[$i];
        my $str = '';
        my $rule_no_by_nt = $rule->{rule_no_by_nt};
        my $r_pri_str = '';
        my @rhs = map { $TS->i_to_str($_) } @{$rule->{rhs}};
        if ($rule->{r_pri}!=0) { $r_pri_str = '#' . $rule->{r_pri}; }

        print join (" ", $i, $TS->i_to_str($rule->{lhs})."($rule_no_by_nt)" , '::='
            , @rhs) . "\n";
    }
}
# ここまでで rules やトークン関連の設定終了
###############################################################
# First set の計算


my %first_set_cache=();

{
    # first_set_cache の初期化
    $first_set_cache{''} = IntSet->new(-1); # empty symbol
    $TS->forall_terminal_symbols_i(sub{
            my ($i)=@_;
            $first_set_cache{$i} = IntSet->new($i);
        });

    # ここから、非終端記号の Firstを計算
    $TS->forall_nt_symbols_i(sub{
            my ($i)=@_;
            $first_set_cache{$i} = IntSet->new();
        });


    # 繰り返し X→ abc ならば First(X) に First(abc) を追加
    my $need_next_iteration = 1;
    while ($need_next_iteration) # 追加されなくなるまで
    {
        $need_next_iteration = 0;
        for my $rule (reverse @rules)
        {
            # $rule->{lhs} の First を計算する。

            my @rhs_seq = @{$rule->{rhs}};  # Copy

            my $result_of_rhs = IntSet->new(); # First(rhs) の結果を入れる


            while (1)
            {
                if (! @rhs_seq)
                {
                    # (最初から)空なら
                    # add -1 to $result_of_rhs
                    # として First($rule->{lhs}) が $result_of_rhs となる
                    $result_of_rhs->add_elements(-1);
                    last;
                }
                my $head = shift @rhs_seq;
                if (@rhs_seq == 0
                        or ! $first_set_cache{$head}->has(-1))
                {
                    # $rhs_seq が1文字だけのとき
                    # と
                    # First($head) が空symbol列を含まない場合
                    # (これは $head が終端記号の場合を含む)
                    # 確定
                    # この場合、add First($head) to $result_of_rhs
                    # として First($rule->{lhs}) が $result_of_rhs となる
                    $result_of_rhs->add($first_set_cache{$head});
                    last;
                }

                {
                    # First($head) が空symbol列を含み @rhs_seq の長さが1以上

                    my $a = $first_set_cache{$head}->clone();
                    $a->remove_elements(-1);
                    $result_of_rhs->add($a);
                }
                # 繰り返し
                #     (注意)ここに到達するテストはまだしていない。
            }

            # ここまで (First(lhs) ではなく、) First(rhs) の計算!
            #     First(rhs) はとりあえずキャッシュしないでおく (しても良いが...)
            # ここから First(lhs) の更新
            # First(lhs) の更新版は First(lhs) に $result_of_rhs を追加したもの

            # ADD して、更新チェックする
            my $result_of_lhs = $first_set_cache{$rule->{lhs}}->clone();
            $result_of_lhs->add($result_of_rhs);

            # # 更新状況の確認
            # print "    Rule [$rule->{rule_i}] :"
            #     . symbols_i_set_to_str( $first_set_cache{$rule->{lhs}} )
            #     . " ===> "
            #     . symbols_i_set_to_str( $result_of_lhs )
            #     . "\n";
            

            # First($rule->{lhs}) の更新版が $result_of_lhs となる
            if (! $first_set_cache{$rule->{lhs}}->equal($result_of_lhs))
            {
                # 変更があった場合
                $need_next_iteration = 1;
                $first_set_cache{$rule->{lhs}} = $result_of_lhs;
                        # Copy しない
            }
        }
    }
}
sub FirstSet
{
    my (@symbol_seq) = @_;
    my $symbols_str = join("\t", @symbol_seq);
    if(exists $first_set_cache{$symbols_str})
    {
        return $first_set_cache{$symbols_str};
    }
    # 0文字は 上で処理されるので、以下 symbol_seq は1個以上
    # (1個のときは全てキャッシュに入っているはずではある)


    my $result_of_first = IntSet->new(); # First(symbol_seq) の結果を入れる

    while (1)
    {
        if (! @symbol_seq)
        {
            # (最初から)空なら
            # add -1 to $result_of_first 
            # として First($rule->{lhs}) が $result_of_first となる
            $result_of_first->add_elements(-1);
            last;
        }
        my $head = shift @symbol_seq;
        if (@symbol_seq == 0
                or ! $first_set_cache{$head}->has(-1))
        {
            # $symbol_seq が1文字だけのとき
            # と
            # First($head) が空symbol列を含まない場合
            # (これは $head が終端記号の場合を含む)
            # 確定
            # この場合、add First($head) to $result_of_first 
            # として First($rule->{lhs}) が $result_of_first となる
            $result_of_first->add($first_set_cache{$head});
            last;
        }

        {
            # First($head) が空symbol列を含み @rhs_seq の長さが1以上

            my $a = $first_set_cache{$head}->clone();
            $a->remove_elements(-1);
            $result_of_first->add($a);

        }
        # 繰り返し
    }

    # First($rule->{lhs}) の更新版が $result_of_first となる

    # $first_set_cache{$symbols_str} は存在しないはずなので
    $first_set_cache{$symbols_str} = $result_of_first->clone();
        # copy しない
    return $first_set_cache{$symbols_str};
}

print "(First Sets)\n";
{
    $TS->forall_symbols_i(sub{
            my ($i)=@_;
            my $s = $TS->i_to_str_2($i);
            print "First('$s') = ";
            my $f = FirstSet($TS->str_to_i($s));
            print join (" ", map {$TS->i_to_str_2($_);} $f->to_array());
            print " ----\n";
        });
}


###############################################################
# Follow set は不要だが、一応計算しておく
#
my %follow_set_cache=( $TS->{start_symbol_i} =>[] );
{
    my ($ntsymbol) = @_;
    # Follow(S) <=add= 終了記号 (不要)
    # A → αBβ な nt B 対して、 
    #     Follow(B) <=add= First(β)-{ε} 
    #     ε in First(β) または β=εなら Follow(B) <=add= Follow(A) 
    # 繰り返し(更新があるまで
    #
    # 全てのルール
    #     全て右辺要素
    #         非終端記号なら
    #             Follow の更新版を計算


    # ここから、非終端記号の Follow を計算
    $TS->forall_nt_symbols_i(sub {
            my ($i) = @_;
            $follow_set_cache{$i} = IntSet->new();
        });

    # 繰り返し   A → αBβ な nt B 対して、Follow(B) を追加
    my $need_next_iteration = 1;
    while ($need_next_iteration) # 追加されなくなるまで
    {
        $need_next_iteration = 0;
        for my $rule (@rules)
        {
            # $rule->{lhs} の First を計算する。
            my @rhs_seq = @{$rule->{rhs}};  # Copy

            while (1)
            {
                if (! @rhs_seq) { last; }

                my $head = shift @rhs_seq;

                if ($TS->is_nt_symbol_i($head))
                {
                    # follow($head) を更新
                    my $follow_result;

                    # A → αBβ な nt B($head) 対して、 
                    #     Follow(B) <=add= First(β(@rhs_seq))-{ε} 

                    my $first_of_rest = FirstSet(@rhs_seq)->clone();

                    $follow_result = $first_of_rest->clone(); # Copy again

                    $follow_result->remove_elements(-1);
                    $follow_result->add($follow_set_cache{$head});

                    #     ε in First(β) または β=εなら Follow(B) <=add= Follow(A) 
                    if ($first_of_rest->has(-1))
                    {
                        $follow_result->add($follow_set_cache{$rule->{lhs}});
                    }
                    # follow($head) の更新後の値が @follow_result に求まった

                    if (! $follow_set_cache{$head}->equal($follow_result))
                    {
                        # 現在の値 (@follow_result) と比較して
                        # 変更があった場合
                        $need_next_iteration = 1;
                        $follow_set_cache{$head} = $follow_result->clone();
                                # 一応 Copy にしている
                    }
                }

            }
        }
    }
}
sub FollowSet
{
    my ($nt) = @_;
    die "Error: No follows for '$nt'\n " if !exists $follow_set_cache{$nt};
    return $follow_set_cache{$nt};
}


print "(First Sets)\n";
{

    print "First('') = ";
    my $f = FirstSet();
    print symbols_i_set_to_str($f);
    print " ----\n";

    $TS->forall_symbols_i (sub {
        my ($i) = @_;
        my $s = $TS->i_to_str($i);

        print "First('$s') = ";
        my $f = FirstSet($TS->str_to_i($s));
        print symbols_i_set_to_str($f);
        print " ----\n";
    });
}

print "(Follow Sets)\n";
{
    $TS->forall_nt_symbols_i (sub {
        my ($i) = @_;
        my $s = $TS->i_to_str($i);

        print "Follow('$s') = ";
        my $f = FollowSet($i);
        print symbols_i_set_to_str($f);
        print " ----\n";
    });
}


# ******
    # First/Follow までで動作確認したら
    # intlist と symbols オブジェクトを作ってリファクタリング
    #
# 要チェック
# Package 
# method/function の返す配列リファレンスのデリファレンス方法のテスト

###############################################################

{
    # LR0term {rule => $rules_i, n_pos => $n_pos};
    #  new(rule_i,n_pos)
    #  -> equal(.)
    #  -> next_shift_symbol()
    #  -> gen_shift()
    #  -> can_reduce()
    #  -> to_str()
    #
    # その他 closure_LR0??
    # その他 goto_LR0??

    package LR0term;

    sub new
    {
        my ($class, $rules_i, $n_pos) = @_;
        my $self = {rule => $rules_i, n_pos => $n_pos};
        bless $self, "LR0term";
        return $self;
    }
    sub clone
    {
        my ($self) = @_;
        return LR0term->new($self->{rule}, $self->{n_pos});
    }
    sub equal
    {
        my ($self, $b) = @_;
        return ($self->{rule} == $b->{rule} and $self->{n_pos} == $b->{n_pos});
    }
    sub next_shift_symbol
    {
        my ($self) = @_;

        if ( $self->{n_pos} >= @{$main::rules[$self->{rule}]->{rhs}} )
        { return -1;}
        else
        { return $main::rules[$self->{rule}]->{rhs}->[ $self->{n_pos} ] };
    }
    sub gen_shift
    {
        my ($self) = @_;
        main::confess "Error: gen_shift() : Can not shift the term\n"
            if $self->{n_pos} >= scalar(@{$main::rules[$self->{rule}]->{rhs}});
        return LR0term->new($self->{rule}, $self->{n_pos} + 1);
    }
    sub can_reduce
    {
        my ($self) = @_;
        return $self->{n_pos} == @{$main::rules[$self->{rule}]->{rhs}};
    }
    sub to_str
    {
        my ($self) = @_;
        my $cur = "<*>";
        $cur = "<*#>" if $self->can_reduce();
        my @seq = map { $TS->i_to_str($_) } @{$main::rules[$self->{rule}]->{rhs}};
        splice(@seq, $self->{n_pos}, 0, $cur);

        my $r_pri = $main::rules[$self->{rule}]->{r_pri};
        my $r_pri_str = '';
        $r_pri_str = "   [r_pri=$r_pri]" if $r_pri != 0;

        return $TS->i_to_str( $main::rules[$self->{rule}]->{lhs} )
            . " ::= " . join(" ",  @seq) . $r_pri_str;
    }
}
###############################################################
{
    package ArrayBasedGeneralSet;

    # override? sub new(self,e...)
    # override? sub add_elements(self,e...)
    # override? sub remove_elements(self,e...)
    # override? sub has(self,e)
    # abstract  sub element_equal(self,e1,e2)
    # abstract  sub element_clone(self,e)

    sub new
    {
        my ($class, @elems)=@_;
        my $self = {
            elements =>[],
            #    i=>{},
        };

        bless $self, $class;
        $self->add_elements(@elems);
        return $self;
    }
    # sub new
    # {
    #     # Note: must override 'clone' if override 'new'
    #     my ($class, @elems)=@_;
    #     my $self = $class->SUPER::new();

    #     #
    #     return $self;
    # }
    sub clone
    {
        my ($self) = @_;
        # die "...\n" unless $self isa 'ArrayBasedGeneralSet'

        return new( ref($self), map {$self->element_clone($_) } @{$self->{elements}} );
    }
    sub has
    {
        my ($self, $e) = @_;

        for (my $n = scalar(@{$self->{elements}}) - 1; $n >=0; $n--)
        {
            return 1 if $self->element_equal($self->{elements}->[$n], $e);
        }
        return 0;
    }
    sub is_empty
    {
        my ($self) = @_;
        return scalar(@{$self->{elements}}) == 0;
    }
    sub to_array
    {
        my ($self) = @_;

        return map {$self->element_clone($_) } @{$self->{elements}};
    }
    sub raw_array_element
    {
        my ($self) = @_;

        return $self->{elements};
    }
    sub add_elements
    {
        my ($self, @elems) = @_;
        my $modified = 0;
        for my $e(@elems)
        {
            if (! $self->has($e))
            {
                push @{$self->{elements}}, $self->element_clone($e);
                $modified = 1;
            }
        }
        return $modified;
    }
    sub remove_elements
    {
        my ($self, @elems) = @_;

        my $modified = 0;
        for (my $n = scalar(@{$self->{elements}}) - 1; $n >=0; $n--)
        {
            my $nth_elem = $self->{elements}->[$n];
            for my $e(@elems)
            {
                if ($self->element_equal($e, $nth_elem))
                {
                    splice(@{$self->{elements}}, $n, 1);
                    $modified = 1;
                    last; # quit inner for-loop and proceed to next $n
                }
            }
        }
        return $modified;
    }
    sub add
    {
        my ($self, $b) = @_;
        return $self->add_elements($b->to_array());
    }
    sub sub
    {
        my ($self, $b) = @_;
        return $self->remove_elements(@{$b->{elements}}); # clone 不要なので add と違う
    }
    sub equal
    {
        my ($self, $b) = @_;
        for my $n(@{$b->{elements}})    { return 0 if !  $self->has($n); }
        for my $n(@{$self->{elements}}) { return 0 if !  $b->has($n);    }
        return 1;
    }
    sub has_intersection
    {
        my ($self, $b) = @_;
        for my $n(@{$b->{elements}}) { return 1 if $self->has($n); }
        return 0;
    }

    1;
}
###############################################################
{
    package LR0termSet;
    our @ISA = ('ArrayBasedGeneralSet');

    # override? sub new(self,e...)
    # override? sub add_elements(self,e...)
    # override? sub remove_elements(self,e...)
    # override? sub has(self,e)
    # abstract  sub element_equal(self,e1,e2)
    # abstract  sub element_clone(self,e)

    sub element_equal
    {
        my ($self, $e1, $e2) = @_;
        return $e1->equal($e2);
    }
    sub element_clone
    {
        my ($self, $e) = @_;
        return $e->clone();
    }


    sub LR0termSet_closure
    {
        my ($self) = @_;

        my $result_set = $self->clone();
        my $need_next_iteration = 1;
        while($need_next_iteration)
        {
            $need_next_iteration = 0;
            my @current_lr0terms = $result_set->to_array();
            for my $term(@current_lr0terms)
            {
                my $nx = $term->next_shift_symbol();
                if ($nx >= 0 and $TS->is_nt_symbol_i($nx))
                {
                    while (my ($i, $rule) = each @main::rules)
                    {
                        if ($rule->{lhs} == $nx)
                        {
                            my $adding_term = LR0term->new($i,0);
                            if (! $result_set->has($adding_term))
                            {
                                $need_next_iteration = 1;
                                $result_set->add_elements($adding_term);
                            }
                        }
                    }
                }
            }
        }
        return $result_set;
    }
    sub LR0termSet_goto
    {
        my ($self, $symbol_i) = @_;
        my $pre_closure_set = LR0termSet->new();

        die "Error: LR0termSet_goto arg1(symbol_i) < 0" if $symbol_i < 0;
        for my $term(@{$self->{elements}})
        {
            if ($symbol_i == $term->next_shift_symbol())
            {
                $pre_closure_set->add_elements(
                    LR0term->new($term->{rule}, $term->{n_pos} + 1) );
            }
        }
        return $pre_closure_set->LR0termSet_closure();
    }



    1;
}

###############################################################
# LR0term の動作テスト
#     少し表示
print "(LR0 term examples)\n";
{
    while (my ($i,$rule) = each(@rules))
    {
        my $t = LR0term->new($i,1);
        print "    $i : " . $t->to_str() . "\n";
    }

}
#
#     LR0termSet::closure のテスト
#         [1] E + _ T の(pos=2) で
print "(LR0 terms closure)\n";
{
    my $term1 = LR0term->new(1,2);  # E -> E + <> T
    my $term1set = LR0termSet->new($term1);
    my $closure_result = $term1set->LR0termSet_closure();
    print "    src:  " . $term1->to_str() . "\n";
    print "    closure({src}):\n";
    for my $term_i($closure_result->to_array())
    {
        print "        " . $term_i->to_str() ."\n";
    }
}
#     R0termSet::go_to を作ってみる。

print "(LR0 terms goto) OMIT\n"; # (文法んみ依存するので 四則演算のみ...)
# {
#     my $term1 = LR0term->new(3,1);  # T -> T + F
#     my $term1set = LR0termSet->new($term1);
#     my $s = '*'; # symbol '*'
#     my $s_i = $TS->str_to_i($s);
#     my $goto_result = $term1set->LR0termSet_goto($s_i);
#     print "    from --- symbol:" . $term1->to_str() . " --- '$s'\n";;
#     print "    closure({src}):\n";
#     for my $term_i($goto_result->to_array())
#     {
#         print "        " . $term_i->to_str() ."\n";
#     }
# }
#
#
#
# ****
# ここまで動作テストすべき?
#     R0termSet:: 状態表 (遷移表)を作ってみる
print "(LR0 state)\n";
{
    my @LR0state_array;
    my @all_symbols_i_list = $TS->all_symbols_i_list();

    {
        my $term1 = LR0term->new(0,0);  # (added_S) -> <*> S '(eot)'
        my $init_LR0terms = LR0termSet->new($term1)->LR0termSet_closure();
        my $init_state_index = scalar(@LR0state_array);
        my $init_state = {
            LR0terms=>$init_LR0terms,
            index=>$init_state_index,
            transition=>{},
        };
        push @LR0state_array, $init_state;
    }

    # my $need_next_iteration = 1; # これは不要
    # while($need_next_iteration)  # これも不要
    {
        # $need_next_iteration = 0; # これも不要

        for (my $state_index = 0; $state_index < @LR0state_array; $state_index++)
        {
            my $current_state = $LR0state_array[$state_index];

            for my $symbol_i (@all_symbols_i_list)
            {

                my $next_goto_set = $current_state->{LR0terms}->LR0termSet_goto($symbol_i);
                if (!$next_goto_set->is_empty())
                {
                    my $next_state = first {$next_goto_set->equal($_->{LR0terms});} @LR0state_array;
                    if (!$next_state)
                    {
                        # 求めた goto が
                        #         **空集合ではなく**、 新しい状態なら
                        #     追加し、$need_next_iteration=1
                        my $next_state_index = scalar(@LR0state_array);
                        $next_state = {
                            LR0terms=>$next_goto_set,
                            index=>$next_state_index,
                            transition=>{},
                        };
                        push @LR0state_array, $next_state;
                        # $need_next_iteration = 1; # これも不要
                    }
                    $current_state->{transition}->{$symbol_i} = $next_state->{index};
                }
            }
        }
    }
    # そして表示

    for my $state(@LR0state_array)
    {
        print "    State $state->{index}";
        print " ( " . join("  ",
            map {"'" . $TS->i_to_str($_). "'/s" . $state->{transition}->{$_}}
            grep {exists $state->{transition}->{$_}}
            @all_symbols_i_list
        ). " )\n";


        for my $term($state->{LR0terms}->to_array())
        {
            print "        " . $term->to_str() . "\n"
        }
    }
}

# ここまで動作確認した
###############################################################

{
    package LR1item_fss;
    # core_equal

    sub new
    {
        my ($class, $rules_i, $n_pos, @follow_symbols) = @_;

        if (@follow_symbols && ref($follow_symbols[0]) ne '')
        {
            main::confess "Error: Init value of symbols must be integer (" . ref($follow_symbols[0]) . " is given)!\n";
        }

        my $self = {
            LR0term => LR0term->new($rules_i, $n_pos),
            fss => IntSet->new(@follow_symbols),
        };
        bless $self, "LR1item_fss";
        return $self;
    }
    sub clone
    {
        my ($self) = @_;
        return LR1item_fss->new( $self->{LR0term}->{rule},
            $self->{LR0term}->{n_pos}, $self->{fss}->to_array() );
    }
    sub equal
    {
        my ($self, $b) = @_;
        return ( $self->{LR0term}->equal($b->{LR0term})
            and $self->{fss}->equal($b->{fss}) );
    }
    sub LR0term_equal
    {
        my ($self, $b) = @_;
        return $self->{LR0term}->equal($b->{LR0term});
    }
    sub to_str
    {
        my ($self) = @_;
        my $str = $self->{LR0term}->to_str() . "    follow(";
        $str .= join " ", map {$TS->i_to_str($_);} $self->{fss}->to_array();
        $str .= ")";
        return $str;
    }

    1;
}
{
    package LR1item_fss_Set;;
    sub new
    {
        my ($class, @elems)=@_;
        my $self = {
            elements =>[],
            #    i=>{},
        };

        bless $self, $class;
        $self->add_elements(@elems);
        return $self;
    }
    sub clone
    {
        my ($self) = @_;
        # die "...\n" unless $self isa 'ArrayBasedGeneralSet'

        return new( ref($self), map {$_->clone()} @{$self->{elements}} );
    }
    sub has
    {
        my ($self, $e) = @_;
        main::assert_args('LR1item_fss' , $e);

        # fss が等しくなければ包含関係があっても、has は成立しない

        for (my $n = 0;$n < scalar(@{$self->{elements}}); $n++)
        {
            return 1 if $self->{elements}->[$n]->equal($e);
        }
        return 0;
    }
    sub has_LR0term
    {
        my ($self, $LR0term1) = @_;
        main::assert_args ('LR0term', $LR0term1);

        for (my $n = 0;$n < scalar(@{$self->{elements}}); $n++)
        {
            return 1 if $self->{elements}->[$n]->{LR0term}->equal($LR0term1);
        }
        return 0;
    }
    sub first_LR0term_match
    {
        my ($self, $LR0term1) = @_;

        for (my $n = 0;$n < scalar(@{$self->{elements}}); $n++)
        {
            return $self->{elements}->[$n] if $self->{elements}->[$n]->{LR0term}->equal($LR0term1);
        }
        return undef;
    }
    sub is_empty
    {
        my ($self) = @_;
        return scalar(@{$self->{elements}}) == 0;
    }
    sub to_array
    {
        my ($self) = @_;

        return map {$_->clone()} @{$self->{elements}};
    }
    sub raw_array_element
    {
        my ($self) = @_;

        return $self->{elements};
    }
    sub add_elements
    {
        my ($self, @elems) = @_;
        my $modified = 0;
        my $core_modified = 0;
        for my $e(@elems)
        {
            my $e0 = $self->first_LR0term_match($e->{LR0term});
            if (! defined $e0)
            {
                push @{$self->{elements}}, $e->clone();
                $modified = 1;
                $core_modified = 1;
            }
            elsif(! $e0->{fss}->equal($e->{fss}))
            {
                # $e0 defined   and fss not equals

                $modified = $e0->{fss}->add($e->{fss}) 
                # $core_modified = 1;
            }
            # else do nothing

        }
        return $modified + 2*$core_modified;
        # 1: コアは変化ないが変更された
        # 3: コアも変更された
    }
    # sub remove_elements
    # {
    #     my ($self, @elems) = @_;

    #     for (my $n = scalar(@{$self->{elements}}) - 1; $n >=0; $n--)
    #     {
    #         my $nth_elem = $self->{elements}->[$n];
    #         for my $e(@elems)
    #         {
    #             if ($self->element_equal($e, $nth_elem))
    #             {
    #                 splice(@{$self->{elements}}, $n, 1);
    #                 last; # quit inner for-loop and proceed to next $n
    #             }
    #         }
    #     }
    # }
    sub add
    {
        my ($self, $b) = @_;
        return $self->add_elements($b->to_array());
        # 1: コアは変化ないが変更された
        # 3: コアも変更された
    }
    # sub sub
    # {
    #     my ($self, $b) = @_;
    #     $self->remove_elements(@{$b->{elements}}); # clone 不要なので add と違う
    # }
    sub equal
    {
        my ($self, $b) = @_;
        for my $n(@{$b->{elements}})    { return 0 if !  $self->has($n); }
        for my $n(@{$self->{elements}}) { return 0 if !  $b->has($n);    }
        return 1;
    }
    sub core_equal
    {
        my ($self, $b) = @_;
        for my $n(@{$b->{elements}})    { return 0 if !  $self->has_LR0term($n->{LR0term}); }
        for my $n(@{$self->{elements}}) { return 0 if !  $b->has_LR0term($n->{LR0term});    }
        return 1;
    }
    # sub has_intersection
    # {
    #     my ($self, $b) = @_;
    #     for my $n(@{$b->{elements}}) { return 1 if $self->has($n); }
    #     return 0;
    # }


    sub LR1item_fss_Set_closure
    {
        my ($self) = @_;

        my $result_set = $self->clone();
        my $need_next_iteration = 1;
        while($need_next_iteration)
        {
            $need_next_iteration = 0;
            my @current_lr0items = $result_set->to_array();
            for my $item(@current_lr0items)
            {
                my $nx = $item->{LR0term}->next_shift_symbol();
                if ($nx >= 0 and $TS->is_nt_symbol_i($nx))
                {
                    # $item の右辺の (n_pos+1..最後 , -1) の配列にたいして、
                    # 最後の -1 を s in item->fss に置き換えたものの FIrstSet を
                    # 求めて、全部 s についての和集合を求める
                    my @seq_f=();
                    my $i_rest;
                    for ($i_rest = $item->{LR0term}->{n_pos} +1
                        ; $i_rest < @{$main::rules[$item->{LR0term}->{rule}]->{rhs}}
                        ; $i_rest++)
                    {
                        push @seq_f, $main::rules[$item->{LR0term}->{rule}]->{rhs}->[$i_rest];
                    }
                    my $i_last = @seq_f;
                    push @seq_f, -1;

                    my $fss = new IntSet();
                    for my $forward_symbol($item->{fss}->to_array())
                    {
                        $seq_f[$i_last] = $forward_symbol;
                        $fss->add(main::FirstSet(@seq_f));
                    }


                    while (my ($i, $rule) = each @main::rules)
                    {
                        if ($rule->{lhs} == $nx)
                        {
                            # LR0term->new($i, 0),fss=? が加える
                            #     LR0item   ($i のルールが $rule)



                            my $adding_item = LR1item_fss->new($i,0,$fss->to_array());


                            my $modified = $result_set->add_elements($adding_item);
                            if ($modified) { $need_next_iteration = 1; }


                        }
                    }
                }
            }
        }
        return $result_set;
    }


    sub LR1item_fss_Set_goto
    {
        my ($self, $symbol_i) = @_;
        my $pre_closure_set = LR1item_fss_Set->new();

        die "Error: LR1item_fss_Set_goto arg1(symbol_i) < 0" if $symbol_i < 0;
        for my $term(@{$self->{elements}})
        {
            if ($symbol_i == $term->{LR0term}->next_shift_symbol())
            {
                my $e = $term->clone();
                $e->{LR0term} = $e->{LR0term}->gen_shift();
                $pre_closure_set->add_elements($e);
            }
        }
        return $pre_closure_set->LR1item_fss_Set_closure();
    }

    1;
}
###############################################################
# LR1item_fss_Set_closure の動作確認
pop @{$rules_src[0]->{rhs}};
pop @{$rules[0]->{rhs}};
print "Modified rule0: ";
{
    my $i = 0;
    my @rhs = map { $TS->i_to_str($_) } @{$rules[$i]->{rhs}};
    # if ($rules[$i]->{r_pri}!=0) { $r_pri_str = '#' . $rules[$i]->{r_pri}; }
    # あと $rule_no_by_nt

    print join (" ", $i, $TS->i_to_str($rules[$i]->{lhs}) , '::='
        , @rhs) . "\n";
}
print "(LR1 Closure of {[rule0 pos0 eot]}\n";
{

    my $item_set_1 = LR1item_fss_Set->new(LR1item_fss->new(0,0,$TS->{eot_symbol_i}));
    my $closure1 = $item_set_1->LR1item_fss_Set_closure();
    for my $item($closure1->to_array())
    {
        print "    " . $item->to_str() . "\n";
    }
}
# LR1 goto の動作確認
# # これも文法依存なので省略 ↓は四則演算のみ
# {
#     my $item_set_1 = LR1item_fss_Set->new(LR1item_fss->new(0,0,$TS->{eot_symbol_i}));
#     my $closure1 = $item_set_1->LR1item_fss_Set_closure();
#     my $item_set_2 = $closure1->LR1item_fss_Set_goto($TS->str_to_i('T'));
#     print "(LR1 GOTO (Closure ({[rule0 pos0 eot]}), T)\n";
#     for my $item($item_set_2->to_array())
#     {
#         print "    " . $item->to_str() . "\n";
#     }
#     my $item_set_3 = $closure1->LR1item_fss_Set_goto($TS->str_to_i('('))
#         ->LR1item_fss_Set_goto($TS->str_to_i('T'));
#     print "(LR1 Closure({[rule0 pos0 eot]})->goto('(')->goto(T)\n";
#     for my $item($item_set_3->to_array())
#     {
#         print "    " . $item->to_str() . "\n";
#     }
# }

# LR1 状態表 (遷移表)
print "(LR1 state list)\n";
{
    my @LR1state_array;
    my @all_symbols_i_list = $TS->all_symbols_i_list();

    {
        my $item1 = LR1item_fss->new(0,0,$TS->{eot_symbol_i});  # (added_S) -> <*> S
        my $init_LR1items = LR1item_fss_Set->new($item1)->LR1item_fss_Set_closure();
        my $init_state_index = scalar(@LR1state_array);
        my $init_state = {
            LR1items=>$init_LR1items,
            index=>$init_state_index,
            transition=>{},
            # modified=>1,
        };
        push @LR1state_array, $init_state;
    }

    # my $need_next_iteration = 1; # これは不要
    # while($need_next_iteration)  # これも不要
    {
        # $need_next_iteration = 0; # これも不要

        for (my $state_index = 0; $state_index < @LR1state_array; $state_index++)
        {
            my $current_state = $LR1state_array[$state_index];

            for my $symbol_i (@all_symbols_i_list)
            {
                my $next_goto_set = $current_state->{LR1items}->LR1item_fss_Set_goto($symbol_i);
                if (!$next_goto_set->is_empty())
                {
                    my $next_state = first {$next_goto_set->equal($_->{LR1items});} @LR1state_array;
                    if (!$next_state)
                    {
                        # 求めた goto が
                        #         **空集合ではなく**、 新しい状態なら
                        #     追加し、$need_next_iteration=1
                        my $next_state_index = scalar(@LR1state_array);
                        $next_state = {
                            LR1items=>$next_goto_set,
                            index=>$next_state_index,
                            transition=>{},
                            # modified=>1,
                        };
                        push @LR1state_array, $next_state;
                        # $need_next_iteration = 1; # これも不要
                    }
                    $current_state->{transition}->{$symbol_i} = $next_state->{index};
                }
            }
        }
    }
    # そして表示

    for my $state(@LR1state_array)
    {
        print "    State $state->{index}";
        print " ( " . join("  ",
            map {"'" . $TS->i_to_str($_). "'/s" . $state->{transition}->{$_}}
            grep {exists $state->{transition}->{$_}}
            @all_symbols_i_list
        ). " )\n";

        for my $item($state->{LR1items}->to_array())
        {
            print "        " . $item->to_str() . "\n"
        }
    }
}
#
# LALR1 状態表 (遷移表)
print "(LALR1 state list)\n";
my @LALR1state_table_i;
my @LALR1state_table_str;
{
    my @LALR1state_array;
    my @all_symbols_i_list = $TS->all_symbols_i_list();

    {
        my $item1 = LR1item_fss->new(0,0,$TS->{eot_symbol_i});  # (added_S) -> <*> S
        my $init_LR1items = LR1item_fss_Set->new($item1)->LR1item_fss_Set_closure();
        my $init_state_index = scalar(@LALR1state_array);
        my $init_state = {
            LR1items=>$init_LR1items,
            index=>$init_state_index,
            transition=>{},
            modified=>1,
        };
        push @LALR1state_array, $init_state;
    }

    my $need_next_iteration = 1; # これは不要
    while($need_next_iteration)  # これも不要
    {
        $need_next_iteration = 0; # これも不要

        for (my $state_index = 0; $state_index < @LALR1state_array; $state_index++)
        {
            my $current_state = $LALR1state_array[$state_index];
            next if !$current_state->{modified};
            $current_state->{modified} = 0;


            for my $symbol_i (@all_symbols_i_list)
            {
                my $next_goto_set = $current_state->{LR1items}->LR1item_fss_Set_goto($symbol_i);
                if (!$next_goto_set->is_empty())
                {
                    # 求めた goto が空集合ではなければ
                    #     状態を追加して、遷移先として登録
                    #     (ただし core が等しい状態があればマージして使う)
                    #     (   完全に等しい状態があればそれを使う)

                    my $next_state = first {$next_goto_set->core_equal($_->{LR1items});} @LALR1state_array;
                    if (!$next_state)
                    {
                        # コアが等しい状態が見つからなければ、完全新規状態を作る
                        #   (for の最後でケアされるから
                        #      $need_next_iteration=1 は不要)
                        my $next_state_index = scalar(@LALR1state_array);
                        $next_state = {
                            LR1items=>$next_goto_set,
                            index=>$next_state_index,
                            transition=>{},
                            modified=>1,
                        };
                        push @LALR1state_array, $next_state;
                        # $need_next_iteration = 1; # これは不要 (for の最後でケアされるから)
                    }
                    else
                    {
                        # コアが等しい状態がみつかって ($next_state に)
                        #     それが、先読み記号も含めた完全一致ならなにもしない
                        #     先読み記号のみ違うなら マージする
                        #        そしてマージして変更が起きたら再処理する
                        if ($next_state->{LR1items}->equal($next_goto_set))
                        {}
                        else
                        {
                            my $modified = $next_state->{LR1items}->add($next_goto_set);
                            if ($modified)
                            {
                                $next_state->{modified} = 1;
                                $need_next_iteration = 1;
                            }
                        }
                    }
                    $current_state->{transition}->{$symbol_i} = $next_state->{index};
                }
            }
        }
    }

    # ここまでで @LALR1state_array が desc_for debug 以外は作成完了

    ##################################################################
    # そして表示 (デバッグ用出力文字列を生成して、表示する)

    for my $state(@LALR1state_array)
    {
        my $d; # デバッグ用出力文字列
        $d=    "    State $state->{index}";
        $d=$d. " shift_trans( " . join("  ",
            map {"'" . $TS->i_to_str($_). "'/s" . $state->{transition}->{$_}}
            grep {exists $state->{transition}->{$_}}
            @all_symbols_i_list
        ). " )\n";

        for my $item($state->{LR1items}->to_array())
        {
            # $item: LR1item_fss
            # $item->{LR0term}: LR0term
            # $item->{LR0term}->{rule} : int(ルール番号)
            $d=$d. "        rule$item->{LR0term}->{rule}:  " . $item->to_str();
            $d=$d. "        reduce_if_follow(" . join(" ",
                map {"'" . $TS->i_to_str($_). "'"}
                  $item->{fss}->to_array()
              ). ")" if $item->{LR0term}->can_reduce();
            $d=$d. "\n";
        }
        print $d;
        $state->{desc_for_debug} = $d;


    }
    # パーサ用の遷移表を @LALR1state_table_str / _i に生成
    #
    my @conflict_errors = ();
    for my $state(@LALR1state_array)
    {
        my $table_state = {
            desc_for_debug => $state->{desc_for_debug},
            index => $state->{index},
            next_s_r => {},
        };
        for my $symbol_i(@all_symbols_i_list)
        {
            my @next_s_r=();
            # シフト可能か?
            if (exists $state->{transition}->{$symbol_i})
            {
                push @next_s_r, {
                    is_shift => 1,
                    pri => 0,
                    trans_to => $state->{transition}->{$symbol_i},
                };
            }
            # reduce 可能なものをすべて挙げる
            for my $item($state->{LR1items}->to_array())
            {
                # $item: LR1item_fss
                # $item->{LR0term}: LR0term
                # $item->{LR0term}->{rule} : int(ルール番号)
    #my $r_pri = $main::rules[$self->{rule}]->{r_pri};
    #
    #
                if ( $item->{LR0term}->can_reduce() && $item->{fss}->has($symbol_i) )
                {
                    my $rule_i = $item->{LR0term}->{rule};
                    my $rule_ref = $main::rules[$rule_i];
                    my $lhs = $TS->i_to_str(
                        $rule_ref->{lhs} );
                    my @rhs = map {$TS->i_to_str($_) }
                        @{$rule_ref->{rhs}};

                    push @next_s_r, {
                        is_shift => 0,
                        pri => $rule_ref->{r_pri},
                        reduce_lhs => $lhs,
                        reduce_rhs => [@rhs],
                        rule_i => $rule_i,
                        rule_no_by_nt => $rule_ref->{rule_no_by_nt},
                        action => $rule_ref->{action},
                    };
                }
            }
            # @next_s_r はここまでで確定

            # 無ければ無視、1個なら登録、
            if (@next_s_r == 0)
            {}
            elsif (@next_s_r == 1)
            {
                $table_state->{next_s_r}->{$TS->i_to_str($symbol_i)}
                    = $next_s_r[0];
            }
            else
            {
                # 候補が2個以上ある場合
                #     priority で選別して、
                #     選別できなければエラー
                # pri の最大を求める。
                my $pri_max = $next_s_r[0]->{pri};
                for my $next_s_r_item(@next_s_r)
                {
                    if ($pri_max < $next_s_r_item->{pri})
                    { $pri_max = $next_s_r_item->{pri}; }
                }

                my @next_s_r_top = grep { $pri_max == $_->{pri}; } @next_s_r;

                if ( @next_s_r_top == 0)
                {
                    # ありえないので die
                    die "Internal Error...\n $state->{desc_for_debug}\n\nError: state: $state->{index} token:$TS->i_to_str($symbol_i): fails to find pri_max action!\n";
                }
                elsif ( @next_s_r_top == 1)
                {
                    $table_state->{next_s_r}->{$TS->i_to_str($symbol_i)}
                        = $next_s_r[0];
                }
                else
                {
                    # おなじ priority が複数存在する。
                    my $err_msg = "Error: state: $state->{index} token:$TS->i_to_str($symbol_i): conflict!\n";
                    for my $next_s_r_item(@next_s_r)
                    {
                        if ($next_s_r_item->{is_shift})
                        {
                            if ($next_s_r_item->{pri} == $pri_max)
                            { $err_msg.= "    * can shift (pri = $next_s_r_item->{pri})\n"; }
                            else
                            { $err_msg.= "      ( can shift (pri = $next_s_r_item->{pri}))\n"; }
                        }
                        else
                        {
                            # reduce なら
                            if ($next_s_r_item->{pri} == $pri_max)
                            { $err_msg.= "    * can reduce rule $next_s_r_item->{rule_i} (pri = $next_s_r_item->{pri})\n"; }
                            else
                            { $err_msg.= "      (can reduce rule $next_s_r_item->{rule_i} (pri = $next_s_r_item->{pri}))\n"; }
                        }
                    }
                    push @conflict_errors, $err_msg.$state->{desc_for_debug}."\n";
                }
            }
        }
        push @LALR1state_table_str, $table_state;
    }
    if (@conflict_errors)
    {
        die join("\n", @conflict_errors). "Error exit!\n";
    }
    # パーサ用の遷移表 @LALR1state_table_str が完成
}
print "\n";

#
############################
# @LALR1state_table  を使った parser example
############################

###############################################################
###############################################################
###############################################################
# Emit Helper Functions: 150 lines
#
#     qq_string str     a"${ => "a\"\$"{"
#     foreach_abc [first,mid,last,first_last], \@target, sub {$_[0] ...} ;
#     untrim_abc \@target, [first, mid, last, first_last, frontstr, tailstr], ...;
#     untrim_join_abc \@target, [first, mid, last, first_last, frontstr, tailstr], ...;
#         returns result_str (non-destructive)
#     kv_q_strs_by_keys \%target_hash, @keys   (returns string array)
#     kv_raws_by_keys \%target_hash, @keys   (returns string array)
#
#
###############################################################
use Carp;
use Scalar::Util;

###############################################################
# qq_string str     a"${ => "a\"\$"{"
sub qq_string($)
{
    my ($src) = @_;
    $src =~ s/\\/\\\\/g ;
    $src =~ s/([\'\"\$\@\&\{\}\/\(\)\[\]\#])/\\$1/g ;
    $src =~ s/\t/\\t/g ;
    $src =~ s/\r//g ;
    $src =~ s/\n/\\n/g ;
    return q{"} . $src . q{"};
}
###############################################################
# foreach_abc [first,mid,last,first_last], ref_array, ref_f
sub foreach_abc ($$$)
{
    my ($ra_flags, $ra_target, $rf_do) = @_;
    if (Scalar::Util::reftype($ra_flags) ne 'ARRAY')
    {
        croak "Err: 1st arg of 'foreach_abc()' is not ref to array.\n"
        . "  It must be ref to array that contains [first_f, mid_f, last_f]!\n";
    }
    if (@$ra_flags != 4)
    {
        croak "Err: Invalid size of 1st arg of 'foreach_abc'.\n"
        . "  It must be ref to array that contains [first_flag, mid_flag, last_flag, first_last_flag]!\n";
    }
    if (Scalar::Util::reftype($ra_target) ne 'ARRAY')
    {
        croak "Err: 2nd arg of 'foreach_abc()' is not ref to (target) array.\n";
    }
    if (Scalar::Util::reftype($rf_do) ne 'CODE')
    {
        croak "Err: 3rd arg of 'foreach_abc()' is not ref to function.\n";
    }
    my ($first, $mid, $last, $first_last) = @$ra_flags;
    my $n = @$ra_target;
    my $i;
    if ($n == 0) { return; }
    if ($n == 1) { if ($first_last) {$rf_do->($ra_target->[0])} return; }


    $rf_do->($ra_target->[0]) if $first;

    if ($mid)
    {
        for ($i = 1; $i <= $n - 2 ; $i++) { $rf_do->($ra_target->[$i]); }
    }

    $rf_do->($ra_target->[$n - 1]) if $last;

    # essentially $rf_do->(..) is called by call-by-ref
    #   (in spite of its no-ref looks)
}




###############################################################
# untrim_abc \@target, [first, mid, last, first_last, frontstr, tailstr], ...;
sub untrim_abc ($@)
{
    my $ra_target = shift @_;
    my @abc_all = @_;
    if (Scalar::Util::reftype($ra_target) ne 'ARRAY')
    {
        Carp::cluck "Err: 1st arg of 'untrim_abc()' is not ref to (target)array.\n";
    }
    for my $i ( 0 .. $#abc_all)
    {
        my $x = $abc_all[$i];
        if (Scalar::Util::reftype($x) ne 'ARRAY')
        {
            Carp::cluck "Err: @{[$i+1]}th arg of 'untrim_abc()' is not ref to array.\n"
            . "It is expected to be ref to array [first_f, mid_f, last_f, frontstr, tailstr]!\n";
        }
        if (@$x != 6)
        {
            Carp::cluck "Err: @{[$i+1]}th arg of 'add_indent_abc()' refs array with invalid size.\n"
            . "It is expected to be ref to array [first_f, mid_f, last_f, first_last_f, frontstr, tailstr]!\n";
        }
        my ($first, $mid, $last, $first_last, $front_str, $last_str) = @$x;
        foreach_abc [$first, $mid, $last, $first_last], $ra_target, 
            sub {$_[0] = $front_str . $_[0] . $last_str;} ;
    }
}

###############################################################
# untrim_abc \@target, [first, mid, last, first_last, frontstr, tailstr], ...;
#     returns result_str (non-destructive)
sub untrim_join_abc ($@)
{
    my $ra_target = shift @_;
    my @target_clone = @$ra_target; # clone
    untrim_abc \@target_clone, @_;
    return join('', @target_clone);
}
###############################################################
# kv_q_strs_by_keys ref_hash, keys...  (returns string array)
sub kv_qq_strs_by_keys($@)
{
    my $ref_hash = shift;
    if (Scalar::Util::reftype($ref_hash) ne 'HASH')
    {
        croak "Err: 1st arg of 'kv_q_strs_by_keys()' is not ref to hash.\n"
        . "It must be ref to hash!\n";
    }
    my @keys = @_;
    for (@keys)
    {
        croak "Err: In kv_q_strs_by_keys(), key '$_' does not exists!\n"
            if !exists $ref_hash->{$_};
    }
    return map { qq_string($_) . ' => ' . qq_string($ref_hash->{$_}) } @keys;
}
###############################################################
# kv_raws_by_keys ref_hash, keys...  (returns string array)
sub kv_raws_by_keys($@)
{
    my $ref_hash = shift;
    if (Scalar::Util::reftype($ref_hash) ne 'HASH')
    {
        croak "Err: 1st arg of 'kv_q_raws_by_keys()' is not ref to hash.\n"
        . "It must be ref to hash!\n";
    }
    my @keys = @_;
    for (@keys)
    {
        croak "Err: In kv_raws_by_keys(), key '$_' does not exists!\n"
            if !exists $ref_hash->{$_};
    }
    return map { qq_string($_) . ' => ' . $ref_hash->{$_} } @keys;
}
###############################################################
# jskv_q_strs_by_keys ref_hash, keys...  (returns string array)
sub jskv_qq_strs_by_keys($@)
{
    my $ref_hash = shift;
    if (Scalar::Util::reftype($ref_hash) ne 'HASH')
    {
        croak "Err: 1st arg of 'jskv_q_strs_by_keys()' is not ref to hash.\n"
        . "It must be ref to hash!\n";
    }
    my @keys = @_;
    for (@keys)
    {
        croak "Err: In kv_q_strs_by_keys(), key '$_' does not exists!\n"
            if !exists $ref_hash->{$_};
    }
    return map { qq_string($_) . ' : ' . qq_string($ref_hash->{$_}) } @keys;
}
###############################################################
# jskv_raws_by_keys ref_hash, keys...  (returns string array)
sub jskv_raws_by_keys($@)
{
    my $ref_hash = shift;
    if (Scalar::Util::reftype($ref_hash) ne 'HASH')
    {
        croak "Err: 1st arg of 'jskv_q_raws_by_keys()' is not ref to hash.\n"
        . "It must be ref to hash!\n";
    }
    my @keys = @_;
    for (@keys)
    {
        croak "Err: In kv_raws_by_keys(), key '$_' does not exists!\n"
            if !exists $ref_hash->{$_};
    }
    return map { qq_string($_) . ' : ' . $ref_hash->{$_} } @keys;
}
###############################################################
###############################################################
###############################################################
#

for my $PG_TARGET(@PG_TARGETS)
{
    if (!defined $PG_OUTPUT_FILE->{$PG_TARGET})
    {die "Error: PG_OUTPUT_FILE target '$PG_TARGET' does not exist!\n";}
    if (!defined $PG_PRE->{$PG_TARGET})
    {die "Error: PG_PRE target '$PG_TARGET' does not exist!\n";}
    if (!defined $PG_POST->{$PG_TARGET})
    {die "Error: PG_POST target '$PG_TARGET' does not exist!\n";}
    if (!defined $PG_GENERAL_ACTION->{$PG_TARGET})
    {die "Error: PG_GENERAL_ACTION target '$PG_TARGET' does not exist!\n";}

    print "Generating $PG_OUTPUT_FILE->{$PG_TARGET} ...\n";

    if ($PG_TARGET eq 'perl')
    {
        my $fhg;
        open $fhg, '>:raw:utf8', $PG_OUTPUT_FILE->{$PG_TARGET}
            or die "Error: failed to open '$PG_OUTPUT_FILE->{$PG_TARGET}\n";


        print $fhg "use utf8;\n";
        print $fhg "use strict;\n";
        print $fhg "use warnings;\n";
        print $fhg "\n";
        print $fhg "package $PG_PARSER_ID;\n";
        print $fhg "use Carp;\n";

        print $fhg "################################################################\n";
        print $fhg "# BEGIN PRE\n";
        print $fhg "################################################################\n";
        print $fhg $PG_PRE->{$PG_TARGET} . "\n";
        print $fhg "################################################################\n";
        print $fhg "# END PRE\n";
        print $fhg "################################################################\n";

        print $fhg "\n";
        print $fhg "package $PG_PARSER_ID;\n";


        print $fhg 'our @PG_TERMINAL_SYMBOLS = (' . "\n";
        {
            my @arr = map {qq_string($_);} @Vt;
            print $fhg untrim_join_abc \@arr,
                [1,1,0,0,"    ", ",\n"], [0,0,1,1,"    ", "\n"];
        }
        print $fhg ");\n";



##################################################
            # # entry
            # {
            #     desc_for_debug => $state->{desc_for_debug},
            #     index => $state->{index},
            #     next_s_r => {},
            # }
                #     {
                #        is_shift => 1,
                #        pri => 0,
                #        trans_to => $state->{transition}->{$symbol_i},
                #    };
                #       {
                #           is_shift => 0,
                #           pri => $rule_ref->{r_pri},
                #           reduce_lhs => $lhs,
                #           reduce_rhs => [@rhs],
                #           rule_i => $rule_i,
                #           rule_no_by_nt => $rule_ref->{rule_no_by_nt},
                #           action => $rule_ref->{action},
                #       };


        {
            my @table_str;
            my @all_symbols_str_list = map
                {$TS->i_to_str($_);} $TS->all_symbols_i_list();

            for my $table_entry(@LALR1state_table_str)
            {
                my $str_table_entry = "{\n";

                $str_table_entry .= "        index => $table_entry->{index},\n";



                $str_table_entry .= "        next_s_r => {\n";
                $str_table_entry .= "            " . join ( ",\n            ",
                    map {
                        my $ret;
                        $ret = qq_string($_) . " => {";

                        my $next_s_r = $table_entry->{next_s_r}->{$_};

                        if ($next_s_r->{is_shift})
                        {
                            # shift
                            # $ret.= "is_shift => " . $next_s_r->{is_shift} . ", ";
                            # $ret.= "pri => "      . $next_s_r->{pri} . ", ";
                            # $ret.= "trans_to => " . $next_s_r->{trans_to} . ", ";
                            $ret .= join ", ", kv_raws_by_keys $next_s_r,
                                qw/ is_shift pri trans_to /;


                        }
                        else
                        {
                            #reduce
                            $ret .= join ", ", kv_raws_by_keys $next_s_r,
                                qw/ is_shift pri rule_i rule_no_by_nt /;

                            # $ret.= "is_shift => " . $next_s_r->{is_shift} . ", ";
                            # $ret.= "pri => " . $next_s_r->{pri} . ", ";
                            # # $ret.= "reduce_lhs => " . qq_string($next_s_r->{reduce_lhs}) . ", ";
                            # # $ret.= "reduce_rhs => ["
                            # #     . join (", ", map {qq_string($_)} @{$next_s_r->{reduce_rhs}})
                            # #     . "], ";
                            # $ret.= "rule_i => "     . $next_s_r->{rule_i} . ", ";
                            # $ret.= "rule_no_by_nt => " . $next_s_r->{rule_no_by_nt } . "";
                            # # ##############
                            # # ## action は外に出したので削除した
                            # # ##############
                            # # if (!defined $next_s_r->{action})
                            # # {
                            # #     $ret.= " action => undef" . ", ";
                            # # }
                            # # elsif (!exists $next_s_r->{action}->{$PG_TARGET})
                            # # {
                            # #     die "Error: action of $next_s_r->{rule_i} for target $PG_TARGET does not exist!\n";
                            # # }
                            # # else
                            # # {
                            # #     $ret.= " action => " . $next_s_r->{action}->$PG_TARGET . ", ";
                            # # }

                # #           pri => $rule_ref->{r_pri},
                # #           # reduce_lhs => $lhs,
                # #           # reduce_rhs => [@rhs],
                # #           rule_i => $rule_i,
                # #           rule_no_by_nt => $rule_ref->{rule_no_by_nt},
                # #           action => $rule_ref->{action},
                        }
                        $ret .= "}";
                        $ret;
                    }
                    grep {
                        exists $table_entry->{next_s_r}->{$_}
                    }
                    @all_symbols_str_list );
                $str_table_entry .= "\n";
                $str_table_entry .= "        }";

                $str_table_entry .= "," if ! $PG_SKIP_DEBUG_DESC;
                $str_table_entry .= "\n";

                $str_table_entry .= "        desc_for_debug => " . qq_string($table_entry->{desc_for_debug}) . "\n" if ! $PG_SKIP_DEBUG_DESC;
                $str_table_entry .= "    }";


                push @table_str, $str_table_entry;
            }

            print $fhg 'our @PG_STATE_TABLE = (' . "\n";
            print $fhg untrim_join_abc \@table_str,
                [1,1,0,0, '', ','], [1,1,1,1, '    ', "\n"];
            print $fhg ");\n";
        }

        ################################################################
        # rules  中身は直書きしているから、内容は不要
        print $fhg 'our @PG_RULES = (' . "\n";
        # print $fhg join (",\n    ", map {
        #         my $rule1=$_;
        #         '{ lhs => ' . qq_string($TS->i_to_str($_->{lhs})) . ", "
        #              . 'rhs => [' .
        #                  join (", ", map {qq_string($TS->i_to_str($_)) } @{$rule1->{rhs}})
        #               . "],  "
        #             # action は別置き
        #              . 'r_pri =>' . $_->{r_pri} . " }"
        #     }
        #     @main::rules);
        {
            my @arr = map {
                    my $rule1=$_;
                    '{ lhs => ' . qq_string($TS->i_to_str($_->{lhs})) . ", "
                         . 'rhs => [' .
                             join (", ", map {qq_string($TS->i_to_str($_)) } @{$rule1->{rhs}})
                          . "],  "
                        # action は別置き
                         . 'r_pri =>' . $_->{r_pri} . " }"
                }
                @main::rules;
            print $fhg untrim_join_abc \@arr,
                [1,1,0,0, '', ','], [1,1,1,1, '    ', "\n"];
        }
        print $fhg ");\n";

        ################################################################
        # rule_action  中身は直書きしているから、内容は不要
        print $fhg 'our @PG_RULE_ACTION = (' . "\n    ";
        print $fhg join (",\n    ", map {

                my $ret;
                if (!defined $_->{action})
                { $ret = 'undef'; }
                elsif (!exists $_->{action}->{$PG_TARGET})
                {
                    die "Error: action for target $PG_TARGET does not exist!\n";
                }
                else
                { $ret = qq_string( $_->{action}->{$PG_TARGET} ); }
                $ret;
            } @main::rules);
        print $fhg "\n);\n";





        # parse() は
        # 
        #    $tokenizer
        #        ->following_token_sv()
        #        ->following_token_id()
        #        ->next()
        #        (->open/close はユーザサイドで勝手にする)
        #    &parse_error()
        #            $default_msg
        #            @LALR_parse_stack
        #            @LALR1state_table
        #            tokenizer
        #            # TS  は要らない
        #        の参照も受け取っておいた方がよい→#  parse() の引数で受けとろう。


########################################################################

        # 初期
        print $fhg <<'EOT';
sub parse {
    my ($tokenizer, $rh_error_handler) = @_;


    my $parse_result;


    my @LALR_parse_stack = ( {state_index=>0, shifted_symbol=>undef} );

    while(1)
    {
        my $state_index = $LALR_parse_stack[$#LALR_parse_stack]->{state_index};

        if (!exists $PG_STATE_TABLE[$state_index]->{next_s_r}->{$tokenizer->{following_token_id}})
        {
            # エラー
            # (SHOULD CALL $rh_error_handler
            confess "Error! (in parse)!";
        }
        my $shift_or_reduce = $PG_STATE_TABLE[$state_index]->{next_s_r}->{$tokenizer->{following_token_id}};
        if ($shift_or_reduce->{is_shift})
        {
            # シフト
            push @LALR_parse_stack, {
                state_index => $shift_or_reduce->{trans_to},
                shifted_symbol =>$tokenizer->{following_token_sv},
            };

            $tokenizer->read_next_token();
        }
        else
        {
            # 還元
            # (eot) に還元するところで終了
            #  $shift_or_reduce : {
            #      is_shift => 0,
            #      pri => $pri,
            #      reduce_lhs => $lhs,     # $PG_RULES[...->{rule_i}]->{lhs} に変更
            #      reduce_rhs => [@rhs],   # $PG_RULES[...->{rule_i}]->{rhs} に変更
            #      rule_i => $rule_i,
            # };

            #  rhs の数だけ popして、
            #      木を構築 した lhs を
            #             _=$LALR_parse_stack[$#LALR_parse_stack]->{state_index}
            #                 の $PG_STATE_TABLE[_]->{next_s_r}->{ <lhs> } のshift で
            #             シフトする

            my $next_shift_symbol_id_str = $PG_RULES[$shift_or_reduce->{rule_i}]->{lhs};
            my $n_pop = @{$PG_RULES[$shift_or_reduce->{rule_i}]->{rhs}};
            if (@LALR_parse_stack <= $n_pop)
            {
                die "Internal Erroe! Over reduce\n"
            }
            my @SVs = map{$_->{shifted_symbol}} splice(@LALR_parse_stack, -$n_pop, $n_pop);

            if( $next_shift_symbol_id_str eq '(ADDED_START)' )
            {
                # 結果を取り出して終了
                if (@LALR_parse_stack != 1)
                { die "Internal Error: n stack not eq 1 at eot!\n"; }
                $parse_result = $SVs[0];
                return $parse_result;
            }

            my $LHS_ID = $next_shift_symbol_id_str;
            my $LHS_SV;
            # my $LHS_SV = {
            #     id => $LHS_ID,
            #     child => \@SVs,
            # };
EOT
        print $fhg "################################################################\n";
        print $fhg "# BEGIN ACTION\n";
        print $fhg "################################################################\n";
    #     print $fhg '$LHS_SV = {id => $LHS_ID, child => \\@SVs};' . "\n";


        print $fhg "{\n";
        print $fhg '    my $rule_i = $shift_or_reduce->{rule_i};' . "\n";

        print $fhg '    if (!defined $PG_RULE_ACTION[$rule_i])' . "\n";

        if (!defined $PG_GENERAL_ACTION->{$PG_TARGET})
        {die "Error: action for target $PG_TARGET does not exist!\n";}

        print $fhg "    {\n";
        print $fhg $PG_GENERAL_ACTION->{$PG_TARGET};
        print $fhg "\n    }\n";

        for my $i(0 .. $#main::rules)
        {
            if (!defined $main::rules[$i]->{action})
            { }
            elsif (!exists $main::rules[$i]->{action}->{$PG_TARGET})
            {
                die "Error: action for target $PG_TARGET does not exist!\n";
            }
            else
            {
                print $fhg '    elsif ( $rule_i ' . "== $i )\n";
                print $fhg '    {' . "\n";
                print $fhg '    # rule ' . "$i\n";
                print $fhg $main::rules[$i]->{action}->{$PG_TARGET};
                print $fhg "\n    }\n";
            }
        }
    print $fhg <<'EOT';
    else { die "Error: Internal error! Wrong rule $rule_i in action proc\n"; }
EOT
        print $fhg "}\n";


        print $fhg "################################################################\n";
        print $fhg "# END ACTION\n";
        print $fhg "################################################################\n";


        print $fhg <<'EOT';

            my $state_index_after_reduce
            = $LALR_parse_stack[$#LALR_parse_stack]->{state_index};


            # ここからシフト

            if (!exists $PG_STATE_TABLE[$state_index_after_reduce]->{next_s_r}->{$next_shift_symbol_id_str})
            { die "Internal Error: cannot shift after reduce.\n"}

            my $shift_after_reduce = $PG_STATE_TABLE[$state_index_after_reduce]->{next_s_r}->{$next_shift_symbol_id_str};

            if (!$shift_after_reduce->{is_shift})
            { die "Internal Error: cannot shift after reduce(2).\n"}

            my $next_state = $shift_after_reduce->{trans_to};


            push @LALR_parse_stack,
            { state_index=>$next_state, shifted_symbol=>$LHS_SV };
        }
    }

}
EOT

########################################################################







=pod
    # while(1)
    # {
    #     my $token = get_next_token();
    #     last if exists $token->{eof};
    #     print $TS->i_to_str($token->{id_i})."__";
    # }
    # print "(end of text)\n";

    # 参照するのは $TS と、@LALR1state_table、&get_next_token_str
    # 後のことを考えると
    #    $tokenizer
    #        ->following_token_sv()
    #        ->following_token_id()
    #        ->next()
    #        (->open/close はユーザサイドで勝手にする)
    #    &parse_error()
    #            $default_msg
    #            @LALR_parse_stack
    #            @LALR1state_table
    #            tokenizer
    #            # TS  は要らない
    #        の参照も受け取っておいた方がよい→#  parse() の引数で受けとろう。

    # 初期
    my @LALR_parse_stack = ( {state_index=>0, shifted_symbol=>undef} );

    my $next_token;
    $next_token = get_next_token_str();
    $next_token = {id_str=>'(eot)'} if !defined $next_token;

    while(1)
    {
        # print join (" == ", map { ($_->{shifted_symbol}->{id_str} //'undef')." s".$_->{state_index}} @LALR_parse_stack);
        # print "\n> $next_token->{id_str} \n";

        my $state_index = $LALR_parse_stack[$#LALR_parse_stack]->{state_index};

        if (!exists $LALR1state_table_str[$state_index]->{next_s_r}->{$next_token->{id_str}})
        {
            # エラー
            die "Error! (in parse)!";
        }
        my $shift_or_reduce = $LALR1state_table_str[$state_index]->{next_s_r}->{$next_token->{id_str}};
        if ($shift_or_reduce->{is_shift})
        {
            # シフト
            push @LALR_parse_stack, {
                state_index => $shift_or_reduce->{trans_to},
                shifted_symbol =>$next_token,
            };

            $next_token = get_next_token_str();
            $next_token = {id_str=>'(eot)'} if !defined $next_token;
        }
        else
        {
            # 還元
            # (eot) に還元するところで終了
            #  $shift_or_reduce : {
            #      is_shift => 0,
            #      pri => $pri,
            #      reduce_lhs => $lhs,
            #      reduce_rhs => [@rhs],
            #      rule_i => $rule_i,
            # };

            #  rhs の数だけ popして、
            #      木を構築 した lhs を
            #             _=$LALR_parse_stack[$#LALR_parse_stack]->{state_index}
            #                 の $LALR1state_table_str[_]->{next_s_r}->{ <lhs> } のshift で
            #             シフトする

            my $next_shift_symbol_id_str = $shift_or_reduce->{reduce_lhs};
            my $n_pop = @{$shift_or_reduce->{reduce_rhs}};
            if (@LALR_parse_stack <= $n_pop)
            {
                die "Internal Erroe! Over reduce\n"
            }
            my @child_elements = map{$_->{shifted_symbol}} splice(@LALR_parse_stack, -$n_pop, $n_pop);

            if( $next_shift_symbol_id_str eq '(ADDED_START)' )
            {
                # 結果を取り出して終了
                if (@LALR_parse_stack != 1)
                { die "Internal Error: n stack not eq 1 at eot!\n"; }
                $parse_result = $child_elements[0];
                last;
            }

            my $next_shift_element = {
                id_str => $next_shift_symbol_id_str,
                child => \@child_elements,
            };


            my $state_index_after_reduce
            = $LALR_parse_stack[$#LALR_parse_stack]->{state_index};


            # ここからシフト

            if (!exists $LALR1state_table_str[$state_index_after_reduce]->{next_s_r}->{$next_shift_symbol_id_str})
            { die "Internal Error: cannot shift after reduce.\n"}

            my $shift_after_reduce = $LALR1state_table_str[$state_index_after_reduce]->{next_s_r}->{$next_shift_symbol_id_str};

            if (!$shift_after_reduce->{is_shift})
            { die "Internal Error: cannot shift after reduce(2).\n"}

            my $next_state = $shift_after_reduce->{trans_to};


            push @LALR_parse_stack,
            { state_index=>$next_state, shifted_symbol=>$next_shift_element };
        }
    }
    dumpv "parse_result", $parse_result ;
    &easy_tree_output($parse_result);

=cut
        print $fhg "\n";
        print $fhg "################################################################\n";
        print $fhg "# BEGIN POST\n";
        print $fhg "################################################################\n";
        print $fhg $PG_POST->{$PG_TARGET} . "\n";
        print $fhg "################################################################\n";
        print $fhg "# END POST\n";
        print $fhg "################################################################\n";



        close $fhg;
    }
    elsif ($PG_TARGET eq 'javascript')
    {
        my $fhg;
        open $fhg, '>:raw:utf8', $PG_OUTPUT_FILE->{$PG_TARGET}
            or die "Error: failed to open '$PG_OUTPUT_FILE->{$PG_TARGET}\n";


        print $fhg $PG_PRE->{$PG_TARGET} . "\n";
        print $fhg "////////////////////////////////////////////////////////////////\n";
        print $fhg "// END PRE\n";
        print $fhg "////////////////////////////////////////////////////////////////\n";

        print $fhg "\n";

        print $fhg "var $PG_PARSER_ID = {};\n";
        #     // or ...    function (){};
        #     // or ...    let TestParser;

        print $fhg "\n";
        print $fhg "{\n";
        print $fhg "    let parser_ref = $PG_PARSER_ID;\n";


        print $fhg "\n";
        print $fhg "    ////////////////////////////////////////////////////////////////////\n";
        print $fhg "    // 変数定義部分\n";
        print $fhg "\n";

        print $fhg "    parser_ref.PG_TERMINAL_SYMBOLS = [\n";
        {
            my @arr = map {qq_string($_);} @Vt;
            print $fhg untrim_join_abc \@arr,
                [1,1,0,0,"        ", ",\n"], [0,0,1,1,"        ", "\n"];
        }
        print $fhg "    ];\n";
        print $fhg "\n";
        print $fhg "\n";

##################################################
            # # entry
            # {
            #     desc_for_debug => $state->{desc_for_debug},
            #     index => $state->{index},
            #     next_s_r => {},
            # }
                #     {
                #        is_shift => 1,
                #        pri => 0,
                #        trans_to => $state->{transition}->{$symbol_i},
                #    };
                #       {
                #           is_shift => 0,
                #           pri => $rule_ref->{r_pri},
                #           reduce_lhs => $lhs,
                #           reduce_rhs => [@rhs],
                #           rule_i => $rule_i,
                #           rule_no_by_nt => $rule_ref->{rule_no_by_nt},
                #           action => $rule_ref->{action},
                #       };


        {
            my @table_str;
            my @all_symbols_str_list = map
                {$TS->i_to_str($_);} $TS->all_symbols_i_list();

            for my $table_entry(@LALR1state_table_str)
            {
                my $str_table_entry = "        {\n";

                $str_table_entry .= "            index : $table_entry->{index},\n";



                $str_table_entry .= "            next_s_r : {\n";
                $str_table_entry .= "                " . join ( ",\n                ",
                    map {
                        my $ret;
                        $ret = qq_string($_) . " : {";

                        my $next_s_r = $table_entry->{next_s_r}->{$_};

                        if ($next_s_r->{is_shift})
                        {
                            # shift
                            # $ret.= "is_shift => " . $next_s_r->{is_shift} . ", ";
                            # $ret.= "pri => "      . $next_s_r->{pri} . ", ";
                            # $ret.= "trans_to => " . $next_s_r->{trans_to} . ", ";
                            $ret .= join ", ", jskv_raws_by_keys $next_s_r,
                                qw/ is_shift pri trans_to /;


                        }
                        else
                        {
                            #reduce
                            $ret .= join ", ", jskv_raws_by_keys $next_s_r,
                                qw/ is_shift pri rule_i rule_no_by_nt /;

                            # $ret.= "is_shift => " . $next_s_r->{is_shift} . ", ";
                            # $ret.= "pri => " . $next_s_r->{pri} . ", ";
                            # # $ret.= "reduce_lhs => " . qq_string($next_s_r->{reduce_lhs}) . ", ";
                            # # $ret.= "reduce_rhs => ["
                            # #     . join (", ", map {qq_string($_)} @{$next_s_r->{reduce_rhs}})
                            # #     . "], ";
                            # $ret.= "rule_i => "     . $next_s_r->{rule_i} . ", ";
                            # $ret.= "rule_no_by_nt => " . $next_s_r->{rule_no_by_nt } . "";
                            # # ##############
                            # # ## action は外に出したので削除した
                            # # ##############
                            # # if (!defined $next_s_r->{action})
                            # # {
                            # #     $ret.= " action => undef" . ", ";
                            # # }
                            # # elsif (!exists $next_s_r->{action}->{$PG_TARGET})
                            # # {
                            # #     die "Error: action of $next_s_r->{rule_i} for target $PG_TARGET does not exist!\n";
                            # # }
                            # # else
                            # # {
                            # #     $ret.= " action => " . $next_s_r->{action}->$PG_TARGET . ", ";
                            # # }

                # #           pri => $rule_ref->{r_pri},
                # #           # reduce_lhs => $lhs,
                # #           # reduce_rhs => [@rhs],
                # #           rule_i => $rule_i,
                # #           rule_no_by_nt => $rule_ref->{rule_no_by_nt},
                # #           action => $rule_ref->{action},
                        }
                        $ret .= "}";
                        $ret;
                    }
                    grep {
                        exists $table_entry->{next_s_r}->{$_}
                    }
                    @all_symbols_str_list );
                $str_table_entry .= "\n";
                $str_table_entry .= "            }";
                $str_table_entry .= "," if ! $PG_SKIP_DEBUG_DESC;
                $str_table_entry .= "\n";



                $str_table_entry .= "            desc_for_debug : " . qq_string($table_entry->{desc_for_debug}) . "\n" if ! $PG_SKIP_DEBUG_DESC;
                $str_table_entry .= "        }";


                push @table_str, $str_table_entry;
            }

            print $fhg "    parser_ref.PG_STATE_TABLE = [\n";
            print $fhg untrim_join_abc \@table_str,
                [1,1,0,0, '', ','], [1,1,1,1, '', "\n"];
            print $fhg "    ];\n";
        }
        print $fhg "\n";
        print $fhg "\n";

        ################################################################
        # rules  中身は直書きしているから、内容は不要
        print $fhg "    parser_ref.PG_RULES = [\n";
        {
            my @arr = map {
                    my $rule1=$_;
                    '{ lhs : ' . qq_string($TS->i_to_str($_->{lhs})) . ", "
                         . 'rhs : [' .
                             join (", ", map {qq_string($TS->i_to_str($_)) } @{$rule1->{rhs}})
                          . "],  "
                        # action は別置き
                         . 'r_pri : ' . $_->{r_pri} . " }"
                }
                @main::rules;
            print $fhg untrim_join_abc \@arr,
                [1,1,0,0, '', ','], [1,1,1,1, '        ', "\n"];
        }
        print $fhg "    ];\n";
        print $fhg "\n";
        print $fhg "\n";

        ################################################################
        # rule_action  中身は直書きしているから、内容は不要
        print $fhg "    parser_ref.PG_RULE_ACTION = [\n        ";
        print $fhg join (",\n        ", map {

                my $ret;
                if (!defined $_->{action})
                { $ret = 'null'; }
                elsif (!exists $_->{action}->{$PG_TARGET})
                {
                    die "Error: action for target $PG_TARGET does not exist!\n";
                }
                else
                { $ret = qq_string( $_->{action}->{$PG_TARGET} ); }
                $ret;
            } @main::rules);
        print $fhg "\n    ];\n";
        print $fhg "\n";

        ########################################################################
        # ここから perse()

        print $fhg "\n";
        print $fhg "    ////////////////////////////////////////////////////////////////////\n";
        print $fhg "    // parse()\n";
        print $fhg <<'EOT';

    parser_ref.parse = function(tokenizer, rh_error_handler) {
        // my ($tokenizer, $rh_error_handler) = @_;

        let parse_result;


        let a_LALR_parse_stack = [ {state_index : 0, shifted_symbol : null} ];

        while(1)
        {
            let state_index = a_LALR_parse_stack[a_LALR_parse_stack.length - 1].state_index;

            if (!( tokenizer.following_token_id in parser_ref.PG_STATE_TABLE[state_index].next_s_r))
            {
                // エラー
                // (SHOULD CALL rh_error_handler
                throw Error( "Error! (in parse)!");
            }
            let shift_or_reduce = parser_ref.PG_STATE_TABLE[state_index].next_s_r[tokenizer.following_token_id];
            if (shift_or_reduce.is_shift)
            {
                // シフト
                a_LALR_parse_stack.push({
                    state_index : shift_or_reduce.trans_to,
                    shifted_symbol : tokenizer.following_token_sv,
                });

                tokenizer.read_next_token();
            }
            else
            {
                // 還元
                // (eot) に還元するところで終了
                //  $shift_or_reduce : {
                //      is_shift => 0,
                //      pri => $pri,
                //      reduce_lhs => $lhs,     # parser_ref.PG_RULES[...->{rule_i}]->{lhs} に変更
                //      reduce_rhs => [@rhs],   # parser_ref.PG_RULES[...->{rule_i}]->{rhs} に変更
                //      rule_i => $rule_i,
                // };

                //  rhs の数だけ popして、
                //      木を構築 した lhs を
                //             _= a_LALR_parse_stack[a_LALR_parse_stack.length - 1].state_index
                //                 の parser_ref.PG_STATE_TABLE[_].next_s_r[ <lhs> ] のshift で
                //             シフトする

                let next_shift_symbol_id_str = parser_ref.PG_RULES[shift_or_reduce.rule_i].lhs;
                let n_pop = parser_ref.PG_RULES[shift_or_reduce.rule_i].rhs.length;
                if (a_LALR_parse_stack.length <= n_pop)
                {
                    throw Error("Internal Erroe! Over reduce\n");
                }
                // SVs は Array だが、例外的に a_SVs とはしない
                let SVs = a_LALR_parse_stack.splice(-n_pop, n_pop).map((s) => s.shifted_symbol);

                // == は文字列比較として
                if( next_shift_symbol_id_str == '(ADDED_START)' )
                {
                    // 結果を取り出して終了
                    if (a_LALR_parse_stack.length != 1)
                    { throw Error("Internal Error: n stack not eq 1 at eot!\n"); }
                    parse_result = SVs[0];
                    return parse_result;
                }

                let LHS_ID = next_shift_symbol_id_str;
                let LHS_SV;
                // let LHS_SV = {
                //     id => LHS_ID,
                //     child => SVs,
                // };
EOT
        print $fhg "    ////////////////////////////////////////////////////////////////\n";
        print $fhg "    // BEGIN ACTION\n";
        print $fhg "    ////////////////////////////////////////////////////////////////\n";

        print $fhg "    {\n";
        print $fhg "        let rule_i = shift_or_reduce.rule_i;\n";

        print $fhg "        if (parser_ref.PG_RULE_ACTION[rule_i] === null)\n";

        if (!defined $PG_GENERAL_ACTION->{$PG_TARGET})
        {die "Error: action for target $PG_TARGET does not exist!\n";}

        print $fhg "        {\n";
        print $fhg $PG_GENERAL_ACTION->{$PG_TARGET};
        print $fhg "\n        }\n";

        for my $i(0 .. $#main::rules)
        {
            if (!defined $main::rules[$i]->{action})
            { }
            elsif (!exists $main::rules[$i]->{action}->{$PG_TARGET})
            {
                die "Error: action for target $PG_TARGET does not exist!\n";
            }
            else
            {
                print $fhg '        else if ( rule_i ' . "== $i )\n";
                print $fhg '        {' . "\n";
                print $fhg '        // rule ' . "$i\n";
                print $fhg $main::rules[$i]->{action}->{$PG_TARGET};
                print $fhg "\n        }\n";
            }
        }
    print $fhg <<'EOT';
        else { throw Error( `Error: Internal error! Wrong rule ${rule_i} in action proc\n` ); }
EOT
        print $fhg "    }\n";


        print $fhg "    ////////////////////////////////////////////////////////////////\n";
        print $fhg "    // END ACTION\n";
        print $fhg "    ////////////////////////////////////////////////////////////////\n";


        print $fhg <<'EOT';

                let state_index_after_reduce
                = a_LALR_parse_stack[a_LALR_parse_stack.length - 1].state_index;


                // ここからシフト

                if (!( next_shift_symbol_id_str in parser_ref.PG_STATE_TABLE[state_index_after_reduce].next_s_r))
                { throw Error( "Internal Error: cannot shift after reduce.\n" );}

                let shift_after_reduce = parser_ref.PG_STATE_TABLE[state_index_after_reduce].next_s_r[next_shift_symbol_id_str];

                if (!shift_after_reduce.is_shift)
                { throw Error( "Internal Error: cannot shift after reduce(2).\n" );}

                let next_state = shift_after_reduce.trans_to;


                a_LALR_parse_stack.push(
                { state_index : next_state, shifted_symbol : LHS_SV } );
            }
        }

    }

}
EOT

########################################################################

        print $fhg "\n";
        print $fhg "////////////////////////////////////////////////////////////////\n";
        print $fhg "// BEGIN POST\n";
        print $fhg "////////////////////////////////////////////////////////////////\n";
        print $fhg $PG_POST->{$PG_TARGET} . "\n";
        print $fhg "\n";
        # print $fhg "////////////////////////////////////////////////////////////////\n";
        # print $fhg "// END POST\n";
        # print $fhg "////////////////////////////////////////////////////////////////\n";






        close $fhg;
    }
    else { die "Error: Unknown target '$PG_TARGET'\n"; }

    print "Generating $PG_OUTPUT_FILE->{$PG_TARGET} ...done.\n\n";
}
#
#
#
#### ここまでできたと思うので、
# 動作確認 step?
# LR1item_fss_set_Closure の実行
# LR1state ???{X LR0t=> ... , followTs =>[]};
# その後parser_gen


# p99- LR(1) 項目 closure => I , GOTO(I,X)
#     LR0term のデータ構造
#     一致判定ルーチン
#     表示判定ルーチン
#
#     LR1項目
#     LR1項目の集合のデータ構造
#         LR1項目の集合へのLR1項目の追加

