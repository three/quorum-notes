#!/usr/bin/env bash
grep -q host.docker.internal /etc/hosts || echo -e "$(ip route | awk '/default/ { print $3 }')\thost.docker.internal" >>/etc/hosts
python manage.py runserver_plus 0.0.0.0:8000
