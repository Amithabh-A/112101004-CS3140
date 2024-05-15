#include <iostream>
#include <fstream>
#include <sstream>

void writeFileOnEnd(const std::string& filePath, const std::string& str) {
    // Open the file in append mode
    std::ofstream outFile(filePath, std::ios::app);

    if (outFile.is_open()) {
        // Write the string to the end of the file
        outFile << str;
        // Close the file
        outFile.close();
        std::cout << "String '" << str << "' written to the end of the file." << std::endl;
    } else {
        std::cerr << "Unable to open the file: " << filePath << std::endl;
    }
}

int main(){
    std::string filePath = "output.txt";
    std::string str = "Hello, World!\n";

    writeFileOnEnd(filePath, str);

    return 0;
}
