# SCM_ prefix is used to mark variables that come from SimpleCmakeModules

# =======================================================================================================================================
# ================================================== Built-in compiler static analysis ==================================================
# =======================================================================================================================================

# scm_add_static_analysis_target(<your_target_name>)
#
# This function will create a target called your_target_name-static-analyze that will perform static analysis on
# source and header files of your target. At the time of writing this, g++13, clang++17 and msvc 19.37 were used for testing
#
# your_target_name - name of your target
function(scm_add_static_analysis_target SCM_TARGET_NAME)
    message(STATUS "Detected ${CMAKE_CXX_COMPILER_ID} compiler, version: ${CMAKE_CXX_COMPILER_VERSION}")

    get_target_property(SCM_TARGET_INTERFACE_INCLUDE_DIRS ${SCM_TARGET_NAME} INTERFACE_INCLUDE_DIRECTORIES)
    get_target_property(SCM_TARGET_INCLUDE_DIRS ${SCM_TARGET_NAME} INCLUDE_DIRECTORIES)

    # TODO: extract include directories from linked targets as well!

    set(SCM_ANALYZER_OPTIONS)
    set(SCM_INCLUDE_DIR_PREFIX)

    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "10.0.0")
            message(FATAL_ERROR "Error: GNU compiler does not support static analysis as compiler option untill version 10.0.0")
        endif()

        list(APPEND SCM_ANALYZER_OPTIONS -fanalyzer)
        set(SCM_INCLUDE_DIR_PREFIX "-I")
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "10.0.0")
            message(FATAL_ERROR "Error: MSVC compiler does not support static analysis as compiler option untill version 10.0.0")
        endif()

        list(APPEND SCM_ANALYZER_OPTIONS --analyze)
        set(SCM_INCLUDE_DIR_PREFIX "-I")
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "15.7.0")
            message(FATAL_ERROR "Error: MSVC compiler does not support static analysis as compiler option untill version 15.7.0")
        endif()

        list(APPEND SCM_ANALYZER_OPTIONS /analyze)
        set(SCM_INCLUDE_DIR_PREFIX "/I")
    else()
        message(FATAL_ERROR "Compiler: Unknown or unsupported compiler")
    endif()

    foreach(SCM_INCLUDE_DIR ${SCM_TARGET_INTERFACE_INCLUDE_DIRS})
        list(APPEND SCM_ANALYZER_OPTIONS "${SCM_INCLUDE_DIR_PREFIX}${SCM_INCLUDE_DIR}")
    endforeach()
  
    get_target_property(SCM_TARGET_SOURCES ${SCM_TARGET_NAME} SOURCES)
    get_target_property(SCM_SOURCE_ROOT_DIR ${SCM_TARGET_NAME} SOURCE_DIR)
    
    set(SCM_TARGET_SOURCES_ABSOLUTE_PATHS)

    foreach(SCM_SINGLE_TARGET_SOURCE ${SCM_TARGET_SOURCES})
        cmake_path(APPEND SCM_SOURCE_ABS_PATH ${SCM_SOURCE_ROOT_DIR} ${SCM_SINGLE_TARGET_SOURCE})
        list(APPEND SCM_TARGET_SOURCES_ABSOLUTE_PATHS ${SCM_SOURCE_ABS_PATH})
    endforeach()

    set(SCM_CUSTOM_TARGET_NAME ${SCM_TARGET_NAME}-static-analyze)
    message(STATUS "Creating `${SCM_CUSTOM_TARGET_NAME}` target")

    add_custom_target(
        ${SCM_CUSTOM_TARGET_NAME}
        COMMAND ${CMAKE_CXX_COMPILER} ${SCM_ANALYZER_OPTIONS} ${SCM_TARGET_SOURCES_ABSOLUTE_PATHS}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )

    set_target_properties(${SCM_CUSTOM_TARGET_NAME} PROPERTIES EXCLUDE_FROM_ALL TRUE)
endfunction()
