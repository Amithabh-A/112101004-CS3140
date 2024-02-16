// header file for compiler

typedef enum {
  identifiers,
  operators,
  constants
}nodeType;

typedef operatorTypes{
  BEG, 
  END,
  T_INT,
  T_BOOL,
  blah
};

typedef struct{
  int id;
  char *name;
  node *val;
} symbolTable;






typedef struct{
  nodeType type;

  union{
    int constant;
    char *name;

  }

}node
