VERSION ?= v1.5
ADHOC ?= ""
MOUNT ?= /shared

build:
	docker build . --tag tools:${VERSION}

versions:
	docker run tools:${VERSION}

interactive:
	docker run --privileged=false -v ${HOME}:/root -v `pwd`:${MOUNT} -ti tools:${VERSION} bash

home:
	docker run --privileged=false -v ${HOME}:/root -ti tools:${VERSION} bash

run:
	docker run tools:${VERSION} '${ADHOC}'
