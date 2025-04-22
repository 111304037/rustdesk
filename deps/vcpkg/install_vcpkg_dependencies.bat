@echo off

set VCPKG_ROOT=%~dp0vcpkg
set PATH=%VCPKG_ROOT%;%PATH%
cd /d %~dp0
REM get vcpkg distribution
::if not exist vcpkg git clone https://github.com/Microsoft/vcpkg.git

REM build vcpkg
if not exist vcpkg\vcpkg.exe call vcpkg\bootstrap-vcpkg.bat -disableMetrics

REM install required packages
@REM vcpkg.exe install --triplet x64-windows-static freetype glfw3 capstone[arm,arm64,x86]
vcpkg install --triplet x64-windows-static nasm:x64-windows
cmd /k