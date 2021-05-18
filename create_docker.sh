#!/bin/bash

# build the docker image, this will take a while
DOCKER_IMAGE_TAG=$(cat docker_image_tag)
REPO_DIRECTORY=$(cat build_directory)
docker build --build-arg UID=$(id -u) -t "$DOCKER_IMAGE_TAG" .

# run the docker instance for future runs, just use the resume script
HAS_INSTANCE=$(docker container ls -a | grep "$DOCKER_IMAGE_TAG"-instance)
if [ ! -z "$HAS_INSTANCE" ];
then
	docker container rm "$DOCKER_IMAGE_TAG"-instance
fi
if [ ! -d "$REPO_DIRECTORY" ]; then
	mkdir "$REPO_DIRECTORY"
fi
DOCKER_IMAGE_TAG="$DOCKER_IMAGE_TAG" $(pwd)/run_docker.sh
