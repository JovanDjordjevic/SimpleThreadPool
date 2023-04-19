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

            bool shouldTerminateWorkers;
            unsigned int numThreads;
            std::vector<std::thread> workers;
            std::mutex jobQueueMutex;
            std::condition_variable cond;
            std::queue<std::function<void()>> jobQueue;
    };
} // namespace simpleThreadPool

//------------------------------------- IMPLEMENTATION -------------------------------------

namespace simpleThreadPool {
    ThreadPool::ThreadPool(const unsigned numThreads) 
        : shouldTerminateWorkers(false), numThreads(numThreads), workers(numThreads)
    {
        for (unsigned i = 0; i < numThreads; ++i) {
            workers.at(i) = std::thread(&ThreadPool::workerThread, this);
        }
    }

    ThreadPool::~ThreadPool() {
        {
            std::unique_lock<std::mutex> jobQueueLock(jobQueueMutex);
            shouldTerminateWorkers = true;
        }

        cond.notify_all();

        for (auto& worker : workers) {
            worker.join();
        }
    }

    template <typename F, typename... Args, typename R>
    std::future<R> ThreadPool::queueJob(const F& func, const Args&... args) {
        std::shared_ptr<std::promise<R>> jobPromise = std::make_shared<std::promise<R>>();
        std::future<R> jobFuture = jobPromise->get_future();

        {
            std::unique_lock<std::mutex> jobQueueLock(jobQueueMutex);

            if(shouldTerminateWorkers) {
                throw std::runtime_error("Cannot enqueue additional jobs when trying to terminate workers!");
            }

            jobQueue.emplace([func, args..., jobPromise](){
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
        std::function<void()> job;

        while (true) {
            {
                std::unique_lock<std::mutex> jobQueueLock(jobQueueMutex);
                
                cond.wait(jobQueueLock, [this](){
                    return shouldTerminateWorkers || !jobQueue.empty();
                });

                // immediately terminate even though there might be some left over jobs in the queue that are not started
                if (shouldTerminateWorkers) {
                    return;
                }

                job = jobQueue.front();
                jobQueue.pop();
            }

            job();
        }
    }
} // namespace simpleThreadPool

#endif // __SIMPLE_THREAD_POOL__