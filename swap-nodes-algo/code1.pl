#!/usr/bin/perl

use strict;
use warnings;

#
# Complete the swapNodes function below.
#
sub swapNodes {
    my ($tree, $queries) = @_;

    # Let's unshift a dummy at the start of the $tree so that we can work with
    # indices starting at 1.
    unshift @$tree, [];

    my @traversals;

    foreach my $k (@$queries) {
        swap($tree, 1, 1, $k);
        in_order_traversal($tree, 1, \my @traversal);
        push @traversals, \@traversal;
    }

    return @traversals;
}

sub swap {
    my ($tree, $node, $level, $swap_at) = @_;

    foreach my $child (@{$tree->[$node]}[0 .. 1]) {
        swap($tree, $child, $level+1, $swap_at)
            unless $child == -1;
    }
    if (($level % $swap_at) == 0) {
        @{$tree->[$node]}[0, 1] = @{$tree->[$node]}[1, 0];
    }
}

sub in_order_traversal {
    my ($tree, $node, $traversal) = @_;

    if ($tree->[$node][0] != -1) {
        in_order_traversal($tree, $tree->[$node][0], $traversal);
    }
    push @$traversal, $node;
    if ($tree->[$node][1] != -1) {
        in_order_traversal($tree, $tree->[$node][1], $traversal);
    }
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});
$fptr = *STDOUT;

my $n = <>;
$n =~ s/\s+$//;

my @indexes = ();

for (1..$n) {
    my $indexes_item = <>;
    $indexes_item =~ s/\s+$//;
    my @indexes_item = split /\s+/, $indexes_item;

    push @indexes, \@indexes_item;
}

my $queries_count = <>;
$queries_count =~ s/\s+$//;

my @queries = ();

for (1..$queries_count) {
    my $queries_item = <>;
    $queries_item =~ s/\s+$//;
    push @queries, $queries_item;
}

my @result = swapNodes \@indexes, \@queries;

print $fptr join "\n", map{ join " ", @{$_} } @result;
print $fptr "\n";

close $fptr;
