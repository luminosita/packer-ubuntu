terraform {
    required_providers {
        proxmox = {
            source  = "bpg/proxmox"
        }    
        local = {
            source  = "hashicorp/local"
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
        data = templatefile("../cloud-init/k3s-control-plane.yaml.tftpl", {
            common-config = templatefile("../cloud-init/k3s-common.yaml.tftpl", {
                hostname      = "k3s-ctrl-01"
                username      = var.vm_user
                pub-key       = file(var.ssh_public_key_file)
                cluster-cidr  = var.cluster_cidr
            })
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
        data = templatefile("../cloud-init/k3s-worker.yaml.tftpl", {
            common-config = templatefile("../cloud-init/k3s-common.yaml.tftpl", {
            hostname    = "k3s-work-0${count.index+1}"
            username    = var.vm_user
            pub-key     = file(var.ssh_public_key_file)
            })
        })    
        
        file_name = "cloud-init-k3s-work-0${count.index+1}.yaml"
    }
}

resource "proxmox_virtual_environment_vm" "k3s-ctrl-01" {
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

output "ctrl_01_ipv4_address" {
    value      = proxmox_virtual_environment_vm.k3s-ctrl-01.ipv4_addresses[1][0]
}

resource "proxmox_virtual_environment_vm" "k3s-work-01" {
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

resource "null" "k3sup" {
    provisioner "local-exec" {
        command = "k3sup install --ip ${proxmox_virtual_environment_vm.k3s-ctrl-01.ipv4_addresses[1][0]} ${local.k3sup_server_args}"
    }  

    provisioner "local-exec" {
        command = "k3sup join --ip ${proxmox_virtual_environment_vm.k3s-work-01[0].ipv4_addresses[1][0]} --server-ip ${proxmox_virtual_environment_vm.k3s-ctrl-01.ipv4_addresses[1][0]} ${local.k3sup_agent_args}"
    }

    provisioner "local-exec" {
        command = "k3sup join --ip ${proxmox_virtual_environment_vm.k3s-work-01[1].ipv4_addresses[1][0]} --server-ip ${proxmox_virtual_environment_vm.k3s-ctrl-01.ipv4_addresses[1][0]} ${local.k3sup_agent_args}"
    }
}

