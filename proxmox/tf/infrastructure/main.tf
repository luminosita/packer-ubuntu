terraform {
    required_version = ">= 1.9.5"

    required_providers {
        kustomization = {
            source = "kbst/kustomization"
            version = "0.9.6"
        }
        local = {
            source  = "hashicorp/local"
            version = ">= 2.5.1"
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

provider "helm" {
    kubernetes {
        config_path    = var.k3s.kube_config_file
        config_context = "default"
    }
}
provider "kustomization" {
    kubeconfig_path    = var.k3s.kube_config_file
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
    }

    tmp_dir = "/var/tmp"
}

module "proxmox" {
    source = "../../../common/tf/modules/proxmox"

    proxmox = var.proxmox
    k3s     = var.k3s
}

module "k3s" {
    source = "../../../common/tf/modules/k3s"

    k3s     = var.k3s

    cluster = module.proxmox.ip_addresses
}

