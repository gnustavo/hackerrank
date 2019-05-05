#!/usr/bin/perl

use strict;
use warnings;
no warnings 'recursion';
use feature 'state';
use List::Util qw(any);

my $MOD = 10 ** 9 + 7;

sub facmod {
    my ($n) = @_;
    state $cache = {};
    unless (exists $cache->{$n}) {
        my $f = 1;
        for (my $i = $n; $i > 1; --$i) {
            $f = ($f * $i) % $MOD;
        }
        $cache->{$n} = $f;
    }
    #warn "facmod($n) = $cache->{$n}\n";
    return $cache->{$n};
}

sub combmod {
    my ($p, $k) = @_;
    # assert $p >= $k
    state $cache = {};
    my $key = "$p,$k";
    unless (exists $cache->{$key}) {
        if ($k == 0 || $p == $k) {
            $cache->{$key} = 1;
        } elsif ($k == 1) {
            $cache->{$key} = $p % $MOD;
        } else {
            $cache->{$key} = (combmod($p - 1, $k - 1) + combmod($p - 1, $k)) % $MOD;
        }
    }
    #warn "combmod($p, $k) = $cache->{$key}\n";
    return $cache->{$key};
}

sub termmod_fast {
    my ($n, $p, $k) = @_;
    # assert $n > $p >= $k
    state $cache = {};
    my $key = "$n,$p,$k";
    unless (exists $cache->{$key}) {
        my $term = 1;
        my $i    = $n - $k;
        my $pow  = $p - $k;

        my $j;
        if ($i % 2 == 0) {
            $j = $i;
            --$i;
        } else {
            $term = ($term * $i) % $MOD;
            $j = $i - 1;
            $i -= 2;
        }

        for (; $pow > 0 && $j > 1; $j -= 2, --$pow) {
            $term = ($term * ($j/2)) % $MOD;
        }
        for (; $i > $j; $i -= 2) {
            $term = ($term * $i) % $MOD;
        }
        if ($j > 1) {
            $term = ($term * facmod($j)) % $MOD;
        }
        $cache->{$key} = $term;
    }
    #warn "termmod($key) = $cache->{$key}\n";
    return $cache->{$key};
}

sub termmod {
    my ($n, $p, $k) = @_;
    # assert $n > $p >= $k
    state $cache = {};
    my $key = "$n,$p,$k";
    unless (exists $cache->{$key}) {
        my $term = 1;
        my $pow = $p - $k;
        for my $i (2 .. $n - $k) {
            while ($pow > 0 && $i > 1 && $i % 2 == 0) {
                $pow -= 1;
                $i /= 2;
            }
            $term = ($term * $i) % $MOD;
        }
        die "termmod($key): power of two rested $pow"
            if $pow > 0;
        $cache->{$key} = $term;
    }
    #warn "termmod($key) = $cache->{$key}\n";
    return $cache->{$key};
}

sub termmod_recursive {
    my ($n, $p, $k) = @_;
    # assert $n > $p >= $k
    state $cache = {};
    my $key = "$n,$p,$k";
    unless (exists $cache->{$key}) {
        if ($p == $k) {
            $cache->{$key} = facmod($n, $k);
        } else {
            my $previous = termmod($n - 1, $p - 1, $k);
            my $nk = $n - $k;
            if ($previous % 2 == 0) {
                $previous /= 2;
            } elsif ($nk % 2 == 0) {
                $nk /= 2;
            } else {
                die "termmod($key): power of two rested $previous,$nk";
            }
            $cache->{$key} = ($previous * $nk) % $MOD;
        }
    }
    warn "termmod_recursive($key) = $cache->{$key}\n";
    return $cache->{$key};
}

#
# Complete the beautifulPermutations function below.
#
sub beautifulPermutations {
    my ($arr) = @_;

    my %bag;
    ++$bag{$_} foreach @$arr;

    die "At least one number is repeated more than twice\n"
        if any {$_ > 2} values %bag;

    my $n     = @$arr;
    my $pairs = grep {$_ == 2} values %bag;

    my @sum   = (0, 0);

    #warn sprintf('n=%d pairs=%d', $n, $pairs), "\n";

    for (my $k = 0; $k <= $pairs; ++$k) {
        my $comb = combmod($pairs, $k);

        my $term = termmod_fast($n, $pairs, $k);

        my $sum = \$sum[$k % 2];

        $$sum = ($$sum + ($comb * $term) % $MOD) % $MOD;

        #warn sprintf('k=%d comb=%d term=%d sum0=%d sum1=%d', $k, $comb, $term, $sum[0], $sum[1]), "\n";
    }

    return ($sum[0] - $sum[1]) % $MOD;
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
