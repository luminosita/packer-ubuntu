#! /bin/bash

eval "$(jq -r '@sh "IP_ADDRESS=\(.ip_address) PRIVATE_KEY=\(.private_key)"')"

token=$(/usr/bin/ssh root@$IP_ADDRESS -o "IdentityFile $PRIVATE_KEY" -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' "cat /var/lib/rancher/k3s/server/node-token")
certhash=$(/usr/bin/ssh root@$IP_ADDRESS -o "IdentityFile $PRIVATE_KEY" -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' "openssl x509 -pubkey -in /var/lib/rancher/k3s/server/tls/server-ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'")

jq -n --arg token "$token" --arg certhash "$certhash" '{"token":$token, "certhash":$certhash}'