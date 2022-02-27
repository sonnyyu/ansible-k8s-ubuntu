# Bootstrapping a kubernetes cluster using ansible
 
 Creating a kubernetes cluster via ansible.
# Prerequisites:
Setup Ansible:
```sh
wget https://raw.githubusercontent.com/sonnyyu/ansible-k8s-ubuntu/main/setupansible.sh
chmod +x setupansible.sh
./setupansible.sh
sudo su devops
cd ~
ssh-keygen  -N "" -f ~/.ssh/id_rsa
whoami
```
Get Install Software
```sh
git clone https://github.com/sonnyyu/ansible-k8s-ubuntu
cd ansible-k8s-ubuntu
```
Setup Host file
```sh
nano hosts-dev
# hosts-dev
[kubemasters]
kubemaster1 ansible_host=192.168.1.2
[kubeworkers]
kubeworker1 ansible_host=192.168.1.3
kubeworker2 ansible_host=192.168.1.4
```
Run Playbook to create password less login 
```sh
ansible-playbook setup-ansible.yml -usonnyyu -bK --ask-pass 
```
Test password less ssh login
```sh
ansible-playbook  checkpwless.yml
```
Test Python Version 
```sh
ansible all -m shell  -a "/usr/bin/python3 -V"
ansible all -m shell  -a "/usr/bin/python -V"
```
Test Ad-hoc 
```sh
ansible all -m ping
ansible all -a "df -h" 
ansible all -a "free -h"
ansible all -m apt -a "name=tree state=latest" -b
ansible all -a "uptime"
ansible all -m shell  -a "reboot" -b
ansible all -m shell  -a "uptime"
ansible all -m shell  -a "nproc"
```
Install Kubernetes
```sh
ansible-playbook setup_kubernetes.yml
```
Test Kubernetes
```sh
ansible all -m shell -a 'docker version' -b
ansible all -m shell -a 'kubeadm version' 
ansible all -m shell  -a "free -h"
ansible all -m shell  -a "hostname"
ansible all -m shell -a 'sysctl net.bridge.bridge-nf-call-iptables' -b
ansible all -m shell  -a "systemctl status kubelet" -b
ansible kubemaster1 -m shell  -a "kubectl get nodes" 
ansible kubemaster1 -m shell  -a "kubectl get pods --all-namespaces"
```
Make sure Kubernetes working
```sh
ansible all -m shell -a 'kubectl version' 
ansible kubemaster1 -m shell  -a "systemctl status kubelet" -b
ansible kubeworker1 -m shell  -a "systemctl status kubelet" -b
ansible kubeworker2 -m shell  -a "systemctl status kubelet" -b 
```
Install Nginx
```sh
ansible kubemaster1 -m shell  -a "kubectl create deployment nginx --image=nginx" 
ansible kubemaster1 -m shell  -a "kubectl create service nodeport nginx --tcp=80:80" 
ansible kubemaster1 -m shell  -a "kubectl get service -o wide"
```
Currently tested on Ubuntu 16.04,18.04,20.04
