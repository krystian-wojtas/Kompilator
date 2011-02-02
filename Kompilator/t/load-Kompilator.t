#!perl -T

use Test::More tests => 18;

BEGIN {
	use_ok( 'Kompilator' ) || BAIL_OUT('Nie można załadować klasy Kompilator podczas kompilacji');
	use_ok( 'Kompilator::Api::Drzewo' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Api::Drzewo podczas kompilacji');
	use_ok( 'Kompilator::Api::Konfigurator' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Api::Konfigurator podczas kompilacji');
	use_ok( 'Kompilator::Api::PodstKonfiguratorImpl' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Api::PodstKonfiguratorImpl podczas kompilacji');
	use_ok( 'Kompilator::Pascal::Leksyka' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Pascal::Leksyka podczas kompilacji');
	use_ok( 'Kompilator::Pascal::Syntaktyka' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Pascal::Syntaktyka podczas kompilacji');
	use_ok( 'Kompilator::Pascal::Semantyka' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Pascal::Semantyka podczas kompilacji');
	use_ok( 'Kompilator::Java::Synteza' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Java::Synteza podczas kompilacji');
	use_ok( 'Kompilator::Debug::AspectDebugger' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Debug::AspectDebugger podczas kompilacji');
}
require_ok( 'Kompilator' ) || BAIL_OUT('Nie można załadować klasy Kompilator w czasie wykonania');
require_ok( 'Kompilator::Api::Drzewo' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Api::Drzewo podczas kompilacji');
require_ok( 'Kompilator::Api::Konfigurator' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Api::Konfigurator w czasie wykonania');
require_ok( 'Kompilator::Api::PodstKonfiguratorImpl' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Api::PodstKonfiguratorImpl w czasie wykonania');
require_ok( 'Kompilator::Pascal::Leksyka' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Pascal::Leksyka w czasie wykonania');
require_ok( 'Kompilator::Pascal::Syntaktyka' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Pascal::Syntaktyka w czasie wykonania');
require_ok( 'Kompilator::Pascal::Semantyka' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Pascal::Semantyka w czasie wykonania');
require_ok( 'Kompilator::Java::Synteza' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Java::Synteza w czasie wykonania');
require_ok( 'Kompilator::Debug::AspectDebugger' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Debug::AspectDebugger w czasie wykonania');

diag( "Test srodowiska, $Kompilator::VERSION, Perl $], $^X" );
