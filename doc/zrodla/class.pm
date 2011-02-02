#!/usr/bin/perl
package Kompilator::Api::Synteza::Class;
use strict;
use warnings;

sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	
	$self->_wyjsciePlik( shift );
	$self->_wyjscieP( [] );
	
	return $self;
}

sub _wyjsciePlik { $_[0]->{wyjsciePlik}=$_[1] if defined $_[1]; $_[0]->{wyjsciePlik} }
sub _wyjscieP { $_[0]->{wyjscieP}=$_[1] if defined $_[1]; $_[0]->{wyjscieP} }

sub ldc {}
sub iload {}
sub fload {}
sub bload {}
sub aload {}
sub iaload {}
sub putfield {}
sub getfield {}
sub fstore {}
sub bstore {}
sub astore {}
sub iastore {}
sub iadd {}
sub fadd {}
sub isub {}
sub fsub {}
sub imul {}
sub fmul {}
sub idiv {}
sub fdiv {}
sub faload {}
sub baload {}
sub aaload {} 
sub f2i {} 
sub i2f {} 
sub i2b {} 
sub b2i {}
sub newarrayInt {}
sub newarrayFloat {}
sub newarrayBoolean {}
sub newarrayString {}
sub invoke {}


sub drukujKod
{
	my $self = shift;
	my $kody = shift;
	push @{$self->_wyjscieP}, "$kody\n";
	return $self;
}

sub zapisz
{
	my $self = shift;
	open(KLASA, '>', $self->_wyjsciePlik ) or die "Cannot write to file $self->_wyjsciePlik, exit $!";
	foreach my $linia ( @{$self->_wyjscieP} ) {
		print KLASA $linia;
	}
	close(KLASA);
}


1;
