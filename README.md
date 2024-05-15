112101004
Amithabh A

# Abstract Syntax Tree generator

- An AST Generator which takes program statements in c like language and generates Abstract Syntax Tree of the input language
- Used `lex`, `yacc` and `c++` for parsing and generating AST.

# How to run

- Go to compiler directory
  ```
  cd compiler
  ```
- To generate compiler, run
  ```
  make
  ```
- Now, the compiler is generated in `bin/compiler`.
  To run compiler.
  ```
  make run
  ```
  Now, your terminal will be running `llvm` debugger. run this command:
  ```
  run
  ```
- Now, give the code in the terminal, and enter `Ctrl-D`. Abstract Syntax Tree will be printed in the terminal.

# What are there in this repo?

- All the relevant codes are in `compiler` directory.
- Source code for generating compiler can be found in `compiler/src`
- All header files are in `compiler/include` directory.

# Sample Program to run :

```
decl
	integer array[10];
	integer key;
	integer mid, temp;
	integer test,i;
	integer result;
  integer start, e;
enddecl

begin
       test=0;
       for(i=0;i<10;i++) {
		array[test] = test;
		test = test + 1;
       }
	key=array[5];
        start=1;
        e=9;
	print(test);
	return 0;
end
```
