@echo on
cd /d %~dp0

@REM python
set PythonLocation=E:\MyFiles\Python\Python38
if not exist "%PythonLocation%" (
	set PythonLocation=D:\App\Python310
)
set PY_PIP=%PY_ROOT%\Scripts
set PY_DLLs=%PY_ROOT%\DLLs
set PY_LIBS=%PY_ROOT%\Lib\site-packages
set PYTHONPATH=%PythonLocation%;%PY_PIP%;%PY_LIBS%;%PY_DLLs%;
set PATH=%PYTHONPATH%;%PATH%


@REM rustdesk
set env_toolchain=%~dp0\deps\toolchain-windows\bin

@REM vcpkg
set VCPKG_ROOT=%~dp0deps\vcpkg\vcpkg
set pkg_vpx=%VCPKG_ROOT%\packages\libvpx_arm64-static\lib\pkgconfig
set PKG_CONFIG_PATH=%VCPKG_ROOT%/installed/arm64/lib/pkgconfig;%pkg_vpx%;%PKG_CONFIG_PAT%
set LD_LIBRARY_PATH=%VCPKG_ROOT%\installed\arm64-static\lib
set VPX_LIB_DIR=%VCPKG_ROOT%\installed\arm64-static\lib
set VPX_INCLUDE_DIR=%VCPKG_ROOT%\installed\arm64-static\include


set env_nasm=%VCPKG_ROOT%\downloads\tools\nasm\nasm-2.16.03
set env_perl=%VCPKG_ROOT%\downloads\tools\perl\5.32.1.1\perl\bin
@REM set env_cmake=%VCPKG_ROOT%\downloads\tools\cmake-3.30.1-windows\cmake-3.30.1-windows-i386\bin
set env_vckpg=%env_nasm%;%env_perl%;%env_cmake%;

set VCPKGRS_DYNAMIC=1
set LLVM_ROOT=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\Llvm\x64
set LIBCLANG_PATH=%LLVM_ROOT%\bin
set env_rustdesk_build=%env_vckpg%;%env_toolchain%;%PKG_CONFIG_PATH%;%LIBCLANG_PATH%;

set PATH=%env_rustdesk_build%;%LD_LIBRARY_PATH%;%VCPKG_ROOT%;%LLVM_ROOT%;%PATH%;

@REM set HTTP_PROXY=http://10.227.199.162:808
@REM set HTTPS_PROXY=http://10.227.199.162:808
git config --global http.proxy http://10.227.199.162:808
git config --global https.proxy http://10.227.199.162:808

@REM git config --global --unset http.proxy
@REM git config --global --unset https.proxy
set VCPKG_KEEP_ENV_VARS=MSYS2_MIRROR
set MSYS2_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/msys2
set VCPKG_DEFAULT_TRIPLET_OVERRIDE=arm64-windows-tuna

clang --version

@REM first init vcpkg
@REM bootstrap-vcpkg.bat
@REM vcpkg install libvpx:x64-windows-static
@REM vcpkg install libyuv:x64-windows-static
@REM vcpkg install opus:x64-windows-static
@REM vcpkg install aom:x64-windows-static
@REM vcpkg_cli probe libvpx
@REM vcpkg list
@REM cargo run
::cargo clean
::cargo cache

set CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG=true
set RUST_BACKTRACE=full
@REM cargo clean
@REM cargo update
@REM cargo build --target aarch64-linux-android



set ANDROID_SDK=B:\Android\sdk
if not exist "%ANDROID_SDK%" (
	set ANDROID_SDK=D:\App\Android\sdk
)

set ANDROID_HOME=%ANDROID_SDK%
set ANDROID_NDK=%ANDROID_SDK%\ndk\25.0.8775105
set ANDROID_NDK_HOME=%ANDROID_NDK%
set env_cmake=%ANDROID_SDK%\cmake\3.18.1\bin
set CMAKE_TOOLCHAIN_FILE=%ANDROID_NDK%/build/cmake/android.toolchain.cmake
set cmake_version=3.18.1
set RUST_BACKTRACE=1
set CARGO_PROFILE_RELEASE_BUILD_OVERRIDE_DEBUG=true

set PATH=%env_cmake%;%ANDROID_SDK%/cmdline-tools/latest/bin;%PATH%

@REM set HTTP_PROXY=127.0.0.1:8899
@REM set HTTPS_PROXY=127.0.0.1:8899
@REM git config --global https.proxy 127.0.0.1:8899


REM build vcpkg
if not exist deps\vcpkg\vcpkg.exe call deps\vcpkg\vcpkg\bootstrap-vcpkg.bat -disableMetrics
REM install required packages
vcpkg install --triplet arm64-android

python -V
nasm -version
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install nasm for host platform
    goto :END
)

cargo install flutter_rust_bridge_codegen
cargo add libvpx
cargo add libyuv
cargo add opus
@REM cargo add aom
cargo add sodium

@REM 为 ARM64 设备添加目标支持
rustup target add aarch64-linux-android
cargo install cargo-ndk
@REM VCPKG_ROOT=$HOME/vcpkg ANDROID_NDK_HOME=$HOME/android-ndk-r23c flutter/ndk_arm64.sh
cargo ndk --platform 25 --target aarch64-linux-android build --release --features flutter,hwcodec

:END
cmd /k




