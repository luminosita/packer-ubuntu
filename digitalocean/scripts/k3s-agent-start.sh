#!/usr/bin/env bash
set -x

if [ -f /etc/systemd/system/k3s-agent.service.env ]; then
    echo "==> K3s Agent Starting ..."

    systemctl enable k3s-agent

    systemctl start k3s-agent
else
    echo "==> K3s Agent Skipped"
fi
