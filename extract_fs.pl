#!/usr/bin/perl

open(FILE, $ARGV[0]);
$nstart = $ARGV[1];
$nend = $ARGV[2];

for($i=0;$i<14;$i++) {
  $_=<FILE>;
  chomp;
  printf("%s\n", $_);
}

$_=<FILE>;
@tmp= split;
$nbands=$tmp[0];

if($nend<$nstart || $nbands<$nend) {
  printf("Wrong indices, exit...\n");
  exit(0);
}

printf("%15d\n",$nend-$nstart+1);

$_=<FILE>;
printf("%s", $_);
@tmp= split;
$nx=$tmp[0]; $ny=$tmp[1]; $nz=$tmp[2];

for($i=0;$i<4;$i++) {
  $_=<FILE>;
  chomp;
  printf("%s\n", $_);
}

for($i=1;$i<$nstart;$i++) {
  for($j=0;$j<$nx*$ny*$nz+1;$j++) {
    $_=<FILE>;
  }
}

for($i=0;$i<$nend-$nstart+1;$i++) {
  $_=<FILE>;
  printf(" BAND:%12d\n",$i+1);
  for($j=0;$j<$nx*$ny*$nz;$j++) {
    $_=<FILE>;
    chomp;
    printf("%s\n", $_);
  }
}

printf(" END_BANDGRID_3D\n");
printf("  END_BLOCK_BANDGRID_3D\n");

