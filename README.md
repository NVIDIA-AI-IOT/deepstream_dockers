# DeepStream 9.0 Open Source Dockerfiles Guide

The documentation here is intended to help customers build the Open Source DeepStream Dockerfiles.

This information is useful for both x86 systems with dGPU setup and NVIDIA Jetson Thor only devices.

Improvements from previous releases.   
(A) Building Jetson Thor dockers on x86 Linux PCs (cross-compile on x86).  
(B) Dockerfiles into different directories based on platform (Jetson or x86).  
(C) Build setup files to put all of the files in correct location for the various build x86 and x86 crosss-compile (for Jetson).  

NOTE: Jetson Thor support only. Also x86 uses CUDA 13.1 and Jetson Thor uses Cuda 13.


## 1 Additional Installation to use all DeepStreamSDK Features within the docker container.

Since DS 6.3, deepStream docker containers do NOT package libraries necessary for certain multimedia operations like audio data parsing, CPU decode, and CPU encode. This change could affect processing certain video streams/files like mp4 that include audio tracks.

Please run the below script inside the docker images to install additional packages that might be necessary to use all of the DeepStreamSDK features :

```
/opt/nvidia/deepstream/deepstream/user_additional_install.sh
```

## 1.1 Triton samples additional libraries required.

For Triton samples, while running /opt/nvidia/deepstream/deepstream-9.0/samples/prepare_classification_test_video.sh, FFMPEG package along with additional dependent libs need to be installed using command below. For additional information please refer to section 1.4 (for codecs: DIFFERENCES WITH  DEEPSTREAM 6.1 AND ABOVE) & section 1.5  for BREAKING CHANGES in Release notes.


```
apt-get install --reinstall libflac8 libmp3lame0 libxvidcore4 ffmpeg
```


## 1.2 Libraries and Packages needed for docker builds.

There is a need for two directories to handle these libraries and packages for x86 and Jetson.

export ADDVAR99=\<your x86 and Jetson content\>

```
mkdir -p $ADDVAR99/x86/gst
mkdir -p $ADDVAR99/x86/optel
mkdir -p $ADDVAR99/jetson/gst
mkdir -p $ADDVAR99/jetson/optel
```


## 1.2.1 Prebuilt libgstrtpmanager.so, libgstrtsp.so and libgstvideoparsersbad.so found in the NGC dockers.

These files are found in the DS 9.0 dockers found on NGC.

To include that in these local builds you will need to download these files from the DS 9.0 NGC dockers. On both Jetson and x86_64 dockers they are found in the following location.
/tmp99/libgstrtpmanager.so
/tmp99/libgstrtsp.so
/tmp99/libgstvideoparsersbad.so

The docker cp is one method to get those libraries.


This will need to be added to open the Dockerfiles if you wish to include it.

Alternatively you can use the ``/opt/nvidia/deepstream/deepstream/update_rtpmanager.sh`` script (included in the deepstream sdk) and build the library directly.

So when users run ``/opt/nvidia/deepstream/deepstream/user_additional_install.sh`` script (on the docker) libgstrtpmanager.so will be copied to the correct location.

For x86 copy x86 gst libraries into $ADDVAR99/x86/gst

For Jetson Thor copy jetson gst libraries into $ADDVAR99/jetson/gst

### 1.2.2 Packages for Open Telemetry

This may require updates to the particular packages if there are changes in location or versions. This is a helper script to download the packages for reference.

``get_optel_pkgs.sh`` is a script to help download these packages. These packages will be downloaded for both x86 and Jetson ($ADDVAR99/x86/optel and $ADDVAR99/jetson/optel).


## 1.3 Jetson Dockers (adding to the released DS 9.0 NGC Jetson dockers)

For the Jetson NGC dockers you will need to add the following lines if you are making modifications to those prebuilt NGC DS 9.0 Jetson dockers.

```
RUN apt-key adv --fetch-keys https://repo.download.nvidia.com/jetson/jetson-ota-public.asc   
RUN echo "deb https://repo.download.nvidia.com/jetson/common r38.4 main" >> /etc/apt/sources.list      
```


## 2 Building x86 DS docker images

## 2.1 x86 Docker Pre-requisites

Please refer to the Prerequisites section at DeepStream NGC page [NVIDIA NGC](https://ngc.nvidia.com/catalog/containers/nvidia:deepstream) to build and run deepstream containers.


### 2.1.1 Prerequisites; Mandatory; (DeepStreamSDK package and terminology)

1) Please download the [DeepStreamSDK release](https://developer.nvidia.com/deepstream-getting-started) x86 tarball and place it locally
in the ``$ROOT/`` folder of this repository.

``cp deepstream_sdk_v9.0.0_x86_64.tbz2 ./x86_dockerfiles/``


#### 2.1.2 CuDNN 9.17.1 install 

For x86-samples docker only

#### 2.1.2.1  x86 docker pre-requisites

Requires Docker version 29 or later.

#### 2.1.2.1.1  x86-Triton

Nothing to be added other than deepstream package.

#### 2.1.2.2 For x86 samples docker the TensorRT 10.14.1 and cuDNN 9.17.1 install is required for the Docker build

Download file link: [nv-tensorrt-local-repo-ubuntu2404-10.14.1-cuda-13.0_1.0-1_amd64.deb](https://developer.download.nvidia.com/compute/tensorrt/10.14.1/local_installers/nv-tensorrt-local-repo-ubuntu2404-10.14.1-cuda-13.0_1.0-1_amd64.deb) from TensorRT download page.
Note: You may have to login to [developer.nvidia.com](https://developer.nvidia.com/) to download the file.  
Quick Steps:  
$ROOT is the root directory of this git repo.    
``cd $ROOT/``

``cp nv-tensorrt-local-repo-ubuntu2404-10.14.1-cuda-13.0_1.0-1_amd64.deb ./x86_dockerfiles/``

Also the CuDNN file.

Download file link: [cudnn-local-repo-ubuntu2404-9.17.1_1.0-1_amd64.deb](https://developer.download.nvidia.com/compute/cudnn/9.17.1/local_installers/cudnn-local-repo-ubuntu2404-9.17.1_1.0-1_amd64.deb) from cuDNN download page.
Note: You may have to login to [developer.nvidia.com](https://developer.nvidia.com/) to download the file.
Quick Steps:
$ROOT is the root directory of this git repo.
``cd $ROOT/``

``cp cudnn-local-repo-ubuntu2404-9.17.1_1.0-1_amd64.deb ./x86_dockerfiles/``

#### 2.1.2.3 Important Notes on docker image size optimization

Hosting files on server (e.g. https://\<host server\>) is another alternative.

### 2.1.3 x86 Build setup Command

```
cd $ROOT/
./setup_x86_build.sh

```

## 2.2 Building specific x86 docker types

### 2.2.1 Instructions for Building x86 DS Triton docker image

NOTE: Make sure you run the x86 Build setup command first.

```
cd $ROOT/x86_dockerfiles
sudo docker build --network host --progress=plain --build-arg DS_DIR=/opt/nvidia/deepstream/deepstream-9.0 -t deepstream:9.0.0-triton-local -f Dockerfile_triton_x86 ..

```
NOTE: There is an example build script called $ROOT/buildx86.sh with the same contents.
  
### 2.2.2 Instructions for Building x86 DS samples docker image

NOTE: Make sure you run the x86 Build setup command first.

```
cd $ROOT/x86_dockerfiles
sudo docker build --network host --progress=plain -t deepstream:9.0.0-samples-local -f Dockerfile_samples_x86 ..

```


## 3 Building Jetson DS docker images


### 3.1 Pre-requisites

Must be built on a x86 Linux machine.

Please refer to the Prerequisites section at DeepStream NGC page [NVIDIA NGC](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/deepstream-l4t) to run deepstream containers.

Download DeepStreamSDK tarball from [DeepStreamSDK release](https://developer.nvidia.com/deepstream-getting-started) Jetson tarball and place it locally
in the ``$ROOT/`` folder of this repository.

``cp deepstream_sdk_v9.0.0_jetson.tbz2 ./jetson_dockerfiles/ ``

## 3.1.1 Jetson requires JP 7.1 to run the dockers on Jetson

More information found here [JetPack 7.1 GA](https://developer.nvidia.com/embedded/jetpack).

## 3.1.2 Jetson build setup for x86 cross compile

```
cd $ROOT/
./setup_x86_cross_compile_jetson.sh  
./setup_jetson_build.sh
 
```


## 3.2 Building specific Jetson docker types

### 3.2.1 Instructions for building Jetson DS triton docker image

NOTE: Make sure you run the Jetson setup (x86 cross-compile) and Build setup command first.

```
cd $ROOT/jetson_dockerfiles  
sudo docker build --platform linux/arm64 --network host --progress=plain -t deepstream-l4t:9.0.0-triton-local -f Dockerfile_Jetson_Devel ..

```

NOTE: There is an issue with the Jetson triton docker where for this example deepstream-infer-tensor-meta-test. The issue is related to libopencv package not being installed with libopencv-dev.  The solution is to install libopencv package directly (e.g. apt install libopencv) in addition to all of the other packages listed in the deepstream-infer-tensor-meta-test README file.


### 3.2.2 Instructions for building Jetson DS samples docker image

NOTE: Make sure you run the Jetson setup (x86 cross-compile) and Build setup command first.

```
cd $ROOT/jetson_dockerfiles  
sudo docker build --platform linux/arm64 --network host --progress=plain -t deepstream-l4t:9.0.0-samples-local -f Dockerfile_Jetson_Run ..

```
## 4 Triton Migration Guide

### 4.1 Changing triton version in DS 9.0 x86+dGPU docker image

Steps:

1. Open Triton Docker file:

```
$ROOT/x86_dockerfiles/Dockerfile_triton_x86
```

2. Edit the FROM command in Dockerfile.

Change the FROM command to use the desired Triton version.

Current: Triton 26.01
```
FROM nvcr.io/nvidia/tritonserver:26.01-py3
```

Example Migration to: Triton 26.02
```
FROM nvcr.io/nvidia/tritonserver:26.02-py3
```

3. Edit the Triton client libraries URL in Dockerfile.

Client libraries are available for download from [Triton Inference Server Releases page](https://github.com/triton-inference-server/server/releases).

Current: Triton 26.01
```
wget https://github.com/triton-inference-server/server/releases/download/v2.65.0/v2.65.0_ubuntu2404.clients.tar.gz
```

Example Migration to: Triton 26.02
```
https://github.com/triton-inference-server/server/releases/download/v2.66.0/v2.66.0_ubuntu2404.clients.tar.gz
```

3.1 You should also have to remove this symlink from the dockerfile.

 ```ln -s /usr/src/tensorrt/bin/trtexec /usr/bin/trtexec```

There are some other smalls edits that will be required to build the updated docker.


4. Build the DS x86 triton docker following instructions in section 2.2.1. [here](#221-Instructions-for-Building-x86-DS-Triton-docker-image)

### 4.2 Changing triton version in DS 9.0 Jetson docker image

No Jetson upgrade available.

### 4.3 API and ABI Compatibility Requirements

#### 4.3.1 Tritonserver lib upgrade

DeepStream 9.0 Triton Server API is based on Triton 26.01 (x86)

Regarding API compatibility, if a customer wants to upgrade triton, they need to make sure:

a) new version's `tritonserver.h` is compatible with  the:

[26.01 version of tritonserver.h for x86](https://github.com/triton-inference-server/core/blob/r26.01/include/triton/core/tritonserver.h), 

and

b) new version’s `model_config.proto` is compatible with:

[26.01 version for x86](https://github.com/triton-inference-server/common/blob/r26.01/protobuf/model_config.proto), 

To build specific Tritonserver version libs, users can follow instructions at https://github.com/triton-inference-server/server/blob/master/docs/build.md.


#### 4.3.2 DeepStream Config file Requirement

Gst-nvinferserver plugin’s config file kept backward compatibility.
Triton model/backend’s config.pbtxt file must follow rules of 26.01’s ``model_config.proto`` for x86.

### 4.4 Ubuntu Version Requirements

#### 4.4.1 Ubuntu 24.04

DeepStream 9.0 release package inherently supports Ubuntu 24.04.

Thus, the only thing to consider is API/ABI compatibility between the new Triton version and the Triton version supported by current DS release.
 
