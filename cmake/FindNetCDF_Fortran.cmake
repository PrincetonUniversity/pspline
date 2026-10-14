# FindNetCDF_Fortran
# ------------------
#
# Find the NetCDF Fortran library (libnetcdff and the netcdf.mod module).
#
# The search uses, in this order:
#
#   NetCDF_Fortran_ROOT (CMake variable or environment variable)
#   NETCDF_F_HOME, NETCDF_FORTRAN_HOME, EBROOTNETCDFMINFORTRAN (environment)
#   NETCDF_MODDIR (environment, directory containing netcdf.mod)
#   nf-config, then pkg-config (netcdf-fortran)
#   CMAKE_PREFIX_PATH and the system directories
#
# The NetCDF C library is located the same way (NetCDF_C_ROOT, NETCDF_C_HOME,
# NETCDF_HOME, EBROOTNETCDF, nc-config) and is linked when found.
#
# Result variables:
#
#   NetCDF_Fortran_FOUND
#   NetCDF_Fortran_INCLUDE_DIRS
#   NetCDF_Fortran_LIBRARIES
#   NetCDF_Fortran_VERSION       (when nf-config or pkg-config is available)
#   NetCDF_Fortran_PKGCONFIG     TRUE if a netcdf-fortran.pc file was found
#   NetCDF_Fortran_LINK_FLAGS    -L/-l flags, e.g. for a pkg-config file
#
# Imported target:
#
#   NetCDF::NetCDF_Fortran

set(_nf_hints "")
set(_nf_inc_hints "")
set(_nc_hints "")

foreach(_var IN ITEMS NETCDF_F_HOME NETCDF_FORTRAN_HOME EBROOTNETCDFMINFORTRAN)
  if(DEFINED ENV{${_var}})
    list(APPEND _nf_hints "$ENV{${_var}}")
  endif()
endforeach()
if(DEFINED ENV{NETCDF_MODDIR})
  list(APPEND _nf_inc_hints "$ENV{NETCDF_MODDIR}")
endif()
foreach(_var IN ITEMS NETCDF_C_HOME NETCDF_HOME EBROOTNETCDF)
  if(DEFINED ENV{${_var}})
    list(APPEND _nc_hints "$ENV{${_var}}")
  endif()
endforeach()

find_program(NetCDF_Fortran_CONFIG_EXECUTABLE nf-config HINTS ${_nf_hints} PATH_SUFFIXES bin)
mark_as_advanced(NetCDF_Fortran_CONFIG_EXECUTABLE)
if(NetCDF_Fortran_CONFIG_EXECUTABLE)
  foreach(_opt IN ITEMS prefix includedir version)
    execute_process(COMMAND "${NetCDF_Fortran_CONFIG_EXECUTABLE}" --${_opt}
      OUTPUT_VARIABLE _nf_${_opt} OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET)
  endforeach()
  list(APPEND _nf_hints "${_nf_prefix}")
  list(APPEND _nf_inc_hints "${_nf_includedir}")
  if(_nf_version MATCHES "([0-9]+\\.[0-9]+\\.[0-9]+)")
    set(NetCDF_Fortran_VERSION "${CMAKE_MATCH_1}")
  endif()
endif()

find_program(NetCDF_C_CONFIG_EXECUTABLE nc-config HINTS ${_nc_hints} PATH_SUFFIXES bin)
mark_as_advanced(NetCDF_C_CONFIG_EXECUTABLE)
if(NetCDF_C_CONFIG_EXECUTABLE)
  execute_process(COMMAND "${NetCDF_C_CONFIG_EXECUTABLE}" --libdir
    OUTPUT_VARIABLE _nc_libdir OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET)
  list(APPEND _nc_hints "${_nc_libdir}")
endif()

set(NetCDF_Fortran_PKGCONFIG FALSE)
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(_NF_PC QUIET netcdf-fortran)
  if(_NF_PC_FOUND)
    set(NetCDF_Fortran_PKGCONFIG TRUE)
    list(APPEND _nf_hints ${_NF_PC_PREFIX})
    list(APPEND _nf_inc_hints ${_NF_PC_INCLUDE_DIRS} ${_NF_PC_INCLUDEDIR})
    list(APPEND _nf_lib_hints ${_NF_PC_LIBRARY_DIRS} ${_NF_PC_LIBDIR})
    if(NOT NetCDF_Fortran_VERSION AND _NF_PC_VERSION)
      set(NetCDF_Fortran_VERSION "${_NF_PC_VERSION}")
    endif()
  endif()
endif()

# netcdf.mod is in include/ for most installations; RHEL/Fedora system
# packages put it in lib64/gfortran/modules.
find_path(NetCDF_Fortran_INCLUDE_DIR
  NAMES netcdf.mod NETCDF.mod
  HINTS ${_nf_inc_hints} ${_nf_hints}
  PATH_SUFFIXES include lib64/gfortran/modules lib/gfortran/modules)
find_library(NetCDF_Fortran_LIBRARY
  NAMES netcdff
  HINTS ${_nf_lib_hints} ${_nf_hints}
  PATH_SUFFIXES lib lib64)
find_library(NetCDF_C_LIBRARY
  NAMES netcdf
  HINTS ${_nc_hints} ${_nf_hints}
  PATH_SUFFIXES lib lib64)
mark_as_advanced(NetCDF_Fortran_INCLUDE_DIR NetCDF_Fortran_LIBRARY NetCDF_C_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NetCDF_Fortran
  REQUIRED_VARS NetCDF_Fortran_LIBRARY NetCDF_Fortran_INCLUDE_DIR
  VERSION_VAR NetCDF_Fortran_VERSION)

if(NetCDF_Fortran_FOUND)
  set(NetCDF_Fortran_INCLUDE_DIRS "${NetCDF_Fortran_INCLUDE_DIR}")
  set(NetCDF_Fortran_LIBRARIES "${NetCDF_Fortran_LIBRARY}")

  get_filename_component(_nf_libdir "${NetCDF_Fortran_LIBRARY}" DIRECTORY)
  set(NetCDF_Fortran_LINK_FLAGS "-L${_nf_libdir} -lnetcdff")
  if(NetCDF_C_LIBRARY)
    list(APPEND NetCDF_Fortran_LIBRARIES "${NetCDF_C_LIBRARY}")
    get_filename_component(_nc_libdir "${NetCDF_C_LIBRARY}" DIRECTORY)
    string(APPEND NetCDF_Fortran_LINK_FLAGS " -L${_nc_libdir} -lnetcdf")
  endif()

  if(NOT TARGET NetCDF::NetCDF_Fortran)
    add_library(NetCDF::NetCDF_Fortran UNKNOWN IMPORTED)
    set_target_properties(NetCDF::NetCDF_Fortran PROPERTIES
      IMPORTED_LOCATION "${NetCDF_Fortran_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${NetCDF_Fortran_INCLUDE_DIR}")
    if(NetCDF_C_LIBRARY)
      set_property(TARGET NetCDF::NetCDF_Fortran APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${NetCDF_C_LIBRARY}")
    endif()
  endif()
endif()

unset(_nf_hints)
unset(_nf_inc_hints)
unset(_nf_lib_hints)
unset(_nc_hints)
