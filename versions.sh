#!/usr/bin/env bash

echo -e "Infrastructure Development Environment v1.3\n"

echo "Versions:"
sleep 0.5
# python
python3 --version | head -1
# ansible
ansible --version | head -1
# oc
oc version | head -1
# terraform
terraform --version | head -1
# kubectl
echo -n "kubectl: " && kubectl version --short=true 2>/dev/null | head -1 | cut -d' ' -f3
# awscli
pip list 2>/dev/null|grep awscli
# gcloud
echo -n "gcloud: " && gcloud --version |head -1 | cut -d' ' -f4
# azure
az --version | head -1

echo -e "\nUsage: make interactive"
