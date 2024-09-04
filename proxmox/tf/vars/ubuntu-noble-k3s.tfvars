api_url                 = "https://proxmox.wan:8006/api2/json"

ssh_username            = "ubuntu"
ssh_private_key_file    = "~/.ssh/id_rsa"

# ssh_bastion_host                = "proxmox.wan"
# ssh_bastion_username            = "ubuntu"
# ssh_bastion_private_key_file    = "~/.ssh/id_rsa"

vm_server_name          = "k3s-server-ubuntu-noble"
vm_agent_name           = "k3s-agent-ubuntu-noble"

api_token_id            = "root@pam!terraform"

prox_target_node        = "proxmox"
prox_storage            = "local-zfs"
prox_template_vmid      = 8010
prox_pool               = "k3s"



