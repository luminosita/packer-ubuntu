terraform {
    required_providers {
        local = {
            source  = "hashicorp/local"
        }

        helm = {
            source  = "hashicorp/helm"
        }

        null = {
            source  = "hashicorp/null"
        }

    }
}

resource "null_resource" "k3sup-ctrl" {
    count = length(var.cluster.ctrl_ips)
    provisioner "local-exec" {
        command = "k3sup install --ip ${var.cluster.ctrl_ips[count.index]} ${local.k3sup_ctrl_args}"
    }  
}

module "cilium" {
    depends_on = [ null_resource.k3sup-ctrl ]
    source = "../../../../common/tf/modules/cilium"

    k3s     = var.k3s

    cluster = var.cluster
}

resource "null_resource" "k3sup-work" {
    depends_on = [ module.cilium ]

    count = length(var.cluster.work_ips)
    provisioner "local-exec" {
        command = "k3sup join --ip ${var.cluster.work_ips[count.index]} --server-ip ${var.cluster.ctrl_ips[0]} ${local.k3sup_work_args}"
    }
}

