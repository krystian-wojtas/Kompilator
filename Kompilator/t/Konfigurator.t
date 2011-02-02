#!perl -T

use Test::More tests => 3;
use Test::Exception;
use strict;
use warnings;

BEGIN {
    use_ok( 'Kompilator::Api::Konfigurator' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Api::Konfigurator podczas kompilacji');
}
require_ok( 'Kompilator::Api::Konfigurator' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Api::Konfigurator w czasie wykonania');

#diag( "Test Konfigurator $Kompilator::VERSION, Perl $], $^X" );

use FindBin;                 # locate this script
use lib "$FindBin::Bin/..";  # use the parent directory
use Kompilator::Api::Konfigurator;
throws_ok { new Kompilator::Api::Konfigurator } qr/Klasa abstrakcyjna/, 'Konstrukcja obiektu zakonczona porazka, ok';
#Kompilator::Api::Konfigurator::parametry;
#throws_ok { Kompilator::Api::Konfigurator::parametry } qr/Should call parametry() with an object, not a class/, 'Nie mozna pobrac z klasy wlasciwosci obiektu, ok';
#throws_ok { Kompilator::Api::Konfigurator::opisP } qr/Should call opisP() with an object, not a class/, 'Nie mozna pobrac z klasy wlasciwosci obiektu, ok';
#throws_ok { Kompilator::Api::Konfigurator::tP } qr/Should call tP() with an object, not a class/, 'Nie mozna pobrac z klasy wlasciwosci obiektu, ok';
#throws_ok { Kompilator::Api::Konfigurator::konfigPlik } qr/Should call konfigPlik() with an object, not a class/, 'Nie mozna pobrac z klasy wlasciwosci obiektu, ok';
#throws_ok { Kompilator::Api::Konfigurator::zrodloPlik } qr/Should call zrodloPlik() with an object, not a class/, 'Nie mozna pobrac z klasy wlasciwosci obiektu, ok';
#throws_ok { Kompilator::Api::Konfigurator::konfiguracja } qr/Should call konfiguracja() with an object, not a class/, 'Nie mozna pobrac z klasy wlasciwosci obiektu, ok';
