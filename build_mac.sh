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

echo ==========
deps/vcpkg/vcpkg/bootstrap-vcpkg.sh
# brew install pkgconf
vcpkg --version
vcpkg help triplet | grep -i osx
# 安装vcpkg.json
vcpkg install --triplet=$VCPKG_TARGET_TRIPLET
# 在清单模式下，默认值为${CMAKE_BINARY_DIR}/vcpkg_installed。
# 在经典模式下，默认值为${VCPKG_ROOT}/installed。
if [ -d "$RootDir/vcpkg_installed" ]; then
    echo "link:${VCPKG_ROOT}/installed exist"
else
    echo "link:${VCPKG_ROOT}/installed from $RootDir/vcpkg_installed"
    ln -s $RootDir/vcpkg_installed ${VCPKG_ROOT}/installed 
fi


pkg-config --libs opus
pkg-config --libs libavcodec
pkg-config --cflags libavcodec

# wget https://github.com/c-smile/sciter-sdk/raw/master/bin.osx/libsciter.dylib

# cargo clean
cargo update


# #Sciter版本
# python3 build.py > a.log

cargo build --verbose
if [ ! -f "$RootDir/target/debug/libsciter.dylib" ]; then
    echo "cp $RootDir/deps/libsciter.dylib => $RootDir/target/debug/libsciter.dylib"
    cp -n "$RootDir/deps/libsciter.dylib" "$RootDir/target/debug/libsciter.dylib"
fi
# cargo run
# python3 build.py --portable --hwcodec --flutter --vram

#Flutter版本
# #install flutter
brew tap leoafarias/fvm
brew install fvm cocoapods
# 安装 Flutter 版本 https://docs.flutter.cn/release/archive
flutter_ver=3.29.3
fvm install $flutter_ver
# 设置全局flutter版本为
fvm global $flutter_ver

cd flutter
fvm flutter clean
fvm flutter pub cache clean
rm -rf .dart_tool/
rm -rf build/
fvm use $flutter_ver
# 更新 Flutter 依赖
fvm flutter pub get
cd ..


# 显示当前 Flutter 版本
echo "Flutter version:"
flutter --version
flutter doctor -v
cargo install flutter_rust_bridge_codegen --version "1.80.1" --features "uuid"
flutter_rust_bridge_codegen --rust-input ./src/flutter_ffi.rs --dart-output ./flutter/lib/generated_bridge.dart --c-output ./flutter/macos/Runner/bridge_generated.h
python3 build.py --flutter --hwcodec --unix-file-copy-paste --portable


exec $SHELL