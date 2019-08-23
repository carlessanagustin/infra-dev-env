# Infrastructure Development Environment

A docker image that contains the necessary tools for doing Infrastructure Development.

## Tools

* Ansible
* Ansible Tower CLI
* Openshift CLI
* Terraform
* kubectl
* Helm
* Kubernetes Tools
* kops
* AWS CLI
* Google Cloud CLI
* Azure CLI
* Rackspace CLI

## Usage

* build: `make build`
* display all versions: `make versions`
* interactive shell + mount $HOME folders: `make home`
* interactive shell + mount current folder: `make interactive`
* adhoc commands: `make run ADHOC="<command>"`
