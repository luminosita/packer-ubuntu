source "proxmox-clone" "template" {
    insecure_skip_tls_verify = "true"
    proxmox_url              = "https://${var.proxmox_api_host}:8006/api2/json"
    node                     = "${var.proxmox_node}"
    token                    = "${var.proxmox_token}"
    username                 = "${var.proxmox_api_user}!${var.proxmox_token_id}"

    clone_vm_id           = "${var.vm_clone_id}"

    template_description = "${var.vm_template_description}\n\n---\n\nbuilt via [pve-cloud-templates-packer](https://github.com/mabeett/pve-cloud-templates-packer) (or a fork)\n\n${timestamp()}"
    template_name        = "${local.vm_template_name}"
    vm_id                = "${var.vm_id}"
    pool                 = "${var.vm_pool}"
    
//    cpu_type    = "${var.cpu_type}"
    cores       = "${var.vm_cores}"
    memory      = "${var.vm_memory}"
//    os          = "l26"

//    bios        = "ovmf"
//    machine     = "q35"

    communicator = "ssh"

    // ssh_host                = "${var.ssh_host}"
    ssh_username            = "${var.ssh_username}"
    ssh_private_key_file    = "${var.ssh_private_key_file}"

    ssh_bastion_host                = "${var.ssh_bastion_host}"
    ssh_bastion_username            = "${var.ssh_bastion_username}"
    ssh_bastion_private_key_file    = "${var.ssh_bastion_private_key_file}"

    task_timeout = "5m"
    ssh_timeout = "10m"

    // serials = ["socket"]
    // vga {
    //     type = "${var.vm_serial_device}"
    // }

    // scsi_controller = "${var.vm_scsi_controller}"
    // disks {
    //     disk_size    = "${var.vm_disk_size}"
    //     format       = "${var.vm_disk_format}"
    //     storage_pool = "${var.vm_disk_storage_pool}"
    //     type         = "${var.vm_disk_type}"
    //     io_thread    = "${var.vm_disk_io_thread}"
    // }

    network_adapters {
        firewall    = false
        bridge      = "${var.vm_net_bridge}"
        model       = "${var.vm_net_model}"
        mac_address = "${var.vm_net_mac_address}"
        }
}
