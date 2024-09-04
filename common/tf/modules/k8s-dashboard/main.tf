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
  dash_namespace = "kubernetes-dashboard"
}

resource "helm_release" "kubernetes-dashboard" {
  name        = "kubernetes-dashboard"
  repository  = "https://kubernetes.github.io/dashboard/"
  chart       = "kubernetes-dashboard"
  version     = "7.5.0"

  create_namespace  = true
  namespace         = local.dash_namespace

  set {
    name  = "crds.enabled"
    value = "true"
  }
}

resource "kubernetes_labels" "kubernetes_dashboard_namespace_istio_injection" {
  api_version = "v1"
  kind        = "Namespace"

  metadata {
    name = "${helm_release.kubernetes-dashboard.namespace}"
  }

  labels = {
    istio-injection = "enabled"
  }
}

resource "kubernetes_manifest" "kubernetes_dashboard_gateway" {
    manifest = {
        "apiVersion" = "networking.istio.io/v1beta1"
        "kind" = "Gateway"
        "metadata" = {
            "name" = "dashboard-gateway"
            "namespace" = "${helm_release.kubernetes-dashboard.namespace}"
        }
        "spec" = {
            "selector" = {
                "istio" = "ingressgateway" # use istio default ingress gateway
            }
            "servers" = [{
                "port" = {
                    "number" = "443"
                    "name" = "https"
                    "protocol" = "HTTPS"
                }
                "tls" = {
                    "mode" = "PASSTHROUGH"
                }
                "hosts" = [
                    "dashboard.${var.ingress_domain}"
                ]
            }]
        }
    }
}

resource "kubernetes_manifest" "kubernetes_dashboard_virtual_service" {
    manifest = {
        "apiVersion" = "networking.istio.io/v1beta1"
        "kind" = "VirtualService"
        "metadata" = {
            "name" = "kubernetes-dashboard"
            "namespace" = "${helm_release.kubernetes-dashboard.namespace}"
        }
        "spec" = {
            "hosts" = ["dashboard.${var.ingress_domain}"]
            "gateways" = ["dashboard-gateway"]
//            "http" = {}
            "tls" = [{
                "match" = [{
                    "port" = "443"
                    "sniHosts" = ["dashboard.${var.ingress_domain}"]
                }]
                "route" = [{
                    "destination" = {
                        "host" = "kubernetes-dashboard-kong-proxy.kubernetes-dashboard.svc.cluster.local"
                        "port" = {
                            "number" = "443"
                        }
                    }
                }]
            }]
        }
    }
}

resource "kubernetes_manifest" "kubernetes_dashboard_service_account" {
    manifest = {
        "apiVersion" = "v1"
        "kind" = "ServiceAccount"
        "metadata" = {
          "name" = "admin-user"
          "namespace" = "${helm_release.kubernetes-dashboard.namespace}"
        }
    }
}

resource "kubernetes_manifest" "kubernetes_dashboard_cluster_role_binding" {
    manifest = {
        "apiVersion" = "rbac.authorization.k8s.io/v1"
        "kind" = "ClusterRoleBinding"
        "metadata" = {
          "name" = "admin-user"
        }
        "roleRef" = {
          "apiGroup" = "rbac.authorization.k8s.io"
          "kind" = "ClusterRole"
          "name" = "cluster-admin"
        }
        "subjects" = [{
            "kind" = "ServiceAccount"
            "name" = "admin-user"
            "namespace" = "${helm_release.kubernetes-dashboard.namespace}"
        }]
    }
}