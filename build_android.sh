#!/bin/sh -e


echo "dirname=$0"
RootDir=$(cd `dirname $0`; pwd)
echo "RootDir=$RootDir"
cd ${RootDir}

source ${RootDir}/env_mac.sh
echo \n\n------------------------------------\n\n
export ANDROID_SDK=/Users/game-netease/Library/Android/sdk
export ANDROID_HOME=$ANDROID_SDK
export ANDROID_NDK=$ANDROID_SDK/ndk/25.0.8775105
export env_cmake=$ANDROID_SDK/cmake/3.18.1/bin
export CMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake
export PATH=$ANDROID_HOME:$env_cmake$:$ANDROID_SDK/cmdline-tools/latest/bin:$PATH



source ~/.bashrc
echo "PATH=$PATH"
echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH"

# chmod +x ${VCPKG_ROOT}/bootstrap-vcpkg.sh
# ${VCPKG_ROOT}/bootstrap-vcpkg.sh -disableMetrics
# ${VCPKG_ROOT}/vcpkg install libvpx libyuv opus aom

# # rustup-init
# rustup default 1.75.0
# rustup component add rustfmt

# cd ${RootDir}/libs/portable/
# python3 -m pip install --upgrade pip
# pip3 install -r requirements.txt

# wget https://github.com/c-smile/sciter-sdk/raw/master/bin.osx/libsciter.dylib
# brew tap leoafarias/fvms
# brew install fvm cocoapods
# fvm global 3.16.9
# cargo install flutter_rust_bridge_codegen --version "1.80.1" --features "uuid"

# #Sciter版本
# python3 build.py

# #Flutter版本
# # flutter_rust_bridge_codegen --rust-input ./src/flutter_ffi.rs --dart-output ./flutter/lib/generated_bridge.dart --c-output ./flutter/macos/Runner/bridge_generated.h
# # python3 ./build.py --flutter

# install ffigen and llvm 
dart pub global activate ffigen 5.0.1
# on Ubuntu 18, it is: sudo apt install libclang-9-dev
# sudo apt-get install libclang-dev


cargo install flutter_rust_bridge_codegen
cargo add libvpx
cargo add libyuv
cargo add opus
# cargo add aom
cargo add sodium

rustup target add aarch64-linux-android
cargo install cargo-ndk
#VCPKG_ROOT=$HOME/vcpkg ANDROID_NDK_HOME=$HOME/android-ndk-r23c flutter/ndk_arm64.sh
cargo ndk --platform 21 --target aarch64-linux-android build --release --features flutter,hwcodec
