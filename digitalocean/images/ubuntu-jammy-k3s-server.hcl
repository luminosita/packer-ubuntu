vm_name              = "k3s-server-ubuntu-noble"

vm_base_image        = "ubuntu-24-04-x64" 

#vm_base_version     = "1.0"

#ansible_operation   = "bootstrap,server,network,certmgr,config,istio"

// ansible_ssh_host        = "localhost"
// ansible_ssh_port        = 60022
// ansible_ssh_username    = "ubuntu"
// ansible_ssh_password    = "ubuntu"

scripts = [
    "digitalocean/scripts/init.sh",
    "digitalocean/scripts/k3s.sh",
    "digitalocean/scripts/istio.sh",
]


