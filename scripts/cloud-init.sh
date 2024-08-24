#!/usr/bin/env bash
set -x

while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for Cloud-Init...'; sleep 1; done

while [ `pgrep -x "apt"` ]; do echo 'Waiting for APT ...'; sleep 1; done

mkdir /tmp/download
sudo mv /var/log/cloud-init-output.log /tmp/download

sudo touch /etc/cloud/cloud-init.disabled
