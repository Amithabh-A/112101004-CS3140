all :
	gcc src/y.tab.c src/lex.yy.c -o src/compiler

y.tab.c : src/compiler.y
	yacc -d src/compiler.y

lex.yy.c : src/compiler.l
	lex src/compiler.l

clean : 
	cd src;
	rm y.tab.c lex.yy.c compiler;
	cd ..
