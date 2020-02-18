VERSION ?= v1.4
ADHOC ?= ""
MOUNT ?= /root

versions:
	docker run tools:${VERSION}

interactive:
	docker run -v `pwd`:${MOUNT} -ti tools:${VERSION} bash

home:
	docker run -v $HOME:${MOUNT} -ti tools:${VERSION} bash

build:
	docker build . --tag tools:${VERSION}
