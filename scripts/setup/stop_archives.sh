#!/bin/sh

docker service scale archives=0
docker service rm archives
docker secret rm archives_env
