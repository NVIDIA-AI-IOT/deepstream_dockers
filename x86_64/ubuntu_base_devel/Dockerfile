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

ARG CUDA_VERSION

# Build vulkan libs on a separate docker image
FROM ubuntu:20.04 as vulkan-khronos

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends  gnupg ca-certificates


# Vulkan devel image 
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git \
        libx11-xcb-dev \
        libxkbcommon-dev \
        libwayland-dev \
        libxrandr-dev \
        libegl1-mesa-dev \
        python3 \
        wget \
        python3-distutils \
        python3-apt \
    && rm -rf /var/lib/apt/lists/*

# Install cmake version 3.15
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2-Linux-x86_64.tar.gz && \
    tar -xvf cmake-3.15.2-Linux-x86_64.tar.gz && cp cmake-3.15.2-Linux-x86_64/bin/cmake /usr/local/bin && \
    mkdir -p /usr/local/share/cmake-3.15 && \
    cp -r cmake-3.15.2-Linux-x86_64/share/cmake-3.15/* /usr/local/share/cmake-3.15 && \
    rm -rf cmake-3.15.2-Linux-x86_64*

# Download and compile vulkan components
# WAR: v1.1.123 was chosen based on time frame of Vulkan dockerfile
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    git clone https://github.com/KhronosGroup/Vulkan-ValidationLayers.git /opt/vulkan && \
    cd /opt/vulkan && git checkout v1.1.123 && \
    mkdir build && cd build && ../scripts/update_deps.py && \
    cmake -C helper.cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build . && make install && ldconfig && \
    mkdir -p /usr/local/lib && cp -a Vulkan-Loader/build/install/lib/* /usr/local/lib && \
    mkdir -p /usr/local/include/vulkan && cp -r Vulkan-Headers/build/install/include/vulkan/* /usr/local/include/vulkan && \
    mkdir -p /usr/local/share/vulkan/registry && \
    cp -r Vulkan-Headers/build/install/share/vulkan/registry/* /usr/local/share/vulkan/registry && \
    rm -rf /opt/vulkan

# use cuda base docker for DS docker image

FROM nvcr.io/nvidia/cuda:${CUDA_VERSION}-devel-ubuntu20.04

ARG TENSORRT_VERSION
ARG CUDNN_VERSION


# Add open GL libraries
RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive  apt-get install -y --no-install-recommends \
        pkg-config \
        libglvnd-dev \
        libgl1-mesa-dev \
        libegl1-mesa-dev \
        libgles2-mesa-dev

RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive  apt-get install -y \
        wget \
        libxml2 \
        libyaml-cpp-dev \
        gnutls-bin

# Add TensorRT repo
# NOTE THis should already be downloaded into x86_64 directory
# nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb 
ADD nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb /tmp

# install TensorRT repo
 RUN mkdir -p /tmp/temp_trt && \
       cd /tmp/temp_trt && \
       mv /tmp/nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb /tmp/temp_trt/ && \
       dpkg -i /tmp/temp_trt/nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb && \
       apt-key add /var/nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604/9a60d8bf.pub && \
       apt-get update && \
       cd /tmp && \
       rm -rf temp_trt

# install TensorRT repo from a hosted file on a server
# add a URL to  server where  TRT is hosted
# Commented out the  Add version before uncommenting this version.
# RUN mkdir -p /tmp/temp_trt && \
#       cd /tmp/temp_trt && \
#       wget  https://<add url>/nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb && \
#       dpkg -i /tmp/temp_trt/nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb && \
#       apt-key add /var/nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604/9a60d8bf.pub && \
#       apt-get update && \
#       cd /tmp && \
#       rm -rf temp_trt



 RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive  apt-get install -y --no-install-recommends \
        libnvinfer8=8.4.1-1+cuda11.6 \
        libnvinfer-plugin8=8.4.1-1+cuda11.6 \
        libnvparsers8=8.4.1-1+cuda11.6 \
        libnvonnxparsers8=8.4.1-1+cuda11.6 \
        libnvinfer-bin=8.4.1-1+cuda11.6 \
        libnvinfer-dev=8.4.1-1+cuda11.6 \
        libnvinfer-plugin-dev=8.4.1-1+cuda11.6 \
        libnvparsers-dev=8.4.1-1+cuda11.6 \
        libnvonnxparsers-dev=8.4.1-1+cuda11.6 \
        libnvinfer-samples=8.4.1-1+cuda11.6 \
        python3-libnvinfer=8.4.1-1+cuda11.6 \
        uff-converter-tf=8.4.1-1+cuda11.6 \
        graphsurgeon-tf=8.4.1-1+cuda11.6 && \
        rm -rf /var/lib/apt/lists/*

# IP requirement for removal
# gstreamer1.0-libav
	
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive 	apt-get install -y --no-install-recommends \
	linux-libc-dev \
	libglew2.1 libssl1.1 libjpeg8 libjson-glib-1.0-0 \
	gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-tools \
	gstreamer1.0-alsa \
	libcurl4 \
	libuuid1 \
	libjansson4 \
	libjansson-dev \
	librabbitmq4 \
	libgles2-mesa \
	libgstrtspserver-1.0-0 \
	libv4l-dev \
	gdb bash-completion libboost-dev \
	uuid-dev libgstrtspserver-1.0-0 libgstrtspserver-1.0-0-dbg libgstrtspserver-1.0-dev \
	libgstreamer1.0-dev \
	libgstreamer-plugins-base1.0-dev \
	libglew-dev \
	libssl-dev \
	libopencv-dev \
	freeglut3-dev \
	libjpeg-dev \
	libcurl4-gnutls-dev \
	libjson-glib-dev \
	libboost-dev \
	librabbitmq-dev \
	libgles2-mesa-dev \
	pkg-config \
	libxau-dev \
	libxdmcp-dev \
	libxcb1-dev \
	libxext-dev \
	libx11-dev \
        libnss3 \
        linux-libc-dev \
        libxml2 \
	git \
	wget \
        gnutls-bin \
        sshfs \
	python3-distutils \
	python3-apt \
	python \
	rsyslog \
	vim  rsync \
	gstreamer1.0-rtsp && \
	rm -rf /var/lib/apt/lists/* && \
	apt autoremove


# install realsense sdk for 3d camera (Optional; disabled by default)
# instructions: https://github.com/IntelRealSense/librealsense/blob/master/doc/distribution_linux.md
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE && \
	apt-get update && DEBIAN_FRONTEND=noninteractive  apt-get install -y software-properties-common && \
	add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u &&  apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
	librealsense2-dev librealsense2-utils && \
	rm -rf /var/lib/apt/lists/* && \
	apt autoremove


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libx11-xcb-dev \
    libxkbcommon-dev \
    libwayland-dev \
    libxrandr-dev \
    libegl1-mesa-dev && \
    rm -rf /var/lib/apt/lists/*


COPY --from=vulkan-khronos /usr/local/bin /usr/local/bin
COPY --from=vulkan-khronos /usr/local/lib /usr/local/lib
COPY --from=vulkan-khronos /usr/local/include/vulkan /usr/local/include/vulkan
COPY --from=vulkan-khronos /usr/local/share/vulkan /usr/local/share/vulkan
COPY --from=vulkan-khronos /usr/local/share/cmake-3.15 /usr/local/share/cmake-3.15


COPY nvidia_icd.json /etc/vulkan/icd.d/nvidia_icd.json
COPY trtserver_base_devel/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json


# To get video driver libraries at runtime (libnvidia-encode.so/libnvcuvid.so)
ENV NVIDIA_DRIVER_CAPABILITIES $NVIDIA_DRIVER_CAPABILITIES,video,compute,graphics,utility

WORKDIR /opt/nvidia/deepstream/deepstream

# User additional install script (moved to the correct location with the license file)
ADD user_additional_install_devel.sh /opt/


RUN ln -s /usr/lib/x86_64-linux-gnu/libnvcuvid.so.1 /usr/lib/x86_64-linux-gnu/libnvcuvid.so
RUN ln -s /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-encode.so

RUN ldconfig

ADD deps/gRPC_installation.sh /root/
RUN /root/gRPC_installation.sh

RUN cd / && \
    rm -rf /opt/dev_ucx && \
    rm -rf /opt/dev_ucx2 && \
    rm /root/gRPC_installation.sh


# IP requirement for removal
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstaudioparsers.so
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstfaad.so
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstvoaacenc.so
RUN rm -f /usr/lib/x86_64-linux-gnu/libavresample* /usr/lib/x86_64-linux-gnu/libavutil* \
     /usr/lib/x86_64-linux-gnu/libavcodec* /usr/lib/x86_64-linux-gnu/libavformat* \
     /usr/lib/x86_64-linux-gnu/libavfilter*
