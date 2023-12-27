if(STP_ENABLE_BUILD_TESTS)
    set(STP_TEST_SOURCES "tests.cpp")

    set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
    set(THREADS_PREFER_PTHREAD_FLAG TRUE)
    find_package(Threads REQUIRED)
    
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        if(STP_ENABLE_BRUTAL_COMPILE_OPTIONS)
            include(brutal-compiler-options)
    
            set(STP_WARNING_SUPPRESSORS)
    
            if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
                list(APPEND STP_WARNING_SUPPRESSORS 
                    -Wno-unsafe-loop-optimizations
                )
            elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
                list(APPEND STP_WARNING_SUPPRESSORS 
                    -Wno-padded
                    -Wno-date-time
                    -Wno-c++98-compat
                )
            elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
                list(APPEND STP_WARNING_SUPPRESSORS 
                    /wd4820
                    /wd4514
                    /wd4711
                    /wd5045
                )
            endif()
        endif()
    
        if(STP_ENABLE_SANITIZERS)
            include(sanitize)
        endif()
    
        if(STP_ENABLE_CALLGRIND_TARGETS)
            include(grind)
        endif()
    
        if(STP_ENABLE_STATIC_ANALYSIS)
            include(static-analysis)
        endif()
    endif()

    
    foreach(STP_SOURCE IN LISTS STP_TEST_SOURCES)
        get_filename_component(STP_TEST_NAME ${STP_SOURCE} NAME_WLE)
        message(STATUS "Creating test: ${STP_TEST_NAME} from source: ${STP_SOURCE}")
    
        add_executable(${STP_TEST_NAME} ${STP_SOURCE})
        target_link_libraries(${STP_TEST_NAME} PUBLIC
            Threads::Threads
            simpleThreadPool
        )
    
        if(CMAKE_BUILD_TYPE STREQUAL "Debug")
            if(STP_ENABLE_BRUTAL_COMPILE_OPTIONS)
                scm_add_brutal_compiler_options(${STP_TEST_NAME} PUBLIC ${STP_WARNING_SUPPRESSORS})
            endif()
    
            if(STP_ENABLE_SANITIZERS)
                # scm_add_address_sanitizer_with_options(${STP_TEST_NAME} PUBLIC)
                # scm_add_undefined_behavior_sanitizer_with_options(${STP_TEST_NAME} PUBLIC)
                # scm_add_thread_sanitizer_with_options(${STP_TEST_NAME} PUBLIC)
                # scm_add_memory_sanitizer_with_options(${STP_TEST_NAME} PUBLIC)
            endif()
    
            if(STP_ENABLE_CALLGRIND_TARGETS)
                scm_create_grind_target(${STP_TEST_NAME})
            endif()
    
            if(STP_ENABLE_STATIC_ANALYSIS)
                # this target_include_directories is only needed for the ${SC-TEST_NAME}-static-analyze target
                # because at this time it cannot extract include directories from the linked simpleContainers target
                # remove this line once that is working!
                target_include_directories(${STP_TEST_NAME} PUBLIC ${CMAKE_SOURCE_DIR}/include)
    
                scm_add_static_analysis_target(${STP_TEST_NAME})
            endif()
        endif()
    
        add_test(NAME ${STP_TEST_NAME} COMMAND ${STP_TEST_NAME} WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
    
        if(STP_ENABLE_COVERAGE_REPORT)
            target_code_coverage(${STP_TEST_NAME} AUTO ALL)
        endif()
    endforeach()
endif()
