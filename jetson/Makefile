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

img_type = base test5 runtime triton
prefix = deepstream_jetson
L4T_VERSION=r8.6.2.1
platform="jetson"
qemu_bin="qemu-aarch64-static"
qemu_bin_path="/usr/bin/$(qemu_bin)"
build_machine=$(shell uname -m)
ifeq ($(build_machine),x86_64)
DOCKER=podman
platform_run_arg += -v $(qemu_bin_path):$(qemu_bin_path)
bin_misc = -v $(qemu_bin_path):$(qemu_bin_path)
platform_build_arg += -v $(qemu_bin_path):$(qemu_bin_path)
else
DOCKER=docker
endif

base test5 runtime : ubuntu_base_runtime
base test5 runtime : base_image?= $(registry)/$(prefix)-ubuntu_base_runtime:$(image_tag)

triton : ubuntu_base_devel
triton : base_image?= $(registry)/$(prefix)-ubuntu_base_devel:$(image_tag)

include ../common/Makefile

ds_pkg="deepstream_sdk_v$(version)_jetson.tbz2"
ds_pkg_dir="deepstream_sdk_v$(version)_jetson"
platform_run_arg += -v $(top)/$(platform)/$(ds_pkg):/root/tmp/$(ds_pkg):ro
platform_build_arg += --build-arg L4T_VERSION=$(L4T_VERSION)
