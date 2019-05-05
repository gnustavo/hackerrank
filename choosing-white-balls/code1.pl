#!/usr/bin/perl

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

    for my $x (0 .. $n - 1) {
        my $chars = substr($balls, $x, 1) . substr($balls, -$x - 1, 1);

        $picks += 1 unless $chars eq 'BB';

        next if $k == 1;        # optimization

        substr(my $lballs = $balls,      $x, 1) = '';
        substr(my $rballs = $balls, -$x - 1, 1) = '';

        if ($chars eq 'WW' || $chars eq 'BB') {
            my $lexpected = expected($n - 1, $k - 1, $lballs);
            my $rexpected = expected($n - 1, $k - 1, $rballs);
            $prob += $lexpected > $rexpected ? $lexpected : $rexpected;
        } elsif ($chars eq 'WB') {
            $prob += expected($n - 1, $k - 1, $lballs);
        } elsif ($chars eq 'BW') {
            $prob += expected($n - 1, $k - 1, $rballs);
        }

    }

    my $result = ($picks + $prob) / $n;
    #warn "expected($n, $k, $balls) = ($picks + $prob) / $n = $result\n";
    return $result;
}

print expected($n, $k, $balls), "\n";
