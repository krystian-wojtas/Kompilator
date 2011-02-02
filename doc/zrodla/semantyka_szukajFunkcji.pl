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
