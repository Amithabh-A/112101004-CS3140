/* DEFINITIONS */
/* C Definitions */
%{
  #include <stdio.h> 
  #include <stdlib.h>
  void yyerror(char *);
  int yylex(void);
  int sym[26];
%}

/* YACC Definitions */
%token INTEGER VARIABLE
%left '+' '-'
%left '*' '/' 
%nonassoc UNARYMINUS

/*
$$ : designates top of the stack
$1 : First term of RHS of production
$x : xth term of RHS of production
*/

/*
we pop "expr '+' expr" and push expr
*/

/*
%prec explicitly mention the precedence of unary '-'. It ensures that unary minus binds more tightly than '-'. 
*/

%%
program:
  program statement '\n'
  |
  ;

statement:
  expr { printf("%d\n", $1); }
  | VARIABLE '=' expr { sym[$1] = $3; }
  ;

expr:
  INTEGER
  | VARIABLE { $$ = sym[$1]; }
  | '-' expr %prec UNARYMINUS { $$ = -$2; }
  | expr '+' expr { $$ = $1 + $3; }
  | expr '-' expr { $$ = $1 - $3; }
  | expr '*' expr { $$ = $1 * $3; }
  | expr '/' expr { $$ = $1 / $3; }
  | '(' expr ')' { $$ = $2; }
  ;

%%

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
  //jreturn 0;
}

int main(void) {
  yyparse();
  return 0;
}

