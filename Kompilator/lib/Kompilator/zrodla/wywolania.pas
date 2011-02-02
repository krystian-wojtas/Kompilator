var zm1,zm2:integer;
	var zm3:float;
var napis :	
string;
proc dodawanie(zm1:integer,zm2:integer) : integer
begin
	return zm1 + zm2;
end
proc mnozenie(zm1:integer,zm2:integer) : integer
begin
	return zm1 * zm2;
end
start
	zm1 = call dodawanie(2,3);
	zm2 = call mnozenie(zm1, 4);
end
