#!/usr/bin/perl

use 5.026;
use strict;
use warnings;
use List::Util qw(max);

# Complete the arrayManipulation function below.
sub arrayManipulation {
    my ($n, $queries) = @_;

    my $array = [[1, $n, 0]];

    foreach my $query (sort {$b->[0] <=> $a->[0] || $b->[1] <=> $a->[1]} @$queries) {
    #foreach my $query (sort {($b->[1]-$b->[0]) <=> ($a->[1]-$a->[0]) || $b->[0] <=> $a->[0] || $b->[1] <=> $a->[1]} @$queries) {
        query($array, @$query)
    }

    #say scalar(@$array);

    return max(map {$_->[2]} @$array);
}

sub query {
    my ($array, $from, $to, $add) = @_;

    my $i=0;

    while ($array->[$i][1] < $from) {
        ++$i;
    }

    # assert($array->[$i][0] <= $from <= $array->[$i][1])

    if ($array->[$i][0] < $from) {
        my $seq = $array->[$i];
        splice @$array, $i, 1,
            [$seq->[0], $from-1,   $seq->[2]],
            [$from,     $seq->[1], $seq->[2]];
        $i += 1;
    }

    while ($i < @$array && $array->[$i][1] <= $to) {
        $array->[$i][2] += $add;
        ++$i;
    }

    # assert($i == @$array || $array->[$i][1] > $to)

    if ($i < @$array && $array->[$i][0] <= $to) {
        my $seq = $array->[$i];
        splice @$array, $i, 1,
            [$seq->[0], $to,   $seq->[2]+$add],
            [$to+1,     $seq->[1], $seq->[2] ];
    }

    return;
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});
$fptr = *STDOUT;

my $nm = <>;
$nm =~ s/\s+$//;
my @nm = split /\s+/, $nm;

my $n = $nm[0];
$n =~ s/\s+$//;

my $m = $nm[1];
$m =~ s/\s+$//;

my @queries = ();

for (1..$m) {
    my $queries_item = <>;
    $queries_item =~ s/\s+$//;
    my @queries_item = split /\s+/, $queries_item;

    push @queries, \@queries_item;
}

my $result = arrayManipulation $n, \@queries;

print $fptr "$result\n";

close $fptr;
