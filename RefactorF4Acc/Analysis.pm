package RefactorF4Acc::Analysis;
use v5.10;
use RefactorF4Acc::Config;
use RefactorF4Acc::Utils;
use RefactorF4Acc::Analysis::Includes qw( find_root_for_includes lift_param_includes);
use RefactorF4Acc::Analysis::Variables qw( analyse_variables );
use RefactorF4Acc::Analysis::Arguments qw( 
	determine_ExGlobArgs 
	find_argument_declarations 
	resolve_conflicts_with_params 
	create_RefactoredArgs
	create_RefactoredArgs_for_ENTRY
	map_call_args_to_sig_args
	identify_external_proc_args
	analyse_var_decls_for_params
	);
use RefactorF4Acc::Analysis::Globals qw( identify_inherited_exglobs_to_rename lift_globals rename_inherited_exglobs );
#use RefactorF4Acc::Analysis::LoopDetect qw( outer_loop_end_detect );
use RefactorF4Acc::Refactoring::Common qw( get_f95_var_decl stateless_pass );
use RefactorF4Acc::Refactoring::BlockData qw( add_BLOCK_DATA_call_after_last_VarDecl );
use RefactorF4Acc::Refactoring::Functions qw(add_function_var_decls_from_calls );
# WORK IN PROGRESS
use RefactorF4Acc::Analysis::CommonBlocks qw( identify_common_var_mismatch create_common_var_size_tuples match_up_common_vars );

#
#   (c) 2010-2017 Wim Vanderbauwhede <wim@dcs.gla.ac.uk>
#

use vars qw( $VERSION );
$VERSION = "1.2.0";

#use warnings::unused;
use warnings;
use warnings FATAL => qw(uninitialized);
use strict;
use Carp;
use Data::Dumper;
use Storable qw( dclone );

use Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(
  analyse_all
  identify_vars_on_line
);

sub analyse_all {

	( my $stref, my $code_unit_name, my $stage, my $is_source_file_path  ) = @_;
	my $sub_or_func_or_mod = sub_func_incl_mod( $code_unit_name, $stref );
			
	if ($sub_or_func_or_mod eq 'Modules' and $is_source_file_path) {
	   $code_unit_name = get_module_name_from_source($stref,$code_unit_name);
	}
	if (not defined $stage) {$stage=0}
	
	my $annlines =	add_BLOCK_DATA_call_after_last_VarDecl($code_unit_name,$stref); 
	
	if ($sub_or_func_or_mod eq 'Subroutines') {
		# Find the 'root', i.e. the outermost calling subroutine, for each include file
		print "\t** FIND ROOT FOR INCLUDES **\n" if $V;
		$stref = find_root_for_includes( $stref, $code_unit_name );
	}
	return $stref if $stage == 1;

	# Insert BLOCK DATA calls in the main program
	# if (exists $Sf->{'Program'} and $Sf->{'Program'} == 1)
	# Find the last declaration. Just use a statefull pass or even a conditional splice.
	# Problem is of course comments. The condition is "line is a Decl and next line that is not a comment is not a decl
	# Also, if it's a COMMON or DIMENSION it is effectively a decl

	# In this stage, 'ExGlobArgs' is populated from CommonVars by looking at the common blocks that occur in the call chain
	# Note that this does not cover common blocks in includes so hopefully ExGlobArgs will not be affected for the case with includes.
	if ($sub_or_func_or_mod eq 'Subroutines') {
		determine_ExGlobArgs($code_unit_name, $stref);
	}
	# First find any additional argument declarations, either in includes or via implicits
	for my $f ( keys %{ $stref->{'Subroutines'} } ) {
		next if $f eq '';
		if (exists $stref->{'Entries'}{$f}) {
			next;
		}
		
		# Includes
		$stref = lift_param_includes( $stref, $f );
		# ExImplicitArgs, ExInclArgs
		$stref = find_argument_declarations( $stref, $f );
	}	
	return $stref if $stage == 2;

	for my $f ( keys %{ $stref->{'Subroutines'} } ) {
		next if $f eq '';	
		if (exists $stref->{'Entries'}{$f}) {
			next;
		}
		$stref = analyse_variables( $stref, $f );
	}
    for my $f ( keys %{ $stref->{'Subroutines'} } ) {
        next if $f eq '';   
        if (exists $stref->{'Entries'}{$f}) {
            next;
        }	
	    $stref = add_function_var_decls_from_calls( $stref, $f );
    }
	return $stref if $stage == 3;


# ConflictingGlobals: ex-common vars conflicting with params, both from include files
	for my $f ( keys %{ $stref->{'Subroutines'} } ) {
		next if $f eq '';
		if (exists $stref->{'Entries'}{$f}) {
			next;
		}
		
		$stref = resolve_conflicts_with_params( $stref, $f );
	}
	return $stref if $stage == 4;
	
	# The next three routines work on ExGlobArgs and RenamedInheritedExGLobs
	if ($sub_or_func_or_mod eq 'Subroutines') {
	$stref = identify_inherited_exglobs_to_rename( $stref, $code_unit_name );
	# Although this seems duplication, it is actually required!	
	$stref = lift_globals( $stref, $code_unit_name );	
	$stref = rename_inherited_exglobs( $stref, $code_unit_name );
	}
	return $stref if $stage == 5;

	for my $f ( keys %{ $stref->{'Subroutines'} } ) { 
		next if $f eq '';
		if (exists $stref->{'Entries'}{$f}) {
			next;
		}
		# RefactoredArgs = OrigArgs ++ ExGlobArgs and at this point any necessary renaming has been done
		# This sets HasRefactoredArgs = 1
		$stref = create_RefactoredArgs( $stref, $f );
		if (exists $stref->{'Subroutines'}{$f}{'HasEntries'} ) {
			$stref = create_RefactoredArgs_for_ENTRY( $stref, $f );
		}
	}
	return $stref if $stage == 6;

	for my $f ( keys %{ $stref->{'Subroutines'} } ) {    # Functions are just special subroutines
		next if $f eq '';		
		if (exists $stref->{'Entries'}{$f}) {
			next;
		}
		$stref = map_call_args_to_sig_args( $stref, $f );
	}
	return $stref if $stage == 7;

	for my $f ( keys %{ $stref->{'Subroutines'} } ) { # Functions are just special subroutines
		next if $f eq '';
		next if not exists $stref->{'Subroutines'}{$f}{'Callers'}; 
		
		if (exists $stref->{'Entries'}{$f}) {
			next;
		}
        
		$stref = identify_external_proc_args( $stref, $f );
	}
	return $stref if $stage == 8;

#	# This is only for refactoring init out of time loops so very domain specific
#	for my $kernel_wrapper ( keys %{ $stref->{'KernelWrappers'} } ) {
#		$stref = outer_loop_end_detect( $kernel_wrapper, $stref );
#	}

	# So at this point all globals have been resolved and typed.

	for my $f ( keys %{ $stref->{'Subroutines'} } ) {
		next if $f eq '';
		if (exists $stref->{'Entries'}{$f}) {
			next;
		}		
		$stref = analyse_var_decls_for_params( $stref, $f );
	}	
# ================================================================================================================================	
	for my $f ( keys %{ $stref->{'Subroutines'} } ) {
		next if $f eq '';			
		next  if $f eq 'UNKNOWN_SRC';
		next unless exists $stref->{'Subroutines'}{$f}{'HasLocalCommons'};

#	 say "\nCOMMON BLOCK VARS in $f:\n";
#    say Dumper($stref->{'Subroutines'}{$f}{'CommonBlocks'});
#	die if $f eq 'fm302';
		next if  exists $stref->{'Subroutines'}{$f}{'Program'} and $stref->{'Subroutines'}{$f}{'Program'}==1;
		
#	 say "\nCOMMON BLOCK MISMATCHES in $f:\n";
#    say Dumper($stref->{'Subroutines'}{$f}{'CommonBlocks'});
    $stref = identify_common_var_mismatch($stref,$f);
#    say Dumper($stref->{'Subroutines'}{$f}{'CommonVarMismatch'});
	}
	
	for my $f ( keys %{ $stref->{'Subroutines'} } ) {
		next if $f eq '';			
		next  if $f eq 'UNKNOWN_SRC';
		next unless exists $stref->{'Subroutines'}{$f}{'HasLocalCommons'};
		create_common_var_size_tuples( $stref, $f );
	}
	for my $f ( keys %{ $stref->{'Subroutines'} } ) {		
		next if $f eq '';			
		next  if $f eq 'UNKNOWN_SRC';
		next unless exists $stref->{'Subroutines'}{$f}{'HasLocalCommons'};
		match_up_common_vars( $stref, $f );
		next unless exists $stref->{'Subroutines'}{$f}{'HasCommonVarMismatch'};
		$stref = create_RefactoredArgs( $stref, $f );
	}
	
	
	return $stref;
}    # END of analyse_all()

1;
