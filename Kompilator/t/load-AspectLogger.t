#!perl -T

use Test::More tests => 8;

BEGIN {
	use_ok( 'Kompilator' ) || BAIL_OUT('Nie można załadować klasy Kompilator podczas kompilacji');
	use_ok( 'Kompilator::Debug::AspectDebugger' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Debug::AspectDebugger podczas kompilacji');
	use_ok( 'Kompilator::Debug::Api::Drzewo' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Debug::Api::Drzewo podczas kompilacji');
	use_ok( 'Kompilator::Debug::Pascal::Leksyka' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Debug::Pascal::Leksyka podczas kompilacji');
}
require_ok( 'Kompilator' ) || BAIL_OUT('Nie można załadować klasy Kompilator podczas kompilacji');
require_ok( 'Kompilator::Debug::AspectDebugger' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Debug::AspectDebugger podczas kompilacji');
require_ok( 'Kompilator::Debug::Api::Drzewo' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Debug::Api::Drzewo podczas kompilacji');
require_ok( 'Kompilator::Debug::Pascal::Leksyka' ) || BAIL_OUT('Nie można załadować klasy Kompilator::Debug::Pascal::Leksyka podczas kompilacji');

diag( "Test srodowiska, $Kompilator::VERSION, Perl $], $^X" );
