#!/usr/bin/perl
package Kompilator::Api::Synteza::SyntezaBaza;
use Kompilator::Api::Synteza::Procedury;
use Kompilator::Api::Synteza::ONP;
use Kompilator::Api::Synteza::Stale;
use Kompilator::Java::Synteza::Class;
use strict;
use warnings;

sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$self->_classP( new Kompilator::Java::Synteza::Class( shift ) );
	$self->_staleP( new Kompilator::Api::Synteza::Stale() );
	$self->_onpP( new Kompilator::Api::Synteza::ONP( $self, $self->_staleP ) );
	$self->_proceduryP( new Kompilator::Api::Synteza::Procedury( $self, $self->_onpP ) );
	$self->_init();
	return $self;
}

sub _staleP { $_[0]->{stale}=$_[1] if defined $_[1]; $_[0]->{stale} }
sub _onpP { $_[0]->{onp}=$_[1] if defined $_[1]; $_[0]->{onp} }
sub _proceduryP { $_[0]->{procedury}=$_[1] if defined $_[1]; $_[0]->{procedury} }
sub proceduryP { $_[0]->_proceduryP }
sub _classP { $_[0]->{class}=$_[1] if defined $_[1]; $_[0]->{class} }

sub _init
{}

#funkcje wywolywane w chwili deklaracji procedury i jej parametrow
sub deklProcNazwaD
{
	my ( $self, $nazwa ) = @_;
	$self->_proceduryP->deklProcNazwa( $nazwa );
	$self->deklProcNazwa( $nazwa );
	return $self;
}

sub deklProcNazwa
{}


sub deklProcMaskaD
{
	my ( $self, $maska ) = @_;
	$self->_proceduryP->deklProcMaska( $maska );
	$self->deklProcMaska( $maska );
	return $self;
}

sub deklProcMaska
{}


sub deklProcD
{
	my $self = shift;
	$self->_proceduryP->deklProc();
	$self->deklProc;
	return $self;
}

sub deklProc
{}


sub deklParamNazwaD
{
	my ( $self, $nazwa ) = @_;
	$self->_proceduryP->deklParamNazwa( $nazwa );
	$self->deklParamNazwa( $nazwa );
	return $self;
}

sub deklParamNazwa
{}


sub deklParamMaskaD
{
	my ( $self, $maska ) = @_;
	$self->_proceduryP->deklParamMaska( $maska );
	$self->deklParamMaska( $maska );
	return $self;
}

sub deklParamMaska
{}


sub deklParamD
{
	my $self = shift;
	$self->_proceduryP->deklParam();
	$self->deklParam();
	return $self;
}

sub deklParam
{}


sub wywolanieProceduryD
{
	my ( $self, $nazwa) = @_;
	$self->_proceduryP->wywolanieProcedury( $nazwa );
	$self->wywolanieProcedury;
	return $self;
}

sub wywolanieProcedury
{}

sub proceduraWywolanaD
{
	my $self = shift;
	my $procedura = shift; #TODO shift ?
	my $prWNr = $self->_proceduryP->proceduraWywolana( $procedura );
	$self->proceduraWywolana( $prWNr, $procedura );
	return $self;
}

sub proceduraWywolana
{}


sub alokacjaD
{
	my $self = shift;
	$self->alokacja;
	return $self;
}

sub alokacja
{}


sub zwolnienieD
{
	my $self = shift;
	$self->zwolnienie;
	return $self;
}

sub zwolnienie
{}


sub zwrotD
{
	my $self = shift;
	my $z1 = $self->_proceduryP->zwrot;
	my $z2 = $self->_onpP->zdejmij;
	$self->konwertuj21($z1, $z2);
	$self->_onpP->wloz( $z2 );
	$self->zwrot( $z1, $z2 );
	return $self;
}

# Funkcja jest wywolywana z dwoma argumentami
# Pierwszy - typ zwracany przez funkcje, drugi - typ zmiennej zwracanej
# Zastajemy stos z przekonwertowana zwracana zmienna
sub zwrot
{}


sub nowyParametrD
{
	my $self = shift;
	my $z1 = $self->_proceduryP->nowyParametr;
	$self->nowyParametr;
	return $self;
}

sub nowyParametr
{}


sub koniecParametruD
{
	my $self = shift;
	my $z1 = $self->_proceduryP->koniecParametru;
	$self->koniecParametru;
	return $self;
}

sub koniecParametru
{}


sub wrzucD
{
	my $self = shift;
	my $operand = shift;
	my $bajtkod = shift;
	$self->wrzuc( $operand, $bajtkod );
	$self->_onpP->wloz( $operand );
	
	return $self;
}

sub wrzuc
{}


sub zapiszWartoscD
{
	my $self = shift;
	my $operand = shift;
	$self->zapiszWartosc( $operand );
	
	return $self;
}

sub zapiszWartosc
{}


sub noweWyrazenieD
{
	my $self = shift;
	$self->_onpP->noweWyrazenie;
	$self->noweWyrazenie;
	return $self;
}

sub noweWyrazenie
{}


sub koniecWyrazeniaD
{
	my $self = shift;
	$self->_onpP->koniecWyrazenia;
	$self->koniecWyrazenia;
	return $self;
}

sub koniecWyrazenia
{}


sub dzialajOperatorem2D
{
	my $self = shift;
	my $operator = shift;
	my $z2 = $self->_onpP->zdejmij;
	my $z1 = $self->_onpP->zdejmij;
	$z2 = $self->dzialajOperatorem2( $operator, $z1, $z2 );
	$self->_onpP->wloz( $z2 );
	return $self;
}

sub dzialajOperatorem2
{}


sub operator2D
{
	my $self = shift;
	my $opP = shift;
	my $opS = shift;
	$self->_onpP->operator2( $opP, $opS );
	$self->operator2( $opP, $opS );
	return $self;
}

sub operator2
{}


sub operator1D
{
	my $self = shift;
	my $opP = shift;
	my $opS = shift;
	$self->_onpP->operator1( $opP, $opS);
	$self->operator1( $opP, $opS );
	return $self;
}

sub operator1
{}


sub negacjaD
{
	my $self = shift;
	my $operand = shift;
	$self->negacja( $operand );
	return $self;	
}

sub negacja
{}


sub konwertuj21D
{
	my $self = shift;
	my $z1 = shift;
	my $z2 = shift;
	$self->konwertuj21( $z1, $z2 );
	return $self;
}

sub konwertuj21
{}


sub drukujKodD
{
	my $self = shift;
	my $kody = shift;
	$self->_classP->drukujKod( $kody );
	$self->drukujKod;
	return $self;
}

sub drukujKod
{}


sub zapiszD
{
	my $self = shift;
	$self->_classP->zapisz();
	$self->zapisz;
	return $self;
}

sub zapisz
{}

1;