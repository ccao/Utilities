#!/usr/bin/perl
#
use Math::VectorReal;

$ARGC=@ARGV;
$Math::VectorReal::FORMAT = " %12.9f %12.9f %12.9f ";

if ($ARGC<1) {
  printf(" Usage: \n");
  printf("    1. pwbandproj.pl PROJ.DAT\n");
  printf("      Lists the definition of projections in PROJ.DAT file.\n");
  printf("    2. pwbandproj.pl PROJ.DAT INPUT\n");
  printf("      Generate the plotable projection file according to INPUT specification.\n");
  printf("       example INPUT file format:\n");
  printf("      line 1: bands.dat # file name of PWSCF bands.x output\n");
  printf("      line 2: 1         # Number of projection groups\n");
  printf("      line 3...: 1 2 3 4 5 # List projections...\n");
  exit(0);
}

&read_projection ( $ARGV[0], $ARGC );	#  READ projection data

printf("#  Number of kpts, bnds: %5d, %5d\n", $nkpts, $nbnds);
printf("#  Reciprocal lattices:\n");
for($i=0; $i<3; $i++) {
  print("#", $bvec[$i], "\n");
}

if ($ARGC<2) {
  exit(0);
}

&read_input ( $ARGV[1] );		#  READ input specification

printf("#  %d projections will be done...\n", $ngrps);
for($i=0; $i<$ngrps; $i++) {
  printf("#     %d projection include %d orbitals\n", $i+1, $nprjgrp[$i]);
}

&read_bands ( $bandfile );		#  READ band structure data



$kx[0]=0.0;
for($ikpt=1; $ikpt<$nkpts; $ikpt++) {
  $kv=$kvec[$ikpt] - $kvec[$ikpt-1];
  $kx[$ikpt]=$kx[$ikpt-1]+$kv->length;
}

for($ibnd=0; $ibnd<$nbnds; $ibnd++) {
  for($ikpt=0; $ikpt<$nkpts; $ikpt++) {
    printf("%12.9f %12.9f ", $kx[$ikpt], $eig[$ikpt][$ibnd]);
    for($igrp=0; $igrp<$ngrps; $igrp++) {
      $coef=0.0;
      for($iproj=0; $iproj<$nprjgrp[$igrp]; $iproj++) {
        $coef+=$proj[$projlist[$igrp][$iproj]-1][$ikpt][$ibnd];
      }
      printf(" %12.9f", $coef);
    }
    printf("\n");
  }
  printf("\n");
}

sub read_projection {

  my $i, $iproj, $ikpts, $ibnds;
  my @tmp, @acell;
  
  open(FIN, $_[0]);
  
  $_=<FIN>;	# Blank line
  $_=<FIN>;	# Dimensions...
  @tmp=split;
  $natm=$tmp[6];
  $ntyp=$tmp[7];
  
  $_=<FIN>;	# Cell dimension as specified from celldm()
  for($i=0; $i<3; $i++) {
    $_=<FIN>;
    @tmp=split;
    $acell[$i]=vector($tmp[0], $tmp[1], $tmp[2]);
  }
  $_=<FIN>;

  $omega = $acell[0].($acell[1] x $acell[2]);
  $bvec[0]=($acell[1] x $acell[2])/$omega;
  $bvec[1]=($acell[2] x $acell[0])/$omega;
  $bvec[2]=($acell[0] x $acell[1])/$omega;

  for($i=0; $i<$ntyp; $i++) {	# Type information
    $_=<FIN>;
    @tmp=split;
    $typnam[$i]=$tmp[1];
    $ntypatm[$i]=0;
  }
  
  for($i=0; $i<$natm; $i++) {	# Atom information
    $_=<FIN>;
    @tmp=split;
    $atmtyp[$i]=$tmp[3];		# Setup dictionary
    $typatm[$typnam[$tmp[3]]][$ntypatm[$tmp[3]]++]=$i;	# Setup Harsh
  }
  
  $_=<FIN>;
  @tmp=split;		# Dimension
  $nproj=$tmp[0];
  $nkpts=$tmp[1];
  $nbnds=$tmp[2];
  
  $_=<FIN>;		# Not sure what is it?
  
  for($iproj=0; $iproj<$nproj; $iproj++) {
    $_=<FIN>;		# Projection specification
    if ($_[1]<2) {
      print;
    }
    for($ikpts=0; $ikpts<$nkpts; $ikpts++) {
      for($ibnds=0; $ibnds<$nbnds; $ibnds++) {
        $_=<FIN>;
        if ($_[1]>1) {
          @tmp=split;
          $proj[$iproj][$ikpts][$ibnds]=$tmp[2];
        }
      }
    }
  }
  
  close(FIN);
}

sub read_bands {
  my $_nkpt, $_nbnd;
  my $ikpt, $ibnd;

  open (FIN, $_[0]);
  $_=<FIN>;		# &plot nbnd= ...

  for ($ikpt=0; $ikpt<$nkpts; $ikpt++) {
    $_=<FIN>;
    @tmp=split;
    $kvec[$ikpt]=vector( $tmp[0], $tmp[1], $tmp[2]);
#    push @kvec, [ @tmp ];

    undef @teig;
    for ($ibnd=0; $ibnd<$nbnds; $ibnd+=10) {
      $_=<FIN>;
      @tmp=split;
      push @teig, @tmp;
    }

    push @eig, [ @teig ];
  }
  close(FIN);
}

sub read_input {
  my $igrp;
  open (FIN, $_[0]);
  $bandfile=<FIN>;		# band structure data file
  chomp($ngrps=<FIN>);			# Number of projection groups...

  for($igrp=0; $igrp<$ngrps; $igrp++) {
    $_=<FIN>;
    @tmp=split;
    push @projlist, [ @tmp ];
    $nprjgrp[$igrp]=@tmp;
  }
  close(FIN);
}
