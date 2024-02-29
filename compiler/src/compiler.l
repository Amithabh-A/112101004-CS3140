%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include<cstring>
#include "compiler.hh"
#include "../include/compiler.h"
#include<iostream>
void yyerror(char *);
char c;
//int 	Lineno;
//int     wflag;
%}

%option noyywrap
digit	[0-9]
letter	[a-zA-Z]

%%
begindecl {
    return  DECL;
	}
enddecl {
    cout<<"enddecl in lex\n";
    return ENDDECL;
  }
integer {
    return T_INT;
  }
print {
    return WRITE;
  }
{digit}+  { 	
//             yylval.val = atoi(yytext);
            yylval.Node->value = atoi(yytext);
            return NUM;
				  }

{letter}({letter}|{digit})*	{ 	
//     yylval.s = strdup(yytext);
//    char* hello = strdup(yytext) + sizeof(char);
//    hello[strlen(hello)-2]='\0'; 
//    cout<<"made strdup. ";
//    yylval.Node->name = hello;
    yylval.Node = (node*)malloc(sizeof(node)); 
    yylval.Node -> name = strdup(yytext);
    return VAR;
  }
[-+()=/*;,] { return *yytext; }
["]                             { }
"\\n"                           {
                                }
\n

[ \t]				
.				{
				}		

%%


