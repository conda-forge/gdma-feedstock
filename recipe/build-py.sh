#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

cmake ${CMAKE_ARGS} \
  -S ${SRC_DIR}/pygdma \
  -B build_py${PY_VER} \
  -G Ninja \
  -D CMAKE_BUILD_TYPE=Release \
  -D PYMOD_INSTALL_LIBDIR="/python${PY_VER}/site-packages" \
  -D Python_EXECUTABLE=${PYTHON} \
  -D CMAKE_VERBOSE_MAKEFILE=OFF \
  -D CMAKE_PREFIX_PATH="${PREFIX}"

cmake --build build_py${PY_VER} --target install -j${CPU_COUNT}
