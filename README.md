### Install Digital Ocean HCP Vault CLI

### Initialize Digital Ocean Packer
```bash
$ make hcl-init-do
```

### Create Digital Ocean K3s Snapshots

Review snapshot variables in `digitalocean/images` and make necessary corrections.

For HA K3s Cluster start with creation of `Master Contol Node Server Snapshot`. For the regular K3s Cluster start with creation of `Control Node Server Snapshot`

#### Create Digital Ocean Master Control Node K3s Server Snapshot
```bash
make hcl-k3s-master-do-snapshot
```

For HA cluster option copy `/tmp/k3s-server.token` content to `k3s-server.token`, file used by Terraform to set proper environment variables into K3s services (`/etc/systemd/system/k3s-agent.service.env`)

#### Create Digital Ocean Control Node K3s Server Snapshot
```bash
make hcl-k3s-server-do-snapshot
```

For non HA cluster option copy `/tmp/k3s-server.token` to `k3s-server.token` after creation of `Control Node K3s Server Snapshot`

#### Create Digital Ocean K3s Agent Snapshot
```bash
make hcl-k3s-agent-do-snapshot
```
Verify snapshots in Digital Ocean Control Panel under Manager -> Backups/Snapshots

### Terraform Digital Ocean

#### Prepare variables

Review terraform variables in `terraform/vars` and paste proper snapshot names from Digital Ocean Contol Panel

#### Init Digital Ocean Terraform

```bash
$ cd terraform
$ make init-tf-do
```

#### Run Digital Ocean Terraform

```bash
$ make plan-k3s-do
```

Review Terraform plan and if everything is as expected,

```bash
$ make apply-k3s-do
```

### Initialize QEMU Packer
```bash
$ make hcl-init-qemu
```

#### Create QEMU Control Node K3s Server Snapshot
```bash
make hcl-k3s-server-qemu
```

#### Create QEMU K3s Agent Snapshot
```bash
make hcl-k3s-agent-qemu
```

### Deploy KVM, QEMU and Cockpit on VM Server

To use KVM to create, install, and manage virtual machines, you need to first make sure your computer is configured for virtualization, then install a number of packages. Here is the sequence for preparing Ubuntu 20.04:

```bash
$ lscpu | grep Virtualization 
```
to make sure virtualization is enabled. If it is, then, as root (prefix commands with sudo):

```bash
$ apt update 
$ apt install cpu-checker 
$ kvm-ok 
```
To check to see if kvm is enabled in the kernel, then install the following packages and check to see if the daemon is running:

```bash
$ apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager 
$ systemctl is-active libvirtd 
```
Lastly, add yourself to the libvirt and kvm groups

```bash
$ usermod -aG libvirt $USER 
$ usermod -aG kvm $USER 
```
 
And check to see if the bridge network is running properly

```bash
$ brctl show 
```

### Run VM on AMD64 Linux 

```bash
$ sudo qemu-system-x86_64 -m 2G -smp 2 -enable-kvm -cpu host -nic user,hostfwd=tcp::60022-:22 -boot strict=off -device qemu-xhci -device usb-kbd -device virtio-gpu-pci -nographic -drive if=virtio,format=qcow2,file=output/packerubuntu-24.04/packerubuntu-24.04
```

```bash
sudo qemu-system-x86_64 -cpu host -m 2G -enable-kvm -nographic -device virtio-net-pci,netdev=net0 -netdev user,id=net0,hostfwd=tcp::60022-:22 -drive if=virtio,format=raw,file=output/packerubuntu-24.04/packerubuntu-24.04 -bios /usr/share/ovmf/OVMF.fd
```

### Run VM on ARM64 MacOS

Download QEMU_EFI.rd
curl -L https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd -o QEMU_EFI.fd

```bash
$ qemu-system-aarch64 -M type=virt,accel=hvf -m 2G -smp 2 -cpu host -device virtio-net-pci,netdev=net0 -netdev user,id=net0,hostfwd=tcp::60022-:22 -bios QEMU_EFI.fd -nographic -drive if=virtio,format=qcow2,file=output/ubuntu-noble-ansible-1.0/ubuntu-noble-ansible-1.0
```

### SSH Access to running VM

```bash
$ ssh ubuntu@127.0.0.1 -p 60022
```

+++++++++++++++

Bug: NON-ROOT USER DigitalOcean

Terraform:
Тest k3s cluster with three nodes
K3S node tokens for agents
LOCAL IPS for agent join

Start cockpit as non-root
Start qemu as non-root
Checksum?

Change passwd ubuntu user
Qemu Builder not resizing image
HCP Packer for metadata

Review QEMU images
Finalize README.md
