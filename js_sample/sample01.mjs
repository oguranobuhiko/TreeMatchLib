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

let target = TreeConstruct(Tree1, 'A >B (C > D) E').Tree();
target.TreePrint(print_last);

let result;
if (result = TreeMatch(target, 'A > . C > .##x'))
{
    print_last("MATCH\n");
    print_last(result.Capture('x').Node().Attr0() + "\n");
}

///////////////////////////////////////////////////////////////

