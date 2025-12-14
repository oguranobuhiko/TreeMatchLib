'use strict';

import {
    // TreeWrapperBase,
    // TreeWrapperBaseIterator,
    // MatchCapturePlace,
    // TreeMatchLib,
    useNewTreeClass,
    TreeConstruct,
    TreeMatch,
    TreeMatchFind
} from '../js_deploy/TreeMatchLib.mjs';

// (import TreeMatchLib.js)

var Tree1 = useNewTreeClass('Tree1', '__k0', '__k1');

///////////////////////////////////////////////////////////////
function print_last(s)
{
    console.log(s.replace(/\n$/, ''));
}
///////////////////////////////////////////////////////////////

function print_plus(msg){ return function(arg){print_last(msg + arg);} }
function node_name_str(node)
{
    if (node === undefined || node === null) { return '(null)'; }
    return node.Attr0();
}

function result_print(result)
{
    print_last('  match = ' + node_name_str(result.Node()));

    let key_single = result.GetCaptureNames();
    let key_multi = result.GetMultiCaptureNames();
    let k;
    for (k of key_single)
    {
        print_last(`    ##${k} = ` + node_name_str(result.Capture(k).Node()));
    }
    for (k of key_multi)
    {
        for (let c of result.MultiCapture(k))
        {
            print_last(`    ##@${k} = ` + node_name_str(c.Node()));
        }
    }
}

function doMatch(target, pat)
{
    print_last(`TARGET = [ ${target} ], MATCH = [ ${pat} ]\n`);

    let target_tree = TreeConstruct(Tree1, target).Tree();
    let result = TreeMatch(target_tree, pat);

    if(result) { result_print(result); }
    else { print_last ("  (NOT MATCH)\n"); }
}

function doFind(target, pat)
{
    print_last(`TARGET = [ ${target} ], FIND = [ ${pat} ]\n`);

    let target_tree = TreeConstruct(Tree1, target).Tree();
    let results = TreeMatchFind(target_tree, pat);

    for (let result of results) { result_print(result); }

}
///////////////////////////////////////////////////////////////


print_last("=== OUTPUT ===");
let target;
target = 'A > (B>C) D A > E > C F ';
doMatch(target, 'A>B D')
doMatch(target, 'A>D A')
doFind(target, '.> C')

doFind(target, '.##a> C##b')
// doFind(target, '.##@a> C##@a')

target = 'A >B C C D>E _';
TreeConstruct(Tree1, target).Tree().TreePrint(print_last);
doMatch(target, 'A>(B##a |B##b C) C D')
doFind(target, '(.##a > B##b) |.##a > E##b')
doMatch(target, 'A>B C C$')

target = 'E1 >X (E2 > "+" Y) E3 > "+" Z';
doMatch(target, 'E1> .##@term (/^E/ > "+" .##@term)*');

target = 'R > A B A B A B';
doMatch(target, 'R > .##head (.##@tail)* B');
doMatch(target, 'R > .##head (.##@tail)*? B');
doMatch(target, 'R > .##head (.##@tail)+ B');
doMatch(target, 'R > .##head (.##@tail)+? B');

doMatch('R > A B', 'R > .##head (.##@tail)+ B');
doMatch('R > A B', 'R > .##head (.##@tail)+? B');

print_last("[CONNECT]\n");
{
    let r1 = TreeConstruct(Tree1, 'E > _##x "*" X');
    let r2 = TreeConstruct(Tree1, 'E##y > R "+" S');
    r1.Tree().TreePrint(print_last); r2.Tree().TreePrint(print_last);

    let cap_x = r1.Capture('x'); let cap_y = r2.Capture('y');
    cap_x.SetNode(cap_y.Node());
    r1.Tree().TreePrint(print_last);
}
{
    let target = TreeConstruct(Tree1, 'A > (B > C) D > B > E').Tree();
    for (let r of TreeMatchFind(target, 'B > .'))
    {
        let match_root_capture = r.GetRootCapture();
        let ins = TreeConstruct(Tree1, 'if > cond _##body');
        let ins_root_node = ins.Node();
        let body_capture = ins.Capture('body');

        match_root_capture.SetNode(ins_root_node);
        body_capture.SetNode(match_root_capture.Node());
    }

    target.TreePrint(print_last);
}
print_last("[ATTRIBUTE]\n");
{
    target = 'E1 > (E2 > ((E3 > ID#x1) "+" ID#x2)) "+" ID#x';
    let target_tree = TreeConstruct(Tree1, target).Tree();
    for (let r1 of TreeMatchFind(target_tree, '/^E/##e > (-/^E/ "+"|) ID#/[0-9]/##term $'))
    {
        print_last( "    [results]\n");
        print_last( "        e: " + r1.Capture('e').Node().Attr0() + "\n");
        print_last( "        term: " + r1.Capture('term').Node().Attr1() + "\n");
    }
}
print_last("[RECURSIVE]\n");

doMatch('E1 > E2  > E3', ' (/E/##@cap > (?-1)|$)');
doMatch('E > (E  > (E > X) "+" Y) "+" Z' , ' E > (.##@t $ | (E > (?-2)) "+" .##@t)');
doFind('E1 > (E2  > (E3 > X) "+" Y) "+" E4> (E5>Z) "*" W', ' /^E/##root > (.##@t $ | (/^E/ > (?-2)) ("+"|"*") -.##@t)');

///////////////////////////////////////////////////////////////

