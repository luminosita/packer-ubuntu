api_token_id            = "root@pam!terraform"

proxmox = {
    node_name   = "proxmox"
    endpoint    = "https://proxmox.wan:8006"
    insecure    = true

    ssh_host                = "proxmox.wan"
    ssh_username            = "root"
    ssh_private_key_file    = "~/.ssh/id_rsa"
    socks5_server           = "localhost:8002"
}

vm_user                     = "k3s"
vm_ssh_public_key_file      = "~/.ssh/id_rsa.proxmox.pub"

ingress_domain          = "k3s.emisia.net"
cluster_cidr            = "10.100.0.0/16"



