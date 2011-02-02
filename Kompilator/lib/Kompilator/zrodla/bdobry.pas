var zm1,zm2:integer;
	var zm3:float;
var napis :	
string;
proc dodawanie(zm1:integer,zm2:integer) : integer
begin
	var zm4 : integer;
	block
	begin
		var zm4 : string;
		zm4 = "Jestem w dodawaniu";
	end
	zm4 = zm1+zm2;
	return zm4;
end
proc dodawanie2(zm1:integer,zm2:integer) : integer
begin
	return - zm1 + zm2;
end
start
	zm1 = 1;
	zm2 = 12;
	zm3 = 15;
	while(zm1 <= 10)
	begin
		if (zm2 < zm3)
		begin
			zm2 = call dodawanie(zm2,1);
		end
		if (zm2 > zm3 or zm3 == zm2)
			zm3 =call dodawanie(zm3,1);
	end
	zm1= call dodawanie(zm1,1);
	
	write("To jest wartosc wyniku: ");
	write(call dodawanie2(zm2,zm3));
	write("A to wartosc pierwszej operacji:");
	write(true and false);
	block begin
		var zm1:array of float;
		var zm4:float;
		read(zm2);
		if(zm2 > 0)
		begin
			alloc(zm1,zm2);
			zm3 = 0;
			while(zm3<zm2)
			begin
				zm1{zm3} = zm3/2;
				zm3 = zm3+1;
			end
			zm3 = 0;
			zm4 = 4;
			while(zm3<zm2)
			begin
			zm4=zm1{0}-	zm4+zm1{zm3}/zm2;
				zm3 = zm3+1;
			end
		end
	end
	write("A to nowy wynik" + zm3);
end
