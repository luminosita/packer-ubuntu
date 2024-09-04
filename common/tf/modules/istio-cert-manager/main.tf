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
            "namespace" = "default"
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

resource "kubernetes_manifest" "cert_manager_certificate" {
    manifest = {
        "apiVersion" = "cert-manager.io/v1"
        "kind" = "Issuer"
        "metadata" = {
            "name" = "my-ca-issuer"
        }
        "spec" = {
            "ca" = {
                "secretName" = "root-secret"
            }
        }
    }
}

resource "kubernetes_manifest" "cert_manager_certificate" {
    manifest = {
        "apiVersion" = "cert-manager.io/v1"
        "kind" = "Certificate"
        "metadata" = {
            "name" = "telemetry-gw-cert"
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
                "${INGRESS_DOMAIN}",
                "*.${INGRESS_DOMAIN}"
            ]
        }
    }
}