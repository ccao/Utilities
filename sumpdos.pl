#!/usr/bin/perl

open( HDR, $ARGV[0]);

$i=1;
while( defined($ARGV[$i]) ) {
  local *FILE;
  open(FILE, $ARGV[$i++]);
  push @files, *FILE;
}

$_=<HDR>;
printf("%s", $_);

foreach $f(@files) {
  $_=<$f>;
}

while( <HDR> ) {
  local @data;
  @data = split;
  foreach $f(@files) {
    local @tmp;
    $_=<$f>;
    @tmp = split;
    $n=@tmp;
    for($j=1;$j<$n;$j++) {
      $data[$j]+=$tmp[$j];
    }
  }

  $n=@data;
  for($j=0;$j<$n;$j++) {
    printf("%9.6e  ",$data[$j]);
  }
  printf("\n");
}
