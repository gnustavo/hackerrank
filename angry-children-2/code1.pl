#!/usr/bin/perl

use strict;
use warnings;

# Complete the angryChildren function below.
sub angryChildren {
    my ($k, $packets) = @_;

    my @ordered_packets = sort {$a <=> $b} @$packets;

    my $cdiff = 0;

    for (my $i=0; $i<$k; ++$i) {
        my $y = $ordered_packets[$i];
        foreach my $item (@ordered_packets[0 .. $i-1]) {
            if ($item < $y) {
                $cdiff += $y - $item;
            } else {
                $cdiff += $item - $y;
            }
        }
    }

    my $min_cdiff = $cdiff;

    for (my $i=$k; $i<@ordered_packets; ++$i) {
        my $x = $ordered_packets[$i-$k];
        my $y = $ordered_packets[$i];
        my ($min, $max) = $x<$y ? ($x, $y) : ($y, $x);
        my $y_minus_x = $y - $x;
        my $x_minus_y = $x - $y;
        my $x_plus_y  = $x + $y;
        foreach my $item (@ordered_packets[$i-$k+1 .. $i-1]) {
            if ($item < $min) {
                $cdiff += $y_minus_x;
            } elsif ($item > $max) {
                $cdiff += $x_minus_y;
            } elsif ($x < $y) {
                $cdiff += $x_plus_y - 2*$item;
            } else {
                $cdiff += 2*$item - $x_plus_y;
            }
        }
        $min_cdiff = $cdiff if $cdiff < $min_cdiff;
    }

    return $min_cdiff;
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});
$fptr = *STDOUT;

my $n = <>;
$n =~ s/\s+$//;

my $k = <>;
$k =~ s/\s+$//;

my @packets = ();

for (1..$n) {
    my $packets_item = <>;
    $packets_item =~ s/\s+$//;
    push @packets, $packets_item;
}

my $result = angryChildren $k, \@packets;

print $fptr "$result\n";

close $fptr;
