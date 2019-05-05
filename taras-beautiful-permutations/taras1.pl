#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(any sum0);
use bigint;

my $MODULUS = 10 ** 9 + 7;

sub bp_ones {
    my ($ones) = @_;

    return $ones->bfac()->bmod($MODULUS);
}

sub bp_only_twos {
    my ($twos) = @_;

    if ($twos < 2) {
        return 0;
    } elsif ($twos == 2) {
        return 2;
    } else {
        my $base = 2 * ($twos - 1);
        return (bp_only_twos($twos - 1) * ($base * ($base + 1)) / 2) % $MODULUS;
    }
}

sub bp_ones_and_twos {
    my ($ones, $twos) = @_;

    if ($twos == 0) {
        return bp_ones($ones);
    } else {
        my $base = $ones + 2 * ($twos - 1);
        return (bp_ones_and_twos($ones, $twos - 1) * ($base * ($base + 1)) / 2) % $MODULUS;
    }
}

#
# Complete the beautifulPermutations function below.
#
sub beautifulPermutations {
    my ($arr) = @_;

    my %bag;
    ++$bag{$_} foreach @$arr;

    my $ones = 0 + grep {$_ == 1} values %bag;
    my $twos = 0 + grep {$_ == 2} values %bag;

    print "$ones $twos\n";

    die "At least one number is repeated more than twice\n"
        if any {$_ > 2} values %bag;

    if ($ones == 0) {
        return bp_only_twos($twos);
    } else {
        return bp_ones_and_twos($ones, $twos);
    }
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
