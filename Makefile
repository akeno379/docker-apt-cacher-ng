IMAGE_NAME = seifer08ms/apt-cacher-ng
CONTAINER_NAME = apt-cacher-ng
HOST_CACHE_DIR = /srv/docker/apt-cacher-ng

all:     build install

default: build

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
	docker run  --name ${CONTAINER_NAME} -d --restart=always -p 3142:3142 -v ${HOST_CACHE_DIR}:/var/cache/apt-cacher-ng ${IMAGE_NAME}
clean:     
	docker stop ${CONTAINER_NAME}
	docker rm ${CONTAINER_NAME}
purge:
	docker stop ${CONTAINER_NAME}
	docker rm ${CONTAINER_NAME}	    
	docker rmi ${IMAGE_NAME}

release: build push



