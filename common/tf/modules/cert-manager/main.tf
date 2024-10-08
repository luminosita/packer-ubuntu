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


