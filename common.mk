K3S_TOKEN_FILE:=./k3s.token

ifneq ("$(wildcard $(K3S_TOKEN_FILE))","") 
	K3S_TOKEN_VAR:=$(shell cat ${K3S_TOKEN_FILE}) 
endif

REPO_ROOT:=$(shell dirname ~/vm_repo/. )

QEMU_FOLDER:=./hcl/qemu/

NOBLE_ANSIBLE_VARS_FILE:=./images/ubuntu-noble-ansible.hcl
NOBLE_K3S_SERVER_VARS_FILE:=./images/ubuntu-noble-k3s-server.hcl
NOBLE_K3S_AGENT_VARS_FILE:=./images/ubuntu-noble-k3s-agent.hcl
NOBLE_K3S_ISTIO_VARS_FILE:=./images/ubuntu-noble-k3s-istio.hcl

export VM_REPO_ROOT=${REPO_ROOT}
export K3S_TOKEN=${K3S_TOKEN_VAR}
