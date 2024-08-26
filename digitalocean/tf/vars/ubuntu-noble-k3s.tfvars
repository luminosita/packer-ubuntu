api-token               = env("API_TOKEN")

ssh_username            = "k3s"
ssh_private_key_file         = "~/.ssh/id_rsa"

do_ssh_key_name         = "Gianni"

vm_server_name          = "k3s-server-ubuntu-noble"
vm_agent_name           = "k3s-agent-ubuntu-noble"

vm_server_base_image    = "k3s-server-ubuntu-noble-2024_26_08, 22:04" 
vm_agent_base_image     = "k3s-agent-ubuntu-noble-2024_26_08, 22:05" 


