#!/bin/bash
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update -y
sudo apt install ansible -y
sudo useradd -m  -s /bin/bash devops
echo devops:newpassword | sudo chpasswd
sudo usermod -aG sudo devops
sudo su devops
cd ~
ssh-keygen  -N "" -f ~/.ssh/id_rsa
whoami
