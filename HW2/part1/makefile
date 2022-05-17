CC=gcc

all:
	lex gpp_interpreter.l
	yacc -d gpp_interpreter.y
	${CC} lex.yy.c y.tab.c -w -lm

clean:
	rm -rf a.out
	rm -rf parsed_gpp.txt

run:
	./a.out
