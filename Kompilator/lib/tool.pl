#!/usr/bin/perl
use strict;
use warnings;
use feature "switch";

my @t;
my $t1;
my $t2;
my $t3;
my $t4;
my $t5;
my $kL;
my %klasProdukcja;
my @klasyfikacja;
my %gramatyka;
my %parsing;
my %sema;
my $path;

sub start {
	$path = $ARGV[0];
	if(defined $path and -e $path) {
		open(OPIS, "<$path") or die "Cannot read file $path\n$!";
		my @opis = <OPIS>;
		close(OPIS);
		
		#wczytywanie rozdzielaczy
		@t = ($opis[0], $opis[1], $opis[2], $opis[3], $opis[4]);
		foreach my $tt (@t) {
			$tt =~ s/\s+$//;
			$tt =~ s/^\s+//; 
		}
		($t1, $t2, $t3, $t4, $t5) = @t;
		
		#wczytywanie semantyki
		foreach my $linia (@opis) {
			if($linia =~ /^\s*(\w+)[^${t5}]*${t5}\s*((\w|_)+)\s*$/) {
				$sema{$1} = $2;
			}
		}
		
		#wczytywanie klasyfikacji
		$kL = 0;
		foreach my $linia (@opis) {
			if($linia =~ /^\s*(\w+)[^$t3]*$t3\s*$t4([^$t4]+)$t4\s*$t4([^$t4]*)$t4\s*$t4([^$t4]*)$t4/) {
				push @klasyfikacja, { wzorzec => $2, terminator => $3, opis => $4 };
				$klasProdukcja{\$klasyfikacja[$kL]} = $1;
				$kL++;
			}
		}
		print "Number of leksems: $kL\n";
			
		#wczytywanie gramatyki
		my $gL = 0;
		foreach my $linia (@opis) {
			 if($linia =~ /^\s*(\w+)\s*$t1\s*(((\w+\s+)|(\d+\s+))*)/) {
				$gramatyka{$1} = [ split (/\s/, $2) ] ;
				$gL++;
			}
		}
		print "Number of grama: $gL\n";
		
		#wczytanie tablicy parsingu
		my $pL = 0;
		foreach my $linia (@opis) {
			 if($linia =~ /^\s*(\w+)\s*$t1[^$t2]*$t2\s*((\w+\s+)+)/) {
			 	my $a = $2;
			 	my @odw = split (/\s/, $2);
			 	#TODO osobna funkcja
			 	my $n = scalar (@odw);
			 	if(scalar (@odw) != $kL) {
			 		print "ERR \t@odw\n";
			 		#die "Parsing table is failed!\n";
			 	}		 	
				$parsing{$1} = [ @odw ] ;
				$pL++;
			}
		}
		print "Number of lines in parsing table: $pL\n";
		my $x = 1;
	}
}

sub main {
	print "1. Show delimiters\n";
	print "2. Edit delimiters\n";
	print "3. Show leksems\n";
	print "4. Edit leksem\n";
	print "10. Add leksem\n";
	print "11. Delete leksem\n";
	print "5. Show grama\n";
	print "6. Edit grama\n";
	print "7. Show parsing table\n";
	print "8. Edit parsing table\n";
	print "9. Save your work\n";
	print "0. Quit\n";
	
	my $decyzja = <STDIN>;
	given($decyzja) {
		when(/^1$/) {
			pokazRozdzielacze();
		}
		when(/^2$/) {
			edytujRozdzielacze();
		}
		when(/^3$/) {
			pokazLeksemy();
		}
		when(/^4$/) {
			edytujLeksemy();
		}
		when(/^5$/) {
			pokazGramatyke();
		}
		when(/^6$/) {
			edytujGramatyke();
		}
		when(/^7$/) {
			pokazParsing();
		}
		when(/^8$/) {
			edytujParsing();
		}
		when(/^9$/) {
			zapisz();
		}
		when(/^10$/) {
			dodajLeksem();
		}
		when(/^11$/) {
			usunLeksem();
		}
		when(/^0$/) {
			wyjdz();
		}
	}
}

sub pokazRozdzielacze {
	print "TODO\n";
}

sub edytujRozdzielacze {
	print "TODO\n";
}

sub pokazLeksemy {
	for (my $i = 0; $i < @klasyfikacja; $i++) {
		pokazLeksem($i);
	}
}

sub edytujLeksemy {
	print "Nr of leksem to edit:\n";
	my $leksemNr = <STDIN>;
	$leksemNr =~ s/\n//;
	pokazLeksem($leksemNr);
	print "Nr of attribute to edit:\n";
	my $i = <STDIN>;
	$i =~ s/\n//;
	while($i > 0 && $i < 4) {
		my $atrybut = "";
		when($i) {
			given(/1/) {
				$atrybut = "wzorzec";
			}
			given(/2/) {
				$atrybut = "terminator";
			}
			given(/3/) {
				$atrybut = "opis";
			}
		}
		print "$klasyfikacja[$leksemNr]->{$atrybut}\n";
		print "New attribute:\n";
		my $edit = <STDIN>;
		$edit =~ s/\n//;
		$klasyfikacja[$leksemNr]->{$atrybut} = $edit;
		$i = <STDIN>;
		$i =~ s/\n//;
	}
}

sub dodajLeksem {
	print "Total leksems: $#klasyfikacja. Nr of adding leksem:\n";
	my $leksemNr = <STDIN>;
	$leksemNr =~ s/\n//;
	while($leksemNr > 0 and $leksemNr <= @klasyfikacja) {
		if($leksemNr < @klasyfikacja) {
			#TODO ang
			print "WARNING: Leksems after $leksemNr are going to be moved one place futher\n";
		}
		print "Production:\n";
		my $produkcja = <STDIN>;
		$produkcja =~ s/\n//;
		print "Pattern:\n";
		my $wzorzec = <STDIN>;
		$wzorzec =~ s/\n//;
		print "Terminals:\n";
		my $terminator = <STDIN>;
		$terminator =~ s/\n//;
		print "Description:\n";
		my $opis = <STDIN>;
		$opis =~ s/\n//;	
		if($leksemNr < @klasyfikacja) {
			#klasyfikacja1
			for(my $i = $#klasyfikacja; $i >= $leksemNr; $i--) {
				$klasyfikacja[$i+1] = $klasyfikacja[$i];
				$klasProdukcja{ \$klasyfikacja[ $i+1 ] } = $klasProdukcja{ \$klasyfikacja[$i] };
			}
			$klasProdukcja{ \$klasyfikacja[$leksemNr] } = $produkcja;
			#gramatyka1
			for my $key ( keys %gramatyka ) {
				for(my $i = 0; $i < @{$gramatyka{$key}}; $i++) {
					if(@{$gramatyka{$key}}[$i] =~ m/^\d+$/ and @{$gramatyka{$key}}[$i] >= $leksemNr) {
						@{$gramatyka{$key}}[$i]++; 
					}
				}
			}
		}
		#klasyfikacja2
		$klasyfikacja[$leksemNr] = { wzorzec => $wzorzec, terminator => $terminator, opis => $opis };
		#gramatyka2
		$gramatyka{$produkcja} = [ $leksemNr ];
		#parsing
		for my $key ( keys %parsing ) {
			for(my $i = $#{$parsing{$key}}; $i >= $leksemNr; $i--) {
				@{$parsing{$key}}[$i+1] = @{$parsing{$key}}[$i];
			}
			@{$parsing{$key}}[$leksemNr] = "ERR";
		}
		$kL++;
		my @errory = ();
		for(my $i = 0; $i < $kL; $i++) {
			push @errory, "ERR";
		}
		$parsing{$produkcja} = [ @errory ];
		
		print "Total leksems: $#klasyfikacja. Nr of adding leksem:\n";
		$leksemNr = <STDIN>;
		$leksemNr =~ s/\n//;
	}
}

sub usunLeksem {
	print "TODO\n";
}

sub pokazGramatyke {
	print "TODO\n";
}

sub edytujGramatyke {
	print "TODO\n";
}

sub pokazParsing {
	for my $produkcja ( keys %parsing ) {
		pokazParsingProdukcji($produkcja);
	}
}

sub edytujParsing {
	print "Production to edit:\n";
	my $produkcja = <STDIN>;
	$produkcja =~ s/\n//;
	pokazParsingProdukcji($produkcja);
	print "Nr of line to edit (-1 to exit): ";
	my $i = <STDIN>;
	$i =~ s/\n//;
	while($i >= 0) { # and < @parsing
		print "$parsing{$produkcja}[$i]\n";
		print "New production:\n";
		my $edit = <STDIN>;
		$edit =~ s/\n//;
		$parsing{$produkcja}[$i] = $edit;
		pokazParsingProdukcji($produkcja);
		print "Nr of line to edit (-1 to exit): ";
		$i = <STDIN>;
		$i =~ s/\n//;
	}
}

sub zapisz {
	my $klasyfikacjaL = scalar @klasyfikacja;
	my $gramatykaL = scalar keys( %gramatyka );
	my $parsingL = scalar keys( %parsing );
	if($gramatykaL != $parsingL or $klasyfikacjaL > $parsingL) {
		print "Failed tables\n";
		return;
	}
	open(OUT, ">${path}") or die "Cannot write to file $path\n$!";
	foreach my $tt (@t) {
		print OUT "$tt\n";
	}
	my @wykorzystaneProdukcje;
	for (my $i = 0; $i < @klasyfikacja; $i++) {
		my $l1 = $klasyfikacja[$i]->{wzorzec};
		my $l2 = $klasyfikacja[$i]->{terminator};
		my $l3 = $klasyfikacja[$i]->{opis};
		my $produkcja = $klasProdukcja{\$klasyfikacja[$i]};
		my @grama = @{$gramatyka{$produkcja}};
		my @pars = @{$parsing{$produkcja}};
		print OUT "$produkcja\t$t1\t@grama\t$t2\t@pars\t$t3\t$t4$l1$t4\t$t4$l2$t4\t$t4$l3$t4\n";
		push @wykorzystaneProdukcje, $produkcja;
	} 
	for my $produkcja ( keys %gramatyka ) {
		my $wykorzystana = 0;
		for my $wykorzystanaProdukcja ( @wykorzystaneProdukcje ) {
			if($produkcja =~ /$wykorzystanaProdukcja/ ) {
				$wykorzystana = 1;
			}
		}
		if (not $wykorzystana) {
	        my @grama = @{$gramatyka{$produkcja}};
	        my @pars = @{$parsing{$produkcja}};
			my $sem = "";
			$sem = "\t$t[4]\t".$sema{$produkcja} if defined $sema{$produkcja};
	        print OUT "$produkcja\t$t1\t@grama\t$t2\t@pars$sem\n";			
		}
    }
	close OUT;
}

sub wyjdz {
	die;
}

sub pokazLeksem {
	my $leksemNr = $_[0];
	#TODO sprawdzenie zakresu tablicy
	#if(defined $klasyfikacja[$leksem])
	my $leksem = $klasyfikacja[$leksemNr];
	print "$leksemNr\n";
	print "\t1 pattern\t$leksem->{wzorzec}\n";
	print "\t2 terminators\t$leksem->{terminator}\n";
	print "\t3 description\t$leksem->{opis}\n";
}

sub pokazParsingProdukcji {
	my $produkcja = $_[0];	
	print "$produkcja\n";	
	my @pars = @{$parsing{$produkcja}};
	for (my $i = 0; $i < @pars; $i++) {
		print "\t$i\t$klasyfikacja[$i]->{opis}\t$pars[$i]\n";
	}
}

start();
while(1) {
	main();
}