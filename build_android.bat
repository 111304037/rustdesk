@echo on


@REM python
set PythonLocation=E:\MyFiles\Python\Python38
set PY_PIP=%PY_ROOT%\Scripts
set PY_DLLs=%PY_ROOT%\DLLs
set PY_LIBS=%PY_ROOT%\Lib\site-packages
set PYTHONPATH=%PythonLocation%;%PY_PIP%;%PY_LIBS%;%PY_DLLs%;
set PATH=%PYTHONPATH%;%PATH%


@REM rustdesk
set env_toolchain=%~dp0\deps\toolchain-windows\bin
set VCPKG_ROOT=%~dp0\deps\vcpkg\vcpkg
set VPX_LIB_DIR=%VCPKG_ROOT%\installed\arm64-windows-static
set LD_LIBRARY_PATH=%VCPKG_ROOT%\installed\arm64-windows-static

set pkg_vpx=%VCPKG_ROOT%\packages\libvpx_arm64-windows-static\lib\pkgconfig
set PKG_CONFIG_PATH=%VCPKG_ROOT%/installed/arm64-windows-static/lib/pkgconfig;%pkg_vpx%;%PKG_CONFIG_PAT%

set env_nasm=%VCPKG_ROOT%\downloads\tools\nasm\nasm-2.15.05
set env_perl=%VCPKG_ROOT%\downloads\tools\perl\5.32.1.1\perl\bin
set env_cmake=%VCPKG_ROOT%\downloads\tools\cmake-3.29.2-windows\cmake-3.29.2-windows-i386\bin
set env_vckpg=%env_nasm%;%env_perl%;%env_cmake%;

set VCPKGRS_DYNAMIC=1
set LLVM_ROOT=D:\Program Files\LLVM
set LIBCLANG_PATH=%LLVM_ROOT%\bin
set env_rustdesk_build=%env_vckpg%;%env_toolchain%;%PKG_CONFIG_PATH%;

set PATH=%env_rustdesk_build%;%LD_LIBRARY_PATH%;%VCPKG_ROOT%;%LLVM_ROOT%;%PATH%;







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



cargo install flutter_rust_bridge_codegen
cargo add libvpx
cargo add libyuv
cargo add opus
@REM cargo add aom
cargo add sodium

rustup target add aarch64-linux-android
cargo install cargo-ndk
@REM VCPKG_ROOT=$HOME/vcpkg ANDROID_NDK_HOME=$HOME/android-ndk-r23c flutter/ndk_arm64.sh
cargo ndk --platform 21 --target aarch64-linux-android build --release --features flutter,hwcodec
cmd /k




