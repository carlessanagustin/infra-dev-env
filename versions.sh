#!/usr/bin/env bash

echo -e ">> Infrastructure Development Environment v$TOOLS_VERSION"

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
echo -n "kubectl: " && kubectl version -o json | jq '.clientVersion.gitVersion'
#kubectl version --short=true 2>/dev/null | head -1 | cut -d' ' -f3
# aws
pip list 2>/dev/null|grep awscli
echo -n "aws-iam-authenticator: " && aws-iam-authenticator version | jq '.Version'
# gcloud
echo -n "gcloud: " && gcloud --version |head -1 | cut -d' ' -f4
# azure
az version | head -2 | tail -1
# docker-ce-cli
echo -n "Docker cli: " && docker version --format '{{.Client.Version}}'
docker-compose version | grep -i docker-compose

echo -e "\nUsage: make interactive"
