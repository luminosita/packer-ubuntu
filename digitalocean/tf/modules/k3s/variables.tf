variable "vm_server_base_image" {
    type    = string
}

variable "vm_agent_base_image" {
    type    = string
}

variable "vm_server_name" {
    type    = string
}

variable "vm_agent_name" {
    type    = string
}

variable "do_ssh_key_name" {
    type    = string
}

variable "do_region" {
    type    = string
}          

variable "do_size" {
    type    = string
}            

variable "k3s_server_token_file" {
    type    = string
}            

variable "pvt_key" {
    type = string
    default = "~/.ssh/id_rsa"
}

locals {
}

