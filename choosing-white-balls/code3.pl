#!/usr/bin/perl

### PRODUCES WRONG ANSWERS!!

use strict;
use warnings;
use Memoize;
memoize('expected');

my $nk = <>;
$nk =~ s/\s+$//;
my @nk = split /\s+/, $nk;

my $n = $nk[0];
$n =~ s/\s+$//;

my $k = $nk[1];
$k =~ s/\s+$//;

my $balls = <>;
chomp($balls);

# Write Your Code Here
sub expected {
    my ($n, $k, $balls) = @_;

    return 0 if $k == 0;

    my $picks = 0;
    my $prob  = 0;

    for my $l (0 .. int($n / 2)) {
        my $r = $n - 1 - $l;
        my $lchar = substr(my $lballs = $balls, $l, 1, '');
        my ($rchar, $rballs);
        if ($l == $r) {
            $rchar  = $lchar;
            $rballs = $lballs;
        } else {
            $rchar = substr($rballs = $balls, $r, 1, '');
        }

        $picks += 1 if $lchar eq 'W' || $rchar eq 'W';

        next if $k == 1;        # optimization

        my $subprob;

        if ($lchar eq $rchar) {
            my $lexpected = expected($n - 1, $k - 1, $lballs);
            my $rexpected = expected($n - 1, $k - 1, $rballs);
            $subprob = $lexpected > $rexpected ? $lexpected : $rexpected;
            $subprob *= 2 unless $l == $r;
        } elsif ($lchar eq 'W') {
            $subprob = 2 * expected($n - 1, $k - 1, $lballs);
        } else {
            $subprob = 2 * expected($n - 1, $k - 1, $rballs);
        }

        $prob += $subprob;
    }

    return ($picks + $prob) / $n;
}

print expected($n, $k, $balls), "\n";
