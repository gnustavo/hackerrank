#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(any);
use Memoize;

my $modulus = 10 ** 9 + 7;

sub comb {
    my ($n, $k) = @_;
    my $c = 1;
    for ($k+1 .. $n) {
        $c *= $_;
        $c %= $modulus;
    }
    for (2 .. $k) {
        $c /= $_;
    }
    return $c;
}

memoize('factorial');
sub factorial {
    my ($n) = @_;
    my $f = 1;
    for (2 .. $n) {
        $f *= $_;
        $f %= $modulus;
    }
    return $f;
}

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

    my $sum     = 0;
    my $term    = factorial($n - $pairs);
    my $sign    = $pairs % 2 ? 1 : -1;

    for (my $k = $pairs; $k >= 0; --$k) {
        $sign *= -1;
        my $factor = comb($pairs, $k) * $sign;
        $sum += (($term / 2 ** ($pairs - $k)) * $factor) % $modulus;
        $sum %= $modulus;
        $term = ($term * (($n * $k) % $modulus)) % $modulus;
    }

    return $sum;
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
