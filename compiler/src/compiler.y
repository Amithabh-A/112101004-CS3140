%{	
#define parse.error verbose
#define YYDEBUG 1
#include<iostream>
#include<string>
#include<cstring>
#include<unordered_map>
#include<vector>
#include "../include/compiler.h"
#define UNDEFINED INT_MAX
using namespace std;
int yylex();
void yyerror( char* );
unordered_map<string, int>symbol_table;
vector<const node*>stmt_list;

void printStatement(node* statement);
void printTree(vector<const node*> stmt_list);

node* createNode(type Type, int value, const char* name, node* leftTree, node* rightTree, node* next) {
    node *newNode = new node();
    newNode->Type = Type;
    newNode->value = value;
    newNode->name = name ? strdup(name) : NULL; // strdup - str dup - string duplicate fn in c. Ensure deep copy of name
    // NOTE : NULL is used with pointer data types only. 
    // If value is not being assigned, we will just assign it with UNDEFINED. 
    newNode->lt = leftTree;
    newNode->rt = rightTree;
    newNode->next = next;
    newNode->ifTrue = NULL;
    newNode->ifFalse = NULL;
    return newNode;
}

int getSymbolValue(const string& name) { // just taking string reference, avoiding copy. 
    if(symbol_table.find(name) != symbol_table.end()) {
        return symbol_table[name];
    } else {
        cout << "Error: Undefined symbol '" << name << "'." << endl;
        return UNDEFINED; // Consider how you want to handle undefined symbols
    }
}

void setSymbolValue(const string& name, int value) {
    symbol_table[name] = value;
}

void printNode(const node* node) {
    if (!node) return;
    switch (node->Type) {
        case assign:
            cout << "ASSIGN " << node->name << " " << node->value << "\n";
            break;
        case print:
            cout << "CALL print ";
            while (node != NULL) {
                cout << node->name << " ";
                node = node->next;
            }
            cout << "\n";
            break;
        case declaration:
            cout << "DECLARATION ";
            while (node != NULL) {
                cout << node->name << " ";
                node = node->next;
            }
            cout << "\n";
            break;
        // Add cases for other types as needed
        default:
            cout << "Unknown node type\n";
    }
}

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
// below line might be shitty. Sorry


%%

	Prog	:	Gdecl_sec stmt_list // Fdef_sec MainBlock		;
//        {cout<<"In Prog\n";}
  ;
		
	Gdecl_sec:	DECL Gdecl_list ENDDECL {
      }
		;
		
	Gdecl_list: 
		| 	Gdecl Gdecl_list
		;
		
  Gdecl 	:	ret_type Glist ';'
//      {
//        cout<<"Gdecl\n";
//        stmt_list.push_back($2);
//            for(auto it : stmt_list)cout<<it->Type<<" ";cout<<"\n";
//      }
		;
		
	ret_type:	T_INT		{ }
    | T_BOOL { }
		;
		
	Glist 	:	Gid
             {
                $$ = createNode(declaration, UNDEFINED, $1->name, NULL, NULL, NULL);
             }
		|	Gid ',' Glist 
      {
                $$ = createNode(declaration, UNDEFINED, $1->name, NULL, NULL, $3);
      }
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
		|	statement stmt_list	
//          {		
//            cout<<"stmt end\n";				
//          }
		//|	error ';' 	//	{ cout<<"error end \n"; }
		;

	statement:	assign_stmt  ';'	
          {
            $$ = $1;
            stmt_list.push_back($1);
//             for(auto it : stmt_list)cout<<it->Type<<" ";cout<<"\n";
          }	
		|	read_stmt ';'	//	{ cout<<"read_stmt end\n"; }
		|	write_stmt ';'		
          { 
            $$ = $1;
            stmt_list.push_back($1);
//             for(auto it : stmt_list)cout<<it->Type<<" ";cout<<"\n";
            auto temp = $1;
 //           cout<<"printing variables in write stmt";
//
//            // This test is for testing whether a node is pointing to itself
//            // testcase is single assign and single print of a. 
//
//            if(temp->next == temp) {
//              cout<<"ERROR : node pointing to itself!!\n Check print. ";
//              exit(1);
//            }


            while(temp != NULL)
            {
              cout<<temp->name<<" ";
              temp = temp->next;
            }
            cout<<"\n";
          }
		|	cond_stmt 	 { cout<<"cond_stmt end\n";}
		|	func_stmt ';'		// { cout<<"func_stmt end\n";}
		;

	read_stmt:	READ '(' var_expr ')' {						 
  }
  ;

  write_stmt: WRITE '(' Wlist ')' {// cout<<"write_stmt inside end\n";
     $$ = $3;
    }
  ;

  Wlist : Wid 
        {
//           cout<<"entered Wid\n";
          $1->Type = print;
          $1->value = getSymbolValue($1->name);
          cout<<getSymbolValue($1->name)<<"\n";
          $$ = $1;
//           cout<<"exiting Wid\n";
        }
        
  | Wid ',' Wlist
        {
          $1->Type = print;
          $1->value = getSymbolValue($1->name);
          cout<<getSymbolValue($1->name)<<"\n";
          $1->next = $3;
          $$ = $1;
        }
  ;

	Wid	:	VAR		{ 				}
		|	Wid '[' NUM ']'	{ }

		;
		


	
	assign_stmt:	var_expr '=' expr
        {
          setSymbolValue($1->name, $3->value);
          $$ = createNode(assign, $3->value, $1->name, $1, $3, NULL);
        }
		;

	cond_stmt:	IF expr THEN '{'stmt_list'}' ENDIF 	
        {  
          cout<<"in if expr\n";
          $$ = createNode(condition, 0, NULL, NULL, NULL, NULL);
          $$->ifTrue = $5;
          cout<<"going out of if expr\n";
        }
		|	IF expr THEN '{'stmt_list'}' ELSE '{'stmt_list'}' ENDIF 
        { 						
          cout<<"in if else expr\n";
          $$ = createNode(condition, 0, NULL, NULL, NULL, NULL);
          $$->ifTrue = $5;
          $$->ifFalse = $9;
          cout<<"going out of if else expr\n";
        }
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
          $$ = createNode(constant, $1->value, NULL, NULL, NULL, NULL);
        }
		|	'-' NUM	%prec UMINUS
      { 
          $$ = createNode(constant, (-1)*$2->value, NULL, NULL, NULL, NULL);
        }
		|	var_expr	//	{}
		|	T			{ 						  	}
		|	F			{ 	}
		|	'(' expr ')'		
      { 
        $$ = $2; 
      }

		|	expr '+' expr 
        {
          $$ = createNode(add, $1->value + $3->value, NULL, $1, $3, NULL);
        }
		|	expr '-' expr
        {
          $$ = createNode(sub, $1->value - $3->value, NULL, $1, $3, NULL);
        }
		|	expr '*' expr
        {
          $$ = createNode(mul, $1->value * $3->value, NULL, $1, $3, NULL);
        }
		|	expr '/' expr
        {
          if($3->value == 0)
          {
            cout<<"ZeroDivisionError\n";
            exit(1);
          }
          $$ = createNode(Div, (int)($1->value / $3->value), NULL, $1, $3, NULL);
        }
// 		|	expr '%' expr 		{ 						}
		|	expr '<' expr		
        { 						
          $$ = createNode(lt, $1->value < $3->value, NULL, $1, $3, NULL);
        }
		|	expr '>' expr		
        { 						
          $$ = createNode(gt, $1->value > $3->value, NULL, $1, $3, NULL);
        }
		|	expr GREATERTHANOREQUAL expr			
        { 						
          $$ = createNode(ge, $1->value >= $3->value, NULL, $1, $3, NULL);
        }
		|	expr LESSTHANOREQUAL expr	
        { 						
          $$ = createNode(le, $1->value <= $3->value, NULL, $1, $3, NULL);
        }
		|	expr NOTEQUAL expr		
        { 						
          $$ = createNode(ne, $1->value != $3->value, NULL, $1, $3, NULL);
        }
		|	expr EQUALEQUAL expr	
        { 					
          $$ = createNode(eq, $1->value == $3->value, NULL, $1, $3, NULL);
        }
		|	LOGICAL_NOT expr	
        { 					
          $$ = createNode(not, $2->value, NULL, $2, NULL, NULL);
        }
		|	expr LOGICAL_AND expr	
        { 					
          $$ = createNode(and, $1->value && $3->value, NULL, $1, $3, NULL);
        }
		|	expr LOGICAL_OR expr	
        { 					
          $$ = createNode(or, $1->value || $3->value, NULL, $1, $3, NULL);
        }

		;
	
	var_expr:	VAR	
      {
        $$ = createNode(declaration, getSymbolValue($1->name), $1->name, NULL, NULL, NULL);
      }
		|	var_expr '[' expr ']'	{                                                 }
		;
%%
void yyerror ( char  *s) {
   fprintf (stderr, "%s\n", s);
 }

void printTree(vector<const node*> stmt_list)
{
  for(const auto& it : stmt_list)
  {
    printNode(it);
  }
}

int main(){
extern int yydebug;
yydebug = 1;
yyparse();
printTree(stmt_list);
}

// ----------------------------------
/*
*/
