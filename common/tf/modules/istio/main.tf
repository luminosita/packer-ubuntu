terraform {
    required_providers {
        helm = {
            source  = "hashicorp/helm"
        }
    }
}

locals {
    istio_ns = "istio-system"
    istio_ingress_ns = "istio-ingress"
}

resource "helm_release" "istio_base" {
    name        = "base"
    repository  = "https://istio-release.storage.googleapis.com/charts"
    chart       = "base"
    version     = "1.23.0"

    create_namespace  = true
    namespace         = local.istio_ns
}

resource "helm_release" "istiod" {
    name        = "istiod"
    repository  = "https://istio-release.storage.googleapis.com/charts"
    chart       = "istiod"
    version     = "1.23.0"

    create_namespace  = true
    namespace         = local.istio_ns
}

resource "helm_release" "gateway" {
    name        = "istio-ingressgateway"
    repository  = "https://istio-release.storage.googleapis.com/charts"
    chart       = "gateway"
    version     = "1.23.0"

    create_namespace  = true
    namespace         = local.istio_ingress_ns
}

resource "kubernetes_manifest" "cert_manager_clusterissuer" {
    manifest = {
        "apiVersion" = "cert-manager.io/v1"
        "kind" = "ClusterIssuer"
        "metadata" = {
            "name" = "letsencrypt-staging-cluster"
        }
        "spec" = {
            "acme" = {
                "email" = "milosh@emisia.net"
                "server" = "https://acme-staging-v02.api.letsencrypt.org/directory"
                "privateKeySecretRef" = {
                    "name" = "letsencrypt-staging-cluster"
                }
                "solvers" = [{
                    "http01" = {
                        "ingress" = {
                            "class" = "istio"
                        }
                    }
                }]
            }
        }
    }  
}  
