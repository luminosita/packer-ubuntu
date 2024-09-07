terraform {
    required_providers {
        kustomization = {
            source = "kbst/kustomization"
            version = "0.9.6"
        }
    }
}

data "kustomization_build" "gateway" {
    path = "${path.module}/resources"
}

resource "kustomization_resource" "gateway" {
    for_each = data.kustomization_build.gateway.ids

    manifest = data.kustomization_build.gateway.manifests[each.value]
}
