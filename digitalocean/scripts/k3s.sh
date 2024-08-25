#!/usr/bin/env bash
set -x

export K3S_KUBECONFIG_MODE="644"
export INSTALL_K3S_EXEC="--flannel-backend=none --cluster-cidr=$K3S_CLUSTER_CIDR --disable-network-policy --disable=traefik"

echo "Using K3S_TOKEN: $K3S_TOKEN"
echo "Using K3S_CLUSTER_CIDR: $K3S_CLUSTER_CIDR"
echo "Using K3S_KUBECONFIG_MODE: $K3S_KUBECONFIG_MODE"
echo "Using INSTALL_K3S_EXEC: $INSTALL_K3S_EXEC"

curl -sfL https://get.k3s.io | sh -

#Prepare kubctl config
mkdir -p ~/.kube
cp -n /etc/rancher/k3s/k3s.yaml ~/.kube/config

cat ~/.kube/config