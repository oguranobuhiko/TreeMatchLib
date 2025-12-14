// pre here...

'use strict';
// ↑ これも pre に書く前提

// generated from ...


////////////////////////////////////////////////////////////////
// END PRE
////////////////////////////////////////////////////////////////

var PathPatternParser = {};

{
    let parser_ref = PathPatternParser;

    ////////////////////////////////////////////////////////////////////
    // 変数定義部分

    parser_ref.PG_TERMINAL_SYMBOLS = [
        "\#\#\@",
        "\#\#",
        "\(?",
        "|",
        ">",
        ",",
        "\(",
        "\)",
        "\{",
        "\}",
        "*",
        "\#",
        ".",
        "?",
        "-",
        "\$",
        "!",
        "+",
        "~",
        "_",
        ";",
        "t_LITERAL",
        "t_PATTERN_LITERAL",
        "t_LABEL"
    ];


    parser_ref.PG_STATE_TABLE = [
        {
            index : 0,
            next_s_r : {
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 3, "rule_no_by_nt" : 2},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 3, "rule_no_by_nt" : 2},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 3, "rule_no_by_nt" : 2},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 3, "rule_no_by_nt" : 2},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 3, "rule_no_by_nt" : 2},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 3, "rule_no_by_nt" : 2},
                "PathPattern" : {"is_shift" : 1, "pri" : 0, "trans_to" : 1},
                "Node012" : {"is_shift" : 1, "pri" : 0, "trans_to" : 2}
            }
        },
        {
            index : 1,
            next_s_r : {
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 0, "rule_no_by_nt" : 1}
            }
        },
        {
            index : 2,
            next_s_r : {
                "." : {"is_shift" : 1, "pri" : 0, "trans_to" : 3},
                "\$" : {"is_shift" : 1, "pri" : 0, "trans_to" : 4},
                "_" : {"is_shift" : 1, "pri" : 0, "trans_to" : 5},
                "t_LITERAL" : {"is_shift" : 1, "pri" : 0, "trans_to" : 6},
                "t_PATTERN_LITERAL" : {"is_shift" : 1, "pri" : 0, "trans_to" : 7},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 1, "rule_no_by_nt" : 1},
                "NodeFactorWithPostCond" : {"is_shift" : 1, "pri" : 0, "trans_to" : 8},
                "Node" : {"is_shift" : 1, "pri" : 0, "trans_to" : 9}
            }
        },
        {
            index : 3,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 13, "rule_no_by_nt" : 1},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 13, "rule_no_by_nt" : 1},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 13, "rule_no_by_nt" : 1},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 13, "rule_no_by_nt" : 1},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 13, "rule_no_by_nt" : 1},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 13, "rule_no_by_nt" : 1},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 13, "rule_no_by_nt" : 1},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 13, "rule_no_by_nt" : 1},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 13, "rule_no_by_nt" : 1}
            }
        },
        {
            index : 4,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 17, "rule_no_by_nt" : 5},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 17, "rule_no_by_nt" : 5},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 17, "rule_no_by_nt" : 5},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 17, "rule_no_by_nt" : 5},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 17, "rule_no_by_nt" : 5},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 17, "rule_no_by_nt" : 5},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 17, "rule_no_by_nt" : 5},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 17, "rule_no_by_nt" : 5},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 17, "rule_no_by_nt" : 5}
            }
        },
        {
            index : 5,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 14, "rule_no_by_nt" : 2},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 14, "rule_no_by_nt" : 2},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 14, "rule_no_by_nt" : 2},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 14, "rule_no_by_nt" : 2},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 14, "rule_no_by_nt" : 2},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 14, "rule_no_by_nt" : 2},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 14, "rule_no_by_nt" : 2},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 14, "rule_no_by_nt" : 2},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 14, "rule_no_by_nt" : 2}
            }
        },
        {
            index : 6,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 15, "rule_no_by_nt" : 3},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 15, "rule_no_by_nt" : 3},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 15, "rule_no_by_nt" : 3},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 15, "rule_no_by_nt" : 3},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 15, "rule_no_by_nt" : 3},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 15, "rule_no_by_nt" : 3},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 15, "rule_no_by_nt" : 3},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 15, "rule_no_by_nt" : 3},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 15, "rule_no_by_nt" : 3}
            }
        },
        {
            index : 7,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 16, "rule_no_by_nt" : 4},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 16, "rule_no_by_nt" : 4},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 16, "rule_no_by_nt" : 4},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 16, "rule_no_by_nt" : 4},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 16, "rule_no_by_nt" : 4},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 16, "rule_no_by_nt" : 4},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 16, "rule_no_by_nt" : 4},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 16, "rule_no_by_nt" : 4},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 16, "rule_no_by_nt" : 4}
            }
        },
        {
            index : 8,
            next_s_r : {
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 2, "rule_no_by_nt" : 1},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 2, "rule_no_by_nt" : 1},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 2, "rule_no_by_nt" : 1},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 2, "rule_no_by_nt" : 1},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 2, "rule_no_by_nt" : 1},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 2, "rule_no_by_nt" : 1}
            }
        },
        {
            index : 9,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 1, "pri" : 0, "trans_to" : 10},
                "\#\#" : {"is_shift" : 1, "pri" : 0, "trans_to" : 11},
                "\#" : {"is_shift" : 1, "pri" : 0, "trans_to" : 12},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "NodeCond012" : {"is_shift" : 1, "pri" : 0, "trans_to" : 13},
                "NodeCond" : {"is_shift" : 1, "pri" : 0, "trans_to" : 14}
            }
        },
        {
            index : 10,
            next_s_r : {
                "t_LITERAL" : {"is_shift" : 1, "pri" : 0, "trans_to" : 15}
            }
        },
        {
            index : 11,
            next_s_r : {
                "t_LITERAL" : {"is_shift" : 1, "pri" : 0, "trans_to" : 16}
            }
        },
        {
            index : 12,
            next_s_r : {
                "\{" : {"is_shift" : 1, "pri" : 0, "trans_to" : 17},
                "t_LITERAL" : {"is_shift" : 1, "pri" : 0, "trans_to" : 18},
                "t_PATTERN_LITERAL" : {"is_shift" : 1, "pri" : 0, "trans_to" : 19}
            }
        },
        {
            index : 13,
            next_s_r : {
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 4, "rule_no_by_nt" : 1},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 4, "rule_no_by_nt" : 1},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 4, "rule_no_by_nt" : 1},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 4, "rule_no_by_nt" : 1},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 4, "rule_no_by_nt" : 1},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 4, "rule_no_by_nt" : 1}
            }
        },
        {
            index : 14,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 1, "pri" : 0, "trans_to" : 10},
                "\#\#" : {"is_shift" : 1, "pri" : 0, "trans_to" : 11},
                "\#" : {"is_shift" : 1, "pri" : 0, "trans_to" : 12},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 6, "rule_no_by_nt" : 2},
                "NodeCond012" : {"is_shift" : 1, "pri" : 0, "trans_to" : 20},
                "NodeCond" : {"is_shift" : 1, "pri" : 0, "trans_to" : 14}
            }
        },
        {
            index : 15,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 12, "rule_no_by_nt" : 6},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 12, "rule_no_by_nt" : 6},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 12, "rule_no_by_nt" : 6},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 12, "rule_no_by_nt" : 6},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 12, "rule_no_by_nt" : 6},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 12, "rule_no_by_nt" : 6},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 12, "rule_no_by_nt" : 6},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 12, "rule_no_by_nt" : 6},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 12, "rule_no_by_nt" : 6}
            }
        },
        {
            index : 16,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 11, "rule_no_by_nt" : 5},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 11, "rule_no_by_nt" : 5},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 11, "rule_no_by_nt" : 5},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 11, "rule_no_by_nt" : 5},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 11, "rule_no_by_nt" : 5},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 11, "rule_no_by_nt" : 5},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 11, "rule_no_by_nt" : 5},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 11, "rule_no_by_nt" : 5},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 11, "rule_no_by_nt" : 5}
            }
        },
        {
            index : 17,
            next_s_r : {
                "t_LITERAL" : {"is_shift" : 1, "pri" : 0, "trans_to" : 21}
            }
        },
        {
            index : 18,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 7, "rule_no_by_nt" : 1},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 7, "rule_no_by_nt" : 1},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 7, "rule_no_by_nt" : 1},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 7, "rule_no_by_nt" : 1},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 7, "rule_no_by_nt" : 1},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 7, "rule_no_by_nt" : 1},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 7, "rule_no_by_nt" : 1},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 7, "rule_no_by_nt" : 1},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 7, "rule_no_by_nt" : 1}
            }
        },
        {
            index : 19,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 8, "rule_no_by_nt" : 2},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 8, "rule_no_by_nt" : 2},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 8, "rule_no_by_nt" : 2},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 8, "rule_no_by_nt" : 2},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 8, "rule_no_by_nt" : 2},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 8, "rule_no_by_nt" : 2},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 8, "rule_no_by_nt" : 2},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 8, "rule_no_by_nt" : 2},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 8, "rule_no_by_nt" : 2}
            }
        },
        {
            index : 20,
            next_s_r : {
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 5, "rule_no_by_nt" : 1},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 5, "rule_no_by_nt" : 1},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 5, "rule_no_by_nt" : 1},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 5, "rule_no_by_nt" : 1},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 5, "rule_no_by_nt" : 1},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 5, "rule_no_by_nt" : 1}
            }
        },
        {
            index : 21,
            next_s_r : {
                "\}" : {"is_shift" : 1, "pri" : 0, "trans_to" : 22}
            }
        },
        {
            index : 22,
            next_s_r : {
                "t_LITERAL" : {"is_shift" : 1, "pri" : 0, "trans_to" : 23},
                "t_PATTERN_LITERAL" : {"is_shift" : 1, "pri" : 0, "trans_to" : 24}
            }
        },
        {
            index : 23,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 9, "rule_no_by_nt" : 3},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 9, "rule_no_by_nt" : 3},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 9, "rule_no_by_nt" : 3},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 9, "rule_no_by_nt" : 3},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 9, "rule_no_by_nt" : 3},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 9, "rule_no_by_nt" : 3},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 9, "rule_no_by_nt" : 3},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 9, "rule_no_by_nt" : 3},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 9, "rule_no_by_nt" : 3}
            }
        },
        {
            index : 24,
            next_s_r : {
                "\#\#\@" : {"is_shift" : 0, "pri" : 0, "rule_i" : 10, "rule_no_by_nt" : 4},
                "\#\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 10, "rule_no_by_nt" : 4},
                "\#" : {"is_shift" : 0, "pri" : 0, "rule_i" : 10, "rule_no_by_nt" : 4},
                "." : {"is_shift" : 0, "pri" : 0, "rule_i" : 10, "rule_no_by_nt" : 4},
                "\$" : {"is_shift" : 0, "pri" : 0, "rule_i" : 10, "rule_no_by_nt" : 4},
                "_" : {"is_shift" : 0, "pri" : 0, "rule_i" : 10, "rule_no_by_nt" : 4},
                "t_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 10, "rule_no_by_nt" : 4},
                "t_PATTERN_LITERAL" : {"is_shift" : 0, "pri" : 0, "rule_i" : 10, "rule_no_by_nt" : 4},
                "\(eot\)" : {"is_shift" : 0, "pri" : 0, "rule_i" : 10, "rule_no_by_nt" : 4}
            }
        }
    ];


    parser_ref.PG_RULES = [
        { lhs : "\(ADDED_START\)", rhs : ["PathPattern"],  r_pri : 0 },
        { lhs : "PathPattern", rhs : ["Node012"],  r_pri : 0 },
        { lhs : "Node012", rhs : ["Node012", "NodeFactorWithPostCond"],  r_pri : 0 },
        { lhs : "Node012", rhs : [],  r_pri : 0 },
        { lhs : "NodeFactorWithPostCond", rhs : ["Node", "NodeCond012"],  r_pri : 0 },
        { lhs : "NodeCond012", rhs : ["NodeCond", "NodeCond012"],  r_pri : 0 },
        { lhs : "NodeCond012", rhs : [],  r_pri : 0 },
        { lhs : "NodeCond", rhs : ["\#", "t_LITERAL"],  r_pri : 0 },
        { lhs : "NodeCond", rhs : ["\#", "t_PATTERN_LITERAL"],  r_pri : 0 },
        { lhs : "NodeCond", rhs : ["\#", "\{", "t_LITERAL", "\}", "t_LITERAL"],  r_pri : 0 },
        { lhs : "NodeCond", rhs : ["\#", "\{", "t_LITERAL", "\}", "t_PATTERN_LITERAL"],  r_pri : 0 },
        { lhs : "NodeCond", rhs : ["\#\#", "t_LITERAL"],  r_pri : 0 },
        { lhs : "NodeCond", rhs : ["\#\#\@", "t_LITERAL"],  r_pri : 0 },
        { lhs : "Node", rhs : ["."],  r_pri : 0 },
        { lhs : "Node", rhs : ["_"],  r_pri : 0 },
        { lhs : "Node", rhs : ["t_LITERAL"],  r_pri : 0 },
        { lhs : "Node", rhs : ["t_PATTERN_LITERAL"],  r_pri : 0 },
        { lhs : "Node", rhs : ["\$"],  r_pri : 0 }
    ];


    parser_ref.PG_RULE_ACTION = [
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null
    ];


    ////////////////////////////////////////////////////////////////////
    // parse()

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
    ////////////////////////////////////////////////////////////////
    // BEGIN ACTION
    ////////////////////////////////////////////////////////////////
    {
        let rule_i = shift_or_reduce.rule_i;
        if (parser_ref.PG_RULE_ACTION[rule_i] === null)
        {
// javascript_action_here...
//     LHS_SV = {id : LHS_ID, child : SVs};
     LHS_SV = {id : LHS_ID, val : null, child : SVs};

        }
        else { throw Error( `Error: Internal error! Wrong rule ${rule_i} in action proc\n` ); }
    }
    ////////////////////////////////////////////////////////////////
    // END ACTION
    ////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////
// BEGIN POST
////////////////////////////////////////////////////////////////
// 
// 


///////////////////////////////////////////////////////////////



