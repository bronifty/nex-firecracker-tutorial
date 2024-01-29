# Makefile

# Default target
all: make_executable init firecracker setup_nex preflight build_echo_service cleanup

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

# Build and run EchoService
build_echo_service:
	echo 'package main

	import (
		"context"
		"fmt"
		"os"
		"strings"

		"github.com/nats-io/nats.go"
		services "github.com/nats-io/nats.go/micro"
	)

	func main() {
		ctx := context.Background()

		natsUrl := os.Getenv("NATS_URL")
		if len(strings.TrimSpace(natsUrl)) == 0 {
			natsUrl = nats.DefaultURL
		}
		fmt.Printf("Echo service using NATS url '%s'\n", natsUrl)
		nc, err := nats.Connect(natsUrl)
		if err != nil {
			panic(err)
		}

		// request handler
		echoHandler := func(req services.Request) {
			req.Respond(req.Data())
		}

		fmt.Println("Starting echo service")

		_, err = services.AddService(nc, services.Config{
			Name:    "EchoService",
			Version: "1.0.0",
			// base handler
			Endpoint: &services.EndpointConfig{
				Subject: "svc.echo",
				Handler: services.HandlerFunc(echoHandler),
			},
		})

		if err != nil {
			panic(err)
		}

		<-ctx.Done()
	}' > ./main.go # Add your Go code here
	go mod init nex-firecracker
	go mod tidy
	go run .

# Test EchoService
test_echo_service:
	nats-server &
	nats req svc.echo 'this is a test'
	nats micro ls

.PHONY: all make_executable init firecracker setup_nex preflight build_echo_service test_echo_service cleanup 
