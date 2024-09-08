terraform {
    required_providers {
        kustomization = {
            source = "kbst/kustomization"
        }
    }
}

data "kustomization_build" "test" {
    path = "${path.module}/resources/"
}

resource "kustomization_resource" "test" {
    for_each = data.kustomization_build.test.ids

    manifest = data.kustomization_build.test.manifests[each.value]
}
