package Business::RO::Types;

# ABSTRACT: Types

use 5.010001;
use strict;
use warnings;
use utf8;
use Type::Library 0.040 -base, -declare => qw(
    MathBigFloat
);
use Type::Utils -all;
use Types::Standard -types;

BEGIN { extends "Types::Standard" };

class_type MathBigFloat, { class => 'Math::BigFloat' };

1;

__END__

=head1 Name

Business::RO::Types - Custom attribute types

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

=back

=cut
