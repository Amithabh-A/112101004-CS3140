typedef enum type {
  assign,
  print,
  declaration,
  condition,

  assignStmt,
  printStmt,
  declarationStmt,
  conditionStmt,

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

  And,
  Or,
  Not,

  Int,
  Bool

} type;

typedef struct node {
  type Type;
  int value;
  char *name;
  node *lt;
  node *rt;
  node *next;

  node *expr;
  node *ifTrue;
  node *ifFalse;

  node() {}
} node;
