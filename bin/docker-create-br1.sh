#! /usr/bin/env bash

docker network create \
  --driver=bridge \
  --subnet=192.168.54.0/24 \
  --ip-range=192.168.54.0/25 \
  --gateway=192.168.54.1 \
  -o "com.docker.network.bridge.name"="docker-br1" \
  br1