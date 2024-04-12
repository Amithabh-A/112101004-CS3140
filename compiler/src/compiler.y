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
node *globalStatementList;
vector<const node*>statement_list; 

void printTree(node *stmt_list);
void printWholeTree(node* stmt_list);

node* createNode(type Type, int value = UNDEFINED, const char* name = NULL, node* leftTree = NULL, node* rightTree = NULL, node* next = NULL, node* expr = NULL, node* ifTrue = NULL, node* ifFalse = NULL) {
    node *newNode = new node();
    cout<<newNode<<"\n";
    newNode->Type = Type;
    newNode->value = value;

    // might be a bug. 
    // This is a hack. Need a refactor in function. 
    // if(newNode->value != UNDEFINED && newNode->Type == declaration) {
    //   newNode->Type = assign;
    // }

    newNode->name = name ? strdup(name) : NULL; // strdup - str dup - string duplicate fn in c. Ensure deep copy of name
    // NOTE : NULL is used with pointer data types only. 
    // If value is not being assigned, we will just assign it with UNDEFINED. 
    newNode->lt = leftTree;
    newNode->rt = rightTree;
    newNode->next = next;
    newNode->expr = expr;
    newNode->ifTrue = ifTrue;
    newNode->ifFalse = ifFalse;
    cout<<Type<<" statement created. \n";
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
    if (node == NULL) return;
    const struct node* temp;
    switch (node->Type) {
        case declarationStmt:
            cout<<"DECLARATION ";
            printNode(node->rt);
            break;
        case assignStmt:
            cout<<"ASSIGN ";
            printNode(node->rt);
            break;
        case printStmt:
            cout<<"PRINT ";
            printNode(node->rt);
            break;


        case declaration: {
            temp = node;
            while (temp != NULL) {
                cout << temp->name << " ";
                temp = temp->rt;
            }
            cout << "\n";
            break;


        case assign:
            cout <<node->name << " " << node->value << "\n"; 
            break;


        case print: {
            temp = node;
            while (temp != NULL) {
                cout << temp->name << " ";
                temp = temp->rt;
            }
            cout << "\n";
            break;
        }



        // Add cases for other types as needed
//         case condition:
//           cout<<"\nCONDITIONAL\nLogical Expression start\n";
//           // Logical expression here
//           printNode(node->expr);
//           cout<<"Logical expression end\n If True, stmt_list here : \n";
//           // if stmt_list
//           printTree(node->ifTrue); 
//           cout<<"Over... \n Else stmt_list here: \n";
//           // else stmt_list
//           printTree(node->ifFalse); 
//           cout<<"CONDITIONAL block over\n\n";
        }
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
%type<Node> Gdecl_sec
%type<Node> Prog
%type<Node> Gdecl_list
%type<Node> Gdecl


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
    // currently only integer node. 
    $$ = createNode(declarationStmt, UNDEFINED, NULL, NULL, $2);
  }
		;
		
	ret_type:	T_INT		{ }
    | T_BOOL { }
		;
		
	Glist 	:	Gid
             {
                $$ = createNode(declaration, UNDEFINED, $1->name);
                cout<<"Am I in declaration ? \n";
             }
		|	Gid ',' Glist 
      {
                $$ = createNode(declaration, UNDEFINED, $1->name, NULL, $3);
                cout<<"Am I in declaration ? \n";
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
          {		
            $1->next = $2;
            $$ = $1;
            // statement_list.push_back($1);
          }
		//|	error ';' 	//	{ cout<<"error end \n"; }
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
            cout<<"cond_stmt end\n";
            $$ = $1;
          }
		|	func_stmt ';'		// { cout<<"func_stmt end\n";}
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
          $$ = createNode(print, getSymbolValue($1->name), $1->name);
        }
        
  | Wid ',' Wlist
        {
          // $1->value = getSymbolValue($1->name);
          // cout<<getSymbolValue($1->name)<<"\n";
          $$ = createNode(print, getSymbolValue($1->name), $1->name, NULL, $3);
        }
  ;

	Wid	:	VAR		{ 				}
		|	Wid '[' NUM ']'	{ }

		;
		


	
	assign_stmt:	var_expr '=' expr
        {
          setSymbolValue($1->name, $3->value);
          $$ = createNode(assign, $3->value, $1->name, $1, $3);
          // cout<<$$<<" This is the address of node of assign stmt. \n";
          // cout<<"An assign node creation\n";
        }
		;

	cond_stmt:	IF expr '{'stmt_list'}'
        {  
          // $$ = createNode(condition, UNDEFINED, NULL, NULL, NULL, expr = $2, ifTrue = $4);
        }
		|	IF expr '{'stmt_list'}' ELSE '{'stmt_list'}' 
        { 						
          // $$ = createNode(condition, expr = $2, ifTrue = $4, ifFalse = $8);
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
          $$ = createNode(constant, $1->value);
      }
		|	'-' NUM	%prec UMINUS
      { 
          $$ = createNode(constant, (-1)*$2->value);
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
        //   $$ = createNode(lt, truthVal = $1->value < $3->value, leftTree = $1, rightTree = $3);
        }
		|	expr '>' expr		
        { 						
        //   $$ = createNode(gt, truthVal = $1->value > $3->value, leftTree = $1, rightTree = $3);
        }
		|	expr GREATERTHANOREQUAL expr			
        { 						
        //   $$ = createNode(ge, truthVal = $1->value >= $3->value, leftTree = $1, rightTree = $3);
        }
		|	expr LESSTHANOREQUAL expr	
        { 						
        //   $$ = createNode(le, truthVal = $1->value <= $3->value, leftTree = $1, rightTree = $3);
        }
		|	expr NOTEQUAL expr		
        { 						
        //   $$ = createNode(ne, truthVal = $1->value != $3->value, leftTree = $1, rightTree = $3);
        }
		|	expr EQUALEQUAL expr	
        { 					
        //   $$ = createNode(eq, truthVal = $1->value == $3->value, leftTree = $1, rightTree = $3);
        }
		|	LOGICAL_NOT expr	
        { 					
        //   $$ = createNode(Not, truthVal = !$2->value, rightTree = $2);
        }
		|	expr LOGICAL_AND expr	
        { 					
        //   $$ = createNode(And, truthVal = $1->value && $3->value, leftTree = $1, rightTree = $3);
        }
		|	expr LOGICAL_OR expr	
        { 					
        //   $$ = createNode(Or, truthVal = $1->value || $3->value, leftTree = $1, rightTree = $3);
        }

		;
	
	var_expr:	VAR	
      {
        $$ = createNode(declaration, UNDEFINED, $1->name);
      }
		|	var_expr '[' expr ']'	{                                                 }
		;
%%
void yyerror ( char  *s) {
   fprintf (stderr, "%s\n", s);
 }

// printTree :: stmt_list -> 
void printTree(node *stmt_list)
{
  int k = 0;
  node *temp = stmt_list;
  while(temp != NULL) {
    cout<<"4\n";
    cout<<temp<<"\n";
    k++;
    cout<<k<<"   type : "<<temp->Type;
    printNode(temp);
    temp = temp->next;
  }
  free(temp);
}

// void printWholeTree(node* node){
//   if(node == NULL){
//     cout<<"null node! \n";
//     return;
//   }
//   cout<<"Type : ";
//   // <<node->Type<<"\n";
//   switch(node->Type) {
//     case assign:
//       cout<<"assign type\n";
//     case print:
//       cout<<"print type\n";
//     case declaration:
//       cout<<"declaration type\n";
//     default:
//       cout<<"error\n";
//   }
//   cout<<"left \n";
//   printWholeTree(node->lt);
//   cout<<"left end\nright \n";
//   printWholeTree(node->rt);
//   cout<<"rightend\nnext statement \n";
//   printWholeTree(node->next); 
//   cout<<"nextStatementEnd\n";
// }
// 

void nodeImage(node* node){
    if(node == NULL){
        cout<<"nullvalue\n";
        return;
    }
    cout<<"NODE ID : "<<node<<"\n";

    cout<<"\n";
    cout<<"Type : "<<node->Type<<"\nvalue: "<<node->value;

    
    if(node->name == NULL){
        cout<<"name: NULL\n";
    } else {
      cout<<"\nname: "<< node->name<<"\n";
    }


    if(node->lt == NULL){
        cout<<"lt: NULL\n";
    } else {
        cout<<"\nLeftTree : \n";
        nodeImage(node->lt);
    }

    if(node->rt == NULL){
        cout<<"rt: NULL\n";
    } else {
        cout<<"\nRightTree : \n";
        nodeImage(node->rt);
    }

    if(node->next == NULL){
        cout<<"next: NULL\n";
    } else {
        cout<<"\nNext : \n";
        nodeImage(node->next);
    }

    cout<<"\n";
}

int main(){
extern int yydebug;
// yydebug = 1;
yyparse();
cout<<"Size of statement list : "<<statement_list.size()<<"\n";
cout<<"\n\n\nprintTree\n";
printTree(globalStatementList);
cout<<"\n\nInfix Traversal\n";
if(globalStatementList == NULL)cout<<"haha\n root is null\n";
nodeImage(globalStatementList);
}
