#!/bin/bash -eux

# Add net.ifnames to /etc/default/grub and rebuild grub.cfg
sudo sed -i -e '/GRUB_CMDLINE_LINUX/ s:"$: net.ifnames=0":' /etc/default/grub
sudo /sbin/grub-mkconfig -o /boot/grub/grub.cfg

# Make sure udev does not block our network - http://6.ptmc.org/?p=164
# echo "==> Cleaning up udev rules"
# rm -rf /dev/.udev/
# rm /lib/udev/rules.d/75-persistent-net-generator.rules

# echo "==> Cleaning up leftover dhcp leases"
# Ubuntu 10.04
# if [ -d "/var/lib/dhcp3" ]; then
#     rm /var/lib/dhcp3/*
# fi
# Ubuntu 12.04 & 14.04
# if [ -d "/var/lib/dhcp" ]; then
#     rm /var/lib/dhcp/*
# fi 

# Add delay to prevent "vagrant reload" from failing
# echo "pre-up sleep 2" >> /etc/network/interfaces

echo "==> Cleaning up tmp"
sudo rm -rf /tmp/*

# Cleanup apt cache
sudo apt-get -y autoremove --purge
sudo apt-get -y clean
sudo apt-get -y autoclean

echo "==> Installed packages"
sudo dpkg --get-selections | grep -v deinstall

DISK_USAGE_BEFORE_CLEANUP=$(df -h)

# Remove Bash history
sudo rm -f /root/.bash_history

# Clean up log files
sudo find /var/log -type f | while read f; do sudo su -c "echo -ne '' > '${f}'"; done;

echo "==> Clearing last login information"
sudo su -c "echo -ne '' >/var/log/lastlog"
sudo su -c "echo -ne '' >/var/log/wtmp"
sudo su -c "echo -ne '' >/var/log/btmp"

# NOTE: Shrinking is not part of the build process
# so this will only grow the image...

# # Whiteout root
# count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
# let count--
# dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
# rm /tmp/whitespace

# # Whiteout /boot
# count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
# let count--
# dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count
# rm /boot/whitespace

# echo '==> Clear out swap and disable until reboot'
# set +e
# swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
# case "$?" in
#     2|0) ;;
#     *) exit 1 ;;
# esac
# set -e
# if [ "x${swapuuid}" != "x" ]; then
#     # Whiteout the swap partition to reduce box size
#     # Swap is disabled till reboot
#     swappart=$(readlink -f /dev/disk/by-uuid/$swapuuid)
#     /sbin/swapoff "${swappart}"
#     dd if=/dev/zero of="${swappart}" bs=1M || echo "dd exit code $? is suppressed"
#     /sbin/mkswap -U "${swapuuid}" "${swappart}"
# fi

# # Zero out the free space to save space in the final image
# dd if=/dev/zero of=/EMPTY bs=1M  || echo "dd exit code $? is suppressed"
# rm -f /EMPTY

# # Make sure we wait until all the data is written to disk, otherwise
# # Packer might quite too early before the large files are deleted
# sync

# echo "==> Disk usage before cleanup"
# echo ${DISK_USAGE_BEFORE_CLEANUP}

# echo "==> Disk usage after cleanup"
# df -h
