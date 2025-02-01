cmake %CMAKE_ARGS% ^
  -G "Ninja" ^
  -S "%SRC_DIR%\\pygdma" ^
  -B "build_py%PY_VER%" ^
  -D CMAKE_BUILD_TYPE=Release ^
  -D CMAKE_CXX_FLAGS="/EHsc %CXXFLAGS%" ^
  -D CMAKE_C_COMPILER=%CC% ^
  -D FORTRAN_COMPILER=%FC% ^
  -D PYMOD_INSTALL_LIBDIR="/../../Lib/site-packages" ^
  -D gdma_INSTALL_CMAKEDIR="Library\share\cmake\gdma" ^
  -D Python_EXECUTABLE="%PYTHON%" ^
  -D CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
  -D CMAKE_VERBOSE_MAKEFILE=ON
if errorlevel 1 exit 1

cmake --build build_py%PY_VER% ^
      --config Release ^
      --target install ^
      -- -j %CPU_COUNT%
if errorlevel 1 exit 1
