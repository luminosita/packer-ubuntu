#!/usr/bin/env bash
set -x

export ISTIO_VERSION=1.23.0

if [ -f /etc/rancher/k3s/k3s.yaml ]; then
    echo "==> Installing Istio"

    curl -L https://istio.io/downloadIstio | sh -

    ./istio-1.23.0/bin/istioctl x precheck
else
    echo "==> K3s server unavailable. Skipping Istio installation"
fi