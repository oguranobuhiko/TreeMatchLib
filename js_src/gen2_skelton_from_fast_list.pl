# 日本語



# try { } catch (err) {
#     print_last(err.message);
#     throw new Error(err.message, { cause: err });
# }
# { throw Error("ToAST_SubTreeSeq Error: Conflict child\n"); }
# { throw Error(`Lex Error! rest = '${s}'\n`); }

sub randstr
{
    my $rand_str= '';
    for (0..7){$rand_str .= sprintf('%01x',int(rand(16-0.01)));}
    $rand_str .= '_';
    for (0..7){$rand_str .= sprintf('%01x',int(rand(16-0.01)));}
    return $rand_str;
}
sub NYIErr($)
{
    my ($indent) = @_;
    $indent = '    ' if !defined $indet;
    return $indent . 'throw Error("Error: not yet implemented ('
        . randstr()  . ')!");' . "\n";
}

my $f_name = '(--null--)';
my $p_name = '(--null--)';



while(<DATA>)
{
    s/[\n\r\x0a\x0d]//g;

    if (/\A\[\s+([\w\.]+)\.p\w\s+\]\s+\=+\z/)
    {
        # [ TreeWrapperBase.pm ] ================================
        $f_name = $1;
        print "1>>($f_name)$_\n";
    }
    elsif (/\Apackage\s+([\w\:]+)\:\:\s+in\s+file/)
    {
        # package TreeWrapperBase::NodeBox::  in file 'TreeWrapperBase.pm'

        $p_name = $1; $p_name =~ s/\:\:/\./g;

        print "// ------------------------------------------------------------\n";
        print "// CLASS $p_name\n";
        print "// ------------------------------------------------------------\n";
    }
    elsif(/\AC\+\s+(\w+)\(\)\s+\-\-\>/)
    {
        # C+ NodeClass() -->
        # print " // ($1 =c )$_\n";
        print "// class method (static)\n";
        print "$p_name.$1 = function() {\n";
        print "\n";
        print NYIErr('    ');
        print "};\n";
        print "\n";
    }
    elsif(/\A\+\s+(\w+)\(\)\s+\-\-\>/)
    {
        # + NodeClass() -->
        # print " // ($1 = )$_\n";
        print "$p_name.prototype.$1 = function() {\n";
        print "\n";
        print NYIErr('    ');
        print "};\n";
        print "\n";
    }
    elsif(/\A\s*\z/)
    {
        print " // ignore this line [$_]\n";
    }
    else
    {
        die "Error: line = [$_]\n";
    }

}

###############################################################
__DATA__
[ TreeMatchLibSrc.pm ] ================================
package MatchCapturePlace::  in file 'TreeMatchLibSrc.pm'
C+ new() -->
C+ newByIterator() -->
+ Node() -->
+ Tree() -->
+ PathLength() -->
+ PathNthUpNode() -->
+ PathNthUpTree() -->
+ SetNode() -->
+ DetachNode() -->
+ RemoveNode() -->
+ SpliceNode() -->
+ InsertBefore() -->
+ InsertAfter() -->
+ PathNthUpSetNode() -->
+ PathNthUpDetachNode() -->
+ PathNthUpRemoveNode() -->
+ PathNthUpSpliceNode() -->
+ PathNthUpInsertBefore() -->
+ PathNthUpInsertAfter() -->
+ _nth_path_entry_or_die() -->
C+ aux_debug_print_capture_node_tree_str() -->
+ aux_debug_print_capture() -->
+ aux_debug_short_print() -->
package TreePatternMatchResult::  in file 'TreeMatchLibSrc.pm'
C+ new() -->
+ Capture() -->
+ MultiCapture() -->
+ GetCaptureNames() -->
+ GetMultiCaptureNames() -->
+ GetRootCapture() -->
+ Node() -->
+ Tree() -->
+ aux_debug_short_print() -->
package TreeMatchLib::  in file 'TreeMatchLibSrc.pm'
C+ TreeConstruct() -->
C+ aux_TreeConstruct_add_node() -->
C+ aux_rec_TreeConstruct() -->
C+ aux_is_valid_child_index() -->
C+ aux_nth_child_node_or_undef() -->
C+ aux_nth_child_subtree_or_undef() -->
C+ aux_attr0_child() -->
C+ TreeMatch() -->
C+ aux_TreeMatch_traverse_tree_pat() -->
C+ aux_TreeMatch_match_single_node() -->
C+ aux_TreeMatch_push_backtrack_stack() -->
C+ aux_TreeMatch_do_backtrack() -->
C+ TreeMatchFind() -->
C+ TreeIfMatchDo() -->
C+ force_import() -->
C+ import() -->
package TreeMatchLibSrc::  in file 'TreeMatchLibSrc.pm'
C+ import() -->


