terraform {
    required_providers {
        helm = {
            source  = "hashicorp/helm"
        }
    }
}

resource "helm_release" "cilium" {
    name        = "cilium"
    repository  = "https://helm.cilium.io/"
    chart       = "cilium"
    version     = "1.16.1"

    create_namespace  = true
    namespace         = "kube-system"

    values = ["${templatefile("${path.module}/resources/values.yaml.tftpl", {
        ctrl_ip = var.cluster.ctrl_ips[0]
        })}"
    ]
}

