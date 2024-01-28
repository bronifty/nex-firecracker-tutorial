#!/bin/bash
source variables.sh

# Write the JSON configuration to a file
cat << EOF > input.json
{
  "boot-source": {
    "kernel_image_path": "${KERNEL_IMAGE_PATH}",
    "boot_args": "console=ttyS0 reboot=k panic=1 pci=off",
    "initrd_path": null
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "partuuid": null,
      "is_root_device": true,
      "cache_type": "Unsafe",
      "is_read_only": false,
      "path_on_host": "${ROOTFS_PATH}",
      "io_engine": "Sync",
      "rate_limiter": null,
      "socket": null
    }
  ],
  "machine-config": {
    "vcpu_count": 2,
    "mem_size_mib": 1024,
    "smt": false,
    "track_dirty_pages": false
  },
  "cpu-config": null,
  "balloon": null,
  "network-interfaces": [
  {
    "iface_id": "eth0",
    "guest_mac": "AA:FC:00:00:00:01",
    "host_dev_name": "tap0"
  }
],
  "vsock": null,
  "logger": null,
  "metrics": null,
  "mmds-config": null,
  "entropy": null
}
EOF

# Substitute the variables
envsubst < input.json > firecracker-config.json

# run the firecracker with the output.json config file
firecracker --api-sock "${FIRECRACKER_SOCKET}" --config-file firecracker-config.json
