#!/usr/bin/perl
package Kompilator::Debug::Java::Synteza;
use strict;
use warnings;
use Data::Dumper;

sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$self->_syntezaWywolaniaPlik( shift );
	$self->_syntezaWywolaniaP( [] );
	$self->_it(0);
	return $self;
}

sub _syntezaWywolaniaPlik { $_[0]->{syntezaWywolaniaPlik}=$_[1] if defined $_[1]; $_[0]->{syntezaWywolaniaPlik} }
sub _syntezaWywolaniaP { $_[0]->{syntezaWywolaniaP}=$_[1] if defined $_[1]; $_[0]->{syntezaWywolaniaP} }
sub _it { $_[0]->{it}=$_[1] if defined $_[1]; $_[0]->{it} }

sub wywolanie
{
	my $self = shift;
	my $subName = shift;
	my $paramsP = shift;
	push @{$self->_syntezaWywolaniaP}, "\n\n".$self->_it( $self->_it+1 )."\t$subName\n";
	push @{$self->_syntezaWywolaniaP}, Data::Dumper->Dump( $paramsP );
}

sub wyjatek
{
	my $self = shift;
	my $subName = shift;
	my $exception = shift;
	push @{$self->_syntezaWywolaniaP}, "\n\n".$self->_it."WYJATEK\n";
	push @{$self->_syntezaWywolaniaP}, "\t$subName\n\t$exception\n";
}

sub zapisz
{
	my $self = shift;
	open(KLASA, '>', $self->_syntezaWywolaniaPlik ) or die "Cannot write to file $self->_syntezaWywolaniaPlik, exit $!";
	foreach my $linia ( @{$self->_syntezaWywolaniaP} ) {
		print KLASA $linia;
	}
	close(KLASA);
}

1;