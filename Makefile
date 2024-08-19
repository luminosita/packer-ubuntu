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

.PHONY: build-focal build-jammy validate-packer validate-cloudinit validate

QEMU_TEMPLATE_FILE:=./templates/ubuntu-qemu.pkr.hcl
VMWARE_TEMPLATE_FILE:=./templates/ubuntu-vmware.pkr.hcl

UBUNTU_AMD_VARS_FILE:=./vars/ubuntu-amd.pkrvars.hcl
UBUNTU_ARM_VARS_FILE:=./vars/ubuntu-arm.pkrvars.hcl

FOCAL_VARS_FILE:=./vars/focal.pkrvars.hcl
JAMMY_VARS_FILE:=./vars/jammy.pkrvars.hcl

NOBLE_VARS_FILE:=./vars/noble/noble.pkrvars.hcl
NOBLE_AMD_VARS_FILE:=./vars/noble/noble-amd.pkrvars.hcl
NOBLE_ARM_VARS_FILE:=./vars/noble/noble-arm.pkrvars.hcl

TEST_TEMPLATE_FILE:=./templates/test.pkr.hcl
TEST_ARM_TEMPLATE_FILE:=./templates/test-arm.pkr.hcl

init-qemu:
	packer init ${QEMU_TEMPLATE_FILE}

init-vmware:
	packer init ${VMWARE_TEMPLATE_FILE}

test-focal: validate-focal
	source /etc/os-release; PACKER_LOG=1 packer build -force -var host_distro=$${ID} -var-file=${FOCAL_VARS_FILE} ${TEST_TEMPLATE_FILE}

test-jammy: validate-jammy
	source /etc/os-release; PACKER_LOG=1 packer build -force -var host_distro=$${ID} -var-file=${JAMMY_VARS_FILE} ${TEST_TEMPLATE_FILE}

test-noble: init
	source /etc/os-release; PACKER_LOG=1 packer build -force -var host_distro=$${ID} -var-file=${NOBLE_VARS_FILE} ${TEST_TEMPLATE_FILE}

test-noble-arm: init
	PACKER_LOG=1 packer build -force -var-file=${NOBLE_ARM_VARS_FILE} ${TEST_ARM_TEMPLATE_FILE}

build-focal: init
	source /etc/os-release; PACKER_LOG=1 packer build -force -var host_distro=$${ID} -var-file=${FOCAL_VARS_FILE} ${TEMPLATE_FILE}

build-jammy: validate-jammy
	source /etc/os-release; PACKER_LOG=1 packer build -force -var host_distro=$${ID} -var-file=${JAMMY_VARS_FILE} ${TEMPLATE_FILE}

build-noble-qemu: init-qemu validate-cloudinit-noble
	source /etc/os-release; PACKER_LOG=1 packer build -force -var host_distro=$${ID} -var-file=${UBUNTU_AMD_VARS_FILE} -var-file=${NOBLE_VARS_FILE} -var-file=${NOBLE_AMD_VARS_FILE} ${QEMU_TEMPLATE_FILE}

build-noble-qemu-arm: init-qemu
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_ARM_VARS_FILE} -var-file=${NOBLE_VARS_FILE} -var-file=${NOBLE_ARM_VARS_FILE} ${QEMU_TEMPLATE_FILE}

build-noble-vmware: init-vmware validate-cloudinit-noble
	source /etc/os-release; PACKER_LOG=1 packer build -force -var host_distro=$${ID} -var-file=${NOBLE_VARS_FILE} ${VMWARE_TEMPLATE_FILE}

build-noble-vmware-arm: init-vmware
	PACKER_LOG=1 packer build -force -var-file=${NOBLE_ARM_VARS_FILE} ${VMWARE_TEMPLATE_FILE}

validate-focal: init
	$(info PACKER: Validating Template with Ubuntu 20.04 (Focal Fossa) Packer Variables)
	source /etc/os-release; packer validate -var host_distro=$${ID} -var-file=${FOCAL_VARS_FILE} ${TEMPLATE_FILE}

validate-jammy: init
	$(info PACKER: Validating Template with Ubuntu 22.04 (Jammy Jellyfish) Packer Variables)
	source /etc/os-release; packer validate -var host_distro=$${ID} -var-file=${JAMMY_VARS_FILE} ${TEMPLATE_FILE}

validate-noble: init 
	$(info PACKER: Validating Template with Ubuntu 24.04 (Noble Numbat) Packer Variables)
	source /etc/os-release; packer validate -var host_distro=$${ID} -var-file=${NOBLE_VARS_FILE} ${TEMPLATE_FILE}

validate-cloudinit-focal:
	$(info CLOUD-INIT: Validating Ubuntu 20.04 (Focal Fossa) Cloud-Config File)
	cloud-init schema -c http/focal/user-data

validate-cloudinit-jammy:
	$(info CLOUD-INIT: Validating Ubuntu 22.04 (Jammy Jellyfish) Cloud-Config File)
	cloud-init schema -c http/jammy/user-data

validate-cloudinit-noble:
	$(info CLOUD-INIT: Validating Ubuntu 24.04 (Noble Numbat) Cloud-Config File)
	cloud-init schema -c http/noble/user-data

validate-packer: validate-focal validate-jammy validate-noble

validate-cloudinit: validate-cloudinit-focal validate-cloudinit-jammy validate-cloudinit-noble

validate: validate-cloudinit validate-packer
