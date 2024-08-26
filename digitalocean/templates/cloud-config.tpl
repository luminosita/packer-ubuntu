#cloud-config
users:
  - name: ${SSH_USERNAME}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    passwd: ec3759e2c570d302e65ea20a7d985e3bc131024889ad902a046c385afcd71beec61a4f2a5e4ce56863f54840b7315d692cfaeda8239481e37b00cade86139abd
    lock-passwd: false
    ssh-authorized-keys:
      - ${SSH_PUBLIC_KEY}