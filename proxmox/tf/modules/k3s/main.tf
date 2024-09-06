terraform {
    required_providers {
        proxmox = {
            source  = "bpg/proxmox"
        }    
    }
}

locals {
  //hardcoded MAC address for Mikrotik router statis lease
  work_mac_address = ["BC:24:11:BD:3C:67", "BC:24:11:A9:6A:39","BC:24:11:57:11:94"]
}

resource "proxmox_virtual_environment_download_file" "ubuntu_2404_generic_image" {
//    provider     = proxmox.euclid
    node_name    = var.proxmox.node_name
    content_type = "iso"
    datastore_id = "local"

    file_name          = "noble-server-cloudimg-amd64.img"
    url                = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    checksum           = "ffafb396efb0f01b2c0e8565635d9f12e51a43c51c6445fd0f84ad95c7f74f9b"
    checksum_algorithm = "sha256"
}
	
resource "proxmox_virtual_environment_file" "cloud-init-ctrl-01" {
  node_name    = var.proxmox.node_name
  content_type = "snippets"
  datastore_id = "local"

  source_raw {
    data = templatefile("../cloud-init/k3s-common.yaml.tftpl", {
        hostname    = "k3s-ctrl-01"
        username    = var.vm_user
        pub-key     = file(var.ssh_public_key_file)
    })
    
    file_name = "cloud-init-k3s-ctrl-01.yaml"
  }
}

resource "proxmox_virtual_environment_file" "cloud-init-work-01" {
  count = 2

  node_name    = var.proxmox.node_name
  content_type = "snippets"
  datastore_id = "local"

  source_raw {
    data = templatefile("../cloud-init/k3s-common.yaml.tftpl", {
        hostname    = "k3s-work-0${count.index+1}"
        username    = var.vm_user
        pub-key     = file(var.ssh_public_key_file)
    })
    
    file_name = "cloud-init-k3s-work-0${count.index+1}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "k8s-ctrl-01" {
//  provider  = proxmox.euclid
  node_name = var.proxmox.node_name

  name        = "k3s-ctrl-01"
  description = "Kubernetes Control Plane 01"
  tags        = ["k3s", "control-plane"]
  on_boot     = true
  vm_id       = 8001

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  bios          = "ovmf"

  cpu {
    cores = 4
    type  = "host"
  }

  memory {
    dedicated = 4096
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = local.work_mac_address[0]
  }

  efi_disk {
    datastore_id = "local-zfs"
    file_format  = "raw" // To support qcow2 format
    type         = "4m"
  }

  disk {
    datastore_id = "local-zfs"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_2404_generic_image.id
    interface    = "scsi0"
    cache        = "writethrough"
    discard      = "on"
    ssd          = true
    size         = 32
  }

  serial_device {
    device = "socket"
  }

  vga {
    type = "serial0"
  }

  boot_order = ["scsi0"]

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 6.X.
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    datastore_id      = "local-zfs"
    user_data_file_id = proxmox_virtual_environment_file.cloud-init-ctrl-01.id
  }
}

resource "proxmox_virtual_environment_vm" "k8s-work-01" {
  count = 2
//  provider  = proxmox.euclid
  node_name = var.proxmox.node_name

  name        = "k3s-work-0${count.index+1}"
  description = "Kubernetes Worker Node 0${count.index+1}"
  tags        = ["k3s", "worker"]
  on_boot     = true
  vm_id       = 8001 + count.index + 1

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  bios          = "ovmf"

  cpu {
    cores = 4
    type  = "host"
  }

  memory {
    dedicated = 4096
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = local.work_mac_address[count.index + 1]
  }

  efi_disk {
    datastore_id = "local-zfs"
    file_format  = "raw" // To support qcow2 format
    type         = "4m"
  }

  disk {
    datastore_id = "local-zfs"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_2404_generic_image.id
    interface    = "scsi0"
    cache        = "writethrough"
    discard      = "on"
    ssd          = true
    size         = 32
  }

  serial_device {
    device = "socket"
  }

  vga {
    type = "serial0"
  }

  boot_order = ["scsi0"]

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 6.X.
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    datastore_id      = "local-zfs"
    user_data_file_id = proxmox_virtual_environment_file.cloud-init-work-01[count.index].id
  }
}

# data "external" "k3s-init-info" {
#     program = ["/bin/bash", "../common/scripts/k3s-init-info.sh"]
#     query = {
#         username            = var.ssh_username,
#         ip_address          = digitalocean_droplet.k3s_server.ipv4_address,
#         private_key_file    = var.ssh_private_key_file
#     }
# }

# resource "proxmox_lxc" "k3s_server" {
#     target_node     = var.prox_target_node
#     hostname        = var.vm_server_name
#     unprivileged    = true

#     clone           = var.prox_template_vmid
#     clone_storage   = var.prox_storage

#    pool            = var.prox_pool

    # full            = true

    # vmid            = 2000

    # rootfs {
    #     storage = "local-zfs"
    #     size    = "20G"
    # }

    # network {
    #     name   = "eth0"
    #     bridge = "vmbr0"
    #     ip     = "dhcp"
    # }
# }

# resource "proxmox_lxc" "k3s_agent" {
#     count = 2

#     target_node     = var.prox_target_node
#     hostname        = "${var.vm_agent_name}-${count.index+1}"
#     unprivileged    = true

#     clone           = var.prox_template_vmid
#     clone_storage   = var.prox_storage

# #    pool            = var.prox_pool

#     full            = true

#     vmid            = 2000 + count.index + 1

#     rootfs {
#         storage = "local-zfs"
#         size    = "20G"
#     }

    # network {
    #     name   = "eth0"
    #     bridge = "vmbr0"
    #     ip     = "dhcp"
    # }

    # connection {
    #     host = self.
    #     user = var.ssh_username
    #     type = "ssh"
    #     private_key = file(var.ssh_private_key_file)
    #     timeout = "2m"  
    # }

    # provisioner "local-exec" {
    #     command = "k3sup install --ip $MASTER_IP --user ${ssh_username} --k3s-channel v1.24  --local-path /tmp/config"
    # }
# }

# resource "local_file" "test_file" {
#     filename = "test.env"

#     //content = data.external.k3s-init-info.result.token

#     content = replace(replace(jsonencode(data.external.k3s-init-info.result), "\"", ""), ":", "=")
# }

# variable "ips" {
#     type = list(string)
#     default = ["167.99.129.234"]
# }

# resource "null_resource" "k3sup-server" {
#     count = 1

#     connection {
#         host = proxmox_lxc.k3s_server.vmid
#         user = var.ssh_username
#         type = "ssh"
#         private_key = file(var.ssh_private_key_file)
        
#         bastion_host = var.ssh_bastion_host
#         bastion_user = var.ssh_bastion_username
#         bastion_private_key = var.ssh_bastion_private_key_file

#         timeout = "2m"  
#     }

#     provisioner "local-exec" {
#         command = "laza"
#         # inline = [
#         #     # "systemctl enable k3s-agent",
#         #     # "systemctl start k3s-agent",
#         # ]
#     }
# }
