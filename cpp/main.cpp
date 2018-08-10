#include <stdexcept>
#include <iostream>


int opt_parse(int argc, char** argv) {
    // implement option parsing and call the real main 
    // with everything ready to use
    return 0;
}


int main(int argc, char** argv) {
    try {
        return opt_parse(argc, argv);
    } catch (std::exception& e) {
        std::cerr << "Standard exception. What: " << e.what() << "\n";
        return 10;
    } catch (...) {
        std::cerr << "Unknown exception.\n";
        return 11;
    }
}
