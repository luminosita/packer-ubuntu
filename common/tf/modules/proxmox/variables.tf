variable "proxmox" {
    description = "Proxmox server configuration"
    type        = object({
        node_name = string
        endpoint  = string
        insecure  = bool

        ssh_username            = string
        ssh_private_key_file    = string
    })
}

variable "k3s" {
    type        = object({
        vm_user = string
        vm_ssh_public_key_files = list(string)

        version           = string
        cluster_cidr      = string
        ingress_domain    = string
        kube_config_file  = string
    })
}

locals {
    //hardcoded MAC address for Mikrotik router statis lease
    ctrl_mac_address = ["BC:24:11:BD:3C:67"]
    work_mac_address = ["BC:24:11:A9:6A:39","BC:24:11:57:11:94"]
}
