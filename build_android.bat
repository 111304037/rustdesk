@REM @echo off
setlocal EnableDelayedExpansion

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
    
    vcpkg --version
    
    echo [!]pkg-config --libs opus
    pkg-config --libs opus
    echo [!]pkg-config --libs libavcodec
    pkg-config --libs libavcodec
    echo [!]pkg-config --cflags libavcodec
    pkg-config --cflags libavcodec

    cargo update

    rem Change to flutter directory
    cd flutter
    
    rem Clean flutter project
    call flutter clean
    rd /s /q .dart_tool 2>nul
    rd /s /q build 2>nul
    del /f /q pubspec.lock 2>nul
    
    
    rem Update Flutter dependencies
    call flutter pub get
    
    rem Activate ffigen
    call dart pub global activate ffigen 8.0.2
    
    rem Show Flutter version info
    echo Flutter version:
    call flutter --version
    call flutter --disable-analytics
    call dart --disable-analytics
    call flutter doctor -v
    
    echo [!]run build_android_deps.bat begin
    call build_android_deps.bat "%ANDROID_TARGET%"
    if errorlevel 1 (
        for /r "%VCPKG_ROOT%" %%f in (*.log) do (
            echo %%f:
            echo ======
            type "%%f"
            echo ======
            echo.
        )
        set "GotoEND=true"
    )
    echo [!]run build_android_deps.bat end

    cd /d "%RootDir%"
    
    rem Install flutter_rust_bridge_codegen
    where flutter_rust_bridge_codegen >nul 2>&1
    if errorlevel 1 (
        echo Installing flutter_rust_bridge_codegen v1.80.0...
        cargo install flutter_rust_bridge_codegen --version "1.80.0" --features "uuid"
    )
    
    rem Generate bindings
    if exist "flutter\lib\generated_bridge.dart" del /f /q "flutter\lib\generated_bridge.dart"
    echo [*]flutter_rust_bridge_codegen --rust-input %RootDir%\src\flutter_ffi.rs --dart-output %RootDir%\flutter\lib\generated_bridge.dart
    flutter_rust_bridge_codegen --rust-input "%RootDir%\src\flutter_ffi.rs" --dart-output "%RootDir%\flutter\lib\generated_bridge.dart"
    if errorlevel 1 (
        echo ❌ Codegen failed
        set "GotoEND=true"
    ) else (
        echo ✅ Codegen succeeded
    )
)

if "%GotoEND%"=="false" (
    if "%Build_Skip%"=="false" (
        rem Add Rust target
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
)

endlocal