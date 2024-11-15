# DeepStream 7.1 Open Source Dockerfiles Guide

The documentation here is intended to help customers build the Open Source DeepStream Dockerfiles.

This information is useful for both x86 systems with dGPU setup and NVIDIA Jetson devices.

Improvements from previous releases.   
(A) Building Jetson dockers on x86 Linux PCs (cross-compile on x86)  
(B) Consolidation of Dockerfiles into a single docker directory  
(C) Build setup files to put all of the files in correct location for the various build x86 and x86 crosss-compile (for Jetson).  


## 1 Additional Installation to use all DeepStreamSDK Features within the docker container.

Since DS 6.3, deepStream docker containers do not package libraries necessary for certain multimedia operations like audio data parsing, CPU decode, and CPU encode. This change could affect processing certain video streams/files like mp4 that include audio tracks.

Please run the below script inside the docker images to install additional packages that might be necessary to use all of the DeepStreamSDK features :

```
/opt/nvidia/deepstream/deepstream/user_additional_install.sh
```

## 1.1 Triton samples additional libraries required.

For Triton samples, while running /opt/nvidia/deepstream/deepstream-7.1/samples/prepare_classification_test_video.sh, FFMPEG package along with additional dependent libs need to be installed using command below. For additional information please refer to section 1.4 (for codecs: DIFFERENCES WITH  DEEPSTREAM 6.1 AND ABOVE) & section 1.5  for BREAKING CHANGES in Release notes.


```
apt-get install --reinstall libflac8 libmp3lame0 libxvidcore4 ffmpeg
```


## 1.2 Prebuilt libgstrtpmanager.so found in the NGC dockers.

The file is found in the DS 7.1 dockers found on NGC.

To include that in these local builds you will need to download it from the DS 7.1 NGC dockers. On both Jetson and x86_64 dockers it is found in the following location.
/tmp99/libgstrtpmanager.so.

This will need to be added to open the Dockerfiles if you wish to include it.

Alternatively you can use the ``/opt/nvidia/deepstream/deepstream/update_rtpmanager.sh`` script (included in the deepstream sdk) and build the library directly.

So when users run ``/opt/nvidia/deepstream/deepstream/user_additional_install.sh`` script (on the docker) libgstrtpmanager.so will be copied to the correct location.

## 1.3 Jetson Dockers (adding to the released DS 7.1 NGC Jetson dockers)

For the Jetson NGC dockers you will need to add the following lines if you are making modifications to those prebuilt NGC DS 7.1 Jetson dockers.

```
RUN apt-key adv --fetch-keys https://repo.download.nvidia.com/jetson/jetson-ota-public.asc   
RUN echo "deb https://repo.download.nvidia.com/jetson/common r36.4 main" >> /etc/apt/sources.list      
```


## 2 Building x86 DS docker images

## 2.1 x86 Docker Pre-requisites

Please refer to the Prerequisites section at DeepStream NGC page [NVIDIA NGC](https://ngc.nvidia.com/catalog/containers/nvidia:deepstream) to build and run deepstream containers.


### 2.1.1 Prerequisites; Mandatory; (DeepStreamSDK package and terminology)

1) Please download the [DeepStreamSDK release](https://developer.nvidia.com/deepstream-getting-started) x86 tarball and place it locally
in the ``$ROOT/`` folder of this repository.

``cp deepstream_sdk_v7.1.0_x86_64.tbz2 ./docker/``


#### 2.1.2 CuDNN 9.3.0 install 

For x86-samples docker only

#### 2.1.2.1  x86 docker pre-requisites

Requires Docker version 26 or later.

#### 2.1.2.1.1  x86-Triton

Nothing to be added other than deepstream package.

#### 2.1.2.2 For x86 samples docker the TensorRT 10.3.0 and cuDNN 9.3.0 install is required for the Docker build

Download file link: [nv-tensorrt-local-repo-ubuntu2204-10.3.0-cuda-12.5_1.0-1_amd64.deb](https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/10.3.0/local_repo/nv-tensorrt-local-repo-ubuntu2204-10.3.0-cuda-12.5_1.0-1_amd64.deb) from TensorRT download page.
Note: You may have to login to [developer.nvidia.com](https://developer.nvidia.com/) to download the file.  
Quick Steps:  
$ROOT is the root directory of this git repo.    
``cd $ROOT/``

``cp  nv-tensorrt-local-repo-ubuntu2204-10.3.0-cuda-12.5_1.0-1_amd64.deb ./docker/``

Also the CuDNN file.

Download file link: [cudnn-local-repo-ubuntu2204-9.3.0_1.0-1_amd64.deb](https://developer.download.nvidia.com/compute/cudnn/9.3.0/local_installers/cudnn-local-repo-ubuntu2204-9.3.0_1.0-1_amd64.deb) from cuDNN download page.
Note: You may have to login to [developer.nvidia.com](https://developer.nvidia.com/) to download the file.
Quick Steps:
$ROOT is the root directory of this git repo.
``cd $ROOT/``

``cp cudnn-local-repo-ubuntu2204-9.3.0_1.0-1_amd64.deb ./docker/``

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
cd $ROOT/docker
sudo docker build --network host --progress=plain --build-arg DS_DIR=/opt/nvidia/deepstream/deepstream-7.1 -t deepstream:7.1.0-triton-local -f Dockerfile_triton_x86 ..

```
NOTE: There is an example build script called $ROOT/buildx86.sh with the same contents.
  
### 2.2.2 Instructions for Building x86 DS samples docker image

NOTE: Make sure you run the x86 Build setup command first.

```
cd $ROOT/docker
sudo docker build --network host --progress=plain -t deepstream:7.1.0-samples-local -f Dockerfile ..

```


## 3 Building Jetson DS docker images


### 3.1 Pre-requisites

Must be built on a x86 Linux machine.

Please refer to the Prerequisites section at DeepStream NGC page [NVIDIA NGC](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/deepstream-l4t) to run deepstream containers.

Download DeepStreamSDK tarball from [DeepStreamSDK release](https://developer.nvidia.com/deepstream-getting-started) Jetson tarball and place it locally
in the ``$ROOT/`` folder of this repository.

``cp deepstream_sdk_v7.1.0_jetson.tbz2 ./docker/ ``

## 3.1.1 Jetson requires JP 6.1 to run the dockers on Jetson

More information found here [JetPack 6.1 GA](https://developer.nvidia.com/embedded/jetpack-sdk-61).

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
cd $ROOT/docker  
sudo docker build --platform linux/arm64 --network host --progress=plain -t deepstream-l4t:7.1.0-triton-local -f Dockerfile_Jetson_Devel ..

```
### 3.2.2 Instructions for building Jetson DS samples docker image

NOTE: Make sure you run the Jetson setup (x86 cross-compile) and Build setup command first.

```
cd $ROOT/docker   
sudo docker build --platform linux/arm64 --network host --progress=plain -t deepstream-l4t:7.1.0-samples-local -f Dockerfile_Jetson_Run ..

```
## 4 Triton Migration Guide

### 4.1 Changing triton version in DS 7.1 x86+dGPU docker image

Steps:

1. Open Triton Docker file:

```
docker/Dockerfile_triton_x86
```

2. Edit the FROM command in Dockerfile.

Change the FROM command to use the desired Triton version.

Current: Triton 24.08
```
FROM nvcr.io/nvidia/tritonserver:24.08-py3
```

Example Migration to: Triton 24.09
```
FROM nvcr.io/nvidia/tritonserver:24.09-py3
```

3. Edit the Triton client libraries URL in Dockerfile.

Client libraries are available for download from [Triton Inference Server Releases page](https://github.com/triton-inference-server/server/releases).

Current: Triton 24.08
```
wget https://github.com/triton-inference-server/server/releases/download/v2.49.0/v2.49.0_ubuntu2204.clients.tar.gz
```

Example Migration to: Triton 24.09
```
wget https://github.com/triton-inference-server/server/releases/download/v2.50.0/v2.50.0_ubuntu2204.clients.tar.gz
```

4. Build the DS x86 triton docker following instructions in section 2.2.1. [here](#221-Instructions-for-Building-x86-DS-Triton-docker-image)

### 4.2 Changing triton version in DS 7.1 Jetson (iGPU) docker image

Steps:

1. Open Triton Docker file:

```
docker/Dockerfile_Jetson_Devel
```

2. Edit the FROM command in Dockerfile.

Change the FROM command to use the desired Triton version.

Current: Triton 24.08

```
FROM nvcr.io/nvidia/tritonserver:24.08-py3-igpu
```

Example Migration to: Triton 24.09
```
FROM nvcr.io/nvidia/tritonserver:24.09-py3-igpu
```

3. Edit the Triton client libraries URL in Dockerfile.

Client libraries are available for download from [Triton Inference Server Releases page](https://github.com/triton-inference-server/server/releases).

Current: Triton 24.08

```
wget https://github.com/triton-inference-server/server/releases/download/v2.49.0/tritonserver2.49.0-igpu.tar.gz
```

Example Migration to: Triton 24.09
```
wget https://github.com/triton-inference-server/server/releases/download/v2.50.0/tritonserver-2.50.0-igpu.tar.gz
```

4. Build the Jetson triton docker (x86-cross compile) following instructions [here](#321-instructions-for-building-jetson-ds-triton-docker-image).

### 4.3 API and ABI Compatibility Requirements

#### 4.3.1 Tritonserver lib upgrade

DeepStream 7.1 Triton Server API is based on Triton 24.08 (x86) and Triton 24.08 (Jetson) release.

Regarding API compatibility, if a customer wants to upgrade triton, they need to make sure:

a) new version's `tritonserver.h` is compatible with  the:

[24.08 version of tritonserver.h for x86](https://github.com/triton-inference-server/core/blob/r24.08/include/triton/core/tritonserver.h), 
[24.08 version of tritonserver.h for jetson](https://github.com/triton-inference-server/core/blob/r24.08/include/triton/core/tritonserver.h), 

and

b) new version’s `model_config.proto` is compatible with:

[24.08 version for x86](https://github.com/triton-inference-server/common/blob/r24.08/protobuf/model_config.proto), 
[24.08 version for jetson](https://github.com/triton-inference-server/common/blob/r24.08/protobuf/model_config.proto), 

To build specific Tritonserver version libs, users can follow instructions at https://github.com/triton-inference-server/server/blob/master/docs/build.md.


#### 4.3.2 DeepStream Config file Requirement

Gst-nvinferserver plugin’s config file kept backward compatibility.
Triton model/backend’s config.pbtxt file must follow rules of 24.08’s ``model_config.proto`` for x86 and 24.08's ``model_config.proto`` for jetson.

### 4.4 Ubuntu Version Requirements

#### 4.4.1 Ubuntu 22.04

DeepStream 7.1 release package inherently supports Ubuntu 22.04.

Thus, the only thing to consider is API/ABI compatibility between the new Triton version and the Triton version supported by current DS release.

