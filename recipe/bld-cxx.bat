@ECHO ON
SetLocal EnableDelayedExpansion

::set "CC=clang-cl.exe"
::set "CXX=clang-cl.exe"
::set "FC=flang.exe"
::set "LD=link.exe"
::set "LDFLAGS=/link /DEFAULTLIB:%CONDA_PREFIX%\lib\clang\@MAJOR_VER@\lib\windows\clang_rt.builtins-x86_64.lib"
set "LDFLAGS=-nostdlib -Wl,-defaultlib:%CONDA_PREFIX:\=/%/lib/clang/@MAJOR_VER@/lib/windows/clang_rt.builtins-x86_64.lib"

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
      --target install ^
      -- -j %CPU_COUNT%
if errorlevel 1 exit 1

