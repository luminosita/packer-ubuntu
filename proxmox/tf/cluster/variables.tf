variable "kube_config_file" {
    type = string
    default = "/tmp/config"
}

variable cluster {
    type       = object({
        ctrl_ips = list(string)
        work_ips  = list(string)
    })
}
