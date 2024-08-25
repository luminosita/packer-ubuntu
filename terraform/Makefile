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

DO_TF_FOLDER:=./terraform/

include ../common.mk

init-tf-do:
	$(info TERRAFORM: Init Terraform plugins for $(TF_WORKSPACE))
	
	terraform init;\
	terraform workspace new $(TF_WORKSPACE);\

delete-tf-do:
	$(info TERRAFORM: Delete Terraform folder)
	
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate.d

plan-k3s-do: 
	$(info TERRAFORM: Plan for $(TF_WORKSPACE))
	
	terraform workspace select $(TF_WORKSPACE) && \
    terraform plan -var-file=vars/ubuntu-noble-k3s.tfvars -out=./k3s.tfplan;

apply-k3s-do:
	$(info TERRAFORM: Apply for $(TF_WORKSPACE))

	terraform workspace select $(TF_WORKSPACE) && \
    terraform apply ./k3s.tfplan;

plan-destroy-k3s-do:
	$(info TERRAFORM: Apply for $(TF_WORKSPACE))

	terraform workspace select $(TF_WORKSPACE) && \
    terraform plan -destroy -var-file=vars/ubuntu-noble-k3s.tfvars -out=./k3s.tfplan
