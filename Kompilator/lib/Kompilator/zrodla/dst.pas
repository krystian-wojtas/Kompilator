var zm1,zm2:integer;
	var zm3:float;
	var napis :	
string;
start
	zm1 = 1;
	zm2 = 12;
	zm3 = 15;
	while(zm1 <= 10)
		begin
		if (zm2 < zm3)
		begin
			zm2 = zm2+1;
		end
		if (zm2 > zm3 or zm3 == zm2)
			zm3 = zm3+1;
		zm1 = zm1 + 1;
	end
	write("To jest wartosc wyniku: ");
	write(- zm2 + zm3);
	write("A to wartosc pierwszej operacji:");
	write(true and false);
end
