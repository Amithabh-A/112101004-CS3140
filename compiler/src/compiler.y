%{	
#define parse.error verbose
#define YYDEBUG 1
#include<iostream>
#include<string>
#include<cstring>
#include<unordered_map>
#include<map>
#include<vector>
#include "../include/compiler.h"
#include <type_traits>
#define UNDEFINED INT_MAX
#define NOT_INITIALIZED INT_MIN
using namespace std;
int yylex();
void yyerror( char* );
map<string, int*>array_table;
node *globalStatementList;
vector<const node*>statement_list; 
unordered_map<string, std::variant<int, bool>>symbol_table;

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
    $$ = createNode(main, UNDEFINED, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $2, $3);
  }
  | error ';' {cout<<"error in mymain\n";}
  ;
		
	Gdecl_list: 
		| 	Gdecl Gdecl_list  // Ddecl == decl_stmt
        {
        }
    | error ';' {cout<<"error in Gdecl_list\n";}
		;
		
  Gdecl 	:	ret_type Glist ';' // ret_type == type, Glist == decl_nodelist
    | error ';' {cout<<"error in Gdecl\n";}
		;
		
	ret_type:	T_INT // { $$ = createNode(Int); }
    | T_BOOL // { $$ = createNode(Bool); }
    | error ';' {cout<<"error in ret_type\n";}
		;
		
	Glist 	:	Gid // { $$ = createNode(declaration, UNDEFINED, NULL, $1); }
		|	Gid ',' Glist // { $$ = createNode(declaration, UNDEFINED, NULL, $1, $3); }
    | error ';' {cout<<"error in Glist\n";}
		;
	
	Gid	:	VAR	
      { 				
        // $$ = createNode(var, UNDEFINED, $1->name);
        // symbol_table[$$->name] = UNDEFINED;
      }
		|	VAR '[' NUM ']'	
      {                                                   
        // $$ = createNode(Array, getIntValue($3->value), $1->name);
        // array_table[$$->name] = (int*)malloc(getIntValue($$->value)*sizeof(int));
      }
    | error ';' {cout<<"error in Gid\n";}

		;

	ret_stmt:	RETURN expr ';'// 	{ $$ = createNode(returnStmt, getIntValue($2->value), NULL, NULL, $2); }
		;
			
	stmt_list: statement stmt_list	{
        $$ = $1;
        $$->next = $2;
      }
		|	error ';' 		{ cout<<"error stmt_list\n"; }
		;

	statement:	
    assign_stmt  ';'	{ $$ = $1; }
		|	write_stmt ';'  { $$ = $1; }
	  |	cond_stmt // { $$ = createNode(conditionStmt, UNDEFINED, NULL, NULL, $1);}
    | break_stmt ';' // { $$ = $1;}
    | error ';' {cout<<"error statement\n";}
		;

  break_stmt: BREAK // { $$ = createNode(breakStmt); }


  write_stmt: WRITE '(' Wlist ')' 
    {
      $$ = createNode(printStmt, UNDEFINED, NULL, NULL, $3);
    }
  | error ';' {cout<<"error write_stmt\n";}
  ;

  Wlist : Wid//  { $$ = createNode(print, getSymbolValue($1->name, symbol_table), $1->name); }
  | Wid ',' Wlist // { $$ = createNode(print, getSymbolValue($1->name, symbol_table), $1->name, NULL, $3);}
  | error ';' {cout<<"error Wlist\n";}
  ;

	Wid	:	VAR		{ 				}
		|	Wid '[' NUM ']'	{ }
    | error ';' {cout<<"error Wid\n";}

		;
		
	assign_stmt:	var_expr '=' expr
        {
          $$ = createNode(assignStmt, UNDEFINED, NULL, $1, $3);
        }
    | var_expr T_PLUS_PLUS 
      {
        // define this after expr definitions. 
      }
    | // {$$ = createNode(null);}
    | error ';' {cout<<"error in assign_stmt\n";}
		;

	cond_stmt:	
    IF expr '{'stmt_list'}' // { $$ = createNode(If, UNDEFINED, NULL, NULL, NULL, NULL, $2, $4);}
		|	IF expr '{'stmt_list'}' ELSE '{'stmt_list'}'//  { $$ = createNode(IfElse , UNDEFINED, NULL, NULL, NULL, NULL, $2, $4, $8);}
    | FOR '(' assign_stmt  ';'  expr ';'  assign_stmt ')' '{' stmt_list '}' // { $$ = createNode(For, UNDEFINED, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $3, $5, $7, $10);}
    | error ';' {cout<<"error in cond_stmt\n";}
		;
	
	expr	:	NUM // { $$ = createNode(constant, $1->value);}
		|	'-' NUM	%prec UMINUS // { $$ = createNode(constant, (-1)*std::get<int>($2->value));}
		|	var_expr // { $$ = $1;}
		|	T			{ 						  	}
		|	F			{ 	}
		|	'(' expr ')'	// { $$ = $2;}
		|	expr '+' expr // { $$ = createNode(add, getIntValue($1->value)  + getIntValue($3->value), NULL, $1, $3, NULL);}
		|	expr '-' expr // { $$ = createNode(sub, getIntValue($1->value) - getIntValue($3->value), NULL, $1, $3, NULL);}
		|	expr '*' expr // { $$ = createNode(mul, getIntValue($1->value) * getIntValue($3->value), NULL, $1, $3, NULL);}
		|	expr '/' expr
        {
          // if(getIntValue($3->value) == 0)
          // {
          //   cout<<"ZeroDivisionError\n";
          //   exit(1);
          // }
          // $$ = createNode(Div, (int)(getIntValue($1->value) / getIntValue($3->value)), NULL, $1, $3, NULL);
        }
		|	expr '<' expr	// { $$ = createNode(lt, getIntValue($1->value) < getIntValue($3->value), NULL, $1, $3);}
		|	expr '>' expr	// { $$ = createNode(gt, getIntValue($1->value) > getIntValue($3->value), NULL, $1, $3);}
		|	expr GREATERTHANOREQUAL expr // { $$ = createNode(ge, getIntValue($1->value) >= getIntValue($3->value), NULL, $1, $3);}
		|	expr LESSTHANOREQUAL expr	// { $$ = createNode(le, getIntValue($1->value) <= getIntValue($3->value), NULL, $1, $3);}
		|	expr NOTEQUAL expr //{ $$ = createNode(ne, getIntValue($1->value) != getIntValue($3->value), NULL, $1, $3);}
		|	expr EQUALEQUAL expr // { $$ = createNode(eq, getIntValue($1->value) == getIntValue($3->value), NULL, $1, $3);}
		|	LOGICAL_NOT expr // { $$ = createNode(Not, !getBoolValue($2->value), NULL, NULL, $2);}
		|	expr LOGICAL_AND expr	// { $$ = createNode(And,getBoolValue($1->value) && getBoolValue($3->value), NULL, $1, $3);}
		|	expr LOGICAL_OR expr // { $$ = createNode(Or, getBoolValue($1->value) || getBoolValue($3->value), NULL, $1, $3);}
    | error ';' {cout<<"error in expr\n";}
		;
	
	var_expr:	VAR	// { $$ = createNode(assignVar, getSymbolValue($1->name, symbol_table), $1->name);}
		|	var_expr '[' expr ']'	// { $$ = createNode(assignArray, getIntValue($3->value), $1->name, NULL, $3);}
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
