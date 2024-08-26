variable "api_token" {
    type    = string
    default = env("API_TOKEN")
}

variable "vm_base_image" {
    type    = string
    default = "ubuntu-24-04-x64"
}

variable "vm_name" {
    type = string
}

variable "vm_version" {
    type    = string
    default = ""
}

variable "do_region" {
    type    = string
    default = "fra1"
}          

variable "do_size" {
    type    = string
    default = "s-2vcpu-4gb"
}            

variable "script_env" {
    type = map(string)
}            

variable "scripts" {
    type = list(string)
}            

locals {
    vm_snapshot_name = "${var.vm_name}-${var.vm_version}"
    vm_version = var.vm_version == "" ? formatdate("YYYY_DD_MM, hh:mm", timestamp()) : var.vm_version
}