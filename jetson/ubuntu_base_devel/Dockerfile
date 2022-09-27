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

FROM nvcr.io/nvidia/l4t-tensorrt:r8.4.1.5-devel


# IP requirement for removal (move to the end after everything has been installed)
# remove gstreamer1.0-libav (it is also in the base docker image)

# GStreamer + deepstream devel dependencies
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive 	apt-get install -y --no-install-recommends \
	linux-libc-dev \
	libglew2.1 libssl1.1 libjpeg8 libjson-glib-1.0-0 \
	gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-tools \
	gstreamer1.0-alsa \
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
	git \
	wget \
	python3-distutils \
	python3-apt \
	python \
        libyaml-cpp-dev \
	rsyslog \
	tzdata \
	libcurl4 libcurl4-openssl-dev ca-certificates \
	vim g++  \
	gstreamer1.0-rtsp && \
	rm -rf /var/lib/apt/lists/* && \
	apt autoremove


# Install nvidia-cudnn8-dev for CuDNN developer packages
# Use nvidia-cudnn8 if need CuDNN runtime only
#
RUN apt-get update && apt-get install -y --no-install-recommends --allow-change-held-packages \
    libcudnn8 \
    libcudnn8-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


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
RUN rm -f /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstvoaacenc.so

# IP requirement for removal (move to the end after everything has been installed)
# remove gstreamer1.0-libav (it is also in the base docker image)
RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y gstreamer1.0-libav



CMD ["/bin/bash"]
WORKDIR /opt/nvidia/deepstream/deepstream

# User additional install script (moved to the correct location with the license file)
ADD user_additional_install_devel.sh /opt/


RUN ldconfig

ENV LD_LIBRARY_PATH /usr/local/cuda-11.4/lib64
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

ENV LD_PRELOAD /usr/lib/aarch64-linux-gnu/libgomp.so.1:$LD_PRELOAD

# Clean up link to internal repo
RUN sed -i '$d' /etc/apt/sources.list

RUN rm -f /etc/apt/sources.list.d/cuda.list

