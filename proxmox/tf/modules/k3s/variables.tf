variable "proxmox" {
    description = "Proxmox server configuration"
    type        = object({
        node_name = string
        endpoint  = string
        insecure  = bool

        ssh_username            = string
        ssh_private_key_file    = string
        socks5_server           = string
    })
}

variable "vm_user" {
  description = "VM username"
  type        = string
}

variable "ssh_public_key_file" {
    type = string
}
