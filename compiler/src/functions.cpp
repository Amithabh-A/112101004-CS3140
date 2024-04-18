#include "../include/compiler.h"
#include <iostream>
#include <string>
#include <unordered_map>
#include <variant>

#define UNDEFINED INT_MAX

using namespace std;

/*
 *The class template std::variant represents a type-safe union. An instance of
 *std::variant at any given time either holds a value of one of its alternative
 *types, or in the case of error - no value (this state is hard to achieve, see
 *valueless_by_exception).
 * */

/*Now, errors can come wherever defns like `int value` is written. */

node *createNode(type Type, std::variant<int, bool> value = UNDEFINED,
                 const char *name = NULL, node *leftTree = NULL,
                 node *rightTree = NULL, node *next = NULL, node *expr = NULL,
                 node *ifTrue = NULL, node *ifFalse = NULL) {
  node *newNode = new node();
  cout << newNode << "\n";
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
  cout << Type << " statement created. \n";
  return newNode;
}

std::variant<int, bool> getSymbolValue(
    const string &name,
    unordered_map<string, std::variant<int, bool>>
        &symbol_table) { // just taking string reference, avoiding copy.
  if (symbol_table.find(name) != symbol_table.end()) {
    return symbol_table[name];
  } else {
    cout << "Error: Undefined symbol '" << name << "'." << endl;
    return UNDEFINED; // Consider how you want to handle undefined symbols
  }
}

void setSymbolValue(
    const string &name, std::variant<int, bool> value,
    unordered_map<string, std::variant<int, bool>> symbol_table) {
  symbol_table[name] = value;
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
    cout << node->name << " " << std::get<int>(node->value) << "\n";
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

    // Add cases for other types as needed
    //         case condition:
    //           cout<<"\nCONDITIONAL\nLogical Expression start\n";
    //           // Logical expression here
    //           printNode(node->expr);
    //           cout<<"Logical expression end\n If True, stmt_list here : \n";
    //           // if stmt_list
    //           printTree(node->ifTrue);
    //           cout<<"Over... \n Else stmt_list here: \n";
    //           // else stmt_list
    //           printTree(node->ifFalse);
    //           cout<<"CONDITIONAL block over\n\n";
  default:
    cout << "Unknown node type\n";
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

  cout << "\n";
}

// printTree :: stmt_list ->
void printTree(node *stmt_list) {
  int k = 0;
  node *temp = stmt_list;
  while (temp != NULL) {
    cout << "4\n";
    cout << temp << "\n";
    k++;
    cout << k << "   type : " << temp->Type;
    printNode(temp);
    temp = temp->next;
  }
  free(temp);
}

// void printWholeTree(node* node){
//   if(node == NULL){
//     cout<<"null node! \n";
//     return;
//   }
//   cout<<"Type : ";
//   // <<node->Type<<"\n";
//   switch(node->Type) {
//     case assign:
//       cout<<"assign type\n";
//     case print:
//       cout<<"print type\n";
//     case declaration:
//       cout<<"declaration type\n";
//     default:
//       cout<<"error\n";
//   }
//   cout<<"left \n";
//   printWholeTree(node->lt);
//   cout<<"left end\nright \n";
//   printWholeTree(node->rt);
//   cout<<"rightend\nnext statement \n";
//   printWholeTree(node->next);
//   cout<<"nextStatementEnd\n";
// }
//

int getIntValue(std::variant<int, bool> value) { return std::get<int>(value); }

bool getBoolValue(std::variant<int, bool> value) {
  return std::get<bool>(value);
}
