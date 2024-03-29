#ifndef SIMPLE_THREAD_POOL_HPP
#define SIMPLE_THREAD_POOL_HPP

#include <atomic>
#include <condition_variable>
#include <functional>
#include <future>
#include <mutex>
#include <queue>
#include <thread>
#include <vector>

// ============================================================================================================================================
// =================================================================== API ====================================================================
// ============================================================================================================================================

/// @brief Namespace containing all relevant classes and functions
namespace simpleThreadPool {
    /// @brief Class representing the thread pool
    /// @details The user can specify number of execution threads and add jobs to be executed by them
    class ThreadPool {
        public:
            /// @brief Constructor
            /// @param[in] numThreads Number of worker threads to accept jobs in the thread pool
            ThreadPool(const unsigned numThreads = std::thread::hardware_concurrency());
            /// @brief Destructor
            /// @details Waits for all queued jobs to finish and then joins the worker threads
            /// Jobs cannot be added to the queue while destructor is executing
            ~ThreadPool();

            /// @brief Function to add a job to be executed by the thread pool
            /// @details A job to be queued may be a funcion, lambda, function object etc, that may or may not have arguments and/or return type
            /// Use the returned future object to extract the function return type or to wait for a specific job to finish before continuing execution of your program
            /// @tparam R is deduced to the function return type if the function returns something, or void if function has void return type
            /// @param[in] func Function to queue
            /// @param[in] args Function arguments(if it has any)
            /// @return A std::future<void> if the queued function has no return type, or std::future<R> if queued function has return type R
            template <typename F, typename... Args, typename R = std::invoke_result_t<std::decay_t<F>, std::decay_t<Args>...>>
            std::future<R> queueJob(const F& func, const Args&... args);
            
            /// @brief Function to add multiple jobs to the queue and wait for them to finish
            /// @details Functions added this way must share a return type (that may be void), and have no arguments
            /// @note If functions need to have arguments, use std::bind for them while creating the vector, for example:
            /// ```
            /// std::vector<std::function<int()>> vect = {
            ///     std::bind([](int x){return x;}, 2), 
            ///     std::bind([](int x, int y){return x + y;}, 2, 3)
            /// };
            /// ```
            /// @tparam R is deduced to the function return type if the function returns something, or void if function has void return type
            /// @param[in] functions Vector of jobs to be queued
            /// @return A vector of std::future objects that can be used to extract the return value from enqueued functions
            template <typename R>
            std::vector<std::future<R>> queueAndWaitForJobs(const std::vector<std::function<R()>>& functions);

            /// @brief Function that can be called to wait for all currently queued jobs to finish
            void waitForAllJobsToFinish();
            /// @brief Removes all queued jobs that are not currently in execution from the queue
            void clearQueue();

            /// @brief Get number of worker threads
            size_t getPoolSize() const;
            /// @brief Change the number of worker threads in the pool
            /// @details Waits for all jobs in the queue to finish, joins all worker threads, then creates new worker threads
            /// Jobs cannot be added to the queue while resizing is in progress
            /// @param newSize New number of worker threads in the pool
            void resizePool(const size_t newSize);

            /// @brief Get number of queued jobs that are still not executing
            size_t countQueuedJobs() const;
            /// @brief Get number of jobs that are currently executing
            size_t countOngoingJobs() const;
            /// @brief Get number of total jobs in the thread pool (queued + ongoing) 
            size_t countTotalJobs() const;
        
        private:
            void workerThread();

            std::atomic<bool> shouldTerminateWorkers;
            std::atomic<bool> queueJobAllowed;
            std::atomic<unsigned int> ongoingJobs;
            std::atomic<unsigned int> jobQueueSize;
            std::vector<std::thread> workers;
            std::mutex jobQueueMutex;
            std::condition_variable condQueue;
            std::condition_variable condJobFinished;
            std::queue<std::function<void()>> jobQueue;
    };
} // namespace simpleThreadPool

// ============================================================================================================================================
// ============================================================== IMPLEMENTATION ==============================================================
// ============================================================================================================================================

namespace simpleThreadPool {
    inline ThreadPool::ThreadPool(const unsigned numThreads) 
        : shouldTerminateWorkers(false),
          queueJobAllowed(true),
          ongoingJobs(0),
          jobQueueSize(0),
          workers(numThreads),
          jobQueueMutex{},
          condQueue{},
          condJobFinished{},
          jobQueue{}
    {
        for (unsigned i = 0; i < numThreads; ++i) {
            workers.at(i) = std::thread(&ThreadPool::workerThread, this);
        }
    }

    inline ThreadPool::~ThreadPool() {
        queueJobAllowed = false;

        waitForAllJobsToFinish();

        shouldTerminateWorkers = true;
        condQueue.notify_all();

        for (auto& worker : workers) {
            worker.join();
        }
    }

    template <typename F, typename... Args, typename R>
    inline std::future<R> ThreadPool::queueJob(const F& func, const Args&... args) {
        std::shared_ptr<std::promise<R>> jobPromise = std::make_shared<std::promise<R>>();
        std::future<R> jobFuture = jobPromise->get_future();

        {
            std::unique_lock<std::mutex> jobQueueLock(jobQueueMutex);

            if(!queueJobAllowed) {
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

            ++jobQueueSize;
        }

        condQueue.notify_one();

        return jobFuture;
    }

    template <typename R>
    inline std::vector<std::future<R>> ThreadPool::queueAndWaitForJobs(const std::vector<std::function<R()>>& functions) {
        std::vector<std::future<R>> futures;
        futures.reserve(functions.size());

        for (auto& func : functions) {
            futures.emplace_back(queueJob(func));
        }

        for (auto& f : futures) {
            f.wait();
        }

        return futures;
    }

    inline size_t ThreadPool::countQueuedJobs() const {
        return static_cast<size_t>(jobQueueSize);
    }

    inline size_t ThreadPool::countOngoingJobs() const {
        return static_cast<size_t>(ongoingJobs);
    }

    inline size_t ThreadPool::countTotalJobs() const {
        return countQueuedJobs() + countOngoingJobs();
    }

    inline void ThreadPool::waitForAllJobsToFinish() {
        std::unique_lock<std::mutex> jobQueueLock(jobQueueMutex);
        condJobFinished.wait(jobQueueLock, [this](){
            return countTotalJobs() == 0;
        });
    }

    inline void ThreadPool::clearQueue() {
        std::unique_lock<std::mutex> jobQueueLock(jobQueueMutex);
        jobQueue = {};
        jobQueueSize = 0;
        return;
    }

    inline size_t ThreadPool::getPoolSize() const {
        return workers.size();
    }
    
    inline void ThreadPool::resizePool(const size_t newSize) {
        if (newSize == workers.size()) {
            return;
        }

        queueJobAllowed = false;

        waitForAllJobsToFinish();

        shouldTerminateWorkers = true;
        condQueue.notify_all();

        for (auto& worker : workers) {
            worker.join();
        }

        shouldTerminateWorkers = false;
            
        workers.clear();
        workers.reserve(newSize);

        for (unsigned i = 0; i < newSize; ++i) {
            workers.emplace_back(&ThreadPool::workerThread, this);
        }

        queueJobAllowed = true;

        return;
    }

    inline void ThreadPool::workerThread() {
        std::function<void()> job;

        while (true) {
            {
                std::unique_lock<std::mutex> jobQueueLock(jobQueueMutex);
                
                condQueue.wait(jobQueueLock, [this](){
                    return shouldTerminateWorkers || !jobQueue.empty();
                });

                if (shouldTerminateWorkers) {
                    return;
                }

                job = jobQueue.front();
                jobQueue.pop();
            }

            ++ongoingJobs;
            --jobQueueSize;
            job();
            --ongoingJobs;

            condJobFinished.notify_one();
        }
    }
} // namespace simpleThreadPool

#endif // SIMPLE_THREAD_POOL_HPP
