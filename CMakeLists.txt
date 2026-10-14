# CMake build for PSPLINE
#
# This is an alternative to the Makefiles in the top-level directory. It
# covers the configurations handled by Makefile, Makefile_Flux,
# Makefile_Flux_ICC and Makefile_Ranger from a single description:
#
#   cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/path/to/prefix
#   cmake --build build -j 2
#   ctest --test-dir build
#   cmake --install build
#
# The compiler is selected with FC/CXX (or CMAKE_Fortran_COMPILER and
# CMAKE_CXX_COMPILER); see README.md for the available options.

cmake_minimum_required(VERSION 3.18)

# The project version follows the git release tags (vX.Y.Z), so that it does
# not have to be edited by hand. PSPLINE_VERSION can override it, e.g. when
# building from a source tarball without git metadata.
set(PSPLINE_VERSION "" CACHE STRING "Override the PSPLINE version (X.Y.Z)")
if(NOT PSPLINE_VERSION)
  find_package(Git QUIET)
  if(GIT_FOUND AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
    execute_process(
      COMMAND "${GIT_EXECUTABLE}" describe --tags --abbrev=0 --match "v[0-9]*"
      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
      OUTPUT_VARIABLE _pspline_git_tag
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_QUIET)
    string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+" _pspline_version "${_pspline_git_tag}")
  endif()
  if(NOT _pspline_version)
    set(_pspline_version "0.0.0")
  endif()
else()
  set(_pspline_version "${PSPLINE_VERSION}")
endif()

project(pspline
  VERSION ${_pspline_version}
  DESCRIPTION "Spline and Hermite interpolation of 1D, 2D and 3D data on rectilinear grids"
  HOMEPAGE_URL "https://github.com/PrincetonUniversity/pspline"
  LANGUAGES Fortran)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

# As with the Makefiles, the PREFIX environment variable (set by the files in
# config/) selects the installation directory unless CMAKE_INSTALL_PREFIX is
# given.
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT AND DEFINED ENV{PREFIX})
  set(CMAKE_INSTALL_PREFIX "$ENV{PREFIX}" CACHE PATH "Installation prefix" FORCE)
endif()

# Install libraries in lib/ (not lib64/) by default, as "make install" does.
if(NOT DEFINED CMAKE_INSTALL_LIBDIR)
  set(CMAKE_INSTALL_LIBDIR lib CACHE PATH "Object code libraries (lib)")
endif()
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
  set(_pspline_top_level ON)
else()
  set(_pspline_top_level OFF)
endif()

# ----------------------------------------------------------------------------
# Options
# ----------------------------------------------------------------------------

option(PSPLINE_BUILD_STATIC "Build the static library libpspline.a" ON)
option(PSPLINE_BUILD_SHARED "Build the shared library libpspline.so" OFF)
option(PSPLINE_SINGLE_PRECISION "Use single precision reals (-D_SINGLE_PRECISION)" OFF)
option(PSPLINE_BUILD_TESTS "Build the PSPLINE test programs" ${_pspline_top_level})
option(PSPLINE_INSTALL_TESTS "Install the test programs and reference outputs" OFF)
set(PSPLINE_WITH_NETCDF "AUTO" CACHE STRING "Enable NetCDF support (-D_NETCDF): AUTO, ON or OFF")
set_property(CACHE PSPLINE_WITH_NETCDF PROPERTY STRINGS AUTO ON OFF)

if(NOT PSPLINE_BUILD_STATIC AND NOT PSPLINE_BUILD_SHARED)
  message(FATAL_ERROR "At least one of PSPLINE_BUILD_STATIC and PSPLINE_BUILD_SHARED must be ON")
endif()

# Default to an optimised build with debug symbols (-O2 -g), as in the
# Makefiles.
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING
    "Build type: Debug, Release, RelWithDebInfo or MinSizeRel" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)
endif()

# ----------------------------------------------------------------------------
# NetCDF
# ----------------------------------------------------------------------------

string(TOUPPER "${PSPLINE_WITH_NETCDF}" PSPLINE_WITH_NETCDF)
if(PSPLINE_WITH_NETCDF STREQUAL "ON")
  find_package(NetCDF_Fortran REQUIRED)
elseif(PSPLINE_WITH_NETCDF STREQUAL "AUTO")
  find_package(NetCDF_Fortran)
elseif(NOT PSPLINE_WITH_NETCDF STREQUAL "OFF")
  message(FATAL_ERROR "PSPLINE_WITH_NETCDF must be AUTO, ON or OFF (got '${PSPLINE_WITH_NETCDF}')")
endif()
if(NetCDF_Fortran_FOUND)
  set(PSPLINE_HAVE_NETCDF ON)
else()
  set(PSPLINE_HAVE_NETCDF OFF)
endif()

# ----------------------------------------------------------------------------
# Compiler flags
#
# These are the flags that were selected per compiler in the Makefiles.
# Machine-specific tuning (e.g. -march=znver4) is left to the user through
# CMAKE_Fortran_FLAGS / FFLAGS.
# ----------------------------------------------------------------------------

set(_gnu   "$<COMPILE_LANG_AND_ID:Fortran,GNU>")
set(_intel "$<COMPILE_LANG_AND_ID:Fortran,Intel,IntelLLVM>")
set(_ifort "$<COMPILE_LANG_AND_ID:Fortran,Intel>")
set(_ifx   "$<COMPILE_LANG_AND_ID:Fortran,IntelLLVM>")
set(_nv    "$<COMPILE_LANG_AND_ID:Fortran,NVHPC,PGI>")
set(_debug "$<CONFIG:Debug>")

set(PSPLINE_Fortran_OPTIONS
  # Default REAL is 64 bit (-r8 is the short form of -real-size 64)
  "$<${_gnu}:-std=f2008;-fdefault-real-8>"
  "$<${_intel}:-r8;-auto-scalar>"
  "$<${_nv}:-r8>"
  # Run-time checks for Debug builds
  "$<$<AND:${_gnu},${_debug}>:-fcheck=all;-fbacktrace;-ffpe-trap=invalid$<COMMA>zero$<COMMA>overflow;-Wall>"
  "$<$<AND:${_intel},${_debug}>:-traceback;-fpe0>"
  "SHELL:$<$<AND:${_ifort},${_debug}>:-check all>"
  # ifx implements -check uninit with MemorySanitizer, which does not work
  # for a library linked into programs built with other compilers.
  "SHELL:$<$<AND:${_ifx},${_debug}>:-check all$<COMMA>nouninit>"
  "SHELL:$<$<AND:${_intel},${_debug}>:-warn all>"
  "$<$<AND:${_nv},${_debug}>:-traceback;-Mbounds>"
)

set(PSPLINE_Fortran_DEFINITIONS
  $<$<BOOL:${PSPLINE_HAVE_NETCDF}>:_NETCDF>
  $<$<BOOL:${PSPLINE_SINGLE_PRECISION}>:_SINGLE_PRECISION>
)

# ----------------------------------------------------------------------------
# Library
# ----------------------------------------------------------------------------

set(PSPLINE_SOURCES
  pspline/akherm1.f90 pspline/akherm2.f90 pspline/akherm3.f90
  pspline/bcspeval.f90 pspline/bcspgrid.f90 pspline/bcspline.f90
  pspline/bcspvec.f90 pspline/bpsplinb.f90 pspline/bpspline.f90
  pspline/cspeval.f90 pspline/cspline.f90 pspline/cubsplb.f90
  pspline/dnherm1.f90 pspline/dnherm2.f90 pspline/dnherm3.f90
  pspline/evbicub.f90 pspline/evintrp2d.f90 pspline/evintrp3d.f90
  pspline/evspline.f90 pspline/evtricub.f90 pspline/genxpkg.f90
  pspline/gridbicub.f90 pspline/gridherm1.f90 pspline/gridherm2.f90
  pspline/gridherm3.f90 pspline/gridintrp2d.f90 pspline/gridintrp3d.f90
  pspline/gridpc1.f90 pspline/gridpc2.f90 pspline/gridpc3.f90
  pspline/gridspline.f90 pspline/gridtricub.f90 pspline/herm1ev.f90
  pspline/herm2ev.f90 pspline/herm3ev.f90 pspline/ibc_ck.f90
  pspline/mkbicub.f90 pspline/mkbicubw.f90 pspline/mkherm1.f90
  pspline/mkherm2.f90 pspline/mkherm3.f90 pspline/mkintrp2d.f90
  pspline/mkintrp3d.f90 pspline/mkspl2p.f90 pspline/mkspl2pb.f90
  pspline/mkspl2z.f90 pspline/mkspl2zb.f90 pspline/mkspl3pb.f90
  pspline/mkspl3zb.f90 pspline/mkspline.f90 pspline/mktricub.f90
  pspline/mktricubw.f90 pspline/nspline.f90 pspline/pc1ev.f90
  pspline/pc2ev.f90 pspline/pc3ev.f90 pspline/precision_mod.f90
  pspline/psp_tolsum.f90 pspline/pspline.f90 pspline/pspltsub.f90
  pspline/seval.f90 pspline/seval2.f90 pspline/seval3.f90
  pspline/speval.f90 pspline/spgrid.f90 pspline/splaan.f90
  pspline/splbrk.f90 pspline/spleen.f90 pspline/splinck.f90
  pspline/spline.f90 pspline/spvec.f90 pspline/tcspeval.f90
  pspline/tcspgrid.f90 pspline/tcspline.f90 pspline/tcspvec.f90
  pspline/tpsplinb.f90 pspline/tpspline.f90 pspline/util_bcherm1.f90
  pspline/util_bcherm2.f90 pspline/util_bcherm3.f90 pspline/v_spline.f90
  pspline/vecbicub.f90 pspline/vecherm1.f90 pspline/vecherm2.f90
  pspline/vecherm3.f90 pspline/vecin2d_argchk.f90 pspline/vecin3d_argchk.f90
  pspline/vecintrp2d.f90 pspline/vecintrp3d.f90 pspline/vecpc1.f90
  pspline/vecpc2.f90 pspline/vecpc3.f90 pspline/vecspline.f90
  pspline/vectricub.f90 pspline/xlookup.f90 pspline/zonfind.f90

  ezspline/ezhybrid_init.f90 ezspline/ezhybrid_initx.f90
  ezspline/ezlinear_init.f90 ezspline/ezspline_2netcdf.f90
  ezspline/ezspline_cdfget3.f90 ezspline/ezspline_cdfput3.f90
  ezspline/ezspline_cinterp.f90 ezspline/ezspline_derivative.f90
  ezspline/ezspline_free.f90 ezspline/ezspline_gradient.f90
  ezspline/ezspline_init.f90 ezspline/ezspline_interp.f90
  ezspline/ezspline_isgridregular.f90 ezspline/ezspline_isindomain.f90
  ezspline/ezspline_load.f90 ezspline/ezspline_mod.f90
  ezspline/ezspline_modulo.f90 ezspline/ezspline_save.f90
  ezspline/ezspline_setup.f90 ezspline/ezspline_setupx.f90

)

# The C interface is double precision only (iso_c_binding c_double), so it
# is left out of single precision builds.
if(NOT PSPLINE_SINGLE_PRECISION)
  list(APPEND PSPLINE_SOURCES
    czspline/czspline_1d.f90 czspline/czspline_2d.f90 czspline/czspline_3d.f90)
endif()

set(PSPLINE_MODULE_DIR "${PROJECT_BINARY_DIR}/include")

# The sources are compiled once into an object library that feeds both the
# static and the shared library. The objects are position independent when
# the shared library is requested, so a single set of Fortran .mod files is
# produced.
add_library(pspline_objects OBJECT ${PSPLINE_SOURCES})
set_target_properties(pspline_objects PROPERTIES
  Fortran_PREPROCESS ON
  Fortran_MODULE_DIRECTORY "${PSPLINE_MODULE_DIR}"
  POSITION_INDEPENDENT_CODE ${PSPLINE_BUILD_SHARED})
target_compile_options(pspline_objects PRIVATE ${PSPLINE_Fortran_OPTIONS})
target_compile_definitions(pspline_objects PRIVATE ${PSPLINE_Fortran_DEFINITIONS})
if(PSPLINE_HAVE_NETCDF)
  target_link_libraries(pspline_objects PRIVATE NetCDF::NetCDF_Fortran)
endif()

set(PSPLINE_LIBRARY_TARGETS)
foreach(_kind IN ITEMS STATIC SHARED)
  if(NOT PSPLINE_BUILD_${_kind})
    continue()
  endif()
  string(TOLOWER "${_kind}" _suffix)
  set(_target pspline_${_suffix})
  add_library(${_target} ${_kind} $<TARGET_OBJECTS:pspline_objects>)
  add_library(pspline::${_target} ALIAS ${_target})
  set_target_properties(${_target} PROPERTIES
    OUTPUT_NAME pspline
    EXPORT_NAME ${_target}
    LINKER_LANGUAGE Fortran)
  target_include_directories(${_target} PUBLIC
    $<BUILD_INTERFACE:${PSPLINE_MODULE_DIR}>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/czspline>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
  if(PSPLINE_HAVE_NETCDF)
    target_link_libraries(${_target} PRIVATE NetCDF::NetCDF_Fortran)
  endif()
  list(APPEND PSPLINE_LIBRARY_TARGETS ${_target})
endforeach()

# pspline::pspline refers to the shared library when it is built, otherwise
# to the static one.
if(PSPLINE_BUILD_SHARED)
  set(PSPLINE_DEFAULT_TARGET pspline_shared)
else()
  set(PSPLINE_DEFAULT_TARGET pspline_static)
endif()
add_library(pspline::pspline ALIAS ${PSPLINE_DEFAULT_TARGET})

# ----------------------------------------------------------------------------
# Tests
#
# The test programs are linked against the static library when it is built,
# as in the Makefiles. Each test compares the program output with the
# reference output in the source tree, ignoring white space (as diff -w does
# in the CI) and allowing round-off differences in the printed numbers, so
# that the gfortran references also hold for other compilers.
# ----------------------------------------------------------------------------

if(PSPLINE_BUILD_TESTS)
  include(CTest)
  enable_language(CXX)

  set(PSPLINE_TEST_RTOL "1e-5" CACHE STRING "Relative tolerance for comparing test output with the references")
  set(PSPLINE_TEST_ATOL "1e-12" CACHE STRING "Absolute tolerance for comparing test output with the references")
  mark_as_advanced(PSPLINE_TEST_RTOL PSPLINE_TEST_ATOL)

  add_executable(compare_output cmake/compare_output.cc)
  target_compile_features(compare_output PRIVATE cxx_std_11)

  if(PSPLINE_BUILD_STATIC)
    set(_test_lib pspline_static)
  else()
    set(_test_lib pspline_shared)
  endif()

  set(PSPLINE_TESTS
    "lookup_test\;pspline/lookup_test.f90\;pspline/lookup_test.output"
    "pspltest\;pspline/pspltest.f90\;pspline/pspltest.output"
    "qk_pspline\;ezspline/qk_pspline.f90\;ezspline/qk_pspline.output"
    "ezspline_test\;ezspline/ezspline_test.f90\;ezspline/ezspline_test.ref")
  if(NOT PSPLINE_SINGLE_PRECISION)
    list(APPEND PSPLINE_TESTS
      "czspline_test\;czspline/czspline_test.cc\;czspline/czspline_test.output")
  endif()

  set(PSPLINE_TEST_TARGETS)
  set(PSPLINE_TEST_REFERENCES)
  foreach(_test IN LISTS PSPLINE_TESTS)
    list(GET _test 0 _name)
    list(GET _test 1 _source)
    list(GET _test 2 _reference)

    add_executable(${_name} ${_source})
    target_link_libraries(${_name} PRIVATE ${_test_lib})
    if(PSPLINE_HAVE_NETCDF)
      target_link_libraries(${_name} PRIVATE NetCDF::NetCDF_Fortran)
    endif()
    if(_source MATCHES "\\.f90$")
      set_target_properties(${_name} PROPERTIES
        Fortran_PREPROCESS ON
        Fortran_MODULE_DIRECTORY "${PROJECT_BINARY_DIR}/test_modules/${_name}")
      target_compile_options(${_name} PRIVATE ${PSPLINE_Fortran_OPTIONS})
      target_compile_definitions(${_name} PRIVATE ${PSPLINE_Fortran_DEFINITIONS})
    else()
      target_compile_features(${_name} PRIVATE cxx_std_11)
      target_compile_definitions(${_name} PRIVATE $<$<BOOL:${PSPLINE_HAVE_NETCDF}>:_NETCDF>)
    endif()

    # The reference outputs were produced in double precision, and that of
    # ezspline_test with NetCDF enabled.
    if(NOT PSPLINE_SINGLE_PRECISION AND (PSPLINE_HAVE_NETCDF OR NOT _name STREQUAL "ezspline_test"))
      set(_workdir "${PROJECT_BINARY_DIR}/test_output/${_name}")
      file(MAKE_DIRECTORY "${_workdir}")
      add_test(NAME ${_name}
        COMMAND ${CMAKE_COMMAND}
          -DEXECUTABLE=$<TARGET_FILE:${_name}>
          -DCOMPARE=$<TARGET_FILE:compare_output>
          -DRTOL=${PSPLINE_TEST_RTOL}
          -DATOL=${PSPLINE_TEST_ATOL}
          -DREFERENCE=${PROJECT_SOURCE_DIR}/${_reference}
          -DOUTPUT=${_workdir}/${_name}.out
          -P ${PROJECT_SOURCE_DIR}/cmake/RunAndCompare.cmake
        WORKING_DIRECTORY "${_workdir}")
    endif()

    list(APPEND PSPLINE_TEST_TARGETS ${_name})
    list(APPEND PSPLINE_TEST_REFERENCES ${_reference})
  endforeach()
endif()

# ----------------------------------------------------------------------------
# Installation
#
# The layout matches "make install": libraries in lib/, Fortran modules and
# czspline_capi.h in include/. In addition a CMake package (pspline::pspline)
# and a pkg-config file (pspline.pc) are installed.
# ----------------------------------------------------------------------------

set(PSPLINE_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/pspline"
  CACHE STRING "Installation directory of the CMake package files")

# Keep the RPATH to NetCDF and the compiler run-time libraries in the
# installed shared library and test programs.
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH ON)

install(TARGETS ${PSPLINE_LIBRARY_TARGETS}
  EXPORT psplineTargets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(DIRECTORY "${PSPLINE_MODULE_DIR}/"
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  FILES_MATCHING PATTERN "*.mod")
install(FILES czspline/czspline_capi.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

if(PSPLINE_BUILD_TESTS AND PSPLINE_INSTALL_TESTS)
  install(TARGETS ${PSPLINE_TEST_TARGETS} DESTINATION test)
  install(FILES ${PSPLINE_TEST_REFERENCES} DESTINATION test)
endif()

install(EXPORT psplineTargets
  NAMESPACE pspline::
  DESTINATION ${PSPLINE_INSTALL_CMAKEDIR})
configure_package_config_file(cmake/psplineConfig.cmake.in
  "${PROJECT_BINARY_DIR}/psplineConfig.cmake"
  INSTALL_DESTINATION ${PSPLINE_INSTALL_CMAKEDIR})
write_basic_package_version_file("${PROJECT_BINARY_DIR}/psplineConfigVersion.cmake"
  COMPATIBILITY SameMajorVersion)
install(FILES
  "${PROJECT_BINARY_DIR}/psplineConfig.cmake"
  "${PROJECT_BINARY_DIR}/psplineConfigVersion.cmake"
  cmake/FindNetCDF_Fortran.cmake
  DESTINATION ${PSPLINE_INSTALL_CMAKEDIR})

# pkg-config file, for projects that are built with Makefiles
set(PSPLINE_PC_REQUIRES_PRIVATE "")
set(PSPLINE_PC_LIBS_PRIVATE "")
if(PSPLINE_HAVE_NETCDF)
  if(NetCDF_Fortran_PKGCONFIG)
    set(PSPLINE_PC_REQUIRES_PRIVATE "netcdf-fortran")
  else()
    set(PSPLINE_PC_LIBS_PRIVATE "${NetCDF_Fortran_LINK_FLAGS}")
  endif()
endif()
configure_file(cmake/pspline.pc.in "${PROJECT_BINARY_DIR}/pspline.pc" @ONLY)
install(FILES "${PROJECT_BINARY_DIR}/pspline.pc"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

# ----------------------------------------------------------------------------
# Summary
# ----------------------------------------------------------------------------

message(STATUS "")
message(STATUS "PSPLINE ${PROJECT_VERSION} configuration")
message(STATUS "  Fortran compiler : ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION} (${CMAKE_Fortran_COMPILER})")
message(STATUS "  Build type       : ${CMAKE_BUILD_TYPE}")
message(STATUS "  Static library   : ${PSPLINE_BUILD_STATIC}")
message(STATUS "  Shared library   : ${PSPLINE_BUILD_SHARED}")
message(STATUS "  NetCDF           : ${PSPLINE_HAVE_NETCDF}")
message(STATUS "  Single precision : ${PSPLINE_SINGLE_PRECISION}")
message(STATUS "  Tests            : ${PSPLINE_BUILD_TESTS}")
message(STATUS "  Install prefix   : ${CMAKE_INSTALL_PREFIX}")
message(STATUS "")
