terraform {
    required_providers {
        kustomization = {
            source = "kbst/kustomization"
        }
    }
}

data "kustomization_overlay" "cilium" {
    kustomize_options {
        enable_helm = true
        helm_path = "helm"
        load_restrictor = "none"
    }
    
    resources = [
        "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml",
        "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/experimental/gateway.networking.k8s.io_gateways.yaml",
        "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml",
        "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml",
        "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml",
        "https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml",
        "${path.module}/resources/announce.yaml",
        "${path.module}/resources/ip-pool.yaml"
    ]
    
    helm_charts {
        name = "cilium"
        version = "1.16.1"
        repo = "https://helm.cilium.io/"
        release_name = "cilium"
        namespace = "kube-system"
        include_crds = true
        values_inline = templatefile("${path.module}/resources/values.yaml.tftpl", {
            ctrl_ip = var.ctrl_ip
        })
    }
}

resource "kustomization_resource" "cilium" {
    for_each = data.kustomization_overlay.cilium.ids

    manifest = data.kustomization_overlay.cilium.manifests[each.value]
}
