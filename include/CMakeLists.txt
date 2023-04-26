set(LIBRARY_HEADERS "simpleThreadPool.hpp")
set(LIBRARY_INCLUDES  "./")

add_library(simpleThreadPool INTERFACE)

target_include_directories(simpleThreadPool INTERFACE ${LIBRARY_INCLUDES})