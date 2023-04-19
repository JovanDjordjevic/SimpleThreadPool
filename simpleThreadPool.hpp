#ifndef __SIMPLE_THREAD_POOL__
#define __SIMPLE_THREAD_POOL__

#include <condition_variable>
#include <functional>
#include <future>
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

            template <typename F, typename... Args, typename R = std::invoke_result_t<std::decay_t<F>, std::decay_t<Args>...>>
            std::future<R> queueJob(const F& func, const Args&... args);
        
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

    template <typename F, typename... Args, typename R>
    std::future<R> ThreadPool::queueJob(const F& func, const Args&... args) {
        std::shared_ptr<std::promise<R>> jobPromise = std::make_shared<std::promise<R>>();
        std::future<R> jobFuture = jobPromise->get_future();

        {
            std::unique_lock<std::mutex> lock(jobQueueAccess);

            jobs.emplace([func, args..., jobPromise](){
                try {
                    if constexpr (std::is_void_v<R>) {
                        func(args...);
                        jobPromise->set_value();
                    }
                    else {
                        jobPromise->set_value(func(args...));
                    }
                }
                catch (...) {
                    try {
                        jobPromise->set_exception(std::current_exception());
                    }
                    catch (...) {}
                }
            });
        }

        cond.notify_one();
        return jobFuture;
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