#include <string>
#include <iostream>
#include <chrono>
#include <type_traits>

#include "simpleThreadPool.hpp"

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
void hello1(const std::vector<int>& x) {}

// returns, no arguments
double foo() {
    std::this_thread::sleep_for(std::chrono::seconds(2));
    return 0.0;
}

// returns, with arguments
int foo1(int x) {
    std::this_thread::sleep_for(std::chrono::seconds(2));
    return x;
}

int main() {
    simpleThreadPool::ThreadPool pool;

    std::cout << "queued: " << pool.countQueuedJobs() << " ongoing: " << pool.countOngoingJobs() << " total: " << pool.countTotalJobs() << std::endl;

    auto f1 = pool.queueJob(hello);
    std::cout << "queued: " << pool.countQueuedJobs() << " ongoing: " << pool.countOngoingJobs() << " total: " << pool.countTotalJobs() << std::endl;
    f1.get();
    std::cout << "queued: " << pool.countQueuedJobs() << " ongoing: " << pool.countOngoingJobs() << " total: " << pool.countTotalJobs() << std::endl;
    std::cout << "f1 get called" << std::endl; 

    auto f2 = pool.queueJob(hello1, std::vector<int>{});
    f2.get();
    std::cout << "f2 get called" << std::endl;

    auto f3 = pool.queueJob(foo);
    auto f4 = pool.queueJob(foo1, 1);

    std::this_thread::sleep_for(std::chrono::seconds(1));
    std::cout << "queued: " << pool.countQueuedJobs() << " ongoing: " << pool.countOngoingJobs() << " total: " << pool.countTotalJobs() << std::endl;
    std::this_thread::sleep_for(std::chrono::seconds(1));

    std::cout << "f3 " << f3.get() << std::endl;
    std::cout << "f4 " << f4.get() << std::endl;

    std::cout << "queued: " << pool.countQueuedJobs() << " ongoing: " << pool.countOngoingJobs() << " total: " << pool.countTotalJobs() << std::endl;
}