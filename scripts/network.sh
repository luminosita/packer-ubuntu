#!/usr/bin/env bash
set -x

#Move Netplan config and set proper owner
sudo mv /tmp/50-cloud-init.yaml /etc/netplan/
sudo chown root:root /etc/netplan/50-cloud-init.yaml
