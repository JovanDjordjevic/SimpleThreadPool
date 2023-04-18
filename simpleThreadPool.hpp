#ifndef __SIMPLE_THREAD_POOL__
#define __SIMPLE_THREAD_POOL__

#include <condition_variable>
#include <functional>
#include <mutex>
#include <queue>
#include <thread>
#include <vector>

//------------------------------------- API -------------------------------------

namespace simpleThreadPool {
    class ThreadPool {
        public:
            ThreadPool(const unsigned numThreads = std::thread::hardware_concurrency());
            ~ThreadPool();

            template<typename F, typename... Args>
            void queueJob(F&& f, Args&&... args);
        
        private:
            void workerThread();

            unsigned int numThreads;
            std::mutex jobQueueAccess;
            std::condition_variable cond;
            std::vector<std::thread> pool;
            std::queue<std::function<void()>> jobs;
    };
} // namespace simpleThreadPool

//------------------------------------- IMPLEMENTATION -------------------------------------

namespace simpleThreadPool {
    ThreadPool::ThreadPool(const unsigned numThreads) : numThreads(numThreads) {
        pool.resize(numThreads);
        for (unsigned i = 0; i < numThreads; ++i) {
            pool.at(i) = std::thread(&ThreadPool::workerThread, this);
        }
    }

    ThreadPool::~ThreadPool() {
        for (auto& thread : pool) {
            thread.join();
        }
    }

    template<typename F, typename... Args>
    void ThreadPool::queueJob(F&& f, Args&&... args) {
        {
            std::unique_lock<std::mutex> lock(jobQueueAccess);
            jobs.push(std::bind(std::move(f), std::forward<Args>(args)...));
        }

        cond.notify_one();
    }

    void ThreadPool::workerThread() {
        while (true) {
            std::function<void()> job;

            {
                std::unique_lock<std::mutex> lock(jobQueueAccess);
                
                cond.wait(lock, [this] { return !jobs.empty(); });

                // ...

                job = jobs.front();
                jobs.pop();
            }

            job();
        }
    }
} // namespace simpleThreadPool

#endif // __SIMPLE_THREAD_POOL__