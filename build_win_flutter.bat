@echo on

set RootDir=%~dp0
cd /d %RootDir%
@REM python
set PythonLocation=B:\MyFiles\Python\Python38
if not exist "%PythonLocation%" (
	set PythonLocation=D:\App\Python310
)
set FLUTTER_HOME=B:\Android\flutter
if not exist "%FLUTTER_HOME%" (
	set FLUTTER_HOME=D:\App\Android\flutter
)

set PY_PIP=%PythonLocation%\Scripts
set PY_DLLs=%PythonLocation%\DLLs
set PY_LIBS=%PythonLocation%\Lib\site-packages
set PYTHONPATH=%PythonLocation%;%PY_PIP%;%PY_LIBS%;%PY_DLLs%;
set PATH=%PYTHONPATH%;%PATH%

@REM ::set env_vs=E:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\
@REM set env_vs=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE
@REM set env_cmake=%env_vs%\CommonExtensions\Microsoft\CMake\CMake\bin
@REM if not exist "%env_cmake%" (
@REM 	set env_cmake=D:\Program Files\cmake-3.20.3-windows-x86_64\bin
@REM )

@REM set PATH=%env_cmake%;%PATH%

@REM rustdesk
set env_toolchain=%~dp0\deps\toolchain-windows\bin

@REM VCPKG Configuration
set VCPKG_ROOT=%~dp0deps\vcpkg\vcpkg
set VCPKG_ARCH=x64-windows-static
set VCPKG_DEFAULT_TRIPLET=x64-windows-static
set VCPKG_TARGET_TRIPLET=%VCPKG_DEFAULT_TRIPLET%

@REM Include Paths
set CPATH=%VCPKG_ROOT%/installed/%VCPKG_ARCH%/include;%CPATH%
set C_INCLUDE_PATH=%VCPKG_ROOT%/installed/%VCPKG_ARCH%/include;%C_INCLUDE_PATH%
set CPLUS_INCLUDE_PATH=%VCPKG_ROOT%/installed/%VCPKG_ARCH%/include;%CPLUS_INCLUDE_PATH%
@REM Library Paths 
set LIBRARY_PATH=%VCPKG_ROOT%/installed/%VCPKG_ARCH%/lib;%LIBRARY_PATH%
set LD_LIBRARY_PATH=%VCPKG_ROOT%/installed/%VCPKG_ARCH%/lib;%LD_LIBRARY_PATH%
set DYLD_LIBRARY_PATH=%VCPKG_ROOT%/installed/%VCPKG_ARCH%/lib;%DYLD_LIBRARY_PATH%
set PKG_CONFIG_PATH=%VCPKG_ROOT%/installed/%VCPKG_ARCH%/lib/pkgconfig;%PKG_CONFIG_PATH%

@REM set pkg_vpx=%VCPKG_ROOT%\packages\libvpx_x64-windows-static\lib\pkgconfig
@REM set PKG_CONFIG_PATH=%VCPKG_ROOT%/installed/x64-windows/lib/pkgconfig;%pkg_vpx%;%PKG_CONFIG_PAT%
@REM set VPX_LIB_DIR=%VCPKG_ROOT%\installed\x64-windows-static\lib
@REM set VPX_INCLUDE_DIR=%VCPKG_ROOT%\installed\x64-windows-static\include
@REM set VCPKGRS_DYNAMIC=1

set env_nasm=%VCPKG_ROOT%\downloads\tools\nasm\nasm-2.15.05
set env_perl=%VCPKG_ROOT%\downloads\tools\perl\5.32.1.1\perl\bin
set env_cmake=%VCPKG_ROOT%\downloads\tools\cmake-3.30.1-windows\cmake-3.30.1-windows-i386\bin
set env_vckpg=%env_nasm%;%env_perl%;%env_cmake%;

set LLVM_ROOT=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\Llvm\x64
set LIBCLANG_PATH=%LLVM_ROOT%\bin
set env_rustdesk_build=%env_vckpg%;%env_toolchain%;%PKG_CONFIG_PATH%;%LIBCLANG_PATH%;%FLUTTER_HOME%\bin;

set PATH=%env_rustdesk_build%;%LD_LIBRARY_PATH%;%VCPKG_ROOT%;%LLVM_ROOT%;%PATH%;

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

@REM first init vcpkg
if EXIST "%VCPKG_ROOT%\vcpkg.exe" (
    echo "exist %VCPKG_ROOT%\vcpkg.exe"
) else (
	call deps\vcpkg\vcpkg\bootstrap-vcpkg.bat
)
vcpkg --version
"%VCPKG_ROOT%\vcpkg.exe" install --triplet %VCPKG_TARGET_TRIPLET% --x-install-root="%VCPKG_ROOT%\installed"
if errorlevel 1 (
    echo [-]Vcpkg install failed
    goto :eof
)
@REM if exist "%VCPKG_ROOT%\installed" (
@REM     echo link;%VCPKG_ROOT%\installed exist
@REM ) else (
@REM     echo link;%VCPKG_ROOT%\installed from %VCPKG_ROOT%\installed
@REM     mklink /D "%VCPKG_ROOT%\installed" "%VCPKG_ROOT%\installed"
@REM )

@REM vcpkg install libvpx:x64-windows-static
@REM vcpkg install libyuv:x64-windows-static
@REM vcpkg install opus:x64-windows-static
@REM vcpkg install aom:x64-windows-static
@REM vcpkg_cli probe libvpx
@REM vcpkg list
pkg-config --libs opus
@REM pkg-config --libs libavcodec
@REM pkg-config --cflags libavcodec

@REM cargo run
::cargo clean
::cargo cache

rem Debug settings
set "CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG=true"
set "CARGO_PROFILE_RELEASE_BUILD_OVERRIDE_DEBUG=true"
set "RUST_BACKTRACE=full"

@REM cargo clean
cargo update
@REM cargo build


cd /d flutter
call flutter clean
@REM flutter pub cache clean
@REM rd /s /q  .dart_tool
@REM rd /s /q  build
del  pubspec.lock
@REM  更新 Flutter 依赖,包括CocoaPods
call flutter pub get
echo "[*]exit fullter!!!"
cd /d %RootDir%

@REM  显示当前 Flutter 版本
echo "Flutter version:"
call flutter --version
call flutter --disable-analytics
call dart --disable-analytics
call flutter doctor -v

@REM  安装 flutter_rust_bridge_codegen 工具
@REM echo "[*]uninstall flutter_rust_bridge_codegen"
@REM cargo uninstall flutter_rust_bridge_codegen
where flutter_rust_bridge_codegen >nul 2>&1
if %errorlevel% neq 0 (
    echo [+] install flutter_rust_bridge_codegen v1.80.0...
	cargo install flutter_rust_bridge_codegen --version "1.80.0" --features "uuid"
) else (
    echo [*] flutter_rust_bridge_codegen exist
)
@REM 确保 Rust 代码已正确编译
@REM cargo build --verbose
@REM 生成绑定代码
del /s /q  flutter\lib\generated_bridge.dart
del /s /q  flutter\windows\Runner\bridge_generated.h
set gen_args=--rust-input %RootDir%\src\flutter_ffi.rs --dart-output %RootDir%\flutter\lib\generated_bridge.dart --c-output %RootDir%\flutter\windows\Runner\bridge_generated.h --llvm-path "%LLVM_ROOT%"
echo "[*]flutter_rust_bridge_codegen %gen_args%"
flutter_rust_bridge_codegen %gen_args%
if %ERRORLEVEL% EQU 0 (
    echo ✅ Codegen succeeded
	@REM python build.py --portable --hwcodec --flutter --vram --skip-portable-pack
	python build.py --portable --flutter --skip-portable-pack
) else (
    echo ❌ Codegen failed
)

cmd /k




