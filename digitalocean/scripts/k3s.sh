#!/usr/bin/env bash
set -x

echo "==> ENVIRONMENT VARIABLES"
env

#Check if k3s service is installed
if [ ! -f /etc/systemd/system/k3s.service.env ]; then
    echo "==> Installing K3s Service"
    curl -sfL https://get.k3s.io | sh -
else 
    echo "==> K3s Service ENV"
    sudo cat /etc/systemd/system/k3s.service.env

    while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do echo 'Waiting for K3s server to start...'; sleep 1; done
fi

#Check if k3s-agent service is installed and print environment variables
if [ -f /etc/systemd/system/k3s-agent.service.env ]; then
    echo "==> K3s Agent Service ENV"
    sudo cat /etc/systemd/system/k3s-agent.service.env
fi

#Check if server is installed and copy node token
if [ -f /etc/rancher/k3s/k3s.yaml ]; then
    echo "==> Prepare K3s kubectl"
    mkdir -p ~/.kube
    cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

    echo "==> K3s kubectl config"
    cat ~/.kube/config
fi
