#!/usr/bin/perl
package Kompilator::Debug::AspectDebugger;
use Kompilator::Debug::Api::DrzewoPlain;
use Kompilator::Debug::Api::DrzewoSvg;
use Kompilator::Debug::Api::Synteza::ONP;
use Kompilator::Debug::Pascal::Leksyka;
use Kompilator::Debug::Java::Synteza;
use Kompilator::Pascal::Semantyka;
use Aspect; # w bashu jako root cpan -i Aspect
use strict;
use warnings;
use feature "switch";


sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$self->_konfiguracja( shift );
	$self->_leksyka( shift );
	$self->_syntaktyka( shift );
	$self->_semantyka( shift );
	$self->_syntezator( shift );
	$self->_init;
	return $self;
}

sub _konfiguracja { $_[0]->{konfiguracja}=$_[1] if defined $_[1]; $_[0]->{konfiguracja} }
sub _leksyka { $_[0]->{leksyka}=$_[1] if defined $_[1]; $_[0]->{leksyka} }
sub _syntaktyka { $_[0]->{syntaktyka}=$_[1] if defined $_[1]; $_[0]->{syntaktyka} }
sub _semantyka { $_[0]->{semantyka}=$_[1] if defined $_[1]; $_[0]->{semantyka} }
sub _syntezator { $_[0]->{syntezator}=$_[1] if defined $_[1]; $_[0]->{syntezator} }

sub _init
{
	my $self = shift;
	my %konfiguracja = %{$self->_konfiguracja};
	my $leksykaDefinicjePlik = '';
	my $leksykaWyjsciePlik = '';
	my $drzewoPlainPlik = '';
	my $drzewoSvgPlik = '';
	my $drzewoSvgTpl = '';
	my $syntezaWywolaniaPlik = '';
	my $onpPlik = '';
	my $wywolaniaSyntezaOnpPlik = '';
	
	
	while ( my ($key, $value) = each %konfiguracja ) {
		given($key) {
			when(/leksykaDefinicjePlik/) {
				$leksykaDefinicjePlik = $value;
			}
			when(/leksykaWyjsciePlik/) {
				$leksykaWyjsciePlik = $value;
			}
			when(/drzewoPlainPlik/) {
				$drzewoPlainPlik = $value;
			}
			when(/drzewoSvgPlik/) {
				$drzewoSvgPlik = $value;
			}
			when(/drzewoSvgTpl/) {
				$drzewoSvgTpl = $value;
			}
			when(/syntezaWywolaniaPlik/) {
				$syntezaWywolaniaPlik = $value;
			}
			when(/onpPlik/) {
				$onpPlik = $value;
			}
			when(/wywolaniaSyntezaOnpPlik/) {
				$wywolaniaSyntezaOnpPlik = $value;
			}
		}
	}
	
	my $leksykaDebug = new Kompilator::Debug::Pascal::Leksyka( $self->_leksyka->klasyfikacjaP, $self->_leksyka->leksemyP, $leksykaDefinicjePlik, $leksykaWyjsciePlik )
		if $konfiguracja{leksykaDefinicje} or $konfiguracja{leksykaWyjscie};
	if($konfiguracja{leksykaDefinicje}) {
		after {
			$leksykaDebug->drukujDefinicje();
		} call qr/^Kompilator::Pascal::Leksyka::analizuj/;
	}
	if($konfiguracja{leksykaWyjscie}) {
		after {
			$leksykaDebug->drukujWyjscie();
		} call qr/^Kompilator::Pascal::Leksyka::analizuj/;
	}
	
	if($konfiguracja{drzewoPlain}) {
		my $drzewoPlain = new Kompilator::Debug::Api::DrzewoPlain( $self->_syntaktyka->drzewoP, $drzewoPlainPlik );
		after {
			$drzewoPlain->appendChild();
		} call qr/^Kompilator::Api::Drzewo::appendChild/;
		after {
			$drzewoPlain->parent();
		} call qr/^Kompilator::Api::Drzewo::parent/;
		after {
			my @a = @_;
			my $leksemP = $_->{params}[1]; # sciagam parametr wywolania metody
			$drzewoPlain->textNode( $leksemP );
		} call qr/^Kompilator::Api::Drzewo::textNode/;
		after {
			$drzewoPlain->wyjscie();
		} call qr/^Kompilator::Pascal::Syntaktyka::analizuj/;
	}
	
	if($konfiguracja{drzewoSvg}) {
		my $drzewoSvg = new Kompilator::Debug::Api::DrzewoSvg( $self->_syntaktyka->drzewoP, $drzewoSvgPlik, $drzewoSvgTpl );
		after {
			$drzewoSvg->appendChild();
		} call qr/^Kompilator::Api::Drzewo::appendChild/;
		after {
			$drzewoSvg->parent();
		} call qr/^Kompilator::Api::Drzewo::parent/;
		after {
			my @a = @_;
			my $leksemP = $_->{params}[1]; # sciagam parametr wywolania metody
			$drzewoSvg->textNode( $leksemP );
		} call qr/^Kompilator::Api::Drzewo::textNode/;
		after {
			$drzewoSvg->wyjscie( $drzewoPlainPlik );
		} call qr/^Kompilator::Pascal::Syntaktyka::analizuj/;
	}
	
	if($konfiguracja{syntezaWywolania}) {
		my $syntezaWywolaniaDebug = new Kompilator::Debug::Java::Synteza( $syntezaWywolaniaPlik );
		before {
			$syntezaWywolaniaDebug->wywolanie( $_[0]->{sub_name}, $_[0]->{params} );
		} call qr/^Kompilator::Java::Synteza::\w+/;
		after_throwing {
			$syntezaWywolaniaDebug->wyjatek( $_[0]->{sub_name}, $_[0]->{exception} );
		} call qr/^Kompilator::Java::Synteza::\w+/;
		after {
			$syntezaWywolaniaDebug->zapisz();
		} call qr/^Kompilator::Pascal::Semantyka::analizuj/;
	}
	
	if($konfiguracja{onp}) {
		my $onpLogger = new Kompilator::Debug::Api::Synteza::ONP( $onpPlik );
		before {
			my @a = @_;
			$onpLogger->wloz( $_[0]->{params}->[1] );
		} call qr/^Kompilator::Api::Synteza::ONP::wloz/;
		after {
			my @a = @_;
			$onpLogger->zdejmij(  );
		} call qr/^Kompilator::Api::Synteza::ONP::zdejmij/;
		after {
			$onpLogger->noweWyrazenie();
		} call qr/^Kompilator::Api::Synteza::ONP::noweWyrazenie/;
		after {
			$onpLogger->koniecWyrazenia();
		} call qr/^Kompilator::Api::Synteza::ONP::koniecWyrazenia/;
		after {
			$onpLogger->koniecWyrazenia();
		} call qr/^Kompilator::Api::Synteza::SyntezaBaza::zapiszWartoscD/;
		after_throwing {
			$onpLogger->wyjatek( $_[0]->{sub_name}, $_[0]->{exception} );
		} call qr/^Kompilator::Java::Synteza::\w+/; # ..\w+$ ?
		after {
			$onpLogger->zapisz();
		} call qr/^Kompilator::Pascal::Semantyka::analizuj/;
	}
	
	if($konfiguracja{wywolaniaSyntezaOnp}) {
		my $syntezaWywolaniaDebug = new Kompilator::Debug::Java::Synteza( $wywolaniaSyntezaOnpPlik ); # TODO zmiana nazwy na ogolniejsza tego loggera
		before {
			$syntezaWywolaniaDebug->wywolanie( $_[0]->{sub_name}, $_[0]->{params} );
		} call qr/^Kompilator::Java::Synteza::\w+|Kompilator::Api::Synteza::ONP::\w+/;
		after_throwing {
			$syntezaWywolaniaDebug->wyjatek( $_[0]->{sub_name}, $_[0]->{exception} );
		} call qr/^Kompilator::Java::Synteza::\w+|Kompilator::Api::Synteza::ONP::\w+/;
		after {
			$syntezaWywolaniaDebug->zapisz();
		} call qr/^Kompilator::Pascal::Semantyka::analizuj/;
	}
}


1;