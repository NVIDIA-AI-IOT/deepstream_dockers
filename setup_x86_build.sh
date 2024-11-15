#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2022-2024 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

cp ./x86_64/trtserver_base_devel/10_nvidia.json ./docker/
cp ./x86_64/deps/install_extra_libs.sh ./docker/
cp ./x86_64/deps/gRPC_installation.sh ./docker/
cp ./x86_64/user_additional_install_runtime.sh ./docker/
cp ./x86_64/user_additional_install_devel.sh ./docker/
cp ./x86_64/user_deepstream_python_apps_install.sh ./docker/
cp ./common/files/* ./docker/

cp ./x86_64/deps/rsyslog ./docker/
cp ./x86_64/deps/ofed-ucx.conf ./docker/

cp ./x86_64/nvidia_icd.json ./docker/
cp ./x86_64/trtserver_base_devel/entrypoint.sh ./docker/
			       
