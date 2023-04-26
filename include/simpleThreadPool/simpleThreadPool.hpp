#ifndef __SIMPLE_THREAD_POOL__
#define __SIMPLE_THREAD_POOL__

#include <atomic>
#include <condition_variable>
#include <functional>
#include <future>
#include <mutex>
#include <queue>
#include <thread>
#include <vector>

//------------------------------------- API -------------------------------------

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

            /// @brief Function that can be called to wait for all currently queued jobs to finish
            void waitForAllJobsToFinish();
            /// @brief Removes all queued jobs that are not currently in execution from the queue
            void clearQueue();

            /// @brief Get number of queued jobs that are still not executing
            size_t countQueuedJobs();
            /// @brief Get number of jobs that are currently executing
            size_t countOngoingJobs();
            /// @brief Get number of total jobs in the thread pool (queued + ongoing) 
            size_t countTotalJobs();
        
        private:
            void workerThread();

            const unsigned int numThreads;
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

//------------------------------------- IMPLEMENTATION -------------------------------------

namespace simpleThreadPool {
    ThreadPool::ThreadPool(const unsigned numThreads) 
        : numThreads(numThreads), shouldTerminateWorkers(false), queueJobAllowed(true), ongoingJobs(0), jobQueueSize(0), workers(numThreads)
    {
        for (unsigned i = 0; i < numThreads; ++i) {
            workers.at(i) = std::thread(&ThreadPool::workerThread, this);
        }
    }

    ThreadPool::~ThreadPool() {
        queueJobAllowed = false;

        waitForAllJobsToFinish();

        shouldTerminateWorkers = true;
        condQueue.notify_all();

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

    size_t ThreadPool::countQueuedJobs() {
        return static_cast<size_t>(jobQueueSize);
    }

    size_t ThreadPool::countOngoingJobs() {
        return static_cast<size_t>(ongoingJobs);
    }

    size_t ThreadPool::countTotalJobs() {
        return countQueuedJobs() + countOngoingJobs();
    }

    void ThreadPool::waitForAllJobsToFinish() {
        {
            std::unique_lock<std::mutex> jobQueueLock(jobQueueMutex);
            condJobFinished.wait(jobQueueLock, [this](){
                return countTotalJobs() == 0;
            }); 
        }
    }

    void ThreadPool::clearQueue() {
        std::unique_lock<std::mutex> jobQueueLock(jobQueueMutex);
        jobQueue = {};
        jobQueueSize = 0;
        return;
    }

    void ThreadPool::workerThread() {
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

#endif // __SIMPLE_THREAD_POOL__