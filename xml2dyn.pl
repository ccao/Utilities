#!/usr/bin/perl
printf("Dynamical matrix file\n\n");

$ityp=0;

while(<>) {
  if( /<NUMBER_OF_TYPES /) {
    $_=<>;
    @tmp=split;
    $ntyp=$tmp[0];
    printf("%3d", $ntyp);
  }
  if( /<NUMBER_OF_ATOMS /) {
    $_=<>;
    @tmp=split;
    $natm=$tmp[0];
    printf("%5d", $natm);
  }
  if( /<BRAVAIS_LATTICE_INDEX /) {
    $_=<>;
    @tmp=split;
    $ibrav=$tmp[0];
    printf("%3d", $ibrav);
  }
  if( /<CELL_DIMENSIONS /) {
    for($i=0; $i<6; $i++) {
      $_=<>;
      @tmp=split;
      $alat[$i]=$tmp[0];
      printf("%11.7f",$alat[$i]);
    }
    printf("\n");
  }
#  if( /<AT /){
#    printf("Basis vectors\n");
#    for($i=0; $i<3; $i++) {
#      $_=<>;
#      @tmp=split;
#      push @at, [ @tmp ];
#      printf("  %15.9f%15.9f%15.9f\n", $at[$i][0], $at[$i][1], $at[$i][2]);
#    }
#  }
    
  if( /<TYPE_NAME/) {
    $ityp++;
    $_=<>;
    @tmp=split;
    $typ_name=$tmp[0];
    $_=<>;
    $_=<>;
    $_=<>;
    @tmp=split;
    $typ_wgt=$tmp[0]*911.44424213227317;
    printf("%12d  '%-4s'    %16.9f\n", $ityp, $typ_name, $typ_wgt);
  }

  if( /<ATOM/) {
    s/"/ /g;
    s/ATOM./ /;
    @tmp=split;
    printf("%5d%5d%18.10f%18.10f%18.10f\n", $tmp[1], $tmp[5], $tmp[7], $tmp[8], $tmp[9]);
  }
    
  if( /<Q_POINT / ) {
    $_=<>;
    @qpoint=split;
    printf("\n     Dynamical  Matrix in cartesian axes\n\n");
    printf("     q = ( %14.9f%14.9f%14.9f )\n\n",$qpoint[0],$qpoint[1],$qpoint[2]);
  }
  if( /<PHI/ ) {
    s/\./ /g;
    @tmp=split;
    $iatm=$tmp[1];
    $jatm=$tmp[2];
    for($i=0;$i<9;$i++) {
      $_=<>;
      s/,/ /;
      push @phi, [split];
    }
    printf("%5d%5d\n",$iatm,$jatm);
    for($i=0;$i<3;$i++) {
      for($j=0;$j<3;$j++) {
        printf("%12.8f%12.8f  ",$phi[$i*3+$j][0],$phi[$i*3+$j][1]);
      }
      printf("\n");
    }
    for($i=0;$i<3*$natm;$i++) {
      pop @phi;
    }
  }

  if( /<FREQUENCIES_THZ/ ) {
    printf("\n     Diagonalizing the dynamical matrix\n\n");
    printf("     q = ( %14.9f%14.9f%14.9f )\n\n",$qpoint[0],$qpoint[1],$qpoint[2]);
    printf(" **************************************************************************\n");
  }

  if( /<OMEGA/ ) {
    s/\./ /g;
    @tmp=split;
    $iomega=$tmp[1];
    $_=<>;
    @omega=split;
    printf("     omega(%2d) =   %12.6f [THz] =   %12.6f [cm-1]\n",$iomega,$omega[0],$omega[1]);
  }
  if( /<DISPLACEMENT/ ) {
    for($i=0;$i<3*$natm;$i++) {
      $_=<>;
      s/,/ /;
      push @disp,[split];
    }
    for($i=0;$i<$natm;$i++) {
      printf(" (");
      for($j=0;$j<3;$j++) {
        printf("%10.6f%10.6f",$disp[$i*3+$j][0],$disp[$i*3+$j][1]);
      }
      printf(" )\n");
    }
    for($i=0;$i<3*$natm;$i++) {
      pop @disp;
    }
  }
  printf(" **************************************************************************\n");
}
