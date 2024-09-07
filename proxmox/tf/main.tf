terraform {
    required_version = ">= 1.9.5"

    required_providers {
        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = ">= 2.32.0"
        }

        local = {
            source  = "hashicorp/local"
            version = ">= 2.5.1"
        }

        helm = {
            source  = "hashicorp/helm"
            version = ">= 2.15.0"
        }

        null = {
            source  = "hashicorp/null"
            version = ">= 3.2.2"
        }

        proxmox = {
            source  = "bpg/proxmox"
            version = "0.63.0"
        }    
    }
}

provider "kubernetes" {
    config_path    = var.k3s.kube_config_file
    config_context = "default"
}

provider "helm" {
    kubernetes {
        config_path    = var.k3s.kube_config_file
        config_context = "default"
    }
}

provider "proxmox" {
//    alias    = "euclid"
    endpoint = var.proxmox.endpoint
    insecure = var.proxmox.insecure

    api_token = "${var.api_token_id}=${var.api_token_secret}"
    
    ssh {
        agent               = false
        username            = var.proxmox.ssh_username
        private_key         = file(var.proxmox.ssh_private_key_file)
    }

    tmp_dir = "/var/tmp"
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
	
resource "proxmox_virtual_environment_file" "cloud-init-ctrl" {
    count = 1

    node_name    = var.proxmox.node_name
    content_type = "snippets"
    datastore_id = "local"

    source_raw {
        data = templatefile("../cloud-init/k3s-control-plane.yaml.tftpl", {
            common-config = templatefile("../cloud-init/k3s-common.yaml.tftpl", {
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
        data = templatefile("../cloud-init/k3s-worker.yaml.tftpl", {
            common-config = templatefile("../cloud-init/k3s-common.yaml.tftpl", {
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

module "k3s" {
    source = "../../common/tf/modules/k3s"

    k3s     = var.k3s

    cluster = {
        ctrl_ips = proxmox_virtual_environment_vm.k3s-ctrl[*].ipv4_addresses[1][0]
        work_ips = proxmox_virtual_environment_vm.k3s-work[*].ipv4_addresses[1][0]
    }
}

module "cert-manager" {
    depends_on = [ module.k3s ]
    source = "../../common/tf/modules/cert-manager"
}

# module "k8s-dashboard" {
#     depends_on = [ module.cert-manager ]
#     source = "../../common/tf/modules/k8s-dashboard"

#     ingress_domain = var.k3s.ingress_domain
# }

