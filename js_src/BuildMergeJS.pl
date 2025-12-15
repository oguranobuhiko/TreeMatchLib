# vim: set et sw=4 sts=4 ai : 
# あ

use utf8;
use strict;
use warnings;
use Encode;

# binmode STDIN,":encoding(cp932)";
# binmode STDOUT,":encoding(cp932)";

# use Dumpvalue; # # Dumpvalue->new->dumpValue(...);

# skips
#     2 ParserMaker
#     docs
#     Merges
#     module Build

use Carp;

###############################################################
BEGIN
{
    # add script dir to include pathes in an encoding safe way.
    # ( to cover issue that 'use FindBin;' causes Panic in some platform
    #     at specific directory .)
    my ($script_dir, $script_dir2, $script_body); # _body has last delimiter
    {
        my $i = length($0)-1;
        for (;$i >=0; $i--)
        { my $c = substr($0, $i, 1); last if $c eq "/" or $c eq "\\"; }
        if ($i < 0) {($script_dir,$script_dir2,$script_body) = ('.', './', $0);}
        else { $script_dir = substr($0, 0, $i == 0 ? 1 : $i); $script_dir2 = substr($0, 0, $i + 1); $script_body = substr($0, $i + 1); }
    }
    unshift @INC, $script_dir;
    # unshift @INC, $script_dir2 . "lib";
}
###############################################################
# use lib '.';
#
#
# TreeLib は TreeMatchLib に置き換える
# imports で EXPORTS を

# File list:
#     MyAssertType   (exports)
#     TreeWrapperBase;   (exports)
#
#     TLLex
#     output_PathPatParser_p;
#     output_TreePatParser_p;
#     TLTreePatternAST;
#     TreeMatchLibSrc;   (exports)
# 
# useNewTreeClass Tree1 => '__A', '__B';

# use sample_UtilSubs;

my $sep_line = ('/' x 63) . "\n";


my $wr_layer = ':raw:utf8';
sub MERGE_FILES(@); sub EXPORT_SYMBOLS(@);
sub OPEN_OUTPUT_FILE($); sub CLOSE_OUTPUT_FILE();
sub OUTPUT(@);

my ($fh_o, $fh_i, $output_file_name);

my $dst_dir = '../js_deploy';
my $src_dir = '.';



my @target_files = map {
    my $a = {
        src => $_,
        proc_file => sub { while(<$fh_i>) { OUTPUT $_; } }
    }; $a; } qw { 
        TreeWrapperBase.js
        TLParser_generated.js
        TLParser_pathpat_generated.js
        TLLexParse.js
        TreeMatchLibSrc.js
    } ;

unshift @target_files, {
    src => '..\LICENSE.txt',
    proc_file => sub { while(<$fh_i>) { OUTPUT "// " . $_; } }
};

my @export_symbols = qw{
    TreeWrapperBase
    TreeWrapperBaseIterator

    TLTokenizer_aux_Tokenizer_PathAndTreePat
    -TLTokenizer_aux_TokenizerByArray
    TLTokenizerSeparated

    TLTreePatternAST

    MatchCapturePlace
    TreePatternMatchResult
    TreeMatchLib

    TreeWrapperBase.useNewTreeClass()
    TreeMatchLib.TreeConstruct()
    TreeMatchLib.TreeMatch()
    TreeMatchLib.TreeMatchFind()
    TreeMatchLib.TreeIfMatchDo()
};

OPEN_OUTPUT_FILE "TreeMatchLib.js";
MERGE_FILES(@target_files);
EXPORT_SYMBOLS 'var_only', @export_symbols;
CLOSE_OUTPUT_FILE();

OPEN_OUTPUT_FILE "TreeMatchLib.mjs";
MERGE_FILES(@target_files);
EXPORT_SYMBOLS 'mjs', @export_symbols;
CLOSE_OUTPUT_FILE();

OPEN_OUTPUT_FILE "TreeMatchLib.cjs";
MERGE_FILES(@target_files);
EXPORT_SYMBOLS 'cjs', @export_symbols;
CLOSE_OUTPUT_FILE();


###############################################################





sub MERGE_FILES(@)
{
    my (@entries) = @_;
    OUTPUT "// src =\n";
    for my $entry(@entries)
    {
        OUTPUT "//     $entry->{src}\n";
    }
    OUTPUT "// \n";
    for my $entry(@entries)
    {
        OUTPUT $sep_line;
        OUTPUT "// begin file '$entry->{src}'\n";
        OUTPUT $sep_line;

        open $fh_i, "<$wr_layer", "$src_dir/$entry->{src}"
            or confess "Error: Failed to open file'$src_dir/$entry->{src}' (f1a50234_a8b9b79a)\n";
        $entry->{proc_file}->();
    
        close $fh_i;

        OUTPUT "\n";
        OUTPUT $sep_line;
        OUTPUT "// end of file '$entry->{src}'\n";
        OUTPUT $sep_line;
        OUTPUT "\n";
    }
}
sub EXPORT_SYMBOLS(@)
{
    my $mode = shift @_;
    my @src_symbols = grep {! /^\s*\-/} @_;
    my @to_top = grep {/^[\w\.]+\.\w+(|\(\)|new\(\))$/} @src_symbols;
    my @export_symbols= map {
        my $ret;
        if (/^\w+$/) { $ret = $_; }
        elsif (/^[\w\.]+\.(\w+)(|\(\)|new\(\))$/) { $ret = $1; }
        else{ die "Error: Wrong export entry '$_'! (1)\n" }
        $ret;
    } @src_symbols;

    OUTPUT $sep_line;
    OUTPUT "// [begin Exports]\n";
    OUTPUT $sep_line;
    OUTPUT "// \n";
    OUTPUT "\n";
    for my $entry (@to_top)
    {
        $entry =~ /^([\w\.]+)\.(\w+)(|\(\)|new\(\))$/
            || die "Error: Wrong export entry '$entry'! (2)\n";

        if ($3 eq '')
        { OUTPUT "var $2 = $entry ;\n"; }
        elsif ($3 eq '()')
        {
            OUTPUT "var $2 = function(... args) {\n";
            OUTPUT "    return $1.$2.apply($1, args);\n";
            OUTPUT "};\n";

        }
        elsif ($3 eq 'new()')
        {
            OUTPUT "var $2 = function(... args) {\n";
            OUTPUT "    $1.$2.apply(this, args);\n";
            OUTPUT "};\n";
        }
    }
    OUTPUT "\n";

    if ($mode eq 'var_only') {  }
    elsif ($mode eq 'mjs')
    { OUTPUT "export {\n    " . join(",\n    ", @export_symbols) . "\n};\n"; }
    elsif ($mode eq 'cjs')
    { OUTPUT join ('', map {"exports.$_ = $_ ;\n" } @export_symbols); }
    else
    { die "Error: Wrong export mode '$mode'!\n"; }

    OUTPUT $sep_line;
    OUTPUT "// end exports\n";
    OUTPUT $sep_line;
}
sub OPEN_OUTPUT_FILE($)
{
    ($output_file_name) = @_;

    print "begin file '$dst_dir/$output_file_name' ... ";

    open $fh_o, ">$wr_layer", "$dst_dir/$output_file_name"
        or confess "Error: Failed to open file'$dst_dir/$output_file_name' (505c56a1_78897d66)\n";

    OUTPUT $sep_line;
    OUTPUT "// Generated by BuildMergePMs.pl\n";
    OUTPUT "// [begin file '$dst_dir/$output_file_name']\n";
    OUTPUT $sep_line;
    OUTPUT "// \n";

}
sub CLOSE_OUTPUT_FILE()
{
    OUTPUT "\n";
    OUTPUT $sep_line;
    OUTPUT "1;\n";
    OUTPUT "// (eof)\n";


    print "done. ('$dst_dir/$output_file_name' completed.)\n";
    close $fh_o;
}
sub OUTPUT(@)
{
    print $fh_o @_;
}


#     proc_file => sub {
#         my $remove_until = 0;
#         while(<$fh_i>) {
#             if ($remove_until)
#             {
#                 if($remove_until->()) { $remove_until = 0; next; }
#                 OUTPUT "# REMOVE # $_";
#                 next;
#             }
# 
#             if (/^\s* package \s+ ( TreeMatchLibSrc)\;\s*$/x )
#             {
#                 OUTPUT "# REMOVE # $_"; 
#                 $remove_until = sub {/^\# end of package\b/};
#                 next;
#             }
# 
#             if (/^\s* use \s+ (
#                 TLLex
#                 | output_TreePatParser_p
#                 | output_PathPatParser_p
#                 | TLTreePatternAST
#                 )\;\s*$/x )
#             { OUTPUT "# REMOVE # $_"; next; }
# 
#             OUTPUT $_;
#         }
#     }


# Exports 
#
# # constructor: ###
# var TreeConstruct = function(... args) {
#     TreeMatchLib.TreeConstruct.apply(this, args);
# };
#
# static member function
# var TreeConstruct = function(... args) {
#     return TreeMatchLib.TreeConstruct.apply(TreeMatchLib, args);
# };
# 



exit;

###############################################################
#
