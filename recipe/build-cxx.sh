#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

cmake ${CMAKE_ARGS} ${ARCH_ARGS} \
  -S ${SRC_DIR} \
  -B build \
  -G Ninja \
  -D CMAKE_BUILD_TYPE=Release \
  -D BUILD_SHARED_LIBS=ON \
  -D gdma_ENABLE_PYTHON=OFF \
  -D ENABLE_XHOST=OFF \
  -D CMAKE_VERBOSE_MAKEFILE=ON

cmake --build build --target install -j${CPU_COUNT}
