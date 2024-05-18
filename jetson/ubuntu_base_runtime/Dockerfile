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


ARG L4T_VERSION

FROM nvcr.io/nvidia/l4t-tensorrt:r8.6.2-runtime

#
# Configure nvidia public apt repo
#

RUN apt-key adv --fetch-keys https://repo.download.nvidia.com/jetson/jetson-ota-public.asc
RUN echo "deb https://repo.download.nvidia.com/jetson/common r36.3 main" >> /etc/apt/sources.list



ADD vpi-dev-3.1.5-aarch64-l4t.deb /root
ADD vpi-lib-3.1.5-aarch64-l4t.deb /root

# GStreamer + deepstream dependencies
 RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	rsyslog git \
	tzdata \
	libgstrtspserver-1.0-0 \
	libjansson4 \
        libglib2.0-dev \
	libjson-glib-1.0-0 \
	librabbitmq4 \
	gstreamer1.0-rtsp \
        libgstreamer1.0-0 \
        gstreamer1.0-tools \
        libyaml-cpp-dev \
        libjsoncpp-dev \
        libjpeg-dev \
        openssl \
        libssl3 \
        build-essential \
        libssl-dev \
	libcurl4-openssl-dev \
        libcjson-dev \
        linux-libc-dev \
        wget \
        ca-certificates && \
	rm -rf /var/lib/apt/lists/* && \
	apt autoremove



RUN  mkdir -p /lib/firmware ; apt-get update && \
       DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       /root/vpi-dev-3.1.5-aarch64-l4t.deb \
       /root/vpi-lib-3.1.5-aarch64-l4t.deb && \
       rm -rf /var/lib/apt/lists/* && \
       rm -f /root/vpi-dev-3.1.5-aarch64-l4t.deb /root/vpi-lib-3.1.5-aarch64-l4t.deb && \
       apt autoremove

# rsyslog into /etc/init.d/ (service can run)
ADD deps/rsyslog  /etc/init.d/
RUN chmod +x /etc/init.d/rsyslog


# IP requirement for removal
RUN rm -f /usr/lib/aarch64-linux-gnu/libavresample* /usr/lib/aarch64-linux-gnu/libavutil* \
    /usr/lib/aarch64-linux-gnu/libavcodec* /usr/lib/aarch64-linux-gnu/libavformat* \
    /usr/lib/aarch64-linux-gnu/libavfilter*
RUN rm -f /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstaudioparsers.so
RUN rm -f /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstfaad.so
RUN rm -f /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstvoaacenc.so \
     /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstx264.so /usr/lib/aarch64-linux-gnu/libx264.so*  \
     /usr/lib/aarch64-linux-gnu/libmpeg2.so* /usr/lib/aarch64-linux-gnu/libmpeg2convert.so* /usr/lib/aarch64-linux-gnu/libmpeg2encpp-2.1.so* 
RUN rm -f  /usr/lib/aarch64-linux-gnu/libmpg123.so* /usr/lib/aarch64-linux-gnu/libvpx.so* /usr/lib/aarch64-linux-gnu/libx265.so*  \
     /usr/lib/aarch64-linux-gnu/libde265.so* /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstx265.so*  \
     /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstde265.so* /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstvpx.so \
     /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstopenh264.so /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstnvcodec.so



CMD ["/bin/bash"]
WORKDIR /opt/nvidia/deepstream/deepstream

# User additional install script (moved to the correct location with the license file)
ADD user_additional_install_runtime.sh /opt/

# workaround for directory change from tegra to nvidia
RUN ln -s /usr/lib/aarch64-linux-gnu/nvidia /usr/lib/aarch64-linux-gnu/tegra

# Workaround for Cuda missing symlinks in FAT base docker
RUN ln -s  /usr/local/cuda-12.2/targets/aarch64-linux/lib/libcufft.so.11 /usr/local/cuda-12.2/targets/aarch64-linux/lib/libcufft.so
RUN ln -s  /usr/local/cuda-12.2/targets/aarch64-linux/lib/libcublas.so.12 /usr/local/cuda-12.2/targets/aarch64-linux/lib/libcublas.so


# Workaround for deepstream-app --version-all
RUN ln -s /usr/lib/aarch64-linux-gnu/libcudnn.so.8 /usr/lib/aarch64-linux-gnu/libcudnn.so
RUN ln -s /usr/local/cuda-12.2/lib64/libcudart.so.12 /usr/local/cuda-12.2/lib64/libcudart.so

RUN ln -s /usr/src/tensorrt/bin/trtexec /usr/bin/trtexec

# Workaround for build
# Nvinfer libs:


  RUN ln -s  /usr/lib/aarch64-linux-gnu/libnvparsers.so.8 /usr/lib/aarch64-linux-gnu/libnvparsers.so

  RUN ln -s /usr/lib/aarch64-linux-gnu/libnvinfer_plugin.so.8 /usr/lib/aarch64-linux-gnu/libnvinfer_plugin.so

  RUN ln -s /usr/lib/aarch64-linux-gnu/libnvcaffe_parser.so.8 /usr/lib/aarch64-linux-gnu/libnvonnxparser.so

 RUN ln -s /usr/lib/aarch64-linux-gnu/libnvparsers.so.8.6.2 /usr/lib/aarch64-linux-gnu/libnvcaffe_parser.so



RUN ldconfig

ENV LD_LIBRARY_PATH /usr/local/cuda-12.2/lib64

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

ENV LD_PRELOAD /usr/lib/aarch64-linux-gnu/libgomp.so.1:/lib/aarch64-linux-gnu/libGLdispatch.so:$LD_PRELOAD

# IP requirement for removal
RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y gstreamer1.0-libav

# Clean up link to internal repo
RUN sed -i '$d' /etc/apt/sources.list

RUN rm -f /etc/apt/sources.list.d/cuda.list

