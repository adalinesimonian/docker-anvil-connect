#!/bin/sh
docker build -t vartan/anvil-connect .
IMAGE_ID=`docker images -q vartan/anvil-connect | head -1`
docker tag $IMAGE_ID vartan/anvil-connect:0.1.56
# docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
# docker push vartan/anvil-connect:latest
# docker push vartan/anvil-connect:0.1.56
