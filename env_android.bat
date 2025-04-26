@REM @echo off
@REM setlocal EnableDelayedExpansion


set "RootDir=%~dp0"
set ToolChain=%RootDir%deps\toolchain-windows
set PATH=%ToolChain%\bin;%ToolChain%\tools;%PATH%

rem Android SDK and NDK paths
set ANDROID_SDK=B:\Android\sdk
if not exist "%ANDROID_SDK%" (
	set ANDROID_SDK=D:\App\Android\sdk
)
@REM set "ANDROID_SDK=%LOCALAPPDATA%\Android\Sdk"
set "ANDROID_HOME=%ANDROID_SDK%"
set "ANDROID_NDK=%ANDROID_SDK%\ndk\26.0.10792818"
set "ANDROID_NDK_HOME=%ANDROID_NDK%"
set "ANDROID_NDK_ROOT=%ANDROID_NDK%"
set cmake_version=3.22.1
set "env_cmake=%ANDROID_SDK%\cmake\%cmake_version%\bin"
set "CMAKE_TOOLCHAIN_FILE=%ANDROID_NDK%\build\cmake\android.toolchain.cmake"

@REM LLVM
set LLVM_ROOT=%ANDROID_NDK%/toolchains/llvm/prebuilt/windows-x86_64
set LIBCLANG_PATH=%LLVM_ROOT%\bin
set PATH=%LLVM_ROOT%;%LIBCLANG_PATH%;%PATH%;

@REM flutter env
set FLUTTER_HOME=B:\Android\flutter
@REM C:\Users\mengxingquan\AppData\Local\Pub\Cache\bin
set FVM=%LOCALAPPDATA%\Pub\Cache\bin
set "PATH=%ANDROID_HOME%;%env_cmake%;%ANDROID_SDK%\cmdline-tools\latest\bin;%FLUTTER_HOME%\bin;%FVM%;%PATH%"

set "NDK_HOME=%ANDROID_NDK_HOME%"
rem Add NDK compiler to PATH
set "PATH=%ANDROID_NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin;%PATH%"

rem Set Android API level
set "ANDROID_PLATFORM=34"
if not defined MODE set "MODE=release"

rem Set cross-compilation environment variables
set "TARGET_AR=%ANDROID_NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin\llvm-ar.exe"
set "TARGET_CC=%ANDROID_NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin\aarch64-linux-android%ANDROID_PLATFORM%-clang.cmd"
set "TARGET_CXX=%ANDROID_NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin\aarch64-linux-android%ANDROID_PLATFORM%-clang++.cmd"

rem Set Rust target environment variables
set "CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=%TARGET_CC%"
set "CC_aarch64_linux_android=%TARGET_CC%"
set "CXX_aarch64_linux_android=%TARGET_CXX%"
set "AR_aarch64_linux_android=%TARGET_AR%"

rem VCPKG Configuration
set "ANDROID_TARGET=arm64-v8a"
set "VCPKG_ARCH=arm64-android"
set "VCPKG_DEFAULT_TRIPLET=arm64-android"
set "VCPKG_TARGET_TRIPLET=%VCPKG_DEFAULT_TRIPLET%"
set "VCPKG_ROOT=%RootDir%\deps\vcpkg\vcpkg"
set "PKG_CONFIG_ALLOW_CROSS=1"
rem Include Paths
set "CPATH=%VCPKG_ROOT%\installed\%VCPKG_ARCH%\include;%CPATH%"
set "C_INCLUDE_PATH=%VCPKG_ROOT%\installed\%VCPKG_ARCH%\include;%C_INCLUDE_PATH%"
set "CPLUS_INCLUDE_PATH=%VCPKG_ROOT%\installed\%VCPKG_ARCH%\include;%CPLUS_INCLUDE_PATH%"

rem Library Paths
set "LIBRARY_PATH=%VCPKG_ROOT%\installed\%VCPKG_ARCH%\lib;%LIBRARY_PATH%"
set LD_LIBRARY_PATH=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/lib;%LD_LIBRARY_PATH%
set DYLD_LIBRARY_PATH=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/lib;%DYLD_LIBRARY_PATH%
set PKG_CONFIG_PATH=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/lib/pkgconfig;%PKG_CONFIG_PATH%
set "PATH=%PKG_CONFIG_PATH%;%VCPKG_ROOT%;%PATH%"

rem Debug settings
set "CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG=true"
set "CARGO_PROFILE_RELEASE_BUILD_OVERRIDE_DEBUG=true"
set "RUST_BACKTRACE=full"


@REM set HTTP_PROXY=http://10.227.199.162:808
@REM set HTTPS_PROXY=http://10.227.199.162:808
git config --global http.proxy http://10.227.199.162:808
git config --global https.proxy http://10.227.199.162:808

@REM git config --global --unset http.proxy
@REM git config --global --unset https.proxy
set VCPKG_KEEP_ENV_VARS=MSYS2_MIRROR
set MSYS2_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/msys2
set VCPKG_DEFAULT_TRIPLET_OVERRIDE=x64-windows-tuna


set WIN32_LLVM_ROOT="C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\Llvm\x64"

@REM @REM rem 在endlocal之前将需要传递的变量重新设置到父级环境
@REM endlocal & (
@REM     set "PATH=%PATH%"
@REM     set "ANDROID_SDK=%ANDROID_SDK%"
@REM     rem Export all other environment variables...
@REM )