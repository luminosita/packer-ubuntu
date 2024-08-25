#!/usr/bin/env bash
set -x

echo "Using K3S_TOKEN: $K3S_TOKEN"
echo "Using K3S_SERVER_URL: $K3S_SERVER_URL"

curl -sfL https://get.k3s.io | K3S_URL="https://$K3S_SERVER_URL:6443" K3S_TOKEN=$K3S_TOKEN