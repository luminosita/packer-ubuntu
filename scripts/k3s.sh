#!/usr/bin/env bash
set -x

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_TOKEN="12345" \
    INSTALL_K3S_EXEC="--flannel-backend=none \
    --cluster-cidr=$K3S_CLUSTER_CIDR \ 
    --disable-network-policy --disable=traefik" sh -s -