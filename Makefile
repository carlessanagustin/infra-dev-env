VERSION ?= v1.4
MOUNT ?= /root

versions:
	docker run tools:${VERSION}

interactive:
	docker run -v `pwd`:/shared -ti tools:${VERSION} bash

home:
	docker run -v ${HOME}:${MOUNT} -ti tools:${VERSION} bash

homez:
	docker run -v /var/run/docker.sock:/var/run/docker.sock -v ${HOME}:${MOUNT} -ti tools:${VERSION} zsh

build:
	docker build . --tag tools:${VERSION}

unbuild:
	docker rmi -f tools:${VERSION}