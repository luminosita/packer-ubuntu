terraform {
  required_version = ">= 1.9.5"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.32.0"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }

    external = {
        source = "hashicorp/external"
        version = "2.3.3"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.15.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.40.0"
    }
  }
}

locals {
  istio_namespace = "istio-system"
  istio_version   = "1.23"
  istio_repo      = "https://raw.githubusercontent.com/istio/istio/release-"
  dash_version    = "v7.5.0"
  dash_repo       = "https://raw.githubusercontent.com/kubernetes/dashboard/"

  modules = [
    for moduleName in split(",", var.module) : trimspace(moduleName)
  ]
}

output "modules" {
  value = local.modules
}

# provider "kubernetes" {
#   config_path    = "~/.kube/config"
#   config_context = "default"
# }

provider "digitalocean" {
  token = var.api_token
}

module "k3s" {
  source = "./modules/k3s"

  count = contains(local.modules, "k3s") ? 1 : 0

  vm_server_base_image    = var.vm_server_base_image
  vm_agent_base_image     = var.vm_agent_base_image
  vm_server_name          = var.vm_server_name
  vm_agent_name           = var.vm_agent_name

  do_ssh_key_name         = var.do_ssh_key_name
  do_region               = var.do_region
  do_size                 = var.do_size

  k3s_server_token_file   = var.k3s_server_token_file
}

module "istio-cert-manager-module" {
  source = "./modules/istio-cert-manager"

  count = contains(local.modules, "istio-cert-manager") ? 1 : 0

  istio_namespace = local.istio_namespace
  ingress_domain  = var.ingress_domain
}

module "istio-bookinfo-module" {
  source = "./modules/istio-bookinfo"

  count = contains(local.modules, "istio-bookinfo") ? 1 : 0

  istio_version   = local.istio_version
  istio_repo      = local.istio_repo
  istio_namespace = local.istio_namespace
}

module "istio-addons-module" {
  source = "./modules/istio-addons"

  count = contains(local.modules, "istio-addons") ? 1 : 0

  istio_version  = local.istio_version
  istio_repo     = local.istio_repo
  ingress_domain = var.ingress_domain
}

module "k8s-dashboard" {
  source = "./modules/k8s-dashboard"

  count = contains(local.modules, "k8s-dashboard") ? 1 : 0

  dash_version   = local.dash_version
  dash_repo      = local.dash_repo
  ingress_domain = var.ingress_domain
}
