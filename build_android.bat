@echo on
set VCPKG_ROOT=%~dp0\deps\vcpkg\vcpkg
set VCPKGRS_DYNAMIC=1
set LLVM_ROOT=D:\Program Files\LLVM
set LIBCLANG_PATH=%LLVM_ROOT%\bin
set VPX_LIB_DIR=%VCPKG_ROOT%\installed\x64-windows-static
set LD_LIBRARY_PATH=%VCPKG_ROOT%\installed\x64-windows-static;G:\Mxq_Share\rustdesk\deps\vcpkg\vcpkg\packages\libsodium_x64-windows\lib;

set PY_ROOT=E:\MyFiles\Python\Python38
set PY_PIP=%PY_ROOT%\Scripts
set PY_LIBS=%PY_ROOT%\Lib\site-packages

set env_nasm=G:\Mxq_Share\rustdesk\deps\vcpkg\vcpkg\downloads\tools\nasm\nasm-2.15.05
set env_perl=G:\Mxq_Share\rustdesk\deps\vcpkg\vcpkg\downloads\tools\perl\5.32.1.1\perl\bin

set env_rustdesk_build=%env_nasm%;%env_perl%;
set PATH=%env_rustdesk_build%;%LD_LIBRARY_PATH%;%PY_ROOT%;%PY_PIP%;%PY_LIBS%;%VCPKG_ROOT%;%LLVM_ROOT%;%PATH%;


set ANDROID_SDK=B:\Android\sdk
if not exist "%ANDROID_SDK%" (
	set ANDROID_SDK=E:\App\Android\sdk
)

set ANDROID_HOME=%ANDROID_SDK%
set ANDROID_NDK=%ANDROID_SDK%\ndk\25.0.8775105
set env_cmake=%ANDROID_SDK%\cmake\3.18.1\bin
set CMAKE_TOOLCHAIN_FILE=%ANDROID_NDK%/build/cmake/android.toolchain.cmake
set cmake_version=3.18.1
set RUST_BACKTRACE=1
set CARGO_PROFILE_RELEASE_BUILD_OVERRIDE_DEBUG=true

set PATH=%env_cmake%;%ANDROID_SDK%/cmdline-tools/latest/bin;%PATH%

@REM set HTTP_PROXY=127.0.0.1:8899
@REM set HTTPS_PROXY=127.0.0.1:8899
@REM git config --global https.proxy 127.0.0.1:8899

@REM bootstrap-vcpkg.bat
@REM vcpkg install libvpx:x64-windows-static libyuv:x64-windows-static opus:x64-windows-static
::vcpkg_cli probe libvpx
::vcpkg list
::cargo build
::cargo run
::cargo clean
::cargo cache
@REM cmd /k

cargo install flutter_rust_bridge_codegen
cargo add libvpx
cargo add libyuv
cargo add opus
cargo add aom
cargo add sodium

rustup target add aarch64-linux-android
cargo install cargo-ndk
@REM VCPKG_ROOT=$HOME/vcpkg ANDROID_NDK_HOME=$HOME/android-ndk-r23c flutter/ndk_arm64.sh
cargo ndk --platform 21 --target aarch64-linux-android build --release --features flutter,hwcodec
cmd /k




