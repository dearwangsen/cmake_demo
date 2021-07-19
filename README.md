# Cross platform Make 跨平台自动化建构系统

cmake的重点是添加依赖

```elm
Cmake is great. Don't waste time on other c++ build tools.
```

```bash
# 注意事项
1 cmake命令不区分大小写，但变量区分
2 cmake没有clean，一般工程所在目录和工程编译目录分开，使用build/作为工程编译目录
```

## 一、cmake入门 hello cmake 

### 1.linux版

```bash
# 目录树
hello/
|-- CMakeLists.txt
`-- hello.cpp
```

```cpp
// hello.cpp 源文件
#include <iostream>
int main() {
    std::cout << "hello cmake" << std::endl;
    return 0;
}
```

```cmake
# CMakeLists.txt 组态档
add_executable(hello hello.cpp)
```

(1) 进入hello/目录下，创建build文件夹 

```bash
mkdir build
```

(2) 进入build/目录下，执行cmake构建命令，生成Makefile

```
cmake ..
```

(3) 在build/目录下，执行make，生成可执行文件hello

```
make
./hello
```

### 2.windows版

删除上面linux中的build，下载到windows系统使用visual studio打开

## 二、cmake实践 5种方式添加依赖

```bash
# 目录结构
cmake_demo/
|-- main.cc           # 主函数
|-- CMakeLists.txt    # 组态档
|-- hello
|   `-- hello.h       # 验证 include_directories()
|-- world
|   |-- world.cc
|   `-- world.h       # 验证 add_library()
|-- sub
|   |-- CMakeLists.txt
|   |-- sub.cc
|   `-- sub.h         # 验证 add_subdirectory()
|-- pkg
|   |-- CMakeLists.txt
|   |-- include
|   |   `-- pkg.h     # 验证 find_package()
|   `-- pkg.cc
`-- auxs
    |-- auxs.cc
    `-- auxs.h        # 验证 aux_source_directory()

# 构建步骤
1.安装自定义模块 pkg
进入cmake_demo/pkg/目录
mkdir build
cd build
cmake ..
make
make install

2.构建测试代码 Main
进入cmake_demo/目录
mkdir build
cd build
cmake ..
make
./Main
```

### 1.以包含方式添加依赖

```cmake
# CMakeLists.txt
include_directories ("${CMAKE_SOURCE_DIR}/hello")

# 将给定的目录添加到编译器用来搜索包含文件的目录中。相对路径被解释为相对于当前源目录
include_directories([AFTER|BEFORE] [SYSTEM] dir1 [dir2 ...])
```

### 2.以生成静态库方式添加依赖

```cmake
# CMakeLists.txt
add_library (WORLD "${CMAKE_SOURCE_DIR}/world/world.h" "${CMAKE_SOURCE_DIR}/world/world.cc")
include_directories ("${CMAKE_SOURCE_DIR}/world")

# 使用指定的源文件向项目添加库
add_library(<name> [STATIC | SHARED | MODULE]
            [EXCLUDE_FROM_ALL]
            [<source>...])
```

### 3.以单独组态档生成静态库方式添加依赖

```cmake
# CMakeLists.txt
add_subdirectory ("${CMAKE_SOURCE_DIR}/sub")
include_directories ("${CMAKE_SOURCE_DIR}/sub")

# 向构建添加一个子目录
add_subdirectory(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
```

### 4.以自定义子模块添加依赖

```cmake
# CMakeLists.txt
SET (CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "./pkg/install")
find_package (pkg REQUIRED)

# 找到外部项目，并加载其设置
find_package(<PackageName> [version] [EXACT] [QUIET] [MODULE]
             [REQUIRED] [[COMPONENTS] [components...]]
             [OPTIONAL_COMPONENTS components...]
             [NO_POLICY_SCOPE])
```

### 5.以源文件方式添加依赖

```cmake
# CMakeLists.txt
aux_source_directory ("${CMAKE_SOURCE_DIR}/auxs" DIR_SRCS)
include_directories ("${CMAKE_SOURCE_DIR}/auxs")

# 在一个目录中找到所有源文件
aux_source_directory(<dir> <variable>)
```

## 三、cmake 命令行参数

```cmake
# 常用命令
-G <generator-name> 指定makefile生成器的名字
例如：cmake -G "MinGW Makefiles";注意generator是大小写敏感的，即使是在windows下。generator所用的命令(gcc,cl等)最好已经设置在环境变量PATH中。有个例外就是生成visual studio的工程不必设置环境变量，只要安装了对应的vs，cmake可以自动找到。

-D<var>:<type>=<value> 添加变量及值到CMakeCache.txt中
注意-D后面不能有空格，type为string时可省略。例如：cmake -DCMAKE_BUILD_TYPE:STRING=Debug。MinGW Generator默认生成CMAKE_BUILD_TYPE为空，即release；NMake Generator默认生成CMAKE_BUILD_TYPE为Debug。-DCMAKE_INSTALL_PREFIX=/home，指定编译位置。

-U<globbing_expr> 删除CMakeCache.txt中的变量
注意-U后面不能有空格,支持globbing表达式，比如*,?等。例如：cmake -UCMAKE_BUILD_TYPE。

# 其他命令
  -S <path-to-source>          = 显式指定源目录
  -B <path-to-build>           = 显式指定生成目录
  -C <initial-cache>           = 预加载脚本以填充缓存
  -T <toolset-name>            = 指定工具集名称
  -A <platform-name>           = 指定平台名称
```

## 四、cmake 语法说明

1.遍历列表 ``while`` ``foreach``

```cmake
set(TEST_LIST "one;two;three")
foreach(_target ${TEST_LIST})
  MESSAGE(${_target})
endforeach()
```

2.条件判断 ``if``

```cmake
if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
  MESSAGE("Clang") 
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU") 
  MESSAGE("GNU")
endif()
```

3.正则表达式 ``MATCHES``

```cmake
set(stuff "2017-03-05-02-10-10_78205")
if( "${stuff}" MATCHES "[0-9]{4}(-[0-9]{2}){5}_[0-9]+")
  message("Hello")
endif()
```

4.过程定义 宏和函数 ``defind`` ``function``

```cmake
define a function hello
function(hello MESSAGE) message(${MESSAGE}) endfunction(hello)
```

## 五、cmake C++编译配置

```cmake
# cmake 支持 C++11
set(CMAKE_CXX_STANDARD      11)                 # 指定C++版本
# cmake 支持 gdb 
set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")
# cmake C++ 调试信息
set(CMAKE_CXX_COMPILER      "clang++" )         # 显示指定使用的C++编译器
set(CMAKE_CXX_FLAGS         "-std=c++11")       # c++11
set(CMAKE_CXX_FLAGS         "-g")               # 调试信息
set(CMAKE_CXX_FLAGS         "-Wall")            # 开启所有警告
set(CMAKE_CXX_FLAGS_DEBUG   "-O0" )             # 调试包不优化
set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG " )   # release包优化
```

