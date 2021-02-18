#!/usr/bin/env zsh
cd /code
if [[ -v 1 ]]; then
    "$@"
else
    exec zsh
fi
