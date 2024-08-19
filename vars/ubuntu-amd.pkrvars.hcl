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

## Packer Variables for Ubuntu 24.04 Live Server (Noble Numbat)
ubuntu_qemuargs         = [
    ["-cpu", "host" ]
#    ["-bios", "/usr/share/ovmf/OVMF.fd"]
]

ubuntu_qemu_binary      = "qemu-system-x86_64"
ubuntu_machine_type     = "q35"
ubuntu_accelerator      = "kvm"

