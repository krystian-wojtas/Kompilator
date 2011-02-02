#!/usr/bin/perl
package Kompilator::Java::Synteza::Class;
use strict;
use warnings;
use Kompilator::Api::Synteza::Class;

our @ISA = qw(Kompilator::Api::Synteza::Class);

sub invoke
{
	my ( $self, $prWNr ) = @_;
	$self->drukujKod( "invoke $prWNr" );
	return $self;
}

sub ldc
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("ldc $pozycja");
	return $self;
}

sub getfield
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("getfield $pozycja");
	return $self;
}

sub iload
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("iload $pozycja");
	return $self;
}

sub fload
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("fload $pozycja");
	return $self;
}

sub bload
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("bload $pozycja");
	return $self;
}

sub aload
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("aload $pozycja");
	return $self;
}

sub iaload
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("iaload $pozycja");
	return $self;
}

sub putfield
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("putfield $pozycja");
	return $self;
}

sub istore
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("istore $pozycja");
	return $self;
}

sub fstore
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("fstore $pozycja");
	return $self;
}

sub bstore
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("bstore $pozycja");
	return $self;
}

sub astore
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("astore $pozycja");
	return $self;
}

sub iastore
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("iastore $pozycja");
	return $self;
}

sub iadd
{
	my $self  = shift;
	$self->drukujKod('iadd');
	return $self;
}

sub fadd
{
	my $self  = shift;
	$self->drukujKod('fadd');
	return $self;
}

sub isub
{
	my $self  = shift;
	$self->drukujKod('isub');
	return $self;
}

sub fsub
{
	my $self  = shift;
	$self->drukujKod('fsub');
	return $self;
}

sub imul
{
	my $self  = shift;
	$self->drukujKod('imul');
	return $self;
}

sub fmul
{
	my $self  = shift;
	$self->drukujKod('fmul');
	return $self;
}

sub idiv
{
	my $self  = shift;
	$self->drukujKod('idiv');
	return $self;
}

sub fdiv
{
	my $self  = shift;
	$self->drukujKod('fdiv');
	return $self;
}

sub faload
{
	my $self  = shift;
	$self->drukujKod('faload');
	return $self;
}

sub baload
{
	my $self  = shift;
	$self->drukujKod('baload');
	return $self;
}

sub aaload
{
	my $self  = shift;
	$self->drukujKod('aaload');
	return $self;
} 

sub newarrayInt
{
	my $self  = shift;
	$self->drukujKod('newarray 11');
	return $self;
}

sub newarrayFloat
{
	my $self  = shift;
	$self->drukujKod('newarray 12');
	return $self;
}

sub newarrayBoolean
{
	my $self  = shift;
	$self->drukujKod('newarray 13');
	return $self;
}

sub newarrayString
{
	my $self  = shift;
	$self->drukujKod('anewarray String');
	return $self;
}

sub f2i
{
	my $self  = shift;
	$self->drukujKod('f2i');
	return $self;
} 

sub i2f
{
	my $self  = shift;
	$self->drukujKod('i2f');
	return $self;
} 

sub i2b
{
	my $self  = shift;
	$self->drukujKod('i2b');
	return $self;
} 

sub b2i
{
	my $self  = shift;
	$self->drukujKod('b2i');
	return $self;
} 


1;