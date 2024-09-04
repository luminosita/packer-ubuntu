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
}

resource "helm_release" "istiod" {
  name        = "istiod"
  repository  = "https://istio-release.storage.googleapis.com/charts"
  chart       = "istiod"
  version     = "1.23.0"

  create_namespace  = true
  namespace         = "istio-system"
}

resource "helm_release" "gateway" {
  name        = "istio-ingressgateway"
  repository  = "https://istio-release.storage.googleapis.com/charts"
  chart       = "gateway"
  version     = "1.23.0"

  create_namespace  = true
  namespace         = "istio-system"
}