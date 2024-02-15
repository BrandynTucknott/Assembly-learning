#include <string>
#include <iostream>
#include <pthread>

#define STACK_SIZE 4096

std::string s0 = "hello from thread 0";
std::string s1 = "hello from thread 1";

void t0Process()
{
    std::cout << s0 << "\n";
}

void t1Process()
{
    std::cout << s1 << "\n";
}

int main()
{

    return 0;
}