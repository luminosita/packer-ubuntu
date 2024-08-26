build {
    name = "k3s"
    
    sources = ["source.digitalocean.snapshot"]

    provisioner "shell" {
        env = "${var.script_env}"

        scripts = "${var.scripts}" 
    }
}

// build {
//     name = "test"
    
//     sources = ["source.null.ssh"]

//     provisioner "file" {
//         source          = "digitalocean/scripts/timer.sh"
//         destination     = "timer.sh"
//     }

//     provisioner "shell" {
//         env = "${var.script_env}"

//         scripts = "${var.scripts}" 
//     }
// }

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

