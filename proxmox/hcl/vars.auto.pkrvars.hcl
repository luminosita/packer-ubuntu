proxmox_url         = "https://proxmox.lan:8006/api2/json"
proxmox_api_host    = "proxmox.lan"
proxmox_node        = "proxmox"

vm_template_name        = "test"
vm_template_description = "Test Description"
vm_version              = "1.0"
vm_id                = 100000

vm_clone_id          = 1000

ssh_username            = "test"
ssh_private_key_file    = ""

vm_disk_storage_pool = "local-zfs"
vm_disk_size         = "4G"

script_env              = {}

scripts                 = [ "../common/scripts/init.sh" ]

