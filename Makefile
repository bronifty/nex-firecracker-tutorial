# Makefile

# Default target
all: cleanup make_executable init nex preflight nats build test compile run

# cleanup
cleanup:
	./scripts/cleanup.sh

# Make everything executable
make_executable:
	chmod -R +x ./scripts/

# Run the init script to install prerequisites
init:
	./scripts/shebang.sh

# Setup Nex
nex:
	cd nex-repo/nex && go build -o /usr/local/bin/nex
	which nex

# Nex Preflight Check
preflight:
	nex node preflight --config=/root/nex-firecracker-tutorial/nex-repo/examples/nodeconfigs/simple.json

# Start Nats Server
nats:
	nats-server

# Build and run EchoService
build:
	./scripts/create_main_go.sh
	go mod init echoservice
	go mod tidy
	go run .

# Test EchoService
test:
	nats req svc.echo 'this is a test'
	nats micro ls

# Static Build
compile:
	go build -tags netgo -ldflags '-extldflags "-static"'
	file echoservice

run:
	nex node up --config=/root/nex-firecracker-tutorial/nex-repo/examples/nodeconfigs/simple.json 



.PHONY: all cleanup make_executable init nex preflight nats build test compile run
