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

build {
    name    = "base"
    sources = [ "source.qemu.base" ]

    #Upload Netplan configuration to image from host
    // provisioner "file" {
    //     content = templatefile("../../files/netplan.tpl", {
    //         MAC_ADDR = "${var.vm_mac_addr}",
    //     })
    //     destination = "/tmp/50-cloud-init.yaml"
    // }


    #Prepare image logs for download
    provisioner "shell" {
        scripts = [ "scripts/cloud-init.sh" ]
    }

    #Create local (host) logs folder
    provisioner "shell-local" {
        inline = ["mkdir ${local.output_dir}/${local.vm_name}-logs"]
    }

    #Download Autoinstall logs from image to host
    provisioner "file" {
        sources      = [
            "/tmp/download/cloud-init-output.log"
        ]
        destination = "${local.output_dir}/${local.vm_name}-logs/"
        direction   = "download"
    }

    provisioner "shell" {
        scripts = [
#            "scripts/network.sh",
            "scripts/sshd.sh",  
            "scripts/cleanup.sh"
        ]
    }
    # Finally Generate a Checksum (SHA256) which can be used for further stages in the `output` directory
    post-processor "checksum" {
        checksum_types      = [ "${local.checksum_type}" ]
        output              = "${local.output_dir}/${local.vm_name}.{{.ChecksumType}}"
        keep_input_artifact = true
    }

    post-processor "shell-local" {
        inline = [
            "mkdir -p ${local.vm_repo_path}",
            "cp ${local.output_dir}/${local.vm_name} ${local.vm_repo_url}.img"
        ]
    }
}

build {
    name = "ansible"
    sources = [ "source.qemu.base" ]

    provisioner "shell" {
        scripts = [ "scripts/python.sh" ]
    }
    provisioner "ansible" {
        playbook_file = "ansible/playbook.yaml"
        extra_arguments = ["-e operation=${var.ansible_operation} -v"]
//        command = "/home/ubuntu/python-venv/ansible/bin/ansible-playbook"
        ansible_ssh_extra_args = [ "-o StrictHostKeyChecking=no -o PubkeyAcceptedKeyTypes=+ssh-rsa -o HostkeyAlgorithms=+ssh-rsa"]
    }

    post-processor "shell-local" {
        inline = [
            "mkdir -p ${local.vm_repo_path}",
            "cp ${local.output_dir}/${local.vm_name} ${local.vm_repo_url}.img"
        ]
    }
}

build {
    name = "ansible-remote"
    sources = [ "source.null.ansible" ]

    provisioner "ansible-local" {
        playbook_dir = "ansible"
        playbook_file = "ansible/playbook.yaml"
        extra_arguments = ["-e operation=${var.ansible_operation} -v"]
        command = "/home/ubuntu/python-venv/ansible/bin/ansible-playbook"
#      ansible_ssh_extra_args = [ "-o StrictHostKeyChecking=no -o PubkeyAcceptedKeyTypes=+ssh-rsa -o HostkeyAlgorithms=+ssh-rsa"]
#      local_port = "${var.ansible_ssh_port}"
    }
}

build {
    sources = ["source.digitalocean.example"]

    provisioner "shell" {
        scripts = [ "scripts/python.sh" ]
    }

    provisioner "ansible-local" {
        playbook_dir = "ansible"
        playbook_file = "ansible/playbook.yaml"
        extra_arguments = ["-e operation=${var.ansible_operation} -v"]
        command = "/home/ubuntu/python-venv/ansible/bin/ansible-playbook"
#      ansible_ssh_extra_args = [ "-o StrictHostKeyChecking=no -o PubkeyAcceptedKeyTypes=+ssh-rsa -o HostkeyAlgorithms=+ssh-rsa"]
    }
}