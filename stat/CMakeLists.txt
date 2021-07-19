set(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR})
aux_source_directory(. DIR_LIB_SRCS)
add_library(static ${DIR_LIB_SRCS})