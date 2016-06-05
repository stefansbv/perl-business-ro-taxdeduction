package Business::RO::TaxDeduction::Ranges;

# ABSTRACT: Deduction ranges by year

use 5.010001;
use utf8;
use Moo;
use Business::RO::TaxDeduction::Types qw(
    Int
);

has 'year' => (
    is       => 'ro',
    isa      => Int,
    required => 1,
    default  => sub { 2016 },
);

has 'base_year' => (
    is       => 'ro',
    isa      => Int,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        my $year = $self->year >= 2016  ? 2016 : 2005;
        return $year;
    },
);

has 'vbl_min' => (
    is      => 'ro',
    isa     => Int,
    lazy    => 1,
    default => sub {
        my $self = shift;
        return 1000 if $self->base_year == 2005;
        return 1500 if $self->base_year == 2016;
        die "Not a valid year: " . $self->base_year;
    },
);

has 'vbl_max' => (
    is      => 'ro',
    isa     => Int,
    lazy    => 1,
    default => sub {
        my $self = shift;
        return 3000 if $self->base_year == 2005;
        return 3000 if $self->base_year == 2016;
        die "Not a valid year: " . $self->base_year;
    },
);

has 'f_min' => (
    is      => 'ro',
    isa     => Int,
    lazy    => 1,
    default => sub {
        my $self = shift;
        return 1000 if $self->base_year == 2005;
        return 1500 if $self->base_year == 2016;
        die "Not a valid year: " . $self->base_year;
    },
);

has 'f_max' => (
    is       => 'ro',
    isa      => Int,
    lazy    => 1,
    default => sub {
        my $self = shift;
        return 2000 if $self->base_year == 2005;
        return 1500 if $self->base_year == 2016;
        die "Not a valid year: " . $self->base_year;
    },
);

1;

__END__

=encoding utf8

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 INTERFACE

=head2 ATTRIBUTES

=head3 year

The year in which the calculus.

=head3 base_year

The year from which the formula was introduced.

=head3 vbl_min

The minimum VBL used in the tax deduction formula.

=head3 vbl_max

The maximum VBL used in the tax deduction formula.

=head3 f_min

The amount used in the tax deduction formula:

    250 x [ 1 - ( VBL - $f_min=1000 ) / 2000 ]  # 2005
    300 x [ 1 - ( VBL - $f_min=1500 ) / 1500 ]  # 2016

=head3 f_max

The amount used in the tax deduction formula:

    250 x [ 1 - ( VBL - 1000 ) / $f_max=2000 ]  # 2005
    300 x [ 1 - ( VBL - 1500 ) / $f_max=1500 ]  # 2016

=head2 INSTANCE METHODS

=cut
