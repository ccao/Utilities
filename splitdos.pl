#!/usr/bin/perl

open(DOSCAR,"DOSCAR");

$_=<DOSCAR>;
@tmp=split;
$natms=$tmp[0];
$nspin=$tmp[2];
for($i=0;$i<4;$i++) {
  $_=<DOSCAR>;
}

printf("  Number of atoms: %d\n  Number of spin: %d\n",$natms,$nspin);

open(POSCAR,"POSCAR");
for($i=0;$i<5;$i++) {
  $_=<POSCAR>;
}

$_=<POSCAR>;
@atmnam=split;
$_=<POSCAR>;
@atmnum=split;
$nspec=@atmnam;
close(POSCAR);

printf("  Number of species: %d\n",$nspec);

$temp=0;
for($i=0;$i<$nspec;$i++) {
  $temp+=$atmnum[$i];
}

if($natms!=$temp) {
  printf("DOSCAR info & POSCAR does not match!\n");
  exit;
}

open(PDOS,">pdos_tot");
select PDOS;
$_=<DOSCAR>;
printf("#%s",$_);
$_=substr($_,32,1000);
@tmp=split;
$nedos=$tmp[0];
for($i=0;$i<$nedos;$i++) {
  $_=<DOSCAR>;
  printf("%s",$_);
}
select STDOUT;
close(PDOS);

for($i=0;$i<$nspec;$i++) {
  for($j=0;$j<$atmnum[$i];$j++) {
    $fname=">pdos_".$atmnam[$i].'_'.($j+1);
    open(PDOS,$fname);
    select PDOS;
    $_=<DOSCAR>;
    printf("#%s",$_);
    for($l=0;$l<$nedos;$l++) {
      $_=<DOSCAR>;
      printf("%s",$_);
    }
    select STDOUT;
    close(PDOS);
  }
}
