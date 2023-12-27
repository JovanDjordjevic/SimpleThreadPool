# SCM_ prefix is used to mark variables that come from SimpleCmakeModules

# The following compiler minimum versions are supported by this module:
# gcc 9.0
# clang 10.0
# msvc 19.0

# =======================================================================================================================================
# ============================================================= GCC options =============================================================
# =======================================================================================================================================

# for gcc 9.x. These options will always be included, and when a greater compiler version is detected,
# the flags added in that version will be appended to this list (added flags are ones that are not enabled 
# by -Wall, -Wextra or any other flags in that specific compiler version)
set(SCM_GCC_9_OPTIONS
    -Wall                               # This enables all the warnings about constructions that some users consider questionable, and that are easy to avoid 
    -Wextra                             # This enables some extra warning flags that are not enabled by -Wall.
    -pedantic-errors                    # Issue all the warnings demanded by strict ISO C and ISO C ++. Like -pedantic, except that errors are produced rather than warnings
    -Wctor-dtor-privacy                 # Warn when a class seems unusable because all the constructors or destructors in that class are private, and it has neither friends nor public static member functions.
    -Weffc++                            # Warn about violations of the following style guidelines from Scott Meyers' Effective C ++ book (std headers do not obey all guidelines!!)
    -Wstrict-null-sentinel              # Warn also about the use of an uncasted "NULL" as sentinel.
    -Wold-style-cast                    # Warn if an old-style (C-style) cast to a non-void type is used
    -Woverloaded-virtual                # Warn when a function declaration hides virtual functions from a base class
    -Wsign-promo                        # Warn when overload resolution chooses a promotion from unsigned or enumerated type to a signed type, over a conversion to an unsigned type of the same size
    -Wformat=2                          # Check calls to printf and scanf, etc., to make sure that the arguments supplied have types appropriate to the format string specified, and that the conversions specified in the format string make sense. Gives more errors than just -Wformat that is already included in -Wall
    -Wformat-overflow=2                 # Warn about calls to formatted input/output functions such as sprintf and vsprintf that might overflow the destination buffer.
    -Wformat-signedness                 # If -Wformat is specified, also warn if the format string requires an unsigned argument and the argument is signed and vice versa.
    -Wformat-truncation=2               # Warn about calls to formatted input/output functions such as snprintf and vsnprintf that might result in output truncation
    -Winit-self                         # Warn about uninitialized variables which are initialized with themselves
    -Wmissing-include-dirs              # Warn if a user-supplied include directory does not exist
    -Wswitch-default                    # Warn whenever a "switch" statement does not have a "default" case.
    -Wswitch-enum                       # Warn whenever a "switch" statement has an index of enumerated type and lacks a "case" for one or more of the named codes of that enumeration. "case" labels outside the enumeration range also provoke warnings when this option is used.
    -Wsync-nand                         # Warn when "__sync_fetch_and_nand" and "__sync_nand_and_fetch" built-in functions are used. These functions changed semantics in GCC 4.4.
    -Wunused-but-set-parameter          # Warn whenever a function parameter is assigned to, but otherwise unused (aside from its declaration).
    -Wunused-but-set-variable           # Warn whenever a local variable is assigned to, but otherwise unused (aside from its declaration)
    -Wunused-parameter                  # Warn whenever a function parameter is unused aside from its declaration.
    -Wunknown-pragmas                   # Warn when a #pragma directive is encountered which is not understood by GCC
    -Wstrict-overflow=4                 # warns about cases where the compiler optimizes based on the assumption that signed overflow does not occur
    -Wfloat-equal                       # Warn if floating point values are used in equality comparisons.
    -Wundef                             # Warn if an undefined identifier is evaluated in an #if directive.
    -Wshadow                            # Warn whenever a local variable shadows another local variable, parameter or global variable or whenever a built-in function is shadowed.
    -Wcast-qual                         # Warn whenever a pointer is cast so as to remove a type qualifier from the target type. 
    -Wcast-align                        # Warn whenever a pointer is cast such that the required alignment of the target is increased
    -Wconversion                        # Warn for implicit conversions that may alter a value.
    -Wsign-conversion                   # Warn for implicit conversions that may change the sign of an integer value
    -Wlogical-op                        # Warn about suspicious uses of logical operators in expressions
    -Wmissing-declarations              # Warn if a global function is defined without a previous declaration
    -Wmissing-noreturn                  # Warn about functions which might be candidates for attribute "noreturn".
    -Wmissing-format-attribute          # Warn about function pointers which might be candidates for "format" attributes. 
    -Wpacked                            # Warn if a structure is given the packed attribute, but the packed attribute has no effect on the layout or size of the structure
    -Wredundant-decls                   # Warn if anything is declared more than once in the same scope, even in cases where multiple declaration is valid and changes nothing.
    -Winvalid-pch                       # Warn if a precompiled header is found in the search path but can't be used.
    -Wvla                               # Warn if variable length array is used in the code.
    -Wdouble-promotion                  # Give a warning when a value of type float is implicitly promoted to double.
    -Wnull-dereference                  # Warn if the compiler detects paths that trigger erroneous or undefined behavior due to dereferencing a null pointer
    -Wimplicit-fallthrough              # Warn when a switch case falls through
    -Wunused-const-variable=1           # Warn whenever a constant static variable is unused aside from its declaration.
    -Wstringop-truncation               # Warn for calls to bounded string manipulation functions such as strncat, strncpy, and stpncpy that may either truncate the copied string or leave the destination unchanged.
    -Wsuggest-final-types               # Warn about types with virtual methods where code quality would be improved if the type were declared with the C++11 final specifier, or, if possible, declared in an anonymous namespace.
    -Wsuggest-final-methods             # Warn about virtual methods where code quality would be improved if the method were declared with the C++11 final specifier, or, if possible, its type were declared in an anonymous namespace or with the final specifier.
    -Wsuggest-override                  # Warn about overriding virtual functions that are not marked with the override keyword.
    -Walloca                            # This option warns on all uses of alloca in the source.
    -Wduplicated-branches               # Warn when an if-else has identical branches.
    -Wduplicated-cond                   # Warn about duplicated conditions in an if-else-if chain
    -Wplacement-new=2                   # Warn about placement new expressions with undefined behavior, such as constructing an object in a buffer that is smaller than the type of the object.
    -Wunused-macros                     # Warn about macros defined in the main file that are unused
    -Wconditionally-supported           # Warn for conditionally-supported constructs.
    -Wzero-as-null-pointer-constant     # Warn when a literal ‘0’ is used as null pointer constant. 
    -Wdate-time                         # Warn when macros __TIME__, __DATE__ or __TIMESTAMP__ are encountered as they might prevent bit-wise-identical reproducible compilations.
    -Wno-multichar                      # Do not warn if a multicharacter constant (‘'FOOF'’) is used. Usually they indicate a typo in the user’s code, as they have implementation-defined values, and should not be used in portable code.
    -Wvariadic-macros                   # Warn if variadic macros are used in ISO C90 mode, or if the GNU alternate syntax is used in ISO C99 mode
    -Wvarargs                           # Warn upon questionable usage of the macros used to handle variable arguments like va_start
    -Wextra-semi                        # Warn about redundant semicolon after in-class function definition.
    -Wuseless-cast                      # Warn when an expression is casted to its own type.
    -Wnoexcept                          # Warn when a noexcept-expression evaluates to false because of a call to a function that does not have a non-throwing exception specification (i.e. throw() or noexcept) but is known by the compiler to never throw an exception.
    -Wnoexcept-type                     # Warn if the C++17 feature making noexcept part of a function type changes the mangled name of a symbol relative to C++14.
    -Wregister                          # Warn on uses of the register storage class specifier, except when it is part of the GNU Explicit Register Variables extension
    -Wunsafe-loop-optimizations         # Warn if the loop cannot be optimized because the compiler could not assume anything on the bounds of the loop indices    
)

set(SCM_GCC_10_OPTIONS
    -Warith-conversion                  # Do warn about implicit conversions from arithmetic operations even when conversion of the operands to the same type cannot change their values.
    -Wzero-length-bounds                # Warn about accesses to elements of zero-length array members that might overlap other members of the same objec
    -Wrestrict                          # Warn when an object referenced by a restrict-qualified parameter (or, in C++, a __restrict-qualified parameter) is aliased by another argument, or when copies between such objects overlap
    -Wcomma-subscript                   # Warn about uses of a comma expression within a subscripting expression.
    -Wredundant-tags                    # Warn about redundant class-key and enum-key in references to class types and enumerated types in contexts where the key can be eliminated without causing an ambiguity
    -Wmismatched-tags                   # Warn for declarations of structs, classes, and class templates and their specializations with a class-key that does not match either the definition or the first declaration if no definition is provided
    -Wvolatile                          # Warn about deprecated uses of the volatile qualifier
    -Wcatch-value                       # Warn about catch handlers that do not catch via reference
    -Wsized-deallocation                # Warn about a definition of an unsized deallocation function
)

set(SCM_GCC_11_OPTIONS
    -Wenum-conversion                   # Warn when a value of enumerated type is implicitly converted to a different enumerated type
    -Winvalid-imported-macros           # Verify all imported macro definitions are valid at the end of compilation
    -Wctad-maybe-unsupported            # Warn when performing class template argument deduction (CTAD) on a type with no explicitly written deduction guides
)

set(SCM_GCC_12_OPTIONS
    -Wtrivial-auto-var-init             # Warn when -ftrivial-auto-var-init cannot initialize the automatic variable
    -Wbidi-chars=any,ucn                # Warn about possibly misleading UTF-8 bidirectional control characters in comments, string literals, character constants, and identifiers
    -Wopenacc-parallelism               # Warn about potentially suboptimal choices related to OpenACC parallelism.
    -Winterference-size                 # Warn about use of C++17 std::hardware_destructive_interference_size without specifying its value with --param destructive-interference-size. Also warn about questionable values for that option
)

set(SCM_GCC_13_OPTIONS
    -Winvalid-utf8                      # Warn if an invalid UTF-8 character is found.
    -Wxor-used-as-pow                   # Warn about uses of ^, the exclusive or operator, where it appears the user meant exponentiation
    -Winvalid-constexpr                 # Warn when a function never produces a constant expression. 
)

# Some flags you may wish to pass as optional argument(s) in scm_add_brutal_compiler_options
# to suppress some common spammy warnings or warnings that give false positives
#   -Wno-unsafe-loop-optimizations      # suppress warning that the loop cannot be optimized because the compiler could not assume anything on the bounds of the loop indices

# =======================================================================================================================================
# ============================================================ CLANG options ============================================================
# =======================================================================================================================================

# for clang 10.x. These options will always be included, and when a greater compiler version is detected,
# the flags added in that version will be appended to this list (added flags are ones that are not enabled 
# by -Wall, -Wextra or any other flags in that specific compiler version)
set(SCM_CLANG_10_OPTIONS
    -Wall
    -Wextra
    -Wpedantic
    -Wabstract-vbase-init
    -Walloca
    -Wanon-enum-enum-conversion
    -Warc-repeated-use-of-weak
    -Warc-maybe-repeated-use-of-weak
    -Warray-bounds-pointer-arithmetic
    -Wassign-enum
    -Watomic-implicit-seq-cst
    -Wbad-function-cast
    -Wbind-to-temporary-copy
    -Wbitfield-enum-conversion
    -Wbitwise-op-parentheses
    -Wbool-conversions
    -Wcast-align
    -Wcast-qual
    -Wchar-subscripts
    -Wcomment
    -Wcomplex-component-init
    -Wconditional-uninitialized 
    -Wconsumed
    -Wconversion
    -Wconversion-null
    -Wcoroutine-missing-unhandled-exception
    -Wcstring-format-directive
    -Wctad-maybe-unsupported
    -Wcustom-atomic-properties
    -Wdate-time
    -Wdelete-non-abstract-non-virtual-dtor
    -Wdeprecated-copy
    -Wdeprecated-copy-dtor
    -Wdeprecated-dynamic-exception-spec
    -Wdeprecated-implementations
    -Wdeprecated-this-capture
    -Wdisabled-macro-expansion
    -Wduplicate-decl-specifier
    -Wduplicate-enum
    -Wduplicate-method-arg
    -Wduplicate-method-match
    -Weffc++
    -Wembedded-directive
    -Wempty-init-stmt
    -Wempty-translation-unit
    -Wenum-conversion
    -Wenum-enum-conversion
    -Wenum-float-conversion
    -Wexit-time-destructors
    -Wexpansion-to-defined
    -Wexplicit-ownership-type
    -Wextra-semi
    -Wextra-semi-stmt
    -Wfixed-enum-extension
    -Wflexible-array-extensions
    -Wfloat-conversion
    -Wfloat-equal
    -Wfloat-overflow-conversion
    -Wfloat-zero-conversion
    -Wfor-loop-analysis
    -Wformat=2
    -Wformat-non-iso
    -Wformat-nonliteral
    -Wformat-pedantic
    -Wformat-type-confusion
    -Wfour-char-constants
    -Wglobal-constructors
    -Wgnu-anonymous-struct
    -Wgnu-auto-type
    -Wgnu-binary-literal
    -Wgnu-case-range
    -Wgnu-complex-integer
    -Wgnu-compound-literal-initializer
    -Wgnu-conditional-omitted-operand
    -Wgnu-empty-initializer
    -Wgnu-empty-struct
    -Wgnu-flexible-array-initializer
    -Wgnu-flexible-array-union-member
    -Wgnu-folding-constant
    -Wgnu-imaginary-constant
    -Wgnu-include-next
    -Wgnu-label-as-value
    -Wgnu-redeclared-enum
    -Wgnu-statement-expression
    -Wgnu-union-cast
    -Wgnu-zero-line-directive
    -Wgnu-zero-variadic-macro-arguments
    -Wheader-hygiene
    -Widiomatic-parentheses
    -Wimplicit-atomic-properties
    -Wimplicit-fallthrough
    -Wimplicit-fallthrough-per-function
    -Wimplicit-float-conversion
    -Wimplicit-function-declaration
    -Wimplicit-int-conversion
    -Wimplicit-int-float-conversion
    -Wimplicit-retain-self
    -Wimport-preprocessor-directive-pedantic
    -Wincomplete-module
    -Winconsistent-missing-destructor-override
    -Winfinite-recursion
    -Wint-in-bool-context
    -Winvalid-or-nonexistent-directory
    -Wkeyword-macro
    -Wlanguage-extension-token
    -Wlocal-type-template-args
    -Wlogical-op-parentheses
    -Wmain
    -Wmethod-signatures
    -Wmicrosoft
    -Wmicrosoft-charize
    -Wmicrosoft-comment-paste
    -Wmicrosoft-cpp-macro
    -Wmicrosoft-end-of-file
    -Wmicrosoft-enum-value
    -Wmicrosoft-exception-spec
    -Wmicrosoft-fixed-enum
    -Wmicrosoft-flexible-array
    -Wmicrosoft-redeclare-static
    -Wmisleading-indentation
    -Wmismatched-tags
    -Wmissing-braces
    -Wmissing-field-initializers
    -Wmissing-method-return-type
    -Wmissing-noreturn
    -Wmissing-prototypes
    -Wmissing-variable-declarations
    -Wmost
    -Wmove
    -Wnarrowing
    -Wnested-anon-types
    -Wnewline-eof
    -Wnon-modular-include-in-framework-module
    -Wnon-modular-include-in-module
    -Wnon-virtual-dtor
    -Wnonportable-system-include-path
    -Wnull-pointer-arithmetic
    -Wnullability-extension
    -Wnullable-to-nonnull-conversion
    -Wold-style-cast
    -Wover-aligned
    -Woverlength-strings
    -Woverloaded-virtual
    -Woverriding-method-mismatch
    -Wpacked
    -Wpadded
    -Wparentheses
    -Wpedantic-core-features
    -Wpessimizing-move
    -Wpointer-arith
    -Wpoison-system-directories
    -Wpragma-pack
    -Wpragma-pack-suspicious-include
    -Wpragmas
    -Wrange-loop-analysis
    -Wrange-loop-bind-reference
    -Wrange-loop-construct
    -Wredundant-move
    -Wredundant-parens
    -Wreorder
    -Wreorder-ctor
    -Wreserved-id-macro
    -Wretained-language-linkage
    -Wreturn-std-move
    -Wselector
    -Wselector-type-mismatch
    -Wself-assign
    -Wself-assign-overloaded
    -Wself-move
    -Wsemicolon-before-method-body
    -Wshadow
    -Wshadow-all
    -Wshadow-field
    -Wshadow-field-in-constructor
    -Wshadow-field-in-constructor-modified
    -Wshadow-uncaptured-local
    -Wshift-sign-overflow
    -Wshorten-64-to-32
    -Wsign-compare
    -Wsign-conversion
    -Wsigned-enum-bitfield
    -Wspir-compat
    -Wstatic-in-inline
    -Wstrict-prototypes
    -Wstrict-selector-match
    -Wstring-conversion
    -Wsuper-class-method-mismatch
    -Wswitch-enum
    -Wtautological-bitwise-compare
    -Wtautological-constant-in-range-compare
    -Wtautological-overlap-compare
    -Wtautological-type-limit-compare
    -Wtautological-unsigned-enum-zero-compare
    -Wtautological-unsigned-zero-compare
    -Wthread-safety
    -Wthread-safety-analysis
    -Wthread-safety-attributes
    -Wthread-safety-beta
    -Wthread-safety-negative
    -Wthread-safety-precise
    -Wthread-safety-reference
    -Wthread-safety-verbose
    -Wundeclared-selector
    -Wundef
    -Wundefined-func-template
    -Wundefined-internal-type
    -Wundefined-reinterpret-cast
    -Wunguarded-availability
    -Wuninitialized
    -Wunknown-pragmas
    -Wunnamed-type-template-args
    -Wunneeded-internal-declaration
    -Wunneeded-member-function
    -Wunreachable-code
    -Wunreachable-code-aggressive
    -Wunreachable-code-break
    -Wunreachable-code-loop-increment
    -Wunreachable-code-return
    -Wunsupported-dll-base-class-template
    -Wunused
    -Wunused-const-variable
    -Wunused-exception-parameter
    -Wunused-function
    -Wunused-label
    -Wunused-lambda-capture
    -Wunused-local-typedef
    -Wunused-macros
    -Wunused-member-function
    -Wunused-parameter
    -Wunused-private-field
    -Wunused-property-ivar
    -Wunused-template
    -Wused-but-marked-unused
    -Wvector-conversion
    -Wvla
    -Wweak-template-vtables
    -Wzero-as-null-pointer-constant
    -Wzero-length-array
)

set(SCM_CLANG_11_OPTIONS
    -Wframe-address
    -Wmax-tokens
    -Wsuggest-destructor-override
    -Wsuggest-override
    -Wundef-prefix
    -Wuninitialized-const-reference
)

set(SCM_CLANG_12_OPTIONS
    -Wcompletion-handler
    -Wcompound-token-split-by-space
    -Wfuse-ld-path
    -Wgnu-folding-constant
    -Wstring-concatenation
    -Wtautological-value-range-compare
)

set(SCM_CLANG_13_OPTIONS
    -Wcast-function-type
    -Wdeprecated-copy-with-dtor
    -Wdeprecated-copy-with-user-provided-copy
    -Wdeprecated-copy-with-user-provided-dtor
    -Wreserved-identifier
    -Wreserved-macro-identifier
    -Wtautological-unsigned-char-zero-compare
    -Wunused-but-set-parameter
    -Wunused-but-set-variable
)

set(SCM_CLANG_14_OPTIONS
    -Wbit-int-extension
    -Wbool-operation
    -Wbitwise-instead-of-logical
    -Wdelimited-escape-sequence-extension
    -Wunaligned-access
    -Wunreachable-code-fallthrough
)

set(SCM_CLANG_15_OPTIONS
    -Warray-parameter
    -Wgnu-line-marker
    -Wgnu-null-pointer-arithmetic
    -Wgnu-pointer-arith
    -Wgnu-statement-expression-from-macro-expansion
    -Wimplicit-int
    -Winvalid-utf8
)

set(SCM_CLANG_16_OPTIONS
    -Wcast-function-type-strict
    -Wgnu-offsetof-extensions
    -Wincompatible-function-pointer-types-strict
    -Wpacked-non-pod
    -Wunsafe-buffer-usage
)

set(SCM_CLANG_17_OPTIONS
    -Wdeprecated-literal-operator
    -Wdeprecated-redundant-constexpr-static-def
    -Wgeneric-type-extension
)

# Some flags you may wish to pass as optional argument(s) in scm_add_brutal_compiler_options
# to suppress some common spammy warnings or warnings that give false positives
#   -Wno-padded            # suppress the warning that compiler adds padding automatically in order to align class/structure members
#   -Wno-date-time         # suppress the warning that expansion of date or time macro is not reproducible

# =======================================================================================================================================
# ============================================================ MSVC options =============================================================
# =======================================================================================================================================

set(SCM_MSVC_19_OPTIONS
    /FC
    /permissive
    /Wall
)

# Some flags you may wish to pass as optional argument(s) in scm_add_brutal_compiler_options
# to suppress some common spammy warnings or warnings that give false positives
#   /wd4820            # suppress the: C4820 warning: 'bytes' bytes padding added after construct 'member_name'
#   /wd4514            # suppress the: C4514 warning: 'function' : unreferenced inline function has been removed
#   /wd4711            # suppress the: C4711 warning: 'function' :has been selected for inline expansion
#   /wd5045            # suppress the: C5045 warning: Compiler will insert Spectre mitigation for memory load if /Qspectre switch specified

# =======================================================================================================================================
# ==================================================== Functions for adding options =====================================================
# =======================================================================================================================================

# scm_add_brutal_compiler_options(<your_target_name> <property_specifier> [<additional_flags>...])
#
# This function will add additional compiler warning flags to your target based on your CMAKE_CXX_COMPILER_ID
#
# your_target_name - Name of your target
# property_specifier - Set this to one of:  PUBLIC/PRIVATE/INTERFACE to set rules to what other taregts/dependencies these compiler
#                      flags will be applied to behavior is the same as in `target_compile_options`
# [<additional_flags>...] - An optional list of additional compiler flags you wish to add to your target (for example explicitly
#                           disable some warnings that are not relevant to you or that are spammy)
function(scm_add_brutal_compiler_options SCM_TARGET_NAME SCM_PROP_SPECIFIER)
    set(SCM_ADDITIONAL_COMPILE_OPTIONS ${ARGN})

    message(STATUS "Adding brutal compile options to target: ${SCM_TARGET_NAME} with ${SCM_PROP_SPECIFIER} target property specifier")

    set(SCM_COMPILE_OPTIONS)

    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        message(STATUS "Detected GNU compiler, version: ${CMAKE_CXX_COMPILER_VERSION}")
        if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
            message(FATAL_ERROR "Error: GNU compiler version must be at least 9.0.0")
        endif()

        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "9.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_GCC_9_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "10.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_GCC_10_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "11.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_GCC_11_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "12.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_GCC_12_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "13.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_GCC_13_OPTIONS})
        endif()
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        message(STATUS "Detected Clang compiler, version: ${CMAKE_CXX_COMPILER_VERSION}")
        if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "10.0.0")
            message(FATAL_ERROR "Error: Clang compiler version must be at least 10.0.0")
        endif()

        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "10.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_CLANG_10_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "11.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_CLANG_11_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "12.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_CLANG_12_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "13.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_CLANG_13_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "14.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_CLANG_14_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "15.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_CLANG_15_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "16.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_CLANG_16_OPTIONS})
        endif()
        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "17.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_CLANG_17_OPTIONS})
        endif()
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        message(STATUS "Detected MSVC compiler, version: ${CMAKE_CXX_COMPILER_VERSION}")
        if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "19.0.0")
            message(FATAL_ERROR "Error: MSVC compiler version must be at least 19.0.0")
        endif()

        if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "19.0.0")
            list(APPEND SCM_COMPILE_OPTIONS ${SCM_MSVC_19_OPTIONS})
        endif()
    else()
        message("Compiler: Unknown or unsupported compiler")
    endif()

    list(APPEND SCM_COMPILE_OPTIONS ${SCM_ADDITIONAL_COMPILE_OPTIONS})
    target_compile_options(${SCM_TARGET_NAME} ${SCM_PROP_SPECIFIER} ${SCM_COMPILE_OPTIONS})
endfunction()
