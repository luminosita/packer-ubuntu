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

variable "module" {
  type = string
}

###############################  API ##############################
variable "api_token_id" {
    type    = string
}

variable "api_token_secret" {
    type    = string
}

###############################  VM Settings ##############################
variable "vm_user" {
  description = "VM username"
  type        = string
}

variable "vm_ssh_public_key_file" {
    type = string
}

###############################  K3s Settings ##############################
variable "k3s_version" {
  type = string
  default = "v1.30"
}

variable "ingress_domain" {
  type = string
  default = "k3s.lan"
}

variable "cluster_cidr" {
  type = string
}

