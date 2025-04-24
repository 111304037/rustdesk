#!/bin/sh -e

echo "dirname=$0"
RootDir=$(cd `dirname $0`; pwd)
echo "RootDir=$RootDir"
cd ${RootDir}

export ANDROID_SDK=/Users/game-netease/Library/Android/sdk
export ANDROID_HOME=$ANDROID_SDK
export ANDROID_NDK=$ANDROID_SDK/ndk/26.0.10792818
export ANDROID_NDK_HOME=$ANDROID_NDK
export ANDROID_NDK_ROOT=$ANDROID_NDK
export env_cmake=$ANDROID_SDK/cmake/3.18.1/bin
export CMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake
export PATH=$ANDROID_HOME:$env_cmake:$ANDROID_SDK/cmdline-tools/latest/bin:$PATH

export NDK_HOME="$ANDROID_NDK_HOME"
# 添加 NDK 编译器到 PATH
export PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH"

# 设置 Android API 级别
export ANDROID_PLATFORM=34
export MODE=${MODE:=release}
# 设置交叉编译相关环境变量
export TARGET_AR="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-ar"
export TARGET_CC="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android$$ANDROID_PLATFORM-clang"
export TARGET_CXX="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android$$ANDROID_PLATFORM-clang++"

# 设置 Rust 目标
export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="$TARGET_CC"
export CC_aarch64_linux_android="$TARGET_CC"
export CXX_aarch64_linux_android="$TARGET_CXX"
export AR_aarch64_linux_android="$TARGET_AR"


# VCPKG Configuration
export ANDROID_TARGET=arm64-v8a
export VCPKG_ARCH=arm64-android
export VCPKG_DEFAULT_TRIPLET=arm64-android
export VCPKG_TARGET_TRIPLET=$VCPKG_DEFAULT_TRIPLET
export VCPKG_ROOT=${RootDir}/deps/vcpkg/vcpkg
# mac使用的是静态库，屏蔽掉
# export VCPKGRS_DYNAMIC=1
export PKG_CONFIG_ALLOW_CROSS=1
# export PKG_CONFIG_SYSROOT_DIR=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/sysroot

# # arm64-osx-dynamic.cmake
# set(VCPKG_TARGET_ARCHITECTURE arm64)
# set(VCPKG_CRT_LINKAGE dynamic)
# set(VCPKG_LIBRARY_LINKAGE dynamic)  # 关键配置项
# set(VCPKG_OSX_ARCHITECTURES arm64)

# Include Paths
export CPATH=${RootDir}/vcpkg_installed/$VCPKG_ARCH/include:$CPATH
export C_INCLUDE_PATH=${RootDir}/vcpkg_installed/$VCPKG_ARCH/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=${RootDir}/vcpkg_installed/$VCPKG_ARCH/include:$CPLUS_INCLUDE_PATH
# Library Paths 
export LIBRARY_PATH=${RootDir}/vcpkg_installed/$VCPKG_ARCH/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=${RootDir}/vcpkg_installed/$VCPKG_ARCH/lib:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=${RootDir}/vcpkg_installed/$VCPKG_ARCH/lib:$DYLD_LIBRARY_PATH
export PKG_CONFIG_PATH=${RootDir}/vcpkg_installed/$VCPKG_ARCH/lib/pkgconfig:$PKG_CONFIG_PATH

# # LIB pkgconfig
# # VPX Configuration
# export VPX_INCLUDE_DIR=${RootDir}/vcpkg_installed/$VCPKG_ARCH/include
# export VPX_LIB_DIR=${RootDir}/vcpkg_installed/$VCPKG_ARCH//lib
# export LIBVPX_INCLUDE_DIR=$LIBVPX_INCLUDE_DIR
# export LIBVPX_LIB_DIR=$VPX_LIB_DIR

# # OPUS Configuration
# export OPUS_INCLUDE_DIR=${RootDir}/vcpkg_installed/$VCPKG_ARCH/include
# export OPUS_LIB_DIR=${RootDir}/vcpkg_installed/$VCPKG_ARCH/lib

# ## opus
# export PKG_CONFIG_PATH=/opt/homebrew/Cellar/opus/1.5.2/lib/pkgconfig:$PKG_CONFIG_PATH
# ## ffmpeg
# export FFMPEG_DIR=/opt/homebrew/Cellar/ffmpeg/7.1.1_2
# export PKG_CONFIG_PATH=$FFMPEG_DIR/lib/pkgconfig:$PKG_CONFIG_PATH
# export LIBRARY_PATH=$FFMPEG_DIR/lib:$LIBRARY_PATH
# export CPATH=$FFMPEG_DIR/include:$CPATH
export YUV_LIBRARY_PATH=${RootDir}/vcpkg_installed/$VCPKG_ARCH/lib



# PATH
export PATH=$HOME/fvm/default/bin:$PATH
export PATH=${PKG_CONFIG_PATH}:${VCPKG_ROOT}:$PATH

# Cargo
export CARGO_ROOT=/Users/game-netease/.cargo/bin

# Architecture
export CARGO_CFG_TARGET_ARCH=aarch64
# Debug settings
# 详细build log，只有报错时才打开，方便找问题
export CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG=true
export CARGO_PROFILE_RELEASE_BUILD_OVERRIDE_DEBUG=true
export RUST_BACKTRACE=full

# #设置flutter中国镜像
# export PUB_HOSTED_URL=https://pub.flutter-io.cn
# export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn


CROSS_COMPILE=`xcode-select --print-path`/Toolchains/XcodeDefault.xctoolchain/usr/bin/
CROSS_TOP=`xcode-select --print-path`/Platforms/iPhoneOS.platform/Developer
CROSS_SDK=iPhoneOS.sdk



# Source cargo environment
source $HOME/.cargo/env
source ~/.bashrc
echo "PATH=$PATH"

