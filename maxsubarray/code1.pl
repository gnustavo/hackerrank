#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(max);

# Complete the maxSubarray function below.
sub maxSubarrays {
    my ($arr, $begin, $size) = @_;

    if ($size == 1) {
        return ($arr->[$begin]) x 3;
    }

    my $half = int($size/2);
    my ($lleft, $lmiddle, $lright) = maxSubarrays($arr, $begin,       $half);
    my ($rleft, $rmiddle, $rright) = maxSubarrays($arr, $begin+$half, $size-$half);

    for (my $i=0, my $sum=0; $i < $size; ++$i) {
        $sum += $arr->[$begin+$i];
        $lleft = $sum if $sum > $lleft;
    }

    for (my $i=$size-1, my $sum=0; $i >= 0; --$i) {
        $sum += $arr->[$begin+$i];
        $rright = $sum if $sum > $rright;
    }

    my $middle = max ($lmiddle, $lright, $lright+$rleft, $rleft, $rmiddle);

    return ($lleft, $middle, $rright);
}

sub maxSubarray {
    my ($arr) = @_;

    my $max_subarr = max maxSubarrays($arr, 0, scalar(@$arr));

    my @sorted_array = sort {$b <=> $a} @$arr;
    my $max_subseq = shift @sorted_array;
    while (@sorted_array) {
        my $next = shift @sorted_array;
        if ($next > 0) {
            $max_subseq += $next;
        } else {
            last;
        }
    }

    return ($max_subarr, $max_subseq);
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});
$fptr = *STDOUT;

my $t = <>;
$t =~ s/\s+$//;

for (my $t_itr = 0; $t_itr < $t; $t_itr++) {
    my $n = <>;
    $n =~ s/\s+$//;

    my $arr = <>;
    $arr =~ s/\s+$//;
    my @arr = split /\s+/, $arr;

    my @result = maxSubarray \@arr;

    print $fptr join " ", @result;
    print $fptr "\n";
}

close $fptr;
