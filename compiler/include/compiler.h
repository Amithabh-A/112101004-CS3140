using namespace std;

typedef enum type{
  add, 
  sub, 
  mul, 
  Div,

  assign, 
  print,
  declaration,

  constant
}type;

typedef struct node{
  type Type;
  int value;
  char* name; 
  node *lt;
  node *rt;
  node *next;

  node(){
    
  }
}node;
