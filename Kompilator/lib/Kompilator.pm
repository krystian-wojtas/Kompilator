package Kompilator;
use Kompilator::Api::PodstKonfiguratorImpl;
use Kompilator::Pascal::Leksyka;
use Kompilator::Pascal::Syntaktyka;
use Kompilator::Pascal::Semantyka;
use Kompilator::Java::Synteza;
use Kompilator::Debug::AspectDebugger;
use strict;
use warnings;

=head1 NAME

Kompilator - The great new Kompilator!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.5';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Kompilator;

    my $foo = Kompilator->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new
{
	my ( $class, $paramP ) = @_;
	my $self = {};
	bless $self, $class;
	
	my $konf = new Kompilator::Api::PodstKonfiguratorImpl(@$paramP);
	$self->_leksykaP( new Kompilator::Pascal::Leksyka( $konf->opisP(), $konf->tP(), $konf->zrodloP() ) ); 
	$self->_syntaktykaP( new Kompilator::Pascal::Syntaktyka( $konf->opisP(), $konf->tP() ) );
	$self->_syntezaP( new Kompilator::Java::Synteza( $konf->wyjsciePlik ) );
	$self->_semantykaP( new Kompilator::Pascal::Semantyka( $konf->opisP(), $konf->tP(), $self->_syntaktykaP->drzewoP->korzenP, $self->_syntezaP ) );
	$self->_debugP( new Kompilator::Debug::AspectDebugger( $konf->konfiguracjaP, $self->_leksykaP, $self->_syntaktykaP, $self->_semantykaP, $self->_semantykaP ) );	
	
	return $self;
}

sub _leksykaP { $_[0]->{leksyka}=$_[1] if defined $_[1]; $_[0]->{leksyka} }
sub _syntaktykaP { $_[0]->{syntaktyka}=$_[1] if defined $_[1]; $_[0]->{syntaktyka} }
sub _semantykaP { $_[0]->{semantyka}=$_[1] if defined $_[1]; $_[0]->{semantyka} }
sub _syntezaP { $_[0]->{synteza}=$_[1] if defined $_[1]; $_[0]->{synteza} }
sub _debugP { $_[0]->{debug}=$_[1] if defined $_[1]; $_[0]->{debug} }

=head2 kompiluj

=cut

sub kompiluj
{
	my $self = shift;
	#wykonanie analiz, obsluga wyjatkow
	eval {
		$self->_leksykaP->analizuj();
		$self->_syntaktykaP->analizuj( $self->_leksykaP->leksemyP() );
		$self->_semantykaP( $self->_syntaktykaP->drzewoP() );
		print "SuccesFull\n";
	};
	if($@) {
		print "EXEPTIONS:\n";
		foreach my $err ($@) {
			print "EXCEPTION $err\n";
		}
	}
}

=head1 AUTHOR

Krystian Wojtas, C<< <krystian.wojtas at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-kompilator at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Kompilator>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Kompilator


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Kompilator>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Kompilator>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Kompilator>

=item * Search CPAN

L<http://search.cpan.org/dist/Kompilator/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Krystian Wojtas.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Kompilator
