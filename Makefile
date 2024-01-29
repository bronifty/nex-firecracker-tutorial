# Makefile

# Default target
all: make_executable init firecracker setup_nex preflight build_echo_service cleanup nats_server

# cleanup
cleanup:
	./cleanup.sh

# Make everything executable
make_executable:
	chmod -R +x .

# Run the init script to install prerequisites
init:
	./shebang.sh

# Run the firecracker script to start the instance with a config file
firecracker:
	./firecracker.sh

# Setup Nex
setup_nex:
	cd nex-repo/nex && go build -o /usr/local/bin/nex
	which nex

# Nex Preflight Check
preflight:
	echo '{"kernel_file": "./vmlinux-5.10.204", "rootfs_file": "./ubuntu-22.04.ext4", "machine_pool_size": 1, "cni": {"network_name": "fcnet", "interface_name": "veth0"}, "machine_template": {"vcpu_count": 1, "memsize_mib": 256}, "tags": {"simple": "true"}}' > ./simple.json
	nex node preflight --config=./simple.json

# Start Nats Server
nats_server:
	nats-server

# Build and run EchoService
build_echo_service:
	./create_main_go.sh
	go mod init nex-firecracker
	go mod tidy
	go run .

# Test EchoService
test_echo_service:
	nats-server &
	nats req svc.echo 'this is a test'
	nats micro ls

.PHONY: all make_executable init firecracker setup_nex preflight build_echo_service test_echo_service cleanup 
