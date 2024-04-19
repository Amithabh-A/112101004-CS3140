#include <variant>

typedef enum type {
  assign,      // 0
  print,       // 1
  declaration, // 2
  If,          // 3
  IfElse,      // 4
  For,         // 5

  assignStmt,      // 6
  printStmt,       // 7
  declarationStmt, // 8
  conditionStmt,   // 9

  var, // 10
  add, // 11
  sub, // 12
  mul, // 13
  Div, // 14

  constant, // 15

  eq, // 16
  le, // 17
  ge, // 18
  lt, // 19
  gt, // 20
  ne, // 21

  And, // 22
  Or,  // 23
  Not, // 24

  Int,  // 25
  Bool, // 26

  // for statement
  initialisation, // 27
  condition,      // 28
  update,         // 29

  Array,       // 30
  assignArray, // 31
  assignVar,   // 32

  While, // 33

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

  // while stmt
  node *whilecond;
  node *whilestmts;

  node() {}
} node;
