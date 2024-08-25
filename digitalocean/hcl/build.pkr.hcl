// build {
//     name = "ansible-remote"
   
//     sources = [ "source.null.ansible" ]

//     provisioner "shell" {
//         scripts = [ "digitalocean/scripts/python.sh" ]
//     }

//     provisioner "ansible-local" {
//         playbook_dir = "ansible"
//         playbook_file = "ansible/playbook.yaml"
//         extra_arguments = ["-e operation=${var.ansible_operation} -v"]
//         command = "/home/ubuntu/python-venv/ansible/bin/ansible-playbook"
// #      ansible_ssh_extra_args = [ "-o StrictHostKeyChecking=no -o PubkeyAcceptedKeyTypes=+ssh-rsa -o HostkeyAlgorithms=+ssh-rsa"]
// #      local_port = "${var.ansible_ssh_port}"
//     }
// }

build {
    name = "k3s"
    
    // sources = ["source.null.test"]
    sources = ["source.digitalocean.snapshot"]

    provisioner "shell" {
        env     = {
            "K3S_TOKEN" = "${var.k3s_token}"
            "K3S_CLUSTER_CIDR" = "${var.k3s_cluster_cidr}"
        }

//        inline = [ "echo $K3S_TOKEN" ]

        scripts = "${var.scripts}" 
    }
}