## Prepare Installer Machine
### Install Vault, Packer and Terraform

```bash
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/hcp
$ brew install hashicorp/tap/packer
$ brew install hashicorp/tap/terraform
```
Install JSON parser CLI
```bash
$ brew install jq
```

### Initialize HCP Vault CLI

Login to Vault
```bash
$ hcp auth login
The default web browser has been opened at https://auth.idp.hashicorp.com/oauth2/auth. Please continue the login in the web browser.
Success!
Successfully logged in!

$ hcp profile init --vault-secrets
  ✓ Organization with name "hashicorp-edu-org" and ID "12cd56-88d2-69fb-8cc1-s3sAm3st" selected
  ✓ Project with name "ProductionProject" and ID "12cd56-704c-46af-8ba5-mAtr3x" selected
  ✓ App with name "WebApplication" selected

$ hcp vault-secrets secrets list
Name      Latest Version  Created At
username  2               2023-05-24T12:22:18.395Z
```
## Digital Ocean

Change to `digitalocean` folder
```bash
$ cd digitalocean
```

### Initialize Digital Ocean Packer
```bash
$ make hcl-init
```

### Create Digital Ocean K3s Snapshots

Review snapshot variables in `images` and make necessary corrections.

For HA K3s Cluster start with creation of `Master Contol Node Server Snapshot`. For the regular K3s Cluster start with creation of `Control Node Server Snapshot`

#### Create Digital Ocean Master Control Node K3s Server Snapshot
```bash
make hcl-k3s-master-snapshot
```

For HA cluster option copy `/tmp/k3s-server.token` content to `k3s-server.token`, file used by Terraform to set proper environment variables into K3s services (`/etc/systemd/system/k3s-agent.service.env`)

#### Create Digital Ocean Control Node K3s Server Snapshot
```bash
make hcl-k3s-server-snapshot
```

For non HA cluster option copy `/tmp/k3s-server.token` to `k3s-server.token` after creation of `Control Node K3s Server Snapshot`

#### Create Digital Ocean K3s Agent Snapshot
```bash
make hcl-k3s-agent-snapshot
```
Verify snapshots in Digital Ocean Control Panel under Manager -> Backups/Snapshots

### Terraform Digital Ocean

#### Prepare variables

Review terraform variables in `terraform/vars` and paste proper snapshot names from Digital Ocean Contol Panel

#### Init Digital Ocean Terraform

```bash
$ make init-tf
```

#### Run Digital Ocean Terraform

```bash
$ make plan-k3s
```

Review Terraform plan and if everything is as expected,

```bash
$ make apply-k3s
```

## QEMU

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

### SSH Access to Running VM

```bash
$ ssh ubuntu@127.0.0.1 -p 60022
```

### Setup QEMU

Change to `qemu` folder
```bash
$ cd qemu
```

### Initialize QEMU Packer
```bash
$ make hcl-init
```

Prepare envirnment

```bash
$ make hcl-prepare
```

#### Create QEMU Control Node K3s Server Snapshot
```bash
$ make hcl-k3s-server
```

#### Create QEMU K3s Agent Snapshot
```bash
$ make hcl-k3s-agent
```

### Configure `kubectl` on Local Machine

Copy k3s kubctl access configuration to `~/.kube/config`

```bash
$ scp k3s@<control-node-ip> /etc/rancher/k3s/k3s.yaml ~/.kube/config
```

Run `kubectl` and retrieve cluster node list
```bash 
$ kubectl get nodes
```

+++++++++++++++

Terraform:
Verify CLUSTER-CIDR

Proxmox OS install
Proxmox provider for local server VMs

Start cockpit as non-root on Linux
Start qemu as non-root on Linux

Checksum for snapshots?

Qemu Builder not resizing image

Packer to create all server and agent images and set proper config files
Use Terraform scripts for Packer server/agent final images
Review QEMU images

HCP Packer for metadata
Finalize README.md

