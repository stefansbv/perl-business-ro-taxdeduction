use strict;
use warnings;
use Test::Most;

use Business::RO::TaxDeduction;

subtest 'Test for round_050' => sub {
    foreach my $amount (qw(249 249.01 249.2 249.30 249.31 249.4 249.49)) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 999,
            persons => 0,
        ), "instance for $amount and 0 persons";
        is $brtd->_round_to_int($amount), 249, "round $amount to 249";
    }
    foreach my $amount (qw(249.5 249.59 249.6 249.99 250)) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 999,
            persons => 0,
        ), "instance for $amount and 0 persons";
        is $brtd->_round_to_int($amount), 250, "round $amount to 250";
    }
};

subtest 'Test for persons number range' => sub {
    foreach my $num ( 0 .. 4 ) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 999,
            persons => $num,
        ), "instance for $num person(s)";
        is $brtd->persons, $num, "$num persons";
    }
    foreach my $num ( 4 .. 10 ) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 999,
            persons => $num,
        ), "instance for $num person(s)";
        is $brtd->persons, 4, 'deduction for 4 persons';
    }
};

# 999

subtest 'Test for 999 tax and 0..4 persons' => sub {
    my $results = {
        0 => 250,
        1 => 350,
        2 => 450,
        3 => 550,
        4 => 650,
    };
    foreach my $num ( 0 .. 4 ) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 999,
            persons => $num,
            ),
            "Tax for 999 and $num persons";
        is $brtd->tax_deduction, $results->{$num},
            "Tax for $num persons and 999 VBL";
    }
};

subtest 'Test for 999 tax and 4..10 persons' => sub {
    foreach my $num ( 4 .. 10 ) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 999,
            persons => $num,
        ), "tax for 999 and $num persons";
        is $brtd->tax_deduction, 650, "tax for $num persons and 999 VBL";
    }
};

# 1000

subtest 'Test for 1000 tax and 0..4 persons' => sub {
    my $results = {
        0 => 250,
        1 => 350,
        2 => 450,
        3 => 550,
        4 => 650,
    };
    foreach my $num ( 0 .. 4 ) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 1000,
            persons => $num,
            ),
            "Tax for 1000 and $num persons";
        is $brtd->tax_deduction, $results->{$num},
            "Tax for $num persons and 1000 VBL";
    }
};

subtest 'Test for 1000 tax and 4..10 persons' => sub {
    foreach my $num ( 4 .. 10 ) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 1000,
            persons => $num,
        ), "tax for 1000 and $num persons";
        is $brtd->tax_deduction, 650, "tax for $num persons and 1000 VBL";
    }
};

# 1001

subtest 'Test for 1001 tax and 0..4 persons' => sub {
    my $results = {
        0 => 250,
        1 => 350,
        2 => 450,
        3 => 550,
        4 => 650,
    };
    foreach my $num ( 0 .. 4 ) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 1001,
            persons => $num,
        ), "Tax for 1001 and $num persons";
        is $brtd->tax_deduction, $results->{$num},
            "Tax for $num persons and 1001 VBL";
    }
};

subtest 'Test for 1001 tax and 4..10 persons' => sub {
    foreach my $num ( 4 .. 10 ) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 1001,
            persons => $num,
        ), "tax for 1001 and $num persons";
        is $brtd->tax_deduction, 650, "tax for $num persons and 1001 VBL";
    }
};

# 1080

subtest 'Test for 1080 tax and 0..4 persons' => sub {
    my $results = {
        0 => 240,
        1 => 340,
        2 => 440,
        3 => 530,
        4 => 630,
    };
    foreach my $num ( 0 .. 4 ) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 1080,
            persons => $num,
        ), "Tax for 1080 and $num persons";
        is $brtd->tax_deduction, $results->{$num},
            "Tax for $num persons and 1080 VBL";
    }
};

subtest 'Test for 1080 tax and 4..10 persons' => sub {
    foreach my $num ( 4 .. 10 ) {
        ok my $brtd = Business::RO::TaxDeduction->new(
            vbl     => 1080,
            persons => $num,
        ), "tax for 1080 and $num persons";
        is $brtd->tax_deduction, 630, "tax for $num persons and 1080 VBL";
    }
};

done_testing;
