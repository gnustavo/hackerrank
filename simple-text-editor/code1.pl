#!/usr/bin/env perl

use strict;
use warnings;

my $S = '';

my $Q = <>;

my @undo;

while (<>) {
    chomp;
    my ($t, $arg) = split / /;
    if ($t == 1) {
        push @undo, [$t, length($arg)];
        $S .= $arg;
    } elsif ($t == 2) {
        push @undo, [$t, substr($S, -$arg)];
        substr($S, -$arg) = '';
    } elsif ($t == 3) {
        print substr($S, $arg-1, 1), "\n";
    } elsif ($t == 4) {
        my $undo = pop @undo;
        if ($undo->[0] == 1) {
            substr($S, -$undo->[1]) = '';
        } elsif ($undo->[0] == 2) {
            $S .= $undo->[1];
        }
    }
}
