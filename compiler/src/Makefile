all : clear yacc lex compile run

clear : 
	clear

yacc : 
	bison -d compiler.y -o compiler.cc

lex : 
	flex compiler.l

compile : 
	clang++ -g -std=c++17 lex.yy.c compiler.cc -o compiler

run : 
	lldb ./compiler

clean : 
	rm -rf compiler.dSYM
	rm compiler.hh compiler.cc compiler lex.yy.c 
