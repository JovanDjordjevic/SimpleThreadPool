BUILD_TYPE_LINUX = Debug
# BUILD_TYPE_LINUX = Release
GENERATOR_LINUX = "Unix Makefiles"
COMPILER_LINUX = g++
# COMPILER_LINUX = clang++

ENABLE_DOXYGEN_LINUX = ON
ENABLE_BUILD_TESTS_LINUX = ON
ENABLE_COVERAGE_REPORT_LINUX = ON
ENABLE_BUILD_EXAMPLES_LINUX = ON
ENABLE_CALLGRIND_LINUX = ON
ENABLE_STATIC_ANALYSIS_LINUX = ON
ENABLE_BRUTAL_COMPILE_OPTIONS_LINUX = ON
ENABLE_SANITIZERS_LINUX = ON

do_cmake_linux:
	rm -rf build && \
	mkdir build &&	\
	cd build &&	\
	cmake -G $(GENERATOR_LINUX) \
		  -DCMAKE_CXX_COMPILER=$(COMPILER_LINUX) \
		  -DCMAKE_BUILD_TYPE=$(BUILD_TYPE_LINUX) \
		  -DSTP_ENABLE_DOXYGEN=$(ENABLE_DOXYGEN_LINUX) \
		  -DSTP_ENABLE_BUILD_TESTS=$(ENABLE_BUILD_TESTS_LINUX) \
		  -DSTP_ENABLE_COVERAGE_REPORT=$(ENABLE_COVERAGE_REPORT_LINUX) \
		  -DSTP_ENABLE_BUILD_EXAMPLES=$(ENABLE_BUILD_EXAMPLES_LINUX) \
		  -DSTP_ENABLE_CALLGRIND_TARGETS=$(ENABLE_CALLGRIND_LINUX) \
		  -DSTP_ENABLE_STATIC_ANALYSIS=$(ENABLE_STATIC_ANALYSIS_LINUX) \
		  -DSTP_ENABLE_BRUTAL_COMPILE_OPTIONS=$(ENABLE_BRUTAL_COMPILE_OPTIONS_LINUX) \
		  -DSTP_ENABLE_SANITIZERS=$(ENABLE_SANITIZERS_LINUX) \
		  .. && \
	cmake --build . && \
	cmake --build . --target ccov-all && \
	cmake --build . --target docs && \
	ctest --verbose
#	ctest -T Test -T Coverage

# =====================================================================================================

BUILD_TYPE_WINDOWS = Debug
# BUILD_TYPE_WINDOWS = Release
WINDOWS_CTEST_CONFIGURATION = $(BUILD_TYPE_WINDOWS)
GENERATOR_WINDOWS = "Visual Studio 17 2022"

ENABLE_DOXYGEN_WINDOWS = OFF
ENABLE_BUILD_TESTS_WINDOWS = ON
ENABLE_COVERAGE_REPORT_WINDOWS = OFF
ENABLE_BUILD_EXAMPLES_WINDOWS = ON
ENABLE_CALLGRIND_WINDOWS = OFF
ENABLE_STATIC_ANALYSIS_WINDOWS = ON
ENABLE_BRUTAL_COMPILE_OPTIONS_WINDOWS = ON
ENABLE_SANITIZERS_WINDOWS = OFF

# visual studio generator
do_cmake_windows_vs:
	echo Y | \
	rmdir /S build && \
	mkdir build &&	\
	cd build &&	\
	cmake -G $(GENERATOR_WINDOWS) \
		  -DSTP_ENABLE_DOXYGEN=$(ENABLE_DOXYGEN_WINDOWS) \
		  -DSTP_ENABLE_BUILD_TESTS=$(ENABLE_BUILD_TESTS_WINDOWS) \
		  -DSTP_ENABLE_COVERAGE_REPORT=$(ENABLE_COVERAGE_REPORT_WINDOWS) \
		  -DSTP_ENABLE_BUILD_EXAMPLES=$(ENABLE_BUILD_EXAMPLES_WINDOWS) \
		  -DSTP_ENABLE_CALLGRIND_TARGETS=$(ENABLE_CALLGRIND_WINDOWS) \
		  -DSTP_ENABLE_STATIC_ANALYSIS=$(ENABLE_STATIC_ANALYSIS_WINDOWS) \
		  -DSTP_ENABLE_BRUTAL_COMPILE_OPTIONS=$(ENABLE_BRUTAL_COMPILE_OPTIONS_WINDOWS) \
		  -DSTP_ENABLE_SANITIZERS=$(ENABLE_SANITIZERS_WINDOWS) \
		  .. && \
	cmake --build . --target ALL_BUILD --config $(BUILD_TYPE_WINDOWS) && \
	ctest --verbose -C $(WINDOWS_CTEST_CONFIGURATION)

# for windows with nmake file generator
do_cmake_windows_nmake:
	echo Y | \
	rmdir /S build && \
	mkdir build &&	\
	cd build &&	\
	cmake -G "NMake Makefiles" \
		  -DSTP_ENABLE_DOXYGEN=$(ENABLE_DOXYGEN_WINDOWS) \
		  -DSTP_ENABLE_BUILD_TESTS=$(ENABLE_BUILD_TESTS_WINDOWS) \
		  -DSTP_ENABLE_COVERAGE_REPORT=$(ENABLE_COVERAGE_REPORT_WINDOWS) \
		  -DSTP_ENABLE_BUILD_EXAMPLES=$(ENABLE_BUILD_EXAMPLES_WINDOWS) \
		  -DSTP_ENABLE_CALLGRIND_TARGETS=$(ENABLE_CALLGRIND_WINDOWS) \
		  -DSTP_ENABLE_STATIC_ANALYSIS=$(ENABLE_STATIC_ANALYSIS_WINDOWS) \
		  -DSTP_ENABLE_BRUTAL_COMPILE_OPTIONS=$(ENABLE_BRUTAL_COMPILE_OPTIONS_WINDOWS) \
		  -DSTP_ENABLE_SANITIZERS=$(ENABLE_SANITIZERS_WINDOWS) \
		  .. && \
	cmake --build . && \
	ctest --verbose
