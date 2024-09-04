terraform {
  required_providers {
    kubernetes = {
        source  = "hashicorp/kubernetes"
        version = ">= 2.32.0"
    }
  }
}

resource "kubernetes_manifest" "cert_manager_clusterissuer" {
    manifest = {
        "apiVersion" = "cert-manager.io/v1"
        "kind"       = "ClusterIssuer"
        "metadata" = {
            "name"      = "selfsigned-issuer"
        }
        "spec" = {
            "selfSigned" = {}
        }
    }  
}  

resource "kubernetes_manifest" "cert_manager_certificate" {
    manifest = {
        "apiVersion" = "cert-manager.io/v1"
        "kind" = "Certificate"
        "metadata" = {
            "name" = "my-selfsigned-ca"
            "namespace" = "${var.istio_namespace}"
        }

        "spec" = {
            "isCA" = true
            "commonName" = "my-selfsigned-ca"
            "secretName" = "root-secret"
            "privateKey" = {
                "algorithm" = "ECDSA"
                "size" = 256
            }
            "issuerRef" = {
                "name" = "selfsigned-issuer"
                "kind" = "ClusterIssuer"
                "group" = "cert-manager.io"
            }
        }
    }
}

resource "kubernetes_manifest" "cert_manager_ca_issuer" {
    manifest = {
        "apiVersion" = "cert-manager.io/v1"
        "kind" = "Issuer"
        "metadata" = {
            "name" = "my-ca-issuer"
            "namespace" = "${var.istio_namespace}"
        }
        "spec" = {
            "ca" = {
                "secretName" = "root-secret"
            }
        }
    }
}

resource "kubernetes_manifest" "cert_manager_gw_certificate" {
    manifest = {
        "apiVersion" = "cert-manager.io/v1"
        "kind" = "Certificate"
        "metadata" = {
            "name" = "telemetry-gw-cert"
            "namespace" = "${var.istio_namespace}"
        }
        "spec" = {
            "commonName" = "telemetry-gw-cert"
            "secretName" = "telemetry-gw-secret"
            "privateKey" = {
                "algorithm" = "ECDSA"
                "size" = "256"
            }
            "issuerRef" = {
                "name" = "my-ca-issuer"
                "kind" = "Issuer"
                "group" = "cert-manager.io"
            }
            "dnsNames" = [
                "${var.ingress_domain}",
                "*.${var.ingress_domain}"
            ]
        }
    }
}