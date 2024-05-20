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

FROM nvcr.io/nvidia/tritonserver:24.03-py3-igpu

ADD vpi-lib-3.1.5-aarch64-l4t.deb /root
ADD vpi-dev-3.1.5-aarch64-l4t.deb /root

#
# Configure nvidia public apt repo
#

RUN apt-key adv --fetch-keys https://repo.download.nvidia.com/jetson/jetson-ota-public.asc
RUN echo "deb https://repo.download.nvidia.com/jetson/common r36.3 main" >> /etc/apt/sources.list


# GStreamer + deepstream devel dependencies
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive 	apt-get install -y --no-install-recommends \
	linux-libc-dev \
	libglew2.2 libjpeg8 libjson-glib-1.0-0 \
	gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-tools \
	gstreamer1.0-alsa \
	libuuid1 \
	libjansson4 \
	libjansson-dev \
	librabbitmq4 \
	libgles2-mesa \
	libv4l-dev \
	gdb bash-completion libboost-dev \
	uuid-dev libgstrtspserver-1.0-0 libgstrtspserver-1.0-dev \
	libgstreamer1.0-dev \
	libgstreamer-plugins-base1.0-dev \
	libglew-dev \
	libssl-dev \
        libjpeg-dev \
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
        unzip \
        openssl \
        libssl-dev \
	python3-distutils \
	python3-apt \
	python3 \
        libyaml-cpp-dev \
	rsyslog \
	tzdata \
	libcurl4 libcurl4-openssl-dev ca-certificates \
	vim g++  \
        libjsoncpp-dev \
	gstreamer1.0-rtsp \
        libc-bin \
        libpmi2-0 \
        libslurm37 \
        locales \
        libc6 \
        libcurl3-gnutls \
        linux-libc-dev \
        libc-dev-bin  && \
	rm -rf /var/lib/apt/lists/* && \
	apt autoremove


RUN mkdir -p /opt/tritonclient/ && \
    mkdir -p /tmp/temp_triton99 && \
    mkdir -p /opt/proto && \
    mkdir -p /tmp/temp_proto99 && \
    mkdir -p /opt/half && \
    mkdir -p /tmp/half99 && \
    cd /tmp/temp_triton99 && \
    wget https://github.com/triton-inference-server/server/releases/download/v2.44.0/tritonserver2.44.0-igpu.tgz -nv && \
    tar xvf tritonserver2.44.0-igpu.tgz -C /opt/tritonclient/ --strip-components=2 tritonserver/clients/lib/ tritonserver/clients/include && \
    cd /tmp/temp_proto99 && \
    wget https://github.com/protocolbuffers/protobuf/releases/download/v3.19.4/protoc-3.19.4-linux-aarch_64.zip -nv && \
    /usr/bin/unzip /tmp/temp_proto99/protoc-3.19.4-linux-aarch_64.zip -d /opt/proto && \
    cd /tmp/half99 && \
    wget https://sourceforge.net/projects/half/files/half/2.1.0/half-2.1.0.zip -nv && \
    /usr/bin/unzip /tmp/half99/half-2.1.0.zip -d /opt/half && \
    cd / && \
    rm -rf /tmp/temp_triton99 && \
    rm -rf /tmp/temp_proto99 && \
    rm -rf /tmp/half99


# work-around for vpi tests
RUN mkdir -p /lib/firmware

RUN apt-get update && \
       DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       /root/vpi-dev-3.1.5-aarch64-l4t.deb \
       /root/vpi-lib-3.1.5-aarch64-l4t.deb && \
       rm -rf /var/lib/apt/lists/* && \
       rm -f /root/vpi-dev-3.1.5-aarch64-l4t.deb /root/vpi-lib-3.1.5-aarch64-l4t.deb && \
       apt autoremove

# patch igpu triton jetson base docker cuda 12.2 directory from jetpack
# cp /usr/lib/aarch64-linux-gnu/tegra/libnvjpeg.so  /usr/local/cuda-12.2/lib64/libnvjpeg.so

RUN mv /usr/local/cuda-12.2/lib64/libnvjpeg.so  /usr/local/cuda-12.2/lib64/libnvjpeg.so.bak

# rsyslog into /etc/init.d/ (service can run)
ADD deps/rsyslog  /etc/init.d/
RUN chmod +x /etc/init.d/rsyslog


# workaround for directory rename from tegra to nvidia (symlink for jetson triton base docker)
RUN ln -s /usr/lib/aarch64-linux-gnu/nvidia /usr/lib/aarch64-linux-gnu/tegra


# IP requirement for removal
RUN rm -f /usr/lib/aarch64-linux-gnu/libavresample* /usr/lib/aarch64-linux-gnu/libavutil* \
    /usr/lib/aarch64-linux-gnu/libavcodec* /usr/lib/aarch64-linux-gnu/libavformat* \
    /usr/lib/aarch64-linux-gnu/libavfilter*
RUN rm -f /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstaudioparsers.so
RUN rm -f /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstfaad.so
RUN rm -f /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstvoaacenc.so \
    /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstx264.so /usr/lib/aarch64-linux-gnu/libx264.so* \
    /usr/lib/aarch64-linux-gnu/libmpeg2.so* /usr/lib/aarch64-linux-gnu/libmpeg2convert.so* /usr/lib/aarch64-linux-gnu/libmpeg2encpp-2.1.so* 
RUN rm -f /usr/lib/aarch64-linux-gnu/libmpg123.so* /usr/lib/aarch64-linux-gnu/libvpx.so* /usr/lib/aarch64-linux-gnu/libx265.so* \
    /usr/lib/aarch64-linux-gnu/libde265.so* /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstx265.so* \
    /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstde265.so* /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstvpx.so \
     /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstopenh264.so /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstnvcodec.so



CMD ["/bin/bash"]
WORKDIR /opt/nvidia/deepstream/deepstream

# User additional install script (moved to the correct location with the license file)
ADD user_additional_install_devel.sh /opt/
ADD user_deepstream_python_apps_install.sh /opt/

# workaround for TRT missing symlinks
RUN ln -s /usr/src/tensorrt/bin/trtexec /usr/bin/trtexec



RUN ldconfig

ENV LD_LIBRARY_PATH /opt/tritonserver/lib:/usr/local/cuda-12.2/lib64
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

ENV LD_PRELOAD /usr/lib/aarch64-linux-gnu/libgomp.so.1:/lib/aarch64-linux-gnu/libGLdispatch.so:$LD_PRELOAD

# Clean up link to internal repo
RUN sed -i '$d' /etc/apt/sources.list

RUN rm -f /etc/apt/sources.list.d/cuda.list

