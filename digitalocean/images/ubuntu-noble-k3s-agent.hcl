vm_name              = "k3s-agent-ubuntu-noble"

vm_base_image        = "ubuntu-24-04-x64" 

// vm_base_version     = "1.0"

// ansible_operation   = "bootstrap,agent"

// ansible_ssh_host        = "localhost"
// ansible_ssh_port        = 60022
// ansible_ssh_username    = "ubuntu"
// ansible_ssh_password    = "ubuntu"

script_env = {
    "K3S_TOKEN"                 = "TOKEN"
    "K3S_URL"                   = "https://127.0.0.1:6443"
    "INSTALL_K3S_SKIP_START"    = "true"
}

scripts = [
    "digitalocean/scripts/init.sh",
    "digitalocean/scripts/k3s.sh"
]
