#include <iostream>
#include <unordered_map>
#define UNDEFINED INT_MAX
#define NOT_INITIALIZED INT_MIN
using namespace std;
unordered_map<string, std::variant<int, bool>> symbol_table;

void setVariableValue(string name, std::variant<int, bool> value) {
  symbol_table[name] = value;
}

std::variant<int, bool> getVariableValue(string name) {
  if (symbol_table.find(name) == symbol_table.end()) {
    cout << "variable " << name << " not found" << endl;
    std::variant<int, bool> undefined = UNDEFINED;
    return undefined;
  } else {
    return symbol_table[name];
  }
}

int getIntValue(std::variant<int, bool> value) {
  if (std::holds_alternative<int>(value)) {
    return std::get<int>(value);
  } else {
    cout << "value is not an integer" << endl;
    return UNDEFINED;
  }
}

bool getBoolValue(std::variant<int, bool> value) {
  if (std::holds_alternative<bool>(value)) {
    return std::get<bool>(value);
  } else {
    cout << "value is not a boolean" << endl;
    return false;
  }
}

int main() {
  setVariableValue("x", 10);
  setVariableValue("y", true);
  cout << getIntValue(getVariableValue("x")) << endl;
  cout << getBoolValue(getVariableValue("y")) << endl;
  cout << getIntValue(getVariableValue("y")) << endl;
  cout << getBoolValue(getVariableValue("x")) << endl;
  return 0;
}
