#!/usr/bin/perl
package Kompilator::Api::PodstKonfiguratorImpl;
use Kompilator::Api::Konfigurator;
use strict;
use warnings::register;
use Carp;
use constant {
	OPISPLIK => 'opis.ass',	#opis frontu jezyka
	KONFIGPLIK => 'konfig.cfg',	#konfiguracja kompilatora
	ZRODLOPLIK => 'in.pas'	#zrodlo do analizy
};
use feature "switch";

our @ISA = qw(Kompilator::Api::Konfigurator);

sub _init
#	Nadpisuje ta metode z klasy bazowej.
#	Ma zadanie wczytac zewnetrzne pliki
#	Odczytuje ustawienia programu przekazane jako parametry linii komend lub zapisane w pliku
#	Najpierw przetwarzana jest linia komend aby zauwazyc nazwe pliku z zapisanymi ustawieniami
#	Nastepnie zastosowywane sa ustawienia z pliku i na koncu znow linia komend, ktora ma priorytet
{
	my $self = shift;
	#domyslne nazwy plikow
	$self->_opisPlik(OPISPLIK);
	$self->_konfigPlik(KONFIGPLIK);
	$self->_zrodloPlik(ZRODLOPLIK);
	
	#pierwszy odczyt parametrow linii komend do wyszukania nazwy pliku z konfigiem
	$self->_konfigurujParametry( $self->_parametry() );
	my @konfiguracjaPlik = ();
	if(-e $self->_konfigPlik() ) {
		open(KONFIG, '<', $self->_konfigPlik() );
		@konfiguracjaPlik = <KONFIG>;
		close(KONFIG);
	}
	else {
		 warnings::warnif "Nie mozna czytac pliku $self->_konfigPlik()\n$!"
	}
	#ustawienia z pliku
	$self->_konfigurujParametry( \@konfiguracjaPlik ) if @konfiguracjaPlik;
	#.. ale priorytet dla ustawien z linii komend
	#jesli w pliku nie bylo zadnej konfiguracji, to pierwszy, wstepny odczyt ustawil juz wszystko
	$self->_konfigurujParametry( $self->_parametry() ) if @konfiguracjaPlik; 
	
	open(OPIS, '<', $self->_opisPlik()) or croak "Nie mozna czytac pliku $self->_opisPlik()\n$!";
	my @opis = <OPIS>;
	close(OPIS);
	$self->opisP(\@opis);
	
	my @t = ($opis[0], $opis[1], $opis[2], $opis[3], $opis[4]);
	foreach my $tt (@t) { 
		#obciecie poczatkowych i koncowych bialych znakow
		$tt =~ s/\s+$//;
		$tt =~ s/^\s+//; 
	}
	$self->tP(\@t);
	
	open(ZRODLO, '<', $self->_zrodloPlik()) or croak "Nie mozna czytac pliku $self->_zrodloPlik()\n$!";
	my @zrodlo = <ZRODLO>;
	close(ZRODLO);
	$self->zrodloP(\@zrodlo);
	
	return $self;
}

sub _opisPlik { $_[0]->{opisPlik}=$_[1] if defined $_[1]; $_[0]->{opisPlik} }
sub _konfigPlik { $_[0]->{konfigPlik}=$_[1] if defined $_[1]; $_[0]->{konfigPlik} }
sub _zrodloPlik { $_[0]->{zrodloPlik}=$_[1] if defined $_[1]; $_[0]->{zrodloPlik} }

sub _konfigurujParametry
{
	my $self = shift;
	my @parametry = @{$_[0]};
	#wczytywanie parametrow programu
	for( my $i = 0; $i < @parametry; $i++) {
		given($parametry[$i]) {
			when(/^\s*opisPlik\s*=\s*([^\n]+)/) {
				$self->_opisPlik( $1 );
			}
			when(/^\s*konfigPlik\s*=\s*([^\n]+)/) {
				$self->_konfigPlik( $1 );
			}
			when(/^\s*zrodloPlik\s*=\s*([^\n]+)/) {
				$self->_zrodloPlik( $1 );
			}
			when(/^\s*wyjsciePlik\s*=\s*([^\n]+)/) {
				$self->wyjsciePlik( $1 );
			}
			when(/\s*([^=]+)\s*=\s*([^\n]+)/) { #=\s*(^[\n]+) ?
				$self->konfiguracjaP->{$1} = $2; 
			}
		}
	}
}

1;
