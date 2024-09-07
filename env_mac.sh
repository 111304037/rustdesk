#!/bin/sh -e


echo "dirname=$0"
RootDir=$(cd `dirname $0`; pwd)
echo "RootDir=$RootDir"
cd ${RootDir}

export CARGO_CFG_TARGET_ARCH=aarch64

export CARGO_ROOT=/Users/game-netease/.cargo/bin
export VCPKG_ROOT=${RootDir}/deps/vcpkg/vcpkg

export pkg_vpx=${VCPKG_ROOT}/packages/libvpx_x64-osx/lib/pkgconfig
export PKG_CONFIG_PATH=${RootDir}/deps/vcpkg/vcpkg/installed/x64-osx/lib/pkgconfig:$pkg_vpx:$PKG_CONFIG_PATH


export PATH=$HOME/fvm/default/bin:$PATH
export PATH=${PKG_CONFIG_PATH}:${CARGO_ROOT}:$HOME/fvm/default/bin:${VCPKG_ROOT}:$PATH



source $HOME/.cargo/env
source ~/.bashrc
echo "PATH=$PATH"

