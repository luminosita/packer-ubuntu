api-token = env("API_TOKEN")

do_ssh_key_name = "Gianni"

vm_server_base_image       = "k3s-server-ubuntu-noble-2024_25_08, 12:29" 
vm_agent_base_image        = "k3s-agent-ubuntu-noble-2024_25_08, 12:33" 

#ansible_operation   = "bootstrap,server,network,certmgr,config,istio"

# // ansible_ssh_host        = "localhost"
# // ansible_ssh_port        = 60022
# // ansible_ssh_username    = "ubuntu"
# // ansible_ssh_password    = "ubuntu"

# script_env = {
#     "K3S_INSTALL_EXEC"  = "--flannel-backend=none --cluster-cidr=\"10.100.0.0/16\" --disable-network-policy --disable=traefik",
#     "INSTALL_K3S_SKIP_START"    = "true"
# }

# scripts = [
#     "digitalocean/scripts/init.sh",
#     "digitalocean/scripts/k3s.sh",
#     "digitalocean/scripts/istio.sh",
# ]


