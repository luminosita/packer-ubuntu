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

variable cluster {
    type       = object({
        ctrl_ips = list(string)
        work_ips  = list(string)
    })
}

locals {
  k3s_extra_args = <<-EOT
  --write-kubeconfig-mode 644 --write-kubeconfig ~/.kube/config --flannel-backend=none --cluster-cidr=${var.k3s.cluster_cidr} --disable traefik --disable-network-policy --disable servicelb --disable-kube-proxy
  EOT

#   k3sup_master_ctrl_args = <<-EOT
#   --cluster-init --user ${var.k3s.vm_user} --k3s-channel ${var.k3s.version} --k3s-extra-args "${local.k3s_extra_args}" --local-path ${var.k3s.kube_config_file}
#   EOT

  k3sup_ctrl_args = <<-EOT
  --user ${var.k3s.vm_user} --k3s-channel ${var.k3s.version} --k3s-extra-args "${local.k3s_extra_args}" --local-path ${var.k3s.kube_config_file}
  EOT

  k3sup_work_args = <<-EOT
  --user ${var.k3s.vm_user} --k3s-channel ${var.k3s.version}
  EOT
}
