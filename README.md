To use KVM to create, install, and manage virtual machines, you need to first make sure your computer is configured for virtualization, then install a number of packages. Here is the sequence for preparing Ubuntu 20.04:

lscpu | grep Virtualization 
to make sure virtualization is enabled. If it is, then, as root (prefix commands with sudo):

apt update 
apt install cpu-checker 
kvm-ok 
To check to see if kvm is enabled in the kernel, then install the following packages and check to see if the daemon is running:

apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager 
systemctl is-active libvirtd 
Lastly, add yourself to the libvirt and kvm groups

 usermod -aG libvirt $USER 
 usermod -aG kvm $USER 
And check to see if the bridge network is running properly

 brctl show 

 sudo apt install cloud-init-localds

qemu-system-aarch64 -M type=virt,accel=hvf -m 2G -smp 2 -cpu host -device virtio-net-pci,netdev=net0 -netdev user,id=net0,hostfwd=tcp::60022-:22 -bios QEMU_EFI.fd -nographic -drive if=virtio,format=qcow2,file=output/test-ubuntu-noble-1.0/test-ubuntu-noble-1.0

ssh ubuntu@127.0.0.1 -p 60022


packer DigitalOcean for k8s

Bug: NON-ROOT USER DigitalOcean

HCP Packer for metadata

Start cockpit as non-root
Start qemu as non-root
Checksum?

Change passwd ubuntu user
Qemu Builder not resizing image

Terraform:
Тest k3s cluster with three nodes
K3S node tokens for server
Fix scripts in base builder
