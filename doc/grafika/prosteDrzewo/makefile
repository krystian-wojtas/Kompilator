RASTARIZER=~/batikBin/batik-1.7/batik-rasterizer.jar

run: *.svg
	java -jar $(RASTARIZER) -onload $^

all: var final start

var: program_deklaracjeOpcj_deklaracja_VAR.svg
	java -jar $(RASTARIZER) -w 180 -h 170 -onload $<

final: prosteDrzewoFinal.svg
	java -jar $(RASTARIZER) -onload $<

start: program_start.svg
	java -jar $(RASTARIZER) -w 1250 -h 270 -onload $<
