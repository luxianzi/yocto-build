#!/bin/sh
DOCKER_IMAGE_TAG=$(cat docker_image_tag)
docker start -a -i "$DOCKER_IMAGE_TAG"-instance

