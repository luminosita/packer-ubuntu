source "digitalocean" "snapshot" {
    api_token               = "${var.api_token}"
    image                   = "${var.vm_base_image}"
    region                  = "${var.do_region}"
    size                    = "${var.do_size}"
    
    ssh_username            = "${var.ssh_username}"
    ssh_key_id              = "${var.do_ssh_key_id}"
    ssh_private_key_file    = "${var.ssh_private_key_file}"
    
    snapshot_name           = "${local.vm_snapshot_name}"
    user_data               = templatefile("../templates/cloud-config.tpl", {
        "SSH_USERNAME"      = "${var.ssh_username}"
        "SSH_PUBLIC_KEY"    = file("${var.ssh_public_key_file}")
    })
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
