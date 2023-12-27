set(STP_SIMPLETHREADPOOL_LIBRARY_HEADERS "simpleThreadPool.hpp")
set(STP_SIMPLETHREADPOOL_LIBRARY_INCLUDES  "./")

add_library(simpleThreadPool INTERFACE)

target_include_directories(simpleThreadPool INTERFACE ${STP_SIMPLETHREADPOOL_LIBRARY_INCLUDES})
