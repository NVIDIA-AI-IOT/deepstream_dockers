# DeepStream 6.4 Open Source Dockerfiles Guide

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

``cp deepstream_sdk_v6.4.0_x86_64.tbz2 x86_64/ ``

2) `image_url` is the desired docker name:TAG

3) `ds_pkg` and `ds_pkg_dir` shall be the tarball file-name with and without the
tarball extension respectively. Refer to [Section 2.1.3 x86 Build Command](#213-x86-Build-Command) for sample command.

4) `base_image` is the desired container name. Please feel free to use the sample name
provided in the command above. This name is used in the triton build steps alone.
Refer to [Section 2.1.3 x86 Build Command](#213-x86-Build-Command) for sample command.

### 2.1.2 Prerequisites; some are Optional; (TensorRT and other third-party packages)

#### 2.1.2.1  x86-Triton : Adding uff-converter-tf and graphsurgeon-tf packages 

Note: These packages (uff-converter-tf and graphsurgeon-tf) are now included by default.


#### 2.1.2.2 For x86 samples docker the TensorRT 8.6.1 and CuDNN 8.9.4 install is required for the Docker builds

Download file link: [nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb](https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/secure/8.6.1/local_repos/nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb) from TensorRT download page.
Note: You may have to login to [developer.nvidia.com](https://developer.nvidia.com/) to download the file.  
Quick Steps:  
$ROOT is the root directory of this git repo.    
``cd $ROOT/x86_64``

``cp nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb x86_64/ ``

Also the CuDNN file.

Download file link: [cudnn-local-repo-ubuntu2204-8.9.4.25_1.0-1_amd64.deb](https://developer.nvidia.com/downloads/compute/cudnn/secure/8.9.4/local_installers/12.x/cudnn-local-repo-ubuntu2204-8.9.4.25_1.0-1_amd64.deb) from TensorRT download page.
Note: You may have to login to [developer.nvidia.com](https://developer.nvidia.com/) to download the file.
Quick Steps:
$ROOT is the root directory of this git repo.
``cd $ROOT/x86_64``

``cp cudnn-local-repo-ubuntu2204-8.9.4.25_1.0-1_amd64.deb x86_64/ ``

#### 2.1.2.3 Important Notes on docker image size optimization

:warning: NOTE: Docker ADD image size workaround by using wget instead :warning:

Docker ADD method is used by default for ease to building the x86 Dockers. Docker ADD also increases the image size by approximately 2GB.

To workaround this problem you can host the nv-tensorrt-local-repo-ubuntu2204-8.6.1-cuda-12.0_1.0-1_amd64.deb a server and pull it in during the docker build using wget. This section of code is commented out by default. 

To use this wget method you can uncomment this code section of the code in the dockerfile. Then also add the complete URL to the file.

``# install TensorRT repo from a hosted file on a server``

The commented out this code section in the dockerfile that starts with this.

``# Add TensorRT repo``


### 2.1.3 x86 Build Command

```
sudo image_url=deepstream:6.4.0-triton-local \
     ds_pkg=deepstream_sdk_v6.4.0_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.4.0.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile_x86_triton triton-devel -C x86_64/
```

## 2.2 Building specific x86 docker types

### 2.2.1 Instructions for Building x86 DS Triton docker image

```
sudo image_url=deepstream:6.4.0-triton-local \
     ds_pkg=deepstream_sdk_v6.4.0_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.4.0.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile_x86_triton triton-devel -C x86_64/

There is an example build script is called $ROOT/buildx86.sh with the same contents.
```  
### 2.2.2 Instructions for Building x86 DS samples docker image

```
sudo image_url=deepstream:6.4.0-samples-local \
     ds_pkg=deepstream_sdk_v6.4.0_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.4.0.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile runtime -C x86_64/
```


## 3 Building Jetson DS docker images


### 3.1 Pre-requisites

Must be built on a Jetson device (e.g. Jetson AGX Orin 64GB ).

Please refer to the Prerequisites section at DeepStream NGC page [NVIDIA NGC](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/deepstream-l4t) to build and run deepstream containers.

Download DeepStreamSDK tarball from [DeepStreamSDK release](https://developer.nvidia.com/deepstream-getting-started) Jetson tarball and place it locally
in the ``$ROOT/jetson`` folder of this repository.

``cp deepstream_sdk_v6.4.0_jetson.tbz2 jetson/ ``

## 3.1.1 Jetson needs VPI 3.0.10 pre-requisites.

The following VPI 3.0.10 *.deb (vpi-dev-3.0.10-aarch64-l4t.deb, vpi-lib-3.0.10-aarch64-l4t.deb) files are required from [JetPack 6.0 DP](https://developer.nvidia.com/embedded/jetpack). These need to be copied into the Jetson folder so they can be used by the build.

``cp vpi-dev-3.0.10-aarch64-l4t.deb jetson/ ``  
``cp vpi-lib-3.0.10-aarch64-l4t.deb jetson/ ``

## 3.1.2 Jetson build command

```
sudo image_url=deepstream-l4t:6.4.0-triton-local \
     ds_pkg=deepstream_sdk_v6.4.0_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.4.0_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile triton -C jetson/

     There is an example build script is called $ROOT/buildjet.sh with the same contents. 
```


## 3.2 Building specific Jetson docker types

### 3.2.1 Instructions for building Jetson DS triton docker image

```
sudo image_url=deepstream-l4t:6.4.0-triton-local \
     ds_pkg=deepstream_sdk_v6.4.0_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.4.0_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile triton -C jetson/
```
### 3.2.2 Instructions for building Jetson DS samples docker image

```
sudo image_url=deepstream-l4t:6.4.0-samples-local \
     ds_pkg=deepstream_sdk_v6.4.0_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.4.0_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile runtime -C jetson/     
```
## 4 Triton Migration Guide

### 4.1 Changing triton version in DS 6.4 x86+dGPU docker image

Steps:

1. Open Triton Docker file:

```
x86_64/trtserver_base_devel/Dockerfile
```

2. Edit the FROM command in Dockerfile.

Change the FROM command to use the desired Triton version.

Current: Triton 23.08
```
FROM nvcr.io/nvidia/tritonserver:23.08-py3
```

Example Migration to: Triton 23.11
```
FROM nvcr.io/nvidia/tritonserver:23.11-py3
```

3. Edit the Triton client libraries URL in Dockerfile.

Client libraries are available for download from [Triton Inference Server Releases page](https://github.com/triton-inference-server/server/releases).

Current: Triton 23.08
```
wget https://github.com/triton-inference-server/server/releases/download/v2.37.0/v2.37.0_ubuntu2204.clients.tar.gz
```

Example Migration to: Triton 23.11
```
wget https://github.com/triton-inference-server/server/releases/download/v2.40.0/v2.40.0_ubuntu2204.clients.tar.gz
```

4. Build the DS x86 triton docker following instructions [here](#221-instructions-for-building-x86-ds-triton-docker-image).

### 4.2 Changing triton version in DS 6.4 Jetson (iGPU) docker image

Steps:

1. Open Triton Docker file:

```
jetson/ubuntu_base_devel/Dockerfile
```

2. Edit the FROM command in Dockerfile.

Change the FROM command to use the desired Triton version.

Current: Triton 23.11

```
FROM nvcr.io/nvidia/tritonserver:23.11-py3-igpu
```

**Note**: Newer version of Triton is unavailable to verify migration at the time of DS 6.4 release.

3. Edit the Triton client libraries URL in Dockerfile.

Client libraries are available for download from [Triton Inference Server Releases page](https://github.com/triton-inference-server/server/releases).

Current: Triton 23.08

```
wget https://github.com/triton-inference-server/server/releases/download/v2.40.0/tritonserver2.40.0-igpu.tar.gz
```

**Note**: Newer version of Triton is unavailable to verify migration at the time of DS 6.4 release.

4. Build the DS x86 triton docker following instructions [here](#321-instructions-for-building-jetson-ds-triton-docker-image).

### 4.3 API and ABI Compatibility Requirements

#### 4.3.1 Tritonserver lib upgrade

DeepStream 6.4 Triton Server API is based on Triton 23.08 (x86) and Triton 23.11 (Jetson) release.

Regarding API compatibility, if a customer wants to upgrade triton, they need to make sure:

a) new version's `tritonserver.h` is compatible with  the:

[23.08 version of tritonserver.h for x86](https://github.com/triton-inference-server/core/blob/r23.08/include/triton/core/tritonserver.h), 
[23.11 version of tritonserver.h for jetson](https://github.com/triton-inference-server/core/blob/r23.11/include/triton/core/tritonserver.h), 
and 

b) new version’s `model_config.proto` is compatible with:

[23.08 version for x86](https://github.com/triton-inference-server/common/blob/r23.08/protobuf/model_config.proto), 
[23.11 version for jetson](https://github.com/triton-inference-server/common/blob/r23.11/protobuf/model_config.proto), 

To build specific Tritonserver version libs, users can follow instructions at https://github.com/triton-inference-server/server/blob/master/docs/build.md.


#### 4.3.2 DeepStream Config file Requirement

Gst-nvinferserver plugin’s config file kept backward compatibility.
Triton model/backend’s config.pbtxt file must follow rules of 23.08’s ``model_config.proto`` for x86 and 23.11's ``model_config.proto`` for jetson.

### 4.4 Ubuntu Version Requirements

#### 4.4.1 Ubuntu 22.04

DeepStream 6.4 release package inherently support Ubuntu 22.04.

Thus, the only thing to consider is API/ABI compatibility between the new Triton version and the Triton version supported by current DS release.

