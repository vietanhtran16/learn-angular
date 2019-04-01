#!/bin/bash -l
set -e
TAG_NO=$1
DOCKERHUB_IMAGE_NAME=tranvietanh/angularfrontend:$TAG_NO

docker build -t angularfrontend .
docker tag angularfrontend:latest $DOCKERHUB_IMAGE_NAME

docker push $DOCKERHUB_IMAGE_NAME