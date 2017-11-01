#!/bin/bash

DOCKER_LABEL=archives
LOG_DIR=/var/log/archives
WEB_PORT=3000
REPLICAS=1

docker secret create archives_env ~/config/archives_env
docker service create \
  --name=archives \
  --mount="type=bind,src=$LOG_DIR,dst=$LOG_DIR" \
  --mount="type=bind,src=$LOG_DIR,dst=/app/log" \
  --replicas=$REPLICAS \
  --network=danboorunet \
  --secret=archives_env \
  --constraint="node.labels.$DOCKER_LABEL == true" \
  --env="RUN=1" \
  --detach=true \
  r888888888/archives \
  bundle exec ruby services/sqs_processor.rb
