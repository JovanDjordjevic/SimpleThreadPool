# SCM_ prefix is used to mark variables that come from SimpleCmakeModules

# =======================================================================================================================================
# ====================================================== Callgrind and kcachegrind ======================================================
# =======================================================================================================================================

# scm_create_grind_target(<your_target_name>)
#
# This function will create a target called your_target_name-grind, which when
# built will run callgrind on your executable, and then show you human readable kcachegrind output
#
# your_target_name - name of your executable target
function(scm_create_grind_target SCM_TARGET_NAME)
    find_program(SCM_VALGRIND_EXECUTABLE valgrind)
    if(NOT SCM_VALGRIND_EXECUTABLE)
        message(FATAL_ERROR "Error: 'valgrind' executable not found. Please install Valgrind.")
    endif()

    find_program(SCM_KCACHEGRIND_EXECUTABLE kcachegrind)
    if(NOT SCM_KCACHEGRIND_EXECUTABLE)
        message(FATAL_ERROR "Error: 'kcachegrind' executable not found. Please install KCacheGrind.")
    endif()

    set(SCM_CUSTOM_TARGET_NAME ${SCM_TARGET_NAME}-grind)
    
    add_custom_target(
        ${SCM_CUSTOM_TARGET_NAME}
        COMMAND ${SCM_VALGRIND_EXECUTABLE} --tool=callgrind --callgrind-out-file=${SCM_TARGET_NAME}.callgrind.out $<TARGET_FILE:${SCM_TARGET_NAME}>
        COMMAND ${SCM_KCACHEGRIND_EXECUTABLE} ${SCM_TARGET_NAME}.callgrind.out
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Opening Callgrind output with KCacheGrind"
    )

    set_target_properties(${SCM_CUSTOM_TARGET_NAME} PROPERTIES EXCLUDE_FROM_ALL TRUE)
endfunction()
