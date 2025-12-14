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
[ TreeWrapperBase.pm ] ================================
package TreeWrapperBase::NodeBox::  in file 'TreeWrapperBase.pm'
C+ NodeClass() -->
C+ BoxClass() -->
C+ TreeClass() -->
C+ newByNode() -->
+ GetNode() -->
+ SetNode() -->
package TreeWrapperBase::Node::  in file 'TreeWrapperBase.pm'
C+ NodeClass() -->
C+ BoxClass() -->
C+ TreeClass() -->
+ GetPrimaryAttributeKey0() -->
+ GetPrimaryAttributeKey1() -->
+ IsPrimaryAttributeKey() -->
C+ new() -->
+ GetAttribute() -->
+ SetAttribute() -->
+ HasAttribute() -->
+ DeleteAttribute() -->
+ AttributeKeys() -->
+ AttributeKeysNonPrimary() -->
+ GetPrimaryAttribute0() -->
+ SetPrimaryAttribute0() -->
+ Attr0() -->
+ GetPrimaryAttribute1() -->
+ SetPrimaryAttribute1() -->
+ Attr1() -->
+ NumChildren() -->
+ ChildrenKeys() -->
+ NthChildNode() -->
+ NthChildBox() -->
+ NthChildSubtree() -->
+ ChildNodeList() -->
+ ChildSubtreeList() -->
+ ForEachChildNodes() -->
+ ForEachChildSubtrees() -->
+ SpliceChildrenNodes() -->
+ PrependChildNodes() -->
+ AppendChildNodes() -->
+ NodeSummary() -->
package TreeWrapperBase::  in file 'TreeWrapperBase.pm'
C+ NodeClass() -->
C+ BoxClass() -->
C+ TreeClass() -->
C+ newByRootNode() -->
C+ newByBox() -->
+ GetRootNodeBox() -->
+ GetRootNode() -->
+ SetRootNode() -->
C+ newImportByFuncs() -->
+ ExportByFuncs() -->
+ TreePrint() -->
+ TraverseEnterExit() -->
C+ useNewTreeClass() -->
C+ newImportFromFlatHashTree() -->
+ ExportToFlatHashTree() -->
C+ newImportFromAttrhashChildTree() -->
+ ExportToAttrhashChildTree() -->
package TreeWrapperBaseIterator::  in file 'TreeWrapperBase.pm'
C+ new() -->
+ _top() -->
+ _parent_frame() -->
+ IsRoot() -->
+ IsEnd() -->
+ IsFirst() -->
+ IsLast() -->
+ Tree() -->
+ Node() -->
+ UpTree() -->
+ UpNode() -->
+ MoveNextSibling() -->
+ MoveDown() -->
+ MoveDownForce() -->
+ MoveUp() -->
+ Duplicate() -->
+ aux_debug_print_iter_stack_tree_str() -->
+ aux_debug_print_iter_stack() -->
+ aux_debug_short_print() -->

