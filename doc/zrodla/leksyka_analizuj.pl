foreach my $znaki (@zrodlo) {
	my $ucieteZnaki = 0;
	my $poczatek;
	do {
		$poczatek = -1;
		$leksem = { slowo => 0, opis => 0, klasyfikacjaNr => 0, linia => 0, poczatek => -1};
		for my $klasa ( @klasyfikacja ) {
			if($znaki =~ /(\s*$klasa->{wzorzec}$klasa->{terminator})/) {
				my $p = $-[0];
				$1 =~ /$klasa->{wzorzec}/;
				my( $produkcja, $slowo_, $opis_, $poczatek_, $koniec_ ) = ( $klasa->{produkcja}, $1, $klasa->{opis}, $p + $-[0], $p + $+[0] );
				if($poczatek < 0 or $poczatek_ < $poczatek) {
					$leksem->{produkcja} = $produkcja;
					$leksem->{slowo} = $slowo_;
					$leksem->{opis} = $opis_;
					$leksem->{linia} = $linia;
					$leksem->{poczatek} = $poczatek_ + $ucieteZnaki;
					$poczatek = $poczatek_;
					$koniec = $koniec_;
				}
			}
		}
		if($poczatek >= 0) {
			my $ucieteSpacje = length $leksem->{slowo};
			$leksem->{slowo} =~ s/^\s+//;
			$ucieteSpacje -= length $leksem->{slowo};
			$ucieteZnaki += $ucieteSpacje + $koniec;
			$znaki = substr $znaki, $koniec;
			#normalnie w tym miejscu
			push @{$self->_leksemyP}, $leksem;
			#jednak dla potrzeb debugowania moznaby wywolywac ten fragment w osobnej funkcji
			#dzieki temu mozna sie podpiac do rosnacego stosu aspektem
			#$self->dolozLeksem( $leksem );
		}
	} while($poczatek >= 0);
	$linia++;
}
