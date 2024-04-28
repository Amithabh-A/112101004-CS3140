#include "../include/compiler.h"
#include <iostream>
#include <map>
#include <string>
#include <unordered_map>
#include <variant>
#include <vector>

#define UNDEFINED INT_MAX
#define NOT_INITIALIZED INT_MIN

using namespace std;
void printTree(node *stmt_list);
bool is_statement(type value);

node *createNode(type Type, std::variant<int, bool> value = UNDEFINED,
                 const char *name = NULL, node *leftTree = NULL,
                 node *rightTree = NULL, node *next = NULL, node *expr = NULL,
                 node *ifTrue = NULL, node *ifFalse = NULL, node *init = NULL,
                 node *condition = NULL, node *update = NULL, node *body = NULL,
                 node *returnStmt = NULL) {
  node *newNode = new node();
  newNode->Type = Type;
  newNode->value = value;
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
  if (node == NULL) {
    cout << "NODE IS NULL\n";
    return;
  }

  /*
   * \n will be handled later.
   * */
  switch (node->Type) {
  case Prog:
    printNode(node->lt, param);
    printNode(node->rt, param);
    break;
  case declaration_stmtlist:
    // declaration statement list is a statement list .
    // it should be managed by printTree.
    printTree(node->next);
    break;
  case declarationStmt:
    cout << "DECLARATION ";
    printNode(node->lt, param);
    cout << " ";
    printNode(node->rt, param);
    cout << "\n";
    break;
  case Int:
    cout << "INT ";
    break;
  case Bool:
    cout << "BOOL ";
    break;
  case declVar:
    cout << "VAR " << node->name << " ";
    break;
  case declArray:
    cout << "ARRAY " << node->name << "[" << getIntValue(node->value) << "] ";
    break;
  case Main:
    printTree(node->body);
    cout << "\n";
    printNode(node->returnStmt, param);
    break;
  case assignStmt:
    cout << "ASSIGN ";
    printNode(node->lt, param);
    cout << " ";
    printNode(node->expr, param);
    cout << "\n";
    break;
  case incStmt:
    cout << "INCREMENT ";
    printNode(node->rt, param);
    cout << "\n";
    break;
  case nullStmt:
    cout << "NULL ";
    break;
  case var:
    cout << "VAR " << node->name << " ";
    break;
  case Array:
    cout << "ARRAY " << node->name << "[" << getIntValue(node->value) << "] ";
    break;
  case writeStmt:
    cout << "PRINT ";
    printNode(node->rt, param);
    cout << "\n";
    break;
  case writeVar:
    cout << "VAR " << node->name << " ";
    break;
  case writeArr:
    cout << "ARRAY " << node->name << "[" << getIntValue(node->value) << "] ";
    break;
  case ifStmt:
    cout << "IF ";
    printNode(node->expr, param);
    cout << "\n";
    printTree(node->ifTrue);
    cout << "ENDIF\n";
    break;
  case ifElseStmt:
    cout << "IF ";
    printNode(node->expr, param);
    cout << "\n";
    printTree(node->ifTrue);
    cout << "ELSE\n";
    printTree(node->ifFalse);
    cout << "ENDIF\n";
    break;
  case forStmt:
    cout << "FOR \n";
    cout << "INIT ";
    printNode(node->init, param);
    cout << "CONDITION ";
    printNode(node->condition, param);
    cout << "UPDATE ";
    printNode(node->update, param);
    cout << "\n";
    printTree(node->body);
    cout << "ENDFOR\n";
    break;
  case constant:
    cout << "CONSTANT " << getIntValue(node->value) << " ";
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
  case Not:
    cout << "NOT ";
    printNode(node->rt, param);
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
  case returnStmt:
    cout << "RETURN ";
    printNode(node->expr, param);
    cout << "\n";
    break;
  case breakStmt:
    cout << "BREAK ";
    cout << "\n";
    break;
  default:
    cout << "Unknown node type" << node->Type << "\n";
  }

  // if (node == NULL)
  //   return;
  // const struct node *temp;
  // switch (node->Type) {
  // case declarationStmt:
  //   cout << "DECLARATION ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   cout << "\n";
  //   break;
  // case assignStmt:
  //   cout << "ASSIGN ";
  //   printNode(node->rt, param);
  //   break;
  // case printStmt:
  //   cout << "PRINT ";
  //   printNode(node->rt, param);
  //   break;
  // case conditionStmt:
  //   cout << "\nCONDITION ";
  //   printNode(node->rt, param);
  //   break;
  // case breakStmt:
  //   cout << "\nBREAK ";
  //   break;
  // case declaration: {
  //   printNode(node->lt, param); // var or array
  //   printNode(node->rt, param);
  //   break;
  // }
  // case assign:
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case assignArray:
  //   cout << "ARRAY " << node->name << "[" << getIntValue(node->value) << "]
  //   "; break;

  // case print: {
  //   temp = node;
  //   while (temp != NULL) {
  //     cout << temp->name << " ";
  //     temp = temp->rt;
  //   }
  //   cout << "\n";
  //   break;
  // };

  // case If:
  //   cout << "\nIF ";
  //   printNode(node->expr, param);
  //   cout << "\n";
  //   printTree(node->ifTrue);
  //   cout << "\nENDIF\n";
  //   break;
  // case IfElse:
  //   cout << "\nIF ";
  //   printNode(node->expr, param);
  //   cout << "\n";
  //   printTree(node->ifTrue);
  //   cout << "\nELSE\n";
  //   printTree(node->ifFalse);
  //   cout << "\nENDIF\n";
  //   break;

  // case For:
  //   cout << "\nFOR ";
  //   printNode(node->init, param);
  //   printNode(node->condition, param);
  //   printNode(node->update, param);
  //   cout << "\n";
  //   printTree(node->body);
  //   cout << "\nENDFOR\n";
  //   break;
  // case While:
  //   cout << "\nWHILE\t";
  //   printNode(node->whilecond, param + 2);
  //   printTree(node->whilestmts);
  //   cout << "\nENDWHILE\n";
  //   break;
  // case assignVar:
  //   cout << "VAR " << node->name << " ";
  //   break;
  // case var:
  //   cout << "VAR " << node->name << " ";
  //   break;
  // case Int:
  //   cout << "INT ";
  //   break;
  // case constant:
  //   cout << "CONSTANT " << std::get<int>(node->value) << " ";
  //   break;
  // case add:
  //   cout << "ADD ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case sub:
  //   cout << "SUB ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case mul:
  //   cout << "MUL ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case Div:
  //   cout << "DIV ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // // relational operators
  // case lt:
  //   cout << "LT ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case gt:
  //   cout << "GT ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case le:
  //   cout << "LE ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case ge:
  //   cout << "GE ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case ne:
  //   cout << "NE ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case eq:
  //   cout << "EQ ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // // logical operators
  // case Not:
  //   cout << "NOT ";
  //   printNode(node->lt, param);
  //   break;
  // case And:
  //   cout << "AND ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case Or:
  //   cout << "OR ";
  //   printNode(node->lt, param);
  //   printNode(node->rt, param);
  //   break;
  // case Array:
  //   cout << "ARRAY " << node->name << " " << getIntValue(node->value) <<
  //   "\n"; break;
  // case error:
  //   break;
  // case returnStmt:
  //   cout << "RETURN ";
  //   printNode(node->rt, param);
  //   break;
  // case null:
  //   cout << "NULL ";
  //   break;
  // default:
  //   cout << "Unknown node type" << node->Type << "\n";
  // }
}

void nodeImage(node *node) {
  if (node == NULL) {
    cout << "nullvalue\n";
    return;
  }
  cout << "\n";
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
  if (value == declarationStmt || value == assignStmt || value == writeStmt ||
      value == ifStmt || value == ifElseStmt || value == forStmt ||
      value == nullStmt || value == returnStmt || value == breakStmt) {
    return true;
  }
  return false;
  cout << "Unknown node type" << value << "\n";
}

void set_array(string name, pair<int *, int> p,
               map<string, pair<int *, int>> array_table) {
  array_table[name] = p;
  for (int i = 0; i < p.second; i++) {
    p.first[i] = NOT_INITIALIZED;
  }
}

void set_array_element(string name, int index, int value,
                       map<string, pair<int *, int>> array_table) {
  if (array_table.find(name) == array_table.end()) {
    cout << "Error: array " << name << " not found" << endl;
    return;
  }
  pair<int *, int> p = array_table[name];
  int *array = p.first;
  int size = p.second;
  if (index < 0 || index >= size) {
    cout << "Error: index " << index << " out of bounds" << endl;
    return;
  }
  array_table[name].first[index] = value;
}

int *get_array(string name, map<string, pair<int *, int>> array_table) {
  if (array_table.find(name) == array_table.end()) {
    cout << "Error: array " << name << " not found" << endl;
    return NULL;
  }
  return array_table[name].first;
}

int get_array_element(string name, int index,
                      map<string, pair<int *, int>> array_table) {
  if (array_table.find(name) == array_table.end()) {
    cout << "Error: array " << name << " not found" << endl;
    return NOT_INITIALIZED;
  }
  pair<int *, int> p = array_table[name];
  int *array = p.first;
  int size = p.second;
  if (index < 0 || index >= size) {
    cout << "Error: index " << index << " out of bounds" << endl;
    return UNDEFINED;
  }
  if (array[index] == NOT_INITIALIZED) {
    cout << "Error: array element at index " << index << " not initialized"
         << endl;
    return NOT_INITIALIZED;
  }
  return array_table[name].first[index];
}

// int main() {
//   int a[5];
//   pair<int *, int> p = make_pair(a, 5);
//   set_array("a", p);
//   cout << "hehe? \n";
//   cout << get_array_element("a", 2) << endl;
//   cout << "hehe !!!\n";
//   set_array_element("a", 2, 10);
//   cout << get_array_element("a", 2) << endl;
//   return 0;
// }
