vm_name              = "k3s-server-ubuntu-noble"

vm_base_image        = "ubuntu-24-04-x64" 

script_env = {
    "K3S_KUBECONFIG_MODE" = "644",
    "K3S_INSTALL_EXEC" = "--flannel-backend=none --cluster-cidr=\"10.100.0.0/16\" --disable-network-policy --disable=traefik",
    "INSTALL_K3S_SKIP_START" = "true"
}

scripts = [
    "scripts/init.sh",
    "scripts/k3s.sh",
    "scripts/istio.sh",
]


