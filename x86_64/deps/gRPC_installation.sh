#!/bin/bash -x
# SPDX-FileCopyrightText: Copyright (c) 2022 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: MIT
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

# Script for gRPC C++ Installation
# Installs gRPC C++ v1.38.0
# Based on steps provided at: https://grpc.io/docs/languages/cpp/quickstart/
# Two changes with respect to steps in the above link:
# 1. Add -DBUILD_SHARED_LIBS=ON to build shared libraries
# 2. USe 'make -j4' instead of 'make -j' to avoid system becoming unreponsive
 
export DOWNLOAD_DIR=/tmp
export MY_INSTALL_DIR=$HOME/.local
mkdir -p $MY_INSTALL_DIR
export PATH="$MY_INSTALL_DIR/bin:$PATH"

pushd $DOWNLOAD_DIR

apt update
apt install -y cmake
wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.19.6/cmake-3.19.6-Linux-x86_64.sh
sh cmake-linux.sh -- --skip-license --prefix=$MY_INSTALL_DIR
rm cmake-linux.sh
apt install -y build-essential autoconf libtool pkg-config
git clone --recurse-submodules -b v1.38.0 https://github.com/grpc/grpc

cd grpc
mkdir -p cmake/build
pushd cmake/build

cmake -DgRPC_INSTALL=ON \
      -DgRPC_BUILD_TESTS=OFF \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR \
      ../..

make -j 4
make install
popd

mkdir -p third_party/abseil-cpp/cmake/build
pushd third_party/abseil-cpp/cmake/build

cmake -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR \
       -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE \
      ../..

make -j 4
make install
popd
popd
rm -rf $DOWNLOAD_DIR/grpc

export LD_LIBRARY_PATH=/root/.local/lib/:$LD_LIBRARY_PATH

echo "export PATH="$MY_INSTALL_DIR"/bin:\$PATH" >> $HOME/.profile
echo "export LD_LIBRARY_PATH="$MY_INSTALL_DIR"/lib:\$LD_LIBRARY_PATH" >> $HOME/.profile

