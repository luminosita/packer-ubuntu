#!/usr/bin/env bash
set -x

export K3S_URL="https://$K3S_SERVER_IP:6443"

echo "Using K3S_TOKEN: $K3S_TOKEN"
echo "Using K3S_SERVER_URL: $K3S_SERVER_IP"
echo "Using K3S_URL: $K3S_URL"

curl -sfL https://get.k3s.io | sh -