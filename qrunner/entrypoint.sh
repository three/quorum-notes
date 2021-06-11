#!/usr/bin/env zsh
DOCKER_HOST_IP="$(dig +short host.docker.internal)"
if [[ -z $DOCKER_HOST_IP ]]; then
    DOCKER_HOST_IP="$(ip route | awk '/default/ { print $3 }')"
    grep -q host.docker.internal /etc/hosts || echo -e "$DOCKER_HOST_IP\thost.docker.internal" >>/etc/hosts
fi
[[ -n "$DOCKER_HOST_IP" ]] && echo -e "$(dig +short host.docker.internal)\tpostgres" >>/etc/hosts

exec "$@"
