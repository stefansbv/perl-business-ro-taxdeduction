#!perl -T
use 5.010;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Business::RO::TaxDeduction' ) || print "Bail out!\n";
}

diag( "Testing Business::RO::TaxDeduction $Business::RO::TaxDeduction::VERSION, Perl $], $^X" );
