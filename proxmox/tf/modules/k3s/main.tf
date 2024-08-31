terraform {
    required_providers {
        proxmox = {
            source = "Telmate/proxmox"
        }

        external = {
            source = "hashicorp/external"
        }
            
        local = {
            source = "hashicorp/local"
        }
            
        null = {
            source = "hashicorp/null"
        }
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

resource "proxmox_lxc" "k3s_server" {
    target_node     = var.prox_target_node
    hostname        = var.vm_server_name
    unprivileged    = true

    clone           = var.prox_template_vmid
    clone_storage   = var.prox_storage

#    pool            = var.prox_pool

    full            = true

    vmid            = 2000

    rootfs {
        storage = "local-zfs"
        size    = "20G"
    }

    # network {
    #     name   = "eth0"
    #     bridge = "vmbr0"
    #     ip     = "dhcp"
    # }
}

resource "proxmox_lxc" "k3s_agent" {
    count = 2

    target_node     = var.prox_target_node
    hostname        = "${var.vm_agent_name}-${count.index+1}"
    unprivileged    = true

    clone           = var.prox_template_vmid
    clone_storage   = var.prox_storage

#    pool            = var.prox_pool

    full            = true

    vmid            = 2000 + count.index + 1

    rootfs {
        storage = "local-zfs"
        size    = "20G"
    }

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
}

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
#         host = proxmox_lxc.k3s_server.vmid]
#         user = var.ssh_username
#         type = "ssh"
#         private_key = file(var.ssh_private_key_file)
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
