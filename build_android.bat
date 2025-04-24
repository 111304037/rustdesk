@REM @echo off
@REM setlocal EnableDelayedExpansion

set "Build_Skip=false"
set "GotoEND=false"

echo dirname=%~dp0
set "RootDir=%~dp0"
set "RootDir=%RootDir:~0,-1%"
echo RootDir=%RootDir%
cd /d "%RootDir%"

rem Load Android environment variables
call "%RootDir%\env_android.bat"
echo PATH=%PATH%
echo PKG_CONFIG_PATH=%PKG_CONFIG_PATH%
echo VCPKG_ROOT=%VCPKG_ROOT%

echo VPX_INCLUDE_DIR=%VPX_INCLUDE_DIR%

cd /d "%RootDir%"
echo Current directory: %CD%

if exist "%RootDir%\target\aarch64-linux-android\%MODE%" (
    echo update skip
    set "Build_Skip=true"
) else (
    if exist "%VCPKG_ROOT%\vcpkg.exe" (
        echo file:%VCPKG_ROOT%\vcpkg.exe exist
    ) else (
        call deps\vcpkg\vcpkg\bootstrap-vcpkg.bat
    )
    
    clang --version
    @REM %CMAKE_ASM_COMPILER% --version
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to install nasm for host platform
        set "GotoEND=true"
        goto :eof
    )

    vcpkg --version
    
    echo [!]pkg-config --libs opus
    pkg-config --libs opus
    echo [!]pkg-config --libs libavcodec
    pkg-config --libs libavcodec
    echo [!]pkg-config --cflags libavcodec
    pkg-config --cflags libavcodec

    @REM cargo clean
    cargo update
    @REM cargo build

    rem Change to flutter directory
    cd /d flutter
    
    rem Clean flutter project
    call flutter clean
    @REM flutter pub cache clean
    rd /s /q .dart_tool 2>nul
    rd /s /q build 2>nul
    del /f /q pubspec.lock 2>nul
    
    rem Update Flutter dependencies
    call flutter pub get
    
    rem Activate ffigen
    call dart pub global activate ffigen 8.0.2
    
    @REM  显示当前 Flutter 版本
    echo "Flutter version:"
    echo Flutter version:
    call flutter --version
    call flutter --disable-analytics
    call dart --disable-analytics
    call flutter doctor -v
    
    echo [!]run build_android_deps.bat begin
    call build_android_deps.bat "%ANDROID_TARGET%"
    if errorlevel 1 (
        echo "[*]build_android_deps fail!!!"
        for /r "%VCPKG_ROOT%" %%f in (*.log) do (
            echo %%f:
            echo ======
            type "%%f"
            echo ======
            echo.
        )
        set "GotoEND=true"
        goto :eof
    )
    @REM if exist "%VCPKG_ROOT%\installed" (
    @REM     echo link;%VCPKG_ROOT%\installed exist
    @REM ) else (
    @REM     echo link;%VCPKG_ROOT%\installed from %RootDir%\vcpkg_installed
    @REM     mklink /D "%VCPKG_ROOT%\installed" "%RootDir%\vcpkg_installed"
    @REM )
    echo [!]run build_android_deps.bat end

    echo "[*]exit fullter!!!"
    cd /d "%RootDir%"
    
    
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
    set WIN32_LLVM_ROOT="C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\Llvm\x64"
    @REM set gen_args="--rust-input %RootDir%\src\flutter_ffi.rs --dart-output %RootDir%\flutter\lib\generated_bridge.dart --llvm-path "%WIN32_LLVM_ROOT%
    @REM echo "[*]flutter_rust_bridge_codegen %gen_args%"
    @REM flutter_rust_bridge_codegen %gen_args%
    @REM if exist "flutter\lib\generated_bridge.dart" del /f /q "flutter\lib\generated_bridge.dart"
    echo [*]flutter_rust_bridge_codegen --rust-input "%RootDir%\src\flutter_ffi.rs" --dart-output "%RootDir%\flutter\lib\generated_bridge.dart" --llvm-path %WIN32_LLVM_ROOT%
    flutter_rust_bridge_codegen --rust-input "%RootDir%\src\flutter_ffi.rs" --dart-output "%RootDir%\flutter\lib\generated_bridge.dart" --llvm-path %WIN32_LLVM_ROOT%

    if errorlevel 1 (
        echo [-]Codegen failed
        set "GotoEND=true"
        goto :eof
    ) else (
        echo [+]Codegen succeeded
    )
)

if "%GotoEND%"=="false" (
    if "%Build_Skip%"=="false" (
        rem Add Rust target
        cargo install cargo-ndk
        rustup target install aarch64-linux-android
        @REM 为 ARM64 设备添加目标支持
        rustup target add aarch64-linux-android
        
        echo [!]run flutter/ndk_arm64.bat begin
        cargo ndk --platform %ANDROID_PLATFORM% --target aarch64-linux-android build --release --features flutter,hwcodec
        @REM cargo build --target aarch64-linux-android --release --features flutter,hwcodec
        echo [!]run flutter/ndk_arm64.bat end
        
        rem Create jniLibs directory and copy library
        if not exist "flutter\android\app\src\main\jniLibs\arm64-v8a" mkdir "flutter\android\app\src\main\jniLibs\arm64-v8a"
        copy /y "target\aarch64-linux-android\release\liblibrustdesk.so" "flutter\android\app\src\main\jniLibs\arm64-v8a\librustdesk.so"
    )
    
    pushd flutter
    call flutter build apk --target-platform android-arm64 --%MODE%
    popd
) else (
    echo Build_Skip
)

@REM endlocal