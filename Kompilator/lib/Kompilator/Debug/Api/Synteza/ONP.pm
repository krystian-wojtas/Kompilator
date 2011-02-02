#!/usr/bin/perl
package Kompilator::Debug::Api::Synteza::ONP;
use strict;
use warnings;

sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$self->_onpPlik( shift );
	$self->_onpP( [] );
	return $self;
}

sub _onpPlik { $_[0]->{onpPlik}=$_[1] if defined $_[1]; $_[0]->{onpPlik} }
sub _onpP { $_[0]->{onpP}=$_[1] if defined $_[1]; $_[0]->{onpP} }

sub zdejmij
{
	my ( $self, $operand ) = @_;
	#push @{$self->_onpPlik}, "Zdjecie ze stosu nazwa/const $operand->{nazwa}, maska: $operand->{maska}, pozycja $operand->{pozycja}\n";;
	return $self;
}

sub wloz
{
	my ( $self, $operand ) = @_;
	push @{$self->_onpP}, "Wrzucenie na stos nazwa/const $operand->{nazwa}, maska: $operand->{maska}, pozycja $operand->{pozycja}\n";;
	return $self;
}

sub noweWyrazenie
{
	my $self = shift;
	push @{$self->_onpP}, "nowe wyrazenie\n";
	return $self;
}

sub koniecWyrazenia
{
	my $self = shift;
	push @{$self->_onpP}, "koniec wyrazenie\n";
	return $self;
}

sub zapiszWartosc
{
	my ( $self, $operand ) = @_;
	push @{$self->_onpP}, "Zapisanie wartosci: $operand->{nazwa}, $operand->{maska}, wartosc $operand->{pozycja}\n";
	return $self;
}

sub wyjatek
{
	my ( $self, $subName, $exception ) = @_;
	push @{$self->_onpP}, "\n\nWYJATEK\n";
	push @{$self->_onpP}, "\t$subName\n\t$exception\n";
	return $self;
}

sub zapisz
{
	my $self = shift;
	open(KLASA, '>', $self->_onpPlik ) or die "Cannot write to file $self->_onpPlik, exit $!";
	foreach my $linia ( @{$self->_onpP} ) {
		print KLASA $linia;
	}
	close(KLASA);
	return $self;
}


1;