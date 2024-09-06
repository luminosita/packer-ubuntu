variable cluster {
    type       = object({
        ctrl_ips = list(string)
        work_ips  = list(string)
    })
}

variable "k3s" {
    type        = object({
        vm_user = string
        vm_ssh_public_key_files = list(string)

        version           = string
        cluster_cidr      = string
        ingress_domain    = string
        kube_config_file  = string
    })
}

