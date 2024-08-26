variable "api_token" {
    type    = string
    default = ""
}

variable "vm_server_base_image" {
    type    = string
    default = "ubuntu-24-04-x64"
}

variable "vm_agent_base_image" {
    type    = string
    default = "ubuntu-24-04-x64"
}

variable "vm_server_name" {
    type    = string
    default = "k3s-server-ubuntu-noble"
}

variable "vm_agent_name" {
    type    = string
    default = "k3s-agent-ubuntu-noble"
}

variable "do_ssh_key_name" {
    type    = string
}

variable "do_region" {
    type    = string
    default = "fra1"
}          

variable "do_size" {
    type    = string
    default = "s-2vcpu-4gb"
}            

variable "k3s_server_token_file" {
    type    = string
    default = "../../k3s-server.token"
}            

variable "ingress_domain" {
  type = string
  default = "k3s.local"
}

variable "module" {
  type = string
}