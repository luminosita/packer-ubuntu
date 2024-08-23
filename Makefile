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

VM_REPO_ROOT:=~/vm_repo

QEMU_FOLDER:=./hcl/qemu/

NOBLE_ANSIBLE_VARS_FILE:=./images/ubuntu-noble-ansible.hcl
NOBLE_K3S_SERVER_VARS_FILE:=./images/ubuntu-noble-k3s-server.hcl
NOBLE_K3S_AGENT_VARS_FILE:=./images/ubuntu-noble-k3s-agent.hcl
NOBLE_K3S_ISTIO_VARS_FILE:=./images/ubuntu-noble-k3s-istio.hcl

init-qemu:
	packer init ${QEMU_FOLDER}

build-noble-ansible-qemu-amd: validate  validate-cloudinit
	packer build -var arch="amd" -var-file=${NOBLE_ANSIBLE_VARS_FILE} -only=base.qemu.base ${QEMU_FOLDER}

build-noble-ansible-qemu-arm: validate
	packer build -var arch="arm" -var-file=${NOBLE_ANSIBLE_VARS_FILE} -only=base.qemu.base ${QEMU_FOLDER}

build-noble-k3s-server-qemu-amd: validate  validate-cloudinit
	packer build -var arch="amd" -var-file=${NOBLE_K3S_SERVER_VARS_FILE} -only=ansible.qemu.base ${QEMU_FOLDER}

build-noble-k3s-server-qemu-arm: validate
	packer build -var arch="arm" -var-file=${NOBLE_K3S_SERVER_VARS_FILE} -only=ansible.qemu.base ${QEMU_FOLDER}

build-noble-k3s-agent-qemu-amd: validate  validate-cloudinit
	packer build -var arch="amd" -var-file=${NOBLE_K3S_AGENT_VARS_FILE} -only=ansible.qemu.base ${QEMU_FOLDER}

build-noble-k3s-agent-qemu-arm: validate
	packer build -var arch="arm" -var-file=${NOBLE_K3S_AGENT_VARS_FILE} -only=ansible.qemu.base ${QEMU_FOLDER}

build-noble-k3s-istio-qemu-arm: validate
	packer build -var arch="arm" -var-file=${NOBLE_K3S_ISTIO_VARS_FILE} -only=ansible-remote.null.ansible ${QEMU_FOLDER}

validate: init-qemu
	$(info PACKER: Validating Template with Ubuntu 24.04 (Noble Numbat) Packer Variables)
	packer validate -var arch="amd" ${QEMU_FOLDER}
	packer validate -var arch="arm" ${QEMU_FOLDER}

validate-cloudinit: init-qemu
	$(info CLOUD-INIT: Validating Ubuntu 24.04 (Noble Numbat) Cloud-Config File)
	cloud-init schema -c cloud/cloud.cfg

#Make seed.img used by qemu to initialize cloud images and download proper QEMU EFI bios
prepare-arm: seed-arm qemu-efi download-noble-cloud-arm

prepare-amd: seed-amd qemu-efi download-noble-cloud-amd

seed-arm:
	docker run -it -v $(shell pwd)/cloud:/tmp/host --rm luminosita/cloud-init:latest cloud-localds /tmp/host/seed.img /tmp/host/cloud.cfg

seed-amd:
	cloud-localds cloud/seed.img cloud/cloud.cfg

qemu-efi:
	curl -L https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd -o QEMU_EFI.fd

download-noble-cloud-amd:
	mkdir -p ${VM_REPO_ROOT}/ubuntu-noble/24.04
	curl -L https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img -o ${VM_REPO_ROOT}/ubuntu-noble/24.04/ubuntu-noble-24.04.img

download-noble-cloud-arm:
	mkdir -p ${VM_REPO_ROOT}/ubuntu-noble/24.04
	curl -L https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-arm64.img -o ${VM_REPO_ROOT}/ubuntu-noble/24.04/ubuntu-noble-24.04.img