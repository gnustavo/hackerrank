#!/usr/bin/perl

use strict;
use warnings;

my @magic_squares = (
    [[2, 7, 6], [9, 5, 1], [4, 3, 8]],
    [[2, 9, 4], [7, 5, 3], [6, 1, 8]],
    [[4, 3, 8], [9, 5, 1], [2, 7, 6]],
    [[4, 9, 2], [3, 5, 7], [8, 1, 6]],
    [[6, 1, 8], [7, 5, 3], [2, 9, 4]],
    [[6, 7, 2], [1, 5, 9], [8, 3, 4]],
    [[8, 1, 6], [3, 5, 7], [4, 9, 2]],
    [[8, 3, 4], [1, 5, 9], [6, 7, 2]],
);

# Complete the formingMagicSquare function below.
sub formingMagicSquare {
    my ($square) = @_;

    my $min_diff = 2 ** 31;     # "infinity"

    foreach my $magic (@magic_squares) {
        my $square_diff = 0;
        for my $i (0 .. 2) {
            for my $j (0 .. 2) {
                if (my $cell_diff = $square->[$i][$j] - $magic->[$i][$j]) {
                    $square_diff += $cell_diff > 0 ? $cell_diff : - $cell_diff;
                }
            }
        }
        $min_diff = $square_diff if $square_diff < $min_diff;
    }

    return $min_diff;
}

$ENV{'OUTPUT_PATH'} = '/dev/pts/0';
open(my $fptr, '>', $ENV{'OUTPUT_PATH'});

my @s = ();

for (1..3) {
    my $s_item = <>;
    $s_item =~ s/\s+$//;
    my @s_item = split /\s+/, $s_item;

    push @s, \@s_item;
}

my $result = formingMagicSquare \@s;

print $fptr "$result\n";

close $fptr;
