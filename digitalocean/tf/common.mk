TF_WORKSPACE:="k3s"

TOKEN:=$(shell hcp vault-secrets run --app=Packer -- env | grep DIGITALOCEAN_APITOKEN | sed -e s/DIGITALOCEAN_APITOKEN=//)
export TF_VAR_api_token=${TOKEN}
