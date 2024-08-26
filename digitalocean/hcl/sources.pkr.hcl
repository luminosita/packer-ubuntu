source "digitalocean" "snapshot" {
    api_token       = "${var.api_token}"
    image           = "${var.vm_base_image}"
    region          = "${var.do_region}"
    size            = "${var.do_size}"
    ssh_username    = "${var.ssh_username}"
    snapshot_name   = "${local.vm_snapshot_name}"
}

// source "null" "test" {
//     communicator = "none"
// }

// source "null" "ssh" {
//     ssh_host        = "127.0.0.1"
//     ssh_port        = "60022"
//     ssh_username    = "ubuntu"
//     ssh_password    = "ubuntu"
// }
