#!/usr/bin/perl
package Kompilator::Api::Konfigurator;
use strict;
use warnings;
use Carp;

sub new
{
	my $class = shift;
	my $self = { parametry => \@_, jezyk => [], termy => [], opisPlik => "", konfigPlik => "", zrodloPlik => "", konfiguracja => {} };
	bless($self, $class);
	$self->_init();
	return $self;
}

sub _init
{
	die "Klasa abstrakcyjna"; #rzuc wyjatkiem; init nalezy ukonkretyzowac
} 

sub _parametry
{
	my $self = shift;
	unless (ref $self) {
		croak "Should call parametry() with an object, not a class";
	}
	# Receive more data
	my $parametry = shift;
	# Set the parametry if there's any data there.
	$self->{parametry} = $parametry if defined $parametry;
	return $self->{parametry};
}

sub opisP
{
	my $self = shift;
	unless (ref $self) {
		croak "Should call opisP() with an object, not a class";
	}
	# Receive more data
	my $opis = shift;
	# Set the opisP if there's any data there.
	$self->{opisP} = $opis if defined $opis;
	return $self->{opisP};
}

sub tP
{
	my $self = shift;
	unless (ref $self) {
		croak "Should call tP() with an object, not a class";
	}
	# Receive more data
	my $tP = shift;
	# Set the tP if there's any data there.
	$self->{tP} = $tP if defined $tP;
	return $self->{tP};
}

sub zrodloP
{
	my $self = shift;
	unless (ref $self) {
		croak "Should call zrodloPlik() with an object, not a class";
	}
	# Receive more data
	my $zrodloP = shift;
	# Set the zrodloP if there's any data there.
	$self->{zrodloP} = $zrodloP if defined $zrodloP;
	return $self->{zrodloP};
}

sub konfiguracjaP
{
	my $self = shift;
	unless (ref $self) {
		croak "Should call konfiguracja() with an object, not a class";
	}
	# Receive more data
	my $konfiguracja = shift;
	# Set the konfiguracjaP if there's any data there.
	$self->{konfiguracja} = $konfiguracja if defined $konfiguracja;
	return $self->{konfiguracja};
}

sub wyjsciePlik
{
	my $self = shift;
	unless (ref $self) {
		croak "Should call wyjsciePlik() with an object, not a class";
	}
	# Receive more data
	my $wyjsciePlik = shift;
	# Set the wyjsciePlik if there's any data there.
	$self->{wyjsciePlik} = $wyjsciePlik if defined $wyjsciePlik;
	return $self->{wyjsciePlik};
}

1;
