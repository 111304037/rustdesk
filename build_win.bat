@echo on

@REM python
set PythonLocation=E:\MyFiles\Python\Python38
set PY_PIP=%PY_ROOT%\Scripts
set PY_DLLs=%PY_ROOT%\DLLs
set PY_LIBS=%PY_ROOT%\Lib\site-packages
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

@REM vcpkg
set VCPKG_ROOT=%~dp0deps\vcpkg\vcpkg
set pkg_vpx=%VCPKG_ROOT%\packages\libvpx_x64-windows-static\lib\pkgconfig
set PKG_CONFIG_PATH=%VCPKG_ROOT%/installed/x64-windows/lib/pkgconfig;%pkg_vpx%;%PKG_CONFIG_PAT%
set LD_LIBRARY_PATH=%VCPKG_ROOT%\installed\x64-windows-static\lib
set VPX_LIB_DIR=%VCPKG_ROOT%\installed\x64-windows-static\lib
set VPX_INCLUDE_DIR=%VCPKG_ROOT%\installed\x64-windows-static\include


set env_nasm=%VCPKG_ROOT%\downloads\tools\nasm\nasm-2.15.05
set env_perl=%VCPKG_ROOT%\downloads\tools\perl\5.32.1.1\perl\bin
set env_cmake=%VCPKG_ROOT%\downloads\tools\cmake-3.30.1-windows\cmake-3.30.1-windows-i386\bin
set env_vckpg=%env_nasm%;%env_perl%;%env_cmake%;

set VCPKGRS_DYNAMIC=1
set LLVM_ROOT=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\Llvm\x64
set LIBCLANG_PATH=%LLVM_ROOT%\bin
set env_rustdesk_build=%env_vckpg%;%env_toolchain%;%PKG_CONFIG_PATH%;%LIBCLANG_PATH%;

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
@REM bootstrap-vcpkg.bat
@REM vcpkg install libvpx:x64-windows-static
@REM vcpkg install libyuv:x64-windows-static
@REM vcpkg install opus:x64-windows-static
@REM vcpkg install aom:x64-windows-static
@REM vcpkg_cli probe libvpx
@REM vcpkg list
@REM cargo run
::cargo clean
::cargo cache

set CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG=true
set RUST_BACKTRACE=full
@REM cargo clean
@REM cargo update
@REM cargo build

cmd /k




