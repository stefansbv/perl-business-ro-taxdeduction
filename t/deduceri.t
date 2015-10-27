use strict;
use warnings;
use Test::Most;

use Business::RO::TaxDeduction;

foreach my $pers_no ( 0 .. 4 ) {
    my $test_file_name = qq{t/deduceri-${pers_no}.txt};

    # Import test data
    open my $test_data_fh, '<', $test_file_name
        or die "Cant't read test file '$test_file_name': $!";

    my @data;
    while (<$test_data_fh>) {
        next if /^#/;    # skip comments
        chomp;
        push @data, [ split /\t/ ];
    }

    foreach my $row (@data) {

        # Test for min and max VBL
        foreach my $vbl ( $row->[0], $row->[1] ) {
            ok my $brtd = Business::RO::TaxDeduction->new(
                vbl     => $vbl,
                persons => $pers_no,
                ),
                "Test for $pers_no persons and $vbl VBL";
            is $brtd->tax_deduction, $row->[2],
                "Tax for $pers_no persons and $vbl VBL";
        }
    }
}

done_testing;
