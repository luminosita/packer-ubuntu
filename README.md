qemu-system-aarch64 -M type=virt,accel=hvf -m 2G -smp 2 -cpu host -device virtio-net-pci,netdev=net0 -netdev user,id=net0,hostfwd=tcp::60022-:22 -bios QEMU_EFI.fd -nographic -drive if=virtio,format=qcow2,file=output/test-ubuntu-noble-1.0/test-ubuntu-noble-1.0

ssh ubuntu@127.0.0.1 -p 60022


Checksum?
Hardcoded repository_path 
Change passwd ubuntu user
Qemu Builder not resizing image
AMD build test
Тest k3s cluster with three nodes

Copy node tokens for server