#!/bin/bash
source variables.sh
echo $NATS_SERVER_VERSION
if [ ! -d "/usr/local/bin" ]; then
  mkdir -p /usr/local/bin
fi
# install nex prerequisites - nats go firecracker

# update image and install unzip
apt update && apt install unzip

# add a utility method for github
cat << EOF >> ~/.bashrc
alias gitpushmain="git branch -M main && git add . && git commit -am 'this' && git push -u origin main"
EOF

#download nats-server unzip and cp to /usr/local/bin
curl -L https://github.com/nats-io/nats-server/releases/download/v"${NATS_SERVER_VERSION}"/nats-server-v"${NATS_SERVER_VERSION}"-linux-amd64.zip -o nats-server.zip
unzip -o nats-server.zip -d nats-server-dir
cp nats-server-dir/nats-server-v"${NATS_SERVER_VERSION}"-linux-amd64/nats-server /usr/local/bin/
# cleanup nats-server
rm -rf nats-server.zip nats-server-dir

# download and install nats client
curl -fsSL -o nats-cli.deb https://github.com/nats-io/natscli/releases/download/v"${NATS_CLI_VERSION}"/nats-"${NATS_CLI_VERSION}"-amd64.deb 
dpkg -i nats-cli.deb
# cleanup nats client
rm nats-cli.deb

# download and install go
curl -fsSL -o go"${GOLANG_VERSION}".linux-amd64.tar.gz https://go.dev/dl/go"${GOLANG_VERSION}".linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go"${GOLANG_VERSION}".linux-amd64.tar.gz
# cleanup go
rm go"${GOLANG_VERSION}".linux-amd64.tar.gz

cat << EOF >> ~/.bashrc
export PATH=\$PATH:/usr/local/go/bin
EOF

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





