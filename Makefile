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

QEMU_FOLDER:=./templates/ubuntu-qemu/

UBUNTU_AMD_VARS_FILE:=./vars/ubuntu-amd.pkrvars.hcl
UBUNTU_ARM_VARS_FILE:=./vars/ubuntu-arm.pkrvars.hcl

NOBLE_VARS_FILE:=./vars/noble/noble.pkrvars.hcl
NOBLE_AMD_VARS_FILE:=./vars/noble/noble-amd.pkrvars.hcl
NOBLE_ARM_VARS_FILE:=./vars/noble/noble-arm.pkrvars.hcl

FOCAL_VARS_FILE:=./vars/focal/focal.pkrvars.hcl
FOCAL_AMD_VARS_FILE:=./vars/focal/focal-amd.pkrvars.hcl
FOCAL_ARM_VARS_FILE:=./vars/focal/focal-arm.pkrvars.hcl

JAMMY_VARS_FILE:=./vars/jammy/jammy.pkrvars.hcl
JAMMY_AMD_VARS_FILE:=./vars/jammy/jammy-amd.pkrvars.hcl
JAMMY_ARM_VARS_FILE:=./vars/jammy/jammy-arm.pkrvars.hcl

init-qemu:
	packer init ${QEMU_FOLDER}

build-noble-qemu-amd: validate-noble  validate-cloudinit-noble
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_AMD_VARS_FILE} -var-file=${NOBLE_VARS_FILE} -var-file=${NOBLE_AMD_VARS_FILE} -only=base_build.qemu.base_image ${QEMU_FOLDER}

build-noble-qemu-arm: validate-noble 
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_ARM_VARS_FILE} -var-file=${NOBLE_VARS_FILE} -var-file=${NOBLE_ARM_VARS_FILE} -only=base_build.qemu.base_image ${QEMU_FOLDER}

build-jammy-qemu-amd: validate-jammy  validate-cloudinit-jammy
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_AMD_VARS_FILE} -var-file=${JAMMY_VARS_FILE} -var-file=${JAMMY_AMD_VARS_FILE} -only=base_build.qemu.base_image ${QEMU_FOLDER}

build-jammy-qemu-arm: validate-jammy 
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_ARM_VARS_FILE} -var-file=${JAMMY_VARS_FILE} -var-file=${JAMMY_ARM_VARS_FILE} -only=base_build.qemu.base_image ${QEMU_FOLDER}

build-focal-qemu-amd: validate-focal  validate-cloudinit-focal
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_AMD_VARS_FILE} -var-file=${FOCAL_VARS_FILE} -var-file=${FOCAL_AMD_VARS_FILE} -only=base_build.qemu.base_image ${QEMU_FOLDER}

build-focal-qemu-arm: validate-noble 
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_ARM_VARS_FILE} -var-file=${FOCAL_VARS_FILE} -var-file=${FOCAL_ARM_VARS_FILE} -only=base_build.qemu.base_image ${QEMU_FOLDER}

final-noble-qemu-amd: init-qemu validate-cloudinit-noble
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_AMD_VARS_FILE} -var-file=${NOBLE_VARS_FILE} -var-file=${NOBLE_AMD_VARS_FILE} -only=final_build.qemu.final_image ${QEMU_FOLDER}

final-noble-qemu-arm: init-qemu
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_ARM_VARS_FILE} -var-file=${NOBLE_VARS_FILE} -var-file=${NOBLE_ARM_VARS_FILE} -only=final_build.qemu.final_image ${QEMU_FOLDER}

final-jammy-qemu-amd: init-qemu validate-cloudinit-jammy
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_AMD_VARS_FILE} -var-file=${JAMMY_VARS_FILE} -var-file=${JAMMY_AMD_VARS_FILE} -only=final_build.qemu.final_image ${QEMU_FOLDER}

final-jammy-qemu-arm: init-qemu
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_ARM_VARS_FILE} -var-file=${JAMMY_VARS_FILE} -var-file=${JAMMY_ARM_VARS_FILE} -only=final_build.qemu.final_image ${QEMU_FOLDER}

final-focal-qemu-amd: init-qemu validate-cloudinit-focal
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_AMD_VARS_FILE} -var-file=${FOCAL_VARS_FILE} -var-file=${FOCAL_AMD_VARS_FILE} -only=final_build.qemu.final_image ${QEMU_FOLDER}

final-focal-qemu-arm: init-qemu
	PACKER_LOG=1 packer build -force -var-file=${UBUNTU_ARM_VARS_FILE} -var-file=${FOCAL_VARS_FILE} -var-file=${FOCAL_ARM_VARS_FILE} -only=final_build.qemu.final_image ${QEMU_FOLDER}

validate-noble: init-qemu
	$(info PACKER: Validating Template with Ubuntu 24.04 (Noble Numbat) Packer Variables)
	packer validate -var-file=${UBUNTU_AMD_VARS_FILE} -var-file=${NOBLE_VARS_FILE} -var-file=${NOBLE_AMD_VARS_FILE} ${QEMU_FOLDER}
	packer validate -var-file=${UBUNTU_ARM_VARS_FILE} -var-file=${NOBLE_VARS_FILE} -var-file=${NOBLE_ARM_VARS_FILE} ${QEMU_FOLDER}

validate-cloudinit-noble: init-qemu
	$(info CLOUD-INIT: Validating Ubuntu 24.04 (Noble Numbat) Cloud-Config File)
	cloud-init schema -c http/user-data

validate-jammy: init-qemu
	$(info PACKER: Validating Template with Ubuntu 22.04 (Jammy) Packer Variables)
	packer validate -var-file=${UBUNTU_AMD_VARS_FILE} -var-file=${JAMMY_VARS_FILE} -var-file=${JAMMY_AMD_VARS_FILE} ${QEMU_FOLDER}
	packer validate -var-file=${UBUNTU_ARM_VARS_FILE} -var-file=${JAMMY_VARS_FILE} -var-file=${JAMMY_ARM_VARS_FILE} ${QEMU_FOLDER}

validate-cloudinit-jammy: init-qemu
	$(info CLOUD-INIT: Validating Ubuntu 22.04 (Jammy) Cloud-Config File)
	cloud-init schema -c http/user-data

validate-focal: init-qemu
	$(info PACKER: Validating Template with Ubuntu 20.04 (Focal Fossa) Packer Variables)
	packer validate -var-file=${UBUNTU_AMD_VARS_FILE} -var-file=${FOCAL_VARS_FILE} -var-file=${FOCAL_AMD_VARS_FILE} ${QEMU_FOLDER}
	packer validate -var-file=${UBUNTU_ARM_VARS_FILE} -var-file=${FOCAL_VARS_FILE} -var-file=${FOCAL_ARM_VARS_FILE} ${QEMU_FOLDER}

validate-cloudinit-focal: init-qemu
	$(info CLOUD-INIT: Validating Ubuntu 20.04 (Focal Fossa) Cloud-Config File)
	cloud-init schema -c http/user-data

