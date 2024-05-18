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

top=$(abspath $(lastword $(MAKEFILE_LIST))/../..)
$(info $(top))
include $(top)/common/version
ifdef NO_CACHE
no_cache =
else
no_cache = --no-cache
endif

ubuntu_base = ubuntu_base_runtime ubuntu_base_devel trtserver_base_runtime trtserver_base_devel ds_base_custom

.PHONY : $(img_type)
.PHONY : $(ubuntu_base)

all: $(img_type)

$(img_type) $(ubuntu_base): image_url ?= $(registry)/$(prefix)-$@:$(image_tag)
$(img_type) $(ubuntu_base): dockerfile ?= $@/Dockerfile

$(img_type) : container_name?=ds_build_$@
$(ubuntu_base): no_cache =

$(ubuntu_base):
	$(DOCKER) build --rm $(bin_misc) \
		$(no_cache) \
		$(platform_build_arg) \
		-t $(base_image) -f $(dockerfile) .

$(img_type):
	# Stop and remove container if already exists
	$(DOCKER) stop $(container_name) || true
	$(DOCKER) rm $(container_name) || true

	$(DOCKER) run -itd --rm \
		 -e DS_REL_PKG=$(ds_pkg) \
		 -e DS_REL_PKG_DIR=$(ds_pkg_dir) \
		 -e DS_VERSION=$(version) \
		 -e TAG=$(tag) \
		 -e PLATFORM=$(platform) \
		 -v $(top)/common/install_$@.sh:/root/tmp/install_$@.sh:ro \
		 -v $(top)/common/post_install_script.sh:/root/tmp/post_install_script.sh:ro \
		 -v $(top)/common/files/LicenseAgreementContainer.pdf:/root/tmp/LicenseAgreementContainer.pdf:ro \
		 -v $(top):/root/top/:ro \
		 $(platform_run_arg) \
		 $(target_opts) \
		 --name $(container_name) \
		 $(base_image)
	$(DOCKER) exec $(container_name) /root/tmp/install_$@.sh
	$(DOCKER) exec $(container_name) /root/tmp/post_install_script.sh
	$(DOCKER) commit $(commit_opts) $(container_name) $(image_url)
	$(DOCKER) stop $(container_name) || true
	$(DOCKER) rm $(container_name) || true

	# Remove /root/tmp directory
	$(DOCKER) build --rm $(bin_misc) \
		-t $(image_url) -f $(top)/common/Dockerfile.cleanup \
		--build-arg IMAGE=$(image_url) \
		.
	@echo "Success."
ifdef PUSH
	@echo "Pushing image $(image_url)"
	$(DOCKER) push $(image_url)
endif
