Build an image of cloud-init settings
$ docker run -it -v `pwd`:/tmp/host --rm ubuntu:16.04
# apt update; apt install -y vim cloud-utils; cloud-localds /tmp/host/seed.img /tmp/host/cloud.cfg

Download QEMU EFI.
curl -L https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd -o QEMU_EFI.fd

qemu-system-aarch64 -M type=virt,accel=hvf -m 2G -smp 2 -cpu host -device virtio-net-pci,netdev=net0 -netdev user,id=net0,hostfwd=tcp::60022-:22 -bios QEMU_EFI.fd -nographic -drive if=virtio,format=qcow2,file=output/test-ubuntu-noble-1.0/test-ubuntu-noble-1.0

ssh ubuntu@127.0.0.1 -p 60022


Checksum?
EFI?
Ansible?

Makefile 
    create seed image
    create base image

Hardcoded repository_path 