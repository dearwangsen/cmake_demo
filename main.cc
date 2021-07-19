#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <future>
#include <functional>

// 静态依赖
#include <hello.h>
#include <world.h>
#include <sub.h>
#include <auxs.h>
#include <static.h>
#include <static2.h>

// 自定义模块依赖
#include <pkg.h>

int main()
{
    // hello/hello.h include_directories()
    CoutHello();

    // world/world.h add_library()
    CoutWorld();

    // sub/sub.h add_subdirectory()
    CoutSub();

    // pkg/pkg.h find_package()
    CoutPkg();

    // auxs/auxs.h aux_source_directory()
    CoutAuxs();

    // stat/static.h find_library()
    CoutStatic();

    // stat2/static2.h link_directories()
    CoutStatic2();

    return 0;
}