#!/usr/bin/env bash
# Add net.ifnames to /etc/default/grub and rebuild grub.cfg
sed -i -e '/GRUB_CMDLINE_LINUX/ s:"$: net.ifnames=0":' /etc/default/grub
/sbin/grub-mkconfig -o /boot/grub/grub.cfg

# Arm64
sed -ie 's/enp0s3/eth0/' /etc/netplan/50-cloud-init.yaml

# Amd64
sed -ie 's/ens3/eth0/' /etc/netplan/50-cloud-init.yaml
