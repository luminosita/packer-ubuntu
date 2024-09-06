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

    values = [
        "k8sServiceHost: ${var.cluster.ctrl_ips[0]}",
        "k8sServicePort: 6443",
        "kubeProxyReplacement: true"
    ]
}

