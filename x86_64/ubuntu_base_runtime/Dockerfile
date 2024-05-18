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

ARG CUDA_VERSION

FROM nvcr.io/nvidia/cuda:12.2.2-runtime-ubuntu22.04

ARG TENSORRT_VERSION
ARG CUDNN_VERSION


# Add open GL libraries and other required components. Added new gstreamer components and additional components including CVE patches
RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive  apt-get install -y --no-install-recommends \
        pkg-config \
        libglvnd-dev \
        libgl1-mesa-dev \
        libegl1-mesa-dev \
        libgles2-mesa-dev \
        libegl-mesa0 \
        libglib2.0-dev \
        libcjson-dev \
        libssl-dev \
        wget \
        libyaml-cpp-dev \
        libssl-dev \
        openssl \
        libssl3 \
        gnutls-bin \
        gstreamer1.0-tools \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-alsa \
        libssl3  \
        libgstreamer1.0-0 \
        libgstrtspserver-1.0-0 \
        libjansson4 \
        librabbitmq4 \
        libuuid1 \
        libc-bin \
        libcurl3-gnutls \
        libcurl4 \
        libjson-glib-1.0-0 \
        gstreamer1.0-rtsp \
        rsyslog \
        git \
        python3 \
        libjsoncpp-dev \
        gcc \
        g++ \
        make \
        libjpeg-dev \
        libxml2 \
        bzip2 \
        zlib1g \
        linux-libc-dev \
        tzdata && \
        rm -rf /var/lib/apt/lists/* && \
        apt autoremove

# remove tensorrt package install and force particular libraries/packages to a specific version
#  libnvinfer8=8.6.1.6-1+cuda12.0 
# Add TensorRT and CuDNN repo(s)
# NOTE These should already be downloaded into x86_64 directory
ADD nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb /tmp
ADD cudnn-local-repo-ubuntu2204-8.9.6.50_1.0-1_amd64.deb  /tmp


RUN mkdir -p /tmp/temp_trt && \
       cd /tmp/temp_trt && \
       mv /tmp/nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb /tmp/temp_trt/ && \
       ls -l /tmp/temp_trt/ && \
       mv /tmp/cudnn-local-repo-ubuntu2204-8.9.6.50_1.0-1_amd64.deb /tmp/temp_trt/ && \
       ls -l /tmp/temp_trt/ && \
       dpkg -i /tmp/temp_trt/nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb && \
       cp /var/nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0/nv-tensorrt-local-42B2FC56-keyring.gpg /usr/share/keyrings/ && \
       dpkg -i ./cudnn-local-repo-ubuntu2204-8.9.6.50_1.0-1_amd64.deb && \
       cp /var/cudnn-local-repo-ubuntu2204-8.9.6.50/cudnn-local-1998375D-keyring.gpg /usr/share/keyrings/ && \
       apt-get update && \
       DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       libnvinfer-lean8=8.6.1.6-1+cuda12.0 \
       libnvinfer-vc-plugin8=8.6.1.6-1+cuda12.0 \
       libnvinfer-headers-dev=8.6.1.6-1+cuda12.0 \
       libnvinfer-dev=8.6.1.6-1+cuda12.0 \
       libnvinfer-headers-plugin-dev=8.6.1.6-1+cuda12.0 \
       libnvinfer-plugin-dev=8.6.1.6-1+cuda12.0 \
       libnvonnxparsers-dev=8.6.1.6-1+cuda12.0 \
       libnvinfer-lean-dev=8.6.1.6-1+cuda12.0 \
       libnvparsers-dev=8.6.1.6-1+cuda12.0 \
       python3-libnvinfer-lean=8.6.1.6-1+cuda12.0 \
       python3-libnvinfer-dispatch=8.6.1.6-1+cuda12.0 \
       uff-converter-tf=8.6.1.6-1+cuda12.0 \
       onnx-graphsurgeon=8.6.1.6-1+cuda12.0 \
       libnvinfer-bin=8.6.1.6-1+cuda12.0 \
       libnvinfer-dispatch-dev=8.6.1.6-1+cuda12.0 \
       libnvinfer-dispatch8=8.6.1.6-1+cuda12.0 \
       libnvonnxparsers-dev=8.6.1.6-1+cuda12.0 \
       libnvonnxparsers8=8.6.1.6-1+cuda12.0 \
       libnvinfer-vc-plugin-dev=8.6.1.6-1+cuda12.0 \
       libnvinfer-samples=8.6.1.6-1+cuda12.0 \
       libcudnn8-dev=8.9.6.50-1+cuda12.2 \
       libcudnn8=8.9.6.50-1+cuda12.2 && \
       cd /tmp && \
       dpkg --purge nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0 && \
       dpkg --purge cudnn-local-repo-ubuntu2204-8.9.6.50 && \
       rm -rf temp_trt && \
       rm -rf /var/lib/apt/lists/*

# rsyslog into /etc/init.d/ (service can run)
ADD deps/rsyslog  /etc/init.d/
RUN chmod +x /etc/init.d/rsyslog


COPY trtserver_base_devel/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json


# ENV NVIDIA_DRIVER_CAPABILITIES $NVIDIA_DRIVER_CAPABILITIES,video
ENV NVIDIA_DRIVER_CAPABILITIES $NVIDIA_DRIVER_CAPABILITIES,video,compute,graphics,utility

WORKDIR /opt/nvidia/deepstream/deepstream

# User additional install script (moved to the correct location with the license file)
ADD user_additional_install_runtime.sh /opt/

RUN ln -s /usr/lib/x86_64-linux-gnu/libnvcuvid.so.1 /usr/lib/x86_64-linux-gnu/libnvcuvid.so && \
    ln -s /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-encode.so && \
    ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so


ADD deps/gRPC_installation.sh /root/
RUN /root/gRPC_installation.sh

ENV PATH="${PATH}:${HOME}/.local/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/.local/lib"
ENV PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${HOME}/.local/lib/pkgconfig"


# added wget so gRPC script could install
# RUN apt-get remove --purge -y wget
RUN rm /root/gRPC_installation.sh && \
    cd /tmp && \
    rm -rf temp_cuda99

RUN ldconfig

# IP requirement for removal
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstaudioparsers.so
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstfaad.so
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstvoaacenc.so \
    /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstx264.so
RUN rm -f /usr/lib/x86_64-linux-gnu/libavresample* /usr/lib/x86_64-linux-gnu/libavutil* \
     /usr/lib/x86_64-linux-gnu/libavcodec* /usr/lib/x86_64-linux-gnu/libavformat* \
     /usr/lib/x86_64-linux-gnu/libavfilter* /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstde265.so* \
    /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstx265.so* /usr/lib/x86_64-linux-gnu/libde265.so*
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstvpx.so* \
    /usr/lib/x86_64-linux-gnu/libmpeg2.so.0* /usr/lib/x86_64-linux-gnu/libmpeg2encpp-2.1.so* /usr/lib/x86_64-linux-gnu/libmpg123.so* \
    /usr/lib/x86_64-linux-gnu/libx265.so* /usr/lib/x86_64-linux-gnu/libx264.so* /usr/lib/x86_64-linux-gnu/libvpx.so*   \
    /usr/lib/x86_64-linux-gnu/libmpeg2convert.so* /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstopenh264.so \
    /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstnvcodec.so

