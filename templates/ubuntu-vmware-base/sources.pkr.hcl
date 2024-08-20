source "vmware-iso" "base_image" {
    vm_name         = "${local.vm_name}"
    
    iso_urls        = [
        "iso/${var.ubuntu_iso_file}",
        "${var.ubuntu_iso_path}"
        ]
    iso_checksum    = "${var.ubuntu_iso_checksum}"
    iso_target_path = "iso"
    guest_os_type   = "Ubuntu-64"

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

    # VMWare specific configuration
    cpus             = 2
    memory           = 2048
    disk_size        = 10000
    disk_type_id     = 1

    # Final Image will be available in `output/packerubuntu-*/`
    output_directory = "${local.output_dir}"

    # SSH configuration so that Packer can log into the Image
    ssh_password    = "${local.ssh_password}"
    ssh_username    = "${local.ssh_username}"
    ssh_timeout     = "20m"
    shutdown_command   = "sudo su -c \"/sbin/shutdown -hP now\""
    headless        = true # NOTE: set this to true when using in CI Pipelines
}
