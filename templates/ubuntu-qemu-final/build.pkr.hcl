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

build {
    name = "stage_provision_image"
    sources = [ "source.qemu.final_image" ]
    
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for Cloud-Init...'; sleep 1; done" ,
            "cat /etc/os-release"
        ]
    }
}

