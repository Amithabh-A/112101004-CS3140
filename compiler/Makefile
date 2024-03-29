all : clear yacc lex compile 

clear : 
	clear

yacc : 
	bison -d src/compiler.y -o compiler.cc
	mv compiler.cc src/
	mv compiler.hh include/

lex : 
	flex src/compiler.l 
	mv lex.yy.c src/

compile : 
	clang++ -g -std=c++17 src/lex.yy.c src/compiler.cc -o bin/compiler

run : 
	lldb ./bin/compiler

clean : 
	rm include/compiler.hh src/compiler.cc bin/compiler src/lex.yy.c 
	rm -rf bin/compiler.dSYM