#!/bin/bash

# パッケージアップデート
apt-get update -y

# NVIDIAドライバーのインストール
apt install ubuntu-drivers-common -y
ubuntu-drivers autoinstall -y

Docker CE のインストール
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update -y
apt-get install docker-ce -y

# ユーザーをDockerグループに追加
sudo usermod -aG docker $USER

# docker-composeのインストール
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# NVIDIA Docker のインストール
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get update

apt-get install -y nvidia-docker2
pkill -SIGHUP dockerd

# Dockerコンテナの作成
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi

docker-compose build

docker-compose run --rm app bash
