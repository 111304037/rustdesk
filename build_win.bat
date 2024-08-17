@echo on
set VCPKG_ROOT=%~dp0\deps\vcpkg\vcpkg
set VCPKGRS_DYNAMIC=1
set LLVM_ROOT=D:\Program Files\LLVM
set LIBCLANG_PATH=%LLVM_ROOT%\bin
set VPX_LIB_DIR=%VCPKG_ROOT%\installed\x64-windows-static
set LD_LIBRARY_PATH=%VCPKG_ROOT%\installed\x64-windows-static

set PY_ROOT=E:\MyFiles\Python\Python38
set PY_PIP=%PY_ROOT%\Scripts
set PY_LIBS=%PY_ROOT%\Lib\site-packages

set PATH=%LD_LIBRARY_PATH%;%PY_ROOT%;%PY_PIP%;%PY_LIBS%;%VCPKG_ROOT%;%LLVM_ROOT%;%PATH%

@REM set HTTP_PROXY=127.0.0.1:8899
@REM set HTTPS_PROXY=127.0.0.1:8899
@REM git config --global https.proxy 127.0.0.1:8899

@REM first init vcpkg
@REM bootstrap-vcpkg.bat
@REM vcpkg install libvpx:x64-windows-static libyuv:x64-windows-static opus:x64-windows-static
@REM vcpkg_cli probe libvpx
@REM vcpkg list
cargo build
::cargo run
::cargo clean
::cargo cache

cmd /k




