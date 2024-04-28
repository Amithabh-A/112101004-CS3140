%{	
#define parse.error verbose
#define YYDEBUG 1
#include<iostream>
#include<string>
#include<cstring>
#include<algorithm>
#include<utility>
#include<vector>
#include<map>
#include<string>
#include "../include/compiler.h"
#include <type_traits>
#define UNDEFINED INT_MAX
#define NOT_INITIALIZED INT_MIN
using namespace std;
int yylex();
void yyerror( char* );
node *globalStatementList;
vector<const node*>statement_list; 
unordered_map<string, std::variant<int, bool>>symbol_table;
map<string, pair<int *, int>> array_table;

void printTree(node *stmt_list);
void printWholeTree(node* stmt_list);
void nodeImage(node *node) ;
bool is_statement(type value);
void insertNext(node *stmt_list, node *stmt) ;

node *createNode(type Type, std::variant<int, bool> value = UNDEFINED,
                 const char *name = NULL, node *leftTree = NULL,
                 node *rightTree = NULL, node *next = NULL, node *expr = NULL,
                 node *ifTrue = NULL, node *ifFalse = NULL, node *init = NULL,
                 node *condition = NULL, node *update = NULL, node *body = NULL,
                 node *returnStmt = NULL);

std::variant<int, bool> getSymbolValue(
    const string &name,
    unordered_map<string, std::variant<int, bool>>
        &symbol_table) ; // just taking string reference, avoiding copy.
void setSymbolValue(const string &name, std::variant<int, bool> value,
                    unordered_map<string, std::variant<int, bool>> symbol_table); 
void printNode(const node *node) ;
int getIntValue(std::variant<int, bool> value);
bool getBoolValue(std::variant<int, bool> value);

void set_array(string name, pair<int *, int> p, map<string, pair<int *, int>> array_table) ;
void set_array_element(string name, int index, int value, map<string, pair<int *, int>> array_table) ;
int get_array_element(string name, int index, map<string, pair<int *, int>> array_table) ;
int *get_array(string name, map<string, pair<int *, int>> array_table) ;


%}
%union{
  struct node* Node;
}
%token<Node> VAR NUM WRITE
%token BEG END
%token T_INT T_BOOL
%token READ 
%token DECL ENDDECL
%token IF THEN ELSE ENDIF
%token LOGICAL_AND LOGICAL_NOT LOGICAL_OR
%token EQUALEQUAL LESSTHANOREQUAL GREATERTHANOREQUAL NOTEQUAL
%token WHILE DO ENDWHILE FOR BREAK
%token T F 
%token T_PLUS_PLUS
%token MAIN RETURN
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type<Node> expr
%type<Node> statement 
%type<Node> stmt_list
%type<Node> assign_stmt write_stmt cond_stmt break_stmt
%type<Node> var_expr
%type<Node> Glist
%type<Node> Wlist
%type<Node> Gid
%type<Node> Wid
%type<Node> Gdecl_sec
%type<Node> Prog
%type<Node> Gdecl_list
%type<Node> Gdecl
%type<Node> ret_type
%type<Node> ret_stmt
%type<Node> mymain


%%

	Prog	:	Gdecl_sec mymain { $$ = createNode(Prog, UNDEFINED, NULL, $1, $2);}
  | error ';' {cout<<"error in Prog\n";}
  ;

	Gdecl_sec:	DECL Gdecl_list ENDDECL { $$ = createNode(declaration_stmtlist, UNDEFINED, NULL, NULL, NULL, $2);}// Gdecl_sec == decl_stmtlist
    | error ';' {cout<<"error in Gdecl_sec\n";}
		;

  mymain : BEG stmt_list ret_stmt END {
    /*
      main is divided into two parts : 
      1. body - handled by `body` used by for loop
      2. return statement - seperate node

    */
    $$ = createNode(Main, UNDEFINED, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $2, $3);
  }
  | error ';' {cout<<"error in mymain\n";}
  ;
		
	Gdecl_list: 
		| 	Gdecl Gdecl_list  // Ddecl == decl_stmt
        {
          $$ = $1;
          $$->next = $2;
        }
    | error ';' {cout<<"error in Gdecl_list\n";}
		;
		
  Gdecl 	:	ret_type Glist ';' // ret_type == type, Glist == decl_nodelist
      {
        $$ = createNode(declarationStmt, UNDEFINED, NULL, $1, $2);
      }
    | error ';' {cout<<"error in Gdecl\n";}
		;
		
	ret_type:	T_INT // { $$ = createNode(Int); }
      {
        $$ = createNode(Int);
      }
    | T_BOOL // { $$ = createNode(Bool); }
      {
        $$ = createNode(Bool);
      }
    | error ';' {cout<<"error in ret_type\n";}
		;
		
	Glist 	:	Gid 
      {
        /*
          here, Gid is the node. It can be a var declaration or an array declaration. 
        */
        $$ = $1;
      }
		|	Gid ',' Glist 
      {
        $$ = $1;
        $$->next = $3;
      }
    | error ';' {cout<<"error in Glist\n";}
		;
	
	Gid	:	VAR	
      { 				
        $$ = createNode(declVar, NOT_INITIALIZED, $1->name);
        setSymbolValue($1->name, NOT_INITIALIZED, symbol_table);
      }
		|	VAR '[' NUM ']'	
      {                                                   
        // value of the node is the bound of the array. 
        $$ = createNode(declArray, getIntValue($3->value), $1->name);
        set_array($1->name, make_pair(new int[getIntValue($3->value)], getIntValue($3->value)), array_table);
      }
    | error ';' {cout<<"error in Gid\n";}

		;

	ret_stmt:	RETURN expr ';' 
    {
      $$ = createNode(returnStmt, UNDEFINED, NULL, NULL, NULL, NULL, $2);
    }
		;
			
	stmt_list: statement stmt_list	{
        $$ = $1;
        $$->next = $2;
      }
		|	error ';' 		{ cout<<"error stmt_list\n"; }
		;

	statement:	
    assign_stmt  ';' 
      {
        $$ = $1;
      }
		|	write_stmt ';'  
      {
        $$ = $1;
      }
	  |	cond_stmt 
      {
        $$ = $1;
      }
    | break_stmt ';' // { $$ = $1;}
    | error ';' {cout<<"error statement\n";}
		;

  break_stmt: BREAK // { $$ = createNode(breakStmt); }
    {
      $$ = createNode(breakStmt);
    }


  write_stmt: WRITE '(' Wlist ')' 
    {
      $$ = createNode(writeStmt, UNDEFINED, NULL, NULL, $3);
    }
  ;

  Wlist : Wid 
    {
      $$ = $1;
    }
  | Wid ',' Wlist
    {
      $$ = $1;
      $$->next = $3;
    }
  | error ';' {cout<<"error Wlist\n";}
  ;

	Wid	:	VAR 
      {
        $$ = createNode(writeVar, getSymbolValue($1->name, symbol_table), $1->name);
      }
		|	Wid '[' NUM ']'	
      {
        $$ = createNode(writeArr, getIntValue($3->value) , $1->name, NULL, $3);
        get_array_element($1->name, getIntValue($3->value), array_table);
      }
    | error ';' {cout<<"error Wid\n";}

		;
		
	assign_stmt:	var_expr '=' expr
        {
          $$ = createNode(assignStmt, UNDEFINED, NULL, $1, NULL, NULL, $3);
          // trying to assign here : 
          // switch($1->Type) {
          //   case var:
          //     setSymbolValue($1->name, $3->value, symbol_table);
          //     break; 
          //   case Array:
          //     set_array_element($1->name, getIntValue($1->value), getIntValue($3->value), array_table);
          //     break;
          //   default:
          //     cout<<"error in assign_stmt\n";
          //     break;
          // }
        }
    | var_expr T_PLUS_PLUS 
      {
        $$ = createNode(incStmt, UNDEFINED, NULL, $1);
        /*
          write the semantics later. 
          */
      }
    | 
      {
        $$ = createNode(nullStmt);
      }
    | error ';' {cout<<"error in assign_stmt\n";}
		;

	cond_stmt:	
    IF expr '{'stmt_list'}'
      {
        $$ = createNode(ifStmt, UNDEFINED, NULL, NULL, NULL, NULL, $2, $4);
      }
		|	IF expr '{'stmt_list'}' ELSE '{'stmt_list'}'
      {
        $$ = createNode(ifElseStmt, UNDEFINED, NULL, NULL, NULL, NULL, $2, $4, $8);
      }
    | FOR '(' assign_stmt  ';'  expr ';'  assign_stmt ')' '{' stmt_list '}' 
      {
        $$ = createNode(forStmt, UNDEFINED, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $3, $5, $7, $10);
      }
		;
	
	expr	:	NUM { $$ = createNode(constant, $1->value);}
		|	'-' NUM	%prec UMINUS { $$ = createNode(constant, -getIntValue($2->value));}
		|	var_expr {$$ = $1;}
		|	T			{ 						  	}
		|	F			{ 	}
		|	'(' expr ')'	{ $$ = $2;}
		|	expr '+' expr { $$ = createNode(add, getIntValue($1->value) + getIntValue($3->value), NULL, $1, $3);}
		|	expr '-' expr { $$ = createNode(sub, getIntValue($1->value) - getIntValue($3->value), NULL, $1, $3);}
		|	expr '*' expr { $$ = createNode(mul, UNDEFINED, NULL, $1, $3);}
		|	expr '/' expr 
      {
        $$ = createNode(Div, UNDEFINED, NULL, $1, $3);
        if(getIntValue($3->value) == 0) {
          cout<<"Division by zero\n";
        } else {
          $$->value = getIntValue($1->value) / getIntValue($3->value);
        }
      }
		|	expr '<' expr	{ $$ = createNode(lt, getIntValue($1->value) < getIntValue($3->value), NULL, $1, $3);}
		|	expr '>' expr	{ $$ = createNode(gt, getIntValue($1->value) > getIntValue($3->value), NULL, $1, $3);}
		|	expr GREATERTHANOREQUAL expr { $$ = createNode(ge, getIntValue($1->value) >= getIntValue($3->value), NULL, $1, $3);}
		|	expr LESSTHANOREQUAL expr	{ $$ = createNode(le, getIntValue($1->value) <= getIntValue($3->value), NULL, $1, $3);}
		|	expr NOTEQUAL expr { $$ = createNode(ne, getIntValue($1->value) != getIntValue($3->value), NULL, $1, $3);}
		|	expr EQUALEQUAL expr { $$ = createNode(eq, getIntValue($1->value) == getIntValue($3->value), NULL, $1, $3);}
		|	LOGICAL_NOT expr { $$ = createNode(Not, !getBoolValue($2->value), NULL, NULL, $2);}
		|	expr LOGICAL_AND expr	{ $$ = createNode(And, getBoolValue($1->value) && getBoolValue($3->value), NULL, $1, $3);}
		|	expr LOGICAL_OR expr { $$ = createNode(Or, getBoolValue($1->value) || getBoolValue($3->value), NULL, $1, $3);}
    | error ';' {cout<<"error in expr\n";}
		;
	
	var_expr:	VAR	// { $$ = createNode(assignVar, getSymbolValue($1->name, symbol_table), $1->name);}
      {
        $$ = createNode(var, getSymbolValue($1->name, symbol_table), $1->name);
      }
		|	var_expr '[' expr ']'	// { $$ = createNode(assignArray, getIntValue($3->value), $1->name, NULL, $3);}
      {
        $$ = createNode(Array, getIntValue($3->value), $1->name);
        get_array($1->name, array_table);
      }
    | error ';' {cout<<"error in var_expr\n";}
		;
%%
void yyerror ( char  *s) {
   fprintf (stderr, "%s\n", s);
 }

int main(){
extern int yydebug;
// yydebug = 1;
yyparse();
// cout<<"Size of statement list : "<<statement_list.size()<<"\n";
// nodeImage(globalStatementList);
cout<<"\n\n\nprintTree\n";
printTree(globalStatementList);
if(globalStatementList == NULL)cout<<"haha\n root is null\n";
}
