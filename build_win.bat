@echo on


set PythonLocation=E:\MyFiles\Python\Python38
set PY_PIP=%PY_ROOT%\Scripts
set PY_DLLs=%PY_ROOT%\DLLs
set PY_LIBS=%PY_ROOT%\Lib\site-packages
set PYTHONPATH=%PythonLocation%;%PY_PIP%;%PY_LIBS%;%PY_DLLs%;
set PATH=%PYTHONPATH%;%PATH%

::set env_vs=E:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\
set env_vs=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE
set env_cmake=%env_vs%\CommonExtensions\Microsoft\CMake\CMake\bin
if not exist "%env_cmake%" (
	set env_cmake=D:\Program Files\cmake-3.20.3-windows-x86_64\bin
)

set PATH=%env_cmake%;%PATH%


set env_toolchain=%~dp0\deps\toolchain-windows\bin
set VCPKG_ROOT=%~dp0\deps\vcpkg\vcpkg
set VCPKGRS_DYNAMIC=1
set LLVM_ROOT=D:\Program Files\LLVM
set LIBCLANG_PATH=%LLVM_ROOT%\bin
set VPX_LIB_DIR=%VCPKG_ROOT%\installed\x64-windows-static
set LD_LIBRARY_PATH=%VCPKG_ROOT%\installed\x64-windows-static
set env_nasm=G:\Mxq_Share\rustdesk\deps\vcpkg\vcpkg\downloads\tools\nasm\nasm-2.15.05
set env_perl=G:\Mxq_Share\rustdesk\deps\vcpkg\vcpkg\downloads\tools\perl\5.32.1.1\perl\bin
set env_rustdesk_build=%env_nasm%;%env_perl%;
set PATH=%env_toolchain%;%env_rustdesk_build%;%LD_LIBRARY_PATH%;%VCPKG_ROOT%;%LLVM_ROOT%;%PATH%;

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
@REM cargo run
::cargo clean
::cargo cache

cmd /k




