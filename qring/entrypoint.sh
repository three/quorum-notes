#!/usr/bin/env zsh
DOCKER_HOST_IP="$(dig +short host.docker.internal)"
[[ -n "$DOCKER_HOST_IP" ]] && echo -e "$(dig +short host.docker.internal)\tpostgres" >>/etc/hosts

exec "$@"
