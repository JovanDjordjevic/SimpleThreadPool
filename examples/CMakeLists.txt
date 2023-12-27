if(STP_ENABLE_BUILD_EXAMPLES)
    set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
    set(THREADS_PREFER_PTHREAD_FLAG TRUE)
    find_package(Threads REQUIRED)

    set(STP_EXAMPLE_SOURCES "example_01.cpp")

    foreach(STP_SOURCE IN LISTS STP_EXAMPLE_SOURCES)
        get_filename_component(STP_EXAMPLE_NAME ${STP_SOURCE} NAME_WLE)
        message(STATUS "Creating example: ${STP_EXAMPLE_NAME} from source: ${STP_SOURCE}")
        
        add_executable(${STP_EXAMPLE_NAME} ${STP_SOURCE})
        target_link_libraries(${STP_EXAMPLE_NAME} PUBLIC 
            Threads::Threads
            simpleThreadPool
        )
    endforeach()
endif()
