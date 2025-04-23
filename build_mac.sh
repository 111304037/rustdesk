#!/bin/sh -e


echo "dirname=$0"
RootDir=$(cd `dirname $0`; pwd)
echo "RootDir=$RootDir"
cd ${RootDir}
pwd

source ${RootDir}/env_mac.sh
echo \n\n------------------------------------\n\n
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
if [ -f "$VCPKG_ROOT/vcpkg" ]; then
    echo "file:${VCPKG_ROOT}/vcpkg exist"
else
    deps/vcpkg/vcpkg/bootstrap-vcpkg.sh
fi
# brew install pkgconf
vcpkg --version
vcpkg help triplet | grep -i osx
# 安装vcpkg.json
vcpkg install --triplet=$VCPKG_TARGET_TRIPLET
# 在清单模式下，默认值为${CMAKE_BINARY_DIR}/vcpkg_installed。
# 在经典模式下，默认值为${VCPKG_ROOT}/installed。
if [ -d "${VCPKG_ROOT}/installed" ]; then
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

# cargo build --verbose
# if [ ! -f "$RootDir/target/debug/libsciter.dylib" ]; then
#     echo "cp $RootDir/deps/libsciter.dylib => $RootDir/target/debug/libsciter.dylib"
#     cp -n "$RootDir/deps/libsciter.dylib" "$RootDir/target/debug/libsciter.dylib"
# fi
# cargo run
# python3 build.py --portable --hwcodec --flutter --vram

#Flutter版本
# #install flutter
brew tap leoafarias/fvm
brew install fvm cocoapods
# 安装 Flutter 版本 https://docs.flutter.cn/release/archive
flutter_ver=3.24.0
fvm install $flutter_ver
# 设置全局flutter版本为
fvm global $flutter_ver

cd flutter
fvm flutter clean
# fvm flutter pub cache clean
rm -rf .dart_tool/
rm -rf build/
rm -rf pubspec.lock
fvm use $flutter_ver
# 更新 Flutter 依赖,包括CocoaPods
fvm flutter pub get

# cd macos
# pod deintegrate
# # pod cache clean --all
# pod install

# 显示当前 Flutter 版本
echo "Flutter version:"
flutter --version
flutter --disable-analytics
dart --disable-analytics
flutter doctor -v


cd ${RootDir}
pwd



# 安装 flutter_rust_bridge_codegen 工具
# cargo uninstall flutter_rust_bridge_codegen
if ! command -v flutter_rust_bridge_codegen &> /dev/null; then
    echo "正在安装 flutter_rust_bridge_codegen v1.80.0..."
    cargo install flutter_rust_bridge_codegen --version "1.80.0" --features "uuid"
elif ! flutter_rust_bridge_codegen --version | grep -q "1.80.0"; then
    echo "检测到版本不匹配，重新安装..."
    cargo install --force flutter_rust_bridge_codegen --version "1.80.0" --features "uuid"
fi

# 确保 Rust 代码已正确编译
# cargo build --verbose
# 生成绑定代码
rm flutter/lib/generated_bridge.dart
rm flutter/macos/Runner/bridge_generated.h
echo "[*]flutter_rust_bridge_codegen --rust-input $RootDir/src/flutter_ffi.rs --dart-output $RootDir/flutter/lib/generated_bridge.dart --c-output $RootDir/flutter/macos/Runner/bridge_generated.h"
flutter_rust_bridge_codegen --rust-input $RootDir/src/flutter_ffi.rs --dart-output $RootDir/flutter/lib/generated_bridge.dart --c-output $RootDir/flutter/macos/Runner/bridge_generated.h
if [ $? -eq 0 ]; then
    echo "✅ Codegen succeeded"

    python3 build.py --flutter
else
    echo "❌ Codegen failed"
fi


exec $SHELL