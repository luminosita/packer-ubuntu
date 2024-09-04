variable "api_url" {
    type    = string
}

variable "api_token_id" {
    type    = string
}

variable "api_token_secret" {
    type    = string
}

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

variable "ingress_domain" {
  type = string
  default = "k3s.lan"
}

variable "module" {
  type = string
}