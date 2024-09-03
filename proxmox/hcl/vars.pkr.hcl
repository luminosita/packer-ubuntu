########################## proxmox login credentials ##########################
variable "proxmox_node" {
  type = string
}

variable "proxmox_user" {
  type = string
  default = "root@pam!packer-build"
}

variable "proxmox_api_user" {
  type = string
  default = "root@pam"
}

variable "proxmox_token_id" {
  type = string
  default = "terraform"
}

variable "proxmox_token" {
  type = string
  default = env("API_TOKEN")
}

variable "proxmox_url" {
  type = string
}

variable "proxmox_api_host" {
  type = string
}

######################## SSH definitions ####################################

variable "ssh_username" {
  type = string
}

variable "ssh_private_key_file" {
  type = string
}

variable "ssh_bastion_host" {
  type = string
  default = ""
}

variable "ssh_bastion_username" {
  type = string
  default = ""
}

variable "ssh_bastion_private_key_file" {
  type = string
  default = ""
}

######################## VM definitions ####################################

variable "vm_id" {
  type    = number
}

variable "vm_clone_id" {
  type    = number
}

variable "vm_template_name" {
  type = string
}

variable "vm_template_description" {
  type = string
}

variable "vm_pool" {
  type    = string
  default = ""
}

variable "vm_version" {
    type    = string
    default = env("VM_VERSION")
}

######################## VM hardware definitions ##############################
######## disk drive definitions #######
variable "vm_disk_storage_pool" {
  type = string
}

variable "vm_disk_type" {
  type    = string
  default = "scsi"
}

variable "vm_disk_size" {
  type = string
}

variable "vm_disk_cache_mode" {
  type    = string
  default = "none"
}

variable "vm_disk_format" {
  type    = string
  default = "raw"
}

variable "vm_disk_io_thread" {
  type    = bool
  default = false
}

variable "vm_scsi_controller" {
  type = string
  # scsi_controller = "virtio-scsi-pci"
  default = "virtio-scsi-single"
}

variable "vm_guest_disk_drive" {
  type    = string
  default = "/dev/vda"
}

########### CPU and memory  ###########
variable "cpu_type" {
  type    = string
  default = ""
}

variable "vm_cores" {
  type    = string
  default = "2"
}

variable "vm_memory" {
  type    = string
  default = "2048"
}

############# vm networking ###########
variable "vm_net_mac_address" {
  type    = string
  default = "be:ef:ca:fe:c0:c0"
}

variable "vm_net_model" {
  type    = string
  default = "virtio"
}

variable "vm_net_bridge" {
  type    = string
  default = "vmbr0"
}

######### display serial device ######
variable "vm_serial_device" {
  type    = string
  default = "serial0"
}

####################### # Scripts ########################################

variable "script_env" {
    type = map(string)
}            

variable "scripts" {
    type = list(string)
}            

locals {
    vm_version = var.vm_version == "" ? formatdate("YYYY_DD_MM, hh:mm", timestamp()) : var.vm_version
    vm_template_name = "${var.vm_template_name}-${local.vm_version}"
}







