package RefactorF4Acc::Refactoring::Blocks;
use v5.10;
use RefactorF4Acc::Config;
use RefactorF4Acc::Utils;
#use RefactorF4Acc::Refactoring::Common qw( get_annotated_sourcelines create_refactored_source splice_additional_lines_cond emit_f95_var_decl );

#
#   (c) 2010-2019 Wim Vanderbauwhede <wim@dcs.gla.ac.uk>
#

use vars qw( $VERSION );
$VERSION = "1.2.0";

#use warnings::unused;
use warnings;
use warnings FATAL => qw(uninitialized);
use strict;
use Carp;
use Data::Dumper;

use Exporter;

@RefactorF4Acc::Refactoring::Blocks::ISA = qw(Exporter);

@RefactorF4Acc::Refactoring::Blocks::EXPORT_OK = qw(
  &refactor_marked_blocks_into_subroutines
);

=pod

=begin markdown

### Factoring out code blocks into subroutines

=end markdown

=cut

# -----------------------------------------------------------------------------
sub refactor_marked_blocks_into_subroutines {
    ( my $stref ) = @_;

#   local $V=1;
    for my $f ( keys %{ $stref->{'Subroutines'} } ) {
        next if exists $stref->{'Entries'}{$f}; 
        if ( exists $stref->{'Subroutines'}{$f}{'HasBlocks'}
            and $stref->{'Subroutines'}{$f}{'HasBlocks'} == 1 ) {

            say "refactor_marked_blocks_into_subroutines(): PARSING $f" if $V;

            my $sub_or_incl_or_mod = sub_func_incl_mod( $f, $stref );
            my $is_incl = $sub_or_incl_or_mod eq 'IncludeFiles';
            my $is_external_include = $is_incl ? ( $stref->{'IncludeFiles'}{$f}{'InclType'} eq 'External' ) : 0;

            say "SRC TYPE for $f: $sub_or_incl_or_mod" if $V;
            
            if ( $sub_or_incl_or_mod ne 'ExternalSubroutines'
                and not $is_external_include ) {
                ## 5. Parse subroutine and function calls
                if ( not $is_incl ) {
                    if ( $stref->{$sub_or_incl_or_mod}{$f}{'HasBlocks'} == 1 ) {
                        $stref = _separate_blocks( $f, $stref );
                    }
                }
            } else {
                say "INFO: $f is EXTERNAL" if $I;
            }
            say "LEAVING refactor_marked_blocks_into_subroutines( $f ) with Status $stref->{$sub_or_incl_or_mod}{$f}{'Status'}" if $V;
        }
    }
    
    return $stref;
    
}    # END of refactor_marked_blocks_into_subroutines()
# -----------------------------------------------------------------------------

=pod

=begin markdown

### Factoring out code blocks into subroutines

This is some major refactoring, so should be in Refactoring::Blocks 

=end markdown

=cut

#WV20150701 This routine is very early here and it is BROKEN: common block variables don't get declarations!
sub _separate_blocks {
    ( my $f, my $stref ) = @_;

    #    local $V = 1;

    my $sub_or_func_or_mod = sub_func_incl_mod( $f, $stref );
    my $Sf                 = $stref->{$sub_or_func_or_mod}{$f};
    my $srcref             = $Sf->{'AnnLines'};

    $Data::Dumper::Indent = 2;

    # All variables in the parent subroutine
    my $varsref = get_vars_from_set( $Sf->{'Vars'} );

    # Occurence
    my $occsref  = {};
    my $itersref = {};

    # A map of every block in the parent
    # WV20170515 This BEFORE/AFTER is no good: works only for a single subroutine
    # If there are more than 1, there can be many such portions. 
    # So maybe we need an array of OUTER or something
#   my $blocksref_OLD =
#     { 
#          'OUTER' =>
#         { 'AnnLines' => [], 
#           'CalledSubs' => { 'List' => [], 'Set' => {} } 
#         },
#          'BEFORE' =>
#         { 'AnnLines' => [], 
#           'CalledSubs' => { 'List' => [], 'Set' => {} } 
#         },
#          'AFTER' =>
#         { 'AnnLines' => [], 
#           'CalledSubs' => { 'List' => [], 'Set' => {} } 
#         },
#     };
    # The records in this array are {'Name' => 'OUTER' or actual name, 'CalledSubs', 'AnnLines'
    my $blocksref = []; # Just an array 


# 1. Process every line in $f, scan for blocks marked with pragmas.
# What this does is to separate the code into blocks (%blocks) and keep track of the line numbers
# The lines with the pragmas occur both in OUTER and the block

    $blocksref  = __separate_into_blocks( $stref, $blocksref, $f );

# 2. For all non-OUTER blocks, create an entry for the new subroutine in 'Subroutines'
# Based on the content of %blocks

    $stref = __create_new_subroutine_entries( $stref, $blocksref, $f );

# 3. Identify which vars are used
#   - in both => these become function arguments
#   - only in "outer" => do nothing for those
#   - only in "inner" => can be removed from outer variable declarations
#
# Find all vars used in each block, starting with the outer block
# It is best to loop over all vars per line per block, because we can remove the encountered vars

    ( $occsref, $itersref ) = @{ __find_vars_in_block( $blocksref, $varsref, $occsref ) };

# 4. Construct the subroutine signatures
# This happens before reparsing so the data structures for the Decls and Args are emtpty! So need to call the init here!
    $stref = __construct_new_subroutine_signatures( $stref, $blocksref, $occsref, $itersref, $varsref, $f );

    $stref = __reparse_extracted_subroutines( $stref, $blocksref );

    $blocksref = __find_called_subs_in_OUTER($blocksref);

    $stref = __update_caller_datastructures( $stref, $f, $blocksref );

    return $stref;
}    # END of _separate_blocks()

# -----------------------------------------------------------------------------

sub __find_called_subs_in_OUTER {
    ( my $blocksref ) = @_;
    for my $block_rec ( @{$blocksref}) {
        my $block = $block_rec->{'Name'};
        if ($block eq 'OUTER') {
            for my $annline ( @{ $block_rec->{'AnnLines'} } ) {
                ( my $line, my $info ) = @{$annline};
                if ( exists $info->{'SubroutineCall'} ) {
                    push @{ $block_rec->{'CalledSubs'}{'List'} }, $info->{'SubroutineCall'}{'Name'};
                    $block_rec->{'CalledSubs'}{'Set'}{ $info->{'SubroutineCall'}{'Name'} } = 1;
                    # Now test if this is maybe an ENTRY -- UGH! TODO!
                }
                if ( exists $info->{'FunctionCalls'} ) {
                    for my $fcall_rec (@{ $info->{'FunctionCalls'} } ) {
                        my $fname =  $fcall_rec->{'Name'};  
                    push @{ $block_rec->{'CalledSubs'}{'List'} }, $fname ;
                    $block_rec->{'CalledSubs'}{'Set'}{ $fname  } = 1;
                    }
                }
            }
        }
    }
    
    return $blocksref;
}

# -----------------------------------------------------------------------------
sub __separate_into_blocks {
    ( my $stref, my $blocksref, my $f ) = @_;
    my $sub_or_func_or_mod = sub_func_incl_mod( $f, $stref );    # This is not a misnomer as it can also be a module.
    say "$sub_or_func_or_mod $f";
    my $Sf       = $stref->{$sub_or_func_or_mod}{$f};
    my $srcref   = $Sf->{'AnnLines'};
    my $in_block = 0;

    # Initial settings
    my $block = 'OUTER';
    my $block_rec={};
    $block_rec->{'AnnLines'}=[];
    $block_rec->{'Name'}='OUTER';
    for my $index ( 0 .. scalar( @{$srcref} ) - 1 ) {
        my $line = $srcref->[$index][0];
        my $info = $srcref->[$index][1];

        if ( exists $info->{'AccPragma'}{'BeginSubroutine'} ) { 
            # Push the line with the pragma onto the list of 'OUTER' lines
            push @{ $block_rec->{'AnnLines'} }, [ "! *** Refactored code into $block ***", {} ];
            push @{ $blocksref }, $block_rec;           
            $block_rec={};
            $in_block = 1;
            $block = $info->{'AccPragma'}{'BeginSubroutine'}[0];
            print "FOUND BLOCK $block\n" if $V;

            # Enter the name of the block in the metadata for the line
            $info->{'RefactoredSubroutineCall'}{'Name'} = $block;
            $info->{'SubroutineCall'}{'Name'}           = $block;
            delete $info->{'Comments'};
            $info->{'BeginBlock'}{'Name'} = $block;


           # Push the line with the pragma onto the list of lines for the block,
           # to be replaced by function signature
           $block_rec->{'AnnLines'}=[];
           $block_rec->{'Name'}=$block;
           push @{ $block_rec->{'AnnLines'} },
              [
                "! === Original code from $f starts here ===",
                { 'RefactoredSubroutineCall' => { 'Name' => $block } }
              ];

            $block_rec->{'BeginBlockIdx'} = $index;
            next;
        } elsif ( exists $info->{'AccPragma'}{'EndSubroutine'} ) {
            # Push 'end' onto the list of lines for the block           
            push @{ $block_rec->{'AnnLines'} },  [ '      end subroutine ' . $block, dclone($info) ];
            $block_rec->{'EndBlockIdx'} = $index;
            push @{ $blocksref }, $block_rec;
            $block_rec={};
            $in_block = 0;
            $block = $info->{'AccPragma'}{'EndSubroutine'}[0];
            $block_rec->{'Name'} = 'OUTER';
            push @{ $block_rec->{'AnnLines'} }, [ $line, {} ];
            $info->{'EndBlock'}{'Name'} = $block;           
            next;
        }
        
        if ($in_block==1) {
            # Push the line onto the list of lines for the block
            push @{ $block_rec->{'AnnLines'} }, [ $line, dclone($info) ];
            $info->{'InBlock'}{'Name'} = $block;
        } else {
            # Other lines go onto 'OUTER'
            push @{ $block_rec->{'AnnLines'} }, [ $line, $info ];           
        }
        
        $srcref->[$index] = [ $line, $info ];
    }    # loop over annlines
            $block_rec->{'EndBlockIdx'} = scalar( @{$srcref} ) ; 
            push @{ $blocksref }, $block_rec;
    
    
    return $blocksref;
}    # END of __separate_into_blocks()


# -----------------------------------------------------------------------------
sub __create_new_subroutine_entries {
    ( my $stref, my $blocksref, my $f ) = @_;

    my $sub_or_func_or_mod = sub_func_incl_mod( $f, $stref );
    my $Sf = $stref->{$sub_or_func_or_mod}{$f};

    for my $block_rec ( @{$blocksref} ) {
        
        my $block = $block_rec->{'Name'};
        #        say "\tBLOCK: $block";
        die "EMPTY block name $block" if $block eq '';
        next if $block eq 'OUTER';
        if ( not exists $stref->{'Subroutines'}{$block} ) {
            $stref->{'Subroutines'}{$block} = {};
            $stref->{'Subroutines'}{$block}{'Source'} =
              "./$block.f95";    #$Sf->{'Source'};
        }

        my $Sblock = $stref->{'Subroutines'}{$block};
        $Sblock->{'AnnLines'} = [ @{ $block_rec->{'AnnLines'} } ];    # a copy
        my $line_id = 0;
        for my $annline ( @{ $Sblock->{'AnnLines'} } ) {
            $annline->[1]{'LineID'} = $line_id++;
        }
        my $src = "./$block.f95";

        $stref->{'SourceContains'}{$src}{'Set'}{$block} = 'Subroutines';
        push @{ $stref->{'SourceContains'}{$src}{'List'} }, $block;       
        $stref->{'SourceFiles'}{$src}{'SourceType'}='Subroutines';
         $stref->{'BuildSources'}{'F'}{$src}=1;
        $Sblock->{'RefactorGlobals'} = 1;
        $stref->{'Subroutines'}{$block} = $Sblock;
        if ( $Sf->{'RefactorGlobals'} == 0 ) {
            $Sf->{'RefactorGlobals'} = 2;
        } else {
            say "INFO: RefactorGlobals==1 for $f while processing BLOCK $block" if $I;
        }

        $Sblock->{'Program'}     = 0;
        $Sblock->{'FStyle'}      = $Sf->{'FStyle'};
        $Sblock->{'FreeForm'}    = $Sf->{'FreeForm'};
        $Sblock->{'Recursive'}   = 0;
        $Sblock->{'Callers'}{$f} = [ $block_rec->{'BeginBlockIdx'} ];            

    }
    return $stref;
}    # END of __create_new_subroutine_entries()
# -----------------------------------------------------------------------------
# TODO: see if this can be separated into shorter subs
# FIXME 20170516: need includes for params in decls. Problem is, if we use COMMON blocks in the original subroutine, then there are no args so no decls.
# So I need to check if vars used in the new sub are commons
# As this belongs with _separate_blocks, I see no reason to keep declarations in $info 
sub __construct_new_subroutine_signatures {
    ( my $stref, my $blocksref, my $occsref, my $itersref, my $varsref, my $f )
      = @_;

    #    local $V = 1;
    my $sub_or_func_or_mod = sub_func_incl_mod( $f, $stref );    # This is not a misnomer as it can also be a module.
    my $Sf     = $stref->{$sub_or_func_or_mod}{$f};
    
    my $srcref = $Sf->{'AnnLines'};

    my %args = ();

    for my $block_rec ( @{$blocksref} ) {
        my $block =$block_rec->{'Name'};
        next if $block eq 'OUTER';

        my $Sblock = $stref->{'Subroutines'}{$block};

        $Sblock = _initialise_decl_var_tables( $Sblock, $stref, $block, 0 );

#       if ( not exists $Sblock->{'OrigArgs'} ) {
#           croak 'BOOM!' . Dumper( $Sblock->{Args} );
#           $Sblock->{'OrigArgs'} = { 'Set' => {}, 'List' => [] };
#       }
#       if ( not exists $Sblock->{'DeclaredOrigArgs'} ) {
#           croak 'BOOM!';
#           $Sblock->{'DeclaredOrigArgs'} = { 'Set' => {}, 'List' => [] };
#       }
#       if ( not exists $Sblock->{'LocalVars'} ) {
#           croak 'BOOM!';
#           $Sblock->{'LocalVars'} = { 'Set' => {}, 'List' => [] };
#       }
#       if ( not exists $Sblock->{'DeclaredOrigLocalVars'} ) {
#           croak 'BOOM!';
#           $Sblock->{'DeclaredOrigLocalVars'} = { 'Set' => {}, 'List' => [] };
#       }
        print "\nARGS for BLOCK $block:\n" if $V;
        $args{$block} = [];

        # Collect args for new subroutine
        # At this stage, if a var is global, it should not become an argument.
        for my $var ( sort keys %{ $occsref->{$block} } ) { ;
            if ( exists $occsref->{'OUTER'}{$var} ) {
                print "$var\n" if $V;
                # Only if this $var is not COMMON!
                if ( not exists $Sf->{'UsedParameters'}{'Set'}{$var}
                and not exists $Sf->{'DeclaredCommonVars'}{'Set'}{$var} # FIXME: UndeclaredCommonVars as well?
                and not exists $Sf->{'UndeclaredCommonVars'}{'Set'}{$var}        
                ) {
                     carp "$f: $var is NOT COMMON!";
                push @{ $args{$block} }, $var;
                } 
#               else { 
#                   carp "$f: $var is COMMON or PARAM!";
#               }
            }
            $Sblock->{'Vars'}{$var} = $varsref->{ $var }; # FIXME: this is "inheritance, but in principle a re-parse is better?"
        }
        

        # We declare them right away
        $Sblock->{'DeclaredOrigArgs'}{'List'} = $args{$block};

        # Create Signature and corresponding Decls
        my $sixspaces = ' ' x 6;
        my $sig       = $sixspaces . 'subroutine ' . $block . '(';
        my $sigrec    = {};

        $sigrec->{'Args'}{'List'} = $args{$block};
        $sigrec->{'Args'}{'Set'}  = { map { $_ => $Sblock->{'Vars'}{$_} } @{ $args{$block} } };
        
        $sigrec->{'Name'}         = $block;
        $sigrec->{'Function'}     = 0;
        for my $argv ( @{ $args{$block} } ) {
            $sig .= "$argv,";
            my $decl = get_f95_var_decl( $stref, $f, $argv );
            $decl->{'Indent'} .= $sixspaces;

            $Sblock->{'DeclaredOrigArgs'}{'Set'}{$argv} = $decl;
        }
        if ( @{ $args{$block} } ) {
            $sig =~ s/\,$/)/s;
        } else {
            $sig .= ')';
        }       

        # Add variable declarations and info to line
        # Here we know the vardecls have been formatted.
        my $sigline = shift @{ $Sblock->{'AnnLines'} }; # This is the line that says "! === Original code from $f starts here ==="

        for my $iters ( $itersref->{$block} ) {
            for my $iter ( @{$iters} ) {
                my $decl = get_f95_var_decl( $stref, $f, $iter );
                $Sblock->{'LocalVars'}{'Set'}{$iter}             = $decl;    #
                $Sblock->{'DeclaredOrigLocalVars'}{'Set'}{$iter} = $decl;
                push @{ $Sblock->{'DeclaredOrigLocalVars'}{'List'} }, $iter;

                unshift @{ $Sblock->{'AnnLines'} },
                  [
                    emit_f95_var_decl($decl),
                    {
                        'VarDecl' => {'Name' => $decl->{'Name'}},  
                        'Ann'     => ['__construct_new_subroutine_signatures '
                          . __LINE__]
                    }
                  ];
            }
        }

        for my $argv ( @{ $args{$block} } ) {
            my $decl = get_var_record_from_set( $Sblock->{'OrigArgs'}, $argv );
            if ( not defined $decl ) {
                croak;
                $decl = $Sblock->{'DeclaredOrigArgs'}{'Set'}{$argv};
            }
            
            unshift @{ $Sblock->{'AnnLines'} },
              [
                emit_f95_var_decl($decl),
                {
                    'VarDecl' => {'Name' => $decl->{'Name'}}, 
                    'Ann' => [ '__construct_new_subroutine_signatures ' . __LINE__ ]
                }
              ];
        }
        unshift @{ $Sblock->{'AnnLines'} }, $sigline;

        # Now also add include statements and the actual sig to the line

        $Sblock->{'AnnLines'}[0][1] = {};
        
        for my $inc ( keys %{ $Sf->{'Includes'} } ) { 
            $Sblock->{'Includes'}{$inc} = { 'LineID' => 2 };
            unshift @{ $Sblock->{'AnnLines'} },
              [ "      include '$inc'", { 'Include' => { 'Name' => $inc } } ];              
        }
#       unshift @{ $Sblock->{'AnnLines'} }, [ $sig, { 'Signature' => $sigrec } ];
        
        
        for my $mod ( keys %{ $Sf->{'Uses'} } ) {
            
            if (  $stref->{'Modules'}{$mod}{'Inlineable'} == 1 ) {
#               say "$block USES $mod FROM $f"; 
            $Sblock->{'Uses'}{$mod} = { 'LineID' => 2 };
            my $line = "      use $mod";
            my $info = { 'Use' => { 'Name' => $mod, 'Inlineable' => {} }  };                        
            unshift @{ $Sblock->{'AnnLines'} }, [$line , $info ];  
        }           
        }
        unshift @{ $Sblock->{'AnnLines'} }, [ $sig, { 'Signature' => $sigrec } ];       
        
# And finally, in the original source, replace the blocks by calls to the new subs

        #        print "\n-----\n".Dumper($srcref)."\n-----";
        for my $tindex ( 0 .. scalar( @{$srcref} ) - 1 ) {
            if ( $tindex == $block_rec->{'BeginBlockIdx'} ) {
                $sig =~ s/subroutine/call/;
                $srcref->[$tindex][0] = $sig;
                
                $srcref->[$tindex][1]{'SubroutineCall'} = $sigrec;
                $srcref->[$tindex][1]{'CallArgs'}=dclone($sigrec->{'Args'});
                $srcref->[$tindex][1]{'LineID'} = $Sblock->{'Callers'}{$f}[0];
                
            } elsif ( $tindex > $block_rec->{'BeginBlockIdx'}
                and $tindex <= $block_rec->{'EndBlockIdx'} ) 
            {
                $srcref->[$tindex][0] = '';
                $srcref->[$tindex][1]{'Deleted'} = 1;
            }
        }

        if ($V) {
            print 'SIG:' . $sig, "\n";

            #           print join( "\n", @{$decls} ), "\n";
        }
        $Sblock->{'Status'} = $READ;
        $stref->{'Subroutines'}{$block} = $Sblock ;
        
    }
 
    return $stref;
}    # END of __construct_new_subroutine_signatures()



# -----------------------------------------------------------------------------
sub __reparse_extracted_subroutines {
    ( my $stref, my $blocksref ) = @_;
    for my $block_rec (@{$blocksref} ) {
        my $block = $block_rec->{'Name'};
        next if $block eq 'OUTER';      
        say "REPARSING $block" if $V;
        $stref = parse_fortran_src( $block, $stref );
    }
    return $stref;
}

# -----------------------------------------------------------------------------
sub __update_caller_datastructures {
    ( my $stref, my $f, my $blocksref ) = @_;

    #   delete $blocksref->{'OUTER'};
    # Create new CalledSubs for $f
    
    my @called_subs=();
    for my $block_rec ( @{$blocksref} ) {
        my $block = $block_rec->{'Name'};
        
         if ($block eq 'OUTER' ) {
            if ( exists $block_rec->{'CalledSubs'} and exists $block_rec->{'CalledSubs'}{'List'}) {
                @called_subs = ( @called_subs, @{ $block_rec->{'CalledSubs'}{'List'} } );
            }
         } else {
            @called_subs = ( @called_subs,$block );
        }
    } # for each block
    $stref->{'Subroutines'}{$f}{'CalledSubs'}{'List'}=[@called_subs];
    $stref->{'Subroutines'}{$f}{'CalledSubs'}{'Set'} = { map { $_ => 1} @called_subs };
    $stref->{'CallTree'}{$f}=[@{$stref->{'Subroutines'}{$f}{'CalledSubs'}{'List'}}];
    return $stref;
}    # END of __update_caller_datastructures()
1;
