# DeepStream 7.0 Open Source Dockerfiles Guide

The documentation here is intended to help customers build the Open Source DeepStream Dockerfiles.
This information is useful for both x86 systems with dGPU setup and on NVIDIA Jetson devices.

## 1 Additional Installations to use all DeepStreamSDK Features within the docker container.

Since DS 6.3, deepStream docker containers do not package libraries necessary for certain multimedia operations like audio data parsing, CPU decode, and CPU encode. This change could affect processing certain video streams/files like mp4 that include audio tracks.

Please run the below script inside the docker images to install additional packages that might be necessary to use all of the DeepStreamSDK features :

```
/opt/nvidia/deepstream/deepstream/user_additional_install.sh
```

## 2 Building x86 DS docker images

## 2.1 x86 Docker Pre-requisites

Please refer to the Prerequisites section at DeepStream NGC page [NVIDIA NGC](https://ngc.nvidia.com/catalog/containers/nvidia:deepstream) to build and run deepstream containers.


### 2.1.1 Prerequisites; Mandatory; (DeepStreamSDK package and terminology)

1) Please download the [DeepStreamSDK release](https://developer.nvidia.com/deepstream-getting-started) x86 tarball and place it locally
in the ``$ROOT/x86_64`` folder of this repository.

``cp deepstream_sdk_v7.0.0_x86_64.tbz2 x86_64/ ``

2) `image_url` is the desired docker name:TAG

3) `ds_pkg` and `ds_pkg_dir` shall be the tarball file-name with and without the
tarball extension respectively. Refer to [Section 2.2 Building specific x86 docker types](#22-building-specific-x86-docker-types) for sample command.

4) `base_image` is the desired container name. Please feel free to use the sample name
provided in the command above. This name is used in the triton build steps alone.
Refer to [Section 2.2 Building specific x86 docker types](#22-building-specific-x86-docker-types) for sample command.

#### 2.1.2 CuDNN 8.9.6 install (x86-Triton and x86-samples dockers)

Mandatory for for x86-Triton and x86-samples docker builds.

Download file link: [cudnn-local-repo-ubuntu2204-8.9.6.50_1.0-1_amd64.deb](https://developer.nvidia.com/downloads/compute/cudnn/secure/8.9.6/local_installers/12.x/cudnn-local-repo-ubuntu2204-8.9.6.50_1.0-1_amd64.deb) from TensorRT download page.
Note: You may have to login to [developer.nvidia.com](https://developer.nvidia.com/) to download the file.
Quick Steps:
$ROOT is the root directory of this git repo.
``cd $ROOT/x86_64``

``cp cudnn-local-repo-ubuntu2204-8.9.6.50_1.0-1_amd64.deb x86_64/ ``


#### 2.1.3 TensorRT 8.6.1 install (x86-samples docker)

Mandatory for for x86-samples docker build.

Download file link: [nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb](https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/secure/8.6.1/local_repos/nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb) from TensorRT download page.
Note: You may have to login to [developer.nvidia.com](https://developer.nvidia.com/) to download the file.  
Quick Steps:  
$ROOT is the root directory of this git repo.    
``cd $ROOT/x86_64``

``cp nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb x86_64/ ``

#### 2.1.4 Important Notes on docker image size optimization

:warning: NOTE: Docker ADD image size workaround by using wget instead :warning:

Docker ADD method is used by default for ease to building the x86 Dockers. Docker ADD also increases the image size by approximately 2GB.

To workaround this problem you can host the nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb file in a local server. Then with a single `RUN` command in Dockerfile, pull it using wget, install, and remove the file from filesystem.

## 2.2 Building specific x86 docker types

### 2.2.1 Instructions for Building x86 DS Triton docker image

```
sudo image_url=deepstream:7.0.0-triton-local \
     ds_pkg=deepstream_sdk_v7.0.0_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v7.0.0.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile_x86_triton triton-devel -C x86_64/

There is an example build script is called $ROOT/buildx86.sh with the same contents.
```  
### 2.2.2 Instructions for Building x86 DS samples docker image

```
sudo image_url=deepstream:7.0.0-samples-local \
     ds_pkg=deepstream_sdk_v7.0.0_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v7.0.0.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile runtime -C x86_64/
```


## 3 Building Jetson DS docker images


### 3.1 Pre-requisites

Must be built on a Jetson device (e.g. Jetson AGX Orin 64GB ).

Please refer to the Prerequisites section at DeepStream NGC page [NVIDIA NGC](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/deepstream-l4t) to build and run deepstream containers.

Download DeepStreamSDK tarball from [DeepStreamSDK release](https://developer.nvidia.com/deepstream-getting-started) Jetson tarball and place it locally
in the ``$ROOT/jetson`` folder of this repository.

``cp deepstream_sdk_v7.0.0_jetson.tbz2 jetson/ ``

## 3.1.1 Jetson needs VPI 3.1.5 pre-requisites.

The following VPI 3.1.5 *.deb (vpi-dev-3.1.5-aarch64-l4t.deb, vpi-lib-3.1.5-aarch64-l4t.deb) files are required from [JetPack 6.0 GA](https://developer.nvidia.com/embedded/jetpack). These need to be copied into the Jetson folder so they can be used by the build.

``cp vpi-dev-3.1.5-aarch64-l4t.deb jetson/ ``  
``cp vpi-lib-3.1.5-aarch64-l4t.deb jetson/ ``

## 3.1.2 Jetson build command

```
sudo image_url=deepstream-l4t:7.0.0-triton-local \
     ds_pkg=deepstream_sdk_v7.0.0_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v7.0.0_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile triton -C jetson/

     There is an example build script is called $ROOT/buildjet.sh with the same contents. 
```


## 3.2 Building specific Jetson docker types

### 3.2.1 Instructions for building Jetson DS triton docker image

```
sudo image_url=deepstream-l4t:7.0.0-triton-local \
     ds_pkg=deepstream_sdk_v7.0.0_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v7.0.0_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile triton -C jetson/
```
### 3.2.2 Instructions for building Jetson DS samples docker image

```
sudo image_url=deepstream-l4t:7.0.0-samples-local \
     ds_pkg=deepstream_sdk_v7.0.0_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v7.0.0_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile runtime -C jetson/     
```
## 4 Triton Migration Guide

### 4.1 Changing triton version in DS 7.0 x86+dGPU docker image

Steps:

1. Open Triton Docker file:

```
x86_64/trtserver_base_devel/Dockerfile
```

2. Edit the FROM command in Dockerfile.

Change the FROM command to use the desired Triton version.

Current: Triton 23.10
```
FROM nvcr.io/nvidia/tritonserver:23.10-py3
```

Example Migration to: Triton 24.04
```
FROM nvcr.io/nvidia/tritonserver:24.04-py3
```

3. Edit the Triton client libraries URL in Dockerfile.

Client libraries are available for download from [Triton Inference Server Releases page](https://github.com/triton-inference-server/server/releases).

Current: Triton 23.10
```
wget https://github.com/triton-inference-server/server/releases/download/v2.39.0/v2.39.0_ubuntu2204.clients.tar.gz
```

Example Migration to: Triton 24.04
```
wget https://github.com/triton-inference-server/server/releases/download/v2.45.0/v2.45.0_ubuntu2204.clients.tar.gz
```

4. Build the DS x86 triton docker following instructions [here](#221-instructions-for-building-x86-ds-triton-docker-image).

### 4.2 Changing triton version in DS 7.0 Jetson (iGPU) docker image

Steps:

1. Open Triton Docker file:

```
jetson/ubuntu_base_devel/Dockerfile
```

2. Edit the FROM command in Dockerfile.

Change the FROM command to use the desired Triton version.

Current: Triton 24.03

```
FROM nvcr.io/nvidia/tritonserver:24.03-py3-igpu
```

Example Migration to: Triton 24.04
```
FROM nvcr.io/nvidia/tritonserver:24.04-py3-igpu
```

3. Edit the Triton client libraries URL in Dockerfile.

Client libraries are available for download from [Triton Inference Server Releases page](https://github.com/triton-inference-server/server/releases).

Current: Triton 24.03

```
wget https://github.com/triton-inference-server/server/releases/download/v2.44.0/tritonserver2.44.0-igpu.tgz
```

Example Migration to: Triton 24.04
```
wget https://github.com/triton-inference-server/server/releases/download/v2.45.0/tritonserver2.45.0-igpu.tgz
```

4. Build the DS x86 triton docker following instructions [here](#321-instructions-for-building-jetson-ds-triton-docker-image).

### 4.3 API and ABI Compatibility Requirements

#### 4.3.1 Tritonserver lib upgrade

DeepStream 7.0 Triton Server API is based on Triton 23.10 (x86) and Triton 24.03 (Jetson) release.

Regarding API compatibility, if a customer wants to upgrade triton, they need to make sure:

a) new version's `tritonserver.h` is compatible with  the:

[23.10 version of tritonserver.h for x86](https://github.com/triton-inference-server/core/blob/r23.10/include/triton/core/tritonserver.h), 
[24.03 version of tritonserver.h for jetson](https://github.com/triton-inference-server/core/blob/r24.03/include/triton/core/tritonserver.h), 
and 

b) new version’s `model_config.proto` is compatible with:

[23.10 version for x86](https://github.com/triton-inference-server/common/blob/r23.10/protobuf/model_config.proto), 
[24.03 version for jetson](https://github.com/triton-inference-server/common/blob/r24.03/protobuf/model_config.proto), 

To build specific Tritonserver version libs, users can follow instructions at https://github.com/triton-inference-server/server/blob/master/docs/build.md.


#### 4.3.2 DeepStream Config file Requirement

Gst-nvinferserver plugin’s config file kept backward compatibility.
Triton model/backend’s config.pbtxt file must follow rules of 23.10’s ``model_config.proto`` for x86 and 24.03's ``model_config.proto`` for jetson.

### 4.4 Ubuntu Version Requirements

#### 4.4.1 Ubuntu 22.04

DeepStream 7.0 release package inherently support Ubuntu 22.04.

Thus, the only thing to consider is API/ABI compatibility between the new Triton version and the Triton version supported by current DS release.

