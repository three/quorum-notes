#!/usr/bin/env bash
([[ -d /code/venv/bin ]] && source /code/venv/bin/activate) || (
    echo "Warning! Unable to activate virtualenv."
)
exec zsh "$@"
