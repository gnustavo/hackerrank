#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(any);
use Math::BigInt try => 'GMP,Pari';

#
# Complete the beautifulPermutations function below.
#
sub beautifulPermutations {
    my ($arr) = @_;

    my %bag;
    ++$bag{$_} foreach @$arr;

    die "At least one number is repeated more than twice\n"
        if any {$_ > 2} values %bag;

    my $N        = Math::BigInt->new(scalar @$arr);
    my $Pairs    = Math::BigInt->new(scalar grep {$_ == 2} values %bag);
    my $PairsFac = $Pairs->copy()->bfac();
    my $Two      = Math::BigInt->new(2);
    my $Modulus  = Math::BigInt->new(10 ** 9 + 7);
    my $sign     = $Pairs->is_even() ? -1 : 1;

    my $Sum      = Math::BigInt->bzero();

    for (
        my ($K, $NMK, $Term) = ($Pairs->copy(), $N->copy()->bsub($Pairs), $N->copy()->bsub($Pairs)->bfac());
        $K->is_positive() || $K->is_zero();
        $Term->bmul($NMK), $NMK->binc(), $K->bdec()
    ) {
        $sign *= -1;
        my $factor = $PairsFac->copy()->bdiv($K->copy()->bfac())->bdiv($Pairs->copy()->bsub($K)->bfac())->bmul($sign);
        $Sum->badd($Term->copy()->bdiv($Two->copy()->bpow($Pairs->copy()->bsub($K)))->bmul($factor))->bmod($Modulus);
    }

    return $Sum;
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});
$fptr = *STDOUT;

my $t = <>;
$t =~ s/\s+$//;

for (my $t_itr = 0; $t_itr < $t; $t_itr++) {
    my $arr_count = <>;
    $arr_count =~ s/\s+$//;

    my $arr = <>;
    $arr =~ s/\s+$//;
    my @arr = split /\s+/, $arr;

    my $result = beautifulPermutations \@arr;

    print $fptr "$result\n";
}

close $fptr;
