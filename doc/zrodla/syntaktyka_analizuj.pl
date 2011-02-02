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
					$drzewo->textNode($leksem);
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
