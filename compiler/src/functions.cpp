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

// node *createNode(type Type, std::variant<int, bool> value = UNDEFINED,
//                  const char *name = NULL, node *leftTree = NULL,
//                  node *rightTree = NULL, node *next = NULL, node *expr =
//                  NULL, node *ifTrue = NULL, node *ifFalse = NULL, node *init
//                  = NULL, node *condition = NULL, node *update = NULL, node
//                  *body = NULL) {
//
node *createNode(type Type, std::variant<int, bool> value = UNDEFINED,
                 const char *name = NULL, node *leftTree = NULL,
                 node *rightTree = NULL, node *next = NULL, node *expr = NULL,
                 node *ifTrue = NULL, node *ifFalse = NULL, node *init = NULL,
                 node *condition = NULL, node *update = NULL, node *body = NULL,
                 node *whilecond = NULL, node *whilestmts = NULL) {
  node *newNode = new node();
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

void printNode(const node *node) {
  if (node == NULL)
    return;
  const struct node *temp;
  switch (node->Type) {
  case declarationStmt:
    cout << "DECLARATION ";
    printNode(node->rt);
    break;
  case assignStmt:
    cout << "ASSIGN ";
    printNode(node->rt);
    break;
  case printStmt:
    cout << "PRINT ";
    printNode(node->rt);
    break;
  case conditionStmt:
    cout << "CONDITION ";
    printNode(node->rt);
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
    printNode(node->lt);
    printNode(node->rt);
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
    printNode(node->expr);
    printTree(node->ifTrue);
    break;
  case IfElse:
    cout << "IF ";
    printNode(node->expr);
    printTree(node->ifTrue);
    cout << "ELSE ";
    printTree(node->ifFalse);
    break;

  case For:
    cout << "FOR ";
    printNode(node->init);
    printNode(node->condition);
    printNode(node->update);
    printTree(node->body);
    break;
  case While:
    cout << "\nWHILE ";
    printNode(node->whilecond);
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
    printNode(node->lt);
    printNode(node->rt);
    break;
  case sub:
    cout << "SUB ";
    printNode(node->lt);
    printNode(node->rt);
    break;
  case mul:
    cout << "MUL ";
    printNode(node->lt);
    printNode(node->rt);
    break;
  case Div:
    cout << "DIV ";
    printNode(node->lt);
    printNode(node->rt);
    break;
  // relational operators
  case lt:
    cout << "LT ";
    printNode(node->lt);
    printNode(node->rt);
    break;
  case gt:
    cout << "GT ";
    printNode(node->lt);
    printNode(node->rt);
    break;
  case le:
    cout << "LE ";
    printNode(node->lt);
    printNode(node->rt);
    break;
  case ge:
    cout << "GE ";
    printNode(node->lt);
    printNode(node->rt);
    break;
  case ne:
    cout << "NE ";
    printNode(node->lt);
    printNode(node->rt);
    break;
  case eq:
    cout << "EQ ";
    printNode(node->lt);
    printNode(node->rt);
    break;

  // logical operators
  case Not:
    cout << "NOT ";
    printNode(node->lt);
    break;
  case And:
    cout << "AND ";
    printNode(node->lt);
    printNode(node->rt);
    break;
  case Or:
    cout << "OR ";
    printNode(node->lt);
    printNode(node->rt);
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
  temp = stmt_list;
  while (k < l) {
    // cout << "4\n";
    // cout << temp << "\n";
    k++;
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
