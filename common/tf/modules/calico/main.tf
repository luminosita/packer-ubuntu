terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }

    helm = {
        source  = "hashicorp/helm"
    }
 }
}

locals {
  valuesPath = "${path.module}/resources/values.yaml"
}

resource "helm_release" "calico-operator" {
  name        = "tigera-operator"
  repository  = "https://docs.tigera.io/calico/charts"
  chart       = "tigera-operator"
  version     = "v3.28.1"

  create_namespace  = true
  namespace         = "tigera-operator"

  values = [
    "${file(local.valuesPath)}"
  ]
}