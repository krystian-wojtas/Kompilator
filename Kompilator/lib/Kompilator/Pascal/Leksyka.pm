#!/usr/bin/perl
package Kompilator::Pascal::Leksyka;
use strict;
use warnings;
use Carp;

sub new
{
    my ($class, $opisP, $tP, $zrodloP) = @_;
    my @opis = @{$opisP};
    my $t3 = @{$tP}[2];
    my $t4 = @{$tP}[3];
    my $t5 = @{$tP}[4];
    
    #wczytywanie klasyfikacji
	my @klasyfikacja;
	foreach my $linia (@opis) {
		# @	!"(\w|_|\+|-|\$|~|#|&|@)*"!	!!		!literal znakowy!
		# t1	->
		# t2	#
		# t3	@
		# t4	!
		if($linia =~ /^\s*(\w+)[^$t3]*$t3\s*$t4([^$t4]+)$t4\s*$t4([^$t4]*)$t4\s*$t4([^$t4]*)$t4/) {
			push @klasyfikacja, { produkcja => $1, wzorzec => "($2)", terminator => "($3)", opis => $4 }; # TODO produkcja -> klasa
		}
	}
	
	my $self = {};
	bless $self, $class;
	$self->zrodloP( $zrodloP );
	$self->_klasyfikacjaP( \@klasyfikacja );
	$self->_leksemyP( [] );
    return $self;
}

sub zrodloP { $_[0]->{zrodloP}=$_[1] if defined $_[1]; $_[0]->{zrodloP} }
sub _klasyfikacjaP { $_[0]->{klasyfikacja}=$_[1] if defined $_[1]; $_[0]->{klasyfikacja} }
sub klasyfikacjaP { { $_[0]->_klasyfikacjaP } } # zwraca wskaznik do kopii orginalu
sub _leksemyP { $_[0]->{leksemy}=$_[1] if defined $_[1]; $_[0]->{leksemy} }
sub leksemyP { $_[0]->_leksemyP }
#sub leksemyP { [ @{$_[0]->_leksemyP} ] } #zwraca wskaznik do kopii, chociaz z drugiej strony wcale nie jest potrzebne chronienie orginalu 
#Depracated: Nalezy poslugiwac sie jednym adresem leksemow w calym programie.
#Jeden adres dla kilku osobnych analiz dla testow - wtedy prosto wyczyscic kolejke
#Znaleziony bug stosujac funkcje przekazujaca kopie:
#Jeden adres wazny dla aspektow. W obecnej implementacji tworze raz nowa tablice kolejki i przy stawianiu obiektow dostaje go Kompilator::Debug::Pascal::Leksyka przez getter _leksemyP
#Jesli getter tworzyl nowa tablice podobna do orginalnej, to w momencie stawiania orginalna byla pusta i przekazal adres do nowej pustej
#Nowa pusta puslugiwal sie Kompilator::Debug::Pascal::Leksyka podczas swojego zycia, wiec nic z niej nie wyciagnal, w miedzyczasie orginal sie normalnie zapelnial
#Inne podejscie: gwarantujac poslugiwanie sie pomocnicza metoda dolozLeksem, mozna zainstalowac na niej wrapper i przechwytywac dodawany leksem.
#Dodawany leksem rownoczesnie dodawac do prywatnej kolejki Kompilator::Debug::Pascal::Leksyka

sub analizuj
{
	my $self = shift;
	my @zrodlo = @{$self->zrodloP};
	my @klasyfikacja = @{$self->_klasyfikacjaP};
	@{$self->_leksemyP} = (); # wyczyszczenie kolejki bez zmiany adresu tablicy
	
	#analiza leksykalna	
	my $leksem;
	my $koniec;
	my $klasyfikacjaNr;
	my $linia = 1;
	foreach my $znaki (@zrodlo) {
		my $ucieteZnaki = 0;
		my $poczatek;
		do {
			$poczatek = -1;
			$leksem = { slowo => 0, opis => 0, klasyfikacjaNr => 0, linia => 0, poczatek => -1};
			for my $klasa ( @klasyfikacja ) {
				if($znaki =~ /(\s*$klasa->{wzorzec}$klasa->{terminator})/) {
					my $p = $-[0];
					$1 =~ /$klasa->{wzorzec}/;
					my( $produkcja, $slowo_, $opis_, $poczatek_, $koniec_ ) = ( $klasa->{produkcja}, $1, $klasa->{opis}, $p + $-[0], $p + $+[0] );
					if($poczatek < 0 or $poczatek_ < $poczatek) {
						$leksem->{produkcja} = $produkcja;
						$leksem->{slowo} = $slowo_;
						$leksem->{opis} = $opis_;
						$leksem->{linia} = $linia;
						$leksem->{poczatek} = $poczatek_ + $ucieteZnaki;
						$poczatek = $poczatek_;
						$koniec = $koniec_;
					}
				}
			}
			if($poczatek >= 0) {
				my $ucieteSpacje = length $leksem->{slowo};
				$leksem->{slowo} =~ s/^\s+//;
				$ucieteSpacje -= length $leksem->{slowo};
				$ucieteZnaki += $ucieteSpacje + $koniec;
				$znaki = substr $znaki, $koniec;
				#normalnie w tym miejscu
				push @{$self->_leksemyP}, $leksem;
				#jednak dla potrzeb debugowania moznaby wywolywac ten fragment w osobnej funkcji
				#dzieki temu mozna sie podpiac do rosnacego stosu aspektem
				#$self->dolozLeksem( $leksem );
			}
		} while($poczatek >= 0);
		$linia++;
	}
	
	return $self;
}

sub dolozLeksem
{
	my $self = shift;
	my $leksem = shift;
	push @{$self->_leksemyP}, $leksem;
	return $self;
}


1;