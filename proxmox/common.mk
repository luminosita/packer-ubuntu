TOKEN:=$(shell hcp vault-secrets run --app=Packer -- env | grep PROXMOX_APITOKEN | sed -e s/PROXMOX_APITOKEN=//)

export API_TOKEN=${TOKEN}

TF_WORKSPACE:="k3s"


