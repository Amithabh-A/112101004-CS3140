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

node* createVarNode(char* s)
{
  node* varNode = (node*)malloc(sizeof(node));
  varNode -> Type = assign;
  varNode -> name = s;
  varNode -> lt = NULL;
  varNode -> rt = NULL;
  varNode -> next = NULL;
  return varNode;
}
