#include <iostream>
#include <string>
#include <unordered_map>
#include <variant>

template <typename T>
T extract_value(const std::string &variable_name,
                std::unordered_map<std::string, std::variant<int, bool, float>>
                    symbol_table) {
  auto it = symbol_table.find(variable_name);
  if (it != symbol_table.end()) {
    if (auto val_ptr = std::get_if<T>(&it->second)) {
      return *val_ptr;
    } else {
      throw std::invalid_argument("Type mismatch: Variable is not of type " +
                                  std::string(typeid(T).name()));
    }
  } else {
    throw std::invalid_argument("Variable not found in symbol table");
  }
}

int main() {
  std::unordered_map<std::string, std::variant<int, bool, float>> symbol_table;
  symbol_table["myInt"] = 10;
  symbol_table["myFloat"] = 3.14f;

  try {
    int extracted_int = extract_value<int>("myInt", symbol_table);
    float extracted_float = extract_value<float>("myFloat", symbol_table);

    std::cout << "Extracted int value: " << extracted_int << std::endl;
    std::cout << "Extracted float value: " << extracted_float << std::endl;
  } catch (const std::invalid_argument &e) {
    std::cerr << "Error: " << e.what() << std::endl;
  }

  return 0;
}
