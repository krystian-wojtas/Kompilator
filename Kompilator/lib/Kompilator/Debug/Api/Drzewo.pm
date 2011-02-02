#!/usr/bin/perl
use strict;
use warnings;
package Kompilator::Debug::Api::Drzewo;

sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$self->_drzewo( shift );
	$self->_wciecie( '' );
	$self->_wyjscie( [] );
	return $self;
}

sub _drzewo { $_[0]->{drzewo}=$_[1] if defined $_[1]; $_[0]->{drzewo} }
sub _wciecie { $_[0]->{wciecie}=$_[1] if defined $_[1]; $_[0]->{wciecie} }
sub _produkcja { $_[0]->_drzewo->produkcja }
sub _wyjscie { $_[0]->{wyjscie}=$_[1] if defined $_[1]; $_[0]->{wyjscie} }

sub appendChild
{
	my $self = shift;
	push @{$self->_wyjscie}, $self->_wciecie.'produkcja '.$self->_produkcja."\n";
	$self->_wciecie( $self->_wciecie.' ' );
	return $self;
}

sub parent
{
	my $self = shift;
	$self->_wciecie( substr ( $self->_wciecie, 1) ) if $self->_wciecie;
	push @{$self->_wyjscie}, $self->_wciecie.'zamykam produkcje '.$self->_produkcja."\n" if defined $self->_produkcja;
	return $self;
}

sub textNode
{
	my $self = shift;
	my $leksemP = shift;
	if(defined $leksemP->{slowo}) { # TODO dosyc brzydki sposob, trzeba tu sprawdzac cos ogolniejszego, wykorzystac EPSILON
		push @{$self->_wyjscie}, $self->_wciecie.'zawieszam "'.$leksemP->{slowo}.'" rodzaj '.$leksemP->{klasyfikacjaNr}."\n";
	}
	else {
		push @{$self->_wyjscie}, $self->_wciecie."zawieszam epsilon\n";
	}
	return $self;
}

sub wyjscie
{
	my $self = shift;
	my $wyjsciePlik = shift;
	
	open DRZEWOWYJSCIE, '>', $wyjsciePlik;
	my @a = @{$self->_wyjscie};
	foreach (@{$self->_wyjscie}) {
		print DRZEWOWYJSCIE;
	}
	close DRZEWOWYJSCIE;
	
	return $self;
}


1;