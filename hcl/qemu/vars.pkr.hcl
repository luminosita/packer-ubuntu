variable "arch" {
    type = string
}

variable "vm_base_name" {
    type = string
}

variable "vm_base_version" {
    type = string
}

variable "vm_name" {
    type = string
    default = "packer-template"
}

variable "vm_version" {
    type = string
    default = "1.0"
}

variable "vm_repository_root" {
    type = string
    default = "~/vm_repo"
}

variable "vm_cpus" {
    type = number
    default = 2
}             

variable "vm_memory" {
    type = number
    default = 2048
}
           
variable "vm_disk_size" {
    type = string
    default = "5G"
}        

variable "vm_mac_addr" {
    type = string
    default = "00:AC:39:2C:F9:46"
}

variable "ansible_ssh_host" {
    type = string
    default = "127.0.0.1"
}

variable "ansible_ssh_port" {
    type = number
    default = 60022
} 
variable "ansible_ssh_username" {
    type = string
    default = "ubuntu"
}
variable "ansible_ssh_password" { 
    type = string
    default = "ubuntu"
}

variable "ansible_operation" { 
    type = string
    default = "server"
}

locals {
    vm_name = "${var.vm_name}-${var.vm_version}"
    vm_base_url = "${var.vm_repository_root}/${var.vm_base_name}/${var.vm_base_version}/${var.vm_base_name}-${var.vm_base_version}"
    vm_base_url_checksum = "none"
    vm_repo_path = "${var.vm_repository_root}/${var.vm_name}/${var.vm_version}" 
    vm_repo_url = "${local.vm_repo_path}/${var.vm_name}-${var.vm_version}"
    
    output_dir = "output/${local.vm_name}"
    ssh_username = "ubuntu"
    ssh_password = "ubuntu"
    checksum_type = "sha256"

    qemu_args = {
        "amd" = [
            [ "-cpu", "host" ],
            [ "-bios", "/usr/share/ovmf/OVMF.fd" ],
            [ "-device", "virtio-net,netdev=forward,id=net0,mac=${var.vm_mac_addr}"],
            [ "-netdev", "user,hostfwd=tcp::{{ .SSHHostPort }}-:22,id=forward"],
            [ "-cdrom", "cloud/seed.img" ]            
        ]
        "arm" = [
            [ "-cpu", "host" ],
            [ "-bios", "/opt/homebrew/share/qemu/edk2-aarch64-code.fd" ],                                         
            [ "-device", "virtio-net,netdev=forward,id=net0,mac=${var.vm_mac_addr}"],
            [ "-netdev", "user,hostfwd=tcp::{{ .SSHHostPort }}-:22,id=forward"],
            [ "-cdrom", "cloud/seed.img" ]            
        ]  
    }

    qemu_binary = {
        "amd" = "qemu-system-x86_64"
        "arm" = "qemu-system-aarch64"
    }

    machine_type     = {
        "amd" = "q35"
        "arm" = "virt"
    }
    
    accelerator      = {
        "amd" = "kvm"
        "arm" = "hvf"
    }
}