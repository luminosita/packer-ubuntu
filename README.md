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

****

sudo qemu-system-x86_64 -m 2G -smp 2 -enable-kvm -cpu host -nic user,hostfwd=tcp::60022-:22 -boot strict=off -device qemu-xhci -device usb-kbd -device virtio-gpu-pci -nographic -drive if=virtio,format=qcow2,file=output/packerubuntu-24.04/packerubuntu-24.04

sudo qemu-system-x86_64 -cpu host -m 2G -enable-kvm -nographic -device virtio-net-pci,netdev=net0 -netdev user,id=net0,hostfwd=tcp::60022-:22 -drive if=virtio,format=raw,file=output/packerubuntu-24.04/packerubuntu-24.04 -bios /usr/share/ovmf/OVMF.fd

MacOS:
Download QEMU_EFI.rd
curl -L https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd -o QEMU_EFI.fd

qemu-system-aarch64 -M type=virt,accel=hvf -m 2G -smp 2 -cpu host -device virtio-net-pci,netdev=net0 -netdev user,id=net0,hostfwd=tcp::60022-:22 -boot strict=off -device qemu-xhci -device usb-kbd -device virtio-gpu-pci -bios /opt/homebrew/share/qemu/edk2-aarch64-code.fd -nographic -drive if=virtio,format=raw,file=output/packerubuntu-24.04/packerubuntu-24.04

qemu-system-aarch64 -M type=virt,accel=hvf -m 2G -smp 2 -cpu host -device virtio-net-pci,netdev=net0 -netdev user,id=net0,hostfwd=tcp::60022-:22 -bios QEMU_EFI.fd -nographic -drive if=virtio,format=qcow2,file=output/ubuntu-noble-ansible-1.0/ubuntu-noble-ansible-2.0

ssh ubuntu@127.0.0.1 -p 60022


curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_TOKEN="2y6rrd.hnshbds0iyj6yq9t" \
    INSTALL_K3S_EXEC="--flannel-backend=none --cluster-cidr=$K3S_CLUSTER_CIDR --disable-network-policy --disable=traefik" sh -s -

sudo apt install cloud-init-localds


Bug: NON-ROOT USER DigitalOcean

Terraform:
Тest k3s cluster with three nodes
K3S node tokens for agents

Start cockpit as non-root
Start qemu as non-root
Checksum?

Change passwd ubuntu user
Qemu Builder not resizing image
HCP Packer for metadata
