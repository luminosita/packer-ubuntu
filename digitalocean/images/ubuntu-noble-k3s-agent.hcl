vm_name              = "k3s-agent-ubuntu-noble"

vm_base_image        = "ubuntu-24-04-x64" 

script_env = {
    "K3S_TOKEN"                 = "K3STOKEN"
    "K3S_URL"                   = "https://K3SIP:6443"
    "INSTALL_K3S_SKIP_ENABLE"   = "true"
    "INSTALL_K3S_SKIP_START"    = "true"
}

scripts = [
    "scripts/init.sh",
    "scripts/k3s.sh"
]
