#!/usr/bin/env bash
set -x

if [ -f /etc/systemd/system/k3s-agent.service.env ]; then
    echo "==> K3s Agent Starting ..."

    sudo cp ~/k3s-agent.service.env /etc/systemd/system/k3s-agent.service.env

    sudo systemctl enable k3s-agent

    sudo systemctl start k3s-agent
else
    echo "==> K3s Agent Skipped"
fi
