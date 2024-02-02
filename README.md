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
make nex preflight
```

### Startup NATS Server
```bash
make nats
```

### Build EchoService
- in a new terminal
```bash
make build
```

### Test EchoService
- in a new terminal
```bash
make test
```

### Static Compile
- let's compile this echoservice
```bash
make compile
```

### NEX Node Up
```bash
make run
```

### NEX devrun
```bash
make devrun
```





