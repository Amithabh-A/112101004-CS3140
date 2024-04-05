using namespace std;

typedef enum type{
  assign, 
  print,
  declaration,
  condition,

  add, 
  sub, 
  mul, 
  Div,

  constant,

  eq,
  le,
  ge,
  lt,
  gt,
  ne,

  and,
  or,
  not

}type;

typedef struct node{
  type Type;
  int value;
  char* name; 
  node *lt;
  node *rt;
  node *next;
  
  
  node *expr;
  node *ifTrue;
  node *ifFalse;

  node(){
  }
}node;
