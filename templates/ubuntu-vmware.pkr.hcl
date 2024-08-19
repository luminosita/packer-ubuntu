# Copyright 2024 Shantanoo 'Shan' Desai <sdes.softdev@gmail.com>

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#  limitations under the License.

packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.9"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

## Variable will be set via the Command line defined under the `vars` directory
variable "ubuntu_distro" {
    type = string
}

variable "ubuntu_version" {
    type = string
}

variable "ubuntu_iso_file" {
    type = string
}

variable "vm_template_name" {
    type = string
    default = "packerubuntu"
}

variable "host_distro" {
    type = string
    default = "manjaro"
}

variable "ubuntu_iso_path" {
    type = string
}

variable "ubuntu_iso_checksum" {
    type = string
}

variable "ubuntu_qemuargs" {
    type    = list(list(string))
    default = []
}

variable "ubuntu_qemu_binary" {      
    type = string
}

variable "ubuntu_machine_type" {     
    type = string
}

variable "ubuntu_accelerator" {
    type = string
}

locals {
    vm_name = "${var.vm_template_name}-${var.ubuntu_version}"
    output_dir = "output/${local.vm_name}"
    ovmf_prefix = {
      "manjaro" = "x64/"
    }
    ssh_username = "packer"
    ssh_password = "packer"
}

source "qemu" "custom_image" {
    vm_name         = "${local.vm_name}"
    
    iso_urls        = [
        "iso/${var.ubuntu_iso_file}",
        "${var.ubuntu_iso_path}"
        ]
    iso_checksum    = "${var.ubuntu_iso_checksum}"
    iso_target_path = "iso"

    # Location of Cloud-Init / Autoinstall Configuration files
    # Will be served via an HTTP Server from Packer
    http_directory = "http/${var.ubuntu_distro}"

    # Boot Commands when Loading the ISO file with OVMF.fd file (Tianocore) / GrubV2
    boot_command = [
        "c",
        "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
        "<enter><wait>",
        "initrd /casper/initrd <enter><wait>",
        "boot<enter>"
    ]
    
    boot_wait = "5s"

    # QEMU specific configuration
    qemu_binary      = "${var.ubuntu_qemu_binary}"
    machine_type     = "${var.ubuntu_machine_type}"
    format           = "raw"
    cpus             = 2
    memory           = 2048
    accelerator      = "${var.ubuntu_accelerator}"
    net_device       = "virtio-net"
    disk_size        = "30G"
    disk_compression = true
    disk_interface   = "virtio"
    qemuargs         = "${var.ubuntu_qemuargs}"

    #efi_firmware_code = "/usr/share/OVMF/${lookup(local.ovmf_prefix, var.host_distro, "")}OVMF_CODE.fd"
    #efi_firmware_vars = "/usr/share/OVMF/${lookup(local.ovmf_prefix, var.host_distro, "")}OVMF_VARS.fd"
    #efi_boot          = true

    # Final Image will be available in `output/packerubuntu-*/`
    output_directory = "${local.output_dir}"

    # SSH configuration so that Packer can log into the Image
    ssh_password    = "${local.ssh_password}"
    ssh_username    = "${local.ssh_username}"
    ssh_timeout     = "20m"
    shutdown_command = "echo '${local.ssh_password}' | sudo -S shutdown -P now"
    headless        = true # NOTE: set this to true when using in CI Pipelines
}

build {
    name    = "custom_build"
    sources = [ "source.qemu.custom_image" ]

    provisioner "shell" {
        inline = [
            "mkdir /tmp/download",
            "sudo mv /var/log/installer/autoinstall-user-data /tmp/download",
            "sudo mv /var/log/cloud-init-output.log /tmp/download",
            "sudo chown ${local.ssh_username} -R /tmp/download"
            ]
    }

    provisioner "shell-local" {
        inline = ["mkdir ${local.output_dir}/${local.vm_name}-logs"]
    }

    provisioner "file" {
        sources      = [
            "/tmp/download/autoinstall-user-data",
            "/tmp/download/cloud-init-output.log"
        ]
        destination = "${local.output_dir}/${local.vm_name}-logs/"
        direction   = "download"
    }

    # Wait till Cloud-Init has finished setting up the image on first-boot
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for Cloud-Init...'; sleep 1; done" 
        ]
    }

    provisioner "file" {
        content = templatefile("../files/netplan.tpl", {
            NET_INT = "eth0",
        })
        destination = "/tmp/50-cloud-init.yaml"
    }

    provisioner "shell" {
         inline = [
        "sudo mv /tmp/50-cloud-init.yaml /etc/netplan/",
        "sudo chown root:root /etc/netplan/50-cloud-init.yaml"
        ]
    }

    provisioner "shell" {
        scripts = [
            "scripts/sshd.sh",
#            "scripts/network.sh",
            "scripts/cleanup.sh"
        ]
    }

    # Finally Generate a Checksum (SHA256) which can be used for further stages in the `output` directory
    post-processor "checksum" {
        checksum_types      = [ "sha256" ]
        output              = "${local.output_dir}/${local.vm_name}.{{.ChecksumType}}"
        keep_input_artifact = true
    }
}
