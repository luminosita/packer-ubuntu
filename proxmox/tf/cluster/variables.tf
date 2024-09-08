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
        vm_base_url                 = string
        vm_base_image               = string
        vm_base_image_checksum      = string
        vm_base_image_checksum_alg  = string

        vm_user = string
        vm_ssh_public_key_files = list(string)

        version           = string
        cluster_cidr      = string
        kube_config_file  = string
    })
}

###############################  API ##############################
variable "api_token_id" {
    type    = string
}

variable "api_token_secret" {
    type    = string
}

###############################  Modules ##############################
variable "module" {
    type    = string
}

locals {
  modules = [
    for moduleName in split(",", var.module) : trimspace(moduleName)
  ]
}