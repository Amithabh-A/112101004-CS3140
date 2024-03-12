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
%}

%option noyywrap
digit	[0-9]
letter	[a-zA-Z]

%%
begindecl {
    return  DECL;
	}
enddecl {
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


