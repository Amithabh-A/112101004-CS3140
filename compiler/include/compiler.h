#include <variant>

typedef enum type {
  assign,
  print,
  declaration,
  condition,
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
  Bool

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

  node() {}
} node;
