# [Mac + Vscode下Qt的开发配置](https://www.cnblogs.com/14long-Alex/p/15415531.html)

起因是数据结构实验想要糊个GUI，然后去看了看Qt，又发现自己比较不适应Qt本身的界面，网上资料又比较杂乱，查了蛮久，于是自己记录一下。

-   首先确保有：

（1）mac+vscode(插件包括：(c/c++)/C++ Intellisense、cmake+cmake tools+cmake integration)

（2）cmake

（3）Qt Creator(version:5.0.12)

-   配置好Qt Creator:参考[Mac+Qt](https://www.jianshu.com/p/29e6034303d7)
    
-   然后在Qt中创建新的Qt Widgets Application，Build System选cmake。得到一个包含了CMakeLists.txt的项目文件，然后把Qt软件关了。
    
-   打开vscode，用vscode 打开Qt中创建的新项目的文件夹。
    
-   配置.vscode文件夹：
    

在项目文件夹下新建一个.vscode文件夹，vscode通过其中的配置文件来完成类似IDE一样的编译运行效果。

1.  command+shift+p 找到c/c++ edit configuration，使用默认文件或者复制以下代码(我的电脑上的默认版本):

```json
{
    "configurations": [
        {
            "name": "Mac",
            "includePath": [
                "${default}"
            ],
            "compilerPath": "/usr/bin/clang",
            "cStandard": "c11",
            "cppStandard": "c++98",
            "intelliSenseMode": "macos-clang-x64",
            "compileCommands": "${workspaceFolder}/build/compile_commands.json",
            "configurationProvider": "ms-vscode.cmake-tools"
        }
    ],
    "version": 4
}
```

2.  .vscode文件夹下新建tasks.json:

```json
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        { // 在根文件夹中执行创建文件夹build的命令
            // 除windows系统外执行的命令为`mkdir -p build`
            // windows系统是在powershell中执行命令`mkdir -Force build`
            "label": "Build_dir",
            "command": "mkdir",
            "type": "shell",
            "args": [
                "-p",
                "build"
            ],
        },
        { // 在build文件夹中调用cmake进行项目配置
            // 除windows系统外执行的命令为`cmake -DCMAKE_BUILD_TYPE=<Debug|Release|RelWithDebInfo|MinSizeRel> ../`
            // windows系统是在visual stuido的环境中执行命令`cmake -DCMAKE_BUILD_TYPE=<Debug|Release|RelWithDebInfo|MinSizeRel>  ../ -G "CodeBlocks - NMake Makefiles"`
            "label": "Cmake",
            "type": "shell",
            "command": "cmake",
            "args": [
                "-DCMAKE_BUILD_TYPE=${input:CMAKE_BUILD_TYPE}",
                "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON", // 生成compile_commands.json 供c/c++扩展提示使用
                "../"
            ],
            "options": {
                "cwd": "${workspaceFolder}/build",
            },
            "dependsOn": [
                "Build_dir" // 在task `build_dir` 后执行该task
            ]
        },



        { // 在build文件夹中调用cmake编译构建debug程序
            // 执行的命令为`cmake --build ./ --target all --`
            //  windows系统如上需要在visual stuido的环境中执行命令
            "label": "Build",
            "group": "test",
            "type": "shell",
            "command": "cmake",
            "args": [
                "--build",
                "./",
                "--target",
                "all",
                "--"
            ],
            "options": {
                "cwd": "${workspaceFolder}/build",
            },
            "problemMatcher": "$gcc",
            "dependsOn": [
                "Cmake" // 在task `cmake` 后执行该task
            ]
        },
        {
            "label": "Run",
            "type": "shell",
            "group":"build",
            
            "command":"./${workspaceFolderBasename}",
            "options": {
                "cwd": "${workspaceFolder}/build",
            },
            "dependsOn":[
                "Build"
            ]
        },
    ],
    "inputs": [
        {
            "id": "CMAKE_BUILD_TYPE",
            "type": "pickString",
            "description": "What CMAKE_BUILD_TYPE do you want to create?",
            "options": [
                "Debug",
                "Release",
                "RelWithDebInfo",
                "MinSizeRel",
            ],
            "default": "Debug"
        },
        {
            "id": "PLATFORM",
            "type": "pickString",
            "description": "What PLATFORM do you want to create?",
            "options": [
                "x86",
                "amd64",
                "arm",
                "x86_arm",
                "x86_amd64",
                "amd64_x86",
                "amd64_arm",
            ],
            "default": "amd64"
        },
        {
            "id": "vcvars_ver",
            "type": "pickString",
            "description": "What vcvars_ver do you want to create?",
            "options": [
                "14.2", // 2019
                "14.1", // 2017
                "14.0", // 2015
            ],
            "default": "14.2"
        }
    ]
}
```

3.  新建launch.json:

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch Debug",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/build/${workspaceFolderBasename}",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "preLaunchTask": "build",
            "environment": [],
            "externalConsole": false,
            "osx": {
                "MIMode": "lldb"
            },
            "linux": {
                "MIMode": "gdb",
                "setupCommands": [
                    {
                        "description": "Enable pretty-printing for gdb",
                        "text": "-enable-pretty-printing",
                        "ignoreFailures": true
                    }
                ]
            },
            "windows": {
                "program": "${workspaceFolder}/build/${workspaceFolderBasename}"
            },
        }
    ]
}

```

4.  新建settings.json:

```json
{
    "files.associations": {
        "ostream": "cpp",
        "vector": "cpp"
    },
    "C_Cpp.errorSquiggles": "Disabled"
}
```

-   建立项目，目录如下：

```markdown
.(我的测试项目名称为qt_cmake_basic)
├── CMakeLists.txt
├── CMakeLists.txt.user
├── build
│   ├── CMakeCache.txt
│   └── CMakeFiles
├── include
│   └── Testhead.h
├── main.cpp
├── mainwindow.cpp
├── mainwindow.h
├── mainwindow.ui
└── src
    ├── CMakeLists.txt
    └── Testhead.cpp
```

CMakeLists.txt文件除了使用Qt创建新项目的时候生成的那部分之外，可以在开源项目上找一些CMakeLists.txt文件借鉴学习一下，稍微改动一下就可以做出架构类似的项目。

我的测试项目架构大致如上。其中/src中的CMakeLists.txt文件内容如下：

```cmake
set(FILENAME_SOURCE_FILES
    Testhead.cpp
#   这里添加src目录下的.cpp文件
)
set(FILENAME_HEADER_FILES
    ../include/Testhead.h
#   这里添加include目录下的头文件      
)
#   src_head是自己定义的名称，为项目提供链接库
add_library(src_head STATIC ${FILENAME_SOURCE_FILES} ${FILENAME_HEADER_FILES})
target_include_directories(src_head PUBLIC ../include)
```

与main.cpp同级的CMakeLists.txt如下：

```cmake
cmake_minimum_required(VERSION 3.5)

project(qt_cmake_basic VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check https://doc.qt.io/qt/deployment-android.html for more information.
# They need to be set before the find_package( ...) calls below.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets REQUIRED)

set(PROJECT_SOURCES
        main.cpp
        mainwindow.cpp
        mainwindow.h
        mainwindow.ui
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(qt_cmake_basic
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        add_library(qt_cmake_basic SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(qt_cmake_basic
            ${PROJECT_SOURCES}
        )
    endif()
endif()

target_link_libraries(qt_cmake_basic PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)

set_target_properties(qt_cmake_basic PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)
if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(qt_cmake_basic)
endif()
#上面的是Qt项目生成时建立的默认CMakeLists.txt

add_subdirectory(src)
target_include_directories(qt_cmake_basic PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(qt_cmake_basic PUBLIC src_head)
```

-   最后command+R即可生成+运行项目。

参考资料：

[https://blog.csdn.net/weixin\_43669941/article/details/108921714](https://blog.csdn.net/weixin_43669941/article/details/108921714)

[https://blog.csdn.net/qq\_33756749/article/details/114175291](https://blog.csdn.net/qq_33756749/article/details/114175291)

[https://blog.csdn.net/weixin\_42221830/article/details/111245894](https://blog.csdn.net/weixin_42221830/article/details/111245894)

[https://blog.csdn.net/weixin\_43669941/article/details/108921714](https://blog.csdn.net/weixin_43669941/article/details/108921714)