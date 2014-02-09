#!/usr/bin/perl
$nq=0;

while(defined($_=<>)) {
  $nq++;
  $_=<>;
  $_=<>;
  @k=split;
  printf("%12.4f%12.4f%12.4f\n",$k[2],$k[3],$k[4]);
  $_=<>;
  $_=<>;
  $nm=0;
  until (/(\*)+/) {
    if(/omega/) {
      @tmp=split /=/;
      $_=$tmp[1];
      @tmp=split;
      printf("%14.6E",($tmp[0]/3289.828)**2);
      $nm++;
      if($nm%6==0) {
        printf("\n");
      }
    }
    $_=<>;
  }
  printf("\n");
}

printf("nq=%d\n",$nq);
