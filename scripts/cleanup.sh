#!/bin/bash
source variables.sh

rm -rf ubuntu* vmlinux* release* firecracker-repo nex-repo firecracker-config* simple.json go.* *.go nex-firecracker echoservice

rm -rf $(dirname $(which firecracker))
rm -rf $(dirname $(which nats-server))
rm -rf $(dirname $(which nats))
rm -rf $(dirname $(which go))
rm -rf $(dirname $(which nex))


rm -rf $FIRECRACKER_SOCKET

