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
TF_VARS:=./vars/ubuntu-noble-k3s.tfvars
TF_PLAN:=./k3s.tfplan

TF_INFRA:=./tf/cluster

K3S_FOLDER:=./k3s/

include common.mk

#TERRAFORM

init-tf: delete-tf
	$(info TERRAFORM: Init Terraform plugins for $(TF_WORKSPACE))

	cd ${TF_INFRA} && \
	terraform init && \
	terraform workspace new $(TF_WORKSPACE);\

delete-tf:
	$(info TERRAFORM: Delete Terraform folder)
	
	cd ${TF_INFRA} && \
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate.d

plan: 
	$(info TERRAFORM: Plan for $(TF_WORKSPACE))
	
	cd ${TF_INFRA} && \
	terraform workspace select $(TF_WORKSPACE) && \
    terraform plan -var-file=${TF_VARS} -out=${TF_PLAN};

apply:
	$(info TERRAFORM: Apply for $(TF_WORKSPACE))

	cd ${TF_INFRA} && \
	terraform workspace select $(TF_WORKSPACE) && \
    terraform apply ${TF_PLAN};

plan-destroy:
	$(info TERRAFORM: Apply for $(TF_WORKSPACE))

	cd ${TF_INFRA} && \
	terraform workspace select $(TF_WORKSPACE) && \
    terraform plan -destroy -var-file=${TF_VARS} -out=${TF_PLAN}

#k3sup
install-k3s:
	$(info k3sup: Installing ...)

	sudo chmod a+x k3s/install.sh && \
		k3s/install.sh

uninstall-k3s:
	$(info k3sup: Uninstalling ...)

	sudo chmod a+x k3s/uninstall.sh && \
		k3s/uninstall.sh

delete-ns:
	$(info k3sup: Uninstalling ...)

	sudo chmod a+x k3s/delete_namespace.sh && \
		k3s/delete_namespace.sh $(ns)

