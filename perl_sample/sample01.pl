#
# use -I to specify module(*.pm) directory ex.:
#   perl -I../perl_deploy sample01.pl
#   perl -I. sample01.pl
#
# vim: set et sw=4 sts=4 ai : 

# use utf8;
use strict;
use warnings;

use lib '../perl_deploy';

use TreeMatchLib;
useNewTreeClass Tree1 => 'key0', 'key1';

my $target = TreeConstruct('Tree1', 'A >B (C > D) E')->Tree();
$target->TreePrint();

if (my $result = TreeMatch($target, 'A > . C > .##x'))
{
    print "MATCH\n";
    print $result->Capture('x')->Node()->Attr0() . "\n";
}
