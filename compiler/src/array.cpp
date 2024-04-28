#include <iostream>
using namespace std;
#include <map>
#include <utility>
#define NOT_INITIALIZED INT_MIN
#define UNDEFINED INT_MAX
map<string, pair<int *, int>> array_table;

int *set_array(string name, int size,
               map<string, pair<int *, int>> array_table) {
  pair<int *, int> p = make_pair(new int[size], size);
  array_table[name] = p;
  for (int i = 0; i < p.second; i++) {
    p.first[i] = NOT_INITIALIZED;
  }
  return p.first;
}

void set_array_element(string name, int index, int value,
                       map<string, pair<int *, int>> array_table) {
  if (array_table.find(name) == array_table.end()) {
    // cout << "Error: array " << name << " not found" << endl;
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
