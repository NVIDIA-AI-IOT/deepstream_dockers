# SPDX-FileCopyrightText: Copyright (c) 2022-2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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



# additional components the user can self install
apt-get update
apt-get install -y gstreamer1.0-libav
# ubuntu 22.04 / updated to Ubuntu 24.04
apt-get install --reinstall -y gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly  libswresample-dev libavutil-dev libavutil58 libavcodec-dev libavcodec60 libavformat-dev libavformat60 libde265-dev libde265-0 libx265-199 libavfilter9 libmpeg2encpp-2.1-0t64 libmpeg2-4 libmpg123-0t64
# new since DS 7.1
apt-get install --reinstall -y libflac12t64 libmp3lame0 libxvidcore4 ffmpeg libfaad2 mjpegtools libvo-aacenc0 libdca0 libdvdnav4 libdvdread8t64
# new for dev-main 8.0 ubuntu 24.04
apt-get install --reinstall -y libvpx9 libavfilter-dev libflac++10 libmjpegutils-2.1-0t64 libopenh264-7 libx264-164 


# gstreamer1.0-plugins-good fix
cp /tmp99/libgstrtpmanager.so /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstrtpmanager.so
echo "Deleting GStreamer cache"
rm -rf ~/.cache/gstreamer-1.0/
