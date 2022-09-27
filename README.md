# DeepStream 6.1.1 Open Source Dockerfiles Guide

The documentation here is intended to help customers build the Open Source DeepStream Dockerfiles.
This information is useful for both x86 systems with dGPU setup and on NVIDIA Jetson devices.

## 1 Additional Installations to use all DeepStreamSDK Features within the docker container.

With DS 6.1.1, DeepStream docker containers do not package libraries necessary for certain multimedia operations like audio data parsing, CPU decode, and CPU encode. This change could affect processing certain video streams/files like mp4 that include audio tracks.

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

``cp deepstream_sdk_v6.1.1_x86_64.tbz2 x86_64/ ``

2) `image_url` is the desired docker name:TAG

3) `ds_pkg` and `ds_pkg_dir` shall be the tarball file-name with and without the
tarball extension respectively. Refer to [Section 2.1.3 x86 Build Command](#213-x86-Build-Command) for sample command.

4) `base_image` is the desired container name. Please feel free to use the sample name
provided in the command above. This name is used in the triton build steps alone.
Refer to [Section 2.1.3 x86 Build Command](#213-x86-Build-Command) for sample command.

### 2.1.2 Prerequisites; some are Optional; (TensorRT and other third-party packages)

#### 2.1.2.1  x86-Triton : Adding uff-converter-tf and graphsurgeon-tf packages 

Note: This is an optional step to install uff-converter-tf and graphsurgeon-tf packages.

Download file link: [nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb](https://developer.nvidia.com/compute/machine-learning/tensorrt/secure/8.4.1/local_repos/nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb) from TensorRT download page.
Note: You may have to login to [developer.nvidia.com](https://developer.nvidia.com/) to download the file.  
Quick Steps:  
$ROOT is the root directory of this git repo.    
``cd $ROOT``  
``mkdir tmp``  
``dpkg-deb -R nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb tmp``  
``cp tmp/var/nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604/uff-converter-tf_8.4.1-1+cuda11.6_amd64.deb x86_64/``  
``cp tmp/var/nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604/graphsurgeon-tf_8.4.1-1+cuda11.6_amd64.deb x86_64/``  

Note: Please uncomment corresponding installation commands in ``x86_64/trtserver_base_devel/Dockerfile`` to install these optional packages inside the container.

#### 2.1.2.2 For x86 devel, base, samples and iot Dockers the TensorRT 8.4.1.5 install is required for the Docker builds

Download file link: [nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb](https://developer.nvidia.com/compute/machine-learning/tensorrt/secure/8.4.1/local_repos/nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb) from TensorRT download page.
Note: You may have to login to [developer.nvidia.com](https://developer.nvidia.com/) to download the file.  
Quick Steps:  
$ROOT is the root directory of this git repo.    
``cd $ROOT/x86_64``

``cp nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb x86_64/ ``

#### 2.1.2.3 Important Notes on docker image size optimization

:warning: NOTE: Docker ADD image size workaround by using wget instead :warning:

Docker ADD method is used by default for ease to building the x86 Dockers. Docker ADD also increases the image size by approximately 2GB.

To workaround this problem you can host the nv-tensorrt-repo-ubuntu2004-cuda11.6-trt8.4.1.5-ga-20220604_1-1_amd64.deb on a server and pull it in during the docker build using wget. This section of code is commented out by default. 

To use this wget method you can uncomment this code section of the code in the dockerfile. Then also add the complete URL to the file.

``\# install TensorRT repo from a hosted file on a server``

The comment out this code section in the dockerfile that starts with this.

``\# Add TensorRT repo``

#### 2.1.2.4 x86 devel docker has some components excluded.

The following are excluded from the x86 devel docker file: graph composer, Mellanox OFED, and UCX plugins.

### 2.1.3 x86 Build Command

```
sudo image_url=deepstream:6.1.1-devel-local \
     ds_pkg=deepstream_sdk_v6.1.1_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile devel -C x86_64/
```

## 2.2 Building specific x86 docker types

### 2.2.1 Instructions for Building x86 DS Triton docker image

```
sudo image_url=deepstream:6.1.1-triton-local \
     ds_pkg=deepstream_sdk_v6.1.1_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile_x86_triton triton-devel -C x86_64/

There is an example build script is called $ROOT/buildx86.sh with the same contents.
```  
### 2.2.2 Instructions for Building x86 DS devel docker image

```
sudo image_url=deepstream:6.1.1-devel-local \
     ds_pkg=deepstream_sdk_v6.1.1_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile devel -C x86_64/
```

### 2.2.3 Instructions for building x86 DS base docker image

```
sudo image_url=deepstream:6.1.1-base-local \
     ds_pkg=deepstream_sdk_v6.1.1_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile base -C x86_64/
```

### 2.2.4 Instructions for building x86 DS samples docker image

```
sudo image_url=deepstream:6.1.1-samples-local \
     ds_pkg=deepstream_sdk_v6.1.1_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile runtime -C x86_64/
```

### 2.2.5 Instructions for building x86 DS iot docker image

```
sudo image_url=deepstream:6.1.1-iot-local \
     ds_pkg=deepstream_sdk_v6.1.1_x86_64.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1.0_x86_64/ \
     base_image=dgpu-any-custom-base-image make -f Makefile test5 -C x86_64/
```

## 3 Building Jetson DS docker images

### 3.1 Pre-requisites

Must be built on a Jetson device (e.g. Orin).

Please refer to the Prerequisites section at DeepStream NGC page [NVIDIA NGC](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/deepstream-l4t) to build and run deepstream containers.

Download DeepStreamSDK tarball from [DeepStreamSDK release](https://developer.nvidia.com/deepstream-getting-started) Jetson tarball and place it locally
in the ``$ROOT/jetson`` folder of this repository.

``cp deepstream_sdk_v6.1.1_jetson.tbz2 jetson/ ``


## 3.1.1 Jetson build command

```
sudo image_url=deepstream-l4t:6.1.1-triton-local \
     ds_pkg=deepstream_sdk_v6.1.1_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile triton -C jetson/

     There is an example build script is called $ROOT/buildjet.sh with the same contents. 
```

## 3.2 Building specific Jetson docker types

### 3.2.1 Instructions for building Jetson DS triton docker image

```
sudo image_url=deepstream-l4t:6.1.1-triton-local \
     ds_pkg=deepstream_sdk_v6.1.1_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile triton -C jetson/
```
### 3.2.2 Instructions for building Jetson DS base docker image

```
sudo image_url=deepstream-l4t:6.1.1-base-local \
     ds_pkg=deepstream_sdk_v6.1.1_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile base -C jetson/
```

### 3.2.3 Instructions for building Jetson DS samples docker image

```
sudo image_url=deepstream-l4t:6.1.1-samples-local \
     ds_pkg=deepstream_sdk_v6.1.1_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile runtime -C jetson/     
```
### 3.2.4 Instructions for building Jetson DS iot docker image

```
sudo image_url=deepstream-l4t:6.1.1-iot-local \
     ds_pkg=deepstream_sdk_v6.1.1_jetson.tbz2 \
     ds_pkg_dir=deepstream_sdk_v6.1.1_jetson \
     base_image=jetson-any-custom-base-image make -f Makefile test5 -C jetson/ 
```