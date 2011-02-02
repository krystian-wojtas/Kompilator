#!/usr/bin/perl
package Kompilator::Pascal::Semantyka;
use Kompilator::Api::Semantyka::Zmienne;
use strict;
use warnings;
use feature "switch";


my $prD;
my $prD_nazwa;
my $prD_typ;
my $prW;
my $prW_nazwa;
my $pmD;
my $pmyD;
my $pmW;
my $zmD;
my $zmD_nazwa;
my $zmD_typ;
my $zmW_nazwa;
my $zmA_nazwa;
my $zmZ_nazwa;
my $blD;
my $ar;
my $ti;
my $tf;
my $tb;
my $ts;
my @op = ();
my $op1;
my $lw;
my $ro;
my $al;
my $zw;
my $ret;

my $prDA = 0;
my $prD_nazwaA = 0;
my $prD_typA = 0;
my $prWA = 0;
my $prW_nazwaA = 0;
my $pmDA = 0;
my $zmDA = 0;
my $zmD_nazwaA = 0;
my $zmD_typA = 0;
my $zmW_nazwaA = 0;
my $zmA_nazwaA;
my $zmZ_nazwaA;
my $arA = 0;
my $arAA = 0;
my $tiA = 0;
my $tfA = 0;
my $tbA = 0;
my $tsA = 0;
my $opA = 0;
my $op1A = 0;
my $lwA = 0;

my %produkcjaTypuNr = ();

my $ostatniLeksem = 0;

sub new
{	
	my $class = shift;
	my @opis = @{( shift )}; # TODO lokal
	my $t = @{( shift )}[4];
	
    my $self = {};
    bless $self, $class;
    $self->_korzenP( shift );
    $self->_syntezaP( shift );
    $self->_zmienneP( new Kompilator::Api::Semantyka::Zmienne() );
	
	foreach my $linia (@opis) {
		given($linia) {
			when(/^\s*((\w|_)+)[^${t}]*${t}\s*prD\s*$/) {
				$prD = $1;
			}
			when(/^\s*((\w|_)+)[^${t}]*${t}\s*prD_nazwa\s*$/) {
				$prD_nazwa = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*prD_typ\s*$/) {
				$prD_typ = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*prW\s*$/) {
				$prW = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*prW_nazwa\s*$/) {
				$prW_nazwa = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*pmD\s*$/) {
				$pmD = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*pmW\s*$/) {
				$pmW = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*pmyD\s*$/) {
				$pmyD = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*zmD\s*$/) {
				$zmD = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*zmD_nazwa\s*$/) {
				$zmD_nazwa = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*zmD_typ\s*$/) {
				$zmD_typ = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*zmW_nazwa\s*$/) {
				$zmW_nazwa = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*zmA_nazwa\s*$/) {
				$zmA_nazwa = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*zmZ_nazwa\s*$/) {
				$zmZ_nazwa = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*blD\s*$/) {
				$blD = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*ar\s*$/) {
				$ar = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*ti\s*$/) {
				$ti = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*tf\s*$/) {
				$tf = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*tb\s*$/) {
				$tb = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*ts\s*$/) {
				$ts = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*op1\s*$/) {
				$op1 = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*lw\s*$/) {
				$lw = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*ro\s*$/) {
				$ro = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*al\s*$/) {
				$al = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*zw\s*$/) {
				$zw = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*ret\s*$/) {
				$ret = $1;
			}
			when(/^\s*([\w_]+)[^${t}]*${t}\s*op\s*$/) {
				push @op, $1;
			}
		}
	}
	$produkcjaTypuNr{$ti} = 1;
	$produkcjaTypuNr{$tf} = 2;
	$produkcjaTypuNr{$tb} = 3;
	$produkcjaTypuNr{$ts} = 4;
	$produkcjaTypuNr{INTEGER} = 1;
	$produkcjaTypuNr{FLOAT} = 2;
	$produkcjaTypuNr{BOOLEAN} = 3;
	$produkcjaTypuNr{STRING} = 4;
	
    return $self;
}

sub _syntezaP { $_[0]->{synteza}=$_[1] if defined $_[1]; $_[0]->{synteza} }
sub _korzenP { $_[0]->{korzen}=$_[1] if defined $_[1]; $_[0]->{korzen} }
sub _zmienneP { $_[0]->{zmienne}=$_[1] if defined $_[1]; $_[0]->{zmienne} }


sub _zeruj
{
	my $self = shift;
	$prDA = 0;
	$prD_nazwaA = 0;
	$prD_typA = 0;
	$prW_nazwaA = 0;
}


sub analizuj
{
	my $self = shift;
	eval {
		$self->_szukajFunkcji( $self->_korzenP );
		#TODO zerowanie tu
		$self->_zeruj();
		$self->_sprawdzWywolania( $self->_korzenP );
		$self->_syntezaP->zapiszD();
	};
	if($@) {
		my $errs = '';
		foreach my $err ($@) {
			$errs .= "$err\n";
		}
		die "${errs}Miejsce: $ostatniLeksem->{slowo}, $ostatniLeksem->{linia}, $ostatniLeksem->{poczatek}\n";
	}
}


sub _szukajFunkcji
{
	my ( $self, $wezel ) = @_;
	#TODO deklaracja pozniej
	my $produkcjaN = 0;
	foreach my $wezelN (@{$wezel->{dzieci}})
	{
		$produkcjaN = $wezelN->{produkcja};
		#wlaczanie zworek
		if($prDA == 0) {
			if($produkcjaN =~ /^$prD$/) {
				$prDA = 1;
			}
		}
		else {
			if($pmDA == 0) {
				if($produkcjaN =~ /^$pmD$/) {
					$pmDA = 1;
				}
				elsif($produkcjaN =~ /^$prD_nazwa$/) {
					$prD_nazwaA = 1;
				}
				elsif($produkcjaN =~ /^$prD_typ$/) {
					$prD_typA = 1;
				}
			}
			else {
				if($produkcjaN =~ /^$zmD_nazwa$/) {
					$zmD_nazwaA = 1;
				}
				elsif($produkcjaN =~ /^$zmD_typ$/) {
					$zmD_typA = 1;
				}
				elsif($produkcjaN =~ /^$ar$/) {
					$arAA = 1;
				}
			}
		}
		
		#rzezba
		if($produkcjaN !~ /^0$/) {
			$self->_szukajFunkcji($wezelN);
		}
		else {
			if($prDA) {
				if(not $pmDA) {
					if($prD_nazwaA) {
						my $nazwa = $wezelN->{leksem}->{slowo};
						$self->_syntezaP->deklProcNazwaD( $wezelN->{leksem}->{slowo} );
					}
					elsif($prD_typA) {
						$self->_syntezaP->deklProcMaskaD( $produkcjaTypuNr{ uc $wezelN->{leksem}->{slowo} } );
						$arAA = 0;
					}
				}
				else {
					if($zmD_nazwaA) {
						$self->_syntezaP->deklParamNazwaD( $wezelN->{leksem}->{slowo} );
					}
					elsif($zmD_typA) {
						$self->_syntezaP->deklParamMaskaD ( '2'.(($arAA) ? '1' : '0').$produkcjaTypuNr{ uc $wezelN->{leksem}->{produkcja} } );
						$arAA = 0;
					}
				}
			}
		}
		
		#wylaczanie zworek
		if($produkcjaN !~ /^0$/) {
			if($prDA == 1) {
				if($produkcjaN =~ /^$prD$/) {
					$prDA = 0;
					$self->_syntezaP->deklProcD();
				}
				if($pmDA == 0) {
					if($produkcjaN =~ /^$prD_nazwa$/) {
						$prD_nazwaA = 0;
					}
					if($produkcjaN =~ /^$prD_typ$/) {
						$prD_typA = 0;
					}
				}
				else {
					if($produkcjaN =~ /^$pmD$/) {
						$pmDA = 0;
						$self->_syntezaP->deklParamD();
					}
					elsif($produkcjaN =~ /^$zmD_nazwa$/) {
						$zmD_nazwaA = 0;
					}
					elsif($produkcjaN =~ /^$zmD_typ$/) {
						$zmD_typA = 0;
					}
				}
			}
		}
	}
}


sub _sprawdzWywolania
{
	my ( $self, $wezel ) = @_;
	#TODO deklaracja pozniej
	my $produkcjaN = 0;
	foreach my $wezelN (@{$wezel->{dzieci}})
	{
		$produkcjaN = $wezelN->{produkcja};
		#wlaczanie zworek
		if($produkcjaN =~ /^$prD$/) {
			$prDA = 1;
		}
		elsif($produkcjaN =~ /^$pmyD$/) {
			$self->_zmienneP->dolozStosLok();
		}
		elsif($produkcjaN =~ /^$pmW$/) {
			$self->_syntezaP->nowyParametrD();
		}
		elsif($produkcjaN =~ /^$zmD$/ or $produkcjaN =~ /^$pmD$/) {
			$zmDA = 1;
		}
		elsif($produkcjaN =~ /^$zmD_nazwa$/) {
			$zmD_nazwaA = 1;
		}
		elsif($produkcjaN =~ /^$zmD_typ$/) {
			$zmD_typA = 1;
		}
		elsif($produkcjaN =~ /^$zmW_nazwa$/) {
			$zmW_nazwaA = 1;
		}
		elsif($produkcjaN =~ /^$zmA_nazwa$/) {
			$zmA_nazwaA = 1;
		}
		elsif($produkcjaN =~ /^$zmZ_nazwa$/) {
			$zmZ_nazwaA = 1;
		}
		elsif($produkcjaN =~ /^$ar$/) {
			$arA = 1;
			$arAA = 1;
		}
		elsif($produkcjaN =~ /^$ti$/) {
			$tiA = 1;
		}
		elsif($produkcjaN =~ /^$tf$/) {
			$tfA = 1;
		}
		elsif($produkcjaN =~ /^$tb$/) {
			$tbA = 1;
		}
		elsif($produkcjaN =~ /^$ts$/) {
			$tsA = 1;
		}
		elsif($produkcjaN =~ /^$op1$/) {
			$op1A = 1;
		}
		elsif($produkcjaN =~ /^$lw$/ or $produkcjaN =~ /^$ro$/) {
			$self->_syntezaP->noweWyrazenieD();
		}
		elsif($produkcjaN =~ /^$blD$/) {
			$self->_zmienneP->dolozStosLok();
		}
		elsif($produkcjaN =~ /^$prW_nazwa$/) {
			$prW_nazwaA = 1;
		}
		else {
			foreach my $operator (@op) {
				if($produkcjaN =~ /^$operator$/) {
					$opA = 1;
				}
			}
		}
	
		#rzezba
		if($produkcjaN !~ /^0$/) {
			$self->_sprawdzWywolania($wezelN);
		}
		else {
			$ostatniLeksem = $wezelN->{leksem};
			if($zmDA) {
				if($zmD_nazwaA) {
					$self->_zmienneP->deklZmNazwa( $wezelN->{leksem}->{slowo} );
				}
				elsif($zmD_typA and not $arA) {
					$self->_zmienneP->deklZmMaska( $produkcjaTypuNr{ uc $wezelN->{leksem}->{produkcja} }, $arAA );
					$arAA = 0;
				}
			}
			elsif($zmW_nazwaA) {
				my $nazwaZmiennej = $wezelN->{leksem}->{slowo};
				my $znalezionaZm = $self->_zmienneP->wywolanieZmiennej( $nazwaZmiennej );
				if($zmA_nazwaA) {
					$self->_zmienneP->alokacjaZm( $znalezionaZm );
				}
				elsif($zmZ_nazwaA) {
					$self->_zmienneP->zwolnienieZm( $znalezionaZm );
				}
				# gdy alokowanie lub zwlanianie zmiennej jest aktywne, nie drukuje kodow wrzucenia zmiennej na stos
				$self->_syntezaP->wrzucD( { %$znalezionaZm }, (not $zmA_nazwaA and not $zmZ_nazwaA) );
			}
			elsif($prW_nazwaA) {
				my $nazwaP = $wezelN->{leksem}->{slowo};
				$self->_syntezaP->wywolanieProceduryD( $nazwaP );
			}
			elsif($tiA) {
				$self->_syntezaP->wrzucD( { maska => '10'.$produkcjaTypuNr{ $ti }, nazwa => $wezelN->{leksem}->{slowo} } );				
			}
			elsif($tfA) {
				$self->_syntezaP->wrzucD( { maska => '10'.$produkcjaTypuNr{ $tf }, nazwa => $wezelN->{leksem}->{slowo} } );	
			}
			elsif($tbA) {
				$self->_syntezaP->wrzucD( { maska => '10'.$produkcjaTypuNr{ $tb }, nazwa => $wezelN->{leksem}->{slowo} } );	
			}
			elsif($tsA) {
				$self->_syntezaP->wrzucD( { maska => '10'.$produkcjaTypuNr{ $ts }, nazwa => $wezelN->{leksem}->{slowo} } );	
			}
			elsif($opA) {
				if($op1A) {
					$self->_syntezaP->operator1D($wezelN->{leksem}->{produkcja}, $wezelN->{leksem}->{slowo});
				}
				else {
					$self->_syntezaP->operator2D($wezelN->{leksem}->{produkcja}, $wezelN->{leksem}->{slowo});
				}
			}
		}
		
		#wylaczanie zworek
		if($produkcjaN !~ /^0$/) {
			if($produkcjaN =~ /^$zmD$/ or $produkcjaN =~ /^$pmD$/) {
				$self->_zmienneP->deklZm();
				$zmDA = 0;
			}
			elsif($produkcjaN =~ /^$pmW$/) {
				$self->_syntezaP->koniecParametruD();
			}
			elsif($produkcjaN =~ /^$zmD_nazwa$/) {
				$zmD_nazwaA = 0;
			}
			elsif($produkcjaN =~ /^$zmD_typ$/) {
				$zmD_typA = 0;
			}
			elsif($produkcjaN =~ /^$zmW_nazwa$/) {
				$zmW_nazwaA = 0;
			}
			elsif($produkcjaN =~ /^$zmA_nazwa$/) {
				$zmA_nazwaA = 0;
			}
			elsif($produkcjaN =~ /^$zmZ_nazwa$/) {
				$zmZ_nazwaA = 0;
			}
			elsif($produkcjaN =~ /^$ar$/) {
				$arA = 0;
			}
			elsif($produkcjaN =~ /^$ti$/) {
				$tiA = 0;
			}
			elsif($produkcjaN =~ /^$tf$/) {
				$tfA = 0;
			}
			elsif($produkcjaN =~ /^$tb$/) {
				$tbA = 0;
			}
			elsif($produkcjaN =~ /^$ts$/) {
				$tsA = 0;
			}
			elsif($produkcjaN =~ /^$op1$/) {
				$op1A = 0;
			}
			elsif($produkcjaN =~ /^$al$/) {
				$self->_syntezaP->alokacjaD();
			}
			elsif($produkcjaN =~ /^$zw$/) {
				$self->_syntezaP->zwolnienieD();
			}
			elsif($produkcjaN =~ /^$lw$/ or $produkcjaN =~ /^$ro$/) {
				$self->_syntezaP->koniecWyrazeniaD();
			}
			elsif($produkcjaN =~ /^$pmyD$/) {
				# zakonczone dopisywanie parametrow funkcji
				# teraz deklaracje lokalnych funkcji
				$self->_zmienneP->dolozStosLok();
			}
			elsif($produkcjaN =~ /^$prD$/) {
				$prDA = 0;
				# wyjscie z deklaracji procedury, wyczyszczenie zadeklarowanych w niej lokali
				$self->_zmienneP->wyczyscLokale();
			}
			elsif($produkcjaN =~ /^$blD$/) {
				# zakonczenie bloku, sciagniecie zwiazenych z nim zmiennych lokalnych
				$self->_zmienneP->zdejmijStosLok();
			}
			elsif($produkcjaN =~ /^$prW$/) {
				$self->_syntezaP->proceduraWywolanaD();
			}
			elsif($produkcjaN =~ /^$prW_nazwa$/) {
				$prW_nazwaA = 0;
			}
			elsif($produkcjaN =~ /^$ret$/) {
				$self->_syntezaP->zwrotD();
			}
			else {
				foreach my $operator (@op) {
					if($produkcjaN =~ /^$operator$/) {
						$opA = 0;
					}
				}
			}
		}
	}
}

1;