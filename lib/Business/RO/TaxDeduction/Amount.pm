package Business::RO::TaxDeduction::Amount;

# ABSTRACT: Personal deduction amount by year and persons

use 5.010001;
use utf8;
use Moo;
use MooX::HandlesVia;
use Business::RO::TaxDeduction::Types qw(
    Int
    HashRef
    TaxPersons
);

has 'persons' => (
    is       => 'ro',
    isa      => TaxPersons,
    required => 1,
    coerce   => 1,
    default  => sub { 0 },
);

has 'year' => (
    is       => 'ro',
    isa      => Int,
    required => 1,
);

has '_deduction_map_2005' => (
    is          => 'ro',
    isa         => HashRef,
    lazy        => 1,
    default     => sub {
        return {
            0 => 250,
            1 => 350,
            2 => 450,
            3 => 550,
            4 => 650,
        };
    },
);

has '_deduction_map_2016' => (
    is          => 'ro',
    isa         => HashRef,
    lazy        => 1,
    default     => sub {
        return {
            0 => 300,
            1 => 400,
            2 => 500,
            3 => 600,
            4 => 800,
        };
    },
);

has '_deduction_map' => (
    is          => 'ro',
    handles_via => 'Hash',
    lazy        => 1,
    default     => sub {
        my $self = shift;
        if ($self->year >= 2016) {
            return $self->_deduction_map_2016;
        }
        elsif ($self->year >= 2005) {
            return $self->_deduction_map_2005;
        }
        else {
            die "Tax deduction not available before 2005!";
        }
    },
    handles => {
        _get_deduction_for => 'get',
    }
);

has amount => (
    is      => 'ro',
    isa     => Int,
    lazy    => 1,
    default => sub {
        my $self = shift;
        return $self->_get_deduction_for( $self->persons );
    },
);

1;
