# terraform {
#     required_providers {
#         kustomization = {
#             source = "kbst/kustomization"
#             version = "0.9.6"
#         }
#     }
# }

# data "kustomization_build" "cert_manager" {
#     kustomize_options {
#         enable_helm = true
#         helm_path = "helm"
#         load_restrictor = "none"
#     }

#     path = "${path.module}/resources"
# }

# resource "kustomization_resource" "cilium" {
#     for_each = data.kustomization_build.cert_manager.ids

#     manifest = data.kustomization_build.cert_manager.manifests[each.value]
# }


terraform {
    required_providers {
        helm = {
            source  = "hashicorp/helm"
        }
    }
}

resource "helm_release" "cert_manager" {
    name        = "cert-manager"
    repository  = "https://charts.jetstack.io"
    chart       = "cert-manager"
    version     = "v1.15.3"

    create_namespace  = true
    namespace         = "cert-manager"

    set {
        name  = "crds.enabled"
        value = "true"
    }

    set {
        name  = "extraArgs[0]"
        value = "--enable-gateway-api"
    }
}


