#!/usr/bin/perl
package Kompilator::Api::Synteza::Procedury;
use strict;
use warnings;

sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	
	$self->_syntezaP( shift );
	$self->_onpP( shift );
	$self->_procedur( 0 );
	$self->_proceduryDP( [] );
	$self->_proceduryWP( [] );
	$self->_deklProceduraP( {} );
	$self->_deklParametrP( {} );
	$self->_nazwProcNr( {} );
	
	return $self;
}

sub _syntezaP { $_[0]->{synteza}=$_[1] if defined $_[1]; $_[0]->{synteza} }
sub _onpP { $_[0]->{onp}=$_[1] if defined $_[1]; $_[0]->{onp} }
sub _procedur { $_[0]->{procedur}=$_[1] if defined $_[1]; $_[0]->{procedur} }
sub _proceduryDP { $_[0]->{proceduryD}=$_[1] if defined $_[1]; $_[0]->{proceduryD} }
sub _proceduryWP { $_[0]->{proceduryW}=$_[1] if defined $_[1]; $_[0]->{proceduryW} }
sub _deklProceduraP { $_[0]->{deklProcedura}=$_[1] if defined $_[1]; $_[0]->{deklProcedura} }
sub deklProceduraP { $_[0]->_deklProceduraP }
sub _deklParametrP { $_[0]->{deklParametr}=$_[1] if defined $_[1]; $_[0]->{deklParametr} }
sub deklParametrP { $_[0]->_deklParametrP }
sub _nazwProcNr { $_[0]->{nazwProcNr}=$_[1] if defined $_[1]; $_[0]->{nazwProcNr} }


sub deklProcNazwa
{
	my ( $self, $nazwa ) = @_;
	$self->_deklProceduraP->{nazwa} = $nazwa;
	return $self;
}


sub deklProcMaska
{
	my ( $self, $maska ) = @_;
	$self->_deklProceduraP->{maska} = $maska;
	return $self;
}


sub deklProc
{
	my $self = shift;
	if(defined $self->_nazwProcNr->{ $self->_deklProceduraP->{nazwa} } ) {
		die "Procedura $self->_deklProceduraP->{nazwa} jest juz zdefiniowana. Nie mozna przeciazac funkcji.";
	}
	# dopisanie procedury
	push @{$self->_proceduryDP}, $self->_deklProceduraP;
	# przyporzadkowanie nazwie zadeklarowanej procedury kolejnego numeru
	$self->_nazwProcNr->{ $self->_deklProceduraP->{nazwa} } = $self->_procedur;
	# zwiekszenie licznika procedur
	$self->_procedur( $self->_procedur+1 );
	# i wystawienie szkieletu dla nowonadchodzacej deklaracji
	$self->_deklProceduraP( { parametry => [] } );
	return $self;
}


sub deklParamNazwa
{
	my ( $self, $nazwa ) = @_;
	$self->_deklParametrP->{nazwa} = $nazwa;
	return $self;
}


sub deklParamMaska
{
	my ( $self, $maska ) = @_;
	$self->_deklParametrP->{maska} = $maska;
	return $self;
}


sub deklParam
{
	my $self = shift;
	# dodanie biezacego parametru do definicji biezacej procedury
	push @{$self->_deklProceduraP->{parametry}}, $self->_deklParametrP;
	# i wystawienie szkieletu dla nowonadchodzacego parametru
	$self->_deklParametrP( {} );
	return $self;
}



sub wywolanieProcedury
{
	my ( $self, $nazwa ) = @_;
	# sprawdzenie czy wywolywana procedura byla deklarowana
	my $prNr = $self->_nazwProcNr->{ $nazwa };
	if(not defined $prNr ) {
		die "Nie zdefiniowano procedury $nazwa\n";
	}
	# byla deklarowana, dodaj jej wywolanie na szczyt stosu procedur wywolywanych
	# nowyParametr i koniecParametru beda doliczac argumenty jej wywolania
	push @{$self->_proceduryWP}, { nr => $prNr, parametrow => 0 }; 
	return $self;
}

sub proceduraWywolana
{
	my $self = shift;
	my $prW = pop @{$self->_proceduryWP};
	# ilosc parametrow deklarowanych w funkcji
	my $parametrowDef = @{ $self->_proceduryDP->[ $prW->{nr} ]->{parametry} };
	# lista argumentow wywolania sie ustalila, ich ilosc porownywana jest z definicja procedury
	if( $prW->{parametrow} < $parametrowDef ) {
		die "Za mało parametrów";
	}
	return $prW->{nr};
}

sub zwrot
{
	my $self = shift;
	# zwraca zmienna o masce definicji procedury wywolywanej
	return ${$self->_proceduryDP} [${$self->_proceduryWP} [$#{self->_proceduryWP}] ->{nr} ];
}

sub nowyParametr
{
	my $self = shift;
	# indeks szczytu stosu wywolan funkcji
	my $ostIdx = $#{ $self->_proceduryWP };
	# inkrementacja ilosci wywolywanych argumentow biezacej funkcji
	${$self->_proceduryWP()} [$ostIdx] ->{parametrow}++;
	my $z = 1;
}

sub koniecParametru
{
	my $self = shift;
	# indeks szczytu stosu wywolan funkcji
	my $ostIdx = $#{ $self->_proceduryWP };
	# dekrementacja ilosci parametrow biezacego wywolania funkcji
	my $parametrWNr = $self->_proceduryWP->[ $ostIdx ]->{parametrow} - 1;# = $self->_proceduryWP->[ $ostIdx ]->{parametrow} - 1;
	# Sciagniecie listy parametrow z definicji wywolywanej funkcji
	my @parametry = @{ $self->_proceduryDP-> [ $self->_proceduryWP->[ $ostIdx ]->{nr} ] ->{parametry} };
	if(not defined $parametry[$parametrWNr]) {
		die "Za duzo parametrow.";
	}
	# ewentualna konwersja typow argumentu wywolywanego i parametru definicji funkcji
	if($self->_onpP->czyNiepusty) {
		my $z1 = $self->_onpP->zdejmij; # pop @{ $self->_stosWrzutowP };
		my $z2 = $parametry[$parametrWNr];
		$self->_syntezaP->konwertuj21D($z1, $z2);
		$self->_onpP->wloz( $z2 ); # push @{ $self->_stosWrzutowP }, $z2; #TODO spr $z2 jest bez -> {pozycja}
	}
}


1;