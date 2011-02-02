#!/usr/bin/perl
use FindBin;                 # locate this script
use lib "$FindBin::Bin/..";  # use the parent directory
use Kompilator::Api::PodstKonfiguratorImpl;
use Kompilator::Pascal::Leksyka;
use Kompilator::Pascal::Syntaktyka;
use Kompilator::Pascal::Semantyka;
use Kompilator::Java::Synteza;
use Kompilator::Debug::AspectDebugger;
use strict;
use warnings;

#wykonanie analiz, obsluga wyjatkow
eval {
	my $konf = new Kompilator::Api::PodstKonfiguratorImpl(@ARGV);
	my $analizatorLeksykalny = new Kompilator::Pascal::Leksyka( $konf->opisP(), $konf->tP(), $konf->zrodloP() ); 
	my $analizatorSyntaktyczny = new Kompilator::Pascal::Syntaktyka( $konf->opisP(), $konf->tP() );
	my $syntezator = new Kompilator::Java::Synteza( $konf->wyjsciePlik );
	my $analizatorSemantyczny = new Kompilator::Pascal::Semantyka( $konf->opisP(), $konf->tP(), $analizatorSyntaktyczny->drzewoP->korzenP, $syntezator );
	my $debug = new Kompilator::Debug::AspectDebugger( $konf->konfiguracjaP, $analizatorLeksykalny, $analizatorSyntaktyczny, $analizatorSemantyczny, $syntezator );
	
	$analizatorLeksykalny->analizuj();
	$analizatorSyntaktyczny->analizuj( $analizatorLeksykalny->leksemyP() );
	$analizatorSemantyczny->analizuj( $analizatorSyntaktyczny->drzewoP() );
	print "SuccesFull\n";
};
if($@) {
	print "EXEPTIONS:\n";
	foreach my $err ($@) {
		print "EXCEPTION $err\n";
	}
}
