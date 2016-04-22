package Business::RO::TaxDeduction;

# ABSTRACT: Romanian salary tax deduction calculator

use 5.010001;
use utf8;
use Moo;
use MooX::HandlesVia;
use Math::BigFloat;
use Scalar::Util qw(blessed);
use Business::RO::TaxDeduction::Types qw(
    Int
    MathBigFloat
    TaxPersons
);

has 'vbl' => (
    is       => 'ro',
    isa      => Int,
    required => 1,
);

has 'persons' => (
    is       => 'ro',
    isa      => TaxPersons,
    required => 1,
    init_arg => 'persons',
    coerce   => 1,
    default  => sub { 0 },
);

has '_deduction_map' => (
    is          => 'ro',
    handles_via => 'Hash',
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
    handles => {
        _get_deduction_for => 'get',
    }
);

has 'ten' => (
    is      => 'ro',
    isa     => MathBigFloat,
    default => sub {
        return Math::BigFloat->new(10);
    },
);

sub tax_deduction {
    my $self   = shift;
    my $vbl    = $self->_round_to_int( $self->vbl );
    my $amount = $self->_get_deduction_for( $self->persons );
    if ( $vbl <= 1500 ) {
        return $amount;
    }
    elsif ( ( $vbl > 1500 ) && ( $vbl <= 3000 ) ) {
        $amount = $self->_tax_deduction_formula($vbl, $amount);
        return ( blessed $amount ) ? $amount->bstr : $amount;
    }
    else {
        return 0;               # 0 for VBL > 3000
    }
}

sub _tax_deduction_formula {
    my ( $self, $vbl, $base_deduction ) = @_;
    my $amount = $base_deduction * ( 1 - ( $vbl - 1500 ) / 1500 );
    return $self->_round_to_tens($amount);
}

sub _round_to_int {
    my ( $self, $amount ) = @_;
    return int( $amount + 0.5 * ( $amount <=> 0 ) );
}

sub _round_to_tens {
    my ( $self, $para_amount ) = @_;
    my $amount = Math::BigFloat->new($para_amount);

    return 0 if $amount == 0;

    my $afloor  = $amount->copy()->bfloor();
    my $amodulo = $afloor->copy()->bmod( $self->ten );

    return $amount if $amount->is_int && $amodulo == 0;
    return $afloor->bsub($amodulo)->badd( $self->ten );
}

1;

__END__

=encoding utf8

=head1 DESCRIPTION

Romanian tax deduction calculator.

=head1 SYNOPSIS

use Business::RO::TaxDeduction;

    my $brtd = Business::RO::TaxDeduction->new(
        vbl     => 1400,
        persons => 3,
    );
    my $amount = $brtd->tax_deduction;

=attr vbl

The C<vbl> attribute holds the input amount.  (ro: Venit Brut Lunar).

=attr persons

The C<persons> attribute holds the number of persons.  Not required,
the default is 0.

=attr _deduction_map

Holds the mapping between the number of persons and the a basic
deduction amount.

=attr ten

A Math::BigFloat object instance for 10.

=method tax_deduction

Return the deduction calculated for the given amount.

The current version (0.003) uses the algorithm described in the
document:

"ORDIN Nr. 52/2016 din 14 ianuarie 2016 privind aprobarea
calculatorului pentru determinarea deducerilor personale lunare pentru
contribuabilii care realizează venituri din salarii la funcţia de
bază, începând cu luna ianuarie 2016, potrivit prevederilor art. 77
alin. (2) şi ale art. 66 din Legea nr. 227/2015 privind Codul fiscal".

The previous version (0.002) uses the algorithm described in the
document:

"ORDINUL nr. 1.016/2005 din 18 iulie 2005 privind aprobarea deducerilor
personale lunare pentru contribuabilii care realizează venituri din
salarii la funcția de bază, începând cu luna iulie 2005, potrivit
prevederilor Legii nr. 571/2003 privind Codul fiscal și ale Legii
nr. 348/2004 privind denominarea monedei naționale".

=method _tax_deduction_formula

Formula from the above document for calculating the tax deduction for
amounts above 1000 RON and less or equal to 3000 RON.

=method _round_to_int

Custom rounding method to the nearest integer.  It uses the Romanian
standard for rounding in bookkeeping.

Example:

  10.01 -:- 10.49 => 10
  10.50 -:- 10.99 => 11

=method _round_to_tens

Round up to tens.  Uses Math::BigFloat to prevent rounding errors like
when amount minus floor(amount) gives something like 7.105427357601e-15.
