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

FROM nvcr.io/nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu20.04

ARG TENSORRT_VERSION
ARG CUDNN_VERSION


# Add open GL libraries
RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive  apt-get install -y --no-install-recommends \
        pkg-config \
        libglvnd-dev \
        libgl1-mesa-dev \
        libegl1-mesa-dev \
        libgles2-mesa-dev \
        libegl-mesa0 && \
        rm -rf /var/lib/apt/lists/* && \
        apt autoremove


RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive  apt-get install -y  --no-install-recommends \
        wget \
        libyaml-cpp-dev \
        gnutls-bin && \
        rm -rf /var/lib/apt/lists/* && \
        apt autoremove

#
# IP requirement for removal
#  Remove  gstreamer1.0-libav \

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive 	apt-get install -y --no-install-recommends \
	gstreamer1.0-tools \
	gstreamer1.0-plugins-good \
	gstreamer1.0-plugins-bad \
	gstreamer1.0-plugins-ugly \
	gstreamer1.0-alsa \
	libssl1.1 \
	libgstreamer1.0-0 \
	libgstrtspserver-1.0-0 \
        libjansson4 \
	librabbitmq4 \
	libuuid1 \
	libcurl4 \
	libjson-glib-1.0-0 \
	gstreamer1.0-rtsp \
	rsyslog \
	git \
	python \
        gcc \
	tzdata && \
	rm -rf /var/lib/apt/lists/* && \
	apt autoremove

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


COPY trtserver_base_devel/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json


# ENV NVIDIA_DRIVER_CAPABILITIES $NVIDIA_DRIVER_CAPABILITIES,video
ENV NVIDIA_DRIVER_CAPABILITIES $NVIDIA_DRIVER_CAPABILITIES,video,compute,graphics,utility

WORKDIR /opt/nvidia/deepstream/deepstream

# User additional install script (moved to the correct location with the license file)
ADD user_additional_install_runtime.sh /opt/

RUN ln -s /usr/lib/x86_64-linux-gnu/libnvcuvid.so.1 /usr/lib/x86_64-linux-gnu/libnvcuvid.so && \
    ln -s /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-encode.so 


ADD deps/gRPC_installation.sh /root/
RUN /root/gRPC_installation.sh

# added wget so gRPC script could install
RUN apt-get remove --purge -y wget
RUN rm /root/gRPC_installation.sh && \
    cd /tmp && \
    rm -rf temp_cuda99

RUN ldconfig

# IP requirement for removal
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstaudioparsers.so
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstfaad.so
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstvoaacenc.so
RUN rm -f /usr/lib/x86_64-linux-gnu/libavresample* /usr/lib/x86_64-linux-gnu/libavutil* \
     /usr/lib/x86_64-linux-gnu/libavcodec* /usr/lib/x86_64-linux-gnu/libavformat* \
     /usr/lib/x86_64-linux-gnu/libavfilter*
