VERSION ?= v1.3
ADHOC ?= ""
MOUNT ?= /root

versions:
	docker run tools:${VERSION}

interactive:
	docker run -v `pwd`:${MOUNT} -ti tools:${VERSION} bash

run:
	docker run tools:${VERSION} '${ADHOC}'

build:
	docker build . --tag tools:${VERSION}
