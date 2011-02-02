#!/usr/bin/perl
package Kompilator::Api::Semantyka::Zmienne;
use strict;
use warnings;
use feature "switch";


sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$self->_nazwyZmiennychP( [] );
	$self->_zmienneLP( [] );
	$self->_zmienneGP( [] );
	
	return $self;
}

# w jednej linii analizowanego kodu zrodlowego moze zawierac sie deklaracja kilku nazw zmiennych tego samego typu
sub _nazwyZmiennychP { $_[0]->{nazwyZmiennychP}=$_[1] if defined $_[1]; $_[0]->{nazwyZmiennychP} }
sub _deklZmMaska { $_[0]->{deklZmMaska}=$_[1] if defined $_[1]; $_[0]->{deklZmMaska} }
sub _zmienneLP { $_[0]->{zmienneL}=$_[1] if defined $_[1]; $_[0]->{zmienneL} }
sub _zmienneGP { $_[0]->{zmienneG}=$_[1] if defined $_[1]; $_[0]->{zmienneG} }


sub deklZmNazwa
{
	my ( $self, $nazwa ) = @_;
	# dodaje kolejna nazwe zmiennej do deklaracji typu
	push @{ $self->_nazwyZmiennychP }, $nazwa;	
	return $self;
}


sub deklZmMaska
{
	my ( $self, $typ, $arAA ) = @_;
	# rodzaj wartosci zmieni sie przy koncu deklaracji
	my $maskaZmiennych = '0';
	# zmienna tablicowa
	if($arAA) {
		$maskaZmiennych .= '1';
	}
	else {
		$maskaZmiennych .= '0';
	}
	# wlasciwy typ prosty
	$maskaZmiennych .= $typ;
	# zapisanie w obiekcie biezacy typ deklarowanych zmiennych
	$self->_deklZmMaska( $maskaZmiennych );
	return $self;
}


sub deklZm
{
	my $self = shift;
	my $zmiennePointer;
	# kazdej wrzucanej zmiennej przyporzadkowuje sie pozycje - indeks w tablicy globalnej lub numer porzadkowy z tablic lokalnych
	my $pozycja = 0;
	# jesli jestesmy w miejscu, gdzie wystepuja zmienne lokalne, to do nich jest ladowana nowa deklaracja
	if(@{$self->_zmienneLP}) {
		# wskazanie na najwyzsza tablice ze stosu tablic lokalnych
		$zmiennePointer = $self->_zmienneLP->[ $#{$self->_zmienneLP} ];
		# znalezienie numeru porzadkowego przypadajacego tej deklaracji.
		# Jest to suma wszystkich deklaracji lokalnych na wszystkich poziomach
		for( my $i = 0; $i < @{$self->_zmienneLP}; $i++ ) {
			$pozycja += @{ $self->_zmienneLP->[$i] };
		}
		# ustawienie flagi zasiegu lokalnego
		$self->_deklZmMaska =~ /^\d(\d\d)$/;
		$self->_deklZmMaska( '3'.$1 );
	}
	# nie ma zasiegu zmiennych lokalnych, deklaracja jest globalna
	else {
		# wskazanie na tablice globalnych
		$zmiennePointer = $self->_zmienneGP;
		# pozycja jest po prostu kolejnym indeksem globalnych
		$pozycja = @{$zmiennePointer};
		# ustawienie flagi zasiegu globalnego
		$self->_deklZmMaska =~ /^\d(\d\d)$/;
		$self->_deklZmMaska( '2'.$1 );
	}
	# dla kazdej zlapanej nazwy zmiennej ..
	foreach my $nazwaZmiennej ( @{$self->_nazwyZmiennychP} ) {
		# .. upewnij sie ze nie jest juz zadeklarowana na tym poziomie ..
		foreach my $nazwaZadeklZm (@{$zmiennePointer}) {
			if($nazwaZmiennej =~ /^$nazwaZadeklZm->{nazwa}$/) {
				die "Zmienna jest juz zadeklarowana na tym poziomie.";
			}
		}
		# .. i dopisz do tablicy, ktora okreslilismy, na pozycje, ktora okreslilismy
		push @{$zmiennePointer}, { nazwa => $nazwaZmiennej, maska => $self->_deklZmMaska, pozycja => $pozycja };
		$pozycja++;
	}
	$self->_nazwyZmiennychP( [] );
	$self->_deklZmMaska( '000' );
}


sub dolozStosLok
{
	my $self = shift;
	push @{$self->_zmienneLP}, [];
	return $self;
}


sub zdejmijStosLok
{
	my $self = shift;
	pop @{$self->_zmienneLP};
	return $self;
}


sub wyczyscLokale
{
	my $self = shift;
	@{ $self->_zmienneLP } = ();
	return $self;
}

sub wywolanieZmiennej
{
	my ( $self, $nazwaZmiennej ) = @_;
	my $znalezionaZm = 0;
	# przeszukanie tablic lokalnych
	for(my $i = $#{$self->_zmienneLP}; $i >= 0 and $znalezionaZm == 0; $i--) {
		#TODO bez pomocniczej tablicy
		my @zmienneLokalnePointer = @{$self->_zmienneLP->[$i]};
		my $a = $#zmienneLokalnePointer;
		for( my $j = $#zmienneLokalnePointer; $j >= 0 and $znalezionaZm == 0; $j-- ) {
			#TODO del
			my $c = $zmienneLokalnePointer[$j]->{nazwa};
			if($zmienneLokalnePointer[$j]->{nazwa} =~ /^$nazwaZmiennej$/) {
				$znalezionaZm = $zmienneLokalnePointer[$j];
			}
		}
	}
	# przeszukanie tablicy globalnej
	if($znalezionaZm == 0) {
		#TODO dlaczego $i = 0 w pierwszej iteracji a globalnych sa 2
		for(my $i = $#{$self->_zmienneGP}; $i >= 0 and $znalezionaZm == 0; $i--) {
			if($self->_zmienneGP->[$i]->{nazwa} =~ /^$nazwaZmiennej$/) {
				$znalezionaZm = $self->_zmienneGP->[$i];
			}
		}
	}
	if($znalezionaZm == 0) {
		#TODO poczatek
		#TODO funkcja zwracajaca stringa polozenia debug
		die "Nie zadeklarowano zmiennej";
	}
	return $znalezionaZm;
}


sub alokacjaZm
{
	my ( $self, $zm ) = @_;
	given($zm->{maska}) {
		when(/^\d0\d$/) {
			die "Nie mozna zaalokawac pamieci do zmiennej skalarnej";
		}
		when(/^(\d)1(\d)$/) {
			$zm->{maska} = $1.'2'.$2;
		}
		when(/^\d2\d$/) {
			die "Tablica jest juz zaalokowana";
		}
	}
	return $self;
}


sub zwolnienieZm
{
	my ( $self, $zm ) = @_;
	given($zm->{maska}) {
		when(/^\d0\d$/) {
			die "Nie mozna zwolnic pamieci zmiennej skalarnej";
		}
		when(/^(\d)1(\d)$/) {
			die "Nie mozna zwolnic niezaalokowanej tablicy";
		}
		when(/^(\d)2(\d)$/) {
			$zm->{maska} = $1.'1'.$2;
		}
	}
	return $self;
}

1;