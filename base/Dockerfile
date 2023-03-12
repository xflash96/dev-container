# syntax=docker/dockerfile:1
FROM nvidia/cuda:11.7.0-devel-ubuntu18.04

# SHELL ["/bin/sh", "-ceuxo", "pipefail"]
SHELL ["/bin/bash", "-ceuxo", "pipefail"]

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1
RUN apt-get update && apt install -y \
	fonts-dejavu-core rsync git git-lfs openssh-client jq moreutils sudo vim \
	curl dumb-init htop locales man procps zsh lsb-release \
	linux-tools-common linux-tools-generic linux-cloud-tools-generic \
	&& apt-get clean

RUN apt-get install -y software-properties-common \
	&& add-apt-repository ppa:deadsnakes/ppa && apt install -y python3.10-venv
RUN ln -s /usr/bin/python3.10 /usr/bin/python

RUN python3.10 -m ensurepip --upgrade
RUN PIP_NO_CACHE_DIR=1 python3.10 -m pip install torch==1.13.1+cu117 torchvision --extra-index-url https://download.pytorch.org/whl/cu117

# setup a user: coder
RUN sed -i -e "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && locale-gen # buildkit
ENV LANG=en_US.UTF-8
RUN adduser --gecos '' --disabled-password coder && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd # buildkit

RUN ARCH="$(dpkg --print-architecture)"  \
	&& curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.5/fixuid-0.5-linux-$ARCH.tar.gz"  \
	| tar -C /usr/local/bin -xzf -   \
	&& chown root:root /usr/local/bin/fixuid  \
	&& chmod 4755 /usr/local/bin/fixuid \
	&& mkdir -p /etc/fixuid  \
	&& printf "user: coder\ngroup: coder\n" > /etc/fixuid/config.yml # buildkit

RUN PIP_NO_CACHE_DIR=1 pip3 install jupyterlab==3.6.1

RUN curl -fsSL https://code-server.dev/install.sh | sh

# the entry point will rename coder to the outside user name
COPY entrypoint.sh /usr/bin/entrypoint.sh

USER 1000
ENV USER=coder
WORKDIR /home/coder
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

COPY install_extensions.sh /home/coder/
