#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "pkg::pkg" for configuration ""
set_property(TARGET pkg::pkg APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(pkg::pkg PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libpkg.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS pkg::pkg )
list(APPEND _IMPORT_CHECK_FILES_FOR_pkg::pkg "${_IMPORT_PREFIX}/lib/libpkg.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
