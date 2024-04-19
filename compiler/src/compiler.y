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
#define UNDEFINED (INT_MAX/2)
using namespace std;
int yylex();
void yyerror( char* );
unordered_map<string, std::variant<int, bool>>symbol_table;
map<string, int*>array_table;
node *globalStatementList;
vector<const node*>statement_list; 

void printTree(node *stmt_list);
void printWholeTree(node* stmt_list);
void nodeImage(node *node) ;



// node *createNode(type Type, std::variant<int, bool> value = UNDEFINED,
//                  const char *name = NULL, node *leftTree = NULL,
//                  node *rightTree = NULL, node *next = NULL, node *expr = NULL,
//                  node *ifTrue = NULL, node *ifFalse = NULL, node *init = NULL,
//                  node *condition = NULL, node *update = NULL,
//                  node *body = NULL);

node *createNode(type Type, std::variant<int, bool> value = UNDEFINED,
                 const char *name = NULL, node *leftTree = NULL,
                 node *rightTree = NULL, node *next = NULL, node *expr = NULL,
                 node *ifTrue = NULL, node *ifFalse = NULL, node *init = NULL,
                 node *condition = NULL, node *update = NULL, node *body = NULL,
                 node *whilecond = NULL, node *whilestmts = NULL) ;


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
%token WHILE DO ENDWHILE FOR 
%token T F 
%token MAIN RETURN
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

// %type identifies type of non terminals
%type<Node> expr
%type<Node> statement 
%type<Node> stmt_list
%type<Node> cond_stmt
%type<Node> assign_stmt  write_stmt read_stmt func_stmt
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


%%

	Prog	:	Gdecl_sec stmt_list // Fdef_sec MainBlock		;
      {
        $1->next = $2;
        $$ = $1;
        globalStatementList = $1;
      }
      
//        {cout<<"In Prog\n";}
  ;
		
	Gdecl_sec:	DECL Gdecl_list ENDDECL 
    {
      $$ = $2;
    }
		;
		
	Gdecl_list: 
		| 	Gdecl Gdecl_list 
        {
          $$ = $1;
        }
		;
		
  Gdecl 	:	ret_type Glist ';' {
    // we have to create node for type of variable
    // type can be int or bool
    // Initially we have to create node for type in ret_type. 
    $$ = createNode(declarationStmt, UNDEFINED, NULL, $1, $2);
  }
		;
		
	ret_type:	T_INT
      { 
        // other than giving type, no info is there for ret_type node. 
        $$ = createNode(Int);
      }
    | T_BOOL 
      { 
        $$ = createNode(Bool); 
      }
		;
		
	Glist 	:	Gid
      {
         // $$ = createNode(declaration, UNDEFINED, $1->name);
         // symbol_table[$1->name] = UNDEFINED;
         // cout<<"variable "<<$1->name<<" is declared\n";
         $$ = $1;
      }
		|	Gid ',' Glist 
      {
        // $$ = createNode(declaration, UNDEFINED, $1->name, NULL, $3);
        // symbol_table[$1->name] = UNDEFINED;
        // cout<<"variable "<<$1->name<<" is declared\n";
        $1 -> rt = $3;
        $$ = $1;
      }
		;
	
	Gid	:	VAR	
      { 				
         $$ = createNode(declaration, UNDEFINED, $1->name);
         symbol_table[$1->name] = UNDEFINED;
         cout<<"variable "<<$1->name<<" is declared\n";
      }
		|	VAR '[' NUM ']'	
      {                                                   
        $$ = createNode(Array, getIntValue($3->value), $1->name);
        array_table[$1->name] = (int*)malloc(getIntValue($3->value)*sizeof(int));
        cout<<"Array "<<$1->name<<" is declared\n";
      }

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
    |	statement stmt_list	
          {		
            $1->next = $2;
            $$ = $1;
            cout<<$$<<" This is the address of node of stmt_list. \n";

            // statement_list.push_back($1);
          }
		|	error ';' 		{ cout<<"error stmt_list\n"; }
		;

	statement:	assign_stmt  ';'	
          {
            $$ = createNode(assignStmt, UNDEFINED, NULL, NULL, $1);
          }	
		|	read_stmt ';'	//	{ cout<<"read_stmt end\n"; }
		|	write_stmt ';'		
          { 
            $$ = createNode(printStmt, UNDEFINED, NULL, NULL, $1);
            // node* temp = $1;
            // some comments deleted. Check commits in April 5. 

            // while(temp != NULL)
            // {
            //   cout<<"3\n";
            //   cout<<temp->name<<" ";
            //   temp = temp->rt;
            // }
            // cout<<"\n";
          }

		|	cond_stmt 	 
          { 
            $$ = createNode(conditionStmt, UNDEFINED, NULL, NULL, $1);
          }
		|	func_stmt ';'		// { cout<<"func_stmt end\n";}
    | error ';' {cout<<"error statement\n";}
		;

	read_stmt:	READ '(' var_expr ')' {						 
  }
  ;

  write_stmt: WRITE '(' Wlist ')' 
    {// cout<<"write_stmt inside end\n";
      $$ = $3;
    }
  ;

  Wlist : Wid 
        {
          // cout<<getSymbolValue($1->name)<<"\n";
          $$ = createNode(print, getSymbolValue($1->name, symbol_table), $1->name);
        }
        
  | Wid ',' Wlist
        {
          // $1->value = getSymbolValue($1->name);
          // cout<<getSymbolValue($1->name)<<"\n";
          $$ = createNode(print, getSymbolValue($1->name, symbol_table), $1->name, NULL, $3);
        }
  ;

	Wid	:	VAR		{ 				}
		|	Wid '[' NUM ']'	{ }

		;
		


	
	assign_stmt:	var_expr '=' expr
        {
          // setSymbolValue($1->name, $3->value, symbol_table);
          if($1->Type == assignVar){
            symbol_table[$1->name] = $3->value;
            $$ = createNode(assign, $3->value, $1->name, $1, $3);
          } else {
            string s = string($1->name);
            s = s + "[" + to_string(getIntValue($1->value)) + "]";
            array_table[$1->name][getIntValue($1->value)] = getIntValue($3->value);
            $$ = createNode(assign, $3->value, s.c_str(), $1, $3);
          }



          // symbol_table[$1->name] = $3->value;
          //  $$ = createNode(assign, $3->value, $1->name, $1, $3);
          // cout<<$$<<" This is the address of node of assign stmt. \n";
          // cout<<"An assign node creation\n";
        }
		;

	cond_stmt:	IF expr '{'stmt_list'}'
        {  
          // write code for if statement 
          $$ = createNode(If, UNDEFINED, NULL, NULL, NULL, NULL, $2, $4);
        }
		|	IF expr '{'stmt_list'}' ELSE '{'stmt_list'}' 
        { 						
          // write code for if else statement
          $$ = createNode(IfElse , UNDEFINED, NULL, NULL, NULL, NULL, $2, $4, $8);
        }
    | FOR '(' assign_stmt  ';'  expr ';'  assign_stmt ')' '{' stmt_list '}'     
        {
          $$ = createNode(For, UNDEFINED, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $3, $5, $7, $10);
        }
    | WHILE '(' expr ')' '{' stmt_list '}'
        {
          $$ = createNode(While, UNDEFINED, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, $3, $6);
        }

    | error ';' 
        {
          cout<<"error in for/while loop\n";
        }
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
          $$ = createNode(constant, $1->value);
      }
		|	'-' NUM	%prec UMINUS
      { 
          $$ = createNode(constant, (-1)*std::get<int>($2->value));
      }
		|	var_expr		
      {
        // $$ = createNode(declaration, UNDEFINED, $1->name);
        $$ = $1;
      }
		|	T			{ 						  	}
		|	F			{ 	}
		|	'(' expr ')'		
      { 
        $$ = $2; 
      }

		|	expr '+' expr 
        {
          $$ = createNode(add, getIntValue($1->value)  + getIntValue($3->value), NULL, $1, $3, NULL);
        }
		|	expr '-' expr
        {
          $$ = createNode(sub, getIntValue($1->value) - getIntValue($3->value), NULL, $1, $3, NULL);
        }
		|	expr '*' expr
        {
          $$ = createNode(mul, getIntValue($1->value) * getIntValue($3->value), NULL, $1, $3, NULL);
        }
		|	expr '/' expr
        {
          if(getIntValue($3->value) == 0)
          {
            cout<<"ZeroDivisionError\n";
            exit(1);
          }
          $$ = createNode(Div, (int)(getIntValue($1->value) / getIntValue($3->value)), NULL, $1, $3, NULL);
        }
// 		|	expr '%' expr 		{ 						}
		|	expr '<' expr		
        { 						
          // $$ = createNode(lt, $1->value < $3->value, leftTree = $1, rightTree = $3);
          $$ = createNode(lt, getIntValue($1->value) < getIntValue($3->value), NULL, $1, $3);
        }
		|	expr '>' expr		
        { 						
        //   $$ = createNode(gt, truthVal = $1->value > $3->value, leftTree = $1, rightTree = $3);
        $$ = createNode(gt, getIntValue($1->value) > getIntValue($3->value), NULL, $1, $3);
        }
		|	expr GREATERTHANOREQUAL expr			
        { 						
        //   $$ = createNode(ge, truthVal = $1->value >= $3->value, leftTree = $1, rightTree = $3);
        $$ = createNode(ge, getIntValue($1->value) >= getIntValue($3->value), NULL, $1, $3);
        }
		|	expr LESSTHANOREQUAL expr	
        { 						
        //   $$ = createNode(le, truthVal = $1->value <= $3->value, leftTree = $1, rightTree = $3);
        $$ = createNode(le, getIntValue($1->value) <= getIntValue($3->value), NULL, $1, $3);
        }
		|	expr NOTEQUAL expr		
        { 						
        //   $$ = createNode(ne, truthVal = $1->value != $3->value, leftTree = $1, rightTree = $3);
        $$ = createNode(ne, getIntValue($1->value) != getIntValue($3->value), NULL, $1, $3);
        }
		|	expr EQUALEQUAL expr	
        { 					
        //   $$ = createNode(eq, truthVal = $1->value == $3->value, leftTree = $1, rightTree = $3);
        $$ = createNode(eq, getIntValue($1->value) == getIntValue($3->value), NULL, $1, $3);
        }
		|	LOGICAL_NOT expr	
        { 					
        //   $$ = createNode(Not, truthVal = !$2->value, rightTree = $2);
        // even if we write UNDEFINED in the position of node->value, no problem is there, because
        // we are just building an AST. 
        $$ = createNode(Not, !getBoolValue($2->value), NULL, NULL, $2);
        }
		|	expr LOGICAL_AND expr	
        { 					
        //   $$ = createNode(And, truthVal = $1->value && $3->value, leftTree = $1, rightTree = $3);
        $$ = createNode(And,getBoolValue($1->value) && getBoolValue($3->value), NULL, $1, $3);
        }
		|	expr LOGICAL_OR expr	
        { 					
        //   $$ = createNode(Or, truthVal = $1->value || $3->value, leftTree = $1, rightTree = $3);
        $$ = createNode(Or, getBoolValue($1->value) || getBoolValue($3->value), NULL, $1, $3);
        }

		;
	
	var_expr:	VAR	
      {
        // $$ = createNode(var, getSymbolValue($1->name, symbol_table), $1->name);
        $$ = createNode(assignVar, getSymbolValue($1->name, symbol_table), $1->name);
      }
		|	var_expr '[' expr ']'	
      {                                                 
        // $$ = createNode(var, getSymbolValue($1->name, symbol_table), $1->name);
        // $$ = createNode(Array, getIntValue($3->value), $1->name);
        // array_table[$1->name] = (int*)malloc(getIntValue($3->value)*sizeof(int));
        $$ = createNode(assignArray, array_table[$1->name][getIntValue($3->value)], $1->name, NULL, $3);
      }
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
nodeImage(globalStatementList);
cout<<"\n\n\nprintTree\n";
printTree(globalStatementList);



// cout<<"\n\nInfix Traversal\n";
if(globalStatementList == NULL)cout<<"haha\n root is null\n";
// nodeImage(globalStatementList);
}
