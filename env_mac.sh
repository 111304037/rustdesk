#!/bin/sh -e

echo "dirname=$0"
RootDir=$(cd `dirname $0`; pwd)
echo "RootDir=$RootDir"
cd ${RootDir}

# Architecture
export CARGO_CFG_TARGET_ARCH=aarch64

# Cargo
export CARGO_ROOT=/Users/game-netease/.cargo/bin

# VCPKG Configuration
export VCPKG_ROOT=${RootDir}/deps/vcpkg/vcpkg
export VCPKG_ARCH=arm64-osx
export VCPKG_DEFAULT_TRIPLET=arm64-osx
export VCPKG_TARGET_TRIPLET=$VCPKG_DEFAULT_TRIPLET
# mac使用的是静态库，屏蔽掉
# export VCPKGRS_DYNAMIC=1

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
export LIBRARY_PATH=${RootDir}/vcpkg_installed/$VCPKG_ARCH/lib:/opt/homebrew/lib:$LIBRARY_PATH
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

# PATH
export PATH=$HOME/fvm/default/bin:$PATH
export PATH=${PKG_CONFIG_PATH}:${VCPKG_ROOT}:$PATH

# Debug settings
export CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG=true
export RUST_BACKTRACE=full

# Source cargo environment
source $HOME/.cargo/env
source ~/.bashrc
echo "PATH=$PATH"

