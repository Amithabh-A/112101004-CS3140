#include "../include/compiler.h"
#include <iostream>
#include <string>
#include <unordered_map>
#include <variant>

#define UNDEFINED (INT_MAX / 2)

using namespace std;

/*
 *The class template std::variant represents a type-safe union. An instance of
 *std::variant at any given time either holds a value of one of its alternative
 *types, or in the case of error - no value (this state is hard to achieve, see
 *valueless_by_exception).
 * */

/*Now, errors can come wherever defns like `int value` is written. */
void printTree(node *stmt_list);
// template <typename T> bool is_statement(T value);
bool is_statement(type value);

// node *createNode(type Type, std::variant<int, bool> value = UNDEFINED,
//                  const char *name = NULL, node *leftTree = NULL,
//                  node *rightTree = NULL, node *next = NULL, node *expr =
//                  NULL, node *ifTrue = NULL, node *ifFalse = NULL, node
//                  *init = NULL, node *condition = NULL, node *update = NULL,
//                  node *body = NULL) {
//
node *createNode(type Type, std::variant<int, bool> value = UNDEFINED,
                 const char *name = NULL, node *leftTree = NULL,
                 node *rightTree = NULL, node *next = NULL, node *expr = NULL,
                 node *ifTrue = NULL, node *ifFalse = NULL, node *init = NULL,
                 node *condition = NULL, node *update = NULL, node *body = NULL,
                 node *whilecond = NULL, node *whilestmts = NULL) {
  node *newNode = new node();
  cout << "newNode created " << newNode << "\n";
  // cout << newNode << "\n";
  newNode->Type = Type;
  newNode->value = value;

  // might be a bug.
  // This is a hack. Need a refactor in function.
  // if(newNode->value != UNDEFINED && newNode->Type == declaration) {
  //   newNode->Type = assign;
  // }

  newNode->name =
      name ? strdup(name) : NULL; // strdup - str dup - string duplicate fn in
                                  // c. Ensure deep copy of name
  // NOTE : NULL is used with pointer data types only.
  // If value is not being assigned, we will just assign it with UNDEFINED.
  newNode->lt = leftTree;
  newNode->rt = rightTree;
  newNode->next = next;
  newNode->expr = expr;
  newNode->ifTrue = ifTrue;
  newNode->ifFalse = ifFalse;
  newNode->init = init;
  newNode->condition = condition;
  newNode->update = update;
  newNode->body = body;
  newNode->whilecond = whilecond;
  newNode->whilestmts = whilestmts;
  cout << Type << " statement created. \n";
  return newNode;
}

std::variant<int, bool>
getSymbolValue(const string &name,
               unordered_map<string, std::variant<int, bool>> &symbol_table) {
  if (symbol_table.find(name) == symbol_table.end()) {
    cout << "error: " << name << " not declared\n";
    return UNDEFINED;
  }
  return symbol_table[name];
}

int getIntValue(std::variant<int, bool> value) { return std::get<int>(value); }

void setSymbolValue(
    const string &name, std::variant<int, bool> value,
    unordered_map<string, std::variant<int, bool>> symbol_table) {
  symbol_table[name] = value;
  int x = getIntValue(getSymbolValue(name, symbol_table));
  cout << "success: " << name << " = " << x << "\n";
}

void printNode(const node *node, int param = 0) {
  if (node == NULL)
    return;
  const struct node *temp;
  switch (node->Type) {
  case declarationStmt:
    cout << "DECLARATION ";
    printNode(node->rt, param);
    break;
  case assignStmt:
    cout << "ASSIGN ";
    printNode(node->rt, param);
    break;
  case printStmt:
    cout << "PRINT ";
    printNode(node->rt, param);
    break;
  case conditionStmt:
    cout << "CONDITION ";
    printNode(node->rt, param);
    break;

  case declaration: {
    temp = node;
    while (temp != NULL) {
      cout << temp->name << " ";
      temp = temp->rt;
    }
    cout << "\n";
    break;
  }
  case assign:
    // cout << node->name << " " << std::get<int>(node->value) << "\n";
    // cout << node->name << " " << getIntValue(node->value);
    // cout << node->name << " ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    // I might need to print node->lt
    // printNode(node->rt);
    break;

  case print: {
    temp = node;
    while (temp != NULL) {
      cout << temp->name << " ";
      temp = temp->rt;
    }
    cout << "\n";
    break;
  };

  case If:
    cout << "IF ";
    printNode(node->expr, param);
    printTree(node->ifTrue);
    break;
  case IfElse:
    cout << "IF ";
    printNode(node->expr, param);
    printTree(node->ifTrue);
    cout << "ELSE ";
    printTree(node->ifFalse);
    break;

  case For:
    cout << "FOR ";
    printNode(node->init, param);
    printNode(node->condition, param);
    printNode(node->update, param);
    printTree(node->body);
    break;
  case While:
    cout << "\nWHILE\t";
    printNode(node->whilecond, param + 2);
    printTree(node->whilestmts);
    cout << "\nENDWHILE\n";
    break;
  case assignVar:
    cout << "VAR " << node->name << " ";
    break;
  case constant:
    cout << "CONSTANT " << std::get<int>(node->value) << "\n";
    break;
  case add:
    cout << "ADD ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  case sub:
    cout << "SUB ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  case mul:
    cout << "MUL ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  case Div:
    cout << "DIV ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  // relational operators
  case lt:
    cout << "LT ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  case gt:
    cout << "GT ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  case le:
    cout << "LE ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  case ge:
    cout << "GE ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  case ne:
    cout << "NE ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  case eq:
    cout << "EQ ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;

  // logical operators
  case Not:
    cout << "NOT ";
    printNode(node->lt, param);
    break;
  case And:
    cout << "AND ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  case Or:
    cout << "OR ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  default:
    cout << "Unknown node type" << node->Type << "\n";
  }
}

void nodeImage(node *node) {
  /*
  gives idea of entire node tree
  */
  if (node == NULL) {
    cout << "nullvalue\n";
    return;
  }
  cout << "NODE ID : " << node << "\n";

  cout << "\n";
  cout << "Type : " << node->Type << "\nvalue: " << std::get<int>(node->value);

  if (node->name == NULL) {
    cout << "name: NULL\n";
  } else {
    cout << "\nname: " << node->name << "\n";
  }

  if (node->lt == NULL) {
    cout << "lt: NULL\n";
  } else {
    cout << "\nLeftTree : \n";
    nodeImage(node->lt);
  }

  if (node->rt == NULL) {
    cout << "rt: NULL\n";
  } else {
    cout << "\nRightTree : \n";
    nodeImage(node->rt);
  }

  if (node->next == NULL) {
    cout << "next: NULL\n";
  } else {
    cout << "\nNext : \n";
    nodeImage(node->next);
  }

  if (node->expr == NULL) {
    cout << "expr: NULL\n";
  } else {
    cout << "\nExpr : \n";
    nodeImage(node->expr);
  }

  if (node->ifTrue == NULL) {
    cout << "ifTrue: NULL\n";
  } else {
    cout << "\nifTrue : \n";
    nodeImage(node->ifTrue);
  }

  if (node->ifFalse == NULL) {
    cout << "ifFalse: NULL\n";
  } else {
    cout << "\nifFalse : \n";
    nodeImage(node->ifFalse);
  }

  if (node->init == NULL) {
    cout << "init: NULL\n";
  } else {
    cout << "\ninit : \n";
    nodeImage(node->init);
  }

  if (node->condition == NULL) {
    cout << "condition: NULL\n";
  } else {
    cout << "\ncondition : \n";
    nodeImage(node->condition);
  }

  if (node->update == NULL) {
    cout << "update: NULL\n";
  } else {
    cout << "\nupdate : \n";
    nodeImage(node->update);
  }
  cout << "\n";
}

// printTree :: stmt_list ->
void printTree(node *stmt_list) {
  int l = 0;
  int k = 0;
  node *temp = stmt_list;
  while (temp != NULL) {
    l++;
    temp = temp->next;
  }
  cout << l << "\n";
  temp = stmt_list;
  while (k < l) {
    // cout << "4\n";
    // cout << temp << "\n";
    k++;
    cout << temp << " ";
    // NOTE: DEBUG
    cout << k << "   type : " << temp->Type << " ";
    if (temp->Type != assign && temp->Type != eq)
      printNode(temp);
    temp = temp->next;
    cout << "\n";
  }
  free(temp);
}

bool getBoolValue(std::variant<int, bool> value) {
  return std::get<bool>(value);
}

void insertNext(node *stmt_list, node *stmt) {
  if (!is_statement(stmt->Type)) {
    cout << "error: not a statement\n";
    return;
  }
  node *temp = stmt_list;
  while (temp->next != NULL) {
    temp = temp->next;
  }
  temp->next = stmt;
  // success
  cout << "success: statement added\n";
}

// enums used :
//   assign,      // 0
//   print,       // 1
//   declaration, // 2
//   If,          // 3
//   IfElse,      // 4
//   For,         // 5
//   While, // 33
//
//   assignStmt,      // 6
//   printStmt,       // 7
//   declarationStmt, // 8
//   conditionStmt,   // 9
//
//   var, // 10
//   add, // 11
//   sub, // 12
//   mul, // 13
//   Div, // 14
//
//   constant, // 15
//   Float, // 34
//
//   eq, // 16
//   le, // 17
//   ge, // 18
//   lt, // 19
//   gt, // 20
//   ne, // 21
//
//   And, // 22
//   Or,  // 23
//   Not, // 24
//
//   Int,  // 25
//   Bool, // 26
//
//   // for statement
//   initialisation, // 27
//   condition,      // 28
//   update,         // 29
//
//   Array,       // 30
//   assignArray, // 31
//   assignVar,   // 32
//

// template <typename T> bool is_statement(T value) {
//   return std::is_same<T, type>::value &&
//          !std::is_same<T, decltype(assign)>::value &&
//          !std::is_same<T, decltype(print)>::value &&
//          !std::is_same<T, decltype(declaration)>::value &&
//          !std::is_same<T, decltype(If)>::value &&
//          !std::is_same<T, decltype(IfElse)>::value &&
//          !std::is_same<T, decltype(For)>::value &&
//          !std::is_same<T, decltype(While)>::value &&
//          // !std::is_same<T, decltype(assignStmt)>::value &&
//          // !std::is_same<T, decltype(printStmt)>::value &&
//          // !std::is_same<T, decltype(declarationStmt)>::value &&
//          // !std::is_same<T, decltype(conditionStmt)>::value &&
//          !std::is_same<T, decltype(var)>::value &&
//          !std::is_same<T, decltype(add)>::value &&
//          !std::is_same<T, decltype(sub)>::value &&
//          !std::is_same<T, decltype(mul)>::value &&
//
//          !std::is_same<T, decltype(Div)>::value &&
//          !std::is_same<T, decltype(constant)>::value &&
//          !std::is_same<T, decltype(Float)>::value &&
//          !std::is_same<T, decltype(eq)>::value &&
//          !std::is_same<T, decltype(le)>::value &&
//          !std::is_same<T, decltype(ge)>::value &&
//
//          !std::is_same<T, decltype(lt)>::value &&
//          !std::is_same<T, decltype(gt)>::value &&
//          !std::is_same<T, decltype(ne)>::value &&
//          !std::is_same<T, decltype(And)>::value &&
//          !std::is_same<T, decltype(Or)>::value &&
//          !std::is_same<T, decltype(Not)>::value &&
//          !std::is_same<T, decltype(Int)>::value &&
//          !std::is_same<T, decltype(Bool)>::value &&
//          !std::is_same<T, decltype(initialisation)>::value &&
//          !std::is_same<T, decltype(condition)>::value &&
//          !std::is_same<T, decltype(update)>::value &&
//          !std::is_same<T, decltype(Array)>::value &&
//          !std::is_same<T, decltype(assignArray)>::value &&
//          !std::is_same<T, decltype(assignVar)>::value;
// }

bool is_statement(type value) {
  if (value == declarationStmt || value == assignStmt || value == printStmt ||
      value == conditionStmt) {
    return true;
  }
  return false;
  cout << "Unknown node type" << value << "\n";
}
