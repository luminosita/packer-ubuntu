#!/usr/bin/env bash
set -x

sudo apt -y update
sudo apt -y upgrade 
sudo apt install -y python3-venv

mkdir python-venv
cd python-venv
python3 -m venv ansible

#source ansible/bin/activate

./ansible/bin/python3 -m pip install --upgrade pip
./ansible/bin/python3 -m pip install ansible