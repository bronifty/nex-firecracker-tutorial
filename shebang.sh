#!/bin/bash

# install nex prerequisites - nats go firecracker

# bash variables
export NATS_SERVER_VERSION="2.10.9"
export NATS_CLI_VERSION="0.1.1"
export GOLANG_VERSION="1.21.6"
export ARCH="$(uname -m)"
export KERNEL_VERSION="5.10.204"
export ROOTFS_VERSION="22.04"
export FIRECRACKER_SOCKET="/tmp/firecracker.socket"
export KERNEL_IMAGE_PATH="vmlinux-${KERNEL_VERSION}"
export ROOTFS_PATH="ubuntu-${ROOTFS_VERSION}"


# update image and install unzip
apt update && apt install unzip

#download nats-server unzip and cp to /usr/local/bin
curl -L https://github.com/nats-io/nats-server/releases/download/v"${NATS_SERVER_VERSION}"/nats-server-v"${NATS_SERVER_VERSION}"-linux-amd64.zip -o nats-server.zip
unzip -o nats-server.zip -d nats-server
sudo cp nats-server/nats-server-v"${NATS_SERVER_VERSION}"-linux-amd64/nats-server /usr/local/bin

# download and install nats client
curl -fsSL -o nats-cli.deb https://github.com/nats-io/natscli/releases/download/v"${NATS_CLI_VERSION}"/nats-"${NATS_CLI_VERSION}"-amd64.deb 
dpkg -i nats-cli.deb

# download and install go
curl -fsSL -o go"${GOLANG_VERSION}".linux-amd64.tar.gz https://go.dev/dl/go"${GOLANG_VERSION}".linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go"${GOLANG_VERSION}".linux-amd64.tar.gz

# add go to the path
cp ~/.bashrc ~/.bashrc.backup
{
echo ""
echo "export PATH=\$PATH:/usr/local/go/bin"
echo ""
} >> ~/.bashrc
source ~/.bashrc

# download and install firecracker
ARCH="$(uname -m)"
release_url="https://github.com/firecracker-microvm/firecracker/releases"
latest=$(basename $(curl -fsSLI -o /dev/null -w  %{url_effective} ${release_url}/latest))
curl -L ${release_url}/download/${latest}/firecracker-${latest}-${ARCH}.tgz \
| tar -xz
mv release-${latest}-$(uname -m)/firecracker-${latest}-${ARCH} firecracker
mv firecracker /usr/local/bin

# download and install kernel and rootfs
# Download a linux kernel binary
curl -fsSL -o vmlinux-"${KERNEL_VERSION}" https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.7/${ARCH}/vmlinux-"${KERNEL_VERSION}" 

# Download a rootfs
curl -fsSL -o ubuntu-"${ROOTFS_VERSION}".ext4 https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.7/${ARCH}/ubuntu-"${ROOTFS_VERSION}".ext4

# Download the ssh key for the rootfs
curl -fsSL -o ubuntu-"${ROOTFS_VERSION}".id_rsa https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.7/${ARCH}/ubuntu-"${ROOTFS_VERSION}".id_rsa

# Set user read permission on the ssh key
chmod 400 ./ubuntu-"${ROOTFS_VERSION}".id_rsa

# clone firecracker repo
git clone https://github.com/firecracker-microvm/firecracker.git firecracker-repo

# clone nex repo
git clone https://github.com/synadia-io/nex.git nex-repo

# do some etl to convert interpolated values of bash variables in the config files
envsubst < input.json > output.json
