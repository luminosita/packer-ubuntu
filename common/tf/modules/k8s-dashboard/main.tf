terraform {
    required_providers {
        kustomization = {
            source = "kbst/kustomization"
        }
        kubernetes = {
            source  = "hashicorp/kubernetes"
        }
    }
}

locals {
    dash_ns = "kubernetes-dashboard"
}

resource "kubernetes_labels" "kubernetes_dashboard_namespace_istio_injection" {
    api_version = "v1"
    kind        = "Namespace"

    metadata {
        name = "${local.dash_ns}"
    }

    labels = {
        istio-injection = "enabled"
    }
}

data "kustomization_build" "dashboard" {
    path = "${path.module}/resources"
}

resource "kustomization_resource" "dashboard" {
    for_each = data.kustomization_build.dashboard.ids

    manifest = data.kustomization_build.dashboard.manifests[each.value]
}

