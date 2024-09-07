output "ip_addresses" {
    value = {
        ctrl_ips = proxmox_virtual_environment_vm.k3s-ctrl[*].ipv4_addresses[1][0]
        work_ips = proxmox_virtual_environment_vm.k3s-work[*].ipv4_addresses[1][0]
    }
}