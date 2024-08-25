#!/usr/bin/env bash
set -x

#Disable swap by kubernetes requirements
sudo sed -i '/ swap / s/^/#/' /etc/fstab
sudo swapoff -a

#File node-token must exists for Packer file provisioner download
touch /tmp/server-token
