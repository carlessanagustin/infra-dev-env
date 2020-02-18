#!/bin/bash

echo -e "Infrastructure Development Environment v1.4\n"

echo "Versions:"
sleep 0.5
# python
python --version | head -1
# ansible
ansible --version | head -1
# tower-cli
tower-cli --version | head -1
# oc
oc version | head -1
# teeraform
terraform --version | head -1
# awscli
pip list 2>/dev/null|grep awscli
# gcloud
echo -n "gcloud: " && gcloud --version |head -1 | cut -d' ' -f4
# azure
az --version | head -1
# rack
rack version | head -1
# helm
echo -n "helm: " && helm version --short | grep -i client | cut -d' ' -f2
# kops
echo -n "kops: " && kops version | head -1 | cut -d' ' -f2
# kubectl
echo -n "kubectl: " && kubectl version --short=true 2>/dev/null | head -1 | cut -d' ' -f3
# ktools
ktools | head -1

echo -e "\nUsage: make interactive"
