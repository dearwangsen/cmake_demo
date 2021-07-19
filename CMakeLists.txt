# cmake需要的最低版本
cmake_minimum_required (VERSION 3.5.1)

# cmake指定C++版本
set (CMAKE_CXX_STANDARD 11)

# cmake项目名
project (DemoTest)

# hello 以包含方式添加依赖 -I
include_directories ("${CMAKE_SOURCE_DIR}/hello")

# world 以生成静态库方式添加依赖
add_library (WORLD "${CMAKE_SOURCE_DIR}/world/world.h" 
"${CMAKE_SOURCE_DIR}/world/world.cc")
include_directories ("${CMAKE_SOURCE_DIR}/world")

# sub 以单独组态档生成静态库方式添加依赖
add_subdirectory ("${CMAKE_SOURCE_DIR}/sub") # 用于构建子目录中的cmake
include_directories ("${CMAKE_SOURCE_DIR}/sub") # 添加头文件依赖

# pkg 以自定义子模块添加依赖
SET (CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "./pkg/install") # 让find_package知道自定义模块cmake的路径
find_package (pkg REQUIRED)

# aux 以源文件方式添加依赖
aux_source_directory ("${CMAKE_SOURCE_DIR}/auxs" DIR_SRCS)
include_directories ("${CMAKE_SOURCE_DIR}/auxs") # 添加头文件依赖

# 将工程顶层目录所有源文件包含到 DIR_SRCS
aux_source_directory (${CMAKE_SOURCE_DIR} DIR_SRCS)
# 使用 DIR_SRCS 生成可执行文件 Demo
add_executable (Main ${DIR_SRCS})

# 将相关库与 Demo 链接
target_link_libraries (
  Main
    WORLD # 静态库
    SUB # 单独cmake管理的静态库
    pkg::pkg # find_package()管理的静态库
    )
