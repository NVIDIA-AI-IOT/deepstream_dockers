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


# User script to download and install PyDS from https://github.com/NVIDIA-AI-IOT/deepstream_python_apps
# -v option can be used to specify which version of PyDS to download and install
# -b option can be used to indicate that latest available bindings should be downloaded and installed

function usage() {
  echo "Usage: $0 -v PyDS-version -b (build-latest-bindings)"
  echo "  -v, --version            The version of PyDS to download and install"
  echo "  OR  "
  echo "  -b, --build-bindings     Compile and install latest PyDS instead of downloading wheels"
  echo "  -r, --remote-branch      Specify which branch of deepstream_python_apps to clone and build from"
  echo ""
  echo "Example: $0 --version 1.1.4"
  echo "Example: $0 --build-bindings"
  echo "Example: $0 --build-bindings -r master"
  exit 1
}

while [[ "$#" > 0 ]]; do
    case $1 in
        -v|--version) version="$2"; shift 2;;
        -r|--remote-branch) remote_branch="$2"; shift 2;;
        -b|--build-bindings) build_bindings=1; shift 1;;
        -h|--help) usage; shift 1;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
done

if [ -z "$version" ] && [ -z "$build_bindings" ]; then usage "The version of PyDS to download and install"; fi;

cd /opt/nvidia/deepstream/deepstream
echo "####################################"
echo "Downloading necessary pre-requisites"
echo "####################################"
apt-get update
apt-get install -y gstreamer1.0-libav
apt-get install --reinstall -y gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly  libswresample-dev libavutil-dev libavutil56 libavcodec-dev libavcodec58 libavformat-dev libavformat58 libavfilter7 libde265-dev libde265-0 libx265-199 libx264-163 libvpx7 libmpeg2encpp-2.1-0 libmpeg2-4 libmpg123-0
echo "Deleting GStreamer cache"
rm -rf ~/.cache/gstreamer-1.0/
apt install -y python3-gi python3-dev python3-gst-1.0 python-gi-dev git meson \
    python3 python3-pip python3.10-dev cmake g++ build-essential libglib2.0-dev \
    libglib2.0-dev-bin libgstreamer1.0-dev libtool m4 autoconf automake libgirepository1.0-dev libcairo2-dev

pip3 install cuda-python
cd /opt/nvidia/deepstream/deepstream/sources
if [ -z "$remote_branch" ]
then
    remote_branch="master"
    echo "#################################"
    echo "Default sync branch set to master"
    echo "#################################"
fi

git clone -b "$remote_branch" https://github.com/NVIDIA-AI-IOT/deepstream_python_apps.git
if [ $? -eq 0 ]; then
   echo "deepstream_python_apps cloned successfully from branch $remote_branch"
else
   echo "deepstream_python_apps clone from branch $remote_branch FAILED! Exiting..."
   exit 1
fi

if [ -z "$version" ] && [ $build_bindings == 1 ]
then
    echo "############################"
    echo "Building downloaded bindings"
    echo "############################"
 
    cd /opt/nvidia/deepstream/deepstream/sources/deepstream_python_apps
    git submodule update --init
    apt-get install -y apt-transport-https ca-certificates -y
    update-ca-certificates
    cd 3rdparty/gstreamer/subprojects/gst-python/
    # meson build
    # meson configure
    meson setup build
    cd build
    ninja
    ninja install
    cd /opt/nvidia/deepstream/deepstream/sources/deepstream_python_apps/bindings
    rm -rf build && mkdir build && cd build
    platform=$(uname -m)
    if [ $platform == "aarch64" ]
    then
	cmake .. -DPYTHON_MAJOR_VERSION=3 -DPYTHON_MINOR_VERSION=10 -DPIP_PLATFORM=linux_aarch64 -DDS_PATH=/opt/nvidia/deepstream/deepstream/
    else
        cmake ..
    fi
    make -j$(nproc)
    echo "###########################"
    echo "Installing built PyDS wheel"
    echo "###########################"
    if [ $platform == "aarch64" ]
    then
        pip3 install ./pyds-1*_aarch64.whl
    else
        pip3 install ./pyds-1*_x86_64.whl
    fi
elif [ -z "$build_bindings" ] && [[ ! -z $version ]]
then
    echo "##############################"
    echo "Pulling PyDS version: $version"
    echo "##############################"
    cd /opt/nvidia/deepstream/deepstream/sources/deepstream_python_apps
    platform=$(uname -m)
    if [ $platform == "aarch64" ]
    then
        URL="https://github.com/NVIDIA-AI-IOT/deepstream_python_apps/releases/download/v$version/pyds-$version-py3-none-linux_aarch64.whl"
    else
        URL="https://github.com/NVIDIA-AI-IOT/deepstream_python_apps/releases/download/v$version/pyds-$version-py3-none-linux_x86_64.whl"
    fi
    echo "url"
    echo $URL
    wget "$URL"
    if [ $platform == "aarch64" ]
    then
        wheel_file="pyds-$version-py3-none-linux_aarch64.whl"
    else
        wheel_file="pyds-$version-py3-none-linux_x86_64.whl"
    fi
    if [ -f $wheel_file ]
	then
        echo "########################################################"
        echo "Downloaded wheel $wheel_file"
        echo "########################################################"
        echo "#####################"
        echo "Installing PyDS wheel"
        echo "#####################"
        pip3 install $wheel_file
    else
        echo "#########################################"
        echo "PyDS wheel was not downloaded. Exiting..."
        echo "#########################################"
        exit 1
    fi
fi
