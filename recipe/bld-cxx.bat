@ECHO ON
SetLocal EnableDelayedExpansion

::set "CC=clang-cl.exe"
::set "CXX=clang-cl.exe"
::set "FC=flang.exe"
::set "LD=link.exe"

:: clang-win-activation-feedstock/.../activate-clang-cl_win-64.bat
::set "LDFLAGS=/link /DEFAULTLIB:%CONDA_PREFIX%\lib\clang\@MAJOR_VER@\lib\windows\clang_rt.builtins-x86_64.lib"
set "LDFLAGS=/DEFAULTLIB:%CONDA_PREFIX%\lib\clang\@MAJOR_VER@\lib\windows\clang_rt.builtins-x86_64.lib"

:: flang-activation-feedstock/.../activate.bat
:: FAILS: "D:/bld/gdma-split_1744384002874/_build_env/Library/bin/clang-cl.exe" is not able to compile a simple test program.
::set "LDFLAGS=%LDFLAGS% -Wl,-defaultlib:%CONDA_PREFIX:\=/%/lib/clang/@MAJOR_VER@/lib/windows/clang_rt.builtins-x86_64.lib"

:: clang-win-activation-feedstock/.../activate-clang_win-64.bat
:: ALLOWS compiler and library link. on exe: LINK: command "D:\bld\gdma-split_1744384917393\_build_env\Library\bin\lld-link.exe /nologo CMakeFiles\gdmaexe.dir\src\exe.f90.obj /out:gdma.exe /implib:gdma.lib /pdb:gdma.pdb /version:0.0 /machine:x64 -nostdlib -Wl,-defaultlib:D:/bld/gdma-split_1744384917393/_build_env/lib/clang/@MAJOR_VER@/lib/windows/clang_rt.builtins-x86_64.lib /INCREMENTAL:NO /subsystem:console libgdma.lib -libpath:D:/bld/gdma-split_1744384917393/_build_env/Library/lib -libpath:D:/bld/gdma-split_1744384917393/_build_env/Library/lib/clang/20/lib/windows /MANIFEST:EMBED,ID=1" failed (exit code 1) with the following output:
::lld-link: warning: ignoring unknown argument '-nostdlib'
::lld-link: warning: ignoring unknown argument '-Wl,-defaultlib:D:/bld/gdma-split_1744384917393/_build_env/lib/clang/@MAJOR_VER@/lib/windows/clang_rt.builtins-x86_64.lib'
::set "LDFLAGS=-nostdlib -Wl,-defaultlib:%CONDA_PREFIX:\=/%/lib/clang/@MAJOR_VER@/lib/windows/clang_rt.builtins-x86_64.lib"


:: flang still uses a temporary name not recognized by CMake
copy %BUILD_PREFIX%\Library\bin\flang-new.exe %BUILD_PREFIX%\Library\bin\flang.exe

:: millions of lines of warnings with clang-19
set "CFLAGS=%CFLAGS% -w"

cmake %CMAKE_ARGS% ^
  -G "Ninja" ^
  -S %SRC_DIR% ^
  -B build ^
  -D CMAKE_BUILD_TYPE=Release ^
  -D CMAKE_INSTALL_PREFIX="%PREFIX%" ^
  -D CMAKE_C_FLAGS="/EHsc %CFLAGS%" ^
  -D CMAKE_Fortran_FLAGS="%FFLAGS%" ^
  -D CMAKE_INSTALL_LIBDIR="Library\lib" ^
  -D CMAKE_INSTALL_INCLUDEDIR="Library\include" ^
  -D CMAKE_INSTALL_BINDIR="Library\bin" ^
  -D CMAKE_INSTALL_DATADIR="Library\share" ^
  -D gdma_INSTALL_CMAKEDIR="Library\share\cmake\gdma" ^
  -D gdma_ENABLE_PYTHON=OFF ^
  -D BUILD_SHARED_LIBS=ON ^
  -D CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
  -D ENABLE_XHOST=OFF ^
  -D CMAKE_VERBOSE_MAKEFILE=OFF ^
  -D CMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"
if errorlevel 1 exit 1

cmake --build build ^
      --config Release ^
      --target libgdma ^
      -- -j %CPU_COUNT%
if errorlevel 1 exit 1

dir build

cmake --build build ^
      --config Release ^
      --target gdmaexe ^
      -- -j %CPU_COUNT%
if errorlevel 1 exit 1

dir build

cmake --build build ^
      --config Release ^
      --target install ^
      -- -j %CPU_COUNT%
if errorlevel 1 exit 1

