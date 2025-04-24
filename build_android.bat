@echo on

set RootDir=%~dp0
cd /d %RootDir%


@REM VCPKG Configuration
set ANDROID_TARGET=arm64-v8a
set ANDROID_ABI=%ANDROID_TARGET%

set VCPKG_ARCH=arm64-android
set VCPKG_DEFAULT_TRIPLET=arm64-android
set VCPKG_TARGET_TRIPLET=%VCPKG_DEFAULT_TRIPLET%

set VCPKG_ROOT=%RootDir%/deps/vcpkg/vcpkg

@REM mac使用的是静态库，屏蔽掉
@REM set VCPKGRS_DYNAMIC=1
set PKG_CONFIG_ALLOW_CROSS=1
@REM set PKG_CONFIG_SYSROOT_DIR=%ANDROID_NDK_HOME%/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
set VCPKG_TARGET_ARCHITECTURE=arm64
set VCPKG_CRT_LINKAGE=dynamic
set VCPKG_LIBRARY_LINKAGE=static
set VCPKG_CMAKE_SYSTEM_NAME=Android

@REM # 启用 NEON 指令集
set VCPKG_C_FLAGS="-march=armv8-a+crypto+crc -mfpu=neon-fp-armv8 %VCPKG_C_FLAGS%"
set VCPKG_CXX_FLAGS="-march=armv8-a+crypto+crc -mfpu=neon-fp-armv8 %VCPKG_CXX_FLAGS%"


@REM Include Paths
set CPATH=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/include;%CPATH%
set C_INCLUDE_PATH=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/include;%C_INCLUDE_PATH%
set CPLUS_INCLUDE_PATH=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/include;%CPLUS_INCLUDE_PATH%
@REM Library Paths 
set LIBRARY_PATH=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/lib;/opt/homebrew/lib;%LIBRARY_PATH%
set LD_LIBRARY_PATH=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/lib;%LD_LIBRARY_PATH%
set DYLD_LIBRARY_PATH=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/lib;%DYLD_LIBRARY_PATH%
set PKG_CONFIG_PATH=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/lib/pkgconfig;%PKG_CONFIG_PATH%

@REM @REM LIB pkgconfig
@REM @REM VPX Configuration
@REM set VPX_INCLUDE_DIR=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/include
@REM set VPX_LIB_DIR=%RootDir%/vcpkg_installed/%VCPKG_ARCH%//lib
@REM set LIBVPX_INCLUDE_DIR=%LIBVPX_INCLUDE_DIR%
@REM set LIBVPX_LIB_DIR=%VPX_LIB_DIR%

@REM @REM OPUS Configuration
@REM set OPUS_INCLUDE_DIR=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/include
@REM set OPUS_LIB_DIR=%RootDir%/vcpkg_installed/%VCPKG_ARCH%/lib

@REM PATH
set PATH=%PKG_CONFIG_PATH%;%VCPKG_ROOT%;%PATH%



set ANDROID_SDK=B:\Android\sdk
if not exist "%ANDROID_SDK%" (
	set ANDROID_SDK=D:\App\Android\sdk
)
set ANDROID_HOME=%ANDROID_SDK%
set ANDROID_NDK=%ANDROID_SDK%/ndk/26.0.10792818
set ANDROID_NDK_HOME=%ANDROID_NDK%
set ANDROID_NDK_ROOT=%ANDROID_NDK%
set cmake_version=3.22.1
set env_cmake=%ANDROID_SDK%/cmake/%cmake_version%/bin
set env_nasm=%RootDir%\deps\toolchain-windows\tools\nasm-2.16.03
set CMAKE_ASM_COMPILER=%env_nasm%/nasm.exe
@REM set CMAKE_TOOLCHAIN_FILE=%ANDROID_NDK%/build/cmake/android.toolchain.cmake
set CMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%/scripts/buildsystems/vcpkg.cmake
set VCPKG_CHAINLOAD_TOOLCHAIN_FILE=%ANDROID_NDK%/build/cmake/android.toolchain.cmake
set PATH=%ANDROID_HOME%;%env_cmake%;%ANDROID_SDK%/cmdline-tools/latest/bin;%env_nasm%;%PATH%


set LLVM_ROOT=%ANDROID_NDK%/toolchains/llvm/prebuilt/windows-x86_64
set LIBCLANG_PATH=%LLVM_ROOT%\bin
set FLUTTER_HOME=B:\Android\flutter
set env_rustdesk_build=%env_vckpg%;%env_toolchain%;%PKG_CONFIG_PATH%;%LIBCLANG_PATH%;%FLUTTER_HOME%\bin;
set PATH=%env_rustdesk_build%;%LD_LIBRARY_PATH%;%VCPKG_ROOT%;%LLVM_ROOT%;%PATH%;
set CMAKE_ASM_COMPILER=%LIBCLANG_PATH%\aarch64-linux-android25-clang.cmd
set ASM=%CMAKE_ASM_COMPILER%



@REM Cargo
set CARGO_ROOT=/Users/game-netease/.cargo/bin

@REM Architecture
set CARGO_CFG_TARGET_ARCH=aarch64
@REM Debug settings
@REM 详细build log，只有报错时才打开，方便找问题
@REM set CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG=true
@REM set CARGO_PROFILE_RELEASE_BUILD_OVERRIDE_DEBUG=true
@REM set RUST_BACKTRACE=full

@REM @REM设置flutter中国镜像
@REM set PUB_HOSTED_URL=https;//pub.flutter-io.cn
@REM set FLUTTER_STORAGE_BASE_URL=https;//storage.flutter-io.cn


@REM CROSS_COMPILE=`xcode-select --print-path`/Toolchains/XcodeDefault.xctoolchain/usr/bin/
@REM CROSS_TOP=`xcode-select --print-path`/Platforms/iPhoneOS.platform/Developer



@REM rustdesk
set env_toolchain=%~dp0\deps\toolchain-windows\bin

@REM vcpkg
set VCPKG_ROOT=%~dp0deps\vcpkg\vcpkg
set pkg_vpx=%VCPKG_ROOT%\packages\libvpx_arm64-static\lib\pkgconfig
set PKG_CONFIG_PATH=%VCPKG_ROOT%/installed/arm64/lib/pkgconfig;%pkg_vpx%;%PKG_CONFIG_PAT%
set LD_LIBRARY_PATH=%VCPKG_ROOT%\installed\arm64-static\lib
set VPX_LIB_DIR=%VCPKG_ROOT%\installed\arm64-static\lib
set VPX_INCLUDE_DIR=%VCPKG_ROOT%\installed\arm64-static\include



@REM set HTTP_PROXY=http://10.227.199.162:808
@REM set HTTPS_PROXY=http://10.227.199.162:808
git config --global http.proxy http://10.227.199.162:808
git config --global https.proxy http://10.227.199.162:808

@REM git config --global --unset http.proxy
@REM git config --global --unset https.proxy
set VCPKG_KEEP_ENV_VARS=MSYS2_MIRROR
set MSYS2_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/msys2
set VCPKG_DEFAULT_TRIPLET_OVERRIDE=x64-windows-tuna


clang --version
@REM %CMAKE_ASM_COMPILER% --version
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install nasm for host platform
    goto ;END
)


@REM first init vcpkg
if EXIST "%VCPKG_ROOT%\vcpkg.exe" (
    echo "exist %VCPKG_ROOT%\vcpkg.exe"
) else (
	call deps\vcpkg\vcpkg\bootstrap-vcpkg.bat
)
vcpkg --version
vcpkg install --triplet=%VCPKG_TARGET_TRIPLET%
if exist "%VCPKG_ROOT%\installed" (
    echo link;%VCPKG_ROOT%\installed exist
) else (
    echo link;%VCPKG_ROOT%\installed from %RootDir%\vcpkg_installed
    mklink /D "%VCPKG_ROOT%\installed" "%RootDir%\vcpkg_installed"
)

@REM goto ;END

@REM @REM vcpkg_cli probe libvpx
@REM @REM vcpkg list
@REM pkg-config --libs opus
@REM @REM pkg-config --libs libavcodec
@REM @REM pkg-config --cflags libavcodec

@REM @REM cargo run
@REM ::cargo clean
@REM ::cargo cache

@REM @REM cargo clean
@REM @REM cargo update
@REM @REM cargo build


@REM cd /d flutter
@REM call flutter clean
@REM @REM flutter pub cache clean
@REM @REM rd /s /q  .dart_tool
@REM @REM rd /s /q  build
@REM del  pubspec.lock
@REM @REM  更新 Flutter 依赖,包括CocoaPods
@REM call flutter pub get
@REM echo "[*]exit fullter!!!"
@REM cd /d %RootDir%

@REM @REM  显示当前 Flutter 版本
@REM echo "Flutter version:"
@REM call flutter --version
@REM call flutter --disable-analytics
@REM call dart --disable-analytics
@REM call flutter doctor -v

@REM cargo install cargo-ndk
@REM rustup target install aarch64-linux-android
@REM rustup target add aarch64-linux-android

@REM @REM  安装 flutter_rust_bridge_codegen 工具
@REM @REM echo "[*]uninstall flutter_rust_bridge_codegen"
@REM @REM cargo uninstall flutter_rust_bridge_codegen
@REM where flutter_rust_bridge_codegen >nul 2>&1
@REM if %errorlevel% neq 0 (
@REM     echo [+] install flutter_rust_bridge_codegen v1.80.0...
@REM 	cargo install flutter_rust_bridge_codegen --version "1.80.0" --features "uuid"
@REM ) else (
@REM     echo [*] flutter_rust_bridge_codegen exist
@REM )
@REM @REM 确保 Rust 代码已正确编译
@REM @REM cargo build --verbose
@REM @REM 生成绑定代码
@REM del /s /q  flutter\lib\generated_bridge.dart
@REM set WIN32_LLVM_ROOT=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\Llvm\x64
@REM set gen_args=--rust-input %RootDir%\src\flutter_ffi.rs --dart-output %RootDir%\flutter\lib\generated_bridge.dart --llvm-path "%WIN32_LLVM_ROOT%"
@REM echo "[*]flutter_rust_bridge_codegen %gen_args%"
@REM flutter_rust_bridge_codegen %gen_args%
@REM if %ERRORLEVEL% EQU 0 (
@REM     echo ✅ Codegen succeeded
	
@REM     @REM 为 ARM64 设备添加目标支持
@REM     @REM rustup target add aarch64-linux-android
@REM     @REM cargo install cargo-ndk
@REM     cargo ndk --platform 25 --target aarch64-linux-android build --release --features flutter,hwcodec

@REM ) else (
@REM     echo ❌ Codegen failed
@REM )


@REM ;END
cmd /k




