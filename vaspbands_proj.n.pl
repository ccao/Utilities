#!/usr/bin/perl
# Simple input file:
# line 1: Fe    ! atoms to project
# line 2: dz2   ! orbitals to project
# line 3: 72    ! Number of kpts to be skipped

use Math::VectorReal;

$Math::VectorReal::FORMAT = " %12.9f %12.9f %12.9f ";
# Get input
#
$Kpoints_Per_Path=100;
 open(FILE, "input");
 $_=<FILE>;
 @tgatm=split;
 $_=<FILE>;
 @tgorb=split;
 $ntgatm=@tgatm;
 $ntgorb=@tgorb;
 $_=<FILE>;
 @tmp=split;
 $nskip=$tmp[0];
 close(FILE);

# Get POSCAR information ( the atom names )

open(FILE, "POSCAR");
for($ii=0; $ii<2; $ii++) {
  <FILE>;
}

for($ii=0; $ii<3; $ii++) {
  $_=<FILE>;
  @tmp=split;
  $acell[$ii]=vector($tmp[0], $tmp[1], $tmp[2]);
  print("#   ", $acell[$ii], "\n");
}

$omega = $acell[0].($acell[1] x $acell[2]);
$bvec[0]=($acell[1] x $acell[2])/$omega;
$bvec[1]=($acell[2] x $acell[0])/$omega;
$bvec[2]=($acell[0] x $acell[1])/$omega;

$_=<FILE>;
@spnam=split;    # Specie names
$_=<FILE>;
@natsp=split;    # Number of atoms per specie
$nsp=@spnam;     # Number of species
$nat=0;          # Total number of atoms
for($ii=0; $ii<$nsp; $ii++) {
  $istgt=0;
  for($jj=0; $jj<$ntgatm; $jj++) {
    if($spnam[$ii] eq $tgatm[$jj]) {
      $istgt=1;
    }
  }
  for($jj=0; $jj<$natsp[$ii]; $jj++) {
    $prjat[$nat]=$istgt;
    $nat++;
  }
}
close(FILE);

printf("# Projected atoms:");
for($ii=0; $ii<$nat; $ii++) {
  printf("%3d", $prjat[$ii]);
}
printf("\n");

# Do the actual job

open(FILE, "PROCAR");

$_=<FILE>;       # PROCAR lm decomposed
$_=<FILE>;       # # of k-points...
@tmp=split;
$nkpt=$tmp[3];   # num of kpts
$nbnd=$tmp[7];   # num of bands
if ($nat!=$tmp[11]) {
  printf(" POSCAR info does not appear to be consistent with PROCAR\n");
}

printf(" # of K-points: %5d\n", $nkpt);
printf(" # of Bands:    %5d\n", $nbnd);
printf(" # of atoms:    %5d\n", $nat);

for($ik=0; $ik<$nkpt; $ik++) {
  do {
    $_=<FILE>;
    @tmp=split;
  } while ($tmp[0] ne "k-point");  # skip blank lines until 'k-point'
  s/-([0-9])/ -$1/g;
  @tmp=split;
  $tt1=$tmp[3] * $bvec[0];
  $tt2=$tmp[4] * $bvec[1];
  $tt3=$tmp[5] * $bvec[2];
  $kvec[$ik]=$tt1+$tt2+$tt3;
  print("#", $kvec[$ik] );
  if ($ik==0) {
    $kpt[$ik]=0.0;
  }
  elsif($ik%$Kpoints_Per_Path==0) {
     $kpt[$ik]=$kpt[$ik-1];
  }
  else {
    $kv=$kvec[$ik]-$kvec[$ik-1];
    $kpt[$ik]=$kpt[$ik-1]+$kv->length;
  }

  for($ib=0; $ib<$nbnd; $ib++) {
    $tw[$ib]=0.0;

    do {
      $_=<FILE>;
      @tmp=split;
    } while ($tmp[0] ne "band");    # skip blank lines unitl 'band'
    $te[$ib]=$tmp[4];  # energy
    do {
      $_=<FILE>;    # ion ...
      @tmp=split;
    } while ($tmp[0] ne "ion");     # skip blank lines until 'ion'
    $norb=@tmp; $norb--;
    for($ii=0; $ii<$norb; $ii++) {
      $prjorb[$ii]=0;
      for($jj=0; $jj<$ntgorb; $jj++) {
        if($tmp[$ii+1] eq $tgorb[$jj]) {
          $prjorb[$ii]=1;
        }
      }
    }
    for($ia=0; $ia<$nat; $ia++) {
      $_=<FILE>;
      if ( $prjat[$ia]==1 ) {
        @tmp=split;
        for($ii=0; $ii<$norb; $ii++) {
          $tw[$ib]+=$tmp[$ii+1]*$prjorb[$ii];
        }
      }
    }
    $_=<FILE>;   # tot
  }
  push @ebnd, [ @te ];
  push @weight, [ @tw ];
  $_=<FILE>;
  printf(" done.\n");
}

close(FILE);

for($i=0;$i<$nbnd;$i++) {
  for($j=$nskip;$j<$nkpt;$j++) {
      printf("%12.9f  %12.9f  %12.9f\n",$kpt[$j]-$kpt[$nskip],$ebnd[$j][$i],$weight[$j][$i]);
    if(($j+1)%$Kpoints_Per_Path==0){
       if($i==0){
               $xn=($j+1)/$Kpoints_Per_Path;
               warn "x$xn = $kpt[$j]";
       }
      printf("\n");
    }
  }
  printf("\n");
}

