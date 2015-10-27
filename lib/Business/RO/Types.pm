package Business::RO::Types;

# ABSTRACT: Types

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
    where { $_ >= 0 && $_ <= 4 },
    inline_as { my $varname = $_[1]; "$varname >= 0 && $varname <= 4" };

coerce "TaxPersons",
    from "Int", via { $_ >= 4 ? 4 : $_ };

class_type MathBigFloat, { class => 'Math::BigFloat' };

1;

__END__

=head1 Name

Business::RO::Types - Custom attribute types.

=head1 Synopsis

  use Business::RO::Types qw(
      Int
      MathBigFloat
  );

=head1 Description

Types for the C<Business::RO> module:

=over

=item C<MathBigFloat>

A L<Math::BigFloat> object instance.

=item C<TaxPersons>

A custom type for the number of persons.  Valid values are from 0
(zero) to 4.  If the number is greater than 4, the attribute value is
coerced to 4.

=back

=cut
