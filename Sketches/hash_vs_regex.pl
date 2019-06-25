#!/usr/bin/env perl
use v5.28;
use strict;
use warnings;

my $str = lc('READ( 1, 2, ERR=8, END=9, IOSTAT=N ) X');
my $info={};
    if ($str=~/read/) {
$info->{'ReadCall'}=1;
}
my $count=0;
# no cond: 3.1 s
# regex: 10.1
# hash: 5.6 s
for my $i (1..100_000_000) {
    #if ($str=~/read/) {
    if (exists $info->{'ReadCall'}) {
        $count+=$i;
    }
}
#say $count;
