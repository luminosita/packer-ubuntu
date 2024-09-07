terraform {
    required_providers {
        helm = {
            source  = "hashicorp/helm"
        }
        kubernetes = {
            source  = "hashicorp/kubernetes"
        }
    }
}

locals {
    dash_ns = "kubernetes-dashboard"
}

resource "helm_release" "kubernetes-dashboard" {
    name        = "kubernetes-dashboard"
    repository  = "https://kubernetes.github.io/dashboard/"
    chart       = "kubernetes-dashboard"
    version     = "7.5.0"

    create_namespace  = true
    namespace         = local.dash_ns

    set {
        name  = "crds.enabled"
        value = "true"
    }
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

resource "helm_release" "kubernetes-gateway" {
    name        = "k8s-dashboard-gateway"
    chart       = "${path.root}/../../common/helm/k8s-dashboard-gateway"
    version     = "0.1.0"

    create_namespace  = true
    namespace   = local.dash_ns
}

