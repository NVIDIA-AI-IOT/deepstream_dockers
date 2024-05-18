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

#===============================================================================
#IMPORTANT NOTE: This file is For Jetson only
#===============================================================================

utils_install_librdkafka_from_source()
{
    # @{ librdkafka from source;
    echo "Installing librdkafka: "

    cd "/root/tmp"
    git clone https://github.com/confluentinc/librdkafka.git
    cd librdkafka
    git checkout tags/v2.2.0
    ./configure --enable-ssl
    make -j$(nproc)
    make install
    cd "/root/tmp"
    rm -rf librdkafka

    echo "finished installing librdkafka:"
    # @} librdkafka from source;

}

utils_install_libhiredis_from_source()
{
    echo "Installing Dependencies: "
    apt-get install -y libglib2.0 libglib2.0-dev make libssl-dev

    echo "Installing libhiredis: "
    cd "/root/tmp"
    git clone https://github.com/redis/hiredis.git
    cd hiredis
    git checkout tags/v1.2.0
    make USE_SSL=1
    cp libhiredis* /opt/nvidia/deepstream/deepstream/lib/
    ln -sf /opt/nvidia/deepstream/deepstream/lib/libhiredis.so /opt/nvidia/deepstream/deepstream/lib/libhiredis.so.1.1.0
    ldconfig
    cd "/root/tmp"
    echo "finished installing libhiredis"

}

utils_install_libmosquitto_from_source()
{
    echo "Installing Dependencies: "
    apt update
    apt-get install -y libcjson-dev libssl-dev

    echo "Installing libmosquitto: "
    cd "/root/tmp"
    wget https://mosquitto.org/files/source/mosquitto-2.0.15.tar.gz
    tar -xvf mosquitto-2.0.15.tar.gz
    cd mosquitto-2.0.15
    make
    make install
    cd "/root/tmp"
    rm -rf mosquitto-2.0.15
    echo "finished installing libmosquitto"

}

utils_install_glib_from_source()
{
  # ARCH=`uname -m`
  # if [ "$ARCH" == "x86_64" ]; then
    echo "Installing Dependencies: "
    apt update
    apt-get install -y python3 python3-pip python3-setuptools python3-wheel ninja-build
    pip3 install meson

    echo "Installing glib 2.76.6: "
    cd "/root/tmp"
    git clone https://github.com/GNOME/glib.git
    cd glib
    git checkout 2.76.6
    meson build --prefix=/usr
    ninja -C build/
    cd build/
    ninja install
    cd "/root/tmp"
    rm -rf glib
    echo "finished installing glib"
  # fi
}



cd "/root/tmp"

utils_install_librdkafka_from_source

tar -xvf "${DS_REL_PKG}" -C /
/opt/nvidia/deepstream/deepstream/install.sh

# No longer needed since the Jetson triton base docker is available
# /opt/nvidia/deepstream/deepstream/samples/triton_backend_setup.sh


ldconfig

utils_install_libhiredis_from_source

utils_install_libmosquitto_from_source

utils_install_glib_from_source

# License and IP
mv /opt/user_additional_install_devel.sh /opt/nvidia/deepstream/deepstream/user_additional_install.sh
mv /opt/user_deepstream_python_apps_install.sh /opt/nvidia/deepstream/deepstream/user_deepstream_python_apps_install.sh
cp /root/tmp/LicenseAgreementContainer.pdf /opt/nvidia/deepstream/deepstream/

