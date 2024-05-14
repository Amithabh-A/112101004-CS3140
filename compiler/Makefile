MKDIR_P = mkdir -p
BINDIR = /bin

.PHONY: create_bin_dir

all : create clear yacc lex compile 

create:
	mkdir -p bin

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
	clang++ -g -std=c++17 src/lex.yy.c src/compiler.cc src/functions.cpp -I include/compiler.h -o bin/compiler

run : clear execute

execute : 
	lldb ./bin/compiler

clean : 
	rm include/compiler.hh src/compiler.cc bin/compiler src/lex.yy.c 
	rm -rf bin/compiler.dSYM
	rm -rf bin
