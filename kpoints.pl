#!/usr/bin/perl
$nx=$ARGV[0];
$ny=$ARGV[1];
$nz=$ARGV[2];
$dx=$ARGV[3];
$dy=$ARGV[4];
$dz=$ARGV[5];

printf("%8d\n",$nx*$ny*$nz);
for($ix=0;$ix<$nx;$ix++) {
  for($iy=0;$iy<$ny;$iy++) {
    for($iz=0;$iz<$nz;$iz++) {
      printf("%14.9f%14.9f%14.9f%9.4f\n",($ix+0.5*$dx)/$nx,($iy+0.5*$dy)/$ny,($iz+0.5*$dz)/$nz,1/($nx*$ny*$nz));
    }
  }
}
