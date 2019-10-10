#!/usr/bin/env perl
# 
#   (c) 2019 Wim Vanderbauwhede <Wim.Vanderbauwhede@Glasgow.ac.uk>
#   

use 5.010;
use warnings;
use strict;

use vars qw( $VERSION );
$VERSION = "1.2.0";
use Getopt::Std;
use RefactorF4Acc::Main qw( main usage );
use Carp;
use Data::Dumper;

my %opts = ();
getopts( 'hvmst:e:', \%opts );

if ($opts{'h'}){
    die "
    $0 -[hvste] 

    -v : verbose
    -s : Scalarise only
    -t : Testing, no sources needed
    -e : Fortran source file extension (default is .f95, needs the dot)
    \n";
}
our $V=0;
if ($opts{'v'}) {
    $V=1;
}
my $gen_tytra_ir_main=0;
if ($opts{'m'}) {
    $gen_tytra_ir_main=1;
}
my $scalarise=1;
my $gen_main=1;
if ($opts{'s'}) {
    $gen_main=0;
}
my $test = 0;
if ($opts{'t'}) {
    $test=$opts{'t'};
}
my $ext = '.f95';
if ($opts{'e'}) {
    $ext = $opts{'e'};
}

my $stref={};

if ($test && $scalarise) {
    die "The -s and -t options can't be combined.\n";
}

# First scalarise
if (!$test && $scalarise) {
    say "SCALARISE" if $V;
    my @kernel_srcs = glob("module_*_superkernel.f95"); 

    if (scalar @kernel_srcs == 1) {
        if (-d './Scalarized') {
            system ('rm -f ./Scalarized/*.f95');
        }
        my $kernel_src = shift @kernel_srcs;
        say "KERNEL MODULE SRC: $kernel_src" if $V;
        my ($kernel_sub_name, $kernel_module_name) = get_kernel_and_module_names($kernel_src,'superkernel');
        if ($kernel_sub_name ne '') {
            my $rf4a_scalarize_cfg =  create_rf4a_cfg_scalarise($kernel_src,$kernel_sub_name, $kernel_module_name);  
            say "CFG: ".Dumper($rf4a_scalarize_cfg) if $V;
            my $args = {'P' => 'rename_array_accesses_to_scalars','c' => $rf4a_scalarize_cfg};
	        $stref = main($args);
        }
    } else {
        die "No kernel sources found";
    }
}


# Generate TyTraIR main routine
if ($gen_main) {
    say "GENERATING TyTraIR main routine" if $V;
    my @kernel_srcs = glob("module_*_superkernel.f95"); 

    if (scalar @kernel_srcs == 1 or $test) {
        if (!$test) {
            if (-d './TyTraC' ) {
                if (-e './TyTraC/kernelTop.ll')  {
                        unlink('./TyTraC/kernelTop.ll');
                }
            } else {
                mkdir './TyTraC';
            }
            my $kernel_src = shift @kernel_srcs;
            say "KERNEL MODULE SRC: $kernel_src" if $V;
            my ($kernel_sub_name, $kernel_module_name) = get_kernel_and_module_names($kernel_src,'superkernel');
            if ($kernel_sub_name ne '') {
                my $rf4a_tytra_hs_cfg =  create_rf4a_cfg_tytra_cl($kernel_src,$kernel_sub_name, $kernel_module_name);  
                say "CFG: ".Dumper($rf4a_tytra_hs_cfg) if $V;

    # $args is a hash with the same structure as %opts for getopts
    # $stref_init is the initial state, usually carried over from a previous pass
    # $stref_merger is a subroutine reference containing the logic to merge $stref and $stref_init
    # In this case what we need is the argument list and order from the scalarise pass
    # This is stored in $stref->{'Subroutines'}{$f}{'DeclaredOrigArgs'}
    # So I think I'll make a $stref->{'ScalarisedArgs'}{$f}

            my $args = {'P' => 'memory_reduction', 'c' => $rf4a_tytra_hs_cfg, 'o'  => './ASTInstance.hs'};
            my $stref_init=$stref;
            my $stref_merger=sub{ my ($stref, $stref_init )=@_;
                $stref->{'ScalarisedArgs'}={};
                for my $f (sort keys %{$stref_init->{'Subroutines'}}) {
                        $stref->{'ScalarisedArgs'}{$f}=$stref_init->{'Subroutines'}{$f}{'DeclaredOrigArgs'};
                }
                return $stref;
            };
	        $stref = main($args, $stref_init, $stref_merger);                                
            }
        } else {
            $stref = main({'P' => 'memory_reduction', 'c' => {'TEST'=>$test}, 'o'  => './src/ASTInstance.hs'});
        }
    } else {
        die "No kernel sources found";
    }
}



# ==================================== AUX ====================================


sub create_rf4a_cfg_scalarise {
    my ($kernel_src,$kernel_sub_name, $kernel_module_name) = @_;    

    my $rf4a_cfg = {
'MODULE' => $kernel_module_name,
'MODULE_SRC' => $kernel_src,
'TOP' => $kernel_sub_name,
'KERNEL' =>  $kernel_sub_name,
'PREFIX' => '.',
'SRCDIRS' => ['.'],
'NEWSRCPATH' => './Scalarized',
'EXCL_SRCS' => ['(sub|init|param|module_\\w+_superkernel_init|_host|\\.[^f])'],
'EXCL_DIRS' => [ qw(./PostCPP ./Scalarized ./TyTraC)],
'MACRO_SRC' => 'macros.h',
'EXT' => ['.f95'],
'SUB_SUFFIX' => '_scal'
};

return $rf4a_cfg;
} # END of create_rf4a_cfg_scalarise


sub create_rf4a_cfg_tytra_cl {
    my ($kernel_src,$kernel_sub_name, $kernel_module_name) = @_;    

    my $rf4a_cfg = {
'MODULE' => $kernel_module_name,
'MODULE_SRC' => $kernel_src,
'TOP' => $kernel_sub_name,
'KERNEL' => $kernel_sub_name,
'PREFIX' => '.',
'SRCDIRS' => ['.'],
'NEWSRCPATH' => './Temp',
'EXCL_SRCS' => ['(module_\\w+_superkernel_init|_host|\\.[^f])'],
'EXCL_DIRS' => [ qw( ./PostCPP ./Temp ./TempC ./Scalarized ./TyTraC ) ],
'MACRO_SRC' => 'macros.h',
'EXT' => ['.f95']
};

    return $rf4a_cfg;
} # END of create_rf4a_cfg_tytra_cl

sub get_kernel_and_module_names {
    my ($kernel_src, $superkernel) = @_;
    
    open my $SRC, '<', $kernel_src or die $!;
    my @src_lines = <$SRC>;
    close $SRC;
    
    my @kernel_sub_names    = map {/^\s*subroutine\s+(\w+)/; $1} grep { /^\s*subroutine\s+\w+/ } @src_lines;
    my $kernel_sub_name='NO_NAME';
    if (defined $superkernel) {
            ($kernel_sub_name) = grep {/superkernel/} @kernel_sub_names;
    } else {
            ($kernel_sub_name) = grep {!/superkernel/} @kernel_sub_names;
    }
    say "KERNEL SUB NAME: <$kernel_sub_name>" if $V;
    my ($kernel_module_name) = map { /^\s*module\s+(\w+)/; $1 } grep {/^\s*module\s+\w+/} @src_lines;
    say "KERNEL MODULE NAME: <$kernel_module_name>" if $V;
    return ($kernel_sub_name, $kernel_module_name);
} # END of get_kernel_and_module_names




sub VERSION_MESSAGE {	
	if (join(' ',@ARGV)=~/--help/) {
		usage();
	}
	die "Version: $VERSION\n";
}