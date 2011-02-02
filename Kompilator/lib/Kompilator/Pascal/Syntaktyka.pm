#!/usr/bin/perl
package Kompilator::Pascal::Syntaktyka;
use Kompilator::Api::Drzewo;
use strict;
use warnings;
use feature "switch";

sub new
{
	my ($class, $opisP, $tP) = @_;
	my @opis = @{$opisP};
	my $t1 = @{$tP}[0];
	my $t2 = @{$tP}[1];
	my $t3 = @{$tP}[2];
	my $drzewo = new Kompilator::Api::Drzewo();
	
	#hash pomocniczy rozwijajacy produkcje w tablice symboli
	my %gramatyka;
	foreach my $linia (@opis) {
		 if($linia =~ /^\s*(\w+)\s*$t1\s*(((\w+\s+)|(\d+\s+))*)/) {
			$gramatyka{$1} = [ split (/\s/, $2) ] ;
		}
	}

	#tablica pomocnicza zwracajaca z kolejnego numeru klasy jej nazwe
	my @nrKlasyNazwa = ();
	foreach my $linia (@opis) {
		 if($linia =~ /^\s*([A-Z]+)/) {
			push @nrKlasyNazwa, $1;
		}
	}

	#wczytanie tablicy parsingu
	my %parsing;
	foreach my $linia (@opis) {
		 if($linia =~ /^\s*(\w+)\s*$t1[^$t2]*$t2\s*((\w+\s+)+)/) {
			$parsing{$1} = {};
			my @tablicaParsingu = ( split (/\s/, $2) );
			for( my $i = 0; $i < @tablicaParsingu; $i++ ) {
				$parsing{$1}->{ $nrKlasyNazwa[$i] } = $gramatyka{ $tablicaParsingu[$i] };
			}
		}
	}
	
	my $self = {};
	bless $self, $class;
	$self->gramatykaP(\%gramatyka);
	$self->parsingP(\%parsing);
	$self->_drzewoP($drzewo);
    return $self;
}

sub gramatykaP { $_[0]->{gramatyka}=$_[1] if defined $_[1]; $_[0]->{gramatyka} }
sub parsingP { $_[0]->{parsing}=$_[1] if defined $_[1]; $_[0]->{parsing} }
sub leksemyP { $_[0]->{leksemy}=$_[1] if defined $_[1]; $_[0]->{leksemy} }
sub _drzewoP { $_[0]->{drzewo}=$_[1] if defined $_[1]; $_[0]->{drzewo} }
sub drzewoP { $_[0]->_drzewoP }

sub analizuj
{
	my $self = shift;
	$self->leksemyP($_[0]);
	my @leksemy = @{$self->leksemyP};
	my %gramatyka	= %{$self->gramatykaP};
	my %parsing		= %{$self->parsingP};
	my $drzewo		= $self->_drzewoP;
	
	#analiza syntaktyczna
	my $leksem = shift(@leksemy);
	my @stosy;
	push @stosy, [ "program" ]; # TODO przeniesc do pliku opisu nazwe program ?
	my $aktualnyStosP;
	my $aktualnaProdukcja;
	my $nastepnaProdukcja;
	my $poprzedniaProdukcja;
	my $panicMode = 0;
	my $err = 0;
	while(@stosy) {
		$aktualnyStosP = pop(@stosy);
		if(not @{$aktualnyStosP}) {
			$drzewo->parent();
		}
		else {
			$aktualnaProdukcja = shift( @{$aktualnyStosP} );
			
			given($aktualnaProdukcja) {
				when (/ERR/) {
					if($panicMode == 0) {
						#warning::warnif ?
						printf "BLAD, dla produkcji $poprzedniaProdukcja znaleziono niespodziewane slowo '$leksem->{slowo}', nr typu $leksem->{klasyfikacjaNr}, linia $leksem->{linia}, poczatek $leksem->{poczatek}\n";
					}
					else {
						printf "BLAD, brakuje produkcji $poprzedniaProdukcja w linii $leksem->{linia}\n";
					}
					$panicMode = 1;
					$err = 1;
					$drzewo->parent();
				}
				#TODO del, for debug purpose only
				when (/deklaracja$/) {
					continue;
				}
				when (/^[A-Z]/) {
					if(/EPSILON/) {
						my $produkcjaEpsilon = $drzewo->zrobEpsilon($leksem);
						$drzewo->textNode($produkcjaEpsilon);
					}
					else {
						$drzewo->textNode($leksem);
						$leksem = shift(@leksemy);
					}
					push @stosy, $aktualnyStosP;
					$panicMode = 0;
				}
				default {
					push @stosy, $aktualnyStosP;
					$drzewo->appendChild($aktualnaProdukcja);
					die "Bledna tablica parsingu\nNie zdefiniowano $leksem->{slowo} z klasy $leksem->{produkcja} dla produkcji $aktualnaProdukcja\n"
						if not defined $parsing{ $aktualnaProdukcja }->{ $leksem->{produkcja} };
					#wyrazenie rozwija w tablice symboli, rzucana na stosy, nastepna produkcje pozyskana ze skrzyzowania warunkow obecnej produkcji i badanego leksemu 
					push @stosy, [ @{ $parsing{ $aktualnaProdukcja }->{ $leksem->{produkcja} } } ];
					$poprzedniaProdukcja = $aktualnaProdukcja;
				}
			}
		}
	}
	if($err) {
		printf "ERRORY\n";
		die "Wystapily bledy podczas analizy syntaktycznej\n";
	}
	return $self;
}

1;
