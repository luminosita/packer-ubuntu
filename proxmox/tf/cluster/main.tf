terraform {
    required_version = ">= 1.9.5"

    required_providers {
        kustomization = {
            source = "kbst/kustomization"
            version = "0.9.6"
        }
        helm = {
            source  = "hashicorp/helm"
            version = ">= 2.15.0"
        }
    }
}

provider "helm" {
    kubernetes {
        config_path    = var.kube_config_file
        config_context = "default"
    }
}
provider "kustomization" {
    kubeconfig_path    = var.kube_config_file
}

module "cilium" {
    source = "../../../common/tf/modules/cilium"

    ctrl_ip = var.cluster.ctrl_ips[0]
}

module "gateway-api" {
    source = "../../../common/tf/modules/gateway-api"
}

module "cert-manager" {
    source = "../../../common/tf/modules/cert-manager"
}

module "gateway" {
    source = "../../../common/tf/modules/gateway"
}

# module "k8s-dashboard" {
#     depends_on = [ module.cert-manager ]
#     source = "../../common/tf/modules/k8s-dashboard"

#     ingress_domain = var.k3s.ingress_domain
# }

