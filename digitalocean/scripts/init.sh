#!/usr/bin/env bash
set -x

sudo sed -i '/ swap / s/^/#/' /etc/fstab
sudo swapoff -a
