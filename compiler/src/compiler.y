%{	
#include<iostream>
#include<string>
#include<cstring>
#include<unordered_map>
#include<vector>
#include "../include/compiler.h"
#define UNDEFINED 2
using namespace std;
int yylex();
void yyerror( char* );
unordered_map<string, int>symbol_table;
vector<const node*>statement_list;

void printStatement(node* statement);
void printTree(vector<const node*> statement_list);

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
%type<Node> assign_stmt
%type<Node> write_stmt
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
//        statement_list.push_back($2);
//            for(auto it : statement_list)cout<<it->Type<<" ";cout<<"\n";
//      }
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
                $$ = newNode; 
             }
		|	Gid ',' Glist 
      {
                node *newNode = new node();
                newNode->Type = declaration;
                newNode->value = UNDEFINED;
                newNode->name = $1->name;
                newNode->lt = NULL;
                newNode->rt = NULL;
                newNode->next = $3;
                $$ = newNode;
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
		|	error ';' 	//	{ cout<<"error end \n"; }
		;

	statement:	assign_stmt  ';'	
          {
            $$ = $1;
            statement_list.push_back($1);
//             for(auto it : statement_list)cout<<it->Type<<" ";cout<<"\n";
          }	
		|	read_stmt ';'	//	{ cout<<"read_stmt end\n"; }
		|	write_stmt ';'		
          { 
//            cout<<"write stmt end\n"; 
            $$ = $1;
            statement_list.push_back($1);
//             for(auto it : statement_list)cout<<it->Type<<" ";cout<<"\n";
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
		|	cond_stmt 		// { cout<<"cond_stmt end\n";}
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
          $1->value = symbol_table[$1->name];
          cout<<symbol_table[$1->name]<<"\n";
          $$ = $1;
//           cout<<"exiting Wid\n";
        }
        
  | Wid ',' Wlist
        {
          $1->Type = print;
          $1->value = symbol_table[$1->name];
          cout<<symbol_table[$1->name]<<"\n";
          $1->next = $3;
          $$ = $1;
        }
  ;

	Wid	:	VAR		{ 				}
		|	Wid '[' NUM ']'	{ }

		;
		


	
	assign_stmt:	var_expr '=' expr
        {
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
          newNode->value = $1->value + $3->value;
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
//           cout<<"before /\n";
          if($3->value == 0)
          {
            cout<<"ZeroDivisionError\n";
            exit(1);
          }
          newNode->value = (int)(($1->value)/($3->value));
//           cout<<newNode->value<<"\n";
//           cout<<"after /\n";
          newNode->name = NULL;
          newNode->lt = $1;
          newNode->rt = $3;
          newNode->next = NULL;
          $$ = newNode;
        }

		;
	
	var_expr:	VAR	
      {
        node *newNode = new node();
        newNode->Type = declaration;
        if(symbol_table.find($1->name) != symbol_table.end())
        {
          newNode->value = symbol_table[$1->name];
        }
        else newNode->value = UNDEFINED;
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

void printTree(vector<const node*> statement_list)
{
  vector<const node*>reversed_statement_list = statement_list;
//  reverse(reversed_statement_list.begin(), reversed_statement_list.end());
  int count = 0;
  for(auto it : reversed_statement_list)
  {
    if (it->Type == assign){ 
        cout<<"ASSIGN ";
        cout<<it->name<<" "<<it->value<<"\n";
    }
    else if(it->Type == print){ 
        cout<<"CALL print ";
        auto temp = it;

        while(temp != NULL)
        {
          cout<<temp->name<<" ";
          temp = temp->next;
        }
        cout<<"\n";
    }
    else if(it->Type == declaration) { 
        cout<<"DECLARATION ";
        auto temp1 = it;
        
        while(temp1 != NULL)
        {
          cout<<temp1->name<<" ";
          temp1 = temp1->next;
        }
        cout<<"\n";
    }

  }
//   cout<<statement_list.size()<<"\n";
}

int main(){
yyparse();
printTree(statement_list);
}

// ----------------------------------
/*
*/
