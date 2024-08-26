#!/usr/bin/env bash
set -x

export K3S_KUBECONFIG_MODE="644"

echo "==> ENVIRONMENT VARIABLES"
env

echo "==> Installing K3s Service"
curl -sfL https://get.k3s.io | sh -

#Check if k3s service is installed and print environment variables
if [ -f /etc/systemd/system/k3s.service.env ]; then
    echo "==> K3s Service ENV"
    cat /etc/systemd/system/k3s.service.env
fi

# https://www.bashcookbook.com/bashinfo/source/bash-4.0/examples/scripts/timeout3

# https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.yaml

#Check if k3s-agent service is installed and print environment variables
if [ -f /etc/systemd/system/k3s-agent.service.env ]; then
    echo "==> K3s Agent Service ENV"
    cat /etc/systemd/system/k3s-agent.service.env
fi

#Check if server is installed and copy node token
if [ -f /etc/rancher/k3s/k3s.yaml ]; then
    echo "==> Prepare K3s kubectl"
    mkdir -p ~/.kube
    cp -n /etc/rancher/k3s/k3s.yaml ~/.kube/config

    echo "==> K3s kubectl config"
    cat ~/.kube/config

    echo "==> Copy K3s Node Token to /tmp/server-token"
    cp /var/lib/rancher/k3s/server/node-token /tmp/server-token
fi