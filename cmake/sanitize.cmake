# SCM_ prefix is used to mark variables that come from SimpleCmakeModules

# At the time of writing this, g++13 and clang++17 were used for testing

# It is up to the user to make sure that the sanitizer they want to use
# is available on the compiler version and OS they use 

# =======================================================================================================================================
# ========================================================== Address Sanitizer ==========================================================
# =======================================================================================================================================

# scm_add_address_sanitizer(<your_target_name> <property_specifier>)
#
# This function will add address sanitizer to your target (and will not set any other compiler options)
#
# your_target_name - name of your target
# property_specifier - set this to PUBLIC/PRIVATE/INTERFACE to set rules to what other taregts/dependencies these compiler flags will be applied to
#                      behavior is the same as in `target_compile_options`
function(scm_add_address_sanitizer SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    message(STATUS "Adding Address Sanitizer to target to target: ${SCM_TARGET_NAME} with ${SCM_PROP_SPECIFIER} target property specifier")

    set(SCM_ASAN_OPTIONS 
        -g
        -fsanitize=address
    )

    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_ASAN_OPTIONS})
    target_link_libraries(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_ASAN_OPTIONS})
endfunction()

# same as scm_add_address_sanitizer, but also adds useful compiler options for easier debugging with asan
function(scm_add_address_sanitizer_with_options SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    scm_add_address_sanitizer(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER})

    message(STATUS "Adding additional options for use with Address Sanitizer")

    set(SCM_ASAN_ADDITIONAL_FLAGS
        -fno-omit-frame-pointer
        -fno-optimize-sibling-calls 
        -fno-common 
        -fsanitize-address-use-after-scope 
        -fno-sanitize-recover
    )

    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_ASAN_ADDITIONAL_FLAGS})
    target_link_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_ASAN_ADDITIONAL_FLAGS})
endfunction()

# =======================================================================================================================================
# ==================================================== Undefined Behavior Sanitizer =====================================================
# =======================================================================================================================================

# scm_add_undefined_behavior_sanitizer(<your_target_name> <property_specifier>)
#
# This function will add undefined behavior sanitizer to your target (and will not set any other compiler options)
#
# your_target_name - name of your target
# property_specifier - set this to PUBLIC/PRIVATE/INTERFACE to set rules to what other taregts/dependencies these compiler flags will be applied to
#                      behavior is the same as in `target_compile_options`
function(scm_add_undefined_behavior_sanitizer SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    message(STATUS "Adding Undefined Behavior Sanitizer to target to target: ${SCM_TARGET_NAME} with ${SCM_PROP_SPECIFIER} target property specifier")

    set(SCM_UBSAN_OPTIONS 
        -g
        -fsanitize=undefined
    )

    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_UBSAN_OPTIONS})
    target_link_libraries(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_UBSAN_OPTIONS})
endfunction()

# same as scm_add_undefined_behavior_sanitizer, but also adds useful compiler options for easier debugging with ubsan
function(scm_add_undefined_behavior_sanitizer_with_options SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    scm_add_undefined_behavior_sanitizer(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER})

    message(STATUS "Adding additional options for use with Undefined Behavior Sanitizer")

    set(SCM_UBSAN_ADDITIONAL_FLAGS
        -fno-omit-frame-pointer
        -fno-optimize-sibling-calls 
        -fno-common 
        -fno-sanitize-recover
        -fno-inline
    )

    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_UBSAN_ADDITIONAL_FLAGS})
    target_link_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_UBSAN_ADDITIONAL_FLAGS})
endfunction()

# =======================================================================================================================================
# ========================================================== Thread Sanitizer ===========================================================
# =======================================================================================================================================

# scm_add_thread_sanitizer(<your_target_name> <property_specifier>)
#
# This function will add thread sanitizer to your target (and will not set any other compiler options)
#
# your_target_name - name of your target
# property_specifier - set this to PUBLIC/PRIVATE/INTERFACE to set rules to what other taregts/dependencies these compiler flags will be applied to
#                      behavior is the same as in `target_compile_options`
function(scm_add_thread_sanitizer SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    message(STATUS "Adding Thread Behavior Sanitizer to target to target: ${SCM_TARGET_NAME} with ${SCM_PROP_SPECIFIER} target property specifier")

    set(SCM_TSAN_OPTIONS 
        -g
        -fsanitize=thread
    )

    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_TSAN_OPTIONS})
    target_link_libraries(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_TSAN_OPTIONS})
endfunction()

# same as scm_add_thread_sanitizer, but also adds useful compiler options for easier debugging with tsan
function(scm_add_thread_sanitizer_with_options SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    scm_add_thread_sanitizer(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER})

    message(STATUS "Adding additional options for use with Thread Sanitizer")

    set(SCM_TSAN_ADDITIONAL_FLAGS
        -fno-omit-frame-pointer
        -fno-optimize-sibling-calls 
        -fno-common 
        -fno-sanitize-recover
        -fno-inline
    )

    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_TSAN_ADDITIONAL_FLAGS})
    target_link_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_TSAN_ADDITIONAL_FLAGS})
endfunction()

# =======================================================================================================================================
# ========================================================== Memory Sanitizer ===========================================================
# =======================================================================================================================================

# scm_add_memory_sanitizer(<your_target_name> <property_specifier>)
#
# This function will add memory sanitizer to your target (and will not set any other compiler options)
#
# your_target_name - name of your target
# property_specifier - set this to PUBLIC/PRIVATE/INTERFACE to set rules to what other taregts/dependencies these compiler flags will be applied to
#                      behavior is the same as in `target_compile_options`
function(scm_add_memory_sanitizer SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    message(STATUS "Adding Memory Behavior Sanitizer to target to target: ${SCM_TARGET_NAME} with ${SCM_PROP_SPECIFIER} target property specifier")

    set(SCM_MSAN_OPTIONS 
        -g
        -fsanitize=memory
    )

    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_MSAN_OPTIONS})
    target_link_libraries(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_MSAN_OPTIONS})
endfunction()

# same as scm_add_memory_sanitizer, but also adds useful compiler options for easier debugging with msan
function(scm_add_memory_sanitizer_with_options SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    scm_add_memory_sanitizer(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER})

    message(STATUS "Adding additional options for use with Memory Sanitizer")

    set(SCM_MSAN_ADDITIONAL_FLAGS
        -fno-sanitize-recover
        -fno-omit-frame-pointer
        -fsanitize-memory-track-origins
        -fsanitize-memory-use-after-dtor
    )

    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_MSAN_ADDITIONAL_FLAGS})
    target_link_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_MSAN_ADDITIONAL_FLAGS})
endfunction()

# =======================================================================================================================================
# =========================================================== Leak Sanitizer ============================================================
# =======================================================================================================================================

# scm_add_leak_sanitizer(<your_target_name> <property_specifier>)
#
# This function will add leak sanitizer to your target (and will not set any other compiler options)
# NOTE: leak sanitizer is included in address sanitizer by default
#
# your_target_name - name of your target
# property_specifier - set this to PUBLIC/PRIVATE/INTERFACE to set rules to what other taregts/dependencies these compiler flags will be applied to
#                      behavior is the same as in `target_compile_options`
function(scm_add_leak_sanitizer SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    message(STATUS "Adding Leak Behavior Sanitizer to target to target: ${SCM_TARGET_NAME} with ${SCM_PROP_SPECIFIER} target property specifier")

    set(SCM_LSAN_OPTIONS 
        -g
        -fsanitize=leak
    )

    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_LSAN_OPTIONS})
    target_link_libraries(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_LSAN_OPTIONS})
endfunction()

# same as scm_add_leak_sanitizer, but also adds useful compiler options for easier debugging with lsan
function(scm_add_leak_sanitizer_with_options SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    scm_add_leak_sanitizer(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER})

    message(STATUS "Adding additional options for use with Leak Sanitizer")

    set(SCM_LSAN_ADDITIONAL_FLAGS
        -fno-sanitize-recover
        -fno-omit-frame-pointer
    )

    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_LSAN_ADDITIONAL_FLAGS})
    target_link_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_LSAN_ADDITIONAL_FLAGS})
endfunction()
