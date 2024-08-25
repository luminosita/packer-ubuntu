NOBLE_ANSIBLE_VARS_FILE:=./qemu/images/ubuntu-noble-ansible.hcl
NOBLE_K3S_SERVER_VARS_FILE:=./qemu/images/ubuntu-noble-k3s-server.hcl
NOBLE_K3S_AGENT_VARS_FILE:=./qemu/images/ubuntu-noble-k3s-agent.hcl
NOBLE_K3S_ISTIO_VARS_FILE:=./qemu/images/ubuntu-noble-k3s-istio.hcl

DO_K3S_SERVER_VARS_FILE:=./digitalocean/images/ubuntu-jammy-k3s-server.hcl
DO_K3S_AGENT_VARS_FILE:=./digitalocean/images/ubuntu-jammy-k3s-agent.hcl

K3S_TOKEN_FILE:=./k3s.token

ifneq ("$(wildcard $(K3S_TOKEN_FILE))","") 
	K3S_TOKEN_VAR:=$(shell cat ${K3S_TOKEN_FILE})
endif

REPO_ROOT:=$(shell dirname ~/vm_repo/. )

QEMU_FOLDER:=./qemu/hcl/
DO_FOLDER:=./digitalocean/hcl/

export VM_REPO_ROOT=${REPO_ROOT}
export K3S_TOKEN=${K3S_TOKEN_VAR}
export K3S_CLUSTER_CIDR="10.100.0.0/16"

TOKEN:=$(shell hcp vault-secrets run --app=Packer -- env | grep DIGITALOCEAN_APITOKEN | sed -e s/DIGITALOCEAN_APITOKEN=//)

export API_TOKEN=${TOKEN}
