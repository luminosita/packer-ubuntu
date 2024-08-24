// source "null" "ansible" {
//     ssh_host        = "${var.ansible_ssh_host}"
//     ssh_port        = "${var.ansible_ssh_port}"
//     ssh_username    = "${var.ansible_ssh_username}"
//     ssh_password    = "${var.ansible_ssh_password}"
// }

source "digitalocean" "snapshot" {
    api_token       = "${var.api_token}"
    image           = "${var.vm_base_image}"
    region          = "${var.do_region}"
    size            = "${var.do_size}"
    ssh_username    = "root"
    snapshot_name   = "${local.vm_snapshot_name}"
}


