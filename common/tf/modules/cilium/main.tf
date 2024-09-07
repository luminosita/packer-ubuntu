terraform {
    required_providers {
        kustomization = {
            source = "kbst/kustomization"
            version = "0.9.6"
        }
    }
}

# data "kustomization_build" "cilium" {
#     kustomize_options {
#         enable_helm = true
#         helm_path = "helm"
#         load_restrictor = "none"
#     }

#     path = "${path.module}/resources"
# }

# resource "kustomization_resource" "cilium" {
#     for_each = data.kustomization_build.cilium.ids

#     manifest = data.kustomization_build.cilium.manifests[each.value]
# }

data "kustomization_overlay" "cilium" {
    kustomize_options {
        enable_helm = true
        helm_path = "helm"
        load_restrictor = "none"
    }
    
    resources = [
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
