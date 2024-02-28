/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     VAR = 258,
     NUM = 259,
     WRITE = 260,
     BEG = 261,
     END = 262,
     T_INT = 263,
     T_BOOL = 264,
     READ = 265,
     DECL = 266,
     ENDDECL = 267,
     IF = 268,
     THEN = 269,
     ELSE = 270,
     ENDIF = 271,
     LOGICAL_AND = 272,
     LOGICAL_NOT = 273,
     LOGICAL_OR = 274,
     EQUALEQUAL = 275,
     LESSTHANOREQUAL = 276,
     GREATERTHANOREQUAL = 277,
     NOTEQUAL = 278,
     WHILE = 279,
     DO = 280,
     ENDWHILE = 281,
     FOR = 282,
     T = 283,
     F = 284,
     MAIN = 285,
     RETURN = 286,
     UMINUS = 287
   };
#endif
/* Tokens.  */
#define VAR 258
#define NUM 259
#define WRITE 260
#define BEG 261
#define END 262
#define T_INT 263
#define T_BOOL 264
#define READ 265
#define DECL 266
#define ENDDECL 267
#define IF 268
#define THEN 269
#define ELSE 270
#define ENDIF 271
#define LOGICAL_AND 272
#define LOGICAL_NOT 273
#define LOGICAL_OR 274
#define EQUALEQUAL 275
#define LESSTHANOREQUAL 276
#define GREATERTHANOREQUAL 277
#define NOTEQUAL 278
#define WHILE 279
#define DO 280
#define ENDWHILE 281
#define FOR 282
#define T 283
#define F 284
#define MAIN 285
#define RETURN 286
#define UMINUS 287




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 13 "compiler.y"
{
  int val;
  char* s;
  struct node* Node;
}
/* Line 1529 of yacc.c.  */
#line 119 "compiler.hh"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

