# nex-firecracker-tutorial

- Trying to get NEX node running in the firecracker vm. It doesn't look like the firecracker vm has network access. Troubleshooting that. 

```bash
# make everything executable
chmod -R +x .

# run the init script to install prereqs
./shebang.sh

# run the firecracker script to start the instance with a config file
./firecracker.sh

```