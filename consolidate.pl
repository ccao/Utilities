#!/usr/bin/perl

open( HDR, $ARGV[0]);

$i=1;
while( defined($ARGV[$i]) ) {
  local *FILE;
  open(FILE, $ARGV[$i++]);
  push @files, *FILE;
}


while( <HDR> ) {
  local @data;
  @data = split;
  $nelem=@data;
  if ($nelem>0) {
    printf("%12.9e  %12.9e  %12.9e", $data[0], $data[1], $data[2]);
  }
  foreach $f(@files) {
    local @tmp;
    $_=<$f>;
    @tmp = split;
    if ($nelem>0) {
      printf("  %12.9e", $tmp[2]);
    }
  }
  printf("\n");
}
