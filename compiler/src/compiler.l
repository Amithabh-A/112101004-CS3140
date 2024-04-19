%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include<cstring>
#include "../include/compiler.hh"
#include "../include/compiler.h"
#include<iostream>
void yyerror(char *);
char c;
%}

%option noyywrap
digit	[0-9]
letter	[a-zA-Z]

%%
decl {
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
if				{
    return IF; 
				}
then				{
    return THEN;
					}	
else				{
    return ELSE;
					}	
endif				{
    return ENDIF;
				}
for 				{
  return FOR;
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
"==" {return EQUALEQUAL;}
"<=" {return LESSTHANOREQUAL;}
">=" {return GREATERTHANOREQUAL;}
"!=" {return NOTEQUAL;}
"AND" {return LOGICAL_AND;}
"OR" {return LOGICAL_OR;}
"NOT" {return LOGICAL_NOT;}
[-+*/=()><;,\{\}\[\]\%] { return *yytext; }
["]                             { }
"\\n"                           {
                                }
\n

[ \t]				
.				{
				}		

%%


