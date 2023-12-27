# SCM_ prefix is used to mark variables that come from SimpleCmakeModules

# =======================================================================================================================================
# ====================================================== Doxygen target generation ======================================================
# =======================================================================================================================================

# scm_create_docs_target(<doxyfile_location_folder>)
#
# This function will create a `docs` target that will generate doxygen documentation when built
#
# doxyfile_location_folder - Path to folder where the Doxyfile is located
#                            This will also be the output folder for the generated documentation
function(scm_create_docs_target SCM_FOLDER_WITH_DOXYFILE)
    find_package(Doxygen)

    if(DOXYGEN_FOUND)
        message(STATUS "Creating `docs` target for generating doxygen documentation")

        set(SCM_DOXYGEN_TARGET_NAME docs)

        add_custom_target(
            ${SCM_DOXYGEN_TARGET_NAME}
            ${DOXYGEN_EXECUTABLE}
            WORKING_DIRECTORY ${SCM_FOLDER_WITH_DOXYFILE}
        )

        set_target_properties(${SCM_DOXYGEN_TARGET_NAME} PROPERTIES EXCLUDE_FROM_ALL TRUE)
    else()
        message(STATUS "Could not find doxygen executable. Cannot create `docs` target")
    endif()
endfunction()
