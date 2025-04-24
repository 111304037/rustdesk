@REM @echo off
@REM setlocal EnableDelayedExpansion

set "ANDROID_ABI=%~1"

rem Build RustDesk dependencies for Android using vcpkg.json
rem Required:
rem   1. set VCPKG_ROOT / ANDROID_NDK path environment variables
rem   2. vcpkg initialized
rem   3. ndk, version: r25c or newer

if not exist "%ANDROID_NDK_HOME%" (
    echo Failed! Please set ANDROID_NDK_HOME
    @REM exit /b 1
)

if not exist "%VCPKG_ROOT%" (
    echo Failed! Please set VCPKG_ROOT
    exit /b 1
)

set "API_LEVEL=%ANDROID_PLATFORM%"

rem Get directory of this script
set "SCRIPTDIR=%~dp0"
set "SCRIPTDIR=%SCRIPTDIR:~0,-1%"

rem Check if vcpkg.json is one level up - in root directory of RD
if not exist "%SCRIPTDIR%\..\vcpkg.json" (
    echo Failed! Please check where vcpkg.json is!
    exit /b 1
)

rem NDK llvm toolchain
set "HOST_TAG=windows-x86_64"
set "TOOLCHAIN=%ANDROID_NDK%\toolchains\llvm\prebuilt\%HOST_TAG%"

rem Build function
:build
if "%ANDROID_ABI%"=="arm64-v8a" (
    set "ABI=aarch64-linux-android%API_LEVEL%"
    set "VCPKG_TARGET=arm64-android"
) else if "%ANDROID_ABI%"=="armeabi-v7a" (
    set "ABI=armv7a-linux-androideabi%API_LEVEL%"
    set "VCPKG_TARGET=arm-neon-android"
) else if "%ANDROID_ABI%"=="x86_64" (
    set "ABI=x86_64-linux-android%API_LEVEL%"
    set "VCPKG_TARGET=x64-android"
) else if "%ANDROID_ABI%"=="x86" (
    set "ABI=i686-linux-android%API_LEVEL%"
    set "VCPKG_TARGET=x86-android"
) else (
    echo ERROR: ANDROID_ABI must be one of: arm64-v8a, armeabi-v7a, x86_64, x86
    exit /b 1
)

echo *** [%ANDROID_ABI%][Start] Build and install vcpkg dependencies
pushd "%SCRIPTDIR%\.."
"%VCPKG_ROOT%\vcpkg.exe" install --triplet %VCPKG_TARGET% --x-install-root="%VCPKG_ROOT%\installed"
if errorlevel 1 (
    echo Vcpkg install failed
    exit /b 1
)
popd

rem Display first 100 lines of ffmpeg build log if it exists
if exist "%VCPKG_ROOT%\buildtrees\ffmpeg\build-%VCPKG_TARGET%-rel-out.log" (
    echo First 100 lines of ffmpeg build log:
    powershell -Command "Get-Content '%VCPKG_ROOT%\buildtrees\ffmpeg\build-%VCPKG_TARGET%-rel-out.log' -Head 100"
)
echo *** [%ANDROID_ABI%][Finished] Build and install vcpkg dependencies

rem Move arm-neon-android to arm-android if it exists
if exist "%VCPKG_ROOT%\installed\arm-neon-android" (
    echo *** [Start] Move arm-neon-android to arm-android
    if exist "%VCPKG_ROOT%\installed\arm-android" rd /s /q "%VCPKG_ROOT%\installed\arm-android"
    move "%VCPKG_ROOT%\installed\arm-neon-android" "%VCPKG_ROOT%\installed\arm-android"
    echo *** [Finished] Move arm-neon-android to arm-android
)

goto :eof

:main
if "%ANDROID_ABI%"=="" (
    echo Usage: build-android-deps.bat ^<ANDROID-ABI^>
    exit /b 1
) else (
    call :build
)

@REM endlocal