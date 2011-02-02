#!/usr/bin/perl
package Kompilator::Api::Drzewo;
use strict;
use warnings;
use feature "switch";

my $wciecie = "";

sub new {
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$self->_korzenP( { produkcja => 'korzen', leksem => {}, rodzic => 0, dzieci => [] } );
	$self->_wezelP( $self->_korzenP );
	$self->_tagiP( [] );
    return $self;
}

sub _korzenP { $_[0]->{korzen}=$_[1] if defined $_[1]; $_[0]->{korzen} }
sub korzenP { $_[0]->_korzenP }
sub _wezelP { $_[0]->{wezel}=$_[1] if defined $_[1]; $_[0]->{wezel} }
sub _tagiP { $_[0]->{tagi}=$_[1] if defined $_[1]; $_[0]->{tagi} }
sub _produkcja { $_[0]->{produkcja}=$_[1] if defined $_[1]; $_[0]->{produkcja} }
sub produkcja { $_[0]->_produkcja } # TODO kopia, chyba ok scalara przekazuje przez kopie

sub appendChild
{
	my $self = shift;
	$self->_produkcja( shift );	
	push @{$self->_tagiP}, $self->_produkcja;
	
	#nowy potomek i podmiana aktualnego wezla na potomka
	my $dziecko = { produkcja => $self->_produkcja, leksem => {}, rodzic => $self->_wezelP, dzieci => [] };
	my $dzieci = $self->_wezelP->{dzieci};
	push @{$dzieci}, $dziecko;
	$self->_wezelP($dziecko);
	
	return $self;
}


sub parent
{
	my $self = shift;
	$self->_produkcja( pop @{$self->_tagiP} ) if @{$self->_tagiP} ;
	
	$self->_wezelP( $self->_wezelP->{rodzic} );
	return $self;
}


sub textNode
{
	my $self = shift;
	my $leksemPointer = shift;
	$self->_produkcja(0); #zrobic undefined ?

	#if( not defined $leksemPointer ) {
	#	$leksemPointer = { produkcja => 'EPSILON', slowo => $self->_wezelP->{slowo}, linia => $self->_wezelP->{linia}, poczatek => $self->_wezelP->{poczatek} };
	#}
	my $dziecko = { produkcja => $self->_produkcja, leksem => $leksemPointer, rodzic => $self->_wezelP, dzieci => [] };
	push @{ $self->_wezelP->{dzieci} }, $dziecko;
	
	return $self;
}


sub zrobEpsilon
{
	my ( $self, $leksemP ) = @_;
	# produkcja abstrakcyjna epsilon
	# podlaczanie wlasciwosci rodzica do celow wylapania ewentualnego bledu
	my $produkcjaEpsilon = { %$leksemP };
	$produkcjaEpsilon->{produkcja} = 'EPSILON';
	return $produkcjaEpsilon;
}

1;
