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
    istio_ns = "istio-system"
    istio_ingress_ns = "istio-ingress"
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

resource "kubernetes_manifest" "public_gateway" {
    manifest = {
        "apiVersion" = "networking.istio.io/v1beta1"
        "kind" = "Gateway"
        "metadata" = {
            "name" = "public-gateway"
            "namespace" = local.istio_ingress_ns
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
                    "*.${var.ingress_domain}"
                ]
            },{
                "port" = {
                    "number" = "80"
                    "name" = "http"
                    "protocol" = "HTTP"
                }
                "hosts" = [
                    "*.${var.ingress_domain}"
                ]
            }]
        }
    }
}

resource "kubernetes_manifest" "cert_manager_gw_certificate" {
    manifest = {
        "apiVersion" = "cert-manager.io/v1"
        "kind" = "Certificate"
        "metadata" = {
            "name" = "gateway-cert-staging"
            "namespace" = "${local.dash_ns}"
        }
        "spec" = {
            "secretName" = "gateway-cert-staging"
            "isCA" = false
            "duration" = "2160h" # 90d
            "renewBefore" = "360h" # 15d
            "privateKey" = {
                "algorithm" = "RSA"
                "encoding" = "PKCS1"
                "size" = "2048"
            }
            "usages" = [ "server auth", "client auth" ]
            "issuerRef" = {
                "name" = "letsencrypt-staging-cluster"
                "kind" = "ClusterIssuer"
                "group" = "cert-manager.io"
            }
            "dnsNames" = [
                "${var.ingress_domain}",
                "*.${var.ingress_domain}"
            ]
        }
    }
}

resource "kubernetes_manifest" "kubernetes_dashboard_virtual_service" {
    manifest = {
        "apiVersion" = "networking.istio.io/v1beta1"
        "kind" = "VirtualService"
        "metadata" = {
            "name" = "kubernetes-dashboard"
            "namespace" = "${local.dash_ns}"
        }
        "spec" = {
            "hosts" = ["dashboard.${var.ingress_domain}"]
            "gateways" = ["${local.istio_ingress_ns}/public-gateway"]
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
          "namespace" = "${local.dash_ns}"
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
            "namespace" = "${local.dash_ns}"
        }]
    }
}