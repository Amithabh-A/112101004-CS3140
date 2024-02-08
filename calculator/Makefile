all: calculator.out
build: calculator.out

run: calculator.out
	./calculator.out

lex.yy.c: *.l
	lex $<

y.tab.c: *.y lex.yy.c  #Lex has to be compiled before yacc
	yacc -d $<

y.tab.h: *.y lex.yy.c
	yacc -d $<

calculator.out: lex.yy.c y.tab.c
	gcc $^ -o calculator.out

clean:
	rm lex.yy.c
	rm y.tab.h
	rm y.tab.c
	rm calculator.out

.PHONY: all build clean

