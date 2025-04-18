
cmake %CMAKE_ARGS% ^
  -G "Ninja" ^
  -S %SRC_DIR% ^
  -B build ^
  -D CMAKE_BUILD_TYPE=Release ^
  -D CMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -D CMAKE_C_FLAGS="%CFLAGS%" ^
  -D CMAKE_Fortran_FLAGS="%FFLAGS%" ^
  -D gdma_INSTALL_CMAKEDIR="share\cmake\gdma" ^
  -D gdma_ENABLE_PYTHON=OFF ^
  -D BUILD_SHARED_LIBS=ON ^
  -D CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
  -D CMAKE_GNUtoMS=ON ^
  -D ENABLE_XHOST=OFF ^
  -D CMAKE_VERBOSE_MAKEFILE=OFF ^
  -D CMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"
if errorlevel 1 exit 1

cmake --build build ^
      --config Release ^
      --target install ^
      -- -j %CPU_COUNT%
if errorlevel 1 exit 1

