#!/usr/bin/perl

use strict;
use warnings;

# Complete the abbreviation function below.
sub abbreviation {
    my ($a, $b) = @_;

    # Let's take from the first string any lower-case letter not contained in
    # the second string, as as optimization step.
    my %valid_letters = map {(lc($_) => undef)} split //, $b;
    my $valid_letters = join('', keys %valid_letters);
    $valid_letters .= uc $valid_letters;
    warn ">>> $a\n";
    $a =~ tr/$valid_letters//dc;

    my $regex = join('[a-z]*?', map {"[" . lc($_) . uc($_) . "]"} split //, $b);

    warn "$a =~ $regex\n";
    return $a =~ /^[a-z]*?$regex[a-z]*?$/ ? 'YES' : 'NO';
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});
$| = 1;
$fptr = *STDOUT;

my $q = <>;
$q =~ s/\s+$//;

for (my $q_itr = 0; $q_itr < $q; $q_itr++) {
    my $a = <>;
    chomp($a);

    my $b = <>;
    chomp($b);

    my $result = abbreviation $a, $b;

    print $fptr "$result\n";
}

close $fptr;
