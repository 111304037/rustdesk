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

set env_nasm=G:\Mxq_Share\rustdesk\deps\vcpkg\vcpkg\downloads\tools\nasm\nasm-2.15.05
set env_perl=G:\Mxq_Share\rustdesk\deps\vcpkg\vcpkg\downloads\tools\perl\5.32.1.1\perl\bin

set env_rustdesk_build=%env_nasm%;%env_perl%;
set PATH=%env_rustdesk_build%;%LD_LIBRARY_PATH%;%PY_ROOT%;%PY_PIP%;%PY_LIBS%;%VCPKG_ROOT%;%LLVM_ROOT%;%PATH%;

@REM set HTTP_PROXY=127.0.0.1:8899
@REM set HTTPS_PROXY=127.0.0.1:8899
@REM git config --global https.proxy 127.0.0.1:8899

@REM first init vcpkg
@REM bootstrap-vcpkg.bat
@REM vcpkg install libvpx:x64-windows-static
@REM vcpkg install libyuv:x64-windows-static
@REM vcpkg install opus:x64-windows-static
@REM vcpkg install aom:x64-windows-static
@REM vcpkg_cli probe libvpx
@REM vcpkg list
@REM cargo build
::cargo run
::cargo clean
::cargo cache

cmd /k




