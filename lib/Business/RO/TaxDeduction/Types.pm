package Business::RO::TaxDeduction::Types;

# ABSTRACT: Types for the TaxDeduction module

use 5.010001;
use strict;
use warnings;
use utf8;
use Type::Library 0.040 -base, -declare => qw(
    TaxPersons
    MathBigFloat
);

use Type::Utils -all;
use Types::Standard -types;

BEGIN { extends "Types::Standard" };

declare "TaxPersons",
    as "Int",
    where { $_ >= 0 && $_ <= 4 };

coerce "TaxPersons",
    from "Int", via { $_ >= 4 ? 4 : $_ };

class_type MathBigFloat, { class => 'Math::BigFloat' };

1;

__END__

=head1 SYNOPSIS

  use Business::RO::TaxDeduction::Types qw(
      Int
      MathBigFloat
  );

=over

=item C<< MathBigFloat >>

A L<Math::BigFloat> object instance.

=item C<< TaxPersons >>

A custom type for the number of persons.  Valid values are from 0
(zero) to 4.  If the number is greater than 4, the attribute value is
coerced to 4.

=back
