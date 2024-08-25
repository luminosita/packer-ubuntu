#!/usr/bin/env bash
set -x

export ISTIO_VERSION=1.23.0

curl -L https://istio.io/downloadIstio | sh -

./istio-1.23.0/bin/istioctl x precheck