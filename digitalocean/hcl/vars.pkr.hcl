variable "api_token" {
    type    = string
    default = env("API_TOKEN")
}

variable "k3s_token" {
    type    = string
    default = env("K3S_TOKEN")
}

variable "k3s_cluster_cidr" {
    type    = string
    default = env("K3S_CLUSTER_CIDR")
}

variable "k3s_server_ip" {
    type    = string
    default = env("K3S_SERVER_IP")
}

variable "vm_base_image" {
    type    = string
    default = "ubuntu-22-04-x64"
}

variable "vm_name" {
    type = string
}

variable "vm_version" {
    type    = string
    default = "1.0"
}

variable "do_region" {
    type    = string
    default = "fra1"
}          

variable "do_size" {
    type    = string
    default = "s-2vcpu-4gb"
}            

variable "scripts" {
    type    = list(string)
}            

locals {
    vm_snapshot_name = "${var.vm_name}-${formatdate("YYYY_DD_MM, hh:mm", timestamp())}"
}