#include <string>
#include <iostream>
#include <chrono>
#include <type_traits>

#include "simpleThreadPool.hpp"

void printStandard() {
    int s = __cplusplus;
    if (__cplusplus == 201103L) {
        s = 11;
    }
    else if (__cplusplus == 201402L) {
        s = 14;
    }
    else if (__cplusplus == 201703L) {
        s = 17;
    }
    else if (__cplusplus == 202002L) {
        s = 20;
    }

    std::cout << "STANDARD IS: C++" << s << std::endl;
} 

void f (std::string& s) {
    s = "\nbind f\n";
    std::cout << s << std::endl;
}

void f1 (int x, int& y, std::string z) {
    x = 5;
    y = 7;
    z = "aaa";
}

// does not return, no arguments
void hello() {
    std::cout << "Hello world" << std::endl;
}

// does not return, with arguments
void hello1(const std::vector<int>& x) {

}

// returns, no arguments
double foo() {
    return 0.0;
}

// returns, with arguments
int foo1(int x) {
    return x;
}


int main() {
    printStandard();

    simpleThreadPool::ThreadPool pool;

    std::this_thread::sleep_for(std::chrono::seconds(2));

    auto f1 = pool.queueJob(hello);
    f1.get();
    std::cout << "f1 get called" << std::endl; 

    auto f2 = pool.queueJob(hello1, std::vector<int>{});
    f2.get();
    std::cout << "f2 get called" << std::endl;

    auto f3 = pool.queueJob(foo);
    std::cout << "f3 " << f3.get() << std::endl;

    auto f4 = pool.queueJob(foo1, 1);
    std::cout << "f4 " << f4.get() << std::endl;
}