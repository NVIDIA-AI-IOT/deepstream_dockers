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


ARG L4T_VERSION
FROM nvcr.io/nvidia/l4t-tensorrt:r8.5.2-runtime

# GStreamer + deepstream dependencies
 RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	rsyslog git \
	tzdata \
	libgstrtspserver-1.0-0 \
	libjansson4 \
	libglib2.0-0 \
	libjson-glib-1.0-0 \
	librabbitmq4 \
	gstreamer1.0-rtsp \
        libyaml-cpp-dev \
        libyaml-cpp0.6 \
        libjsoncpp-dev \
	libcurl4-openssl-dev \
        ca-certificates && \
	rm -rf /var/lib/apt/lists/* && \
	apt autoremove



#work-around for vpi tests
RUN mkdir -p /lib/firmware


#
# Install nvidia-vpi-dev for VPI developer packages
# Use nvidia-vpi if need VPI runtime only
#
 RUN apt-get update && apt-get install -y --no-install-recommends \
    nvidia-vpi-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


# IP requirement for removal
RUN rm -f /usr/lib/aarch64-linux-gnu/libavresample* /usr/lib/aarch64-linux-gnu/libavutil* \
    /usr/lib/aarch64-linux-gnu/libavcodec* /usr/lib/aarch64-linux-gnu/libavformat* \
    /usr/lib/aarch64-linux-gnu/libavfilter*
RUN rm -f /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstaudioparsers.so
RUN rm -f /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstfaad.so
RUN rm -f /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstvoaacenc.so \
     /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstx264.so /usr/lib/aarch64-linux-gnu/libx264.so.155  \
     /usr/lib/aarch64-linux-gnu/libmpeg2.so* /usr/lib/aarch64-linux-gnu/libmpeg2convert.so* /usr/lib/aarch64-linux-gnu/libmpeg2encpp-2.1.so* 
RUN rm -f  /usr/lib/aarch64-linux-gnu/libmpg123.so* /usr/lib/aarch64-linux-gnu/libvpx.so* /usr/lib/aarch64-linux-gnu/libx265.so.179  \
     /usr/lib/aarch64-linux-gnu/libde265.so* /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstx265.so*  \
     /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstde265.so* /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstvpx.so



CMD ["/bin/bash"]
WORKDIR /opt/nvidia/deepstream/deepstream

# User additional install script (moved to the correct location with the license file)
ADD user_additional_install_runtime.sh /opt/


# Workaround for Cuda missing symlinks in FAT base docker
RUN ln -s  /usr/local/cuda-11.4/targets/aarch64-linux/lib/libcufft.so.10.6.0.202 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libcufft.so
RUN ln -s  /usr/local/cuda-11.4/targets/aarch64-linux/lib/libcublas.so.11.6.6.84 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libcublas.so


# Workaround for deepstream-app --version-all
RUN ln -s /usr/lib/aarch64-linux-gnu/libcudnn.so.8.6.0 /usr/lib/aarch64-linux-gnu/libcudnn.so
RUN ln -s /usr/local/cuda-11.4/lib64/libcudart.so.11.4.298 /usr/local/cuda-11.4/lib64/libcudart.so

# Workaround for build
# Nvinfer libs:

 RUN ln -s /usr/lib/aarch64-linux-gnu/libnvinfer.so.8.5.2 /usr/lib/aarch64-linux-gnu/libnvinfer.so

 RUN ln -s /usr/lib/aarch64-linux-gnu/libnvparsers.so.8.5.2 /usr/lib/aarch64-linux-gnu/libnvparsers.so

 RUN ln -s /usr/lib/aarch64-linux-gnu/libnvinfer_plugin.so.8.5.2 /usr/lib/aarch64-linux-gnu/libnvinfer_plugin.so

 RUN ln -s /usr/lib/aarch64-linux-gnu/libnvonnxparser.so.8.5.2 /usr/lib/aarch64-linux-gnu/libnvonnxparser.so

 RUN ln -s /usr/lib/aarch64-linux-gnu/libnvparsers.so.8.5.2 /usr/lib/aarch64-linux-gnu/libnvcaffe_parser.so


# NPP libs:

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppc.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppc.so

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppial.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppial.so

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppicc.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppicc.so

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppidei.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppidei.so

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppif.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppif.so

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppig.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppig.so

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppim.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppim.so

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppist.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppist.so

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppisu.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppisu.so

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppitc.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnppitc.so

 RUN ln -s /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnpps.so.11 /usr/local/cuda-11.4/targets/aarch64-linux/lib/libnpps.so


RUN ldconfig

ENV LD_LIBRARY_PATH /usr/local/cuda-11.4/lib64

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

ENV LD_PRELOAD /usr/lib/aarch64-linux-gnu/libgomp.so.1:/lib/aarch64-linux-gnu/libGLdispatch.so:$LD_PRELOAD

# IP requirement for removal
# remove gstreamer1.0-libav (it is also in the base docker image)
RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y gstreamer1.0-libav

# Clean up link to internal repo
RUN sed -i '$d' /etc/apt/sources.list

RUN rm -f /etc/apt/sources.list.d/cuda.list

