#!/bin/sh -e


echo "dirname=$0"
RootDir=$(cd `dirname $0`; pwd)
echo "RootDir=$RootDir"
cd ${RootDir}

export CARGO_CFG_TARGET_ARCH=aarch64

export CARGO_ROOT=/Users/game-netease/.cargo/bin

#vcpkg
export VCPKG_ROOT=${RootDir}/deps/vcpkg/vcpkg
# export pkg_vpx=${VCPKG_ROOT}/packages/libvpx_x64-osx/lib/pkgconfig
export pkg_vpx=/opt/homebrew/Cellar/libvpx/1.15.1/lib/pkgconfig
export PKG_CONFIG_PATH=${RootDir}/deps/vcpkg/vcpkg/installed/x64-osx/lib/pkgconfig:$pkg_vpx:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=${VCPKG_ROOT}\installed\x64-osx\lib
export VPX_LIB_DIR=${VCPKG_ROOT}\installed\x64-osx\lib
export VPX_INCLUDE_DIR=${VCPKG_ROOT}\installed\x64-osx\include
export VCPKG_DEFAULT_TRIPLET=arm64-osx-dynamic
export VCPKGRS_DYNAMIC=1

# path
export PATH=$HOME/fvm/default/bin:$PATH
export PATH=${PKG_CONFIG_PATH}:${CARGO_ROOT}:$HOME/fvm/default/bin:${VCPKG_ROOT}:$PATH

export CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG=true
export RUST_BACKTRACE=full

source $HOME/.cargo/env
source ~/.bashrc
echo "PATH=$PATH"

