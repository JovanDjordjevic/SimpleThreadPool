if(ENABLE_TESTING)
    set(TEST_SOURCES "tests.cpp")

    set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
    set(THREADS_PREFER_PTHREAD_FLAG TRUE)
    find_package(Threads REQUIRED)

    foreach(SOURCE IN LISTS TEST_SOURCES)
        get_filename_component(TEST_NAME ${SOURCE} NAME_WLE)
        # message(STATUS "Creating test: " ${TEST_NAME} " from source: " ${SOURCE})
        
        add_executable(${TEST_NAME} ${SOURCE})
        target_link_libraries(${TEST_NAME} PUBLIC Threads::Threads
                                                  simpleThreadPool)
        # add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME} WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
        add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})

        if(ENABLE_COVERAGE_REPORT)
            target_code_coverage(${TEST_NAME} AUTO ALL)
        endif()
    endforeach()
endif()
