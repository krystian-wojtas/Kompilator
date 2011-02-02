#!/usr/bin/perl
use strict;
use warnings;
package Kompilator::Debug::Pascal::Leksyka;

sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$self->_klasyfikacjaP( shift );
	$self->_leksemyP( shift );
	$self->_leksykaDefinicjePlik( shift );
	$self->_leksykaWyjsciePlik( shift );
	return $self; 
}

sub _klasyfikacjaP { $_[0]->{klasyfikacja}=$_[1] if defined $_[1]; $_[0]->{klasyfikacja} }
sub _leksemyP { $_[0]->{leksemy}=$_[1] if defined $_[1]; $_[0]->{leksemy} }
sub _leksykaDefinicjePlik { $_[0]->{leksykaDefinicjePlik}=$_[1] if defined $_[1]; $_[0]->{leksykaDefinicjePlik} }
sub _leksykaWyjsciePlik { $_[0]->{leksykaWyjsciePlik}=$_[1] if defined $_[1]; $_[0]->{leksykaWyjsciePlik} }

sub dolozLeksem
{
	my $self = shift;
	my $leksem = shift;
}

sub drukujDefinicje
{
	my $self = shift;
	my @klasyfikacja = @{$self->_klasyfikacjaP};
	my $leksykaDefinicjePlik = $self->_leksykaDefinicjePlik;
	
	open KLASYFIKACJAWYJSCIE, '>', $leksykaDefinicjePlik;
	print KLASYFIKACJAWYJSCIE "WCZYTANE WZORCE\n";
	for my $klasa ( @klasyfikacja ) {
		print KLASYFIKACJAWYJSCIE "Wzorzec\nwzor:\t".$klasa->{wzorzec}."\nterm:\t".$klasa->{terminator}."\nopis:\t".$klasa->{opis}."\n\n";
	}
	close KLASYFIKACJAWYJSCIE;
}

sub drukujWyjscie
{
	my $self = shift;
	my @leksemy = @{$self->_leksemyP};
	my $leksykaWyjsciePlik = $self->_leksykaWyjsciePlik;
	
	open LEKSEMYWYJSCIE, '>', $leksykaWyjsciePlik;
	print LEKSEMYWYJSCIE "ROZPOZNANE LEKSEMY\n";
	for my $leksem ( @leksemy ) {
		print LEKSEMYWYJSCIE "Leksem\nslowo:\t".$leksem->{slowo}."\nlinia:\t".$leksem->{linia}."\npocz:\t".$leksem->{poczatek}."\nprod:\t".$leksem->{produkcja}."\nopis:\t".$leksem->{opis}."\n\n";
	}
	close LEKSEMYWYJSCIE;
}

1;