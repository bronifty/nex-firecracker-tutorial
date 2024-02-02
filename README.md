# nex-firecracker-tutorial

[kevin hoffman nex demo](https://youtu.be/EfxtiKMnoyQ?si=43tlix2Urrw2F7w8)
[synadia nats nex docs](https://docs.nats.io/using-nats/nex/getting-started/deploying-services)

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





