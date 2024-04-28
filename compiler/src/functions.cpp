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
                 node *returnStmt = NULL, int index = UNDEFINED, node *Var) {
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
  newNode->returnStmt = returnStmt;
  newNode->index = index;
  newNode->Var = Var;
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
    // cout << "<Prog>\n";
    printNode(node->lt, param);
    printNode(node->rt, param);
    // cout << "</Prog>\n";
    break;
  case declaration_stmtlist:
    // declaration statement list is a statement list .
    // it should be managed by printTree.
    // cout << "<declaration_stmtlist>\n";
    printTree(node->next);
    // cout << "</declaration_stmtlist>\n";
    break;
  case declarationStmt:
    // cout << "<declarationStmt>\n";
    cout << "DECLARATION ";
    printNode(node->lt, param);
    printNode(node->rt, param);
    cout << "\n";
    // cout << "</declarationStmt>\n";
    break;
  case Int:
    // cout << "<Int>\n";
    cout << "INT ";
    // cout << "</Int>\n";
    break;
  case Bool:
    // cout << "<Bool>\n";
    cout << "BOOL ";
    // cout << "</Bool>\n";
    break;
  case declVar:
    // cout << "<declVar>\n";
    cout << "VAR " << node->name << " ";
    if (node->next != NULL) {
      cout << ", ";
      printNode(node->next, param);
    }
    // cout << "</declVar>\n";
    break;
  case declArray:
    // cout << "<declArray>\n";
    cout << "ARRAY " << node->name << "[" << getIntValue(node->value) << "] ";
    // cout << "</declArray>\n";
    break;
  case Main:
    // cout << "<Main>\n";
    printTree(node->body);
    cout << "\n";
    printNode(node->returnStmt, param);
    // cout << "</Main>\n";
    break;
  case assignStmt:
    // cout << "<assignStmt>\n";
    cout << "ASSIGN ";
    printNode(node->lt, param);
    cout << " ";
    printNode(node->expr, param);
    cout << "\n";
    // cout << "</assignStmt>\n";
    break;
  case incStmt:
    // cout << "<incStmt>\n";
    cout << "INCREMENT ";
    printNode(node->rt, param);
    cout << "\n";
    // cout << "</incStmt>\n";
    break;
  case nullStmt:
    // cout << "<nullStmt>\n";
    cout << "NULL ";
    // cout << "</nullStmt>\n";
    break;
  case var:
    // cout << "<var>\n";
    cout << "VAR " << node->name << " ";
    // cout << "</var>\n";
    break;
  case specialArr:
    // cout << "<specialArr>\n";
    cout << "ARRAY " << node->name << "[";
    printNode(node->Var, param);
    cout << "] ";
    // cout << "</specialArr>\n";
    break;
  case Array:
    // cout << "<Array>\n";
    cout << "ARRAY " << node->name << "[" << node->index << "]";
    // cout << "</Array>\n";
    break;
  case writeStmt:
    // cout << "<writeStmt>\n";
    cout << "PRINT ";
    printNode(node->rt, param);
    cout << "\n";
    // cout << "</writeStmt>\n";
    break;
  case writeVar:
    // cout << "<writeVar>\n";
    cout << "VAR " << node->name << " ";
    // cout << "</writeVar>\n";
    break;
  case writeArr:
    // cout << "<writeArr>\n";
    cout << "ARRAY " << node->name << "[" << getIntValue(node->value) << "] ";
    // cout << "</writeArr>\n";
    break;
  case ifStmt:
    // cout << "<ifStmt>\n";
    cout << "IF ";
    printNode(node->expr, param);
    cout << "\n";
    printTree(node->ifTrue);
    cout << "ENDIF\n";
    // cout << "</ifStmt>\n";
    break;
  case ifElseStmt:
    // cout << "<ifElseStmt>\n";
    cout << "IF ";
    printNode(node->expr, param);
    cout << "\n";
    printTree(node->ifTrue);
    cout << "ELSE\n";
    printTree(node->ifFalse);
    cout << "ENDIF\n";
    // cout << "</ifElseStmt>\n";
    break;
  case forStmt:
    // cout << "<forStmt>\n";
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
    // cout << "</forStmt>\n";
    break;
  case constant:
    // cout << "<constant>\n";
    cout << "CONSTANT " << getIntValue(node->value) << " ";
    // cout << "</constant>\n";
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
    // cout << "<returnStmt>\n";
    cout << "RETURN ";
    printNode(node->expr, param);
    cout << "\n";
    // cout << "</returnStmt>\n";
    break;
  case breakStmt:
    // cout << "<breakStmt>\n";
    cout << "BREAK ";
    cout << "\n";
    // cout << "</breakStmt>\n";
    break;
  default:
    cout << "Unknown node type" << node->Type << "\n";
    break;
  }
}

void NodeImage(node *node) {
  cout << "\nNodeImage\n";
  if (node == NULL) {
    cout << "nullvalue\n";
    return;
  }
  cout << "type: " << node->Type << "\n";
  cout << "value: " << getIntValue(node->value) << "\n";

  if (node->name != NULL) {
    cout << "name: " << node->name << "\n";
  } else {
    cout << "name: NULL\n";
  }

  if (node->lt != NULL) {
    cout << "lt : \n";
    NodeImage(node->lt);
  } else {
    cout << "lt: NULL\n";
  }

  if (node->rt != NULL) {
    cout << "rt : \n";
    NodeImage(node->rt);
  } else {
    cout << "rt: NULL\n";
  }

  if (node->next != NULL) {
    cout << "next : \n";
    NodeImage(node->next);
  } else {
    cout << "next: NULL\n";
  }

  if (node->expr != NULL) {
    cout << "expr : \n";
    NodeImage(node->expr);
  } else {
    cout << "expr: NULL\n";
  }

  if (node->ifTrue != NULL) {
    cout << "ifTrue : \n";
    NodeImage(node->ifTrue);
  } else {
    cout << "ifTrue: NULL\n";
  }

  if (node->ifFalse != NULL) {
    cout << "ifFalse : \n";
    NodeImage(node->ifFalse);
  } else {
    cout << "ifFalse: NULL\n";
  }

  if (node->init != NULL) {
    cout << "init : \n";
    NodeImage(node->init);
  } else {
    cout << "init: NULL\n";
  }

  if (node->condition != NULL) {
    cout << "condition : \n";
    NodeImage(node->condition);
  } else {
    cout << "condition: NULL\n";
  }

  if (node->update != NULL) {
    cout << "update : \n";
    NodeImage(node->update);
  } else {
    cout << "update: NULL\n";
  }

  if (node->body != NULL) {
    cout << "body : \n";
    NodeImage(node->body);
  } else {
    cout << "body: NULL\n";
  }

  if (node->returnStmt != NULL) {
    cout << "returnStmt : \n";
    NodeImage(node->returnStmt);
  } else {
    cout << "returnStmt: NULL\n";
  }
  cout << "endNodeImage\n";
}

// void printTree(node *stmt_list) {
//   int l = 0;
//   int k = 0;
//   node *temp = stmt_list;
//   while (temp != NULL) {
//     l++;
//     temp = temp->next;
//   }
//   temp = stmt_list;
//   while (k < l) {
//     k++;
//     // NOTE: DEBUG
//     // cout << k << "   type : " << temp->Type << " ";
//     if (temp->Type != assign && temp->Type != eq)
//       printNode(temp);
//     temp = temp->next;
//     cout << "\n";
//   }
//   free(temp);
// }

void printTree(node *stmt_list) {
  node *temp = stmt_list;
  while (temp != NULL) {
    // cout << "type : " << temp->Type << " ";
    printNode(temp);
    temp = temp->next;
  }
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
  if (value == declarationStmt || value == assignStmt || value == incStmt ||
      value == writeStmt || value == ifStmt || value == ifElseStmt ||
      value == forStmt || value == nullStmt || value == returnStmt ||
      value == breakStmt) {
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
