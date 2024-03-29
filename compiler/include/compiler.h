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

  constant
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
//    *ifTrue = NULL;
//    *ifFalse= NULL;
  }
}node;

