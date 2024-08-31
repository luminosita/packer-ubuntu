api_url                 = "https://proxmox.wan:8006/api2/json"

ssh_username            = "k3s"
ssh_private_key_file    = "~/.ssh/id_rsa"

vm_server_name          = "k3s-server-ubuntu-noble"
vm_agent_name           = "k3s-agent-ubuntu-noble"

api_token_id            = "root@pam!terraform"

prox_target_node        = "proxmox"
prox_storage            = "local-zfs"
prox_template_vmid      = 101
prox_pool               = "k3s"



