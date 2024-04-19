#include "../include/compiler.h"
#include <iostream>
#include <string>
#include <type_traits>
#include <unordered_map>
#include <variant>

template <typename T> bool is_statement(T value) {
  return std::is_same<T, type>::value &&
         !std::is_same<T, decltype(assign)>::value &&
         !std::is_same<T, decltype(print)>::value &&
         !std::is_same<T, decltype(declaration)>::value &&
         !std::is_same<T, decltype(If)>::value &&
         !std::is_same<T, decltype(IfElse)>::value &&
         !std::is_same<T, decltype(For)>::value &&
         !std::is_same<T, decltype(While)>::value &&
         // !std::is_same<T, decltype(assignStmt)>::value &&
         // !std::is_same<T, decltype(printStmt)>::value &&
         // !std::is_same<T, decltype(declarationStmt)>::value &&
         // !std::is_same<T, decltype(conditionStmt)>::value &&
         !std::is_same<T, decltype(var)>::value &&
         !std::is_same<T, decltype(add)>::value &&
         !std::is_same<T, decltype(sub)>::value &&
         !std::is_same<T, decltype(mul)>::value &&

         !std::is_same<T, decltype(Div)>::value &&
         !std::is_same<T, decltype(constant)>::value &&
         !std::is_same<T, decltype(Float)>::value &&
         !std::is_same<T, decltype(eq)>::value &&
         !std::is_same<T, decltype(le)>::value &&
         !std::is_same<T, decltype(ge)>::value &&

         !std::is_same<T, decltype(lt)>::value &&
         !std::is_same<T, decltype(gt)>::value &&
         !std::is_same<T, decltype(ne)>::value &&
         !std::is_same<T, decltype(And)>::value &&
         !std::is_same<T, decltype(Or)>::value &&
         !std::is_same<T, decltype(Not)>::value &&
         !std::is_same<T, decltype(Int)>::value &&
         !std::is_same<T, decltype(Bool)>::value &&
         !std::is_same<T, decltype(initialisation)>::value &&
         !std::is_same<T, decltype(condition)>::value &&
         !std::is_same<T, decltype(update)>::value &&
         !std::is_same<T, decltype(Array)>::value &&
         !std::is_same<T, decltype(assignArray)>::value &&
         !std::is_same<T, decltype(assignVar)>::value;
}
int main() {
  // Example usage
  type value = assignStmt;                            // Change the value to
                                                      // check different enums
  bool result = is_statement(value);                  // Change the type to
                                                      // check different enums
  std::cout << std::boolalpha << result << std::endl; // Print the result
  return 0;
}
