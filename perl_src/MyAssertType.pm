# 
# vim: set et sw=4 sts=4 ai : 
use utf8;
use strict;
use warnings;

# use Encode;
# binmode STDIN,":encoding(cp932)";
# binmode STDOUT,":encoding(cp932)";


package MyAssertType;

# use Exporter 'import';
# our @EXPORT = qw{
#     MyAssertJustPrintRefInfo
#     MyAssertClass
#     MyAssertDataType
#     MyAssertCondition
#     MyAssertArgNum
# };
sub force_import
{
    my ($pkg, $exp_to) = @_; no strict 'refs';
    $exp_to = caller(0) if (!defined $exp_to);
    for my $sym ( qw/
            MyAssertJustPrintRefInfo
            MyAssertClass
            MyAssertDataType
            MyAssertCondition
            MyAssertArgNum
        /)
    {  *{"${exp_to}::$sym"} = \&{"${pkg}::$sym"};  }
    # {  *{"${exp_to}::$sym"} = \&{"MyAssertType::$sym"};  }
}
sub import { my $callpkg = caller(0); __PACKAGE__->force_import($callpkg); }



our @CARP_NOT = ('MyAssertType');

use Carp;   # carp/croak/confess/Carp::cluck{,longmess,shortmess}
use Scalar::Util;

sub MyAssert__TargetStringForPrint($)
{
    my ($target) = @_;

    my $target_is;

    if(! defined $target)
    { $target_is = "(undef)"; }
    else
    {
        my $reftype = Scalar::Util::reftype $target;
        my $refaddr = sprintf('0x%x',Scalar::Util::refaddr $target);
        my $blessed = Scalar::Util::blessed $target;

        if(! defined $reftype)
        { $target_is = "not reference(|$target|)"; }
        else
        {
            my $item_part = '';
            if (Scalar::Util::reftype($target) eq 'ARRAY')
            { $item_part = "N = " . scalar(@$target) . ", "; }
            elsif (Scalar::Util::reftype($target) eq 'HASH')
            { $item_part = "N = " . scalar(keys(%$target)) . ", "; }
            elsif (Scalar::Util::reftype($target) eq 'SCALAR')
            { $item_part = "|$target|,"; }
            else
            {} # empty string

            my $blessed_name = $blessed;
            $blessed_name = 'no_bless' if ! defined $blessed_name;

            $target_is = "$blessed_name/$reftype($item_part$refaddr)\n";
        }
    }
    return $target_is;
}

sub MyAssertJustPrintRefInfo($;$)
{
    my ($target, $comment) = @_;
    $comment = '' if !defined $comment;

    my $target_is = MyAssert__TargetStringForPrint($target);

    confess "\n\nMyAssertJustPrintRefInfo:\n"
        . "target: $target_is\n";
}

sub MyAssertClass($$;$)
{
    my ($expected, $target, $comment) = @_;
    $comment = '' if !defined $comment;

    my $blessed_name = Scalar::Util::blessed($target);
    $blessed_name = '' if ! defined $blessed_name;

    return if $blessed_name eq $expected; # return successfully

    my $target_is = MyAssert__TargetStringForPrint($target);

    confess "\n\nMyAssertClass Failed!: $comment\n"
        . "expected: $expected\n"
        . "target: $target_is\n";
}
sub MyAssertDataType($$;$)
{
    my ($expected, $target, $comment) = @_;
    $comment = '' if !defined $comment;

    my $reftype_name = Scalar::Util::reftype($target);
    $reftype_name = '' if ! defined $reftype_name;

    return if $reftype_name eq $expected; # return successfully

    my $target_is = MyAssert__TargetStringForPrint($target);

    confess "\n\nMyAssertDataType Failed!: $comment\n"
        . "expected: $expected\n"
        . "target: $target_is\n";

}
sub MyAssertCondition($;$)
{
    my ($condition_result, $comment) = @_;
    return if $condition_result; # return successfully
    confess "\n\nMyAssertCondition Failed!: $comment\n";
}
sub MyAssertArgNum($$$;$)
{
    my ($lower_bound,$upper_bound,$arg_num, $comment) = @_;
    return if $lower_bound <= $arg_num && $arg_num <= $upper_bound;
    confess "\n\nMyAssertArgNum Failed!: $comment\n"
    . "expected: $lower_bound .. $upper_bound\n"
    . "N arg: $arg_num\n" ;
}

1;
