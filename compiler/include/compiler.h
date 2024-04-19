#include <variant>

typedef enum type {
  assign,
  print,
  declaration,
  If,
  IfElse,
  For,

  assignStmt,
  printStmt,
  declarationStmt,
  conditionStmt,

  var,
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
  Bool,

  // for statement
  initialisation,
  condition,
  update,

} type;

typedef struct node {
  type Type;
  std::variant<int, bool> value;
  char *name;
  node *lt;
  node *rt;
  node *next;

  node *expr;
  node *ifTrue;
  node *ifFalse;

  // For stmt
  node *init;
  node *condition;
  node *update;
  node *body;

  node() {}
} node;
