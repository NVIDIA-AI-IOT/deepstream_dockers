#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2022-2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

# =================================================

# x86 build setup
# samples and triton

cp ./x86_64_specific_files/10_nvidia.json ./x86_dockerfiles/
cp ./x86_64_specific_files/deps/gRPC_installation.sh ./x86_dockerfiles/
cp ./x86_64_specific_files/user_additional_install_runtime.sh ./x86_dockerfiles/
cp ./x86_64_specific_files/user_additional_install_devel.sh ./x86_dockerfiles/
cp ./x86_64_specific_files/user_deepstream_python_apps_install.sh ./x86_dockerfiles/
cp ./common/files/* ./x86_dockerfiles/

cp ./x86_64_specific_files/deps/rsyslog ./x86_dockerfiles/

cp ./x86_64_specific_files/10_nvidia.json ./x86_dockerfiles/
cp ./x86_64_specific_files/entrypoint.sh ./x86_dockerfiles/

# copy /tmp99 components to a specific directory and then point the environment

# ADDVAR99x86="${ADDVAR99x86:-$(pwd -P)}"

if [ -z "${ADDVAR99:-}" ]; then
  echo "Error: ADDVAR99 is not set" >&2
  exit 1
fi

# echo 'copying gst files ...'

cp $ADDVAR99/x86/gst/libgstrtpmanager.so ./x86_dockerfiles/
cp $ADDVAR99/x86/gst/libgstrtsp.so ./x86_dockerfiles/
cp $ADDVAR99/x86/gst/libgstvideoparsersbad.so ./x86_dockerfiles/

mkdir -p ./x86_dockerfiles/optel

# echo 'copying open tel *.deb files'

cp $ADDVAR99/x86/optel/* ./x86_dockerfiles/optel/


