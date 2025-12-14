use utf8;
use strict;
use warnings;

package TreePatternParser;
use Carp;
################################################################
# BEGIN PRE
################################################################
# pre here...

use utf8;
use strict;
use warnings;
use Encode;

# binmode STDIN,":encoding(cp932)";
# binmode STDOUT,":encoding(cp932)";

# generated from treelib -> parserGen -> aa_tree_gen


################################################################
# END PRE
################################################################

package TreePatternParser;
our @PG_TERMINAL_SYMBOLS = (
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
);
our @PG_STATE_TABLE = (
    {
        index => 0,
        next_s_r => {
            "\(?" => {"is_shift" => 1, "pri" => 0, "trans_to" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 1, "pri" => 0, "trans_to" => 2},
            "." => {"is_shift" => 1, "pri" => 0, "trans_to" => 3},
            "-" => {"is_shift" => 1, "pri" => 0, "trans_to" => 4},
            "\$" => {"is_shift" => 1, "pri" => 0, "trans_to" => 5},
            "!" => {"is_shift" => 1, "pri" => 0, "trans_to" => 6},
            "_" => {"is_shift" => 1, "pri" => 0, "trans_to" => 7},
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 8},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 9},
            "t_LABEL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 10},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "TreePattern" => {"is_shift" => 1, "pri" => 0, "trans_to" => 11},
            "NodeTerm012Joint" => {"is_shift" => 1, "pri" => 0, "trans_to" => 12},
            "NodeTerm012" => {"is_shift" => 1, "pri" => 0, "trans_to" => 13},
            "NodeTerm" => {"is_shift" => 1, "pri" => 0, "trans_to" => 14},
            "NodeFactor" => {"is_shift" => 1, "pri" => 0, "trans_to" => 15},
            "NodeBlock" => {"is_shift" => 1, "pri" => 0, "trans_to" => 16},
            "NodeFactorWithCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 17},
            "NodeFactorWithPostCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 18},
            "Node" => {"is_shift" => 1, "pri" => 0, "trans_to" => 19}
        }
    },
    {
        index => 1,
        next_s_r => {
            "-" => {"is_shift" => 1, "pri" => 0, "trans_to" => 20}
        }
    },
    {
        index => 2,
        next_s_r => {
            "\(?" => {"is_shift" => 1, "pri" => 0, "trans_to" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 1, "pri" => 0, "trans_to" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 1, "pri" => 0, "trans_to" => 3},
            "-" => {"is_shift" => 1, "pri" => 0, "trans_to" => 4},
            "\$" => {"is_shift" => 1, "pri" => 0, "trans_to" => 5},
            "!" => {"is_shift" => 1, "pri" => 0, "trans_to" => 6},
            "_" => {"is_shift" => 1, "pri" => 0, "trans_to" => 7},
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 8},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 9},
            "t_LABEL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 10},
            "NodeTerm012Joint" => {"is_shift" => 1, "pri" => 0, "trans_to" => 21},
            "NodeTerm012" => {"is_shift" => 1, "pri" => 0, "trans_to" => 13},
            "NodeTerm" => {"is_shift" => 1, "pri" => 0, "trans_to" => 14},
            "NodeFactor" => {"is_shift" => 1, "pri" => 0, "trans_to" => 15},
            "NodeBlock" => {"is_shift" => 1, "pri" => 0, "trans_to" => 16},
            "NodeFactorWithCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 17},
            "NodeFactorWithPostCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 18},
            "Node" => {"is_shift" => 1, "pri" => 0, "trans_to" => 19}
        }
    },
    {
        index => 3,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 30, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 4,
        next_s_r => {
            "." => {"is_shift" => 1, "pri" => 0, "trans_to" => 3},
            "\$" => {"is_shift" => 1, "pri" => 0, "trans_to" => 5},
            "!" => {"is_shift" => 1, "pri" => 0, "trans_to" => 6},
            "_" => {"is_shift" => 1, "pri" => 0, "trans_to" => 7},
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 8},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 9},
            "NodeFactorWithCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 22},
            "NodeFactorWithPostCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 18},
            "Node" => {"is_shift" => 1, "pri" => 0, "trans_to" => 19}
        }
    },
    {
        index => 5,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 34, "rule_no_by_nt" => 5}
        }
    },
    {
        index => 6,
        next_s_r => {
            "." => {"is_shift" => 1, "pri" => 0, "trans_to" => 3},
            "\$" => {"is_shift" => 1, "pri" => 0, "trans_to" => 5},
            "_" => {"is_shift" => 1, "pri" => 0, "trans_to" => 7},
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 8},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 9},
            "NodeFactorWithPostCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 23},
            "Node" => {"is_shift" => 1, "pri" => 0, "trans_to" => 19}
        }
    },
    {
        index => 7,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 31, "rule_no_by_nt" => 2}
        }
    },
    {
        index => 8,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 32, "rule_no_by_nt" => 3}
        }
    },
    {
        index => 9,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 33, "rule_no_by_nt" => 4}
        }
    },
    {
        index => 10,
        next_s_r => {
            "\(" => {"is_shift" => 1, "pri" => 0, "trans_to" => 24}
        }
    },
    {
        index => 11,
        next_s_r => {
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 0, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 12,
        next_s_r => {
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 1, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 13,
        next_s_r => {
            "|" => {"is_shift" => 1, "pri" => 0, "trans_to" => 25},
            ">" => {"is_shift" => 1, "pri" => 0, "trans_to" => 26},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 5, "rule_no_by_nt" => 4},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 5, "rule_no_by_nt" => 4}
        }
    },
    {
        index => 14,
        next_s_r => {
            "\(?" => {"is_shift" => 1, "pri" => 0, "trans_to" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 1, "pri" => 0, "trans_to" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 1, "pri" => 0, "trans_to" => 3},
            "-" => {"is_shift" => 1, "pri" => 0, "trans_to" => 4},
            "\$" => {"is_shift" => 1, "pri" => 0, "trans_to" => 5},
            "!" => {"is_shift" => 1, "pri" => 0, "trans_to" => 6},
            "_" => {"is_shift" => 1, "pri" => 0, "trans_to" => 7},
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 8},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 9},
            "t_LABEL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 10},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "NodeTerm012" => {"is_shift" => 1, "pri" => 0, "trans_to" => 27},
            "NodeTerm" => {"is_shift" => 1, "pri" => 0, "trans_to" => 14},
            "NodeFactor" => {"is_shift" => 1, "pri" => 0, "trans_to" => 15},
            "NodeBlock" => {"is_shift" => 1, "pri" => 0, "trans_to" => 16},
            "NodeFactorWithCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 17},
            "NodeFactorWithPostCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 18},
            "Node" => {"is_shift" => 1, "pri" => 0, "trans_to" => 19}
        }
    },
    {
        index => 15,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "*" => {"is_shift" => 1, "pri" => 0, "trans_to" => 28},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "+" => {"is_shift" => 1, "pri" => 0, "trans_to" => 29},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 8, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 16,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 15, "rule_no_by_nt" => 3}
        }
    },
    {
        index => 17,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 13, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 18,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 20, "rule_no_by_nt" => 2}
        }
    },
    {
        index => 19,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 1, "pri" => 0, "trans_to" => 30},
            "\#\#" => {"is_shift" => 1, "pri" => 0, "trans_to" => 31},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "\#" => {"is_shift" => 1, "pri" => 0, "trans_to" => 32},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "NodeCond012" => {"is_shift" => 1, "pri" => 0, "trans_to" => 33},
            "NodeCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 34}
        }
    },
    {
        index => 20,
        next_s_r => {
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 35}
        }
    },
    {
        index => 21,
        next_s_r => {
            "\)" => {"is_shift" => 1, "pri" => 0, "trans_to" => 36}
        }
    },
    {
        index => 22,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 14, "rule_no_by_nt" => 2}
        }
    },
    {
        index => 23,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 19, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 24,
        next_s_r => {
            "\(?" => {"is_shift" => 1, "pri" => 0, "trans_to" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 1, "pri" => 0, "trans_to" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 1, "pri" => 0, "trans_to" => 3},
            "-" => {"is_shift" => 1, "pri" => 0, "trans_to" => 4},
            "\$" => {"is_shift" => 1, "pri" => 0, "trans_to" => 5},
            "!" => {"is_shift" => 1, "pri" => 0, "trans_to" => 6},
            "_" => {"is_shift" => 1, "pri" => 0, "trans_to" => 7},
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 8},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 9},
            "t_LABEL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 10},
            "NodeTerm012Joint" => {"is_shift" => 1, "pri" => 0, "trans_to" => 37},
            "NodeTerm012" => {"is_shift" => 1, "pri" => 0, "trans_to" => 13},
            "NodeTerm" => {"is_shift" => 1, "pri" => 0, "trans_to" => 14},
            "NodeFactor" => {"is_shift" => 1, "pri" => 0, "trans_to" => 15},
            "NodeBlock" => {"is_shift" => 1, "pri" => 0, "trans_to" => 16},
            "NodeFactorWithCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 17},
            "NodeFactorWithPostCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 18},
            "Node" => {"is_shift" => 1, "pri" => 0, "trans_to" => 19}
        }
    },
    {
        index => 25,
        next_s_r => {
            "\(?" => {"is_shift" => 1, "pri" => 0, "trans_to" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 1, "pri" => 0, "trans_to" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 1, "pri" => 0, "trans_to" => 3},
            "-" => {"is_shift" => 1, "pri" => 0, "trans_to" => 4},
            "\$" => {"is_shift" => 1, "pri" => 0, "trans_to" => 5},
            "!" => {"is_shift" => 1, "pri" => 0, "trans_to" => 6},
            "_" => {"is_shift" => 1, "pri" => 0, "trans_to" => 7},
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 8},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 9},
            "t_LABEL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 10},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "NodeTerm012Joint" => {"is_shift" => 1, "pri" => 0, "trans_to" => 38},
            "NodeTerm012" => {"is_shift" => 1, "pri" => 0, "trans_to" => 13},
            "NodeTerm" => {"is_shift" => 1, "pri" => 0, "trans_to" => 14},
            "NodeFactor" => {"is_shift" => 1, "pri" => 0, "trans_to" => 15},
            "NodeBlock" => {"is_shift" => 1, "pri" => 0, "trans_to" => 16},
            "NodeFactorWithCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 17},
            "NodeFactorWithPostCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 18},
            "Node" => {"is_shift" => 1, "pri" => 0, "trans_to" => 19}
        }
    },
    {
        index => 26,
        next_s_r => {
            "\(?" => {"is_shift" => 1, "pri" => 0, "trans_to" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 1, "pri" => 0, "trans_to" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 1, "pri" => 0, "trans_to" => 3},
            "-" => {"is_shift" => 1, "pri" => 0, "trans_to" => 4},
            "\$" => {"is_shift" => 1, "pri" => 0, "trans_to" => 5},
            "!" => {"is_shift" => 1, "pri" => 0, "trans_to" => 6},
            "~" => {"is_shift" => 1, "pri" => 0, "trans_to" => 39},
            "_" => {"is_shift" => 1, "pri" => 0, "trans_to" => 7},
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 8},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 9},
            "t_LABEL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 10},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "NodeTerm012Joint" => {"is_shift" => 1, "pri" => 0, "trans_to" => 40},
            "NodeTerm012" => {"is_shift" => 1, "pri" => 0, "trans_to" => 13},
            "NodeTerm" => {"is_shift" => 1, "pri" => 0, "trans_to" => 14},
            "NodeFactor" => {"is_shift" => 1, "pri" => 0, "trans_to" => 15},
            "NodeBlock" => {"is_shift" => 1, "pri" => 0, "trans_to" => 16},
            "NodeFactorWithCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 17},
            "NodeFactorWithPostCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 18},
            "Node" => {"is_shift" => 1, "pri" => 0, "trans_to" => 19}
        }
    },
    {
        index => 27,
        next_s_r => {
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 6, "rule_no_by_nt" => 1},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 6, "rule_no_by_nt" => 1},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 6, "rule_no_by_nt" => 1},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 6, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 28,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "?" => {"is_shift" => 1, "pri" => 0, "trans_to" => 41},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 9, "rule_no_by_nt" => 2}
        }
    },
    {
        index => 29,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "?" => {"is_shift" => 1, "pri" => 0, "trans_to" => 42},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 11, "rule_no_by_nt" => 4}
        }
    },
    {
        index => 30,
        next_s_r => {
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 43}
        }
    },
    {
        index => 31,
        next_s_r => {
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 44}
        }
    },
    {
        index => 32,
        next_s_r => {
            "\{" => {"is_shift" => 1, "pri" => 0, "trans_to" => 45},
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 46},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 47}
        }
    },
    {
        index => 33,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 21, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 34,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 1, "pri" => 0, "trans_to" => 30},
            "\#\#" => {"is_shift" => 1, "pri" => 0, "trans_to" => 31},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "\#" => {"is_shift" => 1, "pri" => 0, "trans_to" => 32},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 23, "rule_no_by_nt" => 2},
            "NodeCond012" => {"is_shift" => 1, "pri" => 0, "trans_to" => 48},
            "NodeCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 34}
        }
    },
    {
        index => 35,
        next_s_r => {
            "\)" => {"is_shift" => 1, "pri" => 0, "trans_to" => 49}
        }
    },
    {
        index => 36,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 17, "rule_no_by_nt" => 2}
        }
    },
    {
        index => 37,
        next_s_r => {
            "\)" => {"is_shift" => 1, "pri" => 0, "trans_to" => 50}
        }
    },
    {
        index => 38,
        next_s_r => {
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 4, "rule_no_by_nt" => 3},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 4, "rule_no_by_nt" => 3}
        }
    },
    {
        index => 39,
        next_s_r => {
            "\(?" => {"is_shift" => 1, "pri" => 0, "trans_to" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 1, "pri" => 0, "trans_to" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 1, "pri" => 0, "trans_to" => 3},
            "-" => {"is_shift" => 1, "pri" => 0, "trans_to" => 4},
            "\$" => {"is_shift" => 1, "pri" => 0, "trans_to" => 5},
            "!" => {"is_shift" => 1, "pri" => 0, "trans_to" => 6},
            "_" => {"is_shift" => 1, "pri" => 0, "trans_to" => 7},
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 8},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 9},
            "t_LABEL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 10},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 7, "rule_no_by_nt" => 2},
            "NodeTerm012Joint" => {"is_shift" => 1, "pri" => 0, "trans_to" => 51},
            "NodeTerm012" => {"is_shift" => 1, "pri" => 0, "trans_to" => 13},
            "NodeTerm" => {"is_shift" => 1, "pri" => 0, "trans_to" => 14},
            "NodeFactor" => {"is_shift" => 1, "pri" => 0, "trans_to" => 15},
            "NodeBlock" => {"is_shift" => 1, "pri" => 0, "trans_to" => 16},
            "NodeFactorWithCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 17},
            "NodeFactorWithPostCond" => {"is_shift" => 1, "pri" => 0, "trans_to" => 18},
            "Node" => {"is_shift" => 1, "pri" => 0, "trans_to" => 19}
        }
    },
    {
        index => 40,
        next_s_r => {
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 2, "rule_no_by_nt" => 1},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 2, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 41,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 10, "rule_no_by_nt" => 3}
        }
    },
    {
        index => 42,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 12, "rule_no_by_nt" => 5}
        }
    },
    {
        index => 43,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 29, "rule_no_by_nt" => 6}
        }
    },
    {
        index => 44,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 28, "rule_no_by_nt" => 5}
        }
    },
    {
        index => 45,
        next_s_r => {
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 52}
        }
    },
    {
        index => 46,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 24, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 47,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 25, "rule_no_by_nt" => 2}
        }
    },
    {
        index => 48,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 22, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 49,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 18, "rule_no_by_nt" => 3}
        }
    },
    {
        index => 50,
        next_s_r => {
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 16, "rule_no_by_nt" => 1}
        }
    },
    {
        index => 51,
        next_s_r => {
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 3, "rule_no_by_nt" => 2},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 3, "rule_no_by_nt" => 2}
        }
    },
    {
        index => 52,
        next_s_r => {
            "\}" => {"is_shift" => 1, "pri" => 0, "trans_to" => 53}
        }
    },
    {
        index => 53,
        next_s_r => {
            "t_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 54},
            "t_PATTERN_LITERAL" => {"is_shift" => 1, "pri" => 0, "trans_to" => 55}
        }
    },
    {
        index => 54,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 26, "rule_no_by_nt" => 3}
        }
    },
    {
        index => 55,
        next_s_r => {
            "\#\#\@" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "\#\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "\(?" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "|" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            ">" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "\(" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "*" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "\#" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "." => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "-" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "\$" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "!" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "+" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "_" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "t_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "t_PATTERN_LITERAL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "t_LABEL" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4},
            "\(eot\)" => {"is_shift" => 0, "pri" => 0, "rule_i" => 27, "rule_no_by_nt" => 4}
        }
    }
);
our @PG_RULES = (
    { lhs => "\(ADDED_START\)", rhs => ["TreePattern"],  r_pri =>0 },
    { lhs => "TreePattern", rhs => ["NodeTerm012Joint"],  r_pri =>0 },
    { lhs => "NodeTerm012Joint", rhs => ["NodeTerm012", ">", "NodeTerm012Joint"],  r_pri =>0 },
    { lhs => "NodeTerm012Joint", rhs => ["NodeTerm012", ">", "~", "NodeTerm012Joint"],  r_pri =>0 },
    { lhs => "NodeTerm012Joint", rhs => ["NodeTerm012", "|", "NodeTerm012Joint"],  r_pri =>0 },
    { lhs => "NodeTerm012Joint", rhs => ["NodeTerm012"],  r_pri =>0 },
    { lhs => "NodeTerm012", rhs => ["NodeTerm", "NodeTerm012"],  r_pri =>0 },
    { lhs => "NodeTerm012", rhs => [],  r_pri =>0 },
    { lhs => "NodeTerm", rhs => ["NodeFactor"],  r_pri =>0 },
    { lhs => "NodeTerm", rhs => ["NodeFactor", "*"],  r_pri =>0 },
    { lhs => "NodeTerm", rhs => ["NodeFactor", "*", "?"],  r_pri =>0 },
    { lhs => "NodeTerm", rhs => ["NodeFactor", "+"],  r_pri =>0 },
    { lhs => "NodeTerm", rhs => ["NodeFactor", "+", "?"],  r_pri =>0 },
    { lhs => "NodeFactor", rhs => ["NodeFactorWithCond"],  r_pri =>0 },
    { lhs => "NodeFactor", rhs => ["-", "NodeFactorWithCond"],  r_pri =>0 },
    { lhs => "NodeFactor", rhs => ["NodeBlock"],  r_pri =>0 },
    { lhs => "NodeBlock", rhs => ["t_LABEL", "\(", "NodeTerm012Joint", "\)"],  r_pri =>0 },
    { lhs => "NodeBlock", rhs => ["\(", "NodeTerm012Joint", "\)"],  r_pri =>0 },
    { lhs => "NodeBlock", rhs => ["\(?", "-", "t_LITERAL", "\)"],  r_pri =>0 },
    { lhs => "NodeFactorWithCond", rhs => ["!", "NodeFactorWithPostCond"],  r_pri =>0 },
    { lhs => "NodeFactorWithCond", rhs => ["NodeFactorWithPostCond"],  r_pri =>0 },
    { lhs => "NodeFactorWithPostCond", rhs => ["Node", "NodeCond012"],  r_pri =>0 },
    { lhs => "NodeCond012", rhs => ["NodeCond", "NodeCond012"],  r_pri =>0 },
    { lhs => "NodeCond012", rhs => [],  r_pri =>0 },
    { lhs => "NodeCond", rhs => ["\#", "t_LITERAL"],  r_pri =>0 },
    { lhs => "NodeCond", rhs => ["\#", "t_PATTERN_LITERAL"],  r_pri =>0 },
    { lhs => "NodeCond", rhs => ["\#", "\{", "t_LITERAL", "\}", "t_LITERAL"],  r_pri =>0 },
    { lhs => "NodeCond", rhs => ["\#", "\{", "t_LITERAL", "\}", "t_PATTERN_LITERAL"],  r_pri =>0 },
    { lhs => "NodeCond", rhs => ["\#\#", "t_LITERAL"],  r_pri =>0 },
    { lhs => "NodeCond", rhs => ["\#\#\@", "t_LITERAL"],  r_pri =>0 },
    { lhs => "Node", rhs => ["."],  r_pri =>0 },
    { lhs => "Node", rhs => ["_"],  r_pri =>0 },
    { lhs => "Node", rhs => ["t_LITERAL"],  r_pri =>0 },
    { lhs => "Node", rhs => ["t_PATTERN_LITERAL"],  r_pri =>0 },
    { lhs => "Node", rhs => ["\$"],  r_pri =>0 }
);
our @PG_RULE_ACTION = (
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef,
    undef
);
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
################################################################
# BEGIN ACTION
################################################################
{
    my $rule_i = $shift_or_reduce->{rule_i};
    if (!defined $PG_RULE_ACTION[$rule_i])
    {
# perl_action_here...
#     $LHS_SV = {id => $LHS_ID, child => \@SVs};
    $LHS_SV = {id => $LHS_ID, val => undef, child => \@SVs};

    }
    else { die "Error: Internal error! Wrong rule $rule_i in action proc\n"; }
}
################################################################
# END ACTION
################################################################

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

################################################################
# BEGIN POST
################################################################
# post here...


################################################################
# END POST
################################################################
