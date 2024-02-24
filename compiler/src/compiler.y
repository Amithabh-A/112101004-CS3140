%{	
#include<iostream>
#include<string>
#include<cstring>
#include<unordered_map>
#include "../include/compiler.h"
#define UNDEFINED INT_MIN
using namespace std;
int yylex();
void yyerror( char* );
unordered_map<char*, int>symbol_table;
%}
%union{
  int val;
  char* s;
  struct node* Node;
}
%token VAR NUM WRITE
%token BEG END
%token T_INT T_BOOL
%token READ 
%token DECL ENDDECL
%token IF THEN ELSE ENDIF
%token LOGICAL_AND LOGICAL_NOT LOGICAL_OR
%token EQUALEQUAL LESSTHANOREQUAL GREATERTHANOREQUAL NOTEQUAL
%token WHILE DO ENDWHILE FOR 
%token T F 
%token MAIN RETURN
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

// %type identifies type of non terminals
%type<Node> NUM
%type<Node> VAR
%type<Node> expr
%type<Node> assign_stmt
%type<Node> write_stmt
%type<Node> var_expr
%type<Node> Glist
%type<Node> Gid
// below line might be shitty. Sorry


%%

	Prog	:	Gdecl_sec stmt_list // Fdef_sec MainBlock
		;

		
	Gdecl_sec:	DECL Gdecl_list ENDDECL{}
		;
		
	Gdecl_list: 
		| 	Gdecl Gdecl_list
		;
		
	Gdecl 	:	ret_type Glist ';'
		;
		
	ret_type:	T_INT		{ }
		;
		
	Glist 	:	Gid
             {
                // here just a variable is being written, make that a node. 
                node *newNode = new node();
                newNode->Type = declaration;
                newNode->value = UNDEFINED;
                newNode->name = $1->name;
                newNode->lt = NULL;
                newNode->rt = NULL;
                newNode->next = NULL;
             }
// 		| 	func 
		|	Gid ',' Glist 
      {
                node *newNode = new node();
                newNode->Type = declaration;
                newNode->value = UNDEFINED;
                newNode->name = $1->name;
                newNode->lt = NULL;
                newNode->rt = NULL;
                newNode->next = $3;
      }
// 		|	func ',' Glist
		;
	
	Gid	:	VAR		{ 				}
		|	Gid '[' NUM ']'	{                                                   }

		;
		
	func 	:	VAR '(' arg_list ')' 					{ 					}
		;
			
	arg_list:	
		|	arg_list1
		;
		
	arg_list1:	arg_list1 ';' arg
		|	arg
		;
		
	arg 	:	arg_type var_list	
		;
		
	arg_type:	T_INT		 {  }
		;

	var_list:	VAR 		 { }
		|	VAR ',' var_list { 	}
		;
		
	Fdef_sec:	
		|	Fdef_sec Fdef
		;
		
	Fdef	:	func_ret_type func_name '(' FargList ')' '{' Ldecl_sec BEG stmt_list ret_stmt END '}'	{	 				}
		;
		
	func_ret_type:	T_INT		{ }
		;
			
	func_name:	VAR		{ 					}
		;
		
	FargList:	arg_list	{ 					}
		;

	ret_stmt:	RETURN expr ';'	{ 					}
		;
			
	MainBlock: 	func_ret_type main '('')''{' Ldecl_sec BEG stmt_list ret_stmt END  '}'		{ 				  	  }
					  
		;
		
	main	:	MAIN		{ 					}
		;
		
	Ldecl_sec:	DECL Ldecl_list ENDDECL	{}
		;

	Ldecl_list:		
		|	Ldecl Ldecl_list
		;

	Ldecl	:	type Lid_list ';'		
		;

	type	:	T_INT			{ }
		;

	Lid_list:	Lid
		|	Lid ',' Lid_list
		;
		
	Lid	:	VAR			{ 						}
		;

	stmt_list:	/* NULL */		{  }
		|	statement stmt_list	{						}
		|	error ';' 		{  }
		;

	statement:	assign_stmt  ';'		{ 							 }
		|	read_stmt ';'		{ }
		|	write_stmt ';'		{ }
		|	cond_stmt 		{ }
		|	func_stmt ';'		{ }
		;

	read_stmt:	READ '(' var_expr ')' {						 }
		;

	write_stmt:	WRITE '(' expr ')'
        {
          node *newNode = new node();
          newNode->Type = print;
          newNode->value = $3->value;
          newNode->name = NULL;
          newNode->lt = NULL;
          newNode->rt = NULL;
          newNode->next = NULL;
        }
		 | WRITE '(''"' str_expr '"'')'      { }

		;
	
	assign_stmt:	var_expr '=' expr
    {
  // VAR = NUM : store in symbol table. 
      // node *newNode = node(NULL, );
      // $$ = $3; // assignment stmt returns value of assignment stmt because x=y=3 : y=3 returns 3 -> so x=3 can be evaluated. 
          symbol_table[$1->name] = $3->value;
          node *newNode = new node();
          newNode->Type = assign;
          newNode->value = $3->value;
          newNode->name = $1->name;
          newNode->lt = $1;
          newNode->rt = $3;
          newNode->next = NULL;
          $$ = newNode;
        }
		;

	cond_stmt:	IF expr THEN stmt_list ENDIF 	{ 						}
		|	IF expr THEN stmt_list ELSE stmt_list ENDIF 	{ 						}
	        |    FOR '(' assign_stmt  ';'  expr ';'  assign_stmt ')' '{' stmt_list '}'                                             {                                                 }
		;
	
	func_stmt:	func_call 		{ 						}
		;
		
	func_call:	VAR '(' param_list ')'	{ 						   }
		;
		
	param_list:				
		|	param_list1		
		;
		
	param_list1:	para			
		|	para ',' param_list1	
		;

	para	:	expr			{ 						}
		;

	expr	:	NUM 
      { 
        // node *newNode = node(constant,$1->value);
        // $$ = newNode; 
          node *newNode = new node();
          newNode->Type = constant;
          newNode->value = $1->value;
          newNode->name = NULL;
          newNode->lt = NULL;
          newNode->rt = NULL;
          newNode->next = NULL;
          $$ = newNode;
        }
		|	'-' NUM	%prec UMINUS
      { 
        // node *newNode = node(constant,-1*($2->value));
        // $$ = newNode; 
          node *newNode = new node();
          newNode->Type = constant;
          newNode->value = (-1)*$2->value;
          newNode->name = NULL;
          newNode->lt = NULL;
          newNode->rt = NULL;
          newNode->next = NULL;
          $$ = newNode;
        }
		|	var_expr	//	{}
//		|	T			{ 						  	}
//		|	F			{ 	}
		|	'(' expr ')'		
      { 
        $$ = $2; 
      }

		|	expr '+' expr 
        {
          node *newNode = new node();
          newNode->Type = add;
          newNode->value = ($1->value)+($3->value);
          newNode->name = NULL;
          newNode->lt = $1;
          newNode->rt = $3;
          newNode->next = NULL;
          $$ = newNode;
        }
		|	expr '-' expr
        {
          node *newNode = new node();
          newNode->Type = sub;
          newNode->value = ($1->value)-($3->value);
          newNode->name = NULL;
          newNode->lt = $1;
          newNode->rt = $3;
          newNode->next = NULL;
          $$ = newNode;
        }
		|	expr '*' expr
        {
          node *newNode = new node();
          newNode->Type = mul;
          newNode->value = ($1->value)*($3->value);
          newNode->name = NULL;
          newNode->lt = $1;
          newNode->rt = $3;
          newNode->next = NULL;
          $$ = newNode;
        }
		|	expr '/' expr
        {
          node *newNode = new node();
          newNode->Type = Div;
          newNode->value = ($1->value)/($3->value);
          newNode->name = NULL;
          newNode->lt = $1;
          newNode->rt = $3;
          newNode->next = NULL;
          $$ = newNode;
        }

/*    |	expr '%' expr 		{ 						}
		|	expr '<' expr		{ 						}
		|	expr '>' expr		{ 						}
		|	expr GREATERTHANOREQUAL expr				{ 						}
		|	expr LESSTHANOREQUAL expr	{  						}
		|	expr NOTEQUAL expr			{ 						}
		|	expr EQUALEQUAL expr	{ 						}
		|	LOGICAL_NOT expr	{ 						}
		|	expr LOGICAL_AND expr	{ 						}
		|	expr LOGICAL_OR expr	{ 						}
		|	func_call		{  }
*/
		;
	str_expr :  VAR                       {}
                  | str_expr VAR   { }
                ;
	
	var_expr:	VAR	
      {
        node *newNode = new node();
        newNode->Type = declaration;
        newNode->value = UNDEFINED;
        newNode->name = $1->name;
        newNode->lt = NULL;
        newNode->rt = NULL;
        newNode->next = NULL;
        $$ = newNode;
      }
		|	var_expr '[' expr ']'	{                                                 }
		;
%%
void yyerror ( char  *s) {
   fprintf (stderr, "%s\n", s);
 }

int main(){
yyparse();
}

// ----------------------------------
/*
*/
/*
%left '<' '>'
%left EQUALEQUAL LESSTHANOREQUAL GREATERTHANOREQUAL NOTEQUAL
%left '%'
%left LOGICAL_AND LOGICAL_OR
%left LOGICAL_NOT
*/
// ----------------------------------

