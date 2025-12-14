'use strict';

///////////////////////////////////////////////////////////////
// TLTokenizerSeparate
// TLTreePatternAST.ToTreePatternAST
// TLTreePatternAST.ToPathPatternAST
//
// requires TreeWrapperBase (ToTreePatternAST/ useNew...)
///////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////
// TLTokenizer ここから
///////////////////////////////////////////////////////////////

// ../TLLex.pm
// と study_tree_lib\parserGen\aa_tree_gen_js_svg/output_js.js (65)...
// あたりの lex を参考にする
//
// TLTokenizer_aux_Tokenizer_PathAndTreePat
// TLTokenizer_aux_TokenizerByArray
// TLTokenizerSeparated
//
//
// new TLTokenizer(src_string)
// read_next_token()
//     -> void
//     set $self ({
//         following_token_id : string or '(eot)'
//         following_token_sv : token_hash({id:?, val:?, child:[]}) or undef
//     });
// reset()
// 

var TLTokenizer_aux_Tokenizer_PathAndTreePat = function(str) {
    this.rest = str;
    this.orig = str;  // 複製が必要
            // # pos_prev_b => 0,
            // # pos_a => 0,
            // # pos_b => 0,
            // # # and, should maintain pre/post space position?
    // this.mres_curr  = 最後のマッチ結果 マッチ部分
    // this.mres_rest  = 最後のマッチ結果 マッチ部分
    // this.mres_value = 最後のマッチ結果 値
    this.read_next_token();
};
TLTokenizer_aux_Tokenizer_PathAndTreePat.prototype.reset = function(){
    this.rest = this.orig; // 複製が必要
    this.read_next_token();
};
TLTokenizer_aux_Tokenizer_PathAndTreePat.prototype.aux_bite_string = function(str){

    let n = str.length;
    if (this.rest.length < n) { return false; }

    let head = this.rest.substring(0, n);
    if ( head == str)
    {
        this.mres_curr = head;
        this.mres_rest = this.rest.substring(n);
        this.rest = this.mres_rest;
        return true;
    }
    else { return false; }
};
TLTokenizer_aux_Tokenizer_PathAndTreePat.prototype.aux_bite_pattern = function(pat){

    let match_result = pat.exec(this.rest);
    if (match_result !== null)
    {
        // my ($a,$b,$c) = ($`, $&, $');
        const ia = match_result.index;
        const ib = ia + match_result[0].length;
        // const a = this.rest.substring(0,ia);
        const b = this.rest.substring(ia,ib);
        const c = this.rest.substring(ib);

        if (ia != 0)
        {
            throw Error(`Error in lex: '${pat}' matches non head string (2c4b7368_7e2bd12b)\n`);
        }

        this.mres_curr = b;
        this.mres_rest = c;
        this.rest = c;
        return true;
    }
    else { return false; }
};
TLTokenizer_aux_Tokenizer_PathAndTreePat.prototype.aux_bite_quoted_string_rest = function(endc, qprefix, qs){
        // qs: array

        let curr = '';
        let value = '';

        while(1)
        {
            if (this.rest.length == 0)
            { throw Error(`Error in lex: run away quoted string(no [${endc}])!\n`); }
            if (this.aux_bite_string(endc))
            {
                this.mres_curr = curr;
                this.mres_value = value;
                return 1;
            }
            if (this.aux_bite_string(qprefix))
            {
                curr = curr + this.mres_curr;
                let matched = 0;
                for (let q_pair of qs)
                {
                    if (this.aux_bite_string(q_pair[0]))
                    {
                        curr = curr + this.mres_curr;
                        value = value + q_pair[1];
                        matched = 1;
                        break;
                    }
                }
                if(matched) { continue; }

                if (this.rest.length == 0)
                { throw Error(`Error in lex: run away quoted string (no char after [${qprefix}])!\n`); }

                // not match: quote as is
                curr = curr + this.rest.substring(0, 1);
                value = value + this.rest.substring(0, 1);
                this.rest = this.rest.substring(1);
                continue;
            }
            // not match: 1char as is
            curr = curr + this.rest.substring(0, 1);
            value = value + this.rest.substring(0, 1);
            this.rest = this.rest.substring(1);
        }
};

TLTokenizer_aux_Tokenizer_PathAndTreePat.prototype.aux_bite_str_list = function(str_list){
    for (let str of str_list)
    {
        let result = this.aux_bite_string(str);
        if (result) { return result; }
    }
    return false;
};
TLTokenizer_aux_Tokenizer_PathAndTreePat.prototype.aux_bite_char_list = function(str_list_join){
    let str_list = str_list_join.split('');

    return this.aux_bite_str_list(str_list);
};

TLTokenizer_aux_Tokenizer_PathAndTreePat.prototype.read_next_token = function(){

    // 1. 空白や改行をスキップ
    if (this.aux_bite_pattern(/^[\s\n\r\x0d\x0a]+/))
    {
        // do something for skipping
    }
    // 1b. End of code
    if (this.rest == '')
    {
        this.following_token_id = '(eot)';
        this.following_token_sv = null;
        return;
    }

    // 2. normal token

    // three or two three char
    //     hirano ver. : ## => & ,  (? => 無し
    //           new : (? 追加 , ##@ 追加
    if ( this.aux_bite_str_list(['##@', '##', '(?']) )
    {
        // $yylval = {type =>$type, val => $val, elem => []};
        this.following_token_id = this.mres_curr;
        this.following_token_sv = {
                id : this.mres_curr,
                val : null,
                child : []
            };
        return;
    }

    // one char
    //     hirano ver. : # => %
    //     hirano ver. : no +, ~, _
    if ( this.aux_bite_char_list( '|>,(){}*#.?-$!' + '+~_;' ) )
    {
        // $yylval = {type =>$type, val => $val, elem => []};
        this.following_token_id = this.mres_curr;
        this.following_token_sv = {
                id : this.mres_curr,
                val : null,
                child : []
            };
        return;
    }

    // 3. quoted literal
    //     new
    if ( this.aux_bite_str_list('"' + "'" + '/' ) ) // q{"}, q{'}, q{/} 
    {
        let endc = this.mres_curr;

        let res = this.aux_bite_quoted_string_rest(endc, "\\", [ [endc,endc] ]);
        if (! res)
        {
            throw Error(`Error in lex! (quoted string '${endc}') (81948650_03a947a1)\n`);
        }

        let id = 't_LITERAL';
        if (endc == "/")
        {
            id = 't_PATTERN_LITERAL';
        }

        // $yylval = {type =>$type, val => $val, elem => []};
        this.following_token_id = id;
        this.following_token_sv = {
                id : id,
                val : this.mres_value,
                child : []
            };
        if (endc == "/")
        {
            if (! this.aux_bite_pattern( /^[_A-Za-z]*/ ))
            { throw Error("Error: internal error (ac13f3ec_7f787326)\n"); }
            this.following_token_sv.option_str = this.mres_curr;
        }
        return;
    }

    // 4. bare label literal
    //   hirano ver:  IDENTIFIER and ':'
    //       new: \w+\: => LABEL
    if ( this.aux_bite_pattern( /^[_A-Za-z0-9]+:/ ) )
    {
        // escape : for some env.
        let n = this.mres_curr.length;
        let val = this.mres_curr.substring(0, n - 1);

        this.following_token_id = 't_LABEL';
        this.following_token_sv = {
                id : 't_LABEL',
                val : val,
                child : []
            };
        return;
    }

    // 5. bare literal
    //  hirano ver. : /^[0-9]+/ => NATURAL
    //  hirano ver. : /^[_A-Za-z][_A-Za-z0-9]*/ => IDENTIFIER
    //     new: /^[_A-Za-z0-9]+/  LITERAL

    if ( this.aux_bite_pattern( /^[_A-Za-z0-9]+/ ) )
    {
        // $yylval = {type =>$type, val => $val, elem => []};
        this.following_token_id = 't_LITERAL';
        this.following_token_sv = {
                id : 't_LITERAL',
                val : this.mres_curr,
                child : []
            };
        return;
    }

    // Error: unexpected head string found
    //
    let err_next_chars = this.rest.length <= 10 ? this.rest
        : this.rest.substring(0, 10) + "...";
    throw Error("Error in lex: (unexpected chars) '" + err_next_chars + "'\n");
};



// TLTokenizer_aux_TokenizerByArray

var TLTokenizer_aux_TokenizerByArray = function(tokens) {
    this.pos = -1
    this.tokens = tokens;

    this.read_next_token();
};
TLTokenizer_aux_TokenizerByArray.prototype.reset = function(){
    this.pos = -1;
    this.read_next_token();
};
TLTokenizer_aux_TokenizerByArray.prototype.read_next_token = function(){
    if (this.pos + 1 < this.tokens.length )
    {
        this.pos++;
        let next_token = this.tokens[this.pos];

        this.following_token_id = next_token.id;
        this.following_token_sv = next_token;
        return;
    }
    else
    {
        this.pos = this.tokens.length;
        this.following_token_id = '(eot)';
        this.following_token_sv = null;
        return;
    }
};


// TLTokenizerSeparated

var TLTokenizerSeparated = function(str) {
    let tok = new TLTokenizer_aux_Tokenizer_PathAndTreePat(str);
    let tokens_pathpat=[];
    let tokens_treepat=[];

    // ? ? ? ; ? ? ? の列を読む ただし ; が出てこない時は全部後につける
    while(1)
    {
        // ';' が出てくるまで読む
        if (tok.following_token_id == ';')
        {
            tokens_pathpat = tokens_treepat;
            tokens_treepat = [];
            tok.read_next_token();
            break;
        }
        else if (tok.following_token_id == '(eot)')
        {
            break;
        }
        else
        {
            tokens_treepat.push(tok.following_token_sv);
            tok.read_next_token();
        }
    }

    while(tok.following_token_id != '(eot)')
    {
        tokens_treepat.push(tok.following_token_sv);
        tok.read_next_token();
    }


    this.pathpat = new TLTokenizer_aux_TokenizerByArray(tokens_pathpat);
    this.treepat = new TLTokenizer_aux_TokenizerByArray(tokens_treepat);
};

// TLTokenizer ここまで

///////////////////////////////////////////////////////////////
// TLTreePatternAST.ToTreePatternAST ここから
///////////////////////////////////////////////////////////////

// var TLTreePatternAST = {};

// TLTreePatternAST.ToTreePatternAST は ツリーパターンのAST変換
// TLTreePatternAST.ToPathPatternAST は パスパターンのAST変換(予定)


var TLTreePatternAST =
    TreeWrapperBase.useNewTreeClass ('TLTreePatternAST', 'id', 'val');
    // TreePatternAST は 現状、最終段の変換のみに使っている
    // // requires :  TreeWrapperBase.js

TLTreePatternAST.ToTreePatternAST = function (src_tree) {
    // 複製したものを破壊的に変換する

    let ret_tree = this.aux_DupTree(src_tree);

    // NodeFactor のうち NodeBlock 以外を処理
    ret_tree = this.ToTreePatternAST_20_NodeFactor(ret_tree);

    // NodeFactor の NodeBlock を処理               ←やった
    // NodeTerm の 右辺を処理                       ← やった
    // NodeTerm012 の 右辺を処理    (Seq へ)        ← やった
    ret_tree = this.ToTreePatternAST_40(ret_tree);

    // // NodeTerm012Joint の処理
    ret_tree = this.ToTreePatternAST_60(ret_tree);

    // a_Parent_Child を削除する ??? ()
    ret_tree = this.ToTreePatternAST_80(ret_tree);

    // a_Child -> a_Non_Order
    ret_tree = this.ToTreePatternAST_90(ret_tree);

    // 最上位の PathPattern/TreePattern を整理する
    ret_tree = this.ToTreePatternAST_95(ret_tree);

    ret_tree = TLTreePatternAST.newImportFromFlatHashTree(ret_tree, 'child', 'id', 'val');

    return ret_tree;
};

TLTreePatternAST.aux_DupTree = function (tree) {
    let ra_src_child = tree.child;

    let n_child = ra_src_child.length;
    let dst_child = Array(n_child); // Array.fill(null); とはせず後で全設定

    for (let i = 0; i < n_child; i++)
    {
        dst_child[i] = this.aux_DupTree(ra_src_child[i]);
    }
    // Object.assign({}, some_object) で shallow copy
    let dst_tree = Object.assign({}, tree)
    dst_tree.child = dst_child;

    return dst_tree;
};
TLTreePatternAST.aux_NodeIDsEq = function (node, args) { // args ; array...
    if (! ('id' in node))
    { throw Error("Error: wrong arg (arg0 is not node)! (04eb8ca6_9382d909)\n"); }

    let i, s;
    while(args.length)
    {
        if (args.length < 2)
        {
            throw Error("Error: Error: Wrong Args of aux_NodeIDsEq! (1054fc28_e32a3ac8)\n");
        }
        i = args.shift();
        s = args.shift();
        if (i < 0)
        {
            if (node.id != s) { return 0; }
        }
        else
        {
            if (i > node.child.length - 1) { return 0; }
            if (node.child[i].id != s) { return 0; }
        }
    }
    return 1;
};
TLTreePatternAST.aux_AllNodeIDsEq = function (node, root_id, args) { // args ; array...

    if (! ('id' in node))
    { throw Error("Error: wrong arg (arg0 is not node)! (04eb8ca6_9382d909)\n"); }


    if (root_id != undefined && root_id != null)
    {
        if (node.id != root_id) { return 0; }
    }

    if (args.length != node.child.length) { return 0; }

    for (let i = 0; i < args.length; i++)
    {
        if (args[i] == undefined || args[i] == null) { continue; }
        if (node.child[i].id != args[i]) { return 0; }
    }
    return 1;
};
TLTreePatternAST.aux_GetChild = function (node, i, s) {
    if (! ('id' in node))
    { throw Error("Error: wrong arg (arg0) (e19c9baa_9c34ad34)\n"); }

    if (i > node.child.length - 1)
    { throw Error("Error: index out of range in aux_GetChild! (3299b931_2c3c8c50)\n"); }
    if (node.child[i].id != s)
    { throw Error("Error: wrong id in aux_GetChild\n"); }

    return node.child[i];
};
TLTreePatternAST.ToTreePatternAST_20_NodeFactor = function (tree) {
    // 1. NodeFactor --> NodeFactorWithCond
    //    NodeFactor --> '-' NodeFactorWithCond
    //    を a_Node に変更する
    //        ( NodeFactor --> NodeBlock ) ←これは別
    // 2. NodeFactor --> NodeBlock
    //    を a_Block に変換する

    let ci = tree.child.map((c) => c.id);

    if (tree.id != 'NodeFactor')
    {
        for (let i in tree.child)
        { tree.child[i] = this.ToTreePatternAST_20_NodeFactor(tree.child[i]); }
        return tree;
    }


    let down_node = null;

    // # NodeFactor --> NodeFactorWithCond
    // if ($tree->{id} eq 'NodeFactor' && $ci[0] eq 'NodeFactorWithCond')
    // { $down_node = $tree->{child}->[0]; }
    // # NodeFactor --> '-' NodeFactorWithCond
    // elsif ($tree->{id} eq 'NodeFactor' && $ci[0] eq '-')
    // { $down_node = $tree->{child}->[1]; }
    // # else  ( NodeFactor --> NodeBlock  と NodeFactor 以外)

    // NodeFactor --> NodeFactorWithCond
    if (this.aux_AllNodeIDsEq(tree, 'NodeFactor', ['NodeFactorWithCond']))
    { down_node = this.aux_GetChild(tree, 0, 'NodeFactorWithCond'); }
    // NodeFactor --> '-' NodeFactorWithCond
    else if (this.aux_AllNodeIDsEq(tree, 'NodeFactor', ['-', 'NodeFactorWithCond']))
    { down_node = this.aux_GetChild(tree, 1, 'NodeFactorWithCond'); }
    // // else  ( NodeFactor --> NodeBlock  と NodeFactor 以外)
    // // // down_node が null のまま進行

    if (down_node == undefined || down_node == null)
    {
        // a_Node に変換しないパターン
        // block の処理をする
        if (this.aux_AllNodeIDsEq(tree, 'NodeFactor', ['NodeBlock']))
        {
            let block_node = this.aux_GetChild(tree, 0, 'NodeBlock');
            // NodeBlock  --> t_LABEL '(' NodeTerm012Joint ')'
            // NodeBlock  --> '(' NodeTerm012Joint ')'
            // NodeBlock  --> '(?' '-' t_LITERAL ')'
            //
            let dst_tree;
            if (this.aux_AllNodeIDsEq(block_node, 'NodeBlock', ['t_LABEL', '(', 'NodeTerm012Joint', ')']))
            {
                dst_tree = {
                    id : 'a_Block',
                    val : null,
                    label : this.aux_GetChild(block_node, 0, 't_Label'),
                    child : [this.aux_GetChild(block_node, 2, 'NodeTerm012Joint')]
                };
                dst_tree.child[0] = this.ToTreePatternAST_20_NodeFactor(dst_tree.child[0]);
            }
            else if (this.aux_AllNodeIDsEq(block_node, 'NodeBlock', ['(', 'NodeTerm012Joint', ')']))
            {
                dst_tree = {
                    id : 'a_Block',
                    val : null,
                    child : [this.aux_GetChild(block_node ,1, 'NodeTerm012Joint')]
                };
                dst_tree.child[0] = this.ToTreePatternAST_20_NodeFactor(dst_tree.child[0]);
            }
            else if (this.aux_AllNodeIDsEq(block_node, 'NodeBlock', ['(?', '-', 't_LITERAL', ')']))
            {
                dst_tree = {
                    id : 'a_Rec_Ref',
                    val : null,
                    num : this.aux_GetChild(block_node, 2, 't_LITERAL').val,
                    child : []
                };
                if (!/^\d+$/.test(dst_tree.num))
                { throw Error(`Error: wrong recursive ref num '${dst_tree.num}'! (2b7175d6_56aeaba4)\n`); }
            }
            else
            { throw Error("Error: Trap internal error! (45d2eb06_de2fa39e)\n"); }

            return dst_tree;
        }
        else
        {
            throw Error("Error: internal error (6362f77a_8dd863a7)\n");
            //
            //
            //    NodeFactor --> NodeFactorWithCond
            //    NodeFactor --> '-' NodeFactorWithCond
            //       は最初の if で弾かれる
            //    NodeFactor --> NodeBlock は2段目の if で弾かれる
            //
            // for my $c(@{$tree->{child}})
            // { $c = ToTreePatternAST_20_NodeFactor($c); }
            // return $tree;
        }
    }
    else
    {
        // a_Node に変換するケース
        // $down_node は NodeFactorWithCond
        let dst_tree = { id : 'a_Node', val : null, child : [
                {id :'a_Attr_Cond_List', val : null, child : []},
                {id :'a_Place_List', val : null, child : []},
                {id :'a_Child', val : null, child : []}
            ]};
        if (ci[0] == '-') { dst_tree.exclude_mached = 1; }
        else              { dst_tree.exclude_mached = 0; }
        tree = down_node;

        // $tree は NodeFactorWithCond
        //     NodeFactorWithCond --> '!' NodeFactorWithPostCond
        //     NodeFactorWithCond --> NodeFactorWithPostCond
        ci = tree.child.map((c) => c.id);
        if (ci[0] == '!')
        { down_node = tree.child[1]; dst_tree.neg = 1;}
        else 
        { down_node = tree.child[0]; dst_tree.neg = 0;}
        tree = down_node;

        // $tree は NodeFactorWithPostCond
        //     NodeFactorWithPostCond -->  Node  NodeCond012
        let node_node = this.aux_GetChild(tree, 0, 'Node');
        let node_cond_012_node = this.aux_GetChild(tree, 1, 'NodeCond012');

        let node_RHS = node_node.child[0];
        // $node_node は Node
        //     $node_RHS は . _ $ t_LITERAL t_PATTERN_LITERAL

        // node_node の処理
        //
        //     Node  --> '.'
        //     Node  --> '_'
        //     Node  --> '$'         ########追加
        //     Node  --> t_LITERAL
        //     Node  --> t_PATTERN_LITERAL
        //
        if (node_RHS.id == '.') { dst_tree.node_type = 'any'; }
        else if (node_RHS.id == '_') { dst_tree.node_type = 'none'; }
        else if (node_RHS.id == '$') { dst_tree.node_type = 'end'; }
        else if (node_RHS.id == 't_LITERAL')
        {
            dst_tree.node_type = 'id';
            dst_tree.val = node_RHS.val;
        }
        else if (node_RHS.id == 't_PATTERN_LITERAL')
        {
            dst_tree.node_type = 'id_regexp';
            dst_tree.val = node_RHS.val;

            if (! ('option_str' in node_RHS))
            { throw Error("Error: internal error (9d1aeeef_05f2fb74)\n"); }
            dst_tree.option_str = node_RHS.option_str;
        }
        else { throw Error("Error: Trap internal error! (b33bd45d_10954886)\n"); }

        // node_cond_012_node  の処理
        //
        //     NodeCond012   --> NodeCond NodeCond012
        //     NodeCond012   --> (none)
        //     NodeCond      --> '#' t_LITERAL
        //     NodeCond      --> '#' t_PATTERN_LITERAL
        //     NodeCond      --> '#' '{' t_LITERAL '}' t_LITERAL
        //     NodeCond      --> '#' '{' t_LITERAL '}' t_PATTERN_LITERAL
        //     NodeCond      --> '##' t_LITERAL
        //     NodeCond      --> '##@' t_LITERAL
        //
        let dst_cond_list = dst_tree.child[0];
        if (dst_cond_list.id != 'a_Attr_Cond_List')
        { throw Error("Error: Trap internal error (658c0d9b_f4641aea)!\n"); }

        let dst_place_list = dst_tree.child[1];
        if (dst_place_list.id != 'a_Place_List')
        { throw Error("Error: Trap internal error (1627d4e4_9eeb1f3c!\n");}


        while (node_cond_012_node.child.length)
        {
            let node_cond = node_cond_012_node.child[0];

            let dst_node_cond = {id : 'a_Attr_Cond', val : null, child : []};
            let dst_place_node = {id : null, val : null, child : []};

            if (node_cond.id != 'NodeCond')
            { throw Error("Error: Trap internal error!(41421071_fd1dd965)\n"); }

            ci = node_cond.child.map((c) => c.id);

            if (ci[0] == '#' && ci[1] == 't_LITERAL' )
            {
                dst_node_cond.key_type = 'sec';
                dst_node_cond.match_type = 'str';
                dst_node_cond.val = node_cond.child[1].val;
                dst_cond_list.child.push(dst_node_cond);
            }
            else if (ci[0] == '#' && ci[1] == 't_PATTERN_LITERAL' )
            {
                dst_node_cond.key_type = 'sec';
                dst_node_cond.match_type = 'regexp';
                dst_node_cond.val = node_cond.child[1].val;

                if (! ('option_str' in node_cond.child[1]))
                { throw Error("Error: internal error (9797c61b_d87f09f3)\n"); }

                dst_node_cond.option_str = node_cond.child[1].option_str;

                dst_cond_list.child.push(dst_node_cond);
            }
            else if (ci[0] == '#' && ci[1] == '{' && ci[4] == 't_LITERAL' )
            {
                dst_node_cond.key_type = 'other';
                dst_node_cond.match_type = 'str';
                dst_node_cond.key_val = node_cond.child[2].val;
                dst_node_cond.val = node_cond.child[4].val;
                dst_cond_list.child.push(dst_node_cond);
            }
            else if (ci[0] == '#' && ci[1] == '{' && ci[4] == 't_PATTERN_LITERAL' )
            {
                dst_node_cond.key_type = 'other';
                dst_node_cond.match_type = 'regexp';
                dst_node_cond.key_val = node_cond.child[2].val;
                dst_node_cond.val = node_cond.child[4].val;
                dst_cond_list.child.push(dst_node_cond);
            }
            else if (ci[0] == '##')
            {
                dst_place_node.id = 'a_Single_Place';
                dst_place_node.val = node_cond.child[1].val;
                dst_place_list.child.push(dst_place_node);
            }
            else if (ci[0] == '##@')
            {
                dst_place_node.id = 'a_Multi_Place';
                dst_place_node.val = node_cond.child[1].val;
                dst_place_list.child.push(dst_place_node);
            }
            else {throw Error("Error: Trap internal error (1273ad1c_c73f56c9)!\n");}

            // 次のノードに進む
            node_cond_012_node = node_cond_012_node.child[1];
        }

        // 一律に ordered にしておいて、後で変更する。
        dst_tree.ordered = 1;

        // 暫定

        return dst_tree;
    }
};
TLTreePatternAST.ToTreePatternAST_40 = function (tree) {

    //   (  NodeFactor の NodeBlock を処理 ← ToTreePatternAST_20 に移した )
    // NodeTerm の 右辺を処理
    // NodeTerm012 の 右辺を処理


    // NodeTerm  --> NodeFactor --> ??? == から
    //     NodeTerm  --> a_Node に変換されたもの
    // NodeTerm  --> NodeFactor --> NodeBlock
    // NodeTerm  --> NodeFactor== '*'
    // NodeTerm  --> NodeFactor== '+'
    if (tree.id == 'NodeTerm')
    {
        let factor_node = tree.child[0];
        let dst_tree = null;
        if (tree.child.length == 1)
        {
            // NodeTerm  --> NodeFactor==
            dst_tree = this.ToTreePatternAST_40(factor_node);
        }
        else if (this.aux_AllNodeIDsEq(tree, 'NodeTerm', [null, '*']))
        {
            dst_tree = {
                id : 'a_Rep0',
                val : null,
                child : [factor_node],
                shortest : 0
            };
            dst_tree.child[0] = this.ToTreePatternAST_40(dst_tree.child[0]);
        }
        else if (this.aux_AllNodeIDsEq(tree, 'NodeTerm', [null, '*', '?']))
        {
            dst_tree = {
                id : 'a_Rep0',
                val : null,
                child : [factor_node],
                shortest : 1
            };
            dst_tree.child[0] = this.ToTreePatternAST_40(dst_tree.child[0]);
        }
        else if (this.aux_AllNodeIDsEq(tree, 'NodeTerm', [null, '+']))
        {
            dst_tree = {
                id : 'a_Rep1',
                val : null,
                child : [factor_node],
                shortest : 0
            };
            dst_tree.child[0] = this.ToTreePatternAST_40(dst_tree.child[0]);
        }
        else if (this.aux_AllNodeIDsEq(tree, 'NodeTerm', [null, '+', '?']))
        {
            dst_tree = {
                id : 'a_Rep1',
                val : null,
                child : [factor_node],
                shortest : 1
            };
            dst_tree.child[0] = this.ToTreePatternAST_40(dst_tree.child[0]);
        }
        else
        { throw Error("Error: Trap internal error (94c0a497_3565def5)!\n"); }

        return dst_tree;
    }
    // # NodeTerm012 の 右辺を処理    (Seq へ)        ←まだ 
    //     NodeTerm012       --> NodeTerm NodeTerm012
    //     NodeTerm012       -->
    else if (tree.id == 'NodeTerm012')
    {
        let ra_term_nodes = [];
        let node_term_012 = tree;
        let dst_node = null;

        while (this.aux_AllNodeIDsEq(node_term_012, 'NodeTerm012', [null, 'NodeTerm012']))
        {
            ra_term_nodes.push(node_term_012.child[0]);
            node_term_012 = this.aux_GetChild(node_term_012, 1, 'NodeTerm012');
        }
        if (node_term_012.child.length != 0)
        { throw Error(`${node_term_012.child[1].id} Error: Trap internal error (83877cae_df9bd754)!\n`); }

        // // 以下は 123 -> 012 になったことで削除
        // ra_term_nodes.push(node_term_012.child[0]);
        //
        // if ( ra_term_nodes.length == 0)
        // { throw Error("Error: Trap internal error (f54d7dc0_70412575)!\n"); }
        // // elsif ( ra_term_nodes.length == 1)
        // // {
        // //     dst_node = ra_term_nodes[0];
        // // }
        // else
        {
            dst_node = {
                id : 'a_Seq',
                val : null,
                child : ra_term_nodes
            };
        }
        for (let i in dst_node.child)
        { dst_node.child[i] = this.ToTreePatternAST_40(dst_node.child[i]); }
        return dst_node;
    }
    else
    {
        // a_Node に変換しないパターン
        for (let i in tree.child)
        { tree.child[i] = this.ToTreePatternAST_40(tree.child[i]); }
        return tree;
    }
};
TLTreePatternAST.ToTreePatternAST_60 = function (tree) {

    // NodeTerm012Joint の処理


    //     NodeTerm012Joint   -->  NodeTerm012 '>' NodeTerm012Joint
    //     NodeTerm012Joint   -->  NodeTerm012 '>' '~' NodeTerm012Joint
    //     NodeTerm012Joint   -->  NodeTerm012 '|' NodeTerm012Joint
    //     NodeTerm012Joint   -->  NodeTerm012

        // L(x > L(y > L(z > L(w))))
        // L(x > L(y > L(z > L(w))))
        //     x : x > L(y > L(z > L(w)))
        //     P+(x, L(y + L(z + L(w)))
        //
        // L(x +~ L(y + L(z + L(w))))
        //     x : x +~ L(y + L(z + L(w)))
        //     P+~(L(y + L(z + L(w)))
        //     P+~(L(~(y) + L(z + L(w)))
        //          さらに(unseq)
    if (tree.id == 'NodeTerm012Joint')
    {
        let dst_node = null;
        let terms = [];

        let down_next = tree;

        while (down_next != undefined && down_next != null)
        {
            if (this.aux_AllNodeIDsEq(down_next, 'NodeTerm012Joint', [null, '>', 'NodeTerm012Joint']))
            {
                terms.push({
                    node : down_next.child[0],
                    type : 'a_Parent_Child'
                });
                down_next = this.aux_GetChild(down_next, 2, 'NodeTerm012Joint')
            }
            else if (this.aux_AllNodeIDsEq(down_next, 'NodeTerm012Joint', [null, '>', '~', 'NodeTerm012Joint']))
            {
                terms.push({
                    node : down_next.child[0],
                    type : 'a_Non_Order'
                });
                down_next = this.aux_GetChild(down_next, 3, 'NodeTerm012Joint')
            }
            else if (this.aux_AllNodeIDsEq(down_next, 'NodeTerm012Joint', [null, '|', 'NodeTerm012Joint']))
            {
                terms.push({
                    node : down_next.child[0],
                    type : 'a_P_Or'
                });
                down_next = this.aux_GetChild(down_next, 2, 'NodeTerm012Joint')
            }
            else if (this.aux_AllNodeIDsEq(down_next, 'NodeTerm012Joint', [null]))
            {
                terms.push({
                    node : down_next.child[0],
                    type : ''
                });
                down_next = null;
            }
            else
            { throw Error("Error: Trap internal error (e13b5cbe_0ea85964)!\n"); }
        }

        dst_node = terms[terms.length - 1].node;
        // 最後の leaf 以下を変換
        dst_node = this.ToTreePatternAST_60(dst_node);
        for (let i = terms.length - 2; i >= 0; i--)
        {
            let parent_node = this.ToTreePatternAST_60(terms[i].node);
            let child_node = dst_node;
            if (terms[i].type != 'a_Non_Order')
            {
                // OR か ParentChild のとき
                dst_node = {
                    id : terms[i].type,
                    child : [parent_node, child_node]
                };
            }
            else
            {
                // a_Non_Order のとき
                dst_node = {
                    id : 'a_Parent_Child',

                    child : [parent_node, {
                        id : 'a_Non_Order',
                        child : [child_node]
                    } ]
                };
            }
        }
        return dst_node;

    }
    else
    {
        // a_Node に変換しないパターン
        for (let i in tree.child)
        { tree.child[i] = this.ToTreePatternAST_60(tree.child[i]); }
        return tree;
    }

};
TLTreePatternAST.ToTreePatternAST_80 = function (tree) {

    // a_Parent_Child を削除する ??? ()

    if (tree.id == 'a_Parent_Child')
    {
        if (tree.child.length !=2 )
        { throw Error("Error: Trap internal error (b67640c9620f542c)!\n"); }

        if (tree.child[0].id != 'a_Seq')
        { throw Error("Error: child '>' of Non-Seq/Node element is not supported yet!!\n"); }

        let parent_node = this.aux_GetChild(tree, 0, 'a_Seq');

        if (parent_node.child.length == 0)
        { throw Error("Error: no parent for child '>' (Seq has 0 element)\n"); }


        let child_node = tree.child[1];

        parent_node = this.ToTreePatternAST_80(parent_node);
        child_node = this.ToTreePatternAST_80(child_node);



        let parent_seq_last_node = parent_node.child[parent_node.child.length -1];
        if (parent_seq_last_node.id !=  'a_Node')
        { throw Error("Error: non Node parent for child '>' is not supported yet!\n"); }


        let parent_seq_last_node_child = this.aux_GetChild(parent_seq_last_node, 2, 'a_Child');


        if (parent_seq_last_node_child.child.length > 0)
        { throw Error("Error: Conflict multiple children descriptor!\n");}

        parent_seq_last_node_child.child[0] = child_node;
        return parent_node;
    }
    else
    {
        // a_Node に変換しないパターン
        for (let i in tree.child)
        {
            tree.child[i] = this.ToTreePatternAST_80(tree.child[i]); }
        return tree;
    }


};


TLTreePatternAST.ToTreePatternAST_90 = function (tree, in_non_order) {

    let next_level_in_non_order;
    // a_Child -> a_Non_Order -> ... -> a_Child の間の a_Node を全て
    // {ordered} = 0 する

    if (in_non_order === undefined || in_non_order === null)
    {
        in_non_order = 0;
    }

    if (tree.id == 'a_Non_Order') { in_non_order = 1; }
    else if (tree.id == 'a_Child')  { in_non_order = 0; }
    else if (in_non_order && tree.id == 'a_Node')   { tree.ordered = 0; }
    // else: do nothing


    // 再帰
    for (let i in tree.child)
    { tree.child[i] = this.ToTreePatternAST_90(tree.child[i], in_non_order); }

    return tree;
};


TLTreePatternAST.ToTreePatternAST_95 = function (tree) {


    //     PathAndTreePattern --> TreePattern
    //     PathAndTreePattern --> ';' TreePattern
    //     PathAndTreePattern --> PathPattern ';' TreePattern
    //     PathAndTreePattern --> PathPattern ';'
    // から
    //     a_Root  -->  a_Path_Pat  a_Tree_Pat
    // ではなく
    //
    //     TreePattern --> ???
    // から
    //     a_Tree_Pat  --> ???
    // へ変換

    if (tree.id != 'TreePattern')
    { throw Error("Error: Trap internal error (ccc2f075_79a0f2b5)!\n"); }

    let tree_pat_orig_node = tree;

    let dst_node = {
        id : 'a_Tree_Pat',
        val : null,
        child : tree_pat_orig_node.child.slice() // shallow copy
    };

    return dst_node;
};


// TLTreePatternAST.ToTreePatternAST ここまで

///////////////////////////////////////////////////////////////
// cjs/mjs の生成を出来るようにしよう
///////////////////////////////////////////////////////////////

