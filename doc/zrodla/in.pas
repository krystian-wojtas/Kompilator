var zm1,zm2:integer;
	var zm3:float;
var napis :	
string;
proc liniowa(x:integer) : integer
begin
	return 4 + 3.5 * x;
end
proc funkcja(zm1:float,zm2:integer) : integer
begin
	var zm3:integer;
	zm3 = 2 * zm1 + 3 * zm2;
	zm1 = call liniowa( 5 );
	return zm1 + zm2 + zm3;
end
start
	zm1 = 3 * 4;
	zm2 = call funkcja(call liniowa(2+zm1),4);
end
