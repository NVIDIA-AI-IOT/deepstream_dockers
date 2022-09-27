#!/bin/bash
#
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
#

utils_install_librdkafka_from_source()
{
    # @{ librdkafka from source; Bug 200630652
    cd "/root/tmp"
    apt-get update && apt-get install -y gcc g++ libssl-dev make python pkg-config zlib1g-dev
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
    git reset --hard d5b4c69b7113213c1da3a0ccbfd1ee1b40443c7a
    make USE_SSL=1
    cp libhiredis* /opt/nvidia/deepstream/deepstream/lib/
    ln -sf /opt/nvidia/deepstream/deepstream/lib/libhiredis.so /opt/nvidia/deepstream/deepstream/lib/libhiredis.so.1.0.1-dev
    ln -sf /opt/nvidia/deepstream/deepstream/lib/libhiredis_ssl.so /opt/nvidia/deepstream/deepstream/lib/libhiredis.so.1.0.1-dev-ssl
    ldconfig
    cd "/root/tmp"
    apt-get purge -y libssl-dev
    echo "finished installing libhiredis"

}


#Throws an error and causes a build failure for all errors in the script
#Custom Message describes where the error was thrown
#Bug 200714632
set -o errtrace
trap "echo CUSTOM MESSAGE: ERROR occured in this file: $BASH_SOURCE}" ERR
set -o errexit


cd /root/tmp
DS_VERSION=${DS_VERSION%.*}
tar -C "/" \
    -xvf "${DS_REL_PKG}" \
    opt/nvidia/deepstream/deepstream \
    opt/nvidia/deepstream/deepstream-${DS_VERSION}/install.sh \
    opt/nvidia/deepstream/deepstream-${DS_VERSION}/lib \
    opt/nvidia/deepstream/deepstream-${DS_VERSION}/bin/deepstream-test5-app \
    opt/nvidia/deepstream/deepstream-${DS_VERSION}/LICENSE.txt \
    opt/nvidia/deepstream/deepstream-${DS_VERSION}/LicenseAgreement.pdf \
    opt/nvidia/deepstream/deepstream-${DS_VERSION}/samples  \
    opt/nvidia/deepstream/deepstream-${DS_VERSION}/sources/apps/sample_apps/deepstream-test5/configs \
    opt/nvidia/deepstream/deepstream-${DS_VERSION}/sources/tools \
    opt/nvidia/deepstream/deepstream-${DS_VERSION}/sources/apps/sample_apps/deepstream-test5/README

utils_install_librdkafka_from_source


/opt/nvidia/deepstream/deepstream/install.sh

utils_install_libhiredis_from_source

pushd "/opt/nvidia/deepstream/deepstream/samples/streams"
rm -rf sample_720p.mjpeg sample_cam6.mp4 sample_industrial.jpg sample_720p.jpg
popd

rm -rf "/opt/nvidia/deepstream/deepstream/samples/models/Segmentation"

# License and IP
mv /opt/user_additional_install_runtime.sh /opt/nvidia/deepstream/deepstream/user_additional_install.sh
cp /root/tmp/LicenseAgreementContainer.pdf /opt/nvidia/deepstream/deepstream/
