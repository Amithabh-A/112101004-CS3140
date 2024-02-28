/*
 *   This file is part of SIL Compiler.
 *
 *  SIL Compiler is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  SIL Compiler is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with SIL Compiler.  If not, see <http://www.gnu.org/licenses/>.
 */

%{
	
	#define YYSTYPE NODPTR
int 	Lineno;
int     wflag;

%}

%option noyywrap
digit	[0-9]
letter	[a-zA-Z]

%%
main	                 	{					}	
					
return 			{
				}
begin				{
					}	
end			{
				}	
read				{
				}
write			{
					}	
integer			{
					}	
boolean				{
					}	
decl				{
				}
enddecl				{
				}
if				{
				}
then				{
					}	
else				{
					}	
endif				{
				}
do				{
				}
while				{
			}
endwhile			{
				}
for 				{
				}		
"=="				{
					}	
"<="				{
				}
">="				{
				}
"!="				{
					}	
AND				{
					}	
OR				{
				}
NOT			{
				}
true			{
					}	
false			      {
				}

{digit}+			{ 	
				}

{letter}({letter}|{digit})*	{ 	
				}
[-+*/=()><;,\{\}\[\]\%]         {
				}
			
["]                             { }
"\\n"                           {
                                }

[ \t]				
.				{
				}		

%%

