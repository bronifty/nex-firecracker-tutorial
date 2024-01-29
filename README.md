# nex-firecracker-tutorial

### Install Make & Cleanup 
- if you need to rerun any of the steps below, the make cleanup command will give you a clean slate
```bash
apt install make
make cleanup
```

### Initial Setup with Makefile
- this will put you inside a firecracker vm terminal session
	- 'reboot' command to exit
```bash
make make_executable init firecracker
```

### Setup NEX and Preflight
- should result in dependency satisfied with green or ask you to download deps
```bash
make setup_nex preflight
```

### Startup NATS Server
```bash
make nats_server
```

### Build EchoService
- in a new terminal
```bash
make build_echo_service
```

### Test EchoService
- in a new terminal
```bash
make test_echo_service
```

### Static Compile
- let's compile this echoservice
```bash
make static_compile
```






- Trying to get NEX node running in the firecracker vm. It doesn't look like the firecracker vm has network access. Troubleshooting that. 

```bash
# make everything executable
chmod -R +x .

# run the init script to install prereqs
./shebang.sh

# run the firecracker script to start the instance with a config file
./firecracker.sh

```

- here are the firecracker networking docs
[https://github.com/firecracker-microvm/firecracker/blob/main/docs/network-setup.md](https://github.com/firecracker-microvm/firecracker/blob/main/docs/network-setup.md)


# Nex Setup

```bash

cd nex-repo/nex && go build .
cp nex /usr/local/bin/
which nex
cd ../..
```

### Nex Preflight Check
```bash

cat << EOF > ./simple.json
{
    "kernel_file": "./vmlinux-5.10.204",
    "rootfs_file": "./ubuntu-22.04.ext4",
    "machine_pool_size": 1,
    "cni": {
        "network_name": "fcnet",
        "interface_name": "veth0"
    },
    "machine_template": {
        "vcpu_count": 1,
        "memsize_mib": 256
    },
    "tags": {
        "simple": "true"
    }
}
EOF

nex node preflight --config=./simple.json
```

### Build an EchoService

```bash
nats-server

```


```bash

cat << EOF > ./main.go
package main

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
}
EOF
go mod init nex-firecracker
go mod tidy
go run .

```

```bash

nats req svc.echo 'this is a test'
nats micro ls

```