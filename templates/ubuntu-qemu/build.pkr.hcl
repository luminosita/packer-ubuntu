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
    default = "packer-ubuntu"
}

variable "ubuntu_iso_path" {
    type = string
}

variable "ubuntu_repository_path" {
    type = string
    default = "repository"
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

variable "scripts" {
    type = list(string)
}

locals {
    vm_name = "${var.vm_template_name}-${var.ubuntu_version}"
    output_dir = "output/${local.vm_name}"
    ssh_username = "packer"
    ssh_password = "packer"
    checksum_type = "sha256"
}

build {
    name    = "base_build"
    sources = [ "source.qemu.base_image" ]

    #Prepare image logs for download
    provisioner "shell" {
        inline = [
            "mkdir /tmp/download",
            "sudo mv /var/log/installer/autoinstall-user-data /tmp/download",
            "sudo mv /var/log/cloud-init-output.log /tmp/download",
            "sudo chown ${local.ssh_username} -R /tmp/download"
            ]
    }

    #Create local (host) logs folder
    provisioner "shell-local" {
        inline = ["mkdir ${local.output_dir}/${local.vm_name}-logs"]
    }

    #Download Autoinstall logs from image to host
    provisioner "file" {
        sources      = [
            "/tmp/download/autoinstall-user-data",
            "/tmp/download/cloud-init-output.log"
        ]
        destination = "${local.output_dir}/${local.vm_name}-logs/"
        direction   = "download"
    }

    #Wait for Clout-init to finish
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for Cloud-Init...'; sleep 1; done"
        ]
    }

    # Finally Generate a Checksum (SHA256) which can be used for further stages in the `output` directory
    post-processor "checksum" {
        checksum_types      = [ "${local.checksum_type}" ]
        output              = "${local.output_dir}/${local.vm_name}.{{.ChecksumType}}"
        keep_input_artifact = true
    }
}

build {
    name = "final_build"
    sources = [ "source.qemu.final_image" ]
    
    #Upload Netplan configuration to image from host
    provisioner "file" {
        content = templatefile("../../files/netplan.tpl", {
            NET_INT = "eth0",
        })
        destination = "/tmp/50-cloud-init.yaml"
    }

    #Wait for Clout-init to finish
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for Cloud-Init...'; sleep 1; done"
        ]
    }

    provisioner "shell" {
        scripts = "${vars.scripts}"
        // scripts = [
        //     "scripts/network.sh",
        //     "scripts/sshd.sh",  
        //     "scripts/cleanup.sh"
        // ]
    }
}
