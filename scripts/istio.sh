#!/usr/bin/env bash
set -x

curl -L https://istio.io/downloadIstio | sh -

./istio-1.23.0/bin/istioctl x precheck