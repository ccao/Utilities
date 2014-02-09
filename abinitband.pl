#!/usr/bin/perl

print "Using prefix $ARGV[0] and dataset $ARGV[1].\n";

open(FILE, $ARGV[0].".out");
$idset=0;

while($_=<FILE>) {
  if(/space primitive vectors, cartesian coordinates/) {
    for($i=0; $i<3; $i++) {
      $_=<FILE>;
      @tmp=split;
      $g[0]=$tmp[5];$g[1]=$tmp[6];$g[2]=$tmp[7];
      push @gvec, [ @g ];
    }
  }

  if(/Eigenvalues/) {
    $idset++;
    if($idset==$ARGV[1]) {
      @tmp=split;
      $nkpt=$tmp[6];

      $kpt[0]=0.0;
      for($ik=0; $ik<$nkpt; $ik++) {
        $_=<FILE>;
        @expr=split(/,/);
        @tmp=split(/=/, $expr[1]);
        $nbnd=$tmp[1];
        @tmp=split(/=/, $expr[3]);
        $_=$tmp[1];
        @tmp=split;
        $knew[0]=$tmp[0]; $knew[1]=$tmp[1]; $knew[2]=$tmp[2];
        if($ik>0) {
          $kpt[$ik]=$kpt[$ik-1]+distance(\@knew,\@kold,\@gvec);
#          printf("%12.9f %12.9f\n",distance(\@knew,\@kold,\@gvec),$kpt[$ik]);
          @kold=@knew;
        }
        for($ib=0; $ib<$nbnd; $ib++) {
          if($ib%8==0) {
            $line=<FILE>;
            @tmp=$line=~/.{10}/g;
          }
          $etmp[$ib]=$tmp[$ib%8];
        }
        push @eig, [ @etmp ];
      }
    }
  }
}

for($ib=0; $ib<$nbnd; $ib++) {
  for($ik=0; $ik<$nkpt; $ik++) {
    printf("%12.9f  %12.4f\n",$kpt[$ik],$eig[$ik][$ib]);
  }
  printf("\n");
}


sub distance{
  my($t1, $t2, $t3)=@_;
  my @k1=@$t1;
  my @k2=@$t2;
  my @gv=@$t3;
  for($ii=0; $ii<3; $ii++) {
    $dk[$ii]=($k1[0]-$k2[0])*$gv[0][$ii]+($k1[1]-$k2[1])*$gv[1][$ii]+($k1[2]-$k2[2])*$gv[2][$ii];
  }
  return sqrt($dk[0]*$dk[0]+$dk[1]*$dk[1]+$dk[2]*$dk[2]);
}
