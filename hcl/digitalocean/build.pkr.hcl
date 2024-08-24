// build {
//     name = "ansible-remote"
   
//     sources = [ "source.null.ansible" ]

//     provisioner "shell" {
//         scripts = [ "scripts/python.sh" ]
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
    name = "ubuntu"
    
    sources = ["source.digitalocean.snapshot"]

    provisioner "shell" {
        scripts = "${var.scripts}" 
    }
}