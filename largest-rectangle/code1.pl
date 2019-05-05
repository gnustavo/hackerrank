#!/usr/bin/perl

use strict;
use warnings;

# Complete the largestRectangle function below.
sub largestRectangle {
    my ($h) = @_;

    return largest($h, 0, scalar(@$h), 0);
}

sub largest {
    my ($h, $begin, $end, $height) = @_;

    warn "largest($begin, $end, $height)\n";

    my $largest = ($end - $begin) * $height;

    my $new_height = 10 ** 6;   # highest height
    foreach (@{$h}[$begin .. $end-1]) {
        $new_height = $_ if $_ < $new_height;
    }
    $new_height += 1 if $new_height == $height;

    my ($i, $j);
    $i = $begin;
    while ($i<$end) {
        ++$i while $i<$end && $h->[$i] < $new_height;
        last if $i==$end;
        $j = $i+1;
        ++$j while $j<$end && $h->[$j] >= $new_height;
        my $sublargest = largest($h, $i, $j, $new_height);
        $largest = $sublargest if $sublargest > $largest;
        $i = $j;
    }

    #warn ' ' x $height, "$largest\n";

    return $largest;
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});
$fptr = *STDOUT;

my $n = <>;
$n =~ s/\s+$//;

my $h = <>;
$h =~ s/\s+$//;
my @h = split /\s+/, $h;

my $result = largestRectangle \@h;

print $fptr "$result\n";

close $fptr;
