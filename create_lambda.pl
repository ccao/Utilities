#!/usr/bin/perl
$narg=@ARGV;

if ($narg<2) {
  printf(" Usage: create_lambda.pl \$PREFIX \$NQPTS\n");
}
else {

  $nqpt=$ARGV[1];
  $prefix=$ARGV[0];
  
  printf(" %9.6f %9.6f %3d\n", 12.0, 0.10, 0);
  printf(" %3d\n", $nqpt);
  
  for ($i=0; $i<$nqpt; $i++) {
    local *FILE;
    $fn=sprintf("%s%d",$prefix,$i+1);
    open(FILE, $fn);
    $first=1;
    $nqeq=0;
    while(<FILE>) {
      if (index($_, "q =")!=-1) {
        if ($first==1) {
          $first=0;
          @data=split;
          $tmp[0]=$data[3]; $tmp[1]=$data[4]; $tmp[2]=$data[5];
          push @qpt, [ @tmp ];
        }
        else {
          $nqeq++;
        }
      }
    }
    printf("%14.9f%14.9f%14.9f%4d\n", $qpt[$i][0], $qpt[$i][1], $qpt[$i][2], $nqeq);
  }
  
  for ($i=0; $i<$nqpt; $i++) {
    printf("elph.%9.6f.%9.6f.%9.6f\n",$qpt[$i][0],$qpt[$i][1],$qpt[$i][2]);
  }
  
  printf(" %9.6f\n", 0.12);
}
