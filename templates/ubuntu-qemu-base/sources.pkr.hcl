source "qemu" "base_image" {
    vm_name         = "${local.vm_name}"
    
    iso_urls        = [
        "iso/${var.ubuntu_iso_file}",
        "${var.ubuntu_iso_path}"
        ]
    iso_checksum    = "${var.ubuntu_iso_checksum}"
    iso_target_path = "iso"

    # Location of Cloud-Init / Autoinstall Configuration files
    # Will be served via an HTTP Server from Packer
    http_directory = "http/${var.ubuntu_distro}"

    # Boot Commands when Loading the ISO file with OVMF.fd file (Tianocore) / GrubV2
    boot_command = [
        "c<wait>",
        "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
        "<enter><wait>",
        "initrd /casper/initrd <enter><wait>",
        "boot<enter>"
    ]
    
    boot_wait = "5s"

    # QEMU specific configuration
    qemu_binary      = "${var.ubuntu_qemu_binary}"
    machine_type     = "${var.ubuntu_machine_type}"
    format           = "raw"
    cpus             = 2
    memory           = 2048
    accelerator      = "${var.ubuntu_accelerator}"
    net_device       = "virtio-net"
    disk_size        = "30G"
    disk_compression = true
    disk_interface   = "virtio"
    qemuargs         = "${var.ubuntu_qemuargs}"

    #efi_firmware_code = "/usr/share/OVMF/${lookup(local.ovmf_prefix, var.host_distro, "")}OVMF_CODE.fd"
    #efi_firmware_vars = "/usr/share/OVMF/${lookup(local.ovmf_prefix, var.host_distro, "")}OVMF_VARS.fd"
    #efi_boot          = true

    # Final Image will be available in `output/packerubuntu-*/`
    output_directory = "${local.output_dir}"

    # SSH configuration so that Packer can log into the Image
    ssh_password    = "${local.ssh_password}"
    ssh_username    = "${local.ssh_username}"
    ssh_timeout     = "20m"
    shutdown_command   = "sudo su -c \"/sbin/shutdown -hP now\""
    #userdel -rf ${local.ssh_password};
    #shutdown_command = "echo '${local.ssh_password}' | sudo -S shutdown -P now" rm /etc/sudoers.d/90-cloud-init-users; 
    headless        = true # NOTE: set this to true when using in CI Pipelines
}
