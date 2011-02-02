#!/usr/bin/perl
package Kompilator::Api::Synteza::Stale;
use strict;
use warnings;

sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	
	$self->_staleHashP( {} ); # odzwierciedla wartosc stalej na indeks w tablicy
	$self->_staleTab( [] ); # odzwierciedla indeks w tablicy na wartosc stalej
	
	return $self;
}

sub _staleHashP { $_[0]->{hash}=$_[1] if defined $_[1]; $_[0]->{hash} }
sub _staleTab { $_[0]->{tab}=$_[1] if defined $_[1]; $_[0]->{tab} }

sub zdejmijStala
{
	my $self = shift;
	my $wartosc = shift;
	if(not defined $self->_staleHashP->{$wartosc}) {
		push @{$self->_staleTab}, $wartosc;
		$self->_staleHashP->{$wartosc} = @{$self->_staleTab}-1; #dlugosc tablicy
	}
	return $self->_staleHashP->{$wartosc}; 
}

# Przydatne dla operatora jednoargumenowego negacji -
# Wtedy dokladam do stosu 0 i przeprowadzam normalne odejmowanie
sub zdejmijZero
{
	my $self = shift;
	return { nazwa => '0', maska => '101', pozycja => $self->zdejmijStala( '0' ) };
}


1;