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

    my $n = @$arr;

    my %bag;
    ++$bag{$_} foreach @$arr;

    die "At least one number is repeated more than twice\n"
        if any {$_ > 2} values %bag;

    my $pairs   = grep {$_ == 2} values %bag;

    warn "n=$n pairs=$pairs\n";

    my $Sum     = Math::BigInt->bzero();
    my $Term    = Math::BigInt->new($n - $pairs)->bfac();
    my $Two     = Math::BigInt->new(2);
    my $sign    = $pairs % 2 ? 1 : -1;
    my $Modulus = Math::BigInt->new(10 ** 9 + 7);

    for (my $k = $pairs; $k >= 0; --$k, $Term->bmul($n - $k)) {
        $sign *= -1;
        my $factor = Math::BigInt->new($pairs)->bfac()->bdiv(Math::BigInt->new($k)->bfac())->bdiv(Math::BigInt->new($pairs)->bsub($k)->bfac())->bmul($sign);
        $Sum->badd($Term->copy()->bdiv($Two->copy()->bpow($pairs - $k))->bmul($factor))->bmod($Modulus);
        warn "k=$k comb=$factor Sum=$Sum\n";
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
