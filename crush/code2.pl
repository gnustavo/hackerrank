#!/usr/bin/perl

use strict;
use warnings;

# Complete the arrayManipulation function below.
sub arrayManipulation {
    my ($n, $queries) = @_;

    my @array;

    foreach my $query (@$queries) {
        my ($from, $to, $add) = @$query;
        $array[$from] += $add;
        $array[$to+1] -= $add if $to < $n;
    }

    my $sum = 0;
    my $max = 0;
    foreach (grep {defined $_} @array) {
        $sum += $_;
        $max = $sum if $sum > $max;
    }

    return $max;
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
