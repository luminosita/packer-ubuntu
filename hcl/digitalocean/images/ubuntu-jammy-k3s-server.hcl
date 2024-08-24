vm_name              = "k3s-server"

vm_base_image        = "ubuntu-22-04-x64" 

#vm_base_version     = "1.0"

#ansible_operation   = "bootstrap,server,network,certmgr,config,istio"

// ansible_ssh_host        = "localhost"
// ansible_ssh_port        = 60022
// ansible_ssh_username    = "ubuntu"
// ansible_ssh_password    = "ubuntu"

scripts = [
    "scripts/init.sh",
    "scripts/k3s.sh",
    "scripts/istio.sh",
]


