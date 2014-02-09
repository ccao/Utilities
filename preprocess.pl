#!/usr/bin/perl

open(FILE, $ARGV[0]);

for($i=0;$i<9;$i++) {
  $_=<FILE>;
}

@tmp = split;
$ef = $tmp[2];

printf("Fermi level : %12.8f\n",$ef);

for($i=0;$i<6;$i++) {
  $_=<FILE>;
}

chomp;
@tmp = split;
$nbnds = $tmp[0];

printf("  # of bands:  %5d \n", $nbnds);

$_=<FILE>;
chomp;
@tmp = split;
$nx = $tmp[0]; $ny = $tmp[1]; $nz = $tmp[2];

for($i=0;$i<4;$i++) {
  $_=<FILE>;
}

for($i=0;$i<$nbnds;$i++) {
  $_=<FILE>;
  chomp;
  printf("%s",$_);
  $emin = 9.0E+8;
  $emax =-9.0E+8;
  for($j=0;$j<$nx*$ny*$nz;$j++) {
    $_=<FILE>;
    chomp;
    @tmp = split;
    $e=$tmp[0];
    if($e<$emin) {
      $emin = $e;
    }
    if($e>$emax) {
      $emax = $e;
    }
  }
  printf(" Emin = %12.8f, Emax = %12.8f\n", $emin, $emax);
}
