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

# special docker setup for x86 cross-compile for Jetson
sudo docker --version


sudo apt-get install qemu binfmt-support qemu-user-static
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
# Verify everything works.
sudo systemctl restart docker
# docker run --rm -t arm64v8/ubuntu uname -m
# Use Docker buildx
# Create builder for building on x86
sudo docker buildx create --name myjetbuilder
# Create a new builder instance with support for multiple architectures
sudo docker buildx use myjetbuilder
# Inspect available platforms and enable ARM64
sudo docker buildx inspect --bootstrap
# Make sure your Dockerfile is compatible with the ARM64 architecture.
# If you need to install architecture-specific packages, use a multi-stage build and specify the appropriate base image for each stage
# Build the multi-arch image:
# Build the image with the `--platform` flag to specify the target architecture:
# docker buildx build --platform linux/arm64 -t myimage:arm64 -f Dockerfile99 .

