#!/bin/sh

docker container prune
docker image prune
docker build -t r888888888/archives -f script/setup/Dockerfile.archives .
docker push r888888888/archives