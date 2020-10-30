.PHONY: all

# https://public-inbox.org/public-inbox.git
VERSION = 10.0.0
# https://git.kernel.org/pub/scm/git/git.git/
IMAGE_NAME ?= nishanthmenon/ccs-msp430-ci
IMAGE_TOBUILD=${IMAGE_NAME}:${VERSION}

REPO ?=
USER_ID ?=$(shell id -u)

all:
	docker build -t ${IMAGE_TOBUILD} \
		--pull .
	docker tag ${IMAGE_TOBUILD} ${IMAGE_NAME}

clean:
	docker container prune; \
	docker image ls|grep none|sed -e "s/\s\s*/ /g"|cut -d ' ' -f3|xargs docker rmi ${IMAGE_TOBUILD}

deploy:
	@echo "REPO=${REPO} IMAGE_TOBUILD=${IMAGE_TOBUILD} IMAGE_NAME=${IMAGE_NAME}"
	docker tag ${IMAGE_NAME} ${REPO}${IMAGE_TOBUILD}
	docker tag ${IMAGE_NAME} ${REPO}${IMAGE_NAME}
	docker push ${REPO}${IMAGE_TOBUILD}
	docker push ${REPO}${IMAGE_NAME}
