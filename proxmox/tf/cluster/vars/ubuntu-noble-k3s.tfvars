api_token_id            = "root@pam!terraform"

proxmox = {
    node_name   = "proxmox"
    endpoint    = "https://proxmox.lan:8006"
    insecure    = true

    ssh_username            = "root"
    ssh_private_key_file    = "~/.ssh/id_rsa"
}

k3s = {
    vm_user                     = "k3s"
    vm_ssh_public_key_files     = [
        "~/.ssh/id_rsa.pub",
        "~/.ssh/id_rsa.proxmox.pub"
        ]
    
    vm_base_url                 = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    vm_base_image               = "noble-server-cloudimg-amd64.img"
    vm_base_image_checksum      = "ffafb396efb0f01b2c0e8565635d9f12e51a43c51c6445fd0f84ad95c7f74f9b"    
    vm_base_image_checksum_alg  = "sha256"

    version                 = "v1.30"
    ingress_domain          = "k3s.emisia.net"
    cluster_cidr            = "10.100.0.0/16"

    kube_config_file        = "/tmp/config"
}


