#!/usr/bin/perl

use 5.026;
use strict;
use warnings;

my $nk = <>;
$nk =~ s/\s+$//;
my @nk = split /\s+/, $nk;

my $n = $nk[0];
$n =~ s/\s+$//;

my $k = $nk[1];
$k =~ s/\s+$//;

my $balls = <>;
chomp($balls);

# Convert the string in a bitvector mapping 'B' to 0 and 'W' to 1.
my $bits = 0;
for my $char (reverse split //, $balls) {
    $bits <<= 1;
    if ($char eq 'W') {
        $bits += 1;
    }
}

print expected($n, $k, $bits), "\n";

# Write Your Code Here
sub expected {
    my ($n, $k, $bits) = @_;

    return 0 if $k == 0;

    state $cache = {};

    my $key = "$n,$bits";

    return $cache->{$key} if exists $cache->{$key};

    my $total = 0;

    for (my $i = 0; 2*$i < $n; ++$i) {
        my $add = 0;
        for my $j ($i, $n - 1 - $i) {
            my $a = ($bits >> $j) & 1 ? 1 : 0;

            if ($k > 1) {
                my $mask = (1 << $j) - 1;
                my $b = ($bits & $mask) | (($bits >> 1) & ~$mask); # CHECK negation of signed int!
                $a += expected($n-1, $k-1, $b);
                #printf STDERR "n = $n, k = $k, bits = %#0b, i = $i, j = $j, mask = %#0b, a = $a, b = %#0b\n", $bits, $mask, $b;
            }

            $add = $a if $a > $add;
        }

        if ((2 * $i + 1) == $n) {
            $total += $add;
        } else {
            $total += 2 * $add;
        }
    }

    $cache->{$key} = $total / $n;
    #printf STDERR "expected($n, $k, %#0*b) = $total / $n = $result\n", $n, $bits;
    return $cache->{$key};
}
