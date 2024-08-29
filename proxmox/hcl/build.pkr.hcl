build {
    name = "k3s"
    
    sources = ["source.proxmox-clone.template"]

    // communicator "ssh " {
    //     ssh_username            = "${var.ssh_username}"
    //     ssh_private_key_file    = "${var.ssh_private_key_file}"
    // }

    // provisioner "shell" {
    //     env = "${var.script_env}"

    //     scripts = "${var.scripts}" 
    // }
}

// build {
//   name = "k3s"

//   sources = ["source.proxmox-iso.template"]

  ## Current community.general collection does not handle cloud-init properly
  # https://github.com/ansible-collections/community.general/issues/7136
  # provisioner "ansible" {
  #   playbook_file = "../ansible/proxmox_cloud_init_config.yml"
  #   user          = "${var.ssh_username}"
  #   extra_arguments = [
  #     # "-vv",
  #     "-e proxmox_api_host=${var.proxmox_api_host} ",
  #     "-e proxmox_node=${var.proxmox_node} ",
  #     "-e proxmox_api_user=${var.proxmox_api_user} ",
  #     "-e proxmox_token_id=${var.proxmox_token_id} ",
  #     "-e proxmox_token=${var.proxmox_token} ",
  #     "-e cloud_init_user=${var.cloud_init_user} ",
  #     "-e cloud_init_password=${var.ssh_password} ",
  #     "-e cloud_init_ipconfig=${var.cloud_init_ipconfig} ",
  #     "-e cloud_init_ssh_keys=${var.cloud_init_ssh_keys} ",
  #     "-e vm_id=${var.vm_id} "
  #   ]
  # }

  // provisioner "ansible" {
  //   playbook_file = "../ansible/install_via_qemu_img.yml"
  //   user          = "${var.ssh_username}"
  //   extra_arguments = [
  //     # "-vv",
  //     "-e cloud_img_url=${var.cloud_img_url} ",
  //     "-e growpart_after_qemuimg=${var.vm_growpart_after_qemuimg}",
  //     "-e root_part_number=${var.vm_growpart_root_part_number}",
  //     "-e vm_disk=${var.vm_guest_disk_drive} "
  //   ]
  // }

  // provisioner "shell" {
  //   inline = ["bash -c 'shutdown -t 1 -r'"]
  // }

  // provisioner "shell-local" {
  //   inline = ["sleep 5"]
  // }

  // provisioner "ansible" {
  //   playbook_file = "../ansible/cloud_init.yml"
  //   user          = "${var.ssh_username}"
  //   extra_arguments = [
  //     # "-vv",
  //     "-e ansible_python_interpreter=/usr/bin/python3",
  //     "-e ssh_root_login_file='${var.ssh_root_login_file}' ",
  //     "-e vm_host=${build.Host} ",
  //     "-e vm_validate_port=${var.guest_os_startup_validation_port} "
  //   ]
  // }

  // provisioner "shell" {
  //   environment_vars = [
  //     "TEMPLATE_NAME=${var.template_name}"
  //   ]
  //   scripts = [
  //     "clean_files.sh"
  //   ]
  // }
// }