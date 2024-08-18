#!/usr/bin/env bash
set -x

echo "Modifying /etc/ssh/sshd_config..."
sed -ie 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -ie 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -ie 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -ie 's/#AllowAgentForwarding yes/AllowAgentForwarding yes/' /etc/ssh/sshd_config
sed -ie 's/#UseDNS no/UseDNS no/' /etc/ssh/sshd_config
