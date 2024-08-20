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
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/vmware"
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

variable "ubuntu_iso_path" {
    type = string
}

variable "ubuntu_iso_checksum" {
    type = string
}

locals {
    vm_name = "${var.vm_template_name}-${var.ubuntu_version}"
    output_dir = "output/${local.vm_name}"
    ssh_username = "packer"
    ssh_password = "packer"
}

build {
    name    = "base_build"
    sources = [ "source.vmware-iso.base_image" ]

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
        content = templatefile("../../files/netplan.tpl", {
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
#            "scripts/sshd.sh",    #this needs to go into final image
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
