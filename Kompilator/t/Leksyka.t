#!perl -T

use Test::More tests => 4;

BEGIN {
    use_ok( 'Kompilator::Pascal::Leksyka' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Pascal::Leksyka podczas kompilacji');
}
require_ok( 'Kompilator::Pascal::Leksyka' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Pascal::Leksyka w czasie wykonania');
diag( "Test Leksyka $Kompilator::VERSION, Perl $], $^X" );

use strict;
use warnings;
use Carp;
use Data::Dumper;

#nie moge utworzyc bezposrednio obiektu PodstKonfiguratorImpl, bo potrzebuje on pliku zrodlowego
#a zrodla sa tworzone w testach na wlasne potrzeby
open(OPIS, '<', 'opis.ass') or croak "Nie mozna czytac pliku opis.ass\n$!";
my @opis = <OPIS>;
close(OPIS);
	
my @t = ($opis[0], $opis[1], $opis[2], $opis[3], $opis[4]);
foreach my $tt (@t) { 
	#obciecie poczatkowych i koncowych bialych znakow
	$tt =~ s/\s+$//;
	$tt =~ s/^\s+//; 
}
my $zrodloP = [];
	
my $analizatorLeksykalny = new Kompilator::Pascal::Leksyka( \@opis, \@t, $zrodloP );
my $leksemyP;

subtest 'Odroznienie slow kluczowych od nazw wlasnych' => sub {
	plan tests => 8;

	@$zrodloP = ( " returnD return reRUrn Dreturn\n" );
	$analizatorLeksykalny->analizuj();
	$leksemyP = $analizatorLeksykalny->leksemyP;
	
	is(@$leksemyP[0]->{produkcja}, 'NAZWA');
	is(@$leksemyP[0]->{slowo}, 'returnD');
	
	is(@$leksemyP[1]->{produkcja}, 'RETURN');
	is(@$leksemyP[1]->{slowo}, 'return');
	
	is(@$leksemyP[2]->{produkcja}, 'NAZWA');
	is(@$leksemyP[2]->{slowo}, 'reRUrn');
	
	is(@$leksemyP[3]->{produkcja}, 'NAZWA');
	is(@$leksemyP[3]->{slowo}, 'Dreturn');
};

subtest 'Rozpoznanie liczb zmienno- i staloprzecinkowych' => sub {
	plan tests => 8;

	@$zrodloP = ( " 1 2 1.2 3\n" );
	$analizatorLeksykalny->analizuj();
	$leksemyP = $analizatorLeksykalny->leksemyP;
	
	is(@$leksemyP[0]->{produkcja}, 'LICZBAINT');
	is(@$leksemyP[0]->{slowo}, '1');
	
	is(@$leksemyP[1]->{produkcja}, 'LICZBAINT');
	is(@$leksemyP[1]->{slowo}, '2');
	
	is(@$leksemyP[2]->{produkcja}, 'LICZBAF');
	is(@$leksemyP[2]->{slowo}, '1.2');
	
	is(@$leksemyP[3]->{produkcja}, 'LICZBAINT');
	is(@$leksemyP[3]->{slowo}, '3');
};

#open(DEBUG, '>', 'debug.out') or croak "Nie mozna czytac pliku debug.out\n$!";
#print DEBUG Data::Dumper->Dump( $leksemyP );
#close(DEBUG);
