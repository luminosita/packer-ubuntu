# VM description
vm_template_name        = "k3s-server-ubuntu-noble"
vm_template_description = "K3s Server Template (Ubuntu 24.04 - Noble Numbat)"
vm_id                = 8100

vm_clone_id          = 8010

vm_pool                     = "templates"

ssh_username            = "ubuntu"
ssh_private_key_file    = "~/.ssh/id_rsa"

ssh_bastion_username            = "proxmox"
ssh_bastion_private_key_file    = "~/.ssh/id_rsa"

### VM disk configuration
vm_disk_storage_pool = "local-zfs"
vm_disk_type         = "virtio"
vm_scsi_controller   = "virtio-scsi-single"
vm_guest_disk_drive  = "/dev/vda"
vm_disk_size         = "32G"
vm_disk_cache_mode   = "none"
vm_disk_format       = "raw"
vm_disk_io_thread    = true

# CPU & Memory
cpu_type            = "host"
vm_cores  = "1"
vm_memory = "1024"

vm_net_mac_address   = "BC:24:11:31:21:D8"

script_env = {
    "K3S_KUBECONFIG_MODE" = "644",
    "K3S_INSTALL_EXEC" = "--flannel-backend=none --cluster-cidr=\"10.100.0.0/16\" --disable-network-policy --disable=traefik",
    "INSTALL_K3S_SKIP_START" = "true"
}

scripts = [
    "../common/scripts/init.sh",
    "../common/scripts/k3s.sh",
    "../common/scripts/istio.sh",
]

