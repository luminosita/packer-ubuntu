vm_name                 = "k3s-server-ubuntu-noble"

vm_base_image           = "ubuntu-24-04-x64" 

ssh_username            = "k3s"
do_ssh_key_id           = 42814638
ssh_public_key_file     = "~/.ssh/id_rsa.pub"
ssh_private_key_file    = "~/.ssh/id_rsa"

script_env = {
    "K3S_KUBECONFIG_MODE" = "644",
    "K3S_INSTALL_EXEC" = "--flannel-backend=none --cluster-cidr=\"10.100.0.0/16\" --disable-network-policy --disable=traefik",
    "INSTALL_K3S_SKIP_START" = "true"
}

scripts = [
    "../common/scripts/init.sh",
    "../common/scripts/k3s.sh",
    "../common/scripts/istio.sh",
]


