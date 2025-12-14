'use strict';








///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
// ------------------------------------------------------------
// CLASS TreeWrapperBase/ .NodeBox/ .Node のコンストラクタ等
// ------------------------------------------------------------
var TreeWrapperBase;



// TreeWrapperBase のコンストラクタ (newByBox に null 引数を許容したもの)
TreeWrapperBase = function(root_node_box) {
    const actual_box_class = this.constructor.BoxClass;

    if (root_node_box === undefined)
    {
        throw Error("Error: undefined arg0 of TreeWrapperBase constructor (expected: NodeBox or null)(dd39caf0_71482d3f)!");
    }

    if (root_node_box === null)
    {
        root_node_box = new actual_box_class(null);
    }
    else if ( actual_box_class !== root_node_box.constructor )
    {
        throw Error("Error: Wrong arg0 of TreeWrapperBase constructor (expected: NodeBox or null)(f3a9726a_95c5b37b)!");
    }
    // no-else

    this.root_node_box = root_node_box;
};

// NodeBox のコンストラクタ (newByNode と同)
TreeWrapperBase.NodeBox = function(node) {
    if (node === undefined)
    {
        throw Error("Error: undefined arg0 of TreeWrapperBase.NodeBox constructor (expected: Node or null)(20ab145b_1ba6d5cf)!");
    }
    if (node !== null && node.constructor !== this.constructor.NodeClass)
    {
        throw Error("Error: Wrong arg0 of TreeWrapperBase.NodeBox constructor (expected: Node or null)(56642286_a735e0c5)!");
    }

    this.node = node;
};


// Node のコンストラクタ (ここに移動)
TreeWrapperBase.Node = function(attr, child_nodes) {
    // attr が obj でなければ エラー
    if (Object(attr) !== attr)
    {
        throw Error("Error: Wrong arg0 of TreeWrapperBase.Node constructor (expected: Object)(373d5705_e474760b)!");
    }
    // child_nodes が undefined (引数が指定されていない) のとき [] とする
    if (child_nodes === undefined) { child_nodes = []; }

    // child_nodes が Array でなければ エラー
    if (!Array.isArray(child_nodes)) 
    {
        throw Error("Error: Wrong arg1 of TreeWrapperBase.Node constructor (expected: Array of Node) (a9f6c904_36b115f4)!");
    }

    // child_nodes[?] が Node でなければ エラー
    const actual_node_class = this.constructor;
    const actual_box_class = this.constructor.BoxClass;

    let c;
    // LOG('new Node(attr, child_nodes) / child_nodes', child_nodes);
    // LOG('  this', this);
    // LOG('  actual_box_class', actual_box_class);
    for (c of child_nodes)
    {
        if (c !== null && c.constructor !== this.constructor)
        {
            throw Error("Error: Wrong arg0 of TreeWrapperBase.NodeBox constructor (expected: Node or null)(c47601c0_87bcf65f)!");
        }
    }
    let child_boxes = child_nodes.map((node) => actual_box_class.newByNode(node));

    this.attr = attr;
    this.child_boxes = child_boxes;
};

// class variable (static)
TreeWrapperBase.NodeBox.NodeClass = TreeWrapperBase.Node;
TreeWrapperBase.NodeBox.BoxClass  = TreeWrapperBase.NodeBox;
TreeWrapperBase.NodeBox.TreeClass = TreeWrapperBase;
TreeWrapperBase.Node.NodeClass    = TreeWrapperBase.Node;
TreeWrapperBase.Node.BoxClass     = TreeWrapperBase.NodeBox;
TreeWrapperBase.Node.TreeClass    = TreeWrapperBase;
TreeWrapperBase.NodeClass         = TreeWrapperBase.Node;
TreeWrapperBase.BoxClass          = TreeWrapperBase.NodeBox;
TreeWrapperBase.TreeClass         = TreeWrapperBase;

// TreeWrapperBase.constructor.name がメンテナンスされない状況のために
TreeWrapperBase.NodeBox.my_classname = 'TreeWrapperBase.NodeBox';
TreeWrapperBase.Node.my_classname    = 'TreeWrapperBase.Node';
TreeWrapperBase.my_classname         = 'TreeWrapperBase';

// ------------------------------------------------------------
// CLASS TreeWrapperBase.NodeBox
// ------------------------------------------------------------

// class method (static)
TreeWrapperBase.NodeBox.newByNode = function(node) {
    return new this(node);
};

TreeWrapperBase.NodeBox.prototype.GetNode = function() {
    return this.node;
};

TreeWrapperBase.NodeBox.prototype.SetNode = function(node) {
    if (node === undefined)
    {
        throw Error("Error: undefined arg0 of NodeBox.SetNode (expected: NodeBox or null) (a1f485b5_2e6fae42)\n");
    }
    if (node !== null && node.constructor !== this.constructor.NodeClass)
    {
        throw Error("Error: Wrong arg0 of NodeBox.SetNode (expected: Node or null) (9c5dfdb9_29ea283b)\n");
    }
    let detached_node = this.node;
    this.node = node;
    return detached_node;
};

// ------------------------------------------------------------
// CLASS TreeWrapperBase.Node
// ------------------------------------------------------------

TreeWrapperBase.Node.prototype.GetPrimaryAttributeKey0 = function() {
    return '__key0';
};

TreeWrapperBase.Node.prototype.GetPrimaryAttributeKey1 = function() {
    return '__key1';
};

TreeWrapperBase.Node.prototype.IsPrimaryAttributeKey = function(k) {
    return ( k == this.GetPrimaryAttributeKey0()
        || k == this.GetPrimaryAttributeKey1() );
};

// ---- constructor new は冒頭に移動 ----

TreeWrapperBase.Node.prototype.GetAttribute = function(key) {
    if (!(typeof key == "string" || key instanceof String) )
    {
        throw Error("Error: wrong argument(key is not string) in Node.GetAttribute() (2c893a8b_fee20848)!");
    }
    if (! (key in this.attr)) { return null; }
    return this.attr[key];
};

TreeWrapperBase.Node.prototype.SetAttribute = function(key, value) {
    if (!(typeof key == "string" || key instanceof String) )
    {
        throw Error("Error: wrong argument(key is not string) in Node.SetAttribute() (0ef82619_d669eb98)!");
    }
    this.attr[key] = value;
};

TreeWrapperBase.Node.prototype.HasAttribute = function(key) {
    if (!(typeof key == "string" || key instanceof String) )
    {
        throw Error("Error: wrong argument(key is not string) in Node.HasAttribute() (6d90a0ad_ee345d1d)!");
    }
    return key in this.attr;
};

TreeWrapperBase.Node.prototype.DeleteAttribute = function(key) {
    if (!(typeof key == "string" || key instanceof String) )
    {
        throw Error("Error: wrong argument(key is not string) in Node.HasAttribute() (adcca607_52b68c4a)!");
    }
    let o = this.attr;
    if (key in o) { delete o[key]; }
};

TreeWrapperBase.Node.prototype.AttributeKeys = function() {
    return Object.keys(this.attr);
};

TreeWrapperBase.Node.prototype.AttributeKeysNonPrimary = function() {
    return this.AttributeKeys().filter( (key) => !(this.IsPrimaryAttributeKey(key)) );
};

TreeWrapperBase.Node.prototype.GetPrimaryAttribute0 = function() {
    let key = this.GetPrimaryAttributeKey0();
    return this.GetAttribute(key);
};

TreeWrapperBase.Node.prototype.SetPrimaryAttribute0 = function(val) {
    let key = this.GetPrimaryAttributeKey0();
    return this.SetAttribute(key, val);
};

TreeWrapperBase.Node.prototype.Attr0 = function() {
    let key = this.GetPrimaryAttributeKey0();
    return this.GetAttribute(key);
};

TreeWrapperBase.Node.prototype.GetPrimaryAttribute1 = function() {
    let key = this.GetPrimaryAttributeKey1();
    return this.GetAttribute(key);
};

TreeWrapperBase.Node.prototype.SetPrimaryAttribute1 = function(val) {
    let key = this.GetPrimaryAttributeKey1();
    return this.SetAttribute(key, val);
};

TreeWrapperBase.Node.prototype.Attr1 = function() {
    let key = this.GetPrimaryAttributeKey1();
    return this.GetAttribute(key);
};

TreeWrapperBase.Node.prototype.NumChildren = function() {
    return this.child_boxes.length;
};

TreeWrapperBase.Node.prototype.ChildrenKeys = function() {
    return Array.from(this.child_boxes.keys());
};

TreeWrapperBase.Node.prototype.NthChildNode = function(n) {
    if (n === undefined || n == null || n < 0 || n >= this.NumChildren())
    {
        throw Error("Error: index error at NthChildNode()(efa53510_a7f2104e)! n is " + n);
    }
    return this.child_boxes[n].GetNode();
};

TreeWrapperBase.Node.prototype.NthChildBox = function(n) {
    if (n === undefined || n == null || n < 0 || n >= this.NumChildren())
    {
        throw Error("Error: index error at NthChildNode() (21496677_3249efc7)! n is " + n);
    }
    return this.child_boxes[n];
};

TreeWrapperBase.Node.prototype.NthChildSubtree = function(n) {
    return this.constructor.TreeClass.newByBox(this.NthChildBox(n));
};

TreeWrapperBase.Node.prototype.ChildNodeList = function() {
    return this.child_boxes.map((box) => box.GetNode());
};

TreeWrapperBase.Node.prototype.ChildSubtreeList = function() {
    return this.child_boxes.map((box) => this.constructor.TreeClass.newByBox(box));
};

TreeWrapperBase.Node.prototype.ForEachChildNodes = function(ref_func) {
    let i;
    let n = this.NumChildren();
    for (i = 0; i < n; i++)
    {
        ref_func(this.NthChildNode(i));
    }
};

TreeWrapperBase.Node.prototype.ForEachChildSubtrees = function(ref_func) {
    let i;
    let n = this.NumChildren();
    for (i = 0; i < n; i++)
    {
        ref_func(this.NthChildSubtree(i));
    }
};

TreeWrapperBase.Node.prototype.SpliceChildrenNodes = function(offset, length, node_array) {
    if (offset === undefined)
    {
        // asume 0 argument
        return [];
    }
    if (length === undefined)
    {
        // asume 1 argument
        return this.child_boxes.splice(offset).map((box) => box.GetNode());
    }
    if (node_array === undefined)
    {
        // asume 2 argument
        return this.child_boxes.splice(offset, length).map((box) => box.GetNode());
    }

    if (!Array.isArray(node_array))
    {
        throw Error("Error in SpliceChildrenNodes(): arg(node_array) is not Array (a3d8a51a_d056f5b2)\n");
    }

    let actual_boxclass = this.constructor.BoxClass;
    let new_boxes = node_array.map((node) => actual_boxclass.newByNode(node));

    let old_boxes = this.child_boxes.splice(offset, length, ...new_boxes);
    return old_boxes.map((box) => box.GetNode());
};

TreeWrapperBase.Node.prototype.PrependChildNodes = function(nodes) {
    if (!Array.isArray(nodes))
    {
        throw Error("Error: arg(nodes) is not Array (of Node). (33c504c1_3c8e0461)!");
    }
    // 継承を考慮する (nodes instanceof this.constructor) べきか迷う
    // が、継承した場合はエラーとすることにする
    for (let node of nodes)
    {
        if (node !== undefined && node !== null)
        {
            if (this.constructor !== node.constructor)
            {
                throw Error("Error: Node class of arg differs from that of this (aa8a0182_6909227d)!");
            }
        }
    }
    this.SpliceChildrenNodes(0, 0, nodes);
};

TreeWrapperBase.Node.prototype.AppendChildNodes = function(nodes) {
    if (!Array.isArray(nodes))
    {
        throw Error("Error: arg(nodes) is not Array (of Node). (33c504c1_3c8e0461)!");
    }
    // 継承を考慮する (nodes instanceof this.constructor) べきか迷う
    // が、継承した場合はエラーとすることにする
    for (let node of nodes)
    {
        if (node !== undefined && node !== null)
        {
            if (this.constructor !== node.constructor)
            {
                throw Error("Error: Node class of arg differs from that of this (aa8a0182_6909227d)!");
            }
        }
    }
    let n = this.NumChildren();
    this.SpliceChildrenNodes(n, 0, nodes);
};

TreeWrapperBase.Node.prototype.NodeSummary = function() {
    
    let classname = this.my_classname;
    let kv_string = this.AttributeKeys().map( (key) => key + "=>|" + this.GetAttribute(key) + "|" ).join(", ");
    let num_child = this.NumChildren();

    return `${classname}(N_child=${num_child}, attr=(${kv_string}))`;
};

// ------------------------------------------------------------
// CLASS TreeWrapperBase
// ------------------------------------------------------------

// class method (static)
TreeWrapperBase.newByRootNode = function(root_node) {
    if (root_node !== null && root_node.constructor !== this.NodeClass)
    { throw Error("Error: arg0 of newByBox must be null or node class (arg0 = null)!"); }

    let root_node_box = this.BoxClass.newByNode(root_node);
    return this.newByBox(root_node_box);
};

// class method (static)
TreeWrapperBase.newByBox = function(root_node_box) {

    if (root_node_box === null)
    { throw Error("Error: arg0 of newByBox must be node_box class (arg0 = null)"); }
    if (root_node_box.constructor !== this.BoxClass)
    { throw Error("Error: arg0 of newByBox must be node boxclass"); }

    return new this(root_node_box);
};

TreeWrapperBase.prototype.GetRootNodeBox = function() {
    return this.root_node_box;
};

TreeWrapperBase.prototype.GetRootNode = function() {
    return this.GetRootNodeBox().GetNode();
};

TreeWrapperBase.prototype.SetRootNode = function(root_node) {
    if (root_node === undefined)
    {
        throw Error("Error: undefined arg0 of TreeWrapperBase.SetRootNode (expected: Node or null)(20ab145b_1ba6d5cf)!");
    }
    if (root_node !== null && root_node.constructor !== this.constructor.NodeClass)
    {
        throw Error("Error: Wrong arg0 of TreeWrapperBase.SetRootNode (expected: Node or null)(56642286_a735e0c5)!");
    }

    return this.GetRootNodeBox().SetNode(root_node);
};

// class method (static)
TreeWrapperBase.newImportByFuncs = function(root_node, rf_make_attribute_hash, rf_num_children, rf_nth_child) {

    let actual_treeclass = this;

    // root_node              : node
    // rf_make_attribute_hash : node --> new_hash_ref
    // rf_num_children        : node --> n
    // rf_children            : node, n --> node

    let iter_stack = [];
    iter_stack.push({
        src_node     : root_node,
        num_children : rf_num_children(root_node),
        dst_children : []
    });
    let dst_root_node;
    let current;
    while(iter_stack.length)
    {
        current = iter_stack[iter_stack.length - 1];
        let n_dst_children = current.dst_children.length;
        if ( n_dst_children < current.num_children )
        {
            let child = rf_nth_child(current.src_node, n_dst_children);
            iter_stack.push({
                src_node     : child,
                num_children : rf_num_children(child),
                dst_children : []
            });
        }
        else
        {
            let rh_attr = rf_make_attribute_hash(current.src_node);
            // ノードを作る (ここも継承を考慮)
            let actual_nodeclass = this.NodeClass;
            let node = new actual_nodeclass(rh_attr, current.dst_children);

            iter_stack.pop();

            if(iter_stack.length)
            {
                let iter_next = iter_stack[iter_stack.length - 1];
                iter_next.dst_children.push(node);
            }
            else
            {
                dst_root_node = node;
            }
        }
    }
    // ここも継承を考慮
    return actual_treeclass.newByRootNode(dst_root_node);
};

TreeWrapperBase.prototype.ExportByFuncs = function(rf_node_from_children, rf_finish_root) {

    // rf_node_from_children : current_src_node, [child_node_0 ...] -> node
    // rf_finish_root        : root_node -> result_tree

    let root_node = this.GetRootNode();
    let iter_stack = [];
    iter_stack.push({
        src_node     : root_node,
        num_children : root_node.NumChildren(),
        dst_children : []
    });
    let dst_root_node;
    let current;
    while(iter_stack.length)
    {
        current = iter_stack[iter_stack.length - 1];
        let n_dst_children = current.dst_children.length;
        if ( n_dst_children < current.num_children )
        {
            let child = current.src_node.NthChildNode(n_dst_children);
            iter_stack.push({
                src_node     : child,
                num_children : child.NumChildren(),
                dst_children : []
            });
        }
        else
        {
            // ノードを作る
            let node = rf_node_from_children(current.src_node, current.dst_children);

            iter_stack.pop();

            if(iter_stack.length)
            {
                let iter_next = iter_stack[iter_stack.length - 1];
                iter_next.dst_children.push(node);
            }
            else
            {
                dst_root_node = node;
            }
        }
    }
    if (rf_finish_root !== undefined && rf_finish_root !== null)
    {
        return rf_finish_root(dst_root_node);
    }
    else
    {
        return dst_root_node;
    }
};

TreeWrapperBase.prototype.TreePrint = function(rf_print, limit_level, rf_node_stringify, level, head, head_c, head_cc) {

    if (rf_print === undefined || rf_print === null)
    {
        throw Error("Error: TreePrint() has wrong argument rf_print! (67867ad4_ced32600)\n");
    }

    if (limit_level === undefined || limit_level === null)
    {
        limit_level = -1;
    }
    if (level === undefined || level === null)
    {
        // <=2 argument
        level = 0; head = ''; head_c = '' ; head_cc ='';
    }

    if (rf_node_stringify === undefined || rf_node_stringify === null)
    {
        rf_node_stringify = function (cur_node)
        {
            let node_str = '(null)';
            if (cur_node !== undefined && cur_node !== null)
            {
                let k_info = 
                cur_node.AttributeKeysNonPrimary().map(
                    (k) => (
                        cur_node.GetAttribute(k) !== undefined && cur_node.GetAttribute(k) !== null
                    ) ?  k + "=" +  cur_node.GetAttribute(k)
                    :  k + "=(null)"
                ).join(",")

                if (k_info != '') { k_info = `  {${k_info}}` }

                let v = '';
                if ( cur_node.Attr1() !== undefined && cur_node.Attr1() !== null)
                {
                    v = "  <" + cur_node.Attr1() + ">"
                }

                let attr0 = '(Attr0=null)';
                if (cur_node.Attr0() !== undefined && cur_node.Attr0() !== null)
                {
                    attr0 = cur_node.Attr0();
                }
                node_str = attr0 + v + k_info;
            }
            return node_str;

            // if (node === undefined || node == null) {return '(empty node)';}
            // let a0 = node.GetPrimaryAttribute0();
            // let a1 = node.GetPrimaryAttribute1();
            // if (a0 === undefined || a0 === null) { a0 = '(null)'; }
            // if (a1 === undefined || a1 === null) { a1 = '(null)'; }
            // return `${a0} / ${a1}`;
        };
    };
    // MyAssertDataType('CODE', $rf_node_stringify);


    // let kei_u1 = { '|' : " \u{2502}  ", 'L' : " \u{2514}\u{2500} ", '|-' : " \u{251C}\u{2500} ",
    //     ' ' : "    ", '-' : " \u{2500}\u{2500} ", '|=' : " \u{255E}  " };
    // let kei_u2 = { '|' : " \u{2502} ", 'L' : " \u{2514} ", '|-' : " \u{251C} ",
    //     ' ' : "    ", '-' : " \u{2500} ", '|=' : " \u{255E} " };
    // let kei_a = { '|' : " |  ", 'L' : " +- ", '|-' : " +- ",
    //     ' ' : "    ", '-' : " -- ", '|=' : " |= " };
    const k = { '|' : " |  ", 'L' : " +- ", '|-' : " +- ",
        ' ' : "    ", '-' : " -- ", '|=' : " |= " };

    let root_node = this.GetRootNode();
    let node_str = rf_node_stringify(root_node);
    rf_print(head + head_c + node_str + "\n");
    if (root_node === undefined || root_node === null) { return; }

    if (limit_level < 0 || level < limit_level)
    {
        for (let i in root_node.ChildrenKeys())
        {
            if (i == root_node.NumChildren() - 1)
            {
                // last child
                root_node.NthChildSubtree(i).TreePrint(rf_print, limit_level, rf_node_stringify, level + 1, head+head_cc, k['L'], k[' ']);
            }
            else
            {
                root_node.NthChildSubtree(i).TreePrint(rf_print, limit_level, rf_node_stringify, level + 1, head+head_cc, k['|-'], k['|']);
            }
        }
    }
    else
    {
        let n_child = root_node.NumChildren();
        if (n_child > 1)
        { rf_print(head + head_cc + k['|-'] + " ...\n"); }
        else if (n_child == 1)
        { rf_print(head + head_cc + k['L'] + " ...\n"); }
        // else (in case $n_child == 0) do nothing
    }
};

TreeWrapperBase.prototype.TraverseEnterExit = function(arg0, enter_func, exit_func) {
    let tree = this;
    // enter_func: node, arg, ref_iter_stack ---> next_arg
    // exit_func:   node, enter_return_value, child_return_value_list, ref_iter_stack ---> next_arg
    let iter_stack = [];
    iter_stack.push({
        up_node : null,
        node    : tree.GetRootNode(),
        sibling_index : 0,
        sibling_num : 1,
        arg     : arg0,
        sibling_values : []
    });
    while (1)
    {
        let iter_top = iter_stack[iter_stack.length - 1];
        if (iter_top.sibling_index < iter_top.sibling_num)
        {
            // do down case

            let next_arg = iter_top.arg;
            if (enter_func !== undefined && enter_func !== null)
            {
                next_arg = enter_func(iter_top.node, iter_top.arg, iter_stack);
            }
            iter_top.arg = next_arg;

            // 子がいない場合でも exit_func 発行のためダミーの子を入れておく
            let child_num = 0;
            let first_child_node = null;
            if (iter_top.node.NumChildren() > 0)
            {
                child_num = iter_top.node.NumChildren();
                first_child_node =  iter_top.node.NthChildNode(0);
            }
            iter_stack.push({
                up_node : iter_top.node,
                node    : first_child_node,
                sibling_index : 0,
                sibling_num : child_num,
                arg : next_arg,
                sibling_values : []
            });
        }
        else
        {
            // case do_up

            if (iter_top.sibling_index >= iter_top.sibling_num)
            {
                // up after last child
                let sibling_values = iter_top.sibling_values;

                iter_stack.pop();
                iter_top = iter_stack[iter_stack.length - 1];

                let sibling_v = null; // to return in case no up function.
                if (exit_func !== undefined && exit_func !== null)
                {
                    sibling_v = exit_func(iter_top.node, iter_top.arg, sibling_values, iter_stack);
                    iter_top.sibling_values.push($sibling_v);
                }

                iter_top.sibling_index++;
                if ( iter_top.sibling_index < iter_top.sibling_num)
                {
                    iter_top.node = iter_top.up_node.NthChildNode(iter_top.sibling_index);
                }
                else
                {
                    iter_top.node = null;
                }

                // iter_stack が 2個 で up したら、root node の up なので抜ける
                if (iter_stack.length == 1)
                {
                    return sibling_v;
                }
            }
        }
    }
};

// class method (static)
TreeWrapperBase.useNewTreeClass = function(class_base, key0, key1) {
    if (key1 === undefined)
    {
        throw Error("Error: useNewTreeClass requires 3 arguments. (54070487_0409e331)\n");
    }
    if (! (typeof class_base == 'string' || class_base instanceof String))
    {
        throw Error("Error: parameter 'tree_class' of useNewTreeClass(tree_class, key0, key1) must be string. (7f39fdf0_0b4f2551)\n");
    }

    // コンストラクタ
    let ret = function(root_node_box) {
        TreeWrapperBase.apply(this, [root_node_box]);
    };
    ret.NodeBox = function(node) {
        TreeWrapperBase.NodeBox.apply(this, [node]);
    };
    ret.Node = function(attr, child_nodes) {
        TreeWrapperBase.Node.apply(this, [attr, child_nodes]);
    };


    // クラス名 (?.constructor.name がメンテナンスされない状況のために)
    ret.my_classname         = class_base;
    ret.NodeBox.my_classname = class_base + '.NodeBox';
    ret.Node.my_classname    = class_base + '.Node';

    // クラス変数
    ret.TreeClass         = ret;
    ret.BoxClass          = ret.NodeBox;
    ret.NodeClass         = ret.Node;
    ret.NodeBox.TreeClass = ret;
    ret.NodeBox.BoxClass  = ret.NodeBox;
    ret.NodeBox.NodeClass = ret.Node;
    ret.Node.TreeClass    = ret;
    ret.Node.BoxClass     = ret.NodeBox;
    ret.Node.NodeClass    = ret.Node;

    // 属性関数3
    ret.Node.prototype.GetPrimaryAttributeKey0 = function () {return key0;};
    ret.Node.prototype.GetPrimaryAttributeKey1 = function () {return key1;};
    ret.Node.prototype.IsPrimaryAttributeKey = function (k) {
        return k == key0 || k == key1;
    };

    // 継承
    Object.setPrototypeOf(ret.prototype, TreeWrapperBase.prototype);
    Object.setPrototypeOf(ret, TreeWrapperBase);

    Object.setPrototypeOf(ret.NodeBox.prototype, TreeWrapperBase.NodeBox.prototype);
    Object.setPrototypeOf(ret.NodeBox, TreeWrapperBase.NodeBox);
    Object.setPrototypeOf(ret.Node.prototype, TreeWrapperBase.Node.prototype);
    Object.setPrototypeOf(ret.Node, TreeWrapperBase);

    return ret;

    //////////////////////////////////////////////////////////////
    // // 準備確認版 use (これに apply(this,[??] (super の代わり)を追加している)
    // TWB.use_deriv = function (name){
    //     
    //     LOG("this (in use_deriv())", this);
    //     LOG("TWB (in use_deriv())", TWB);
    //     print_last("in use_deriv: this.my_ClassName = " + this.my_ClassName);
    //     print_last("in use_deriv: TWB.my_ClassName = " + TWB.my_ClassName);

    //     let ret = function() { this.i_name = name; }
    //     ret.my_ClassName = name;

    //     ret.Node = function() { this.i_cname = name + '.Node'; };
    //     ret.Node.my_ClassName = name + '.Node';

    //     ret.Box = function() { this.i_cname = name + '.Box'; };
    //     ret.Box.my_ClassName = name + '.Box';

    //     Object.setPrototypeOf(ret.prototype, TWB.prototype);
    //     Object.setPrototypeOf(ret, TWB);

    //     Object.setPrototypeOf(ret.Node.prototype, TWB.Node.prototype);
    //     Object.setPrototypeOf(ret.Node, TWB);
    //     Object.setPrototypeOf(ret.Box.prototype, TWB.Box.prototype);
    //     Object.setPrototypeOf(ret.Box, TWB.Box);


    //     ret.TreeClass = ret;
    //     ret.NodeClass = ret.Node;
    //     ret.BoxClass = ret.Box;
    //     ret.Node.TreeClass = ret;
    //     ret.Node.NodeClass = ret.Node;
    //     ret.Node.BoxClass = ret.Box;
    //     ret.Box.TreeClass = ret;
    //     ret.Box.NodeClass = ret.Node;
    //     ret.Box.BoxClass = ret.Box;

    //     return ret;
    // };
    //////////////////////////////////////////////////////////////
    // // perl 版
    // sub useNewTreeClass($$$)
    // {
    //     my ($class_base, $key0, $key1) = @_;
    //     if (@_ != 3) {confess "Error: new_tree_class requires 3 arguments "
    //         . "'BaseClassName', 'primary key name', 'secondary key name'. @_= ("
    //         . join (", ", @_) . ")\n"; }
    // 
    //     my ($box_c, $node_c) = map {$class_base . '::' . $_} 'NodeBox', 'Node';
    //     my $tree_c = $class_base;
    // 
    // 
    //     no strict "refs";
    // 
    //     @{*{$box_c  . '::ISA'}{ARRAY}} = ( 'TreeWrapperBase::NodeBox' );
    //     @{*{$node_c . '::ISA'}{ARRAY}} = ( 'TreeWrapperBase::Node' );
    //     @{*{$tree_c . '::ISA'}{ARRAY}} = ( 'TreeWrapperBase' );
    //     for my $c ($box_c, $node_c, $tree_c)
    //     {
    //         *{$c  . '::BoxClass' } = sub { $box_c; };
    //         *{$c  . '::NodeClass'} = sub { $node_c;};
    //         *{$c  . '::TreeClass'} = sub { $tree_c };
    //     }
    // 
    //     *{$node_c . '::GetPrimaryAttributeKey0' } = sub { $key0; };
    //     *{$node_c . '::GetPrimaryAttributeKey1' } = sub { $key1; };
    //     *{$node_c . '::IsPrimaryAttributeKey' } = sub {
    //         my ($self, $k) = @_; return ($k eq $key0 or $k eq $key1);
    //     };
    // }
    // # 上記は以下とほぼ同等のことをしている
    // # {
    // #     package TreeA::NodeBox;
    // #     our @ISA =    ( 'TreeWrapperBase::NodeBox' );
    // #     sub NodeClass { 'TreeA::Node'    };
    // #     sub BoxClass  { 'TreeA::NodeBox' };
    // #     sub TreeClass { 'TreeA'    };
    // # 
    // #     package TreeA::Node;
    // #     our @ISA =    ( 'TreeWrapperBase::Node' );
    // #     sub NodeClass { 'TreeA::Node'    };
    // #     sub BoxClass  { 'TreeA::NodeBox' };
    // #     sub TreeClass { 'TreeA'    };
    // #     sub GetPrimaryAttributeKey0 { return 'key0'; }
    // #     sub GetPrimaryAttributeKey1 { return 'key1'; }
    // #     sub IsPrimaryAttributeKey
    // #     { my ($self, $k) = @_; return $k =~ /^A(key0|key1)^z/; }
    // # 
    // #     package TreeA;
    // #     our @ISA =    ( 'TreeWrapperBase' );
    // #     sub NodeClass { 'TreeA::Node'    };
    // #     sub BoxClass  { 'TreeA::NodeBox' };
    // #     sub TreeClass { 'TreeA'    };
    // # }
};

// class method (static)
TreeWrapperBase.newImportFromFlatHashTree = function(root_node, children_key, key0, key1) {
    // MyAssertDataType('HASH', $root_node, "Wrong 1st argument(\$root_node)." );
    // MyAssertDataType('SCALAR', \$children_key, "Wrong 1st argument(\$root_node)." );

    let actual_treeclass = this;
    let actual_nodeclass = this.NodeClass;

    let key0c = (new actual_nodeclass({},[])).GetPrimaryAttributeKey0();
    let key1c = (new actual_nodeclass({},[])).GetPrimaryAttributeKey1();
    if (key0 === undefined || key0 ===null) { key0 = key0c; }
    if (key1 === undefined || key1 ===null) { key1 = key1c; }

    return actual_treeclass.newImportByFuncs(root_node,
        // rf_make_attribute_hash : node --> new_hash_ref
        function (node) {
            let rh_attr = {};
            for (let k of Object.keys(node))
            {
                if (k == children_key) {}
                else if (k == key0) { rh_attr[key0c] = node[k]; }
                else if (k == key1) { rh_attr[key1c] = node[k]; }
                else { rh_attr[k] = node[k]; }
            }

            return rh_attr;
        },
        // rf_num_children        : node --> n
        function (node) {
            if (children_key in node) {return node[children_key].length;}
            else {return 0;}
        },
        // rf_children            : node, n --> node
        function (node, n) {
            return node[children_key][n];
        }
    );



};

TreeWrapperBase.prototype.ExportToFlatHashTree = function(children_key, key0, key1) {

    if (!(typeof children_key == "string" || children_key instanceof String) )
    {
        throw Error("Error: wrong 1st argument(children_key) of ExportToFlatHash Tree! (string expected) (1d7625fb_6cca5ec4)!");
    }
    let actual_nodeclass = this.constructor.NodeClass;

    let key0c = (new actual_nodeclass({},[])).GetPrimaryAttributeKey0();
    let key1c = (new actual_nodeclass({},[])).GetPrimaryAttributeKey1();
    if (key0 === undefined || key0 ===null) { key0 = key0c; }
    if (key1 === undefined || key1 ===null) { key1 = key1c; }

    return this.ExportByFuncs(
        // rf_node_from_children : current_src_node, [child_node_0 ...] -> node
        function (src_node, child_nodes){
            let new_node = {};

            for (let k of src_node.AttributeKeysNonPrimary())
            {
                new_node[k] = src_node.GetAttribute(k);
            }
            new_node[key0] = src_node.GetPrimaryAttribute0();
            new_node[key1] = src_node.GetPrimaryAttribute1();

            new_node[children_key] = child_nodes.slice(); // clone array
            return new_node;
        },
        // rf_finish_root : root_node -> result_tree
        function (root_node) { return root_node; }
    );
};

// class method (static)
TreeWrapperBase.newImportFromAttrhashChildTree = function(root_node, children_key, attr_key, key0, key1) {

    let actual_treeclass = this;
    let actual_nodeclass = this.NodeClass;

    let key0c = (new actual_nodeclass({},[])).GetPrimaryAttributeKey0();
    let key1c = (new actual_nodeclass({},[])).GetPrimaryAttributeKey1();
    if (key0 === undefined || key0 ===null) { key0 = key0c; }
    if (key1 === undefined || key1 ===null) { key1 = key1c; }

    return actual_treeclass.newImportByFuncs(root_node,
        // rf_make_attribute_hash : node --> new_hash_ref
        function (node) {
            let node_attr = node[attr_key];
            let rh_attr = {};
            for (let k of Object.keys(node_attr))
            {
                if      (k == key0) { rh_attr[key0c] = node_attr[k]; }
                else if (k == key1) { rh_attr[key1c] = node_attr[k]; }
                else { rh_attr[k] = node_attr[k]; }
            }
            return rh_attr;
        },
        // rf_num_children        : node --> n
        function (node) {
            if (children_key in node) {return node[children_key].length;}
            else {return 0;}
        },
        // rf_children            : node, n --> node
        function (node, n) {
            return node[children_key][n];
        }
    );
};

TreeWrapperBase.prototype.ExportToAttrhashChildTree = function(children_key, attr_key, key0, key1) {
    if (!(typeof children_key == "string" || children_key instanceof String) )
    {
        throw Error("Error: wrong 1st argument(children_key) of ExportToFlatHash Tree! (string expected) (d6064a7b_86a27caa)!");
    }
    if (!(typeof attr_key == "string" || attr_key instanceof String) )
    {
        throw Error("Error: wrong 2nd argument(attr_key) of ExportToFlatHash Tree! (string expected) (c982c8a9_65bbdc95)!");
    }
    let actual_nodeclass = this.constructor.NodeClass;

    let key0c = (new actual_nodeclass({},[])).GetPrimaryAttributeKey0();
    let key1c = (new actual_nodeclass({},[])).GetPrimaryAttributeKey1();
    if (key0 === undefined || key0 ===null) { key0 = key0c; }
    if (key1 === undefined || key1 ===null) { key1 = key1c; }

    return this.ExportByFuncs(
        // rf_node_from_children : current_src_node, [child_node_0 ...] -> node
        function (src_node, child_nodes){
            let new_node_attr = {};

            for (let k of src_node.AttributeKeysNonPrimary())
            {
                new_node_attr[k] = src_node.GetAttribute(k);
            }
            new_node_attr[key0] = src_node.GetPrimaryAttribute0();
            new_node_attr[key1] = src_node.GetPrimaryAttribute1();

            let new_node = {};
            new_node[attr_key] =  new_nodw_attr;
            new_node[children_key] = child_nodes.slice(); // clone array
            return new_node;
        },
        // rf_finish_root : root_node -> result_tree
        function (root_node) { return root_node; }
    );
};

// ------------------------------------------------------------
// CLASS TreeWrapperBaseIterator
// ------------------------------------------------------------
// class method (static)
var TreeWrapperBaseIterator = function(tree, on_up_do) {

    // ルートの仮想親フレームを積む（ルートでは兄弟が1つ）
    this.iter_stack = [
        { tree : tree, sibling_index : 0, sibling_num : 1 },
    ];

    if (on_up_do !== undefined && on_up_do !== null)
    {
        $self.iter_stack[0].on_up_do = on_up_do;
    }
};

// 現在のフレーム（トップ）を返す
TreeWrapperBaseIterator.prototype._top = function() {
    return this.iter_stack[this.iter_stack.length - 1];
};

// 親フレーム（トップの一つ上）を返す（なければ null）
TreeWrapperBaseIterator.prototype._parent_frame = function() {
    let n = this.iter_stack.length;
    if (n < 2) { return null; }

    return this.iter_stack[this.iter_stack.length - 2];
};

TreeWrapperBaseIterator.prototype.IsRoot = function() {
    return this.iter_stack.length == 1 ? 1 : 0;
};

TreeWrapperBaseIterator.prototype.IsEnd = function() {
    let top_frame = this._top();
    return top_frame.sibling_index >= top_frame.sibling_num ? 1 : 0;
};

TreeWrapperBaseIterator.prototype.IsFirst = function() {
    let top_frame = this._top();
    return ((top_frame.sibling_index == 0) ? 1 : 0);
};

TreeWrapperBaseIterator.prototype.IsLast = function() {
    let top_frame = this._top();
    return top_frame.sibling_index == top_frame.sibling_num - 1 ? 1 : 0;
};

TreeWrapperBaseIterator.prototype.Tree = function() {
    let t = this._top();
    if (t === undefined || t === null)
    {
        throw Error("Error: Wrong state Iterator (0340cae4_9b5ecd34)!");
    }
    return t.tree;
};

TreeWrapperBaseIterator.prototype.Node = function() {
    let t = this.Tree();
    if (t === undefined || t === null) { return null; }
    return t.GetRootNode();
};

TreeWrapperBaseIterator.prototype.UpTree = function() {
    let f = this._parent_frame();
    if (f === undefined || f === null) { return null; }
    return f.tree;
};

TreeWrapperBaseIterator.prototype.UpNode = function() {
    let t = this.UpTree();
    if (t === undefined || t === null) { return null; }
    return t.GetRootNode();
};

TreeWrapperBaseIterator.prototype.MoveNextSibling = function() {
    let t = this._top();

    if (t === undefined || t === null)
    {
        throw Error("Error: Wrong state Iterator (0340cae4_9b5ecd34)!");
    }

    t.sibling_index++;

    if (this.IsEnd())
    {
        // Root ならこちら側に入る
        // MoveDownForce() した場合は単一ノードなのでこちら側に入る
        t.tree = null;
    }
    else
    {
        // else なら Root ではないので $self->_parent_frame が有効な値を返す

        let up_node = this.UpNode();
        if (up_node !== undefined && up_node !== null)
        {
            t.tree = up_node.NthChildSubtree(t.sibling_index);
        }
        else
        {
            t.tree = null;
        }
    }
};

TreeWrapperBaseIterator.prototype.MoveDown = function() {

    if (this.IsEnd())
    {
        throw Error("Error: MoveDown: at end position (067dc748_2bb4a69e)\n");
    }

    let cur_node = this.Node();

    // 子数を取得（Tree API 統合が必要）
    //     cur_node が null の場合は必ずゼロ
    let cnt = 0;
    if (cur_node !== undefined && cur_node !== null)
    {
        cnt = cur_node.NumChildren();
    }

    let child_subtree = null;
    if (cnt > 0) { child_subtree = cur_node.NthChildSubtree(0); }

    let new_entry = {
        tree          : child_subtree,   // 親ツリー
        sibling_index : 0,
        sibling_num   : cnt,
    };

    this.iter_stack.push(new_entry);
};

TreeWrapperBaseIterator.prototype.MoveDownForce = function(pseudo_child_subtree) {

    // if(! UNIVERSAL::isa ($pseudo_child_subtree, 'TreeWrapperBase'))
    // prototype チェーンが正しく動くなら o instanceof TreeWrapperBase で
    if(! ('GetRootNodeBox' in pseudo_child_subtree))
    {
        throw Error("Error: arg0(pseudo_child_subtree) must be subclass of TreeWrapperBase! (0d493543_77643a52)\n");
    }

    // // IsEnd() (最終ノード処理後) でもエラーにしないが、
    // //     この場合に反復が上手く働くためには注意が必要
    // confess "Error: MoveDown: at end position" if $self->IsEnd();

    let new_entry = {
        tree          : pseudo_child_subtree,   // 親ツリー
        sibling_index : 0,
        sibling_num   : 1,
    };

    this.iter_stack.push(new_entry);
};

TreeWrapperBaseIterator.prototype.MoveUp = function() {

    if (this.iter_stack.length == 1)
    {
        throw Error("Error: MoveUp called at root! (e236a05e_ff1401d5)\n");
    }

    this.iter_stack.pop();

    let top_entry = this._top();
    if ('on_up_do' in top_entry  && top_entry.on_up_do !== undefined && top_entry.on_up_do !== null) {
        top_entry.on_up_do();
    }

};

TreeWrapperBaseIterator.prototype.OnUpDo = function(on_up_do) {

    let t = this._top();

    if (t === undefined || t === null)
    {
        throw Error("Error: Wrong state Iterator (0340cae4_9b5ecd34)!");
    }


    if ('on_up_do' in t && t.on_up_do !== undefined && t.on_up_do !== null)
    {
        throw Error("Error: current node already has on_up_do (88e6e8ff_488de0d7)\n");
    }

    t.on_up_do = on_up_do;
};

TreeWrapperBaseIterator.prototype.MoveUpNoDo = function() {

    if (this.iter_stack.length == 1)
    {
        throw Error("Error: MoveUp called at root! (e236a05e_ff1401d5)\n");
    }

    this.iter_stack.pop();

};

TreeWrapperBaseIterator.prototype.Duplicate = function() {
    // my $copy = bless {
    //     # root_capture => $self->{root_capture},
    //     iter_stack   => [ map { { %$_ } } @{ $self->{iter_stack} } ],
    // }, ref($self);
    //
    // Object.assign({}, some_object) で shallow copy
    let copy = new TreeWrapperBaseIterator(null);
    copy.iter_stack = this.iter_stack.map((frame) => Object.assign({}, frame));

    return copy;
};

// 本当は class method (static) にするべきものだがそうしていない
TreeWrapperBaseIterator.prototype.aux_debug_print_iter_stack_tree_str = function(tree) {
    let tree_str;
    if (tree === undefined || tree === null) { tree_str = '(null)'; }
    else {
        let root_node = tree.GetRootNode();
        if (root_node === undefined || root_node ===null)
        { tree_str = tree.my_classname + "(node = null)"; }
        else
        {
            // 参照アドレスは表示できなさそう
            //     もともとはtree とか node のアドレス表示をしていた
            tree_str = tree.my_classname + "(node = " + root_node.Attr0() +")";
        }
    }
    return tree_str;
};

TreeWrapperBaseIterator.prototype.aux_debug_print_iter_stack = function(rf_print) {
    if (rf_print === undefined || rf_print === null)
    {
        throw Error("Error: aux_debug_print_iter_stack() has wrong argument rf_print! (8c250be7_8fc4c980)\n");
    }
    rf_print(" [ Iter Stack]\n");

    for (let i of this.iter_stack.keys())
    {
        let e = this.iter_stack[i];

        let tree_str = this.aux_debug_print_iter_stack_tree_str(e.tree);

        let index = '-';
        if ('sibling_index' in e
            && e.sibling_index !== undefined
            && e.sibling_index !== null)
        { index = e.sibling_index;}

        let num = e.sibling_num;

        rf_print(`  [${i}] ${index} / ${num} : ${tree_str}\n`);
    }
};

TreeWrapperBaseIterator.prototype.aux_debug_short_print = function(rf_print) {
    if (rf_print === undefined || rf_print === null)
    {
        throw Error("Error: aux_debug_short_print() has wrong argument rf_print! (60965052_df87012b)\n");
    }
    rf_print(this.iter_stack.map( function (frame){
            let node_name;
            let root_node = frame.tree.GetRootNode();
            if (root_node === undefined || root_node === null)
            { node_name = 'null'; }
            else { root_node = root_node.Attr0(); }
            return node_name +"(" + frame.sibling_index + "/" + frame.sibling_num + ")";
        }).join(" ") + "\n");
};


///////////////////////////////////////////////////////////////
// cjs/mjs の生成を出来るようにしよう
///////////////////////////////////////////////////////////////

