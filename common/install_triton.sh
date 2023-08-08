#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2022-2023 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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
    # @{ librdkafka from source; Bug 200630652
    cd "/root/tmp"
    git clone https://github.com/edenhill/librdkafka.git
    cd librdkafka
    git reset --hard 063a9ae7a65cebdf1cc128da9815c05f91a2a996
    ./configure --enable-ssl
    make -j$(nproc)
    make install
    cd "/root/tmp"
    rm -rf librdkafka
    # @} librdkafka from source; Bug 200630652
}

utils_install_libhiredis_from_source()
{
    echo "Installing Dependencies: "
    apt-get install -y libglib2.0 libglib2.0-dev make libssl-dev

    echo "Installing libhiredis: "
    cd "/root/tmp"
    git clone https://github.com/redis/hiredis.git
    cd hiredis
    git checkout tags/v1.0.2
    make USE_SSL=1
    cp libhiredis* /opt/nvidia/deepstream/deepstream/lib/
    ln -sf /opt/nvidia/deepstream/deepstream/lib/libhiredis.so /opt/nvidia/deepstream/deepstream/lib/libhiredis.so.1.0.0
    ldconfig
    cd "/root/tmp"
    echo "finished installing libhiredis"

}

utils_install_libmosquitto_from_source()
{
    echo "Installing libmosquitto: "
    cd "/root/tmp"
    wget https://mosquitto.org/files/source/mosquitto-1.6.15.tar.gz
    tar -xvf mosquitto-1.6.15.tar.gz
    cd mosquitto-1.6.15
    make
    make install
    cd "/root/tmp"
    rm -rf mosquitto-1.6.15
    echo "finished installing libmosquitto"
}


cd "/root/tmp"

utils_install_librdkafka_from_source

tar -xvf "${DS_REL_PKG}" -C /
/opt/nvidia/deepstream/deepstream/install.sh
/opt/nvidia/deepstream/deepstream/samples/triton_backend_setup.sh
ldconfig

utils_install_libhiredis_from_source

utils_install_libmosquitto_from_source

# License and IP
mv /opt/user_additional_install_devel.sh /opt/nvidia/deepstream/deepstream/user_additional_install.sh
mv /opt/user_deepstream_python_apps_install.sh /opt/nvidia/deepstream/deepstream/user_deepstream_python_apps_install.sh
cp /root/tmp/LicenseAgreementContainer.pdf /opt/nvidia/deepstream/deepstream/

