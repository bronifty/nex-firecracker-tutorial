# nex-firecracker-tutorial

# Setup
```bash
apt update && apt install make 
```

### Initial Setup with Makefile
- make 
```bash
make make_executable init
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



