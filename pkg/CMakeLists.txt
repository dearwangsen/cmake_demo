# 项目基本配置
cmake_minimum_required(VERSION 3.5.1)
project(Pkg)

# 添加名为 mylib 的静态库
add_library(pkg pkg.cc include/pkg.h)

# 将编译好的库文件安装在当前工程的 install 的文件夹下
SET(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/install)

# 向目标库添加包含目录
target_include_directories(pkg PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> # 源文件位置
    $<INSTALL_INTERFACE:include>) # 安装文件位置

# 表示安装的头文件名称是 mylib.h
set_target_properties(pkg PROPERTIES PUBLIC_HEADER "include/pkg.h")

# 配置安装目录,相对于 CMAKE_INSTALL_PREFIX
install(TARGETS pkg
    EXPORT pkg-targets
    ARCHIVE DESTINATION lib # 静态库安装路径
    LIBRARY DESTINATION lib # 动态库安装路径
    RUNTIME DESTINATION bin # 可执行文件安装路径
    PUBLIC_HEADER DESTINATION include # 头文件安装路径
    )

# 将前面 EXPORT mylib-targets 的信息写入到 mylib-config.cmake 文件中
install(EXPORT pkg-targets
    FILE pkg-config.cmake
    NAMESPACE pkg::
    DESTINATION lib/cmake/pkg # 文件存放目录
    )