terraform {
    required_providers {
        proxmox = {
            source  = "bpg/proxmox"
        }    
    }
}


resource "proxmox_virtual_environment_download_file" "ubuntu_2404_generic_image" {
//    provider     = proxmox.euclid
    node_name    = var.proxmox.node_name
    content_type = "iso"
    datastore_id = "local"

    file_name          = var.k3s.vm_base_image
    url                = var.k3s.vm_base_url
    checksum           = var.k3s.vm_base_image_checksum
    checksum_algorithm = var.k3s.vm_base_image_checksum_alg
}
	
resource "proxmox_virtual_environment_file" "cloud-init-ctrl" {
    count = 1

    node_name    = var.proxmox.node_name
    content_type = "snippets"
    datastore_id = "local"

    source_raw {
        data = templatefile("${path.module}/resources/cloud-init/k3s-control-plane.yaml.tftpl", {
            common-config = templatefile("${path.module}/resources/cloud-init/k3s-common.yaml.tftpl", {
                hostname      = "k3s-ctrl-0${count.index+1}"
                username      = var.k3s.vm_user
                pub-keys      = var.k3s.vm_ssh_public_key_files
            })
        })

        file_name = "cloud-init-k3s-ctrl-0${count.index+1}.yaml"
    }
}

resource "proxmox_virtual_environment_file" "cloud-init-work" {
    count = 2

    node_name    = var.proxmox.node_name
    content_type = "snippets"
    datastore_id = "local"

    source_raw {
        data = templatefile("${path.module}/resources/cloud-init/k3s-worker.yaml.tftpl", {
            common-config = templatefile("${path.module}/resources/cloud-init/k3s-common.yaml.tftpl", {
            hostname    = "k3s-work-0${count.index+1}"
            username    = var.k3s.vm_user
            pub-keys    = var.k3s.vm_ssh_public_key_files
            })
        })    
        
        file_name = "cloud-init-k3s-work-0${count.index+1}.yaml"
    }
}

resource "proxmox_virtual_environment_vm" "k3s-ctrl" {
    count = length(proxmox_virtual_environment_file.cloud-init-ctrl)

    //  provider  = proxmox.euclid
    node_name = var.proxmox.node_name

    name        = "k3s-ctrl-0${count.index+1}"
    description = "Kubernetes Control Plane 0${count.index+1}"
    tags        = ["k3s", "control-plane"]
    on_boot     = true
    vm_id       = 8000 + count.index

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
        mac_address = local.ctrl_mac_address[count.index]
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
    
    agent {
        enabled = true
    }

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
        user_data_file_id = proxmox_virtual_environment_file.cloud-init-ctrl[count.index].id
    }
}

resource "proxmox_virtual_environment_vm" "k3s-work" {
    count = length(proxmox_virtual_environment_file.cloud-init-work)

    //  provider  = proxmox.euclid
    node_name = var.proxmox.node_name

    name        = "k3s-work-0${count.index+1}"
    description = "Kubernetes Worker Node 0${count.index+1}"
    tags        = ["k3s", "worker"]
    on_boot     = true
    vm_id       = 8010 + count.index

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
        mac_address = local.work_mac_address[count.index]
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
    
    agent {
        enabled = true
    }
    
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
        user_data_file_id = proxmox_virtual_environment_file.cloud-init-work[count.index].id
    }
}