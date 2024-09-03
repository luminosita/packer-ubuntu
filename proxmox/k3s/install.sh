#!/bin/bash  
  
# Read the list of IP addresses from the environment variable  
IP_ADDRESSES=($HOSTS)  
# Define the k3s version  
K3S_VERSION="v1.30"  

USER="ubuntu"
  
# Check if there is at least one IP address  
if [ ${#IP_ADDRESSES[@]} -eq 0 ]; then  
    echo "No IP addresses found. Please ensure the HOSTS environment variable is correctly set."  
    exit 1  
fi  
  
# Install the master node  
MASTER_IP=${IP_ADDRESSES[0]}  
echo "Installing master node: $MASTER_IP"  
k3sup install --ip $MASTER_IP --user $USER --k3s-channel $K3S_VERSION \
    --k3s-extra-args "--write-kubeconfig-mode 644 --write-kubeconfig ~/.kube/config --flannel-backend=none --cluster-cidr=10.100.0.0/16 --disable traefik --disable metrics-server --disable local-storage --disable-network-policy" \
    --local-path /tmp/config  
  
# Install the other agent nodes  
for i in "${!IP_ADDRESSES[@]}"; do  
    if [ $i -ne 0 ]; then  
        AGENT_IP=${IP_ADDRESSES[$i]}  
        echo "Installing agent node: $AGENT_IP"  
        k3sup join --ip $AGENT_IP --server-ip $MASTER_IP --user $USER --k3s-channel $K3S_VERSION  
    fi  
done  
  
echo "k3s cluster installation complete."