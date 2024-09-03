# Copyright 2024 Shantanoo 'Shan' Desai <sdes.softdev@gmail.com>

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#  limitations under the License.

K3S_SERVER_VARS_FILE:=./images/ubuntu-noble-k3s-server.hcl
K3S_AGENT_VARS_FILE:=./images/ubuntu-noble-k3s-agent.hcl

TF_VARS:=./vars/ubuntu-noble-k3s.tfvars
TF_PLAN:=./k3s.tfplan

HCL_FOLDER:=./hcl/
TF_FOLDER:=./tf/
K3S_FOLDER:=./k3s/

include common.mk

#PACKER

init-hcl:
	$(info PACKER: Init Packer plugins)
	packer init ${HCL_FOLDER}

hcl-k3s-server-template: validate
	$(info PACKER: Build K3S Server template image (Proxmox))
	packer build -var-file=${K3S_SERVER_VARS_FILE} -only=k3s.proxmox-clone.template ${HCL_FOLDER}
	# packer build -var-file=${K3S_SERVER_VARS_FILE} -only=k3s.null.ssh ${HCL_FOLDER}

hcl-k3s-agent-template: validate
	$(info PACKER: Build K3S Server template image (Proxmox))
	packer build -var-file=${K3S_AGENT_VARS_FILE} -only=k3s.proxmox-clone.template ${HCL_FOLDER}
	# packer build -var-file=${K3S_AGENT_VARS_FILE} -only=k3s.null.ssh ${HCL_FOLDER}

validate: init-hcl
	$(info PACKER: Validating Template with Ubuntu 24.04 (Noble Numbat) Packer Variables)
	packer validate ${HCL_FOLDER}

#TERRAFORM

init-tf: delete-tf
	$(info TERRAFORM: Init Terraform plugins for $(TF_WORKSPACE))

	cd ${TF_FOLDER} && \
	terraform init && \
	terraform workspace new $(TF_WORKSPACE);\

delete-tf:
	$(info TERRAFORM: Delete Terraform folder)
	
	cd ${TF_FOLDER} && \
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate.d

plan-k3s: 
	$(info TERRAFORM: Plan for $(TF_WORKSPACE))
	
	cd ${TF_FOLDER} && \
	terraform workspace select $(TF_WORKSPACE) && \
    terraform plan -var-file=${TF_VARS} -out=${TF_PLAN};

apply-k3s:
	$(info TERRAFORM: Apply for $(TF_WORKSPACE))

	cd ${TF_FOLDER} && \
	terraform workspace select $(TF_WORKSPACE) && \
    terraform apply ${TF_PLAN};

plan-destroy-k3s:
	$(info TERRAFORM: Apply for $(TF_WORKSPACE))

	cd ${TF_FOLDER} && \
	terraform workspace select $(TF_WORKSPACE) && \
    terraform plan -destroy -var-file=${TF_VARS} -out=${TF_PLAN}


#k3sup
install-k3s:
	$(info k3sup: Installing ...)

	cd ${K3S_FOLDER} && \
		$(shell ./install.sh)

uninstall-k3s:
	$(info k3sup: Uninstalling ...)

	cd ${K3S_FOLDER} && \
		$(shell ./uninstall.sh)
