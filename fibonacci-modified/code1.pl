#!/usr/bin/perl

use 5.026;
use strict;
use warnings;
use Math::BigInt;

# Complete the fibonacciModified function below.
sub fibonacciModified {
    my $t1 = Math::BigInt->new(shift);
    my $t2 = Math::BigInt->new(shift);
    my $n  = int(shift);

    for (my $i=3; $i <= $n; ++$i) {
        my $t3 = $t2->copy()->bmuladd($t2, $t1);
        ($t1, $t2) = ($t2, $t3);
    }

    return $t2;
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});
$fptr = *STDOUT;

my $t1T2n = <>;
$t1T2n =~ s/\s+$//;
my @t1T2n = split /\s+/, $t1T2n;

my $t1 = $t1T2n[0];
$t1 =~ s/\s+$//;

my $t2 = $t1T2n[1];
$t2 =~ s/\s+$//;

my $n = $t1T2n[2];
$n =~ s/\s+$//;

my $result = fibonacciModified $t1, $t2, $n;

print $fptr $result, "\n";

close $fptr;
