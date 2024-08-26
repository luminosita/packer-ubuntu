#!/usr/bin/env bash
set -x

export ISTIO_VERSION=1.23.0

if [ ! -f ./istio-1.23.0/bin/istioctl ]; then
    echo "==> Downloading Istio"

    curl -L https://istio.io/downloadIstio | sh -
else
    echo "==> Istio already downloaded"
fi

if [ -f /etc/rancher/k3s/k3s.yaml ]; then
    echo "==> Installing Istio"

    ./istio-1.23.0/bin/istioctl x precheck && \
        ./istio-1.23.0/bin/istioctl install --set profile=demo -y
else
    echo "==> K3s server unavailable. Skipping Istio installation"
fi