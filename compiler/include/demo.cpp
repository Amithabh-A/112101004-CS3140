#define SYM_N 20000
#define VAR_N 100

typedef enum { constant, operator, id } nodeType;
typedef enum {
BEG, END, T_INT, T_BOOL, READ, WRITE, DECL, ENDDECL, VAR, NUM, IF, THEN, ELSE, ENDIF,
LOGICAL_AND, LOGICAL_NOT, LOGICAL_OR,
EQUALEQUAL, LESSTHANOREQUAL, GREATERTHANOREQUAL, NOTEQUAL,
WHILE, DO, ENDWHILE, FOR,
T, F, 
MAIN, RETURN
}operations;

class OprNode{
  public:
    operations opr;
    Node op1;
    Node op2;
}

class symbolTable{
  public:
    int index;
    string name;
    int value; 
}

class Node{
  public:
    nodeType type;
    int constVal;
    OprNode oNode;
    string idName;

    // get constant node from an integer
    void constNode(int constVal){
      type = constant;
      constVal = constVal;
    }


    // get an operator node when two operands and an operator is given. 
    void oprNode(char opr, Node a, Node b){
      Node operatorNode;
      operatorNode.type = operator;
      oNode.opr = opr;
      oNode.op1 = a;
      oNode.op2 = b;
    }

    // get an identifier node with given string as name. 
    void idNode(string s){
      type = id;
      idName = s;
    }
}

int evaluateNode(Node node)
{
  if(node.type == constant)
    return node.constVal;
  else if(node.type == operator)
  {
    // Now the operators are +, -, *, /
    char oper = node.oNode.opr;
    if(oper == ADD)
      return (evaluateNode(node.oNode.op1)) + (node.oNode.op2);
    else if(oper == SUB)
      return (evaluateNode(node.oNode.op1)) - (node.oNode.op2);
    if(oper == MUL)
      return (evaluateNode(node.oNode.op1)) * (node.oNode.op2);
    if(oper == DIV)
      return (evaluateNode(node.oNode.op1)) / (node.oNode.op2);
  }
}

int evaluateNode(node * inNode);
int printNode(node * inNode);

extern symtab_entry* symtab;

void create_symtab();
int update_var(int index, int value);
int declare_var(char* name); 
int fetch_var(char* name);
int varIndex(char* name);

void throwError(char *s);
