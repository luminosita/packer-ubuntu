source "qemu" "base" {
    vm_name          = "${local.vm_name}"
    
    iso_url          = "${local.vm_base_url}.img"
    iso_checksum     = "${local.vm_base_url_checksum}"

    boot_wait        = "5s"

    # QEMU specific configuration
    qemu_binary      = "${lookup(local.qemu_binary, var.arch, [])}"
    machine_type     = "${lookup(local.machine_type, var.arch, "")}"
    format           = "qcow2"
    cpus             = "${var.vm_cpus}"
    memory           = "${var.vm_memory}"
    accelerator      = "${lookup(local.accelerator, var.arch, "")}"
    disk_image       = true  #clone base image
    disk_size        = "${var.vm_disk_size}"
    disk_compression = true
    disk_interface   = "virtio"
    qemuargs         = "${lookup(local.qemu_args, var.arch, [])}"

    #efi_firmware_code = "/usr/share/OVMF/${lookup(local.ovmf_prefix, var.host_distro, "")}OVMF_CODE.fd"
    #efi_firmware_vars = "/usr/share/OVMF/${lookup(local.ovmf_prefix, var.host_distro, "")}OVMF_VARS.fd"
    #efi_boot          = true

    output_directory = "${local.output_dir}"

    # SSH configuration so that Packer can log into the Image
    ssh_password     = "${local.ssh_password}"
    ssh_username     = "${local.ssh_username}"
    ssh_timeout      = "20m"
    shutdown_command   = "sudo su -c \"/sbin/shutdown -hP now\""
#    shutdown_command   = "sudo su -c \"userdel -rf ${local.ssh_password}; /sbin/shutdown -hP now\""
    #shutdown_command = "echo '${local.ssh_password}' | sudo -S shutdown -P now" rm /etc/sudoers.d/90-cloud-init-users; 
    headless        = true # NOTE: set this to true when using in CI Pipelines
}

source "null" "ansible" {
    ssh_host        = "${var.ansible_ssh_host}"
    ssh_port        = "${var.ansible_ssh_port}"
    ssh_username    = "${var.ansible_ssh_username}"
    ssh_password    = "${var.ansible_ssh_password}"
}

