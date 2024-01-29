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

### NEX Node Up
```bash
make nex_node_up
```



