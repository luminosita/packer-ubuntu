variable "vm_server_name" {
    type    = string
}

variable "vm_agent_name" {
    type    = string
}

variable "prox_template_vmid" {
    type    = string
}

variable "prox_target_node" {
    type    = string
}          

variable "prox_storage" {
    type    = string
}            

variable "prox_pool" {
    type    = string
}            

variable "ssh_username" {
    type    = string
}

variable "ssh_private_key_file" {
    type = string
}

variable "ssh_bastion_host" {
    type    = string
    default = ""
}

variable "ssh_bastion_username" {
    type    = string
    default = ""
}

variable "ssh_bastion_private_key_file" {
    type = string
    default = ""
}

locals {
}

