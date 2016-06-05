package Business::RO::TaxDeduction::Role::Utils;

# ABSTRACT: A utility role

use Moo::Role;
use Business::RO::TaxDeduction::Types qw(
    Int
);

has 'year' => (
    is       => 'ro',
    isa      => Int,
    default  => sub { 2016 },
);

has 'base_year' => (
    is       => 'ro',
    isa      => Int,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        if ($self->year >= 2016) {
            return 2016;
        }
        elsif ($self->year >= 2005) {
            return 2005;
        }
        else {
            die "The tax deduction does not apply before 2005!";
        }
    },
);

1;

__END__

=encoding utf8

=head1 SYNOPSIS

    package Business::RO::TaxDeduction::Ranges;
    with qw(Business::RO::TaxDeduction::Role::Utils);

=head1 DESCRIPTION

A role that incapsulates common attributes required by the
TaxDeduction::Amount and TaxDeduction::Ranges modules.

=head1 INTERFACE

=head2 ATTRIBUTES

=head3 year

The C<year> attribute holds the year of the tax deduction calculation.

=head3 base_year

The C<base_year> attribute represents the year when the methodology of
the tax deduction calculation was introduced.  Is calculated using the
C<year> attribute and currently can take one of the two values: 2005
or 2016.

=head2 INSTANCE METHODS

=cut
