vm_name              = "k3s-agent-ubuntu-noble"

vm_base_image        = "ubuntu-24-04-x64" 

ssh_username            = "k3s"
do_ssh_key_id           = 42814638
ssh_public_key_file     = "~/.ssh/id_rsa.pub"
ssh_private_key_file    = "~/.ssh/id_rsa"

script_env = {
    "K3S_TOKEN"                 = "K3STOKEN"
    "K3S_URL"                   = "https://K3SIP:6443"
    "INSTALL_K3S_SKIP_ENABLE"   = "true"
    "INSTALL_K3S_SKIP_START"    = "true"
}

scripts = [
    "../common/scripts/init.sh",
    "../common/scripts/k3s.sh"
]
