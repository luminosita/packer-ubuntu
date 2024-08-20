source "qemu" "final_image" {
    vm_name         = "${local.vm_name}"
    
    iso_url        = "${local.output_dir}/${local.vm_name}"
    iso_checksum    = "none"

    # QEMU specific configuration
    qemu_binary      = "${var.ubuntu_qemu_binary}"
    machine_type     = "${var.ubuntu_machine_type}"
    format           = "raw"
    cpus             = 2
    memory           = 2048
    accelerator      = "${var.ubuntu_accelerator}"
    net_device       = "virtio-net"
    disk_size        = "10G"
    disk_compression = true
    disk_interface   = "virtio"
    qemuargs         = "${var.ubuntu_qemuargs}"

    # Base image will be copied first and resized
    disk_image      = true

    output_directory = "${local.output_dir}-final"

    # SSH configuration so that Packer can log into the Image
    ssh_password    = "${local.ssh_password}"
    ssh_username    = "${local.ssh_username}"
    ssh_timeout     = "20m"
    #TODO Check sudoers for "packer" user
    shutdown_command   = "sudo su -c \"userdel -rf ${local.ssh_password}; /sbin/shutdown -hP now\""
    #shutdown_command = "echo '${local.ssh_password}' | sudo -S shutdown -P now" rm /etc/sudoers.d/90-cloud-init-users; 
    headless        = true # NOTE: set this to true when using in CI Pipelines
}
