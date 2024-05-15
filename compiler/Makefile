MKDIR_P = mkdir -p
BINDIR = /bin

.PHONY: create_bin_dir

all : create clear yacc lex compile 

create:
	mkdir -p bin
	rm -f test/codegen.s && touch test/codegen.s

clear : 
	clear

yacc : 
	bison -d src/compiler.y -o compiler.cc
	mv compiler.cc src/
	mv compiler.hh src/

lex : 
	flex src/compiler.l 
	mv lex.yy.c src/

compile : 
	g++ -g -std=c++17 src/lex.yy.c src/compiler.cc src/functions.cpp -I include/compiler.h -o bin/compiler

run : clear new_execute

test: clear old_execute

old_execute : 
	gdb ./bin/compiler 

new_execute:
	./bin/compiler < test/input.sil > test/output.txt

clean : 
	rm src/compiler.hh src/compiler.cc bin/compiler src/lex.yy.c 
	rm -rf bin/compiler.dSYM
	rm -rf bin
	rm -rf test/codegen.s
