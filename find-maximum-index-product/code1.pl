#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(max);

# Complete the solve function below.
sub solve {
    my ($arr) = @_;

    # my @indexes = map {[$_+1, left($arr, $_), right($arr, $_)]} (0 .. $#$arr);
    # my @products = map {$_->[1] * $_->[2]} @indexes;
    # return max @products;

    return max map {left($arr, $_) * right($arr, $_)} (0 .. $#$arr);
}

sub left {
    my ($arr, $i) = @_;
    my $ai = $arr->[$i];
    for (my $j=$i-1; $j>=0; --$j) {
        return $j+1 if $arr->[$j] > $ai;
    }
    return 0;
}

sub right {
    my ($arr, $i) = @_;
    my $ai = $arr->[$i];
    for (my $j=$i+1; $j<=$#$arr; ++$j) {
        return $j+1 if $arr->[$j] > $ai;
    }
    return 0;
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
