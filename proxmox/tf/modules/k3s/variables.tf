variable "proxmox" {
    description = "Proxmox server configuration"
    type        = object({
        node_name = string
        endpoint  = string
        insecure  = bool

        ssh_host                = string
        ssh_username            = string
        ssh_private_key_file    = string
        socks5_server           = string
    })
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

variable "cluster_cidr" {
  type = string
}

locals {
  k3s_extra_args = <<-EOT
  --write-kubeconfig-mode 644 --write-kubeconfig ~/.kube/config --flannel-backend=none
   --cluster-cidr=${var.cluster_cidr} --disable traefik
   --disable-network-policy --disable servicelb --disable-kube-proxy
  EOT

  k3sup_server_args = <<-EOT
  --user ${var.vm_user} --k3s-channel ${var.k3s_version} --k3s-extra-args ${local.k3s_extra_args} 
   --local-path /tmp/config"  
  EOT

  k3sup_agent_args = <<-EOT
  --user ${var.vm_user} --k3s-channel ${var.k3s_version}
  EOT
}
