#!/usr/bin/perl

use strict;
use warnings;

# Complete the queensAttack function below.
sub queensAttack {
    my ($n, $k, $r_q, $c_q, $obstacles) = @_;

    my %obstacles;
    foreach my $obstacle (@$obstacles) {
        $obstacles{$obstacle->[0]-1}{$obstacle->[1]-1} = undef;
    }

    my $attacks = 0;

    foreach my $row_dir (-1 .. 1) {
        foreach my $col_dir (-1 .. 1) {
            next if $row_dir == 0 && $col_dir == 0;
            for (my $r=$r_q-1+$row_dir, my $c=$c_q-1+$col_dir; 0 <= $r && $r < $n && 0 <= $c && $c < $n; $r += $row_dir, $c += $col_dir) {
                last if exists $obstacles{$r}{$c};
                ++$attacks;
            }
        }
    }

    return $attacks;
}

open(my $fptr, '>', $ENV{'OUTPUT_PATH'});
$fptr = *STDOUT;

my $nk = <>;
$nk =~ s/\s+$//;
my @nk = split /\s+/, $nk;

my $n = $nk[0];
$n =~ s/\s+$//;

my $k = $nk[1];
$k =~ s/\s+$//;

my $r_qC_q = <>;
$r_qC_q =~ s/\s+$//;
my @r_qC_q = split /\s+/, $r_qC_q;

my $r_q = $r_qC_q[0];
$r_q =~ s/\s+$//;

my $c_q = $r_qC_q[1];
$c_q =~ s/\s+$//;

my @obstacles = ();

for (1..$k) {
    my $obstacles_item = <>;
    $obstacles_item =~ s/\s+$//;
    my @obstacles_item = split /\s+/, $obstacles_item;

    push @obstacles, \@obstacles_item;
}

my $result = queensAttack $n, $k, $r_q, $c_q, \@obstacles;

print $fptr "$result\n";

close $fptr;
