#include <string>
#include <unordered_map>
#include <variant>
//
// template <typename T>
// T extract_value(const std::string &variable_name,
//                 std::unordered_map<std::string, std::variant<int, bool,
//                 float>>
//                     symbol_table) {
//   auto it = symbol_table.find(variable_name);
//   if (it != symbol_table.end()) {
//     if (auto val_ptr = std::get_if<T>(&it->second)) {
//       return *val_ptr;
//     } else {
//       throw std::invalid_argument("Type mismatch: Variable is not of type " +
//                                   std::string(typeid(T).name()));
//     }
//   } else {
//     throw std::invalid_argument("Variable not found in symbol table");
//   }
// }
//
// int main() {
//   std::unordered_map<std::string, std::variant<int, bool, float>>
//   symbol_table; symbol_table["myInt"] = 10; symbol_table["myFloat"] = 3.14f;
//
//   try {
//     int extracted_int = extract_value<int>("myInt", symbol_table);
//     float extracted_float = extract_value<float>("myFloat", symbol_table);
//
//     std::cout << "Extracted int value: " << extracted_int << std::endl;
//     std::cout << "Extracted float value: " << extracted_float << std::endl;
//   } catch (const std::invalid_argument &e) {
//     std::cerr << "Error: " << e.what() << std::endl;
//   }
//
//   return 0;
// }
//

#include <iostream>
#include <type_traits>

// Define the enum
enum StatementType {
  declarationStmt,
  assignStmt,
  conditionStmt,
  writeStmt,
  numericExpr,
};

// Function to check if a type is one of the enum values
template <typename T> bool is_instance_of_enum(T value) {
  return std::is_same<T, StatementType>::value &&
         !std::is_same<T, decltype(numericExpr)>::value;
}

// template <typename T> bool is_instance_of_enum(T value) {
//   return std::is_same<T, decltype(declarationStmt)>::value &&
//          return std::is_same<T, decltype(assignStmt)>::value &&
//          return std::is_same<T, decltype(writeStmt)>::value &&
//          return std::is_same<T, decltype(conditionStmt)>::value;
// }

int main() {
  // Example usage
  StatementType value = numericExpr;
  bool result = is_instance_of_enum(value);           // Change the type to
                                                      // check different enums
  std::cout << std::boolalpha << result << std::endl; // Print the result
  return 0;
}
