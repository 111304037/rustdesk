#!/bin/sh -e


echo "dirname=$0"
RootDir=$(cd `dirname $0`; pwd)
echo "RootDir=$RootDir"
cd ${RootDir}
pwd

source ${RootDir}/env_mac.sh
source ~/.bashrc
echo "PATH=$PATH"
echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH"

echo "VPX_INCLUDE_DIR=$VPX_INCLUDE_DIR"
# chmod +x ${VCPKG_ROOT}/bootstrap-vcpkg.sh
# ${VCPKG_ROOT}/bootstrap-vcpkg.sh -disableMetrics
# ${VCPKG_ROOT}/vcpkg install libvpx libyuv opus aom

# # rustup-init
# rustup default 1.75.0
# rustup component add rustfmt

# cd ${RootDir}/libs/portable/
# python3 -m pip install --upgrade pip
# pip3 install -r requirements.txt

cd ${RootDir}
pwd

# wget https://github.com/c-smile/sciter-sdk/raw/master/bin.osx/libsciter.dylib
# #install flutter
brew tap leoafarias/fvm
brew install fvm cocoapods
fvm global 3.16.9

# flutter --disable-analytics
# dart --disable-analytics
# flutter doctor -v
cargo install flutter_rust_bridge_codegen --version "1.80.1" --features "uuid"


# #Sciter版本
# python3 build.py > a.log

#Flutter版本
# flutter_rust_bridge_codegen --rust-input ./src/flutter_ffi.rs --dart-output ./flutter/lib/generated_bridge.dart --c-output ./flutter/macos/Runner/bridge_generated.h
# python3 ./build.py --flutter
echo ==========
deps/vcpkg/vcpkg/bootstrap-vcpkg.sh
# brew install pkgconf
vcpkg --version
vcpkg help triplet | grep -i osx
# 安装vcpkg.json
vcpkg install --triplet=$VCPKG_TARGET_TRIPLET
# cargo run
python3 build.py --flutter --hwcodec --unix-file-copy-paste


exec $SHELL