TOKEN:=$(shell hcp vault-secrets run --app=Packer -- env | grep DIGITALOCEAN_APITOKEN | sed -e s/DIGITALOCEAN_APITOKEN=//)

export API_TOKEN=${TOKEN}
export TF_VAR_api_token=${TOKEN}

TF_WORKSPACE:="k3s"


