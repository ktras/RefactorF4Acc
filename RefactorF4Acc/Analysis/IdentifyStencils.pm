package RefactorF4Acc::Analysis::IdentifyStencils;
use v5.10;
use RefactorF4Acc::Config;
use RefactorF4Acc::Utils;
use RefactorF4Acc::Refactoring::Common qw(
	pass_wrapper_subs_in_module
	stateful_pass
	stateful_pass_reverse
	stateless_pass
	emit_f95_var_decl
	splice_additional_lines_cond
	);
use RefactorF4Acc::Refactoring::Subroutines qw( emit_subroutine_sig );
use RefactorF4Acc::Analysis::ArgumentIODirs qw( determine_argument_io_direction_rec );
use RefactorF4Acc::Parser::Expressions qw(
	parse_expression
	emit_expression
	get_vars_from_expression	
	);

#
#   (c) 2016 Wim Vanderbauwhede <wim@dcs.gla.ac.uk>
#

use vars qw( $VERSION );
$VERSION = "1.1.0";

#use warnings::unused;
use warnings;
use warnings FATAL => qw(uninitialized);
use strict;

use Storable qw( dclone );

use Carp;
use Data::Dumper;
use Storable qw( dclone );

use Exporter;

@RefactorF4Acc::Analysis::IdentifyStencils::ISA = qw(Exporter);

@RefactorF4Acc::Analysis::IdentifyStencils::EXPORT_OK = qw(
&pass_identify_stencils
&identify_array_accesses_in_exprs
&eval_expression_with_parameters
);


=info20170903
What we have now is for every array used in a subroutine, a set of all stencils with an indication if an access is constant or an offset from a given iterator.
The syntax is

$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Accesses'}{ join(':', @ast_vals0) }
{$iters[$idx] => [$mult_val,$offset_val]};

 '0:-1' => [
    {
      'j' => [
        1,
        0
      ]
    },
    {
      'k' => [
        1,
        -1
      ]
    }
  ],


Now we have two use cases, one is OpenCL pipes and the other is TyTraCL
For the stencils where all accesses use an iterator we have

vs = stencil patt v
v' = map f vs

There are two other main use cases

1/ LHS and RHS are both partial, i.e. one or more index is constant.
We can check this by comparing the Read and Write arrays. For TyTraCL I think we want to generate code that will apply the map to the accessed ranges and keep the old values for the rest.
But I think this still means we have to buffer: if e.g. we have

v(0)=v(10)
v(1) .. v(8) unchanged
v(9)=v(1)
v(10) unchanged

then we need to construct a stream which reorders, so we'll have to buffer the stream until in this example we reach 10. That is not hard.
 Furthermore, we need to write the partial ranges out to this stream in order of access.
 As the stream is characterised by offsets, ranges and constants, this should be possible, but it is not trivial!

 For example

              u(ip,j,k) = u(ip,j,k)-dt*uout *(u(ip,j,k)-u(ip-1,j,k))/dxs(ip)
              v(ip+1,j,k) = v(ip+1,j,k)-dt*uout *(v(ip+1,j,k)-v(ip,j,k))/dxs(ip)
              w(ip+1,j,k) = w(ip+1,j,k)-dt*uout *(w(ip+1,j,k)-w(ip,j,k))/dxs(ip)

so we have
u
Write: [?,j,k] => [ip,0,0]
Read: [?,j,k] => [ip,0,0],[ip-1,0,0]

and
i: 0 :(ip + 1)
j: -1:(jp + 1)
k: 0 :(kp + 1)

So
if (i==ip) then
	! apply the old code, but a stream - scalar value of it
	u(ip,j,k) = u(ip,j,k)-dt*uout *(u(ip,j,k)-u(ip-1,j,k))/dxs(ip)
else
	! keep the old value
	u(i,j,k) = u(i,j,k)
end if

So I guess what we do is, we create a tuple:

u_ip_j_k, u_ipm1_j_k, u_i_j_k

To do so, we need to identify the buffer, i.e. points within the range
i: ip, ip-1 => this is a 2-point stencil
j: -1:(jp + 1)
k: 0 :(kp + 1)

Actually, by far the easiest solution would be to create this buffer and access it in non-streaming fashion.
The key problem however is that the rest of the stream can't be buffered in the meanwhile.

2/ LHS is full and RHS is partial, i.e. one or more index is constant on RHS. This means we need to replicate the accesses. But in fact, random access as in case 1/ is probably best.

In both cases, we need to express this someway in TyTraCL, and I think I will use `select` and `replicate` to do this.

The unsolved question here is: if I do a "select"  I get a smaller 1-D list. So in case 1/ I apply this list to a part of the original list, but the question is: which part?
To give a simple example on a 4x4 array I select a column
[0,4,8,12] and I want to apply this to either to the bottom row [12,13,14,15] or the 2nd col [1,5,9,13] of the original list.
We could do this via an operation `insert`

	insert target_pattern small_list target_list

Question is then where we get the target pattern, but I guess a start/stop/step should do:

for i in [0 .. 3]
	v1[i+12] = v_small[i]
	v2[i*4+1] = v_small[i]
end

This means for the select we had the opposite:

for i in [0 .. 3]
	v_small[i] = v[i*4+0]
end


So the question is, how do we express this using `select` ?


for i in 0 .. im-1
	for j in 0 .. jm-1
		for k in 0 .. km-1
			v(i,j,k) = v(a_i*i+b_i, a_j*j_const+b_j,k)

Well, it is very easy:

-- selection can work like this
select patt v = map (\idx -> v !! idx) patt

v' = select [ i*jm*km+j*km+k_const | i <- [0 .. im-1],  j <- [0 .. jm-1], k <- [0..km-1] ] v

Key questions of course are (1) if we can parallelise this, and (2) what the generated code looks like.
(1) Translates to: given v :: Vec n a -> v" :: Vec m Vec n/m a
Then what is the definition for select" such that

v"' = select" patt v"

Is this possible in general? It *should* be possible, because what it means is that we only access the data present in each chunk.
The problem is that the index pattern is not localised, for example

v_rhs1 = select [ i*jm*km+j*km+k_const | i <- [0 .. im-1],  j <- [0 .. jm-1], k <- [0..km-1] ] v
v_rhs2 = select [ i*jm*km+j_const*km+k | i <- [0 .. im-1],  j <- [0 .. jm-1], k <- [0..km-1] ] v
v_rhs3 = select [ i_const*jm*km+j*km+k | i <- [0 .. im-1],  j <- [0 .. jm-1], k <- [0..km-1] ] v

So I guess we need to consider (2), how to generate the most efficient buffer for this.

The most important question to answer is: when is it a stencil, when a select, when both?

#* It is a stencil if:
#- there is more than one access to an array =>
#- at least one of these accesses has a non-zero offset
#- all points in the array are processed in order
* It is a select if:
- not all points in the array are covered, let's say this means we have a '?'
(this ignores the fact that the bounds might not cover the array!)

So if we have a combination, then we can do either
- create a stencil, then select from it
- create multiple select expressions

Crucially, a stencil is only really a stencil if the LHS and the RHS parts have the same number of points. I'm not sure if this really matters.

In any case, what we want to know is:
- is straight scalarisation OK for a given variable in a given subroutine
- which variables should become local arrays
- which variables need stencils
- which variables need select.


=cut


=info
Pass to determine stencils in map/reduce subroutines
Because of their nature we don't even need to analyse loops: the loop variables and bounds have already been determined.
So, for every line we check:
If it is an assignment, a subroutine call or a condition in and If or Case, we go on
But in the kernels we don't have subroutines at the moment. We also don't have Case I think
If assignment, we separate LHS and RHS
If subcall, we separate In/Out/InOut
If cond, it is a read expression

In each of these we get the AST and hunt for arrays. This is easy but would be easier if we had an 'everywhere' or 'everything' function

We have `get_args_vars_from_expression` and `get_vars_from_expression` and we can grep these for arrays

=cut

sub pass_identify_stencils {(my $stref)=@_;
    # WV: I think Selects and Inserts should be in Lines but I'm not sure    
	$stref->{'TyTraCL_AST'} = {'Lines' => [], 'Selects' => [], 'Inserts' => []};
	$stref = pass_wrapper_subs_in_module($stref,
			[
#				[ sub { (my $stref, my $f)=@_;  alias_ordered_set($stref,$f,'DeclaredOrigArgs','DeclaredOrigArgs'); } ],
		  		[
			  		\&identify_array_accesses_in_exprs,			  		
				],
			]
		);

	return $stref;
} # END of pass_identify_stencils()


# This was only meant to work for the OpenCL Fortran kernels emitted by this compiler, but should now work for other subroutines as well.

# Array accesses are stored in
# $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{
# 'Exprs' => { $expr_str_1 => 1,...},
# 'Accesses' => { '0:1' =>  'j' => [1,0],'k' => [1,1]},
# 'Iterators' => ['i','j']
# };
#
# Array dimensions are stored in
# 	$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{'Dims'} = [[0,501],[1,500],...]
#
sub identify_array_accesses_in_exprs { (my $stref, my $f) = @_;
	print "\nIN SUB $f, SRC <"; print $stref->{'Subroutines'}{$f}{'Source'}; say ">";
    #	die $f.' : '.Dumper($stref->{'Subroutines'}{$f}{Source});
#    if ($stref->{'Subroutines'}{$f}{'Source'}=~/(?:dyn.f95|module_\w+_superkernel.f95)/ && $f!~/superkernel/)   
    if ($f!~/superkernel/) {  # TODO 
#croak 'DYN';
        # For TyTraCL 
        push @{ $stref->{'TyTraCL_AST'}{'Lines'} }, {'NodeType' => 'Comment', 'CommentStr' => $f };        

		my $pass_identify_array_accesses_in_exprs = sub { (my $annline, my $state)=@_;
			(my $line,my $info)=@{$annline};

            my $in_block = exists $info->{Block} ? $info->{Block}{LineID} : '-1';
            my $block_id = __mkLoopId( $state->{'Subroutines'}{$f}{'LoopNests'} );
#			say 'BLOCK '.$info->{LineID}."\t$block_id\t\'$line\'";# => ;#.' '.$info->{Block}{LineID} ;#if ($info->{LineID} == 0);# or $info->{Block}{LineID} == 0);
            #my $block_id = 0;#$info->{'Block'}{'LineID'};
            #
			# Identify the subroutine
			if ( exists $info->{'Signature'} ) {
				my $subname =$info->{'Signature'}{'Name'} ;
				$state->{'CurrentSub'}= $subname  ;
				croak if $subname ne $f;
				$state->{'Subroutines'}{$subname }={};
				$state->{'Subroutines'}{$subname }{$block_id}={};
                $state->{'Subroutines'}{$f}{'LoopNests'}=[ [0,{}] ];
                # InOut will be both in In and Out
                # Any scalar arg that is InOut or Out could be an Acc, put it in MaybeAcc
                $state->{'Subroutines'}{$f}{'Args'}={
                	'In'=>[],'Out' =>[], 'MaybeAcc'=>[],'Acc'=>[]                	                	
                };
                
                for my $arg ( @{ $info->{'Signature'}{'Args'}{'List'} } ) {
                	my $arg_decl = get_var_record_from_set($stref->{'Subroutines'}{$f}{'Args'},$arg);		
					my $intent =$arg_decl->{'IODir'};       
					my $is_scalar = $arg_decl->{'ArrayOrScalar'} eq 'Array' ? 0 : 1;
					if ($is_scalar and $intent eq 'out' or $intent eq 'inout') {
						push @{ $state->{'Subroutines'}{$f}{'Args'}{'MaybeAcc'} }, $arg;
					}
					if ($intent ne 'out') {
						push @{ $state->{'Subroutines'}{$f}{'Args'}{'In'} }, $arg;
					}
					if ($intent ne 'in') {
						push @{ $state->{'Subroutines'}{$f}{'Args'}{'Out'} }, $arg;
					}         
						                	
                }
			}
			# For every VarDecl, identify dimension if it is an array
			if (exists $info->{'VarDecl'} and not exists $info->{'ParamDecl'} and __is_array_decl($info)) {

				my $array_var=$info->{'VarDecl'}{'Name'};
				 
				my @dims = @{ $info->{'ParsedVarDecl'}{'Attributes'}{'Dim'} };

				$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{'Dims'}=[];
				for my $dim (@dims) {
					(my $lo, my $hi)=$dim=~/:/ ? split(/:/,$dim) : (1,$dim);
					my $dim_vals=[];
					for my $bound_expr_str ($lo,$hi) {
						my $dim_val=$bound_expr_str;
						if ($bound_expr_str=~/\W/) {
                            $dim_val=_eval_expression_w_params($bound_expr_str,$info, $stref,$f,$block_id,$state);
						} else {
							# It is either a number or a var
							if (in_nested_set($stref->{'Subroutines'}{$f},'Parameters',$bound_expr_str)) {
                                # Means it's a parameter
				  				my $decl = get_var_record_from_set( $stref->{'Subroutines'}{$f}{'Parameters'},$bound_expr_str);
                                $dim_val = $decl->{'Val'};
							} # otherwise it's a number and we fall through
						}
						push @{$dim_vals},$dim_val;
					}
                    # This is also used to generate the 1-D stencils for TyTraCL
					push @{ $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{'Dims'} },$dim_vals;					
				}
#				say "{ $f }{ $block_id }{'Arrays'}{$array_var}{'Dims'}";
#				say Dumper($state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{'Dims'});
			}
			if (exists $info->{'Assignment'} ) {
				# Assignment to scalar *_rel
				if ($info->{'Lhs'}{'ArrayOrScalar'} eq 'Scalar' and $info->{'Lhs'}{'VarName'} =~/^(\w+)_rel/) {
					my $loop_iter=$1;
					if (not exists $state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'}{$loop_iter}{'Range'}) {
						croak "This should not happen!";
						$state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'}{$loop_iter}={'Range' => [0,0]};
					}
				}
				# Assignment to scalar *_range
				elsif ($info->{'Lhs'}{'ArrayOrScalar'} eq 'Scalar' and $info->{'Lhs'}{'VarName'} =~/^(\w+)_range/) {
					my $loop_iter=$1;

					my $expr_str = emit_expression($info->{'Rhs'}{'ExpressionAST'},'');
					my $loop_range = eval($expr_str);
					$state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'}{$loop_iter}={'Range' => [1,$loop_range]};
				} elsif ($info->{'Lhs'}{'ArrayOrScalar'} eq 'Scalar' ) { 		
					# Test if a scalar arg is an accumulator for a fold
					# If the arg occurs on LHS and RHS of an assignment and the RHS has an array arg as well			
					my %maybe_accs = map {$_ => 1} @{$state->{'Subroutines'}{$f}{'Args'}{'MaybeAcc'}};
					my %in_arrays  = map {$_ => 1} @{$state->{'Subroutines'}{$f}{'Args'}{'In'}};
					my $acc_var = $info->{'Lhs'}{'VarName'} ;
#					croak $f . ' ' .$acc_var . Dumper($state->{'Subroutines'}{$f}{'Args'}{'MaybeAcc'}) if $acc_var=~/acc/ and $f=~/reduce/;
					if (exists $maybe_accs{$acc_var}) { 
						
						my $vars = get_vars_from_expression($info->{'Rhs'}{'ExpressionAST'});
						if (exists $vars->{$acc_var}) {
							for my $tvar (sort keys %{$vars}) {
								if ($vars->{$tvar}{'Type'} eq 'Array'
								and exists $in_arrays{$tvar}
								) {
#									die "DETERMINED ACC $acc_var  in $f"; ;
									push @{$state->{'Subroutines'}{$f}{'Args'}{'Acc'}}, $acc_var;
									last;
#							die Dumper($vars) if $info->{'Lhs'}{'VarName'} eq 'acc';
								}
							}
						}
					}
					
				} else {
					# This tests for the case of the same array on LHS and RHS, but maybe with a different access location, so a(...) = a(...)
                    # Not sure why as this is rather unusual and it is unused
					if (
						ref($info->{'Rhs'}{'ExpressionAST'}) eq 'ARRAY'
					and (($info->{'Rhs'}{'ExpressionAST'}[0] & 0xF) == 10) #eq '@'
					and ref($info->{'Lhs'}{'ExpressionAST'}) eq 'ARRAY'
					and (($info->{'Lhs'}{'ExpressionAST'}[0] & 0xF) == 10) #eq '@'
					and $info->{'Lhs'}{'ExpressionAST'}[1] eq $info->{'Rhs'}{'ExpressionAST'}[1]
					) {
						my $var_name = $info->{'Rhs'}{'ExpressionAST'}[1];
						say "IDENTITY OP for $var_name : ",$line;
						$state->{'Subroutines'}{ $f }{$block_id}{'Identity'}{$var_name} = 1;
					}

					
					# Find all array accesses in the LHS and RHS AST.
					
					(my $lhs_ast, $state, my $lhs_accesses) = _find_array_access_in_ast($stref, $f, $block_id, $state, $info->{'Lhs'}{'ExpressionAST'},'Write',{});
					(my $rhs_ast, $state, my $rhs_accesses) = _find_array_access_in_ast($stref, $f, $block_id, $state, $info->{'Rhs'}{'ExpressionAST'},'Read',{});
					if (exists $lhs_accesses->{'Arrays'} or exists $rhs_accesses->{'Arrays'} ) {
						# This is a line with array accesses. Check the halos!
#                    say $line;# .' => '.Dumper([$rhs_accesses,$lhs_accesses]). ' ( ' . __LINE__ . ' ) ';
					
                    ($lhs_accesses,$rhs_accesses) = @{ _detect_halo_accesses($line, $lhs_accesses,$rhs_accesses,$state,$block_id,$stref,$f) };
                    if (exists $rhs_accesses->{'HasHaloAccesses'}) {
                    $info->{'Rhs'}{'ArrayAccesses'}=$rhs_accesses;
                    }
                    if (exists $lhs_accesses->{'HasHaloAccesses'}) {
                    $info->{'Lhs'}{'ArrayAccesses'}=$lhs_accesses;
                    }                     
                    
					}
                }
				my $var_name = $info->{'Lhs'}{'VarName'};
				if (not exists $state->{'Subroutines'}{ $f }{$block_id}{'Assignments'}{$var_name}) {
					$state->{'Subroutines'}{ $f }{$block_id}{'Assignments'}{$var_name}=[];
				}
				push @{$state->{'Subroutines'}{ $f }{$block_id}{'Assignments'}{$var_name}}, $info->{'Rhs'}{'ExpressionAST'};
			}
	 		if (exists $info->{'If'} ) {
                # FIXME: Surely conditions of if-statements can contain array accesses, so FIX THIS!
                #say "IF statement, TODO: ".Dumper($info->{'CondExecExpr'});
                my $cond_expr_ast = $info->{'CondExecExprAST'};
                ($cond_expr_ast, $state, my $cond_accesses) = _find_array_access_in_ast($stref, $f, $block_id, $state, $cond_expr_ast,'Read',{});
            }
	#		if (exists $info->{'If'} ) {
	#			my $cond_expr_ast = $info->{'CondExecExprAST'};
	#			# Rename all array accesses in the AST. This updates $state->{'StreamVars'}
	#			(my $ast, $state) = _rename_ast_entry($stref, $f,  $state, $cond_expr_ast, 'In');
	#			$info->{'CondExecExpr'}=$ast;
	#			for my $var ( @{ $info->{'CondVars'}{'List'} } ) {
	#				next if $var eq '_OPEN_PAR_';
	#				if ($info->{'CondVars'}{'Set'}{$var}{'Type'} eq 'Array' and exists $info->{'CondVars'}{'Set'}{$var}{'IndexVars'}) {
	#					$state->{'IndexVars'}={ %{ $state->{'IndexVars'} }, %{ $info->{'CondVars'}{'Set'}{$var}{'IndexVars'} } }
	#				}
	#			}
	#				 if (ref($ast) ne '') {
	#				my $vars=get_vars_from_expression($ast,{}) ;
	#
	#				$info->{'CondVars'}{'Set'}=$vars;
	#				$info->{'CondVars'}{'List'}= [ grep {$_ ne 'IndexVars' and $_ ne '_OPEN_PAR_' } sort keys %{$vars} ];
	#				 } else {
	#				 	$info->{'CondVars'}={'List'=>[],'Set'=>{}};
	#				 }
	#
	#
	#		}
            elsif ( exists $info->{'Do'} ) {
                    if (exists $info->{'Do'}{'Iterator'} ) {

                # Do => {
                #           Label :: Int
                #           Iterator :: Var
                #           Range => {
                #               Vars => [ Var ],
                #               Expressions => [ $range_start, $range_stop, $range_step ]
                #            }
                #       }
                (my $range_start, my $range_stop, my $range_step) = @{ $info->{'Do'}{'Range'}{'Expressions'} };
                my $range_start_evaled = eval_expression_with_parameters($range_start,$info,$stref,$f);
                my $range_stop_evaled = eval_expression_with_parameters($range_stop,$info,$stref,$f);
#                say "RANGE: [ $range_start_evaled , $range_stop_evaled ]"; 
                my $loop_iter = $info->{'Do'}{'Iterator'};
                my $loop_range_exprs = [ $range_start_evaled , $range_stop_evaled ];#[$range_start,$range_stop]; # FIXME Maybe we don't need this. But if we do, we should probably eval() it
                my $loop_id = $info->{'LineID'};
                push @{ $state->{'Subroutines'}{$f}{'LoopNests'} },[$loop_id, $loop_iter , {'Range' => $loop_range_exprs}];
                my $block_id = __mkLoopId( $state->{'Subroutines'}{$f}{'LoopNests'} );
                for my $loop_iter_rec ( @{ $state->{'Subroutines'}{$f}{'LoopNests'} } ) {
                    (my $loop_id, my $loop_iter, my $range_rec) = @{$loop_iter_rec};
                    $state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'}{$loop_iter}=$range_rec;
                }
            } else {
                croak "Sorry, a `do` loop without an iterator is not supported";
            }
            } elsif ( exists $info->{'EndDo'} ) {

            }
			return ([[$line,$info]],$state);
		};

		my $state = {'CurrentSub'=>'', 'Subroutines'=>{}};
			
	 	($stref,$state) = stateful_pass($stref,$f,$pass_identify_array_accesses_in_exprs, $state,'pass_identify_array_accesses_in_exprs ' . __LINE__  ) ;
	 	
	 	$stref = _collect_dependencies_for_halo_access($stref,$f);
#	 	die Dumper $stref->{'Subroutines'}{$f}{'RefactoredCode'};
#	 	if ($f=~/vernieuw/) {

		$state = _link_writes_to_reads( $stref, $f, $state);
#		die Dumper($state) if $f =~/reduce/;

		$stref = _classify_accesses_and_emit_AST($stref, $f, $state);

	} # if subkernel not superkernel
	else {
		# WV: FIXME: This is TyTraCL specific
		        		say "-- SUPERKERNEL $f: ";
		$stref = _emit_AST_Main($stref, $f);
#        $stref->{'TyTraCL_AST'}{'Main'} = $f;
#
#
##		map { say $_ } sort keys %{ $stref->{'Subroutines'}{$f} };
##		say Dumper $stref->{'Subroutines'}{$f}{'DeclaredOrigArgs'}{'Set'};
#		 for my $arg (@{ $stref->{'Subroutines'}{$f}{'RefactoredArgs'}{'List'} } ) {
#		 	say $arg. ' => '. $stref->{'Subroutines'}{$f}{'DeclaredOrigArgs'}{'Set'}{$arg}{'IODir'};
#         $stref->{'TyTraCL_AST'}{'OrigArgs'}{$arg} =  $stref->{'Subroutines'}{$f}{'DeclaredOrigArgs'}{'Set'}{$arg}{'IODir'};
#		 }
	}
 	return $stref;
} # END of identify_array_accesses_in_exprs()




=info2
#  u(i-1,j+1,1)
#
#  (i+i_off,j+j_off,k+k_off) =>
#  idx = i*use_i + i_range*j*use_j+i_range*k_range*k*use_k
#  idx_off = i_off + i_range*j_off + i_range*k_range*k_off
#
#  if i, j or k is a constant then use_* is set to 0

  $VAR1 = [
  '@',
  'u',
  [
    '+',
    [
      '$',
      'i'
    ],
    [
      '-',
      '1'
    ]
  ],
  [
    '+',
    [
      '$',
      'j'
    ],
    '1'
  ],
  '1'
];

So every stencil is identified by offset &  used for each of its iters
v => { i => {offset, used}, j => ... }

=cut
# ============================================================================================================
# FIXME: I think this does not deal with constant accesses
sub _find_array_access_in_ast { (my $stref, my $f,  my $block_id, my $state, my $ast, my $rw, my $accesses)=@_;
    if (ref($ast) eq 'ARRAY') {
		for my  $idx (0 .. scalar @{$ast}-1) {
			my $entry = $ast->[$idx];

			if (ref($entry) eq 'ARRAY') {
				(my $entry, $state) = _find_array_access_in_ast($stref,$f, $block_id, $state,$entry, $rw,$accesses);
				$ast->[$idx] = $entry;
			} else {
				if ($idx==0 and (($entry & 0xF)==10)) { #$entry eq '@'
					my $mvar = $ast->[$idx+1];
					
					if ($mvar ne '_OPEN_PAR_') {

						my $expr_str = emit_expression($ast,'');
						$state = _find_iters_in_array_idx_expr($stref,$f,$block_id,$ast, $state,$rw);
#						say Dumper($ast);
#						say Dumper($state);
						my $array_var = $ast->[1];
                        # Special case for our OpenCL kernels
						if ($array_var =~/(?:glob|loc)al_/) { return ($ast,$state); }
#						# First we compute the offset
#						say "OFFSET";
						my $ast0 = dclone($ast);
						($ast0,$state, my $retval ) = _replace_consts_in_ast($stref,$f,$block_id,$ast0, $state,0);
						my @ast_a0 = @{$ast0};
						my @idx_args0 = @ast_a0[2 .. $#ast_a0];
						my @ast_exprs0 = map { emit_expression($_,'') } @idx_args0;
						my @ast_vals0 = map { eval($_) } @ast_exprs0;
						# Then we compute the multipliers (for proper stencils these are 1 but for the more general case e.g. copying a plane of a cube it can be different.
#						say "MULT";
						my $ast1 = dclone($ast);
						($ast1,$state, $retval ) = _replace_consts_in_ast($stref,$f,$block_id,$ast1, $state,1);
						my @ast_a1 = @{$ast1};
						my $array_var1 = $ast1->[1];
						my @idx_args1 = @ast_a1[2 .. $#ast_a1];
						my @ast_exprs1 = map { emit_expression($_,'') } @idx_args1;
						my @ast_vals1 = map { eval($_) } @ast_exprs1;
						my @iters = @{$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Iterators'}};

						my $iter_val_pairs=[];
						for my $idx (0 .. @iters-1) {
							my $offset_val=$ast_vals0[$idx];
							my $mult_val=$ast_vals1[$idx]-$offset_val;
							push @{$iter_val_pairs}, {$iters[$idx] => [$mult_val,$offset_val]};
						}
						$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Exprs'}{$expr_str}=1;
						$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Accesses'}{ join(':', @ast_vals0) } = $iter_val_pairs;
                        $accesses->{'Arrays'}{$array_var}{$rw}{'Exprs'}{$expr_str}=1;
                        $accesses->{'Arrays'}{$array_var}{$rw}{'Accesses'}{ join(':', @ast_vals0) } = $iter_val_pairs;
						last;
					}
				} 
			}
		}
	}
	return  ($ast, $state, $accesses);

} # END of _find_array_access_in_ast

=info3

In a first pass we try to get the iter order.
We look at the number of dimensions in the array, purely from the access
We see if there is an occurence of any of the declared iters in the array access
That gives us something like
u(const,j,k) so we know now that 0 => const 1 => j, 2 => k,
p(const, i,j,k)  so we know now that 0 => const 1 => i, 2 => j, 3 => k

Main question is: do we need this? Why not simply set the iters to 0 and evaluate the expression to get the offset?
Answer: because we need to know if this offset is to be added to the iter or not, e.g.

u(0,j,k) and u(1,j,k+1) would give stencils (0,0,0) and (1,0,1) but it is NOT i,j,k and i+1,j,k+1
So I need to be able to distinguish constant access from iterator access. Once that his done we can express the stencil as (Offset,isConst) for every dimension, by index.

But suppose something like u(i,j,k) = u(1,j,k)+u(i,1,k) then thar results in ((1,const),(0,j),(0,k)) and ((0,i),(1,const),(0,k))
That is OK: the necessary information is there.
So in short: per index:
- find iters, if not set to '' => is this per sub or per expr? Let's start per expr.
- replace iter with 0 and consts with their values
- eval the expr and use as offset


=cut

# We replace LoopIters with $const and Parameters with their values.
# Apply to RHS of assignments
sub _replace_consts_in_ast { (my $stref, my $f, my $block_id, my $ast, my $state, my $const)=@_;
	my $retval=0;
	if (ref($ast) eq 'ARRAY') {
		for my  $idx (0 .. scalar @{$ast}-1) {
			
			my $entry = $ast->[$idx];

			if (ref($entry) eq 'ARRAY') {
				(my $entry2, $state, $retval) = _replace_consts_in_ast($stref,$f, $block_id,$entry, $state,$const);
				$ast->[$idx] = $entry2;
			} else {
				if ($idx==0 and (($entry & 0xF) == 2)) { #eq '$'
					my $mvar = $ast->[$idx+1];
#					say "MVAR: $mvar in $f";
					if (exists $state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'}{ $mvar }) { 
						$ast=''.$const.'';
						return ($ast,$state,1);
					} elsif (in_nested_set($stref->{'Subroutines'}{$f},'Parameters',$mvar)) {
						my $param_set = in_nested_set($stref->{'Subroutines'}{$f},'Parameters',$mvar);
						
		  				my $decl = get_var_record_from_set( $stref->{'Subroutines'}{$f}{'Parameters'},$mvar);
#		  				say 'DECL: '. Dumper($decl);
		  				#FIXME: the value could be an expression in terms of other parameters!
		  				my $val = $decl->{'Val'};
#		  				say "MVAL: $val";	
		  				$ast = parse_expression($val, {},$stref,$f);
		  				return ($ast,$state,1);
					} else {
						my $param_set = in_nested_set($stref->{'Subroutines'}{$f},'Parameters',$mvar);
						carp "Can\'t replace $mvar, no parameter record found for in $f";#: <$param_set> = " . Dumper( $stref->{'Subroutines'}{$f}{'Parameters'} );
						return ($ast, $state,0);
					}
				}
			}
		}
	}
	return  ($ast, $state, $retval);
} # END of _replace_consts_in_ast()

# When we find an iterator access in an array we must check in which loop this array is being accessed
sub _find_iters_in_array_idx_expr { (my $stref, my $f, my $block_id, my $ast, my $state, my $rw)=@_;
	my @ast_a = @{$ast};
	my @args = @ast_a[2 .. $#ast_a];
	my $array_var = $ast_a[1];
	$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Iterators'}=[];
	for my $idx (0 .. @args-1) {
		$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Iterators'}[$idx]='?';
  		my $item = $args[$idx];
  		my $vars = get_vars_from_expression($item, {});
  		for my $var (keys %{$vars}) {
  			if (exists $state->{'Subroutines'}{ $f }{ $block_id }{'LoopIters'}{ $var }) {
  				# OK, I found an iterator in this index expression. I boldly assume there is only one.
  				$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Iterators'}[$idx]=$var;
  			}
  		}
	}
	return $state;
} # END of _find_iters_in_array_idx_expr

=info
The 'Links' table lists all input args on which an output arg depends.
This is done by a dependency analysis of the assignments.
For output args that do not depend on inputs, we add a dummy $var => "!$var!"

So first we need to gather all assignments in the subroutine, i.e. in a separate, trivial pass
We put this in the $state as 'Assignments'}, this happened in identify_array_accesses_in_exprs()

	$assignments = { $var => $assign_expr }

The links table starts out empty:

	$links = {}
	
* FOLDS
	
- To be sure it is a fold I will do the following tests:
- a scalar argument that is Out or InOut
- used in an assignment on both LHS and RHS
- I suppose this should also test for an array on the RHS, and all indices used. So I need to do a link analysis until I get to the input args
To keep this tidy I will use a separate links table for scalar outputs

So we don't allow folds over lower-dimensionality arrays, nor folds hidden in a subroutine call
Alternatively I could of course rely on the kernel name, they have 'map' or 'reduce' in them	

=cut

sub _link_writes_to_reads {(my $stref, my $f, my $state)=@_;

    for my $block_id (sort keys %{ $state->{'Subroutines'}{$f} }) {
        next if $block_id eq 'LoopNests';
		my $links={};
		my $assignments = $state->{'Subroutines'}{$f}{$block_id}{'Assignments'};
		# So we have to establish the link for every variable that is a multi-dim (effectively 3-D) array argument
		for my $some_var ( sort keys %{ $assignments }  ) {
			next if $some_var=~/_rel|_range/;
			$links = _link_writes_to_reads_rec($stref, $f, $block_id, $some_var,$assignments,$links,$state);
		}

		$links = _collapse_links($stref,$f,$block_id,$links);
		# Now remove anything that is not an array arg link
		for my $var (keys %{$links} ){

			if (not isArg($stref, $f, $var) ) {
				delete $links->{$var};
			}
	
			for my $lvar (keys %{$links->{$var}} ){
				if ($links->{$var}{$lvar} > 2 or $lvar eq '_OPEN_PAR_') {
					delete $links->{$var}{$lvar};
				}
			}
			if (
				scalar keys  %{ $links->{$var}} == 0 or
				$var eq '_OPEN_PAR_'
			) {
					delete $links->{$var};
			}
		}
		$state->{'Subroutines'}{$f}{$block_id}{'Links'}=$links;
	}
	return $state;
} # END of _link_writes_to_reads()

sub _link_writes_to_reads_rec {(my $stref, my $f, my $block_id, my $some_var, my $assignments,my  $links, my $state)=@_;
 		my $decl = get_var_record_from_set( $stref->{'Subroutines'}{$f}{'Vars'},$some_var);
		my $lhs_dim = scalar @{ $decl->{'Dim'} };
		if (exists $assignments->{$some_var} ) {
			my $rhs_array = $assignments->{$some_var};
			my $vars = {};
			for my $rhs (@{ $rhs_array }) {
				my %tvars = %{ get_vars_from_expression($rhs,{}) };
				my %avars = _remove_index_vars($stref,$f,$block_id,$state,\%tvars);
				$vars = {%{$vars},%avars };
			}
			# If an array gets assigned to and returned but does not depend on inputs, we need to make sure it is also in links
			if (scalar keys %{$vars} == 0) {
				$links->{$some_var}{'!'.$some_var.'!'}=1;
			}
			for my $var ( keys %{$vars} ) {
				next if $var=~/_rel|_range/;
				next if exists $links->{$some_var}{$var};
#				next if $var eq $some_var;
				if (isArg($stref, $f, $var)) {
					# look up Dim for $var
					my $decl = get_var_record_from_set( $stref->{'Subroutines'}{$f}{'Args'},$var);
					my $dim = scalar @{ $decl->{'Dim'} };
					if ($dim>0 && $dim == $lhs_dim) {
#						die "<$dim>" if $var eq 'pz' or $some_var eq 'pz';
#						say "LINK $some_var => $var";
						$links->{$some_var}{$var}=1;
					} else {
						$links->{$some_var}{$var}=2;
					#	this is an arg but it is not the right Dim, so ignore it
					}
				} else { # var not arg
#					say "VAR $var IS NOT ARG";
					$links->{$some_var}{$var}=4 unless $var eq '_OPEN_PAR_';
					if (exists $assignments->{$var} ) {
						my $non_arg_rhs_array = $assignments->{$var};
						my $rhs_vars = {};
						for my $non_arg_rhs (@{ $non_arg_rhs_array }) {
							my %tvars =  %{ get_vars_from_expression($non_arg_rhs,{}) };
							my %avars = _remove_index_vars($stref,$f,$block_id,$state,\%tvars);
							$rhs_vars = {%{$vars},%avars };
						}
#						say Dumper($non_arg_rhs);
#						my $rhs_vars = get_vars_from_expression($non_arg_rhs,{});
						for my $rhs_var (keys %{$rhs_vars}) {
#							say "VAR in RHS of NON-ARG assignment for $var: $rhs_var";
							next if exists $links->{$var}{$rhs_var};
							$links->{$var}{$rhs_var}= isArg($stref, $f, $rhs_var) ? 2 : 3 unless $rhs_var eq '_OPEN_PAR_';
#							next if $var eq $rhs_var;
			 				$links=_link_writes_to_reads_rec($stref, $f, $block_id, $rhs_var,$assignments,$links,$state);			 				
						}
					}
				}
			}
		}
 		return $links;
} # END of _link_writes_to_reads_rec()

sub isArg { (my $stref, my $f, my $array_var)=@_;

	if ( in_nested_set($stref->{'Subroutines'}{$f},'Args',$array_var)) {
		return 1;
	} else {
		return 0;
	}
}

# TODO I should split out the code generation and emitter
=info_classify_accesses_and_generate_TyTraCL

This routine does not modify $state; it modifies $stref by creating $stref->{UniqueVarCounters}

However, it does perform analysis:
For every $array_var in  $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}} it does the following:
- It populates $stref->{'UniqueVarCounters'}. We use this to keep track of accesses to a variable for the purpose of creating unique names for TyTraCL
- It tests if the access pattern for $array_var is a proper stencil:
	- There is more than one access to an array, this is determined from $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Accesses'}, see _find_array_access_in_ast()
	- At least one of these accesses has a non-zero offset, this is determined from $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Accesses'}
	- All points in the array are processed in order, this is determined by checking $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Iterators'} for '?', see _find_iters_in_array_idx_expr()
	There outcome is put in %stencils (1 or 0)
- It tests for partial acccesses, to be used for boundary condition processing. This is incomplete.	
- I think the TyTraCL specific funcitonality could be handled
=cut
sub _classify_accesses_and_emit_AST { (my $stref, my $f, my $state ) =@_;
# 	say "SUB $f\n";
    my $block_id=0; # TODO
    my $emit_ast = 0;
    my $ast_to_emit={};
	my $ast_emitter = sub {}; 
    if (exists $stref->{'EmitAST'}) {
    	$emit_ast = 1;
    	my $ast_name = $stref->{'EmitAST'};
    	$ast_to_emit=$stref->{$ast_name};
    	$ast_emitter = $stref->{$ast_name}{'ASTEmitter'};
    }

	my @selects=(); # These are portions of an array that are selected, we need an `select` primitive
 	my @inserts=(); # This is when a portion of an array is inserted, we need an `insert` primitive
	my %stencils=(); # The `stencil` call
	my %non_map_args=();
	my %portions=();

 	for my $array_var (keys %{$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}}) {
 		next if $array_var =~/^global_|^local_/;
 		next if not defined  $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{'Dims'} ;

# 		if (not exists $unique_var_counters->{$array_var}) {
# 			$unique_var_counters->{$array_var}=0;
# 		}

 		for my $rw ('Read','Write') {
 			if (exists  $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw} ) {
 				# because it could be read-only and even write-only: v = u+w
 				my $n_accesses  =scalar keys %{$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Accesses'} } ;
 				my @non_zero_offsets = grep { /[^0]/ } keys %{$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Accesses'} } ;
 				my $n_nonzeroffsets = scalar  @non_zero_offsets ;
 				my @qms = grep { /\?/ } @{ $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Iterators'} };
 				my $all_points = scalar @qms == 0;
				#* It is a stencil if:
				if(  $n_accesses > 1
				#- there is more than one access to an array =>
					 and
				#- at least one of these accesses has a non-zero offset
					$n_nonzeroffsets > 0 and
				#- all points in the array are processed in order
					$all_points
					) {
#						say "STENCIL for $rw of $array_var";#.': '.Dumper($state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{$rw}{'Accesses'});
			 		
				 		$ast_to_emit = $ast_emitter->( $f,  $state,  $ast_to_emit, 'STENCIL',  $block_id,  $array_var,  $rw) if $emit_ast;
						$stencils{$array_var}=1;
					}

#					if(  $n_accesses > 0
#				#- there is more than one access to an array =>
#					 and
#				#- at least one of these accesses has a non-zero offset
#					$n_nonzeroffsets == 0 and
#				#- all points in the array are processed in order
#					$all_points
#					) {
##						say "single access for $rw of $array_var (info only)";
#					}

				if (not $all_points) {
					if ($rw eq 'Read') {
#						say "SELECT for $rw of $array_var";
#						say "${array_var}_portion = select patt $array_var";
						push @selects,$array_var;
						$ast_to_emit = $ast_emitter->( $f,  $state,  $ast_to_emit, 'SELECT',  $block_id,  $array_var,  $rw) if $emit_ast;

						$portions{$array_var}=1;
					} else {
#						say "INSERT for $rw of $array_var";
#						say "${array_var}_out = insert patt buf_to_insert $array_var";
						push @inserts, $array_var;
						$ast_to_emit = $ast_emitter->( $f,  $state,  $ast_to_emit, 'INSERT',  $block_id,  $array_var,  $rw) if $emit_ast;
					}
				} else {
					if ($rw eq 'Read') {
						
					}
					
				}
			}
		}
	}
	
	$ast_to_emit = $ast_emitter->( $f,  $state, $ast_to_emit, 'MAP', $block_id) if $emit_ast;
	
#	$stref->{'TyTraCL_AST'} =$tytracl_ast;
	return $stref ;
} # END of _classify_accesses_and_emit_AST()

## What we need is the in and out tuples
## i.e. keys %{$links} = OUT
## union of vals is IN
#sub pp_links { (my $links)=@_;
#	my $in_tup_table={};
#	for my $lhs_var (sort keys %{$links}) {
##		print "$lhs_var => ";
#		my @rhs_vars=();
#		for my $lvar (sort keys %{$links->{$lhs_var}} ){
#			push @rhs_vars,$lvar;
#			$in_tup_table->{$lvar}=1;
#		}
##		say join(', ',@rhs_vars);
#	}
#	my $out_tup = [ sort keys  %{$links} ];
#	my $in_tup = [ sort keys  %{$in_tup_table} ];
#	return ($out_tup, $in_tup);
#} # END of pp_links()

sub _replace_param_by_val { (my $stref, my $f, my $block_id, my $ast, my $state)=@_;
  		# - see if $val contains vars
  		my $vars=get_vars_from_expression($ast,{}) ;
#  		say 'VARS:'.Dumper($vars);
  		# - if so, substitute them using _replace_consts_in_ast
        #my $state =  {'CurrentSub' =>$f};
  		while (
  		(exists $vars->{'_OPEN_PAR_'} and scalar keys %{$vars} > 1)
  		or (not exists $vars->{'_OPEN_PAR_'} and scalar keys %{$vars} > 0)
  		) {
#  			say 'VARS:'.Dumper($vars);
			($ast, $state, my $retval) = _replace_consts_in_ast($stref, $f, $block_id, $ast, $state, 0);
			last if $retval == 0;
#			say 'VARS-AFTER:'.Dumper($ast);
			# - check if the result is var-free, else repeat
			$vars=get_vars_from_expression($ast,{}) ;
  		}
  		# - return to be eval'ed
#  		say 'DONE WHILE in _replace_param_by_val()';
	return $ast;
} # END of _replace_param_by_val()

sub _eval_expression_w_params { (my $expr_str,my $info, my $stref, my $f, my $block_id, my $state) = @_;

    my $expr_ast=parse_expression($expr_str,$info, $stref,$f);
    my $expr_ast2 = _replace_param_by_val($stref, $f, $block_id,$expr_ast, $state);
    my $evaled_expr_str=emit_expression($expr_ast2,'');
    my $expr_val=eval($evaled_expr_str);
	return $expr_val;

} # END of _eval_expression_w_params()


sub eval_expression_with_parameters { (my $expr_str,my $info, my $stref, my $f) = @_;

    my $expr_ast=parse_expression($expr_str,$info, $stref,$f);
#    say 'AST1: "'.$expr_str.'" => '.Dumper($expr_ast);
    my $expr_ast2 = _replace_param_by_val($stref, $f, 0,$expr_ast, {});
#    say 'AST2:'.Dumper($expr_ast2);
    my $evaled_expr_str=emit_expression($expr_ast2,'');
#    say "EVAL $evaled_expr_str";
    my $expr_val=eval($evaled_expr_str);
	return $expr_val;

} # END of eval_expression_with_parameters()

sub _collapse_links { (my $stref, my $f, my $block_id, my $links)=@_;

	for my $var (keys %{$links}) {
		if (isArg($stref, $f, $var)) {
#say "ARG $var";
			my $deleted_entries={};
			my $again=1;
			do {
					$again=0;
					for my $lvar (keys %{ $links->{$var} } ) {
						next if $lvar eq $var;
						next if $lvar eq '_OPEN_PAR_';
		#				say "\tLVAR $lvar";
						if ($links->{$var}{$lvar} > 2) { # Not an argument
							$again=1;
		#					say "DEL $lvar IN $var: ".$links->{$var}{$lvar};
							delete $links->{$var}{$lvar};
							$deleted_entries->{$lvar}=1;
							for my $nlvar (keys %{ $links->{$lvar} } ) {
								next if $nlvar eq $var;
								next if $nlvar eq $lvar;
								next if $nlvar eq '_OPEN_PAR_';
								next if exists $deleted_entries->{$nlvar};
								$links->{$var}{$nlvar} = $links->{$lvar}{$nlvar};
							}
						}
					}
			} until $again == 0;
		}
	}
	return $links;
} # END of _collapse_links()

sub _remove_index_vars { (my $stref, my $f, my $block_id, my $state, my $vars_ref)=@_;
	my %vars = %{$vars_ref};
    my %non_idx_vars=();
    my %idx_vars=();
	for my $var (keys %vars ) {
		if ($vars_ref->{$var}{'Type'} eq 'Array') {
			for my $rw ('Read','Write') {
				if (exists $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$var}{$rw} and
				exists $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$var}{$rw}{'Iterators'}
				) {
				my @iters = @{$state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$var}{$rw}{'Iterators'}};
				%idx_vars = (%idx_vars, map { $_ => 1 } @iters);
				}
		}
	}
	}
	for my $var (keys %vars ) {
		if (not exists $idx_vars{$var}) {
			$non_idx_vars{$var}->{'Type'} = $vars_ref->{$var}{'Type'};
		}
	}
	return %non_idx_vars;
}

sub __is_array_decl { (my $info)=@_;

	return (exists $info->{'ParsedVarDecl'}
	&& exists $info->{'ParsedVarDecl'}{'Attributes'}
	&& exists $info->{'ParsedVarDecl'}{'Attributes'}{'Dim'}
	&& scalar @{$info->{'ParsedVarDecl'}{'Attributes'}{'Dim'}} >0);
}

sub __mkLoopId { (my $loop_nest_stack ) =@_;
    return join('',map {$_->[0]} @{$loop_nest_stack});
}

sub F3D2C { (
         my $i_rng, my $j_rng, # ranges, i.e. (hb-lb)+1
        my $i_lb, my $j_lb, my $k_lb, # lower bounds
        my $ix, my $jx, my $kx
        ) =@_;
    return ($i_rng*$j_rng*($kx-$k_lb)+$i_rng*($jx-$j_lb)+$ix-$i_lb);
}

sub F2D2C { (
         my $i_rng, # ranges, i.e. (hb-lb)+1
        my $i_lb, my $j_lb, # lower bounds
        my $ix, my $jx
        ) =@_;
    return ($i_rng*($jx-$j_lb)+$ix-$i_lb);
}


sub F1D2C { (
        my $i_lb, #// lower bounds
        my $ix
        ) = @_;
    return $ix-$i_lb;
}

sub F4D2C { (
         my $i_rng, my $j_rng,  my $k_rng, # ranges, i.e. (hb-lb)+1
        my $i_lb, my $j_lb, my $k_lb, my $l_lb, # lower bounds
        my $ix, my $jx, my $kx, my $lx
        ) = @_;
    return ($i_rng*$j_rng*$k_rng*($lx-$l_lb)+
            $i_rng*$j_rng*($kx-$k_lb)+
            $i_rng*($jx-$j_lb)+
            $ix-$i_lb
            );
}

# Halo access detection 
# The main purpose is to detect writes to halos, because reads are never a problem
# For the purpose of dividing the domain (e.g. chunking on GPU, or MPI) we need the read accesses to ensure that no read occurs outside the chunk visible to the process.
# So first we must detect if a given access is inside a halo
# Then we need to decide what to do about it. 
# Let's first look if an LHS write requires an opposite bound for the RHS read
# So what we need is a record of the array access, we put this in HaloAccesses

# This is not good, I need to combine LHS and RHS into a single routine 
sub _detect_halos {
	(my $line, my $accesses, my $rw, my $state, my $block_id, my $stref, my $f) = @_;
	if (not exists $accesses->{'Arrays'}) {
		return $stref;
	}
	
	for my $array_var (keys %{ $accesses->{'Arrays'} } ) {
	
#			say "SUB $f VAR: $array_var ";
			my ($expr_id,$expr_recs ) = each %{ $accesses->{'Arrays'}{$array_var}{$rw}{'Accesses'} };
			my $idx=0;
			for my $expr_rec (@{$expr_recs}) { # i.e. i,j,k
			    my ($loop_iter, $offset_t) = each %{$expr_rec};
			    my $offset=$offset_t->[1];
			    for my $b (0,1) { # $b is the bound index
#			    	say "LOOP ITER: $loop_iter";
#			    	say Dumper($state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'});
					# This is the loop bound
			        my $loop_bound = $state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'}{$loop_iter}{'Range'}->[$b];			        
			        my $expr_loop_bound = $loop_bound+$offset;
#			        say "EXPR: $expr_m ";
			        my $array_bound = $state->{'Subroutines'}{ $f }{ $block_id }{'Arrays'}{$array_var}{'Dims'}[$idx][$b];
#			        say  "BOUND: $array_bound" ;
			        my $decl = get_var_record_from_set( $stref->{'Subroutines'}{$f}{'Vars'},$array_var);
#			        say Dumper($decl);			        
#			        my $decl = $stref->{'Subroutines'}{ $f }{'Vars'}{$array_var}{'Halos'}[$idx][$b];
			        my $array_halo = $decl->{'Halos'}[$idx][$b];
#			        say "HALO: $array_halo"; 
			        my $in_halo = $b ? 
			        ($expr_loop_bound > $array_bound - $array_halo) ? 1 : 0
			        : ($expr_loop_bound < $array_bound + $array_halo) ? 1 : 0;
			        if ($in_halo and $rw eq 'Write') {
			        my $in_halo_expl = $b ? 
			        ($expr_loop_bound > $array_bound - $array_halo) ? "upper bound and highest access is outside core: $expr_loop_bound > ".($array_bound - $array_halo) : ''
			        : ($expr_loop_bound < $array_bound + $array_halo) ? "lower bound and lowest access is outside core: $expr_loop_bound < ".($array_bound + $array_halo) : '';
			        
			        say "SUB $f LINE	$line";
			        say "HALO CHECK: $rw access to $loop_iter".($offset ?$offset:'')." in $array_var is ". ($in_halo ? '' : 'not ').'a halo access for the '. ($b ? 'upper' : 'lower').' bound: '.$in_halo_expl ;
			        
			        	# The test is
			        	# Lower: $loop_bound + $offset < $array_bound + $array_halo
			        	# Upper: $loop_bound + $offset > $array_bound - $array_halo			        	
			        	$accesses->{'Arrays'}{$array_var}{$rw}{'HaloAccesses'}{$loop_iter}={'Bound' =>$b, 'Test' => [$loop_bound, $offset, $array_bound, $array_halo]};
			        }
			        
			        
			    }
			    $idx++;
			}
		
	}
	return $accesses;

}

sub _detect_halo_accesses {
	(my $line, my $lhs_accesses, my $rhs_accesses, my $state, my $block_id, my $stref, my $f) = @_;
	if (exists $lhs_accesses->{'Arrays'}) {
		
		for my $array_var (keys %{ $lhs_accesses->{'Arrays'} } ) {
	
			say "SUB $f VAR: $array_var ";
			my ($expr_id,$expr_recs ) = each %{ $lhs_accesses->{'Arrays'}{$array_var}{'Write'}{'Accesses'} };
			my $idx=0;
			for my $expr_rec (@{$expr_recs}) { # i.e. i,j,k
			    my ($loop_iter, $offset_t) = each %{$expr_rec};
			    my $offset=$offset_t->[1];
			    for my $b (0,1) { # $b is the bound index
			    	say "LOOP ITER: $loop_iter";
			    	say Dumper($state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'});
					# This is the loop bound
			        my $loop_bound = $state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'}{$loop_iter}{'Range'}->[$b];
			        if ($loop_iter eq '?') {$loop_bound=0;}
#			        say "LOOP BOUND: $loop_bound OFFSET: $offset"; 	
#croak 'FIXME: deal with constant access to array!';		        
			        my $expr_loop_bound = $loop_bound+$offset;
#			        say "EXPR: $expr_loop_bound ";
#say "{ $f }{ $block_id }{'Arrays'}{$array_var}{'Dims'}[$idx][$b]";
			        my $array_bound = $state->{'Subroutines'}{ $f }{ 0 }{'Arrays'}{$array_var}{'Dims'}[$idx][$b];
#			        say "{ $f }{ $block_id }{'Arrays'}{$array_var}{'Dims'}[$idx][$b]: ".$array_bound ;
#			        say  "BOUND: $array_bound" ;
			        my $decl = get_var_record_from_set( $stref->{'Subroutines'}{$f}{'Vars'},$array_var);
#			        say Dumper($decl);			        
#			        my $decl = $stref->{'Subroutines'}{ $f }{'Vars'}{$array_var}{'Halos'}[$idx][$b];
					my $array_halo = 0;
					if (exists $decl->{'Halos'}) {
			        	$array_halo = $decl->{'Halos'}[$idx][$b];
					} else {
						say "WARNING: NO halo attribute for $array_var";
					}
#			        say "HALO: $array_halo"; 
			        my $in_halo = $b ? 
			        ($expr_loop_bound > $array_bound - $array_halo) ? 1 : 0
			        : ($expr_loop_bound < $array_bound + $array_halo) ? 1 : 0;
			        if ($in_halo ) {
			        my $in_halo_expl = $b ? 
			        ($expr_loop_bound > $array_bound - $array_halo) ? "upper bound and highest access is outside core: $expr_loop_bound > ".($array_bound - $array_halo) : ''
			        : ($expr_loop_bound < $array_bound + $array_halo) ? "lower bound and lowest access is outside core: $expr_loop_bound < ".($array_bound + $array_halo) : '';
			        
			        say "SUB $f LINE	$line";
			        say "HALO CHECK: Write access to $loop_iter".($offset ?$offset:'')." in $array_var is ". ($in_halo ? '' : 'not ').'a halo access for the '. ($b ? 'upper' : 'lower').' bound: '.$in_halo_expl ;
			        
			        	# The test is
			        	# Lower: $loop_bound + $offset < $array_bound + $array_halo
			        	# Upper: $loop_bound + $offset > $array_bound - $array_halo			        	
			        	$lhs_accesses->{'Arrays'}{$array_var}{'Write'}{'HaloAccesses'}{$loop_iter}={'Bound' =>$b, 'Test' => [$loop_bound, $offset, $array_bound, $array_halo]};
			        	$lhs_accesses->{'HasHaloAccesses'}=1;
			        }
			    }
			    $idx++;
			}		
		}
	}
	# This is for completeness mainly
	if (exists $rhs_accesses->{'Arrays'}) {
		
		for my $array_var (keys %{ $rhs_accesses->{'Arrays'} } ) {
	
#			say "SUB $f VAR: $array_var ";
			my ($expr_id,$expr_recs ) = each %{ $rhs_accesses->{'Arrays'}{$array_var}{'Read'}{'Accesses'} };
			my $idx=0;
			for my $expr_rec (@{$expr_recs}) { # i.e. i,j,k
			    my ($loop_iter, $offset_t) = each %{$expr_rec};
			    my $offset=$offset_t->[1];
			    for my $b (0,1) { # $b is the bound index
#			    	say "LOOP ITER: $loop_iter";
#			    	say Dumper($state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'});
					# This is the loop bound
			        my $loop_bound = $state->{'Subroutines'}{ $f }{$block_id}{'LoopIters'}{$loop_iter}{'Range'}->[$b];
			        if ($loop_iter eq '?') {$loop_bound=0;}			        
			        my $expr_loop_bound = $loop_bound+$offset;
#			        say "EXPR: $expr_m ";
			        my $array_bound = $state->{'Subroutines'}{ $f }{ 0 }{'Arrays'}{$array_var}{'Dims'}[$idx][$b];
#			        say  "BOUND: $array_bound" ;
			        my $decl = get_var_record_from_set( $stref->{'Subroutines'}{$f}{'Vars'},$array_var);
#			        say Dumper($decl);			        
#			        my $decl = $stref->{'Subroutines'}{ $f }{'Vars'}{$array_var}{'Halos'}[$idx][$b];

					my $array_halo = 0;
					if (exists $decl->{'Halos'}) {
			        	$array_halo = $decl->{'Halos'}[$idx][$b];
					} else {
						say "WARNING: NO halo attribute for $array_var";
					}
			        
#			        say "HALO: $array_halo"; 
			        my $in_halo = $b ? 
			        ($expr_loop_bound > $array_bound - $array_halo) ? 1 : 0
			        : ($expr_loop_bound < $array_bound + $array_halo) ? 1 : 0;
			        if ($in_halo ) {
			        my $in_halo_expl = $b ? 
			        ($expr_loop_bound > $array_bound - $array_halo) ? "upper bound and highest access is outside core: $expr_loop_bound > ".($array_bound - $array_halo) : ''
			        : ($expr_loop_bound < $array_bound + $array_halo) ? "lower bound and lowest access is outside core: $expr_loop_bound < ".($array_bound + $array_halo) : '';
			        
#			        say "SUB $f LINE	$line";
#			        say "HALO CHECK: Read access to $loop_iter".($offset ?$offset:'')." in $array_var is ". ($in_halo ? '' : 'not ').'a halo access for the '. ($b ? 'upper' : 'lower').' bound: '.$in_halo_expl ;
			        
			        	# The test is
			        	# Lower: $loop_bound + $offset < $array_bound + $array_halo
			        	# Upper: $loop_bound + $offset > $array_bound - $array_halo			        	
			        	$rhs_accesses->{'Arrays'}{$array_var}{'Read'}{'HaloAccesses'}{$loop_iter}={'Bound' =>$b, 'Test' => [$loop_bound, $offset, $array_bound, $array_halo]};
			        	$rhs_accesses->{'HasHaloAccesses'}=1;
			        }
			    }
			    $idx++;
			}		
		}
	}	
	return [$lhs_accesses, $rhs_accesses];
	
} # _detect_halo_accesses

#For all lines with Write accesses to the halo, i.e. in $lhs_accesses
#- find all dependencies on that lines
#- look at any assignment line before that, and if the LHS is a dep, add it to a list.
#- Somewhere in the end we must then merge all these lists so we'll need to keep them in order
#- So I think tagging the lines is better
#- And do this for downstream as well. So I guess I go through all lines, which means I need the LineID in the accesses as well
sub _collect_dependencies_for_halo_access { (my $stref, my $f) = @_;
	my $annlines = $stref->{'Subroutines'}{$f}{'RefactoredCode'};
my $annline_ctr=0;	
for my $annline (@{$annlines}) {
	my ($line, $info) = @{$annline};
	
	if (exists $info->{'Assignment'} and exists $info->{'Lhs'} and exists $info->{'Lhs'}{'ArrayAccesses'} and exists $info->{'Lhs'}{'ArrayAccesses'}{'HasHaloAccesses'}) {
		$info->{'HaloAccess'}=1;
#		say $f.Dumper();
		say "HALO "."\t".$line;
		# OK, a line with a halo access was found. From here, go up
		# So we must make an inventory of (1) all vars on the RHS (2) all vars that are not the actual array var, on the LHS
		# For each of these we must see if it is assigned to on the LHS of a preceding line.
		# If so, must repeat this do this for that line itself; otherwise we can of course ignore it.
		my ($array_var, $array_var_rec) = each %{$info->{'Lhs'}{'ArrayAccesses'}{'Arrays'}};
		my $rhs_vars = get_vars_from_expression($info->{'Rhs'}{'ExpressionAST'});
		if (not defined $rhs_vars) {
			$rhs_vars={};
		} 
		my $lhs_vars = get_vars_from_expression($info->{'Lhs'}{'ExpressionAST'}); 		
		delete $lhs_vars->{$array_var};
		my %halo_deps=( %{$rhs_vars}, %{$lhs_vars} );
		say 'HALO DEPS: '.join(', ',keys %halo_deps);
		for my $annline_idx ( 0 .. $annline_ctr-1 ) {
			
			my $rev_annline_idx =  $annline_ctr - 1 - $annline_idx;
			my $prec_annline =   $annlines->[$rev_annline_idx];
			my ($prec_line, $prec_info) = @{$prec_annline};
			
			if (exists $prec_info->{'Assignment'}) {
				say "PREC:".$prec_line;
				my $lhs_vars = get_vars_from_expression($prec_info->{'Lhs'}{'ExpressionAST'});
				
				my $lhs_assigned_var =  $prec_info->{'Lhs'}{'VarName'};
				say "LHS VAR:".$lhs_assigned_var ;
#				delete $lhs_vars->{$lhs_assigned_var};
				# But really this should not be array indices, only proper assigned vars!
#				for my $lhs_var (sort keys %{$lhs_vars}) {
					if (exists $halo_deps{$lhs_assigned_var} ) {
						$prec_info->{'HaloDep'}=1;
						say "Halo access $array_var depends on line $prec_line";												
					} 	
#				}
				if (exists $prec_info->{'HaloDep'}) {
					my $rhs_vars = get_vars_from_expression($prec_info->{'Rhs'}{'ExpressionAST'});
					 
					if (not defined $rhs_vars) {
						$rhs_vars={};
					}
					
					if (exists  $rhs_vars->{'_OPEN_PAR_'}) {
						delete $rhs_vars->{'_OPEN_PAR_'};
					};
					say "RHS VARS: ". join(', ',keys %{$rhs_vars});
					%halo_deps=( %halo_deps, %{$rhs_vars}, %{$lhs_vars} );
				}
				
			} # TODO: later we must extend this to subroutine calls as well
	$prec_annline=[$prec_line,$prec_info];
	$annlines->[$rev_annline_idx]=$prec_annline;	
		}  
		
	}

	$annline_ctr++;
	 
}	
#	$stref->{'Subroutines'}{$f}{'RefactoredCode'}=$annlines;
	for my $annline (@{$stref->{'Subroutines'}{$f}{'RefactoredCode'}}) {
		say 'LINE: '."\t".( exists $annline->[1]{'HaloDep'} ? 'DEP' : exists $annline->[1]{'HaloAccess'} ? 'HALO' : '')."\t" .$annline->[0];
	}
	die if $f=~/verniew/;
	return $stref;	
}

sub _emit_AST_Main {(my $stref, my $f) =@_;
	    my $emit_ast = 0;
    my $ast_to_emit={};
	my $ast_emitter = ''; 
    if (exists $stref->{'EmitAST'}) {
    	$emit_ast = 1;
    	my $ast_name = $stref->{'EmitAST'};
    	$ast_to_emit=$stref->{$ast_name};
    	$ast_emitter = $stref->{$ast_name}{'ASTEmitter'};
    }
    
	$ast_to_emit = $ast_emitter->( $f,  $stref,  $ast_to_emit, 'MAIN',  '',  '',  '') if $emit_ast;
	
	return $stref;
}

1;
