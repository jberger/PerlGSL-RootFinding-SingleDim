package PerlGSL::RootFinding::SingleDim;

use strict;
use warnings;

use Carp;
use Scalar::Util qw/looks_like_number/;

our $VERSION = '0.001';
$VERSION = eval $VERSION;

require XSLoader;
XSLoader::load('PerlGSL::RootFinding::SingleDim', $VERSION);

use base 'Exporter';
our @EXPORT_OK = ( qw/
  findroot_1d
/ );

sub findroot_1d {
  croak "findroot_1d requires 3 arguments, aside from an options hashref" 
    unless @_ >= 3;

  my ($sub, $xl, $xu) = (shift, shift, shift);

  my %opts;
  if (@_) {
    %opts = ref $_[0] ? %{shift()} : @_;
  }

  $opts{epsabs} ||= 0;
  $opts{epsrel} = 1e-4 unless defined $opts{epsrel};
  $opts{max_iter} ||= 1000;

  unless (looks_like_number $xl) {
    croak "Lower limit is not a number: $xl";
  }

  unless (looks_like_number $xu) {
    croak "Upper limit is not a number: $xu";
  }

  return c_findroot_1d($sub, $xl, $xu, @opts{ qw/max_iter epsabs epsrel/ });
}

1;

__END__
__POD__

=head1 NAME

PerlGSL::RootFinding::SingleDim - A Perlish Interface to the GSL 1D Root Finding Library

=head1 SYNOPSIS

 use PerlGSL::Integration::SingleDim qw/findroot_1d/;
 my $result = findroot_1d(sub{ $_[0]**2 - 5 }, 0, 5); # sqrt(5)

=head1 DESCRIPTION

This module is an interface to the GSL's Single Dimensional numerical root finding routines. So far only the "bracketing" Brent-Dekker method is implemented. 

=head1 FUNCTIONS

No functions are exported by default.

=over

=item findroot_1d

This is the main interface provided by the module. It takes three required arguments and an (optional) options hash. The first argument is a subroutine reference defining the function. The next two are numbers defining the lower and upper bound for searching. 

The options hash reference accepts the following keys:

=over

=item *

epsabs - The maximum allowable absolute error. The default is C<0> (ignored).

=item *

epsrel - The maximum allowable relative error. The default is C<1e-4>.

=item *

max_iter - The maximum number of search iterations permitted. The default is 1000.

=back

The return value is the position of the root. Note that if there are multiple roots in the search location only one will be returned; there is no way to tell which it will be.

=back

=head1 INSTALLATION REQUIREMENTS

This module needs the GSL library installed and available. The C<PERLGSL_LIBS> environment variable may be used to pass the C<--libs> linker flags; if this is not specified, the command C<gsl-config --libs> is executed to find them. Future plans include using an L<Alien> module to provide the GSL in a more CPAN-friendly manner.

=head1 FUTURE WORK

Derivative methods may be added, but would require a separate closure representing the derivative of the function (unless numeric derivatives were employed). This makes such mechanisms less useful at least for now, of course, L<your contributions are always welcome|/"SOURCE REPOSITORY">!

=head1 SEE ALSO

=over

=item *

L<PerlGSL>

=item *

L<http://www.gnu.org/software/gsl/manual/html_node/One-dimensional-Root_002dFinding.html>

=back

=head1 SOURCE REPOSITORY

L<http://github.com/jberger/PerlGSL-RootFinding-SingleDim>

=head1 AUTHOR

Joel Berger, E<lt>joel.a.berger@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Joel Berger

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The GSL is licensed under the terms of the GNU General Public License (GPL)

