#!/usr/bin/perl

open(FILE, "input");
$_=<FILE>;
@proj=split;
close(FILE);

open(FILE, "PROCAR");

$_=<FILE>;
$_=<FILE>;
@tmp=split;
$nkpt=$tmp[3];
$nbnd=$tmp[7];
$natm=$tmp[11];
printf(" # of K-points: %5d\n", $nkpt);
printf(" # of Bands:    %5d\n", $nbnd);
printf(" # of atoms:    %5d\n", $natm);

for($ik=0; $ik<$nkpt; $ik++) {
  printf(" # Kpt %5d", $ik);
  $_=<FILE>;
  $_=<FILE>;
  @tmp=split;
  $knew[0]=$tmp[3];
  $knew[1]=$tmp[4];
  $knew[2]=$tmp[5];
  printf("(%8.3f,%8.3f,%8.3f):", $knew[0], $knew[1], $knew[2]);
  if ($ik==0) {
    $kpt[$ik]=0.0;
  }
  else {
    $kpt[$ik]=$kpt[$ik-1]+sqrt(($knew[0]-$kold[0])**2+($knew[1]-$kold[1])**2+($knew[2]-$kold[2])**2);
  }
  @kold=@knew;
    
  for($ib=0; $ib<$nbnd; $ib++) {
    $tw[$ib]=0.0;
    if($ib%10==0) {
      printf(".");
    }
    $_=<FILE>;
    $_=<FILE>;
    @tmp=split;
    $te[$ib]=$tmp[4];
    $_=<FILE>;
    $_=<FILE>;
    for($ia=0; $ia<$natm; $ia++) {
      $_=<FILE>;
      @tmp=split;
      $norb=@tmp; $norb--;
      $tw[$ib]+=$tmp[$norb]*$proj[$ia];
    }
    $_=<FILE>;
  }
  push @ebnds, [ @te ];
  push @weight, [ @tw ];
  $_=<FILE>;
  printf("done.\n");
}

close(FILE);

for($i=0;$i<$nbnd;$i++) {
  for($j=0;$j<$nkpt;$j++) {
      printf("%12.9f  %12.9f  %12.9f\n",$kpt[$j],$ebnds[$j][$i],$weight[$j][$i]);
  }
  printf("\n");
}
