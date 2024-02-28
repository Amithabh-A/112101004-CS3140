all: ./src/compiler.cc ./lex.yy.c 
	g++ lex.yy.c ./src/compiler.cc -o ./bin/compiler

lex.yy.c: ./src/compiler.l
	flex ./src/compiler.l 
	mv lex.yy.c src/

src/compiler.cc: ./src/compiler.y
	bison -d ./src/compiler.y -o ./src/compiler.cc;

clean:
	rm ./bin/compiler ./src/lex.yy.c ./src/compiler.hh ./src/compiler.cc;
