terraform {
  required_providers {
    helm = {
        source  = "hashicorp/helm"
    }
 }
}

# locals {
#   valuesPath = "${path.module}/resources/values.yaml"
# }

resource "helm_release" "istio-base" {
  name        = "base"
  repository  = "https://istio-release.storage.googleapis.com/charts"
  chart       = "base"
  version     = "1.23.0"

  create_namespace  = true
  namespace         = "istio-system"

  # values = [
  #   "${file(local.valuesPath)}"
  # ]
}

resource "helm_release" "istiod" {
  name        = "istiod"
  repository  = "https://istio-release.storage.googleapis.com/charts"
  chart       = "istiod"
  version     = "1.23.0"

  create_namespace  = true
  namespace         = "istio-system"

  # values = [
  #   "${file(local.valuesPath)}"
  # ]
}