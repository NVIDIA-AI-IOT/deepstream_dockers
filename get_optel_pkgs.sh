#!/bin/bash
#################################################################
# NOTE: The open telementry packages were located here when first
# posted. These locations may have changed and the script may
# need updates.
#
# These were the original versions for reference:
#
# For x86 dockers download these additional packages into $ADDVAR99/x86/optel
#
# libabsl20240722_20240722.0-4_amd64.deb     (http://archive.ubuntu.com/ubuntu/pool/main/a/abseil/ )
# libcares2_1.34.5-1_amd64.deb               (https://ftp.debian.org/debian/pool/main/c/c-ares/)
# libgrpc++1.51t64_1.51.1-6_amd64.deb        (https://packages.debian.org/source/sid/grpc)
# libgrpc29t64_1.51.1-6_amd64.deb            (https://packages.debian.org/source/sid/grpc)
# libprotobuf32t64_3.21.12-14_amd64.deb      (https://deb.debian.org/debian/pool/main/p/protobuf/)
# libprotoc32t64_3.21.12-14_amd64.deb        (https://deb.debian.org/debian/pool/main/p/protobuf/)
# libre2-11_20250805-1+b1_amd64.deb          (http://deb.debian.org/debian/pool/main/r/re2/)
# opentelemetry-cpp-dev_1.23.0-2_amd64.deb   (https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/opentelemetry-cpp/1.23.0-2/)
# opentelemetry-cpp_1.23.0-2_amd64.deb       (https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/opentelemetry-cpp/1.23.0-2/)


# For Jetson Thor download these additional packages into $ADDVAR99/jetson/optel

# libabsl20240722_20240722.0-4_arm64.deb     (https://ftp.debian.org/debian/pool/main/a/abseil/ )
# libcares2_1.34.5-1_arm64.deb               (https://ftp.debian.org/debian/pool/main/c/c-ares/)
# libgrpc++1.51t64_1.51.1-6_arm64.deb        (https://ftp.debian.org/debian/pool/main/g/grpc/)
# libgrpc29t64_1.51.1-6_arm64.deb            (https://ftp.debian.org/debian/pool/main/g/grpc/)
# libprotobuf32t64_3.21.12-14_arm64.deb      (https://ftp.debian.org/debian/pool/main/p/protobuf/)
# libprotoc32t64_3.21.12-14_arm64.deb        (https://ftp.debian.org/debian/pool/main/p/protobuf/)
# libre2-11_20250805-1+b1_arm64.deb          (https://http.kali.org/pool/main/r/re2/)
# opentelemetry-cpp-dev_1.23.0-2_arm64.deb   (https://ftp.debian.org/debian/pool/main/o/opentelemetry-cpp/)
# opentelemetry-cpp_1.23.0-2_arm64.deb       (https://ftp.debian.org/debian/pool/main/o/opentelemetry-cpp/)
#

if [ -z "${ADDVAR99:-}" ]; then
  echo "Error: ADDVAR99 is not set" >&2
  exit 1
fi


mkdir -p $ADDVAR99/x86/optel
mkdir -p $ADDVAR99/jetson/optel


# get x86 packages
cd $ADDVAR99/x86/optel

wget \
  http://archive.ubuntu.com/ubuntu/pool/main/a/abseil/libabsl20240722_20240722.0-4ubuntu1_amd64.deb \
  https://ftp.debian.org/debian/pool/main/c/c-ares/libcares2_1.34.5-1+deb13u1_amd64.deb \
  https://ftp.debian.org/debian/pool/main/g/grpc/libgrpc++1.51t64_1.51.1-6_amd64.deb \
  https://ftp.debian.org/debian/pool/main/g/grpc/libgrpc29t64_1.51.1-6_amd64.deb \
  https://deb.debian.org/debian/pool/main/p/protobuf/libprotobuf32t64_3.21.12-11_amd64.deb \
  https://deb.debian.org/debian/pool/main/p/protobuf/libprotoc32t64_3.21.12-15_amd64.deb \
  http://deb.debian.org/debian/pool/main/r/re2/libre2-11_20250805-1+b2_amd64.deb \
  https://ftp.debian.org/debian/pool/main/o/opentelemetry-cpp/opentelemetry-cpp-dev_1.23.0-3_amd64.deb \
  https://ftp.debian.org/debian/pool/main/o/opentelemetry-cpp/opentelemetry-cpp_1.23.0-3_amd64.deb

# get aarch64

cd $ADDVAR99/jetson/optel

wget \
  https://ftp.debian.org/debian/pool/main/a/abseil/libabsl20240722_20240722.0-4_arm64.deb \
  https://ftp.debian.org/debian/pool/main/c/c-ares/libcares2_1.34.5-1+deb13u1_arm64.deb \
  https://ftp.debian.org/debian/pool/main/g/grpc/libgrpc++1.51t64_1.51.1-6_arm64.deb \
  https://ftp.debian.org/debian/pool/main/g/grpc/libgrpc29t64_1.51.1-6_arm64.deb \
  https://ftp.debian.org/debian/pool/main/p/protobuf/libprotobuf32t64_3.21.12-15_arm64.deb \
  https://ftp.debian.org/debian/pool/main/p/protobuf/libprotoc32t64_3.21.12-15_arm64.deb \
  https://http.kali.org/pool/main/r/re2/libre2-11_20250805-1+b2_arm64.deb \
  https://ftp.debian.org/debian/pool/main/o/opentelemetry-cpp/opentelemetry-cpp-dev_1.23.0-3_arm64.deb \
  https://ftp.debian.org/debian/pool/main/o/opentelemetry-cpp/opentelemetry-cpp_1.23.0-3_arm64.deb

