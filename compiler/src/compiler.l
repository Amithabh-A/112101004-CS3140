%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include<cstring>
#include "compiler.hh"
#include "../include/compiler.h"
void yyerror(char *);
char c;
//int 	Lineno;
//int     wflag;
%}

%option noyywrap
digit	[0-9]
letter	[a-zA-Z]

%%
print
  {
    return WRITE;
  }
{digit}+  { 	
//             yylval.val = atoi(yytext);
            yylval.Node->value = atoi(yytext);
            return NUM;
				  }

{letter}({letter}|{digit})*	{ 	
//     yylval.s = strdup(yytext);
    yylval.Node->name = strdup(yytext);
    return VAR;
  }
[-+()=/*\n] { return *yytext; }
["]                             { }
"\\n"                           {
                                }

[ \t]				
.				{
				}		

%%


