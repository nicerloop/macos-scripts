#!/bin/sh
DOCKER_HOST=$(docker context inspect -f '{{ .Endpoints.docker.Host }}')
DOCKER_HOST=$DOCKER_HOST "$@"
