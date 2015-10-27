package Business::RO::TaxDeduction;

# ABSTRACT: Romanian salary tax deduction calculator

use 5.010001;
use utf8;
use Moo;
use MooX::HandlesVia;
use Math::BigFloat;
use Business::RO::Types qw(
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
);

has '_deduction_map' => (
    is          => 'ro',
    handles_via => 'Hash',
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
    handles => {
        get_deduction_for => 'get',
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
    my $vbl    = $self->round_050( $self->vbl );
    my $amount = $self->get_deduction_for( $self->persons );
    if ( $vbl <= 1000 ) {
        return $amount;
    }
    elsif ( ( $vbl > 1000 ) && ( $vbl <= 3000 ) ) {
        return $self->tax_deduction_formula($vbl, $amount);
    }
    else {
        return 0;
    }
}

sub tax_deduction_formula {
    my ( $self, $vbl, $base_deduction ) = @_;
    my $amount = $base_deduction * ( 1 - ( $vbl - 1000 ) / 2000 );
    return $self->round_10plus($amount);
}

sub round_050 {
    my ( $self, $amount ) = @_;
    return int( $amount + 0.5 * ( $amount <=> 0 ) );
}

sub round_10plus {
    my ( $self, $para_amount ) = @_;
    my $amount = Math::BigFloat->new($para_amount);
    my $afloor = $amount->copy()->bfloor();
    if ( $amount->is_int ) {
        return $self->corrections($amount, $amount->is_int);
    }
    else {
        return $self->corrections($afloor, $amount->is_int);
    }
}

sub corrections {
    my ($self, $amount, $is_int) = @_;
    my $amount_mod = $amount->copy()->bmod( $self->ten );
    if ($amount_mod > 0) {
        return $amount->bsub($amount_mod)->badd( $self->ten );
    }
    else {
        if ($is_int == 0) {
            return $amount->badd( $self->ten );
        }
        else {
            return $amount;
        }
    }
}

1;

__END__

=encoding utf8

=head1 DESCRIPTION

Romanian tax deduction calculator.

=head1 SYNOPSIS

use Business::RO::TaxDeduction;

my $tax_deduction = Business::RO::TaxDeduction->new(
    vbl     => 2345,
    persons => 3,
);

=head1 ATTRIBUTES

=head2 C<vbl>

The C<vbl> attribute holds the input amount.  (ro: Venit Brut Lunar).

=head2 C<persons>

The C<persons> attribute holds the number of persons.

=head1 METHODS

=head2 C<round_050>

Custom rounding method.

=head2 C<round_10plus>

Round up to 10.  If the amount is an integer than calculate the modulo
and...

=head2 C<corrections>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-business-ro-taxdeduction at rt.cpan.org>, or through the web
interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Business-RO-TaxDeduction>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Business::RO::TaxDeduction

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Business-RO-TaxDeduction>

=item * Search CPAN

L<http://search.cpan.org/dist/Business-RO-TaxDeduction/>

=back

=cut
