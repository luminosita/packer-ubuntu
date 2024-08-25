vm_name              = "k3s-server-ubuntu-noble"

vm_base_image        = "ubuntu-24-04-x64" 

#vm_base_version     = "1.0"

#ansible_operation   = "bootstrap,server,network,certmgr,config,istio"

// ansible_ssh_host        = "localhost"
// ansible_ssh_port        = 60022
// ansible_ssh_username    = "ubuntu"
// ansible_ssh_password    = "ubuntu"

script_env = {
    "K3S_INSTALL_EXEC"  = "--flannel-backend=none --cluster-cidr=\"10.100.0.0/16\" --disable-network-policy --disable=traefik",
    "INSTALL_K3S_SKIP_START"    = "true"
}

scripts = [
    "digitalocean/scripts/init.sh",
    "digitalocean/scripts/k3s.sh",
    "digitalocean/scripts/istio.sh",
]


