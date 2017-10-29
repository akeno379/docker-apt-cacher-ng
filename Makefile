IMAGE_NAME = akeno379/apt-cacher-ng
CONTAINER_NAME = apt-cacher-ng
HOST_CACHE_DIR = /srv/docker/apt-cacher-ng
PROXY = xx-net
PROXY_PORT = 8087
PROXY_ALIAS = proxy_server
PROXY_CHECK_INTVL=320
PROXY_TIMEOUT=3

default: build

all:     build install

debug : build run-debug

build:
	docker build -t ${IMAGE_NAME} .

pull:
	docker pull ${IMAGE_NAME}

push:
	docker push ${IMAGE_NAME}

shell:
	docker exec -it ${CONTAINER_NAME} /bin/bash

install:
	docker run  --name ${CONTAINER_NAME} -d --restart=always -p 3142:3142  --env DISABLE_PROXY=1 -v ${HOST_CACHE_DIR}:/var/cache/apt-cacher-ng ${IMAGE_NAME}
proxy:
	docker run --name ${CONTAINER_NAME} --link ${PROXY}:${PROXY_ALIAS} -d --restart=always -p 3142:3142 --env PROXY_PORT=${PROXY_PORT} --env PROXY_SERVER=${PROXY_ALIAS} --env PROXY_CHECK_INTVL=${PROXY_CHECK_INTVL} --env PROXY_TIMEOUT=${PROXY_TIMEOUT}   -v ${HOST_CACHE_DIR}:/var/cache/apt-cacher-ng ${IMAGE_NAME}
clean:     
	docker stop ${CONTAINER_NAME}
	docker rm ${CONTAINER_NAME}
purge:
	docker stop ${CONTAINER_NAME};docker rm ${CONTAINER_NAME};docker rmi ${IMAGE_NAME}

release: build push



