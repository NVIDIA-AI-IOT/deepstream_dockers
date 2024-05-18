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

FROM nvcr.io/nvidia/tritonserver:24.04-py3

ARG TENSORRT_VERSION
ARG CUDNN_VERSION
ARG DS_DIR
ARG BOOST_VERSION=1.71.0


# Removing unnecessary nvidia entries in sources.list
RUN head -n -2 /etc/apt/sources.list > /tmp/tmp.txt && mv /tmp/tmp.txt /etc/apt/sources.list

# install realsense sdk for 3d camera
# instructions: https://github.com/IntelRealSense/librealsense/blob/master/doc/distribution_linux.md
 RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE && \
        apt-get update && DEBIAN_FRONTEND=noninteractive  apt-get install -y software-properties-common && \
        add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u &&  apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y \
        librealsense2-dev librealsense2-utils && \
        rm -rf /var/lib/apt/lists/* && \
        apt autoremove

 RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive  apt-get install -y \
        wget \
        libxml2 \
        tzdata \
        libyaml-cpp-dev \
        gnutls-bin



 RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive  apt-get install -y --no-install-recommends \
        linux-libc-dev \
        libglew2.2 libssl3 libjpeg8 libjson-glib-1.0-0 \
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
        uuid-dev libgstrtspserver-1.0-0 libgstrtspserver-1.0-dev \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libglew-dev \
        libssl-dev \
        freeglut3-dev \
        libjpeg-dev \
        libcurl4-gnutls-dev \
        libjson-glib-dev \
        libboost-dev \
        libpango1.0-dev \
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
        openssl \
        git \
        wget \
        gnutls-bin \
        sshfs \
        python3-distutils \
        python3-apt \
        python3 \
        python3-pip \
        rsyslog \
        libjsoncpp-dev \
        vim  rsync \
        libpython3.10-dev \
        gstreamer1.0-rtsp \
        libcairo2 \
        libpangocairo-1.0-0 \
        libx11-6 \
        libyaml-cpp-dev \
        libc-dev-bin\
        libslurm37 \
        libc6 \
        libcurl3-gnutls \
        libc-bin \
        libpmi2-0 \
        libcurl4 \
        linux-libc-dev \
        curl && \
        rm -rf /var/lib/apt/lists/* && \
        apt autoremove

 
RUN pip3 install --upgrade pip

# config file
ADD deps/ofed-ucx.conf /root

# update CUDNN to 8.9.6
# NOTE This should already be downloaded into x86_64 directory
ADD cudnn-local-repo-ubuntu2204-8.9.6.50_1.0-1_amd64.deb /tmp

 RUN mkdir -p /tmp/temp_trt && \
       cd /tmp/temp_trt && \
       ls -l /tmp/temp_trt/ && \
       mv /tmp/cudnn-local-repo-ubuntu2204-8.9.6.50_1.0-1_amd64.deb  /tmp/temp_trt/ && \
       ls -l /tmp/temp_trt/ && \
       dpkg -i ./cudnn-local-repo-ubuntu2204-8.9.6.50_1.0-1_amd64.deb && \
       cp /var/cudnn-local-repo-ubuntu2204-8.9.6.50/cudnn-local-1998375D-keyring.gpg /usr/share/keyrings/ && \
       apt-get update && \
       DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       libcudnn8-dev=8.9.6.50-1+cuda12.2 \
       libcudnn8=8.9.6.50-1+cuda12.2 && \
       cd /tmp && \
       dpkg --purge cudnn-local-repo-ubuntu2204-8.9.6.50 && \
       rm -rf temp_trt && \
       rm -rf /var/lib/apt/lists/*

# config file
ADD deps/ofed-ucx.conf /root


# Mellanox OFED libraries: 23.10+
  RUN mkdir /opt/dev_ucx && \
          wget -O /opt/dev_ucx/MLNX_OFED_LINUX-23.10-1.1.9.0-ubuntu22.04-x86_64.tgz https://content.mellanox.com/ofed/MLNX_OFED-23.10-1.1.9.0/MLNX_OFED_LINUX-23.10-1.1.9.0-ubuntu22.04-x86_64.tgz --no-check-certificate --no-verbose  && \
       wget -O /opt/dev_ucx/ofed-ucx.conf  https://urm.nvidia.com/artifactory/sw-ds-generic/depend/ucx/ofed-ucx.conf --no-check-certificate --no-verbose  && \
        cd  /opt/dev_ucx && \
        tar --no-same-owner -xf  MLNX_OFED_LINUX-23.10-1.1.9.0-ubuntu22.04-x86_64.tgz && \
        cp /opt/dev_ucx/ofed-ucx.conf /opt/dev_ucx/MLNX_OFED_LINUX-23.10-1.1.9.0-ubuntu22.04-x86_64/ && \
        cd  /opt/dev_ucx/MLNX_OFED_LINUX-23.10-1.1.9.0-ubuntu22.04-x86_64 && \
        ls -l /opt/dev_ucx/MLNX_OFED_LINUX-23.10-1.1.9.0-ubuntu22.04-x86_64  && \
        chmod +x /opt/dev_ucx/MLNX_OFED_LINUX-23.10-1.1.9.0-ubuntu22.04-x86_64/mlnxofedinstall && \
        /opt/dev_ucx/MLNX_OFED_LINUX-23.10-1.1.9.0-ubuntu22.04-x86_64/mlnxofedinstall --config /opt/dev_ucx/MLNX_OFED_LINUX-23.10-1.1.9.0-ubuntu22.04-x86_64/ofed-ucx.conf --without-fw-update -q --force

# rsyslog into /etc/init.d/ (service can run)
ADD deps/rsyslog  /etc/init.d/
RUN chmod +x /etc/init.d/rsyslog

# UCX 1.15.0

  RUN mkdir /opt/dev_ucx2 && \
         wget -O /opt/dev_ucx2/ucx-1.15.0.tar.gz  https://github.com/openucx/ucx/releases/download/v1.15.0/ucx-1.15.0.tar.gz --no-verbose  && \
        cd  /opt/dev_ucx2 && \
        tar -xf ucx-1.15.0.tar.gz && \
        cd /opt/dev_ucx2/ucx-1.15.0 && \
        /opt/dev_ucx2/ucx-1.15.0/contrib/configure-release-mt --prefix=/usr --enable-examples --with-java=no --with-cuda=/usr/local/cuda && \
        make install



RUN mkdir -p /opt/tritonclient/ && \
    mkdir -p /tmp/temp_triton99 && \
    mkdir -p /opt/proto && \
    mkdir -p /tmp/temp_proto99 && \
    mkdir -p /opt/half && \
    mkdir -p /tmp/half99 && \
    cd /tmp/temp_triton99 && \
    wget https://github.com/triton-inference-server/server/releases/download/v2.45.0/v2.45.0_ubuntu2204.clients.tar.gz -nv && \
    tar xzf v2.45.0_ubuntu2204.clients.tar.gz -C /opt/tritonclient/ lib include && \
    cd /tmp/temp_proto99 && \
    wget https://github.com/protocolbuffers/protobuf/releases/download/v3.19.4/protoc-3.19.4-linux-x86_64.zip -nv && \
    /usr/bin/unzip /tmp/temp_proto99/protoc-3.19.4-linux-x86_64.zip -d /opt/proto && \
    cd /tmp/half99 && \
    wget https://sourceforge.net/projects/half/files/half/2.1.0/half-2.1.0.zip -nv && \
    /usr/bin/unzip /tmp/half99/half-2.1.0.zip -d /opt/half && \
    cd / && \
    rm -rf /tmp/temp_triton99 && \
    rm -rf /tmp/temp_proto99 && \
    rm -rf /tmp/half99



COPY trtserver_base_devel/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
COPY trtserver_base_devel/entrypoint.sh ${DS_DIR}/


# ENV NVIDIA_DRIVER_CAPABILITIES $NVIDIA_DRIVER_CAPABILITIES,video,graphics
ENV NVIDIA_DRIVER_CAPABILITIES $NVIDIA_DRIVER_CAPABILITIES,video,compute,graphics,utility

ENV LD_LIBRARY_PATH /opt/tritonserver/lib:/usr/src/tensorrt/lib:/opt/riva/lib:/usr/local/cuda-12/lib64:$LD_LIBRARY_PATH

ENTRYPOINT ["${DS_DIR}/entrypoint.sh"]

WORKDIR ${DS_DIR}

# add symlink
RUN ln -s /usr/src/tensorrt/bin/trtexec /usr/bin/trtexec


RUN ln -s /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-encode.so && \
 ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so


ADD deps/gRPC_installation.sh /root/
RUN /root/gRPC_installation.sh

ENV PATH="/opt/proto/bin:${PATH}:${HOME}/.local/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/.local/lib"
ENV PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${HOME}/.local/lib/pkgconfig"


# IP requirement for removal
RUN rm -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstaudioparsers.so \
       /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstx264.so \
       /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstfaad.so \
       /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstvoaacenc.so 
RUN rm -f /usr/lib/x86_64-linux-gnu/libavresample* /usr/lib/x86_64-linux-gnu/libavutil* \
    /usr/lib/x86_64-linux-gnu/libavcodec* /usr/lib/x86_64-linux-gnu/libavformat* \
    /usr/lib/x86_64-linux-gnu/libavfilter*  /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstde265.so* \
    /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstx265.so* /usr/lib/x86_64-linux-gnu/libde265.so* /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstvpx.so*
RUN rm -f /usr/lib/x86_64-linux-gnu/libmpeg2.so* /usr/lib/x86_64-linux-gnu/libmpeg2encpp-2.1.so* /usr/lib/x86_64-linux-gnu/libmpg123.so*  \
    /usr/lib/x86_64-linux-gnu/libx265.so* /usr/lib/x86_64-linux-gnu/libx264.so* /usr/lib/x86_64-linux-gnu/libvpx.so*  \
    /usr/lib/x86_64-linux-gnu/libmpeg2convert.so* /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstopenh264.so \
    /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstnvcodec.so

# ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libgstbadvideo-1.0.so.0

ADD user_additional_install_devel.sh /opt/
ADD user_deepstream_python_apps_install.sh /opt/

RUN rm -f /root/gRPC_installation.sh /root/*deb && \
    rm -rf /opt/dev_ucx /opt/dev_ucx2 && \
    rm -rf  /opt/tritonserver/backends/dali 
