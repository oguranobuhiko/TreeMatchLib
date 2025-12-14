#
# use -I to specify module(*.pm) directory ex.:
#   perl -I../perl_deploy sample02.pl
#   perl -I. sample02.pl
#
# vim: set et sw=4 sts=4 ai : 

# use utf8;
use strict;
use warnings;

use lib '../perl_deploy';
use TreeMatchLib;

print "[sample1]\n";
{
    useNewTreeClass Tree1 => '__A', '__B';

    my $target = TreeConstruct('Tree1', 'E >X "+" Y')->Tree;
    $target->TreePrint();

    my $r1 = TreeMatch($target, 'E> .##capL  ("+"##op | "-"##op) .##capR');
    print $r1 ? "T\n" : "F\n";
    print "op: " . $r1->Capture('op')->Node->Attr0 . "\n";
    print "cap1: " . $r1->Capture('capL')->Node->Attr0 . "\n";
    print "cap2: " . $r1->Capture('capR')->Node->Attr0 . "\n";
}
print "\n";
print "[sample2]\n";
{
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
}
print "\n";

print "done.\n\n";

