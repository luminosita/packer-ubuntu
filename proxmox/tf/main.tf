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

        proxmox = {
            source  = "bpg/proxmox"
            version = "0.63.0"
        }    
    }
}

locals {
    modules = [
      for moduleName in split(",", var.module) : trimspace(moduleName)
    ]
}

output "modules" {
    value = local.modules
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "default"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "proxmox" {
//    alias    = "euclid"
    endpoint = var.proxmox.endpoint
    insecure = var.proxmox.insecure

    api_token = "${var.api_token_id}=${var.api_token_secret}"
    ssh {
        agent               = false
        username            = var.proxmox.ssh_username
        private_key         = file(var.proxmox.ssh_private_key_file)
        socks5_server       = var.proxmox.socks5_server
    }

    tmp_dir = "/var/tmp"
}

module "k3s" {
    source = "./modules/k3s"

    count = contains(local.modules, "k3s") ? 1 : 0

    proxmox                 = var.proxmox

    vm_user                 = var.vm_user
    vm_ssh_public_key_file     = var.vm_ssh_public_key_file

    cluster_cidr            = var.cluster_cidr
}

module "calico" {
    source = "../../common/tf/modules/calico"

    count = contains(local.modules, "calico") ? 1 : 0

    cluster_cidr = var.cluster_cidr
}

module "cert-manager" {
    source = "../../common/tf/modules/cert-manager"

    count = contains(local.modules, "cert-manager") ? 1 : 0
}

module "istio" {
    source = "../../common/tf/modules/istio"

    count = contains(local.modules, "istio") ? 1 : 0

    ingress_domain = var.ingress_domain
}

module "k8s-dashboard" {
    source = "../../common/tf/modules/k8s-dashboard"

    count = contains(local.modules, "k8s-dashboard") ? 1 : 0

    ingress_domain = var.ingress_domain
}

