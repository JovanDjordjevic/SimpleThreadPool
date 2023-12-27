cmake_minimum_required(VERSION 3.20)

project(SimpleThreadPool VERSION 1.0.0 LANGUAGES CXX)

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    message(FATAL_ERROR "In-source builds not allowed. Please make a build directory.")
endif()

if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "No build type selected, default to Debug")
    set(CMAKE_BUILD_TYPE "Debug")
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_OUTPUT_EXTENSION_REPLACE ON)

# optional targets
option(STP_ENABLE_DOXYGEN "Create doxygen documentation target" OFF)
option(STP_ENABLE_BUILD_TESTS "Build the test executables" OFF)
option(STP_ENABLE_BUILD_EXAMPLES "Build examples" OFF)
option(STP_ENABLE_CALLGRIND_TARGETS "Create additional targets for callgrind/kcachegrind for executables" OFF)
option(STP_ENABLE_STATIC_ANALYSIS "Create additional targets for explicit static analysis of targets" OFF)

# other build options
option(STP_ENABLE_COVERAGE_REPORT "Create code coverage report for tests" OFF)
option(STP_ENABLE_BRUTAL_COMPILE_OPTIONS "Add additional warning flags when building" OFF)
option(STP_ENABLE_SANITIZERS "Enable sanitizers during compilation" OFF)

if(STP_ENABLE_COVERAGE_REPORT AND NOT STP_ENABLE_BUILD_TESTS)
    message(FATAL_ERROR "Code coverage only available when building tests")
endif()

if(STP_ENABLE_DOXYGEN)
    # To generate html documentation, build the 'docs' target
    include(doxy)
    cmake_path(APPEND STP_DOXYFILE_PATH ${CMAKE_SOURCE_DIR} docs)
    scm_create_docs_target(${STP_DOXYFILE_PATH})
endif()

if(STP_ENABLE_COVERAGE_REPORT)
    # To generate html coverage report, build the 'ccov-all' target
    message(STATUS "Adding code coverage")
    set(CODE_COVERAGE ON)
    include(code-coverage)
    add_code_coverage_all_targets()
endif()

add_subdirectory(include)

if(STP_ENABLE_BUILD_TESTS)
    # run tests with ctest
    message(STATUS "Building tests")
    include(CTest)
    add_subdirectory(tests)
endif()

if(STP_ENABLE_BUILD_EXAMPLES)
    # you can find example executables in build/examples/... (depending on the cmake generator)
    message(STATUS "Building examples")
    add_subdirectory(examples)
endif()
