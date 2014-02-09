#!/usr/bin/perl

open(FILE, $ARGV[0]);

$n[0]=$ARGV[1];
$n[1]=$ARGV[2];
$n[2]=$ARGV[3];

for($i=0;$i<2;$i++) {
  $_=<FILE>;
  chomp;
  printf("%s\n",$_);
}

for($i=0;$i<3;$i++) {
  $_=<FILE>;
  chomp;
  @alat = split;
  printf(" %22.16f%22.16f%22.16f\n", $alat[0]*$n[$i], $alat[1]*$n[$i], $alat[2]*$n[$i]);
}

$nnatm=0;

$_=<FILE>;
chomp;
printf("%s\n",$_);
$_=<FILE>;
chomp;
@natm = split;
for($i=0;$i<@natm;$i++) {
  printf("%8d", $natm[$i]*$n[0]*$n[1]*$n[2]);
  $nnatm+=$natm[$i];
}
$_=<FILE>;
chomp;
printf("\n%s\n",$_);

if(/Selective/) {
  $_=<FILE>;
  chomp;
  printf("%s\n",$_);
}

for($i=0;$i<$nnatm;$i++) {
  $_=<FILE>;
  chomp;
  @atm = split;
  for($i1=0;$i1<$n[0];$i1++) {
    for($i2=0;$i2<$n[1];$i2++) {
      for($i3=0;$i3<$n[2];$i3++) {
        if(@atm==3) {
          printf("%22.16f%22.16f%22.16f\n",($atm[0]+$i1)/$n[0],($atm[1]+$i2)/$n[1],($atm[2]+$i3)/$n[2]);
        }
        else {
          printf("%22.16f%22.16f%22.16f %4s%4s%4s\n",($atm[0]+$i1)/$n[0],($atm[1]+$i2)/$n[1],($atm[2]+$i3)/$n[2],$atm[3],$atm[4],$atm[5]);
        }
      }
    }
  }
}
