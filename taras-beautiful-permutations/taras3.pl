#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(any);
use Math::BigInt;
use Memoize;

my $MODULUS = Math::BigInt->new(10 ** 9 + 7);

#memoize('bp', NORMALIZER => sub { return join(',', $_[0]->bstr(), $_[1]->bstr()) });

sub bp {
    my ($n, $p) = @_;

    my $bp;

    if ($p->is_zero()) {
        $bp = $n->bfac();
    } elsif ($p->is_one()) {
        $bp = bp($n - 1, $p - 1)->bmul($n - 2)->bdiv(2);
    } else {
        $bp = (bp($n - 1, $p - 1) + bp($n - 2, $p - 2)->bmul($p - 1))->bmul($n - 2)->bdiv(2);
    }

    warn "bp($n, $p) = $bp\n";

    return $bp->bmod($MODULUS);
}

#
# Complete the beautifulPermutations function below.
#
sub beautifulPermutations {
    my ($arr) = @_;

    my $n = Math::BigInt->new(scalar @$arr);

    my %bag;
    ++$bag{$_} foreach @$arr;

    my $pairs = Math::BigInt->new(scalar grep {$_ == 2} values %bag);

    die "At least one number is repeated more than twice\n"
        if any {$_ > 2} values %bag;

    return bp($n, $pairs);
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});
$fptr = *STDOUT;

my $t = <>;
$t =~ s/\s+$//;

for (my $t_itr = 0; $t_itr < $t; $t_itr++) {
    my $arr_count = <>;
    $arr_count =~ s/\s+$//;

    my $arr = <>;
    $arr =~ s/\s+$//;
    my @arr = split /\s+/, $arr;

    my $result = beautifulPermutations \@arr;

    print $fptr "$result\n";
}

close $fptr;
