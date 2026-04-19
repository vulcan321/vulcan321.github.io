# Windows平台Flutter桌面应用的底层模块化探索

2023-02-02 13:04·[闲鱼技术](https://www.toutiao.com/c/user/token/MS4wLjABAAAAoDpC5ac7b5nriXRXX4FRmNrP1-9-48wY_kjo-yryzNs/?source=tuwen_detail)

# 前言

Windows应用开发有着较为丰富和多样的技术选型。C#/WPF 这种偏Native的闭源方案，目前开发人员相对比较小众了。C++/QT 的跨平台框架，C++对于GUI开发来说上手会更难。JavaScript/CEF/Electron 基于Chromium 的跨端框架，使用前端技术栈来构建桌面应用，性能会略低一些。总而言之各有所长，有一点可以确定的是，跨端能力成为了选型的重要考量。  
Flutter从诞生之初起，其核心目标就是跨平台，不仅仅支持Android和iOS的移动端设备，同时包括桌面端和Web端。随着2022年2月Flutter 2.10的推出，也带来了首个支持Windows平台的稳定版本。基于Flutter的跨平台特性，移动端或Web端的Flutter应用也能够在Windows系统上运行，Windows应用开发者能够享受到Flutter开发带来的便利和生产力上的提升，同时移动端开发者也能够快速上手Windows应用开发了。

# Windows平台接入

在进一步探索和预演之后，通过Flutter的能力，可以很方便地将移动端的业务模块迁移至PC端，尽可能地实现一码多端，降低业务维护成本，以此为出发点，进行了Windows平台的接入。  
闲鱼App已经在Android和iOS平台上有了多年的积累，并且采用了Native和Flutter混合的技术方案，Flutter和Native相辅相成，共同组成了App的完整生态。如果想要让Flutter相关的模块在Windows平台上运行，那就需要让Windows平台补齐Android和iOS平台提供给Flutter的能力。比如通过Platform Channel提供给Flutter侧相关的Native能力，通过Platform View将Native视图嵌入到Flutter页面中，都需要在Windows平台上进行重新开发。  
Windows平台通过Plugin或FFI的方式提供相关能力，需要使用C++编写相关的平台代码。如果Plugin的代码可以自闭环，即所有C++代码都可以在Plugin内编写完成，那这个Plugin可以单独抽成一个Dart库。但是如果Plugin的代码需要复用其他Plugin或者主工程的C++代码，粗暴一点就是拷贝代码，或者通过CMakeLists来控制相互之间的依赖关系，通过find\_package来完成头文件和库文件的链接。一旦依赖关系比较复杂，CMakeLists就会变得臃肿，依赖关系发生变化时，也会牵一发而动全身。随着系统复杂度的提升，开发人员的增加，模块之间相互耦合在一起，单一模块的修改都会影响到所有模块。  
针对上述的问题，对于底层的模块化设计，梳理了需要遵循的设计原则：

- 单一职责原则：一个模块维护一个单一的主要功能，划清模块间的职责边界；

- 开闭原则：模块应该对扩展开放，对修改关闭。用抽象构建框架，用实现填充细节，通过扩展实体来实现变化，避免修改代码来实现扩展。

- 迪米特法则：最少知道原则，对依赖的模块知道的越少越好，模块除了对外暴露的方法，其他实现细节都隐藏在内部。

- 接口隔离原则：只依赖需要的接口，模块之间提供最小的接口实现依赖关系。

- 依赖倒置原则：依赖抽象，不依赖具体细节，模块之间需要依赖抽象的架构，而非具体的模块细节。

首先基于上述的设计原则，制定了模块化拆解的XModule方案，依据职责来划分模块，设计对外暴露的抽象接口，抽象接口保持最小化原则，完成接口实现，编译出模块的动态链接库DLL，依赖到主工程并放置到特定目录，运行时通过插件机制进行动态加载。  
其次针对模块化带来的依赖管理复杂的问题，引入了vcpkg的依赖管理方案，通过清单模式便捷地管理各个模块，可以自动引入间接依赖，并且版本冲突问题也不复存在了。  
结合XModule和vcpkg之后，最终形成了下面的结构，后面将详细展开。

![](https://p3-sign.toutiaoimg.com/tos-cn-i-tjoges91tu/TUgBsJLGyyvgAq~noop.image?_iz=58558&from=article.pc_detail&x-expires=1676249714&x-signature=RDXQ5b%2B7sXJfeA9yayWcUBPCEeg%3D)

# 模块化拆解**XModule**

上述是一个登录模块的例子，Module 作为基类，定义了模块的一些生命周期方法。LoginModule是对外公开的业务接口，里面仅包含外部会用到的和登录业务相关的方法。LoginModuleImplV1类是登录逻辑的具体实现，不对外公开，里面的私有成员变量和方法对外部是隐藏的，同时实现了Module和LoginModule的接口。Provider用于创建和管理Module实例。  
这里采用的思路是，底层模块和模块之间，上层和底层之间只依赖接口头文件，头文件内包含有限的需要对外暴露的接口。通过XModule这个框架，将实现和接口进行分离。  
为了将接口和实现分离，用到了 pimpl (Pointer to Implementation) 的理念，将对象的实现细节隐藏在指针背后。LoginModule接口负责定义对外公开的API，LoginModuleImplV1类负责定义LoginModule的具体实现，也就是调用的指针实际指向的对象。调用方只能知道LoginModule中公开的API，而无法知道LoginModuleImplV1的实现细节，可以降低调用方的使用门槛，也可以降低错误使用的可能性。pimpl不仅解除了接口和实现之间的耦合关系，还可以降低文件间的编译依赖关系，起到“编译防火墙”的作用，可以提高一定的编译效率。

```cpp
// LoginModuleProvider 通过宏自动生成
X_MODULE_PROVIDER_DEFINE_SINGLE(LoginModule, MIN_VERSION, MAX_VERSION);
// LoginModuleImplV1Provider 通过宏自动生成
X_MODULE_DEFINE_SECONDARY_PROVIDER(LoginModuleImplV1, LoginModule);
```

XModule的模版开发方式，会增加很多类文件，为了方便，通过宏来控制Provider类的自动生成。其中MIN\_VERSION和MAX\_VERSION是该Module接口能支持的最小和最大的版本范围，可以限制后期dll插件化加载时，不加载在版本之外的dll，避免产生冲突和错误，目前Provider的GetVersion使用的是MAX\_VERSION。

```cpp
// 由 X_MODULE_DEFINE_SECONDARY_PROVIDER 宏自动生成
class DLLEXPORT LoginModuleImplV1Provider : public LoginModuleProvider {
public:
LoginModule* Create() const {
    LoginModuleImplV1* p = new LoginModuleImplV1();
    ((Module*)p)->OnCreate();
    return p;
    }
};
```

LoginModuleImplV1Provider可以通过调用Create方法拿到对应的LoginModuleImplV1实例。

```cpp
x_module::ModuleCenter* module_center = x_module::ModuleCenter::GetInstance();
module_center->AcceptProviderType<LoginModuleProvider>();
```

ModuleCenter是所有Module的管理类，先通过x\_module::ModuleCenter::GetInstance()拿到ModuleCenter的实例，它是一个跨dll的单例。然后要用之前的LoginModuleProvider去注册一个Module类型到ModuleCenter中。LoginModuleProvider中定义了支持的Module类型，以及最小版本和最大版本，如果后续扫描到的dll中提供的对应类型的Provider中GetVersion返回的值不在最大版本和最小版本之间，那么就不会被允许加载进来。

```cpp
module_center->AddProvider(new LoginModuleImplV1Provider());
```

通过这种方式，可以将LoginModuleImplV1Provider注册到ModuleCenter中，然后创建并管理LoginModuleImplV1的实例。但是这样就显式地依赖了LoginModuleImplV1Provider，违反了前面说过的依赖倒置原则，对开闭原则也不友好，因为这样就只能通过修改代码来实现扩展了。

```cpp
#include <x_module/connector.h>
#include "login_module/login_module_impl.h"

X_MODULE_CONNECTOR
bool XModuleConnect(x_module::Owner& owner) {
owner.add(new LoginModuleImplV1Provider());
return true;
}
```

为了在加载dll时，来注册Provider，增加了一个connector.cc，添加一个XModuleConnect方法，让dll被加载之后，能够找到XModuleConnect这个符号方法，并进行调用，在XModuleConnect被调用的时候，会调用AddProvider将Provider进行注册。

```cpp
std::string path = GetProgramDir();
module_center->Install(path, "login_module");
```

由于目前login\_module.dll是直接放在exe同目录的，所以这里直接获取了一下exe绝对路径，然后调用Install方法，将路径和dll名login\_module传入进去，这样就完成了注册。

```cpp
auto* p_login_module = module_center->ModuleFromProtocol<LoginModule, LoginModuleProvider>();
if (p_login_module == ptr) {
(*move_result)->Error("-100", "login module 为空");
return;
}
bool islogin = p_login_module->IsLogin();
```

在使用时，只需要LoginModule和LoginModuleProvider这两个抽象，就能获取真实的LoginModuleImplV1这个实例，调用方仅需关心LoginModule所公开的API，完全屏蔽了对实现的依赖。后续底层扩展成了LoginModuleImplV2，只要LoginModule的公开API不变，对上层是无感知的。这种方式完全遵循了前面提到的设计原则，对团队内的多人维护以及后续的更新迭代都带来了稳定的保障。

# 基于vcpkg的C++依赖管理

模块拆分之后，带来的副作用就是依赖管理会变得更加复杂，到C++这边就是CMakeLists的膨胀。从移动端的角度来看这个问题，Android可以通过Gradle来管理依赖，依赖库构建成aar之后上传到Maven仓库，`implementation 'androidx.recyclerview:recyclerview:1.1.0'`像这样通过包名、库名和版本号来依赖具体的库。iOS有CocoaPods，通过添加`pod 'AFNetworking', '~> 2.6'`到Podfile来完成依赖的添加。前端也有NPM这样的包管理器，所有依赖都在package.json这个文件中声明和管理。Flutter侧也可以通过pubspec来管理各个依赖库。为了获得一致的体验，解决C++侧依赖管理的痛点，我们引入了微软官方推出的vcpkg，vcpkg的清单模式可以得到类似的体验。

#### 依赖库配置

这里以fish-ffi-module模块为例子，文件结构如下，其中include文件里面是对外公开的头文件，src文件包含当前库内部使用的代码，cmake文件下的config.cmake.in模版文件用于生成xxx-config.cmake的文件，用于被find\_package找到。

```
.
├── CMakeLists.txt
├── LICENSE
├── cmake
│ └── config.cmake.in
├── include
│ └── fish_ffi_module.h
├── src
│ ├── connector.cc
│ ├── fish_ffi_module_impl_v1.cc
│ └── fish_ffi_module_impl_v1.h
├── vcpkg-configuration.json
└── vcpkg.json
```

vcpkg-configuration.json配置了私有源，后面会讲到。  
vcpkg.json文件，声明了当前库所依赖的其他库，即vcpkg的依赖清单，其中"dependencies"字段声明了所使用的依赖名称。

```json
{
"name": "fish-ffi-module",
"version": "1.0.0",
"description": "A fish-ffi module based on fish-ffi-sdk.",
"homepage": "",
"dependencies": [
"fish-ffi-sdk",
"x-module",
"flutter-sdk"
]
}
```

CMake工程最重要的就是CMakeLists文件了，里面配置了编译相关的设置，添加了相关的注释来帮助理解。

```cmake
cmake_minimum_required(VERSION 3.15)
# 仓库版本常量，升级时修改
set(FISH_FFI_MODULE_VERSION "1.0.0")
project(fish-ffi-module
VERSION ${FISH_FFI_MODULE_VERSION}
DESCRIPTION "A fish-ffi module based on fish-ffi-sdk."
HOMEPAGE_URL ""
LANGUAGES CXX)
option(BUILD_SHARED_LIBS "Build using shared libraries" ON)

# vcpkg清单中添加依赖之后，通过find_package就能找到
find_package(fish-ffi-sdk CONFIG REQUIRED)
find_package(flutter-sdk CONFIG REQUIRED)
find_package(x-module CONFIG REQUIRED)

# configure_package_config_file 生成config要用到
include(CMakePackageConfigHelpers)
# install 安装要用到
include(GNUInstallDirs)

# 当前库的头文件和源文件
aux_source_directory(include HEADER_LIST)
aux_source_directory(src SRC_LIST)
add_library(fish-ffi-module SHARED
${HEADER_LIST}
${SRC_LIST}
)
# 设置别名
add_library(fish-ffi-module::fish-ffi-module ALIAS fish-ffi-module)

# 设置动态库导出宏，PRIVATE为编译时，INTERFACE为运行时
if (BUILD_SHARED_LIBS AND WIN32)
target_compile_definitions(fish-ffi-module
PRIVATE "FISH_FFI_MODULE_EXPORT=__declspec(dllexport)"
INTERFACE "FISH_FFI_MODULE_EXPORT=__declspec(dllimport)")
endif ()
target_compile_features(fish-ffi-module PUBLIC cxx_std_17)

# 添加头文件
target_include_directories(fish-ffi-module PUBLIC
$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/>
$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
# 链接库文件
target_link_libraries(fish-ffi-module PRIVATE fish-ffi-sdk::fish-ffi-sdk)
target_link_libraries(fish-ffi-module PRIVATE flutter-sdk::flutter-sdk)
target_link_libraries(fish-ffi-module PRIVATE x-module::x-module)

# 基于config.cmake.in的模板生成xxx-config.cmake的文件
configure_package_config_file(
cmake/config.cmake.in
${CMAKE_CURRENT_BINARY_DIR}/fish-ffi-module-config.cmake
INSTALL_DESTINATION ${CMAKE_INSTALL_DATADIR}/fish-ffi-module
NO_SET_AND_CHECK_MACRO)
# 生成xx-config-version.cmake文件
write_basic_package_version_file(
${CMAKE_CURRENT_BINARY_DIR}/fish-ffi-module-config-version.cmake
VERSION ${FISH_FFI_MODULE_VERSION}
COMPATIBILITY SameMajorVersion)
# 将上面生成的两个config文件，安装到share/fish-ffi-module下
install(
FILES
${CMAKE_CURRENT_BINARY_DIR}/fish-ffi-module-config.cmake
${CMAKE_CURRENT_BINARY_DIR}/fish-ffi-module-config-version.cmake
DESTINATION
${CMAKE_INSTALL_DATADIR}/fish-ffi-module)
# 安装头文件
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# install target
install(TARGETS fish-ffi-module
EXPORT fish-ffi-module-targets
RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
# 导出
install(EXPORT fish-ffi-module-targets
NAMESPACE fish-ffi-module::
DESTINATION ${CMAKE_INSTALL_DATADIR}/fish-ffi-module)
```

这里面最重要的一点是配置xx-config.cmake和xx-config-version.cmake的生成，vcpkg会在源码首次拉下来的时候进行编译，编译完在相应库的share目录生成上述两个文件，并且在CMake配置阶段执行，这样在使用find\_package的时候就能获取到这个库以及对应版本号。总结一下就是，vcpkg帮助完成了代码的下载、编译和配置，然后就可以方便的链接三方库了。

#### 自定义私有源

私有源的自定义非常简单，其实就是个Git仓库，push到私有的git托管服务上即可。只需要将依赖库的最新commit信息记录到这个仓库里面，通过模版化的配置就能完成依赖库的发布。

```
.
├── ports
│ ├── fish-ffi-module
│ │ ├── portfile.cmake
│ │ └── vcpkg.json
│ └── x-module
│ ├── portfile.cmake
│ └── vcpkg.json
├── versions
│ ├── f-
│ │ └── fish-ffi-module.json
│ └── x-
│ │ └── x-module.json
│ └──baseline.json
└── LICENSE
```

vcpkg里面对依赖库的定义叫port，这里定义了两个port，分别是fish-ffi-module和x-module。其中的文件说明如下：

- • portfile.cmake中定义了这个库的git地址、分支、commitId、编译配置等信息

- • vcpkg.json定义了这个port的依赖以及版本信息，如果有依赖，则会在编译这个库之前优先编译依赖。

- • versions下的文件按首字母分类，里面定义了version和git-tree的对应关系。在port新增或更新之后，git-tree需要重新生成，通过`git rev-parse HEAD:ports/x-module`来生成git-tree，然后通过`git commit --amend`追加提交到刚刚的commit中。

在需要使用私有源的CMake工程根目录，添加vcpkg-configuration.json，里面内容如下。default-registry为默认源，指向官方的地址即可。registries下添加自定义的私有源，再通过指定packages，表示里面的库需要在这个私有源查找。这样就完成了私有源的配置。

```json
{
"default-registry": {
"kind": "git",
"repository": "https://github.com/microsoft/vcpkg",
"baseline": "f4b262b259145adb2ab0116a390b08642489d32b"
},
"registries": [
{
"kind": "git",
"repository": "xxx.git",
"baseline": "1ad54586a5a2fadb8c44d3f8f47754e849fc5a38",
"packages": [ "x-module", "fish-ffi-sdk", "fish-ffi-module"]
}
]
}
```

在versions文件夹下还有一个baseline.json的文件，这个文件主要是设置基线用的，不像其他的依赖管理工具，vcpkg主要是通过这个基线来设置当前所使用的版本号的。  
vcpkg可以胜任依赖管理的相关工作，综上所述只是一个简单使用，相比其他平台的依赖管理工具略显繁琐，除此之外还有很多其他能力，需要到vcpkg.io的官方文档里面探索了。

# 总结

Flutter应用接入Windows平台，主要遇到的问题就是Windows侧的一些能力的提供，需要对齐Android和iOS的已有能力。因为使用的是C++的开发语言，对于移动端开发者并不是那么友好，学习曲线相对会比较抖。不过一旦平台侧的能力完善之后，又可以回归到Flutter这个熟悉的领域了，享受Flutter开发带来的便捷。此外Windows应用的开发不仅仅只是屏幕加大版的移动端开发，还包括不同的输入设备(键盘鼠标)、交互习惯、样式风格、操作系统特性等，为了更好的平台体验，会带来一定的适配成本，这一块后续也将持续投入。
