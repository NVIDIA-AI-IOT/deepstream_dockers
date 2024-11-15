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

ARG BASE_IMAGE

# FROM ${BASE_IMAGE}
FROM nvcr.io/nvidia/cuda:12.6.0-runtime-ubuntu22.04

ARG DS_PUBLIC_X86
ARG DS_PUBLIC_X86_SDK_FILE
ARG TENSORRT_VERSION=10.3.0.26-1+cuda12.5
# ARG CUDNN_VERSION

# Add open GL libraries and other required components. Added new gstreamer components and additional components including CVE patches
# IP removal is included here

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
        tar \
        bzip2 \
        libjpeg-dev \
        libxml2 \
        zlib1g \
        tzdata && \
        rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstaudioparsers.so \
        /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstfaad.so \
    /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstvoaacenc.so \
    /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstx264.so && \
    rm -f /usr/lib/x86_64-linux-gnu/libavresample* /usr/lib/x86_64-linux-gnu/libavutil* \
     /usr/lib/x86_64-linux-gnu/libavcodec* /usr/lib/x86_64-linux-gnu/libavformat* \
     /usr/lib/x86_64-linux-gnu/libavfilter* /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstde265.so* \
    /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstx265.so* /usr/lib/x86_64-linux-gnu/libde265.so* && \
     rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstvpx.so* \
    /usr/lib/x86_64-linux-gnu/libmpeg2.so.0* /usr/lib/x86_64-linux-gnu/libmpeg2encpp-2.1.so* /usr/lib/x86_64-linux-gnu/libmpg123.so* \
    /usr/lib/x86_64-linux-gnu/libx265.so* /usr/lib/x86_64-linux-gnu/libx264.so* /usr/lib/x86_64-linux-gnu/libvpx.so*   \
    /usr/lib/x86_64-linux-gnu/libmpeg2convert.so* /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstopenh264.so \
    /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstnvcodec.so \
    /usr/lib/x86_64-linux-gnu/libopenh264.so* /usr/lib/x86_64-linux-gnu/libvo-aacenc.so* && \
   rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstuvch264.so /usr/lib/x86_64-linux-gnu/libopenh264.so.2.2.0 /usr/lib/x86_64-linux-gnu/libopenh264.so.6 \
     /usr/lib/x86_64-linux-gnu/libvo-aacenc.so.0 /usr/lib/x86_64-linux-gnu/libvo-aacenc.so.0.0.4 /usr/lib/x86_64-linux-gnu/libmp3lame.so.0.0.0 \
     /usr/lib/x86_64-linux-gnu/libmp3lame.so.0 /usr/lib/x86_64-linux-gnu/libfaad* /usr/lib/x86_64-linux-gnu/libFLAC.so* \
     /usr/lib/x86_64-linux-gnu/libmjpegutils-2.1.so.0* /usr/lib/x86_64-linux-gnu/libxvidcore.so* /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstmpegpsmux.so \
/usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstflac.so \
     /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstmpeg2enc.so /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstmpeg2dec.so && \
     rm -f /usr/lib/x86_64-linux-gnu/mfx/libmfx_h264la_hw64.so /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstflac.so \
/usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstmpeg2enc.so  /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstmpeg2dec.so && \
        rm -rf /var/lib/apt/lists/* && \
        apt autoremove

# IP requirement for removal
#  Remove  gstreamer1.0-libav \

# add this manually
# wget -O /tmp99/libgstrtpmanager.so https://<host name>/x86/libgstrtpmanager.so && \

 RUN --mount=type=bind,src=docker,target=/tmp/docker \
       mkdir -p /tmp/temp_trt ; mkdir -p /root/tmp ; mkdir -p /tmp99 && \
       cd /tmp/temp_trt && \
        ls -l /tmp/docker/ && \
       cp /tmp/docker/rsyslog /etc/init.d/ && \
       ls -l /tmp/temp_trt/ && \
       cp /tmp/docker/nv-tensorrt-local-repo-ubuntu2204-10.3.0-cuda-12.5_1.0-1_amd64.deb /tmp/temp_trt && \
       cp  /tmp/docker/cudnn-local-repo-ubuntu2204-9.3.0_1.0-1_amd64.deb  /tmp/temp_trt && \
       ls -l /tmp/temp_trt/ && \
       dpkg -i /tmp/temp_trt/nv-tensorrt-local-repo-ubuntu2204-10.3.0-cuda-12.5_1.0-1_amd64.deb && \
       dpkg -i /tmp/temp_trt/cudnn-local-repo-ubuntu2204-9.3.0_1.0-1_amd64.deb && \
       ls -l /tmp/temp_trt/ && \
       chmod +x /etc/init.d/rsyslog && \
       cp /var/nv-tensorrt-local-repo-ubuntu2204-10.3.0-cuda-12.5/nv-tensorrt-local-620E7D29-keyring.gpg /usr/share/keyrings/ && \
       cp /var/cudnn-local-repo-ubuntu2204-9.3.0/cudnn-*-keyring.gpg /usr/share/keyrings/ && \
       apt-get update && \
       DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       libnvinfer-bin=${TENSORRT_VERSION} \
       libnvinfer-dev=${TENSORRT_VERSION} \
       libnvinfer-dispatch-dev=${TENSORRT_VERSION} \
       libnvinfer-dispatch10=${TENSORRT_VERSION} \
       libnvinfer-headers-dev=${TENSORRT_VERSION} \
       libnvinfer-headers-plugin-dev=${TENSORRT_VERSION} \
       libnvinfer-lean-dev=${TENSORRT_VERSION} \
       libnvinfer-lean10=${TENSORRT_VERSION} \
       libnvinfer-plugin-dev=${TENSORRT_VERSION} \
       libnvinfer-plugin10=${TENSORRT_VERSION} \
       libnvinfer-samples=${TENSORRT_VERSION} \
       libnvinfer-vc-plugin-dev=${TENSORRT_VERSION} \
       libnvinfer-vc-plugin10=${TENSORRT_VERSION} \
       libnvinfer10=${TENSORRT_VERSION} \
       libnvonnxparsers-dev=${TENSORRT_VERSION} \
       libnvonnxparsers10=${TENSORRT_VERSION} \
       tensorrt-dev=${TENSORRT_VERSION} \
       libcudnn9-cuda-12=9.3.0.75-1 && \
       tar --version ; tar -xvf /tmp/docker/deepstream_sdk_v7.1.0_x86_64.tbz2 -C / ;  /opt/nvidia/deepstream/deepstream/install.sh && \
       /tmp/docker/install_extra_libs.sh && \
       /tmp/docker/gRPC_installation.sh && \
       cp /tmp/docker/user_additional_install_runtime.sh /opt/nvidia/deepstream/deepstream/ && \
       cp /tmp/docker/LicenseAgreementContainer.pdf /opt/nvidia/deepstream/deepstream/ && \
       mv  /opt/nvidia/deepstream/deepstream/user_additional_install_runtime.sh /opt/nvidia/deepstream/deepstream/user_additional_install.sh && \
       cp /tmp/docker/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json && \
       ln -s /usr/lib/x86_64-linux-gnu/libnvcuvid.so.1 /usr/lib/x86_64-linux-gnu/libnvcuvid.so && \
       ln -s /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-encode.so && \
       ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so && \
       cd /tmp && \
       dpkg --purge nv-tensorrt-local-repo-ubuntu2204-10.3.0-cuda-12.5 && \
       dpkg --purge cudnn-local-repo-ubuntu2204-9.3.0 && \
       rm -rf /root/tmp && \
       rm -rf temp_trt && \
       rm -rf /var/lib/apt/lists/* && \
       apt autoremove ; ldconfig


ENV NVIDIA_DRIVER_CAPABILITIES $NVIDIA_DRIVER_CAPABILITIES,video,compute,graphics,utility

WORKDIR /opt/nvidia/deepstream/deepstream

ENV PATH="${PATH}:${HOME}/.local/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/.local/lib"
ENV PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${HOME}/.local/lib/pkgconfig"


# RUN ldconfig

# NOTE: IP removal was moved earlier in the dockerfile.

