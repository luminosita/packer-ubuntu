# K3S_TOKEN_FILE:=./k3s-server.token

# ifneq ("$(wildcard $(K3S_TOKEN_FILE))","") 
# 	K3S_TOKEN_VAR:=$(shell cat ${K3S_TOKEN_FILE})
# endif

# export K3S_TOKEN=${K3S_TOKEN_VAR}

REPO_ROOT:=$(shell dirname ~/vm_repo/. )

export VM_REPO_ROOT=${REPO_ROOT}
export K3S_CLUSTER_CIDR="10.100.0.0/16"

TOKEN:=$(shell hcp vault-secrets run --app=Packer -- env | grep DIGITALOCEAN_APITOKEN | sed -e s/DIGITALOCEAN_APITOKEN=//)

export API_TOKEN=${TOKEN}
export TF_VAR_api_token=${TOKEN}

TF_WORKSPACE:="k3s"


