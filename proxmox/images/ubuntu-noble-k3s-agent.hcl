vm_name              = "k3s-agent-ubuntu-noble"

vm_base_image        = "ubuntu-24-04-x64" 

ssh_username            = "k3s"
do_ssh_key_id           = 42814638
ssh_public_key_file     = "~/.ssh/id_rsa.pub"
ssh_private_key_file    = "~/.ssh/id_rsa"

script_env = {
    "K3S_TOKEN"                 = "K3STOKEN"
    "K3S_URL"                   = "https://K3SIP:6443"
    "INSTALL_K3S_SKIP_ENABLE"   = "true"
    "INSTALL_K3S_SKIP_START"    = "true"
}

scripts = [
    "../common/scripts/init.sh",
    "../common/scripts/k3s.sh"
]





### VM disk configuration
vm_disk_storage_pool = "local-zfs"
vm_disk_type         = "virtio"
vm_scsi_controller   = "virtio-scsi-single"
vm_guest_disk_drive  = "/dev/vda"
vm_disk_size         = "4G"
vm_disk_cache_mode   = "none"
vm_disk_format       = "raw"
vm_disk_io_thread    = true

# CPU & Memory
vm_cores  = "1"
vm_memory = "1024"

# OS
cloud_img_url   = "https://cloud-images.ubuntu.com/mantic/current/mantic-server-cloudimg-amd64.img"
cloud_init_user = "ubuntu"

# VM description
vm_name              = "ubuntu-2310-cloudimg-template-WIP"
template_name        = "ubuntu-2310-cloudimg"
template_description = "Ubuntu 23.10 (Mantic Minotaur) via packer\n\n[info](https://cloud-images.ubuntu.com/mantic/current/)"
vm_id                = 1000016
