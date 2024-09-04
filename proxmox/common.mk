TOKEN:=$(shell hcp vault-secrets run --app=Packer -- env | grep PROXMOX_APITOKEN | sed -e s/PROXMOX_APITOKEN=//)

export API_TOKEN=${TOKEN}
export TF_VAR_api_token_secret=${TOKEN}

export HOSTS="192.168.50.20 192.168.50.21 192.168.50.22"

TF_WORKSPACE:="k3s"


