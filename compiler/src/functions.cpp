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
    // cout << "left type: " << node->lt->Type << " right type: " <<
    // node->rt->Type
    //      << "\n";
    printNode(node->lt, param);
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
    // cout << "before going to var or array\n";
    // cout << "type of left tree: " << node->lt->Type << "\n";
    printNode(node->lt, param); // var or array
    // cout << "after going to var or array\n";
    printNode(node->rt, param);
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
  case assignArray:
    cout << "ARRAY " << node->name << "[" << getIntValue(node->value) << "] ";
    // printNode(node->rt, param);
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
    cout << "VAR " << node->name << "\n";
    break;
  case var:
    cout << "VAR " << node->name << " ";
    break;
  case Int:
    cout << "INT ";
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
  case Array:
    cout << "ARRAY " << node->name << " " << getIntValue(node->value) << "\n";
    // cout << "left type: " << node->lt->Type << "\n";
    // cout << "right type: " << node->rt->Type << "\n";
    // printNode(node->lt, param);
    // printNode(node->rt, param);
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
  // cout << "NODE ID : " << node << "\n";

  cout << "\n";
  // cout << "Type : " << node->Type << "\nvalue: " <<
  // std::get<int>(node->value);

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
    // cout << temp << " ";
    // NOTE: DEBUG
    // cout << k << "   type : " << temp->Type << " ";
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

bool is_statement(type value) {
  if (value == declarationStmt || value == assignStmt || value == printStmt ||
      value == conditionStmt) {
    return true;
  }
  return false;
  cout << "Unknown node type" << value << "\n";
}
