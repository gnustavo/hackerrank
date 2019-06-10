#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(max);

# Complete the solve function below.
sub solve {
    my ($arr) = @_;

    my $N = @$arr;
    unshift @$arr, 0;

    my @Lefts = (0, 0);
    $Lefts[$N] = 0;

    for (my $i=2; $i<$N; ++$i) {
        my $ai = $arr->[$i];
        my $j;
        for ($j=$i-1; $j>=1 && $arr->[$j] <= $ai; $j = $Lefts[$j]) { }
        $Lefts[$i] = $j;
    }

    my @Rights = (0, 0);
    $Rights[$N] = 0;

    for (my $i=$N-1; $i>1; --$i) {
        my $ai = $arr->[$i];
        my $j;
        for ($j=$i+1; $j > 0 && $j<=$N && $arr->[$j] <= $ai; $j = $Rights[$j]) { }
        $Rights[$i] = $j;
    }

    return max map {$Lefts[$_] * $Rights[$_]} (1 .. $N);
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});

my $arr_count = <>;
$arr_count =~ s/\s+$//;

my $arr = <>;
$arr =~ s/\s+$//;
my @arr = split /\s+/, $arr;

my $result = solve \@arr;

print $fptr "$result\n";

close $fptr;
