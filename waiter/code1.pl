#!/usr/bin/perl

use 5.026;
use strict;
use warnings;

#
# Complete the waiter function below.
#
sub waiter {
    my ($plates, $Q) = @_;

    my (@A, @B);

    $A[0] = $plates;

    for my $i (1 .. $Q) {
        while (my $plate = pop @{$A[$i-1]}) {
            if (is_divisible_by_ith_prime($plate, $i)) {
                push @{$B[$i]}, $plate;
            } else {
                push @{$A[$i]}, $plate;
            }
        }
    }

    my @result;

    for my $pile (grep {defined} @B[1 .. $Q], $A[$Q]) {
        push @result, reverse @$pile;
    }

    return @result;
}

sub is_divisible_by_ith_prime {
    my ($n, $i) = @_;

    state $primes = primes(10000);

    return ($n % $primes->[$i]) == 0;
}

sub primes {
    my ($upper) = @_;

    my @primes = (1);           # zero-th prime

    my @sieve = (0, 0);

    for (my $i=2; $i <= $upper; ++$i) {
        unless (defined $sieve[$i]) {
            $sieve[$i] = 1;
            push @primes, $i;
        }
        for (my $j=2*$i; $j <= $upper; $j += $i) {
            $sieve[$j] = 0;
        }
    }

    return \@primes;
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});

my $nq = <>;
$nq =~ s/\s+$//;
my @nq = split /\s+/, $nq;

my $n = $nq[0];
$n =~ s/\s+$//;

my $q = $nq[1];
$q =~ s/\s+$//;

my $number = <>;
$number =~ s/\s+$//;
my @number = split /\s+/, $number;

my @result = waiter \@number, $q;

print $fptr join "\n", @result;
print $fptr "\n";

close $fptr;
