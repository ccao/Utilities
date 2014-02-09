#!/usr/bin/perl

open(FILE, $ARGV[0]);

for($i=0;$i<5;$i++) {
  $_=<FILE>;
  chomp;
  printf("%s\n",$_);
}

$nnatm=0;

$_=<FILE>;
chomp;
printf("%s\n",$_);
$_=<FILE>;
chomp;
printf("%s\n",$_);
@natm = split;
for($i=0;$i<@natm;$i++) {
  $nnatm+=$natm[$i];
}

$_=<FILE>;
chomp;
printf("%s\n",$_);

if(/Selective/) {
  $_=<FILE>;
  chomp;
  printf("%s\n",$_);
}

for($i=0;$i<$nnatm;$i++) {
  $_=<FILE>;
  chomp;
  @atm = split;
  for($j=0; $j<3; $j++) {
    $x[$j]=$atm[$j];
    while ($x[$j]<0.0) {
      $x[$j]+=1.0;
    }
    while ($x[$j]>1.0) {
      $x[$j]-=1.0;
    }
  }
  
  if(@atm==3) {
    printf("%22.12f%22.12f%22.12f\n",$x[0],$x[1],$x[2]);
  }
  else {
    printf("%22.12f%22.12f%22.12f %4s%4s%4s\n",$x[0],$x[1],$x[2],$atm[3],$atm[4],$atm[5]);
  }
}
