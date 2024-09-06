#cloud-config
users:
  - name: ${SSH_USERNAME}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    lock-passwd: true
    ssh-authorized-keys:
      - ${SSH_PUBLIC_KEY}
runcmd:
  - apt update  
  - apt install -y qemu-guest-agent  
  - systemctl start qemu-guest-agent
  - reboot