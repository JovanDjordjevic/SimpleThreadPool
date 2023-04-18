#include <string>
#include <iostream>
#include <chrono>

#include "simpleThreadPool.hpp"

using namespace std::chrono_literals;

void f (std::string& s) {
    s = "\nbind f\n";
    std::cout << s << std::endl;
}

void f1 (int x, int& y, std::string z) {
    x = 5;
    y = 7;
    z = "aaa";
}

int main() {
    std::string s = "aa";
    std::cout << s << std::endl;

    std::thread thr(f, std::ref(s));
    thr.join();

    std::cout << s << std::endl;

    simpleThreadPool::ThreadPool pool;

    pool.queueJob([](){std::cout << "\nlambda\n" << std::endl;});
    pool.queueJob(std::bind(f, std::ref(s)));
    int x = 1, y = 0;
    std::string tmp("tmp");
    pool.queueJob(f1, x, std::ref(y), tmp);

    std::this_thread::sleep_for(2s);
    std::cout << x << " " << y << " " << tmp << std::endl;

    std::this_thread::sleep_for(10s);
}