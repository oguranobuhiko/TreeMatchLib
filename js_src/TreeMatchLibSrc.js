'use strict';

//  vim: set expandtab sw=4 sts=4 :

// MatchCapturePlace ここから

// ------------------------------------------------------------
// CLASS MatchCapturePlace
// ------------------------------------------------------------

// # ========================================
// # データ構造
// #   $self->{node}   : TreeWrapperBase::Node (キャプチャされたノード)
// #   $self->{subtree}: TreeWrapperBase::Tree (部分木)
// #   $self->{path}   : ArrayRef[ { node => ..., tree => ..., next_child_index => ... }, ... ]
// # ========================================

// constructor
var MatchCapturePlace = function(node, tree, path) {

    if ( path === undefined || path === null)
    {
        path = [{node: node, tree: tree}];
        // $path->[0]->{next_child_index} は無し
    }

    this.node    = node;
    this.subtree = tree;
    this.path    = path;
};

// class method (static)
MatchCapturePlace.newByIterator = function(iter, root_capture) {


    if ( iter.IsEnd() )
    { throw Error("Error: MatchCapturePlace::newFromIter(): iterator is at end"); }

    if (root_capture === undefined || root_capture === null)
    {
        // my $rootnode = $tree->GetRootNode();
        // $root_capture = MatchCapturePlace->new($rootnode, $tree, undef);
        let tree = iter.iter_stack[0].tree;
        let rootnode = tree.GetRootNode();
        root_capture = new MatchCapturePlace(rootnode, tree, null);
    }


    let cur_tree = iter.Tree();
    let cur_node = iter.Node();

    // パスを構築：ルートから現在まで

    // duplicate path of root_capture;
    //     Object.assign({}, some_object) で shallow copy
    let path = root_capture.path.map( (f) => Object.assign({}, f) );

    path[path.length - 1].tree = iter.iter_stack[0].tree;
    path[path.length - 1].node = path[path.length - 1].tree.GetRootNode();

    let level;
    for (level = 1; level <= iter.iter_stack.length - 1; level++)
    {
        path[path.length - 1].next_child_index = iter.iter_stack[level].sibling_index;

        let tree_l = iter.iter_stack[level].tree;
        let node_l = null;
        if (tree_l !== undefined && tree_l !== null) { node_l = tree_l.GetRootNode(); }

        path.push( {node: node_l , tree: tree_l} );
    }
    let ret_capture = new MatchCapturePlace(cur_node, cur_tree, path);


    return ret_capture;
};


// ========== 基本アクセサ ==========

MatchCapturePlace.prototype.Node = function() {
    return this.node;
};

MatchCapturePlace.prototype.Tree = function() {
    return this.subtree;
};

MatchCapturePlace.prototype.PathLength = function() {
    // root で 1, root の子で 2

    if (this.path === undefined || this.path === null) { return 0; }
    return this.path.length;

    throw Error("Error: not yet implemented (edf9b0a5_b6738e38)!");
};

// ========== パス系取得 ==========

MatchCapturePlace.prototype.PathNthUpNode = function(n) {

    if (n === undefined || n === null || n < 0)
    { throw Error("Error: Wrong argument.\n"); }

    let len = this.PathLength();
    if (n >= len) { return null; }

    let entry = this.path[n];
    return entry.node;
};

MatchCapturePlace.prototype.PathNthUpTree = function(n) {

    if (n === undefined || n === null || n < 0)
    { throw Error("Error: Wrong argument.\n"); }

    let len = this.PathLength();
    if (n >= len) { return null; }

    let entry = this.path[n];
    return entry.tree;
};

// ========== ノード操作 ==========

MatchCapturePlace.prototype.SetNode = function(new_node) {

    return this.Tree().SetRootNode(new_node);
};

MatchCapturePlace.prototype.DetachNode = function() {

    return this.Tree().SetRootNode(null);
};

MatchCapturePlace.prototype.RemoveNode = function() {

    if (this.PathLength() <= 1)
    { throw Error("Error in MatchCapturePlace::RemoveNode(): can't remove root node (b6413fd0_bda73400)\n"); }

    // path [1] (親ノード分)の使用が必要
    let parent_node = this.path[1].node;
    let i = this.path[1].next_child_index;

    let old_nodes;
    old_nodes = parent_node.SpliceChildrenNodes(i, 1);
    return old_nodes[0];
};

MatchCapturePlace.prototype.SpliceNode = function(nodes) {

    if (this.PathLength() <= 1)
    { throw Error("Error in MatchCapturePlace::RemoveNode(): can't remove root node (23aa6e2f_eae49c15)\n"); }

    // path [1] (親ノード分)の使用が必要
    let parent_node = this.path[1].node;
    let i = this.path[1].next_child_index;

    let old_nodes;
    old_nodes = parent_node.SpliceChildrenNodes(i, 1, nodes);
    return old_nodes[0];

    throw Error("Error: not yet implemented (4aaa45f2_ff99e0e3)!");
};

MatchCapturePlace.prototype.InsertBefore = function(nodes) {


    if (this.PathLength() <= 1)
    { throw Error("Error in MatchCapturePlace::InsertBefore(): can't insert root node (d2b6feb4_78b42e4d)\n"); }

    // path [1] (親ノード分)の使用が必要
    let parent_node = this.path[1].node;
    let i = this.path[1].next_child_index;

    parent_node.SpliceChildrenNodes(i, 0, nodes);
};

MatchCapturePlace.prototype.InsertAfter = function(nodes) {

    if (this.PathLength() <= 1)
    { throw Error("Error in MatchCapturePlace::InsertAfter(): can't insert root node (499d5f64_4386b841)\n"); }

    // path [1] (親ノード分)の使用が必要
    let parent_node = this.path[1].node;
    let i = this.path[1].next_child_index;

    parent_node.SpliceChildrenNodes(i + 1 ,0, nodes);
};

// ========== Path 経由のノード操作 ==========


MatchCapturePlace.prototype.PathNthUpSetNode = function(n, new_node) {

    let entry = this._nth_path_entry_or_die(n);

    throw Error("Error: not yet implemented (4cabcf4c_e5878ecb)!");
};

MatchCapturePlace.prototype.PathNthUpDetachNode = function(n) {

    let entry = this._nth_path_entry_or_die(n);

    throw Error("Error: not yet implemented (3f86422a_1ed8b12a)!");
};

MatchCapturePlace.prototype.PathNthUpRemoveNode = function(n) {

    let entry = this._nth_path_entry_or_die(n);

    throw Error("Error: not yet implemented (8ad19425_96e03d56)!");
};

MatchCapturePlace.prototype.PathNthUpSpliceNode = function(n, nodes) {

    let entry = this._nth_path_entry_or_die(n);

    throw Error("Error: not yet implemented (aa894e36_3788bfd9)!");
};

MatchCapturePlace.prototype.PathNthUpInsertBefore = function(n, nodes) {

    let entry = this._nth_path_entry_or_die(n);

    throw Error("Error: not yet implemented (d1e089a8_8c734948)!");
};

MatchCapturePlace.prototype.PathNthUpInsertAfter = function(n, nodes) {

    let entry = this._nth_path_entry_or_die(n);

    throw Error("Error: not yet implemented (cfd62aa2_d86c787b)!");
};

// ========== 内部: パス取得（範囲外なら die） ==========


MatchCapturePlace.prototype._nth_path_entry_or_die = function() {

    if (n === undefined || n === null || n < 0)
    { throw Error("Error: Wrong argument.\n"); }

    let len = this.PathLength();
    if (n >= len)
    { throw Error(`Error: Wrong argument(expected arg(=${n}) < ${len}).\n`);}

    let entry = this.path[n];
    return entry;
};

// ========== 内部: デバッグ用表示関数 ==========

// class method (static)
MatchCapturePlace.aux_debug_print_capture_node_tree_str = function(node, tree) {
    let node_str;
    if (node === undefined || node === null) { node_str = '(null)'; }
    else { node_str = node.Attr0() + `(${node})`; }

    let tree_str;
    if (tree === undefined || tree === null) { tree_str = '(null)'; }
    else {
        if (tree.GetRootNode() === undefined || tree.GetRootNode() === null)
        { tree_str = `${tree}(node = null)`; }
        else
        {
            tree_str = `${tree}(node = `
            + tree.GetRootNode().Attr0()
            + "(" + tree.GetRootNode() + ")"
            +")";
        }
    }

    return `node = ${node_str} / (sub)tree = ${tree_str}`;
};

MatchCapturePlace.prototype.aux_debug_print_capture = function(rf_print) {

    let my_class = this.constructor;

    let node_tree_str = my_class.aux_debug_print_capture_node_tree_str(this.node, this.subtree);

    rf_print(`Capture [ ${node_tree_str} ]\n`);

    // loop on keys
    for (let i in this.path)
    {
        let e = this.path[i];
        node_tree_str = my_class.aux_debug_print_capture_node_tree_str(e.node, e.tree);

        let next_i = '_';
        if ('next_child_index' in e && e.next_child_index !== undefined && e.next_child_index !== null)
        {
            next_i = e.next_child_index;
        }

        rf_print(`  [${i}] ${next_i} : ${node_tree_str}\n`);
    }

};

MatchCapturePlace.prototype.aux_debug_short_print = function(rf_print) {

    let node_str = 'null';
    if (this.Node() !== undefined && this.Node() !== null)
    {
        node_str = this.Node().Attr0();

        if (this.Node().Attr1() !== undefined && this.Node().Attr1() !== null)
        { node_str = node_str + "(" + this.Node().Attr1() + ")"; }
    }

    let tree_str = 'null';
    if (this.Tree().GetRootNode() !== undefined && this.Tree().GetRootNode() !== null)
    { tree_str = this.Tree().GetRootNode().Attr0(); }

    let path_string = '';
    let n = this.path.length;
    let i;
    for (i = 0; i <= n - 2; i++)
    {
        let e_node = this.path[i].node;
        let e_node_name = 'null';
        if (e_node !== undefined && e_node !== null)
        {e_node_name = e_node.Attr0();}

        let next_index = this.path[i].next_child_index;
        path_string = path_string + `${e_node_name}-${next_index},`;
    }
    let e_node = this.path[i].node;
    let e_node_name = 'null';

    if (e_node !== undefined && e_node !== null)
    { e_node_name = e_node.Attr0(); }
    path_string = path_string + e_node_name;

    rf_print(`${node_str} / ${tree_str} / ${path_string}\n`);
};

// ------------------------------------------------------------
// CLASS TreePatternMatchResult
// ------------------------------------------------------------

// ========================================
// データ構造
//   $self->{matched_subtree_capture}   : MatchCapturePlace 型（想定）- マッチしたサブツリー（ルートのキャプチャ）
//   $self->{single_captures}   : HashRef{ name => MatchCapturePlace }
//   $self->{multiple_captures} : HashRef{ name => ArrayRef[ MatchCapturePlace ] }
// ========================================


// constructor
var TreePatternMatchResult = function(root_capture, single_captures, multiple_captures){

    // if (defined $single_captures && ref($single_captures) ne 'HASH') {
    //     confess "Error: single_captures must be a HashRef";
    // }
    // if (defined $multiple_captures && ref($multiple_captures) ne 'HASH') {
    //     confess "Error: multiple_captures must be a HashRef";
    // }

    if (single_captures === undefined || single_captures === null)
    { single_captures = {}; }
    if (multiple_captures === undefined || multiple_captures === null)
    { multiple_captures = {}; }

    this.matched_subtree_capture   = root_capture; // ここは MatchCapturePlace を想定
    this.single_captures   = single_captures;
    this.multiple_captures = multiple_captures;
};

TreePatternMatchResult.prototype.Capture = function(name) {

    if (name === undefined || name === null)
    { throw Error("Error: Capture(name) requires a capture name (4b6c2a1e_2e790627)\n"); }

    if ( !(name in this.single_captures)) { return null; }
    return this.single_captures[name];
};

TreePatternMatchResult.prototype.MultiCapture = function(name) {

    if (name === undefined || name === null)
    { throw Error("Error: MultiCapture(name) requires a capture name (76d7ce7b_d16c0b55)\n"); }

    if ( !(name in this.multiple_captures) ) { return []; }

    let aref = this.multiple_captures[name];
    return aref;
};

TreePatternMatchResult.prototype.GetCaptureNames = function() {

    return Object.keys(this.single_captures).sort()
};

TreePatternMatchResult.prototype.GetMultiCaptureNames = function() {

    return Object.keys(this.multiple_captures).sort()
};

TreePatternMatchResult.prototype.GetRootCapture = function() {

    return this.matched_subtree_capture;
};

TreePatternMatchResult.prototype.Node = function() {

    let root_cap = this.matched_subtree_capture;

    if (root_cap === undefined || root_cap === null) { return null; }
    return root_cap.Node();
};

TreePatternMatchResult.prototype.Tree = function() {

    let root_cap = this.matched_subtree_capture;

    if (root_cap === undefined || root_cap === null) { return null; }
    return root_cap.Tree();
};

TreePatternMatchResult.prototype.aux_debug_short_print = function(rf_print) {

    rf_print("Match: ");
    this.matched_subtree_capture.aux_debug_short_print(rf_print);
    let k;
    for (k of this.GetCaptureNames())
    {
        print `  ##${k}: `;
        this.Capture(k).aux_debug_short_print(rf_print);
    }
    for (k of this.GetMultiCaptureNames())
    {
        let multi_c = this.MultiCapture(k);
        for (let i = 0; i < multi_c.length; i++)
        {
            print `  ##\@${k} ${i}: `;
            multi_c[i].aux_debug_short_print(rf_print);
        }
    }
};

// ------------------------------------------------------------
// CLASS TreeMatchLib
// ------------------------------------------------------------

var TreeMatchLib = {};

// class method (static)
TreeMatchLib.TreeConstruct = function(tree_class, pattern, arg_root_capture) {
    if ( typeof tree_class == 'string' || tree_class instanceof String
        || !((typeof tree_class == 'function' || typeof tree_class == 'object') &&'newByBox' in tree_class))
    {
        throw Error("Error: called with wrong parameter type (TreeConstruct(tree_class, pattern, root_capture?)). 'tree_class' must be subclass of TreeWrapperBase (54070487_0409e331)\n");
    }


    let root_capture = arg_root_capture;

    if ( root_capture === undefined ||  root_capture === null)
    { root_capture = null; }
    else if ( !(root_capture instanceof MatchCapturePlace) )
    { throw Error("Error: arg(root_capture) has wrong type (e14d9e4c_a5441798)\n"); }
    // else do nothing (normal case)

    let tok = new TLTokenizerSeparated(pattern);
    let ast = TLTreePatternAST.ToTreePatternAST(TreePatternParser.parse(tok.treepat));

    // main::tree_output3($ast);


    let tmp_tree = tree_class.newByRootNode(null);
    let new_iter = new TreeWrapperBaseIterator(tmp_tree);

    new_iter.iter_stack[0].tree = null;
    new_iter.iter_stack[0].sibling_index = 0;
    new_iter.iter_stack[0].sibling_num = 0;
    // 強制的に空の木のイテレータとしている

    let context = {
        tree_class : tree_class,
        node_class : tree_class.NodeClass,
        target_tree : null, // ルート木を設定したときに確定する
        target_iter : new_iter,
        single_capture_list : [],
        multi_capture_list : [],
        root_capture : root_capture // undef if root of target tree
                                       // fixed when root node is generated
    };
    // $astは別に渡す


    this.aux_rec_TreeConstruct(context, ast);
    if (! context.target_iter.IsRoot())
    { throw Error("Error: internal error (3ed1d32c_a149e1a5)\n"); }
    if (! context.target_iter.IsEnd())
    { throw Error("Error: internal error (32ed7b15_d6ffb8ba)\n"); }

    context.target_iter._top().sibling_index = 0; // root node position 
    context.target_iter._top().tree = context.target_tree; // root node position


    let single_captures = {};
    let multi_captures = {};
    {
        let e;
        for (e of context.single_capture_list)
        {
            single_captures[e.name] = e.capture;
        }
        for (e of context.multi_capture_list)
        {
            let name = e.name;
            if (! (name in multi_captures)) { multi_captures[name] = []; }
            multi_captures[name].push(e.capture);
        }
    }

    return new TreePatternMatchResult(
        MatchCapturePlace.newByIterator(context.target_iter, context.root_capture),
        single_captures, multi_captures);
};

// class method (static)
TreeMatchLib.aux_TreeConstruct_add_node = function(context, ast) {

    let ast_node = ast.GetRootNode();

    if (ast_node.Attr0() != 'a_Node')
    { throw Error("Error: internal error (6cb21518_f4fd238e)\n"); }

    // null/any/id/id_regexp/end

    // ノードの種類を確定しノードを作成
    //
    //
    //
    // 種類に関わる属性
    //   {exclude_matched}  '-' に対応
    //   {neg}  '!' に対応
    //   {node_type} = none/any/id/id_regexp/end  それぞれ _ . AA // $ に対応
    //   # {val} Attr1
    //

    let neg = ast_node.GetAttribute('neg');
    let node_type = ast_node.GetAttribute('node_type');

    let new_node;
    if (node_type == 'none')
    {
        new_node = null;
    }
    else if (node_type == 'any')
    { throw Error("Error: can't use 'any' node ('.') in TreeConstruct.\n"); }
    else if (node_type == 'id')
    {
        new_node = new context.node_class({},[]);
        let new_node_id = ast_node.Attr1();
        if (new_node_id === undefined || new_node_id === null)
        {
            new_node_id = 'NEED_SOME_CODE';
        }
        new_node.SetPrimaryAttribute0(new_node_id);
    }
    else if (node_type == 'id_regexp')
    { throw Error("Error: can't use 'regexp' node name (//) in TreeConstruct.\n"); }
    else if (node_type == 'end')
    {
        // just ignore
        // (属性やキャプチャは無視される、エラーにすべきか?)
        return;
    }
    else
    { throw Error(`Error: internal error (node_type = ${node_type}) (b720a3af_0b832a0f)\n`); }





    // 属性を設定する
        // 属性を設定する

    let a_attr_cond_list_node = this.aux_attr0_child(ast, 'a_Attr_Cond_List', 0).GetRootNode();
    a_attr_cond_list_node.ForEachChildNodes(function (attr_cond_node) {
        //    {key_type} sec/other
        //    {match_type} str/regexp
        //    {val} Attr1
        //    {key_val}
        let key_type = attr_cond_node.GetAttribute('key_type');
        let match_type = attr_cond_node.GetAttribute('match_type');
        let val = attr_cond_node.GetPrimaryAttribute1(); // val

        if (node_type == 'null')
        { throw Error("Error: empty node can't have attribute"); }

        if (match_type === undefined || match_type === null)
        { throw Error("Error: internal error (544db9ae_a8b1855f)\n"); }
        if ( match_type == 'regexp' )
        { throw Error("Error: can't use regexp in construction pattern\n"); }
        if ( match_type != 'str' )
        { throw Error(`Error: internal error (match_type = '${match_type}') (006e4942_8ea8cc7c)\n`); }

        if (val === undefined || val === null)
        { throw Error("Error: internal error (db1dab8b_46900b43)\n"); }

        if (key_type == 'sec')
        {
            new_node.SetPrimaryAttribute1(val);
        }
        else if (key_type == 'other')
        {
            let key_val = attr_cond_node.GetAttribute('key_val');
            if (key_val === undefined || key_val === null)
            { throw Error("Error: internal error (da889092_1e96d385)\n"); }

            new_node.SetAttribute(key_val, val);
        }
        else
        { throw Error("Error: internal error (8332821d_c2265966)\n"); }

    } );


    // 追加する(ルートかどうかで場合分け)
    let iter_top_frame = context.target_iter._top();
    if (context.target_iter.IsRoot())
    {
        if (!context.target_iter.IsFirst())
        { throw Error("Error: multiple root node (*)!\n"); }
        if (iter_top_frame.sibling_index != 0)
        { throw Error("Error: multiple root node (**)!\n"); }

        let root_tree = context.tree_class.newByRootNode(new_node);

        context.target_tree = root_tree;

        if (context.root_capture === undefined || context.root_capture === null)
        {
            let rootnode = root_tree.GetRootNode();
            context.root_capture = new MatchCapturePlace(rootnode, root_tree, null);
        }

        iter_top_frame.tree = root_tree;
        iter_top_frame.sibling_index = 0;
        iter_top_frame.sibling_num = 1;
    }
    else
    {
        let iter_parent_frame = context.target_iter._parent_frame();

        let n = iter_parent_frame.tree.GetRootNode().NumChildren();

        if (iter_top_frame.sibling_index != n)
        { throw Error("Error: internal error (511212f8_3021e18b)\n"); }
        if (iter_top_frame.sibling_num != n)
        { throw Error("Error: internal error (4a983a88_00e09ee9)\n"); }

        let parent_node = iter_parent_frame.tree.GetRootNode();
        if (parent_node === undefined || parent_node === null)
        { throw Error("Error: Can't add child to empty node (b04a02ef_8ec7d2db)\n"); }

        parent_node.AppendChildNodes([new_node]);

        iter_top_frame.tree = parent_node.NthChildSubtree(n);
        iter_top_frame.sibling_num = n + 1;
    }
    // Capture を生成する
    let a_place_list_node = this.aux_attr0_child(ast, 'a_Place_List', 1).GetRootNode();
    a_place_list_node.ForEachChildNodes(function (place_node) {
        let place_type = place_node.Attr0();
        let place_name = place_node.Attr1();

        if (place_type == 'a_Single_Place')
        {
            context.single_capture_list.push( {
                name : place_name,
                capture : MatchCapturePlace.newByIterator(
                    context.target_iter, context.root_capture
                )
            } );
        }
        else if (place_type == 'a_Multi_Place')
        {
            context.multi_capture_list.push( {
                name : place_name,
                capture : MatchCapturePlace.newByIterator(
                    context.target_iter, context.root_capture
                )
            } );
        }
        else
        {
            throw Error(`Error: internal error (place_type = ${place_type}) (baf31943_77ead180)\n`);
        }
    } );

};

// class method (static)
TreeMatchLib.aux_rec_TreeConstruct = function(context, ast) {
    // print "[" . $ast->GetRootNode->Attr0 . "]\n";

    // ここでは反復制御は ast の再帰で行う。
    // TreeWrapperBaseIterator は対象木のキャプチャ生成も行う

    if (ast === undefined || ast === null) { return; }

    let cur_node = ast.GetRootNode();
    if (cur_node === undefined || cur_node === null) { return; }

    let cur_node_id = cur_node.Attr0();
    if (cur_node_id === undefined || cur_node_id === null) { cur_node_id = ''; }

    if (cur_node_id == 'a_PathPat')
    {
        if (cur_node.NumChildren() > 0)
        { throw Error("Error: PathPattern must be empty in TreeConstruct()!\n"); }

        return; // no child
    }

    // ノードの種類によって場合分け
    if (cur_node_id == 'a_Node')
    {
        // これがルートノード
        this.aux_TreeConstruct_add_node(context, ast);

        context.target_iter.MoveDown();


        // // a_Child 以下を処理
        let child_list_subtree = this.aux_attr0_child(ast, 'a_Child', 2);

        if (child_list_subtree === undefined || child_list_subtree === null)
        { throw Error("Error: internal error (dbf45ab5_f0ace36e)\n"); }
        let child_list_node = child_list_subtree.GetRootNode();

        let i = 0;
        let n = child_list_node.NumChildren();
        for (i = 0; i < n; i++)
        {
            let child_tree = child_list_node.NthChildSubtree(i);
            this.aux_rec_TreeConstruct(context, child_tree)
        }


        context.target_iter.MoveUp();
        context.target_iter.MoveNextSibling();

        return;
    }
    else if (cur_node_id == 'a_P_Or')
    { throw Error("Error: Can't use OR in TreeConstruct Pattern!\n"); }
    else if (cur_node_id == 'a_Parent_Child')
    { throw Error("Error: internal error (2e59eca7_8d044a5b)\n"); }
    else if (cur_node_id == 'a_Rep0')
    { throw Error("Error: Can't use Repeat in TreeConstruct Pattern!\n"); }
    else if (cur_node_id == 'a_Rep1')
    { throw Error("Error: Can't use Repeat(1) in TreeConstruct Pattern!\n"); }
    else if (cur_node_id == 'a_Rec_ref')
    { throw Error("Error: Can't use recursive reference in TreeConstruct Pattern!\n"); }
    else
    {
        // $node が undef と 'a_PathPat' の場合は上で処理済み
        // いくつかの種類はここではじく必要がある。

        let next_subtrees
            = cur_node.ChildrenKeys().map((i) => cur_node.NthChildSubtree(i)) ;
        for (let t of next_subtrees)
        {
            this.aux_rec_TreeConstruct(context, t);
        }

    }
};

// class method (static)
TreeMatchLib.aux_is_valid_child_index = function(tree, n) {

    if (! (tree instanceof TreeWrapperBase))
    { throw Error("Error: arg0(tree) must be subclass of TreeWrapperBase!\n"); }

    let root_node = tree.GetRootNode();
    if (root_node === undefined || root_node === null) { return 0; }

    if (n < 0) { return 0; }

    let num_child = root_node.NumChildren();
    if (n >= num_child) { return 0; }
    return 1;
};

// class method (static)
TreeMatchLib.aux_nth_child_node_or_undef = function(tree, n) {

    if (! (tree instanceof TreeWrapperBase))
    { throw Error("Error: arg0(tree) must be subclass of TreeWrapperBase!\n"); }

    let root_node = tree.GetRootNode();
    if (root_node === undefined || root_node === null) { return null; }
    if (! this.aux_is_valid_child_index(tree, n)) { return null; }

    return root_node.NthChildNode(n);
};

// class method (static)
TreeMatchLib.aux_nth_child_subtree_or_undef = function(tree, n) {

    if (! (tree instanceof TreeWrapperBase))
    { throw Error("Error: arg0(tree) must be subclass of TreeWrapperBase!\n"); }

    let root_node = tree.GetRootNode();
    if (root_node === undefined || root_node === null) { return null; }
    if (! this.aux_is_valid_child_index(tree, n)) { return null; }

    return root_node.NthChildSubtree(n);
};

// class method (static)
TreeMatchLib.aux_attr0_child = function(tree, value, expected_n) {

    // assertion of $tree will be conducted by subroutine

    let child_node;

    if (this.aux_is_valid_child_index(tree, expected_n))
    {
        child_node = this.aux_nth_child_node_or_undef(tree, expected_n);
        if (child_node !== undefined && child_node !== null)
        {
            let attr = child_node.Attr0();
            if (attr !== undefined && attr !== null && attr == value)
            {
                return this.aux_nth_child_subtree_or_undef(tree, expected_n);
            }
        }
    }
    let root_node = tree.GetRootNode();
    if (root_node === undefined || root_node === null) { return null; }

    let n = root_node.NumChildren();
    for (let i = 0; i < n; i++)
    {
        child_node = this.aux_nth_child_node_or_undef(tree, i);
        if (child_node !== undefined && child_node !== null)
        {
            let attr = child_node.Attr0();
            if (attr !== undefined && attr !== null && attr == value)
            {
                return this.aux_nth_child_subtree_or_undef(tree, expected_n);
            }
        }
    }
    return null;

};

// class method (static)
TreeMatchLib.TreeMatch = function(tree, pattern, base_root_capture, next_capture_list) {
    if ( !(tree instanceof TreeWrapperBase))
    {
        throw Error("Error: called with wrong parameter type ('tree' in TreeMatch(tree, pattern, base_root_capture?, next_capture_list?)) (ea91c8c9_13c110b3)\n");
    }
    if ( !(typeof pattern == 'string' || tree_class instanceof String) )
    {
        throw Error("Error: called with wrong parameter type ('pattern' in TreeMatch(tree, pattern, base_root_capture?, next_capture_list?)) (7de3b148_3f2f0201)\n");
    }


    if (base_root_capture === undefined || base_root_capture === null)
    {
        let rootnode = tree.GetRootNode();
        base_root_capture = new MatchCapturePlace(rootnode, tree, null);
    }

    if (next_capture_list === undefined || next_capture_list === null)
    { next_capture_list = null; } // (perl var: do nothing)

    if (next_capture_list !== undefined && next_capture_list !== null && !Array.isArray(next_capture_list))
    {
        throw Error("Error: next_capture_list (argument 4) must be undefined/null or Array!\n");
    }

    // $next_capture_list は MatchCapturePlase を要素とする配列への参照
    // または undef
    //
    //
    // パスパターンの処理をしてから、ツリーパターンの処理をする

    let tok = new TLTokenizerSeparated(pattern);

    // 0a. パスパターンの AST を作る (まだパースして構文木を作るところまで)
    let st_path_pattern = PathPatternParser.parse(tok.pathpat);

    //
    // 
    // context =
    //     iter_pattern_ast  パターンASTイテレータ   (バックトラックでは要コピー)
    //     iter_target_tree  対象木ASTイテレータ     (バックトラックでは要コピー)
    // (不要か)    block_level       現在の括弧のレベル     (int:要コピー)
    //     backtrack_stack  バックトラックスタック [ マッチしなければ pop して復元 ]
    //     next_node_capture_list  次検索ノードキャプチャリスト (単調増加リスト)
    //     next_node_child_level  次検索ノードから何段階の子か?
    //                  '-' で exclude されたノードから何個下の子か
    //     single_capture_list            キャプチャリスト             (単調増加リスト)
    //     multi_capture_list            キャプチャリスト             (単調増加リスト)
    //
    //     non_order_matched_siblings_flame_stack (インデックス集合のハッシュのスタック)
    //     below_neg_node  0or1

    // backtrack_stack_element =
    //     iter_pattern_ast => TreeWrapperBaseIterator   書き戻し用の複製
    //     iter_target_tree => TreeWrapperBaseIterator   書き戻し用の複製
    //
    //     root_capture => MatchCapturePlace ルートノードのパス情報
    // (不要か) block_level      => Int                   書き戻し用
    //     next_node_capture_list_trim_length => 要素数:Int  切り詰め後の長さ
    //     next_node_child_level   => :Int
    //     single_capture_list_trim_length   => 要素数:Int   切り詰め後の長さ
    //     multi_capture_list_trim_length    => 要素数:Int   切り詰め後の長さ
    //
    //     non_order_matched_siblings_flame_stack 各ハッシュからのコピー
    //     below_neg_node  0 or 1                 単純値コピー
    //
    // _do_backtrack() ...


    // 1. ツリーパターンのAST を作る

    let ast_tree_pattern_tree = TLTreePatternAST.ToTreePatternAST(TreePatternParser.parse(tok.treepat));
    let ast_path_pattern_tree = null;


    // if ($ast_path_pattern_tree->GetRootNode()->Attr0 ne 'a_Path_Pat')
    // { confess "Error: internal error (8e62129d_c660a265)\n"; }

    // if ($ast_tree_pattern_tree->GetRootNode()->Attr0 ne 'a_Tree_Pat')
    // { confess "Error: internal error (f62f34c3_528f21ad)\n"; }


    // // とりあえず path pattern が指定されていたらエラーにしておく
    // if ($ast_path_pattern_tree->GetRootNode()->NumChildren() > 0)
    // { confess "Error: path pattern is not yet implemented (TreeMatch) (3ec8111f_9507532b)\n"; }



    // 2. path pattern の matching の準備をする
    //
    let single_capture_list = [];
    let multi_capture_list = [];
    // 3. path pattern の matching をする
    //

    // do something

    // 4. コンテキスト変数を設定
    let context = {
        // パターンASTイテレータ   (バックトラックでは要コピー)
        iter_pattern_ast : new TreeWrapperBaseIterator(ast_tree_pattern_tree),

        // 対象木イテレータ     (バックトラックでは要コピー)
        iter_target_tree : new TreeWrapperBaseIterator(tree),

        // (不要) block_level       現在の括弧のレベル     (int:要コピー)

        // バックトラックスタック [ マッチしなければ pop して復元 ]
        backtrack_stack : [],
        // 次検索ノードキャプチャリスト (単調増加リスト)
        next_node_capture_list : next_capture_list,
        // 次検索ノード('-' で除外されたもの)から何段階の子か?
        next_node_child_level : 0,
        // キャプチャリスト             (単調増加リスト)
        single_capture_list : single_capture_list,
        multi_capture_list  : multi_capture_list,

        non_order_matched_siblings_flame_stack : [],
        below_neg_node : 0,

        root_capture : base_root_capture
    };

    // 5. tree pattern の matching をする

    let success = this.aux_TreeMatch_traverse_tree_pat(context);
    if (!success)
    {
        // マッチに失敗したら、全ての子要素を次探索対象として
        // 結果オブジェクトの代わりに undef を返す
        if (next_capture_list !== undefined && next_capture_list !== null)
        {
            next_capture_list.length = 0; // empty the array

            let iter_target = new TreeWrapperBaseIterator(tree);
            if (iter_target.Node() !== undefined && iter_target.Node() !== null)
            {
                iter_target.MoveDown();
                while (! iter_target.IsEnd())
                {
                    next_capture_list.push(
                        MatchCapturePlace.newByIterator(iter_target, context.root_capture) );
                    iter_target.MoveNextSibling();
                }
            }

        }
        return null;
    }


    // 6. capture_list を設定する
    //
    let single_captures = {};
    let multi_captures = {};
    {
        let e;
        for (e of single_capture_list)
        {
            single_captures[e.name] = e.capture;
        }
        for (e of multi_capture_list)
        {
            let name = e.name;
            if(! (name in multi_captures)) { multi_captures[name] = []; }
            multi_captures[name].push(e.capture);
        }
    }

    // 7. 結果オブジェクトを設定する

    return new TreePatternMatchResult(
        MatchCapturePlace.newByIterator(
            new TreeWrapperBaseIterator(tree),
            context.root_capture
        ),
        single_captures, multi_captures );
};

// class method (static)
TreeMatchLib.aux_TreeMatch_traverse_tree_pat = function(context) {

    // 返り値 マッチ:1 / マッチせず:0
    // TreeMatch の実際の反復部分

    while(1)
    {
        // $context->{iter...} が指す先はバックトラックすると変わるので、
        // 毎回 update する。
        let iter_pat = context.iter_pattern_ast;
        let iter_target = context.iter_target_tree;
        // print "[" . $ast->GetRootNode->Attr0 . "]\n";

        // ここでは反復制御は $context->{iter_pattern_ast} で行う。

        if (iter_pat.IsEnd())
        {
            // Up して
            //   Root だったら 成功として return
            //   Root でなければ
            //       a_Child なら target を MoveUP する
            //       MoveNextSibling して継続




            iter_pat.MoveUp();
            if (iter_pat.IsRoot()) { return 1; }

            // Up 直後

            if (iter_pat.Node().Attr0() == 'a_Child')
            {
                // a_Non_Order の親ではなく a_Child に遷移したばあい
                // target の UP をする前に残りの兄弟を next_capture に追加する

                if ( context.next_node_child_level == 0
                    && context.next_node_capture_list !== undefined && context.next_node_capture_list !== null )
                {
                    while (! iter_target.IsEnd())
                    {
                        context.next_node_capture_list.push(
                            MatchCapturePlace.newByIterator( iter_target , context.root_capture)
                        );
                        iter_target.MoveNextSibling();
                    }
                }

                if (context.next_node_child_level > 0)
                {
                    context.next_node_child_level --;
                }

                iter_target.MoveUp();
                iter_target.MoveNextSibling();
            }
            else if (iter_pat.Node().Attr0() == 'a_Non_Order')
            {
                // 順番なしのノードに Up した場合
                // a_Non_Order での処理から移した

                // (a_Child >) a_Non_Order
                // 親のID
                let p_id = iter_pat.iter_stack[ iter_pat.iter_stack.length - 2 ].tree.GetRootNode().Attr0();
                // # 親の親のID
                // my $pp_id = $iter_pat->{iter_stack}->{ @{ $iter_pat->{iter_stack}} - 3}->Node()->Attr0();;
                if (p_id != 'a_Child')
                {
                    throw Error("Error: Internal Error violated structure of AST 'a_Child > a_Non_Order'  (77da61d2_daeeffca)\n");
                }


                let dup_iter_target = iter_target.Duplicate();
                dup_iter_target.MoveUp();
                dup_iter_target.MoveDown();

                let frame_top = context.non_order_matched_siblings_flame_stack.pop();

                if ( context.next_node_child_level == 0
                    && context.next_node_capture_list !== undefined && context.next_node_capture_list !== null)
                {
                    let i = 0;
                    while (! dup_iter_target.IsEnd())
                    {
                        if (! ((i in frame_top) && frame_top[i]))
                        {
                            context.next_node_capture_list.push (
                                MatchCapturePlace.newByIterator( dup_iter_target , context.root_capture)
                            );
                        }
                        i++;

                        dup_iter_target.MoveNextSibling();

                    }
                }
                if (context.next_node_child_level > 0)
                {
                    context.next_node_child_level --;
                }

                iter_pat.MoveUp(); // a_Child に up してしまう。
                iter_target.MoveUp();
                iter_target.MoveNextSibling();
            }

            iter_pat.MoveNextSibling();
            continue;
        }

        let node_id = iter_pat.Node().Attr0();

        if (node_id == 'a_Node')
        {
            if (iter_pat.Node().GetAttribute('ordered'))
            {
                // 順番ありのノード
                // ax_Non_Order_Node_Do_Match_Single と一部重複
                //

                // ノードがマッチするかチェックして
                let result = this.aux_TreeMatch_match_single_node(context);

                // マッチしなければバックトラック
                //     バックトラックするものが無ければ return FALSE
                // マッチしたら
                //     ast を a_Child に MoveDown (3番目)jして
                //     a_Child が空なら
                //         next_captures をセットして
                //         ast を UP し MovNext
                //     a_Child が空でなければ
                //         パターンが '$'か'_' ならエラー(die)
                //         target を MoveDown して子要素の探索に進む
                if (! result )
                {
                    // マッチしなかったのでバックトラック
                    // バックトラックするものが無ければ return FALSE
                    if ( context.backtrack_stack.length == 0) { return 0; }

                    this.aux_TreeMatch_do_backtrack(context);

                    // print "!!! BACKTRACK !!!\n";
                    //     $context->{iter_pattern_ast}->Tree()->TreePrint();
                    //     $context->{iter_target_tree}->Tree()->TreePrint();

                    continue;
                }

                // 単一ノードのマッチに成功した場合 (子要素のマッチに進む)
                //
                // ただし end ($: 幅0 マッチ) だった場合は
                //    パターンの次の要素に進める。
                //    (ターゲットの子要素は見れないはずなので。)
                if (iter_pat.Node().GetAttribute('node_type') == 'end')
                {
                    iter_pat.MoveNextSibling();
                    continue;
                }

                iter_pat.MoveDown();
                // 1番目の子 = a_Attr_Cond_List
                if (iter_pat.Node().Attr0() != 'a_Attr_Cond_List')
                { throw Error("Error: internal error (c9b1fe13_fe0d0288)\n"); }

                iter_pat.MoveNextSibling();
                // 2番目の子 = a_Place_List
                if (iter_pat.Node().Attr0() != 'a_Place_List')
                { throw Error("Error: internal error (86041b5e_963b0222)\n"); }

                iter_pat.MoveNextSibling();
                // 3番目の子 = a_Child
                if (iter_pat.Node().Attr0() != 'a_Child')
                { throw Error("Error: internal error (90ef8bd1_67a1417a)\n"); }


                // 対象木を子に移す
                iter_target.MoveDown();

                // そして 子の a_Child から パターン木の探索を続ける
                // 親にもどるのは Up 時に a_Child をチェックして行う

                continue;
            }
            else
            {
                // 順不動のノード 'a_Node' {ordered==0}

                // 'ax_Non_Order_Do_Match_Single' の処理時も
                //     ほぼ同じ

                //   Target を Up Down して先頭に巻き戻す

                iter_target.MoveUp();
                iter_target.MoveDown();

                //   パターンAST実行時ノードとして
                //   ax_Non_Order_Node_Next{cancelled=0, link_to_node_pat} を作り
                //       BackTrack Stack に積んだ ターゲットIterator をNextSiblingして
                //       BackTrack Stack に積んだ パターンIterator をそれに ForceDown しておく。
                //       (ただし最後のノードなら、次は積まない)
                //
                //     ax_Non_Order_Node_Do_Match_Single を作りメインのパターンイテレータを ForceDown(ax_Non_Order_Node_Do_Match_Single)する
                //         ただし、ax_Non_Order_Node_Do_Match_Single は a_Node{ordered==0} のほぼコピー
                //            + cancel_link を足したもの

                let n_siblings = iter_target._top().sibling_num;

                if (n_siblings == 0)
                {
                    // マッチするノードが無い
                    this.aux_TreeMatch_do_backtrack(context);
                    continue;
                }
                else
                {
                    // else(順不動の a_Node) はここから

                    // ax_Non_Order_Node_Do_Match_Single にもほぼ同様の
                    //     内容


                    // ターゲットの兄弟が 1 or 2以上
                    let pat_tree_class = iter_pat.Node().constructor.TreeClass;
                    let pat_node_class = iter_pat.Node().constructor.NodeClass;

                    console.log('== pat_node_class');
                    console.log(pat_node_class);
                    console.log('== iter_pat.Node()');
                    console.log(iter_pat.Node());
                    let ax_node_single = new pat_node_class(
                            Object.assign({}, iter_pat.Node().attr), // copy
                            iter_pat.Node().ChildNodeList().slice()  // copy
                        ); // Object.assign({}, obj) makes copy of obj
                    ax_node_single.SetPrimaryAttribute0('ax_Non_Order_Node_Do_Match_Single');
                    ax_node_single.SetAttribute('cancel_link', null);

                    // ターゲットの兄弟 2以上ならバックトラック対象を追加
                    if (n_siblings >= 2 )
                    {
                        let dup_iter_pat = iter_pat.Duplicate();
                        let dup_iter_target = iter_target.Duplicate();

                        dup_iter_target.MoveNextSibling();


                        let ax_next = new pat_node_class( { cancelled : 0, a_node_pat_node : iter_pat.Node() }, []);
                        ax_next.SetPrimaryAttribute0('ax_Non_Order_Node_Next');
                        ax_node_single.SetAttribute('cancel_link', ax_next);

                        dup_iter_pat.MoveDownForce(pat_tree_class.newByRootNode(ax_next));
                        this.aux_TreeMatch_push_backtrack_stack(context, dup_iter_pat, dup_iter_target);
                    }


                    iter_pat.MoveDownForce(pat_tree_class.newByRootNode(ax_node_single));
                    iter_pat.OnUpDo(
                        function()
                        {
                        // (2.5) MoveUp したらax_Non_Order_Node_Do_Match_Single
                        //      だったときマッチに成功したので、
                        //     cancel_link の先の ax_NonOrder_Node_Next の
                        //     {cancelled} をセットする   (枝切り)
                        //
                        //     Non_Order_Siblings フレームの候補にマッチ済みのマークをする
                        //     この実行時ASTノードに兄弟はいない(一応確認する)ので、さらに Up->Next する
                            if (ax_node_single.cancel_link !== undefined && ax_node_single.cancel_link !== null)
                            {
                                ax_node_single.cancel_link.cancelled = 1;
                            }

                            // (a_Node >) ax_Non_Order_Do_Match_Single
                            //     に戻ってきたところなので、
                            // a_Node までUp して、a_Node の次を指すようにする

                            iter_pat.MoveUp();
                            // (ここはなにもしない。)
                        }
                    );

                }

                continue;
                // else(順不動の a_Node) はここまで
            }
            // ここには到達しない ( if: next, else: next なので )
        }
        if (node_id == 'a_Non_Order')
        {
            // まだマッチした兄弟ノードは無いので、空の ハッシュを追加
            context.non_order_matched_siblings_flame_stack.push( {} );
            iter_pat.MoveDown();
            continue;

        }
        if (node_id == 'ax_Non_Order_Node_Next')
        {
            // 順不動の a_Node と重複
            if (iter_pat.Node().GetAttribute('cancelled'))
            {
                // (2.3) ax_Non_Order_Node_Next{cancelled==1} に入ったら
                //     Fail and backtrack (過去にマッチして進んだものと同じ結果となるはず)
                this.aux_TreeMatch_do_backtrack(context);
                continue;
            }


            // (2.2) ax_Non_Order_Node_Next{cancelled==0} に入ったら
            // (つまりSingleNodeMatch が否定されてバックトラックした直後)
            //     パターンAST実行時ノードとして
            //     ax_Non_Order_Node_Next{cancelled=0, a_node_pt_node} を作り
            //         BackTrack Stack に積んだ ターゲットIterator をNextSiblingして
            //         BackTrack Stack に積んだ パターンIterator を(Next はせずにい Node_Next が最上位のままにする。
            //         (ただし最後のノードなら、次は積まない)


            let pat_tree_class = iter_pat.Node().constructor.TreeClass;
            let pat_node_class = iter_pat.Node().constructor.NodeClass;

            let a_node_pat_node = iter_pat.Node().GetAttribute('a_node_pat_node');

            let ax_node_single = new pat_node_class(
                    Object.assign({}, a_node_pat_node.attr), //copy
                    a_node_pat_node.ChildNodeList().slice()  //copy
                );
            ax_node_single.SetPrimaryAttribute0('ax_Non_Order_Node_Do_Match_Single');
            ax_node_single.SetAttribute('cancel_link', null);

            if (iter_target._top().sibling_num - iter_target._top().sibling_index > 1)
            {
                // 最後の候補ノードではないとき
                //     バックトラックに積む
                // 最後の候補ノードでは積まない。


                let dup_iter_pat = iter_pat.Duplicate();
                let dup_iter_target = iter_target.Duplicate();

                dup_iter_target.MoveNextSibling();


                let ax_next = new pat_node_class( { cancelled : 0, a_node_pat_node : a_node_pat_node}, [] );
                ax_next.SetPrimaryAttribute0('ax_Non_Order_Node_Next');
                ax_node_single.SetAttribute('cancel_link', ax_next);

                dup_iter_pat.MoveDownForce(pat_tree_class.newByRootNode(ax_next));
                this.aux_TreeMatch_push_backtrack_stack(context, dup_iter_pat, dup_iter_target);
            }


            iter_pat.MoveDownForce(pat_tree_class.newByRootNode(ax_node_single));
            iter_pat.OnUpDo(
                function()
                {
                // (2.5) MoveUp したらax_Non_Order_Node_Do_Match_Single
                //      だったときマッチに成功したので、
                //     cancel_link の先の ax_NonOrder_Node_Next の
                //     {cancelled} をセットする   (枝切り)
                //
                //     Non_Order_Siblings フレームの候補にマッチ済みのマークをする
                //     この実行時ASTノードに兄弟はいない(一応確認する)ので、さらに Up->Next する
                    if (ax_node_single.cancel_link !== undefined && ax_node_single.cancel_link !== null)
                    {
                        ax_node_single.cancel_link.cancelled = 1;
                    }

                    // (a_Node >) ax_Non_Order_Do_Match_Single
                    //     に戻ってきたところなので、
                    // a_Node までUp して、a_Node の次を指すようにする

                    iter_pat.MoveUp();
                    // (ここはなにもしない。)
                }
            );

            continue;
        }
        if (node_id == 'ax_Non_Order_Node_Do_Match_Single')
        {
            // a_Node {順序あり}と一部重複している

                // ノードがマッチするかチェックして
                let result = this.aux_TreeMatch_match_single_node(context);

                // マッチしなければバックトラック
                //     バックトラックするものが無ければ return FALSE
                // マッチしたら
                //     ast を a_Child に MoveDown (3番目)jして
                //     a_Child が空なら
                //         next_captures をセットして
                //         ast を UP し MovNext
                //     a_Child が空でなければ
                //         パターンが '$'か'_' ならエラー(die)
                //         target を MoveDown して子要素の探索に進む
                if (! result)
                {
                    // マッチしなかったのでバックトラック
                    // バックトラックするものが無ければ return FALSE
                    if (context.backtrack_stack.length == 0) { return 0; }

                    this.aux_TreeMatch_do_backtrack(context);

                    // print "!!! BACKTRACK !!!\n";
                    //         $context->{iter_pattern_ast}->Tree()->TreePrint();
                    //         $context->{iter_target_tree}->Tree()->TreePrint();

                    continue;
                }

                // 単一ノードのマッチに成功した場合 (子要素のマッチに進む)
                //
                // ただし end ($: 幅0 マッチ) だった場合は
                //    パターンの次の要素に進める。
                //    (ターゲットの子要素は見れないはずなので。)
                if (iter_pat.Node().GetAttribute('node_type') == 'end')
                {
                    iter_pat.MoveNextSibling();
                    continue;
                }

                iter_pat.MoveDown();
                // 1番目の子 = a_Attr_Cond_List
                if (iter_pat.Node().Attr0() != 'a_Attr_Cond_List')
                { throw Error("Error: internal error (c9b1fe13_fe0d0288)\n"); }

                iter_pat.MoveNextSibling();
                // 2番目の子 = a_Place_List
                if (iter_pat.Node().Attr0() != 'a_Place_List')
                { throw Error("Error: internal error (86041b5e_963b0222)\n"); }

                iter_pat.MoveNextSibling();
                // 3番目の子 = a_Child
                if (iter_pat.Node().Attr0() != 'a_Child')
                { throw Error("Error: internal error (90ef8bd1_67a1417a)\n"); }


                // 対象木を子に移す
                iter_target.MoveDown();

                // そして 子の a_Child から パターン木の探索を続ける
                // 親にもどるのは Up 時に a_Child をチェックして行う

            continue;
        }
        if (node_id == 'a_P_Or')
        {
            let or_node = iter_pat.Node();
            let n_or = or_node.NumChildren();
            let or_node_NodeClass = or_node.constructor.NodeClass;
            let or_node_TreeClass = or_node.constructor.TreeClass;

            if (n_or == 0)
            { throw Error("Error: internal error (d5efc593_d47cf72f)\n"); }
            if (n_or == 1)
            {
                // 「p_Or の下」に MoveDownForce する
                iter_pat.MoveDownForce( or_node.NthChildSubtree(0) );
                continue;
            }

            // $n >=2 のとき
            //
            // (p_Or > (2番目以降の子...) ) を作ってバックトラックに積む
            // 「p_Or の1番目の子」に MoveDownForce する
            let or_head_subtree = or_node.NthChildSubtree(0);

            // バックトラック用の subtree を作成
            let or_tail_nodes = [];
            // 先頭を除外した繰り返し
            for (let i = 1; i < n_or; i++)
            {
                or_tail_nodes.push( or_node.NthChildNode(i) );
            }

            let new_or_node = new or_node_NodeClass({}, or_tail_nodes);
            new_or_node.SetPrimaryAttribute0('a_P_Or');
            let new_or_tree = or_node_TreeClass.newByRootNode(new_or_node);

            // バックトラック用のイテレータを作成し、バックトラックスタックにpush
            let iter_pat_backtrack = iter_pat.Duplicate();
            let iter_target_backtrack = iter_target.Duplicate();

            iter_pat_backtrack.MoveDownForce(new_or_tree);

            // print "!!! BACKTRACK_PUSH !!!\n";
            //         $iter_pat_backtrack->Tree()->TreePrint();
            //         $iter_target_backtrack->Tree()->TreePrint();

            this.aux_TreeMatch_push_backtrack_stack(context, iter_pat_backtrack, iter_target_backtrack);

            // パターンAST の OR の一番目の子要素で探索を続ける。

            iter_pat.MoveDownForce(or_head_subtree);

            // print "!!! (BACKTRACK) GO WITH !!!\n";
            //         $iter_pat->Tree()->TreePrint();

            continue;
        }
        if (node_id == 'a_Rep0' || node_id == 'a_Rep1' )
        {
            let rep_node = iter_pat.Node();
            if (rep_node.NumChildren() != 1)
            {
                throw Error("Error: internal error (repeat node must has exact one children) (6c108dd7_53125189)\n");
            }
            // rep0 longest なら
            //     or(seq(child, rep0), empty_seq )
            // rep0 shortest なら
            //     or(empty_seq, seq(child, rep0S))
            // rep1 longest なら
            //     seq (child, rep0L) )
            // rep1 shortest なら
            //     seq (child, rep0S)
            // にそれぞれ ForceDown する

            let ast_node_class = rep_node.constructor.NodeClass;
            let ast_tree_class = rep_node.constructor.TreeClass;

            let rep_child = rep_node.NthChildNode(0);

            if (node_id == 'a_Rep0')
            {
                // create seq(child, rep0) / seq(child, rep0S)
                let seq_node = new ast_node_class({}, [rep_child, rep_node]);
                seq_node.SetPrimaryAttribute0('a_Seq');

                // create empty_seq
                let empty_seq_node = new ast_node_class({}, []); // no child
                empty_seq_node.SetPrimaryAttribute0('a_Seq');

                let or_node;
                if (rep_node.GetAttribute('shortest'))
                {
                    // rep0 shortest:    or(empty_seq, seq(child, rep0S))
                    or_node = new ast_node_class({}, [empty_seq_node, seq_node]);
                    or_node.SetPrimaryAttribute0('a_P_Or');
                }
                else
                {
                    // Rep0 longest:    or(seq(child, rep0), empty_seq )
                    or_node = new ast_node_class({}, [seq_node, empty_seq_node]);
                    or_node.SetPrimaryAttribute0('a_P_Or');
                }
                iter_pat.MoveDownForce(ast_tree_class.newByRootNode(or_node));
            }
            else
            {
                // in case $node_id eq 'a_Rep1'
                //     rep1 longest なら    seq (child, rep0L) )
                //     rep1 shortest なら   seq (child, rep0S)
                // create rep0L / rep0S
                let rep0_node = new ast_node_class({}, [rep_child]);
                rep0_node.SetPrimaryAttribute0('a_Rep0');
                rep0_node.SetAttribute('shortest', rep_node.GetAttribute('shortest'));
                let seq_node = new ast_node_class({}, [rep_child, rep0_node]);
                seq_node.SetPrimaryAttribute0('a_Seq');
                iter_pat.MoveDownForce(ast_tree_class.newByRootNode(seq_node));
            }
            continue;
        }
        if (node_id == 'a_Rec_Ref')
        {
            // TODO: TODO :
            //     PatAST で a_RecRef の空の子要素が
            //     (誤って)生成されているようなので、
            //     Lex を修正しないといけない。
            //     (Sample35 には他のエラーもある)
            //     
            //     TreeConstruct で $ が入ってきたときのエラーが不適切
            //

            // 参照ブロックの番号(何個外のブロックか)を取り出す
 
            let num_orig = iter_pat.Node().GetAttribute('num');
            let num = num_orig;
            if (num <= 0)
            {
                throw Error(`Error: (?-${num_orig}): N of (?-N) (num of a_Rec_Rec) must not be zero   (e61e4ec5_c2d7a6d8)\n`);
            }
            // print "[a_RecRef ->{num} = $num]\n";

            // 再帰参照ブロックの 部分木を探す
            // @{ $iter_pat->{iter_stack} } の先頭がRoot, 末尾が今の a_Rec_Ref
            let ref_subtree = null;
            for (let i = iter_pat.iter_stack.length - 2; i >= 0; i--)
            {
                // print "  <$i / $num>\n";
                let cur = iter_pat.iter_stack[i].tree;
                if (cur.GetRootNode().Attr0() == 'a_Block') { num--; }
                if (num == 0)
                {
                    ref_subtree = cur;
                    break;
                }
            }
            if (ref_subtree === undefined || ref_subtree === null)
            {
                throw Error("Error: no ref block for (?-$num_orig) (609ffb07_7660c0fd)\n");
            }
            iter_pat.MoveDownForce(ref_subtree);

            continue;
        }
        if (node_id == 'a_Child'
            || node_id == 'a_Tree_Pat'
            // || node_id == 'a_Root'    # path パターンを分離したので不要に
            || node_id == 'a_Seq'
            || node_id == 'a_Block'
        )
        {
            iter_pat.MoveDown();
            continue;
        }

        throw Error(`Error: not implemented (node_id = ${node_id}) (1a97f567_50bc11d6)\n`);
    }
    throw Error("Error: internal error (96076321_3246bbf0)\n");
};

// class method (static)
TreeMatchLib.aux_TreeMatch_match_single_node = function(context) {

    // 返り値 マッチ:1 / マッチせず:0
    // キャプチャの追加まではする。

    let iter_pat = context.iter_pattern_ast;
    let iter_target = context.iter_target_tree;

    let pat_node = iter_pat.Node();

    if ( pat_node.Attr0() != 'a_Node' && pat_node.Attr0() != 'ax_Non_Order_Node_Do_Match_Single')
    { throw Error("Error: internal error (" + pat_node.Attr0() + ") (79d836bf_12406453)\n"); }

    let neg = pat_node.GetAttribute('neg');
    let match_failed = 0; // 失敗したら 1 (neg が真ならあとで反転する)

    let pat_node_type = pat_node.GetAttribute('node_type');

    if (pat_node_type == 'end')
    {
        if (! iter_target.IsEnd()) { match_failed = 1; }
        // confess "Error: ?? (8f8ebd83_cb1bb4b4)\n";
    }
    else if (iter_target.IsEnd())
    {
        // none/any/id/id_regexp なのに IsEnd ならマッチせず
        // ここでは常にマッチせず
        // そして、処理するノードが無いので、neg でも失敗し、
        // exclude もキャプチャもできないので、即時 return する。
        // $match_failed = 1;
        return 0;
    }
    else if (pat_node_type == 'none')
    {
        let target_node = iter_target.Node();

        if (target_node !== undefined && target_node !== null)
        { match_failed = 1; }
    }
    else if (pat_node_type == 'any')
    {
        // 兄弟の終端ではないことは保証されているので常にマッチする
        // match!
    }
    else if (pat_node_type == 'id')
    {
        // 兄弟の終端ではないことは保証されている
        let target_node = iter_target.Node();

        if (target_node === undefined || target_node === null)
        { match_failed = 1; }
        else if (target_node.Attr0() === undefined || target_node.Attr0() === null)
        { match_failed = 1; }
        else if (target_node.Attr0() != pat_node.Attr1())
        { match_failed = 1; }
    }
    else if (pat_node_type == 'id_regexp')
    {
        let target_node = iter_target.Node();

        if (target_node === undefined || target_node === null)
        { match_failed = 1; }
        else if (target_node.Attr0() === undefined || target_node.Attr0() === null)
        { match_failed = 1; }
        else
        {
            let pat_str = pat_node.Attr1();

            if (pat_node.GetAttribute('option_str') != '')
            { throw Error("Error: not yet implemented (option of regexp node) (1778c0c6_1eb8c8d6)\n"); }

            try{
                let re = new RegExp(pat_str); // option は RegExp(pat_str, flags);
                let match_result = re.test(target_node.Attr0());
                if (! match_result ) { match_failed = 1; }
                // else: match!
            } catch (err) {
                console.log(`Error: wrong RegExp pattern /${pat_str}/! (6f48daf3_1157a1f7)\n`);
                console.log(err);
                throw Error(`Error: wrong RegExp pattern /${pat_str}/ (6f48daf3_1157a1f7)!\n` + err.message, { cause: err });
            }
        }
    }
    else
    { throw Error(`Error:  internal error (pat_node_type = ${pat_node_type}) (083785d8_c02c205a)\n`); }


    // 2. 属性のチェック
    if (! match_failed )
    {
        // ここまででマッチしていないことが確定している場合は属性のチェックをスキップする

        if ( pat_node_type != 'end'
            && iter_target.Node() !== undefined && iter_target.Node() !== null)
        {

            // end には属性がないはずなので end の場合はスキップする
            // end でなくここまででマッチしていれば、IsEnd ではない。
            // だがノードが空(undef/null) の場合はスキップする
            let a_attr_cond_list_node = this.aux_attr0_child(iter_pat.Tree(), 'a_Attr_Cond_List', 0).GetRootNode();
            for (let attr_cond_node of a_attr_cond_list_node.ChildNodeList())
            {
                //    $attr_cond_node :
                //        {key_type} sec/other
                //        {match_type} str/regexp
                //        {val} Attr1
                //        {key_val}
                let key_type = attr_cond_node.GetAttribute('key_type');
                let match_type = attr_cond_node.GetAttribute('match_type');
                let val = attr_cond_node.GetPrimaryAttribute1(); // val


                let target_val = null;
                if (key_type == 'sec')
                {
                    target_val = iter_target.Node().GetPrimaryAttribute1();
                }
                else if (key_type == 'other')
                {
                    let key_val = attr_cond_node.GetAttribute('key_val');
                    if (key_val === undefined || key_val === null)
                    { throw Error("Error: internal error (c4ab0bd1_72026642)\n"); }

                    target_val = iter_target.Node().GetAttribute(key_val);
                }
                else
                { throw Error("Error: internal error (86f76a74_7c2a3b3c)\n"); }



                if (match_type === undefined || match_type === null)
                { throw Error("Error: internal error (fe833894_21fd24aa)\n"); }

                if (val === undefined || val === null)
                { throw Error("Error: internal error (15dd0b4a_5aa64f16)\n"); }


                if ( match_type == 'str' )
                {
                    if (target_val === undefined || target_val === null)
                    { match_failed = 1; break; }
                    if (target_val != val) { match_failed = 1; break; }
                }
                else if ( match_type == 'regexp' )
                {
                    if (target_val === undefined || target_val === null)
                    { match_failed = 1; break; }

                    if (attr_cond_node.GetAttribute('option_str') != '')
                    { throw Error("Error: not yet implemented (option of regexp attribute match) (ce85534b_da2560b2)\n"); }

                    let pat_str = val;

                    try{
                        let re = new RegExp(pat_str); // option は RegExp(pat_str, flags);
                        let match_result = re.test(target_val);
                        if (! match_result ) { match_failed = 1; break; }
                        // else: match!
                    } catch (err) {
                        console.log(`Error: wrong RegExp pattern /${pat_str}/! (ba44a5de_07c05ea7)\n`);
                        console.log(err);
                        throw Error(`Error: wrong RegExp pattern /${pat_str}/! (ba44a5de_07c05ea7)!\n` + err.message, { cause: err });
                    }
                }
            }
        }
    }

    // 3. キャプチャの生成

    let a_place_list_node = this.aux_attr0_child(iter_pat.Tree(), 'a_Place_List', 1).GetRootNode();
    a_place_list_node.ForEachChildNodes(function(place_node) {
        let place_type = place_node.Attr0();
        let place_name = place_node.Attr1();

        if (place_type == 'a_Single_Place')
        {
            context.single_capture_list.push( {
                name : place_name,
                capture : MatchCapturePlace.newByIterator( iter_target, context.root_capture )
            } );
        }
        else if (place_type == 'a_Multi_Place')
        {
            context.multi_capture_list.push( {
                name : place_name,
                capture : MatchCapturePlace.newByIterator( iter_target, context.root_capture )
            } );
        }
        else
        {
            throw Error(`Error: internal error (place_type = ${place_type}) (baf31943_77ead180)\n`);
        }
    } );

    // 4. next node の追加は、このノードだけやって、
    // 子/末弟については たぶん Up に任せれば OK

    if (pat_node_type != 'end')
    {
        // end (幅0マッチ) の場合はなにもしない

        if (context.next_node_child_level == 0)
        {
            if (iter_pat.Node().GetAttribute('ordered'))
            {
                if (iter_pat.Node().GetAttribute('exclude_mached'))
                {
                    if (context.next_node_capture_list !== undefined && context.next_node_capture_list !== null)
                    {
                        context.next_node_capture_list.push(
                            MatchCapturePlace.newByIterator( iter_target, context.root_capture )
                        );
                    }
                    context.next_node_child_level ++;
                }
            }
            else
            {
                // 順序なしの場合
                if (! iter_pat.Node().GetAttribute('exclude_mached'))
                {
                    let ra_matched_stack = context.non_order_matched_siblings_flame_stack;
                    ra_matched_stack[ra_matched_stack.length - 1][ iter_target._top().sibling_index ] = 1;

                }
                else
                {
                    context.next_node_child_level ++;
                }
            }
        }
        else
        {
                context.next_node_child_level ++;
        }
    }

    if (! match_failed) { return neg ? 0 : 1; } // マッチしていた場合
    else  { return neg ? 1 : 0; } // マッチに失敗した場合
};

// class method (static)
TreeMatchLib.aux_TreeMatch_push_backtrack_stack = function(context, iter_pat_copy, iter_target_copy) {

    if( !('iter_pattern_ast' in context)
        || iter_pat_copy === undefined || iter_pat_copy === null
        || iter_target_copy === undefined || iter_target_copy === null )
    { throw Error("Error: internal error (wrong argument) (41017456_7d341182)\n"); }

    let next_node_capture_list_length = null;
    if (context.next_node_capture_list !== undefined && context.next_node_capture_list !== null)
    {
        next_node_capture_list_length = context.next_node_capture_list.length;
    }

    let entry = {
        iter_pattern_ast : iter_pat_copy,
        iter_target_tree : iter_target_copy,

        next_node_capture_list_trim_length
            : next_node_capture_list_length,
        next_node_child_level : context.next_node_child_level,
        single_capture_list_trim_length
            : context.single_capture_list.length,
        multi_capture_list_trim_length
            : context.multi_capture_list.length,

        non_order_matched_siblings_flame_stack :
            context.non_order_matched_siblings_flame_stack.map((o) => Object.assign({}, o)),
            // shallow copy of array of object
        below_neg_node : context.below_neg_node
    };
    context.backtrack_stack.push(entry);
};

// class method (static)
TreeMatchLib.aux_TreeMatch_do_backtrack = function(context) {

    if (context.backtrack_stack.length == 0)
    { throw Error("Error: internal error (5b592053_5eb2cc1c)\n"); }

    let entry = context.backtrack_stack.pop();

    context.iter_pattern_ast = entry.iter_pattern_ast;
    context.iter_target_tree = entry.iter_target_tree;

    if (context.next_node_capture_list !== undefined && context.next_node_capture_list !== null)
    {
        context.next_node_capture_list.splice(
            entry.next_node_capture_list_trim_length );
    }
    context.next_node_child_level = entry.next_node_child_level;

    context.single_capture_list.splice(
        entry.single_capture_list_trim_length );
    context.multi_capture_list.splice(
        entry.multi_capture_list_trim_length );

    context.non_order_matched_siblings_flame_stack = entry.non_order_matched_siblings_flame_stack;
    context.below_neg_node = entry.below_neg_node;
};

// class method (static)
TreeMatchLib.TreeMatchFind = function(tree, pattern) {

    if ( !(tree instanceof TreeWrapperBase))
    {
        throw Error("Error: called with wrong parameter type ('tree' in TreeMatchFind(tree, pattern)) (f9a9649a_fc50f7cb)\n");
    }
    if ( !(typeof pattern == 'string' || tree_class instanceof String) )
    {
        throw Error("Error: called with wrong parameter type ('pattern' in TreeMatchFind(tree, pattern)) (ae2f3983_181072c8)\n");
    }


    let results = [];
    let result;
    let next_capture_list = [];

    let next_capture_list_add = [];
    let base_root_capture = null;

    while(1)
    {
        result = TreeMatchLib.TreeMatch(tree, pattern, base_root_capture, next_capture_list_add);
        if (result) { results.push(result); }
        let n = next_capture_list_add.length;
        for (let i = n - 1; i >= 0; i--)
        {
            next_capture_list.push(next_capture_list_add[i]);
        }
        next_capture_list_add = [];
        if (next_capture_list.length == 0) { break; }
        base_root_capture = next_capture_list.pop();
        tree = base_root_capture.Tree();
    }
    return results;
};

// class method (static)
TreeMatchLib.TreeIfMatchDo = function() {

    throw Error("Error: not yet implemented (96815e8a_a2bb6030)!");
};

// class method (static)
TreeMatchLib.force_import = function() {

    throw Error("Error: not yet implemented (c28b4ead_67b95704)!");
};

// class method (static)
TreeMatchLib.__import = function() {

    throw Error("Error: not yet implemented (8f1e5e4e_249c97bd)!");
};

// ------------------------------------------------------------
// CLASS TreeMatchLibSrc
// ------------------------------------------------------------
var TreeMatchLibSrc = {};

// class method (static)
TreeMatchLibSrc.__import = function() {

    throw Error("Error: not yet implemented (3ac7209b_9f0dd9da)!");
};

 // ignore this line []
 // ignore this line []


///////////////////////////////////////////////////////////////
// cjs/mjs の生成を出来るようにしよう
///////////////////////////////////////////////////////////////

