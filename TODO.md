# K8s (Proxmox VMs and DigitalOcean for true HA)
- [x] Ansible
- [x] Terraform
- [ ] Network
- [ ] Storage
- [ ] Health Checks (https://blog.kubecost.com/blog/kubernetes-health-check/)
- [ ] Ingress

## Terraform
- [ ] Verify CLUSTER-CIDR

## Proxmox
- [ ] CT Template?
- [ ] LXC Containers
- [ ] Packer template
- [ ] Packer VM clone
- [ ] Packer LXC container

## Packer
- [ ] HCP Packer for metadata

## Misc
- [ ] Finalize README.md for Proxmox

# User k3s
- [ ] .ssh/authorized_keys 
- [ ] root@proxmox
- [ ] proxmox@proxmox
- [ ] milosh@Gianni
- [ ] sudoers.d
- [ ] k3s ALL = (ALL) NOPASSWD: ALL

# VM
- [ ] EFI vs UEFI
- [ ] Public IP (directly assigned by modem, eth1 net interface)
- [ ] Private IP (eth0 net interface)
- [ ] Virtual Router pfSense (NAT, Firewall, VLANs, DHCP, DNS)
- [ ] Robust images:
 - [ ] local hypervisor
 - [ ] cloud provider as custom image 
 - [ ] bare metal image thru iPXE or some other option
- [ ] Cloud init for ISO or published RAW image as base template image:
 - [ ]  Minimum packages installed
 - [ ]  Minimum VM size
 - [ ]  Optimal storage layout
 - [ ]  Bridge network
- [ ] Bash script vs Ansible customization provisioner:
 - [ ] Hostname
 - [ ] Root password
 - [ ] Root SSH access public key
 - [ ] Custom SSH account password
 - [ ] Custom SSH account public key
 - [ ] Enable/disable root access
 - [ ] Enable/disable password authentication
 - [ ] Package installation
 - [ ] Config file templating (netplan, docker, kubernetes...)
 - [ ] Chown/chmod for files
 - [ ] Monitoring (Prometheus)
 - [ ] Change ubuntu account passwd
 - [ ] Image cleanup (temp/log file deletion ...)

# CI/CD VM images
- [ ] GitRepo for base Packer HCL files
- [ ] Fork base repo for each final image
- [ ] Main branch for fork repo requires PullRequest for commit/merge
- [ ] Artifactory Pipeline is created for a fork repo
- [ ] Artifactory is triggered by main branch commit
- [ ] Development is done in a form repo branch
- [ ] Github local worker creates Artifactory Pipeline thru REST API for a fork
