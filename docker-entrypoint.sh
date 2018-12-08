#!/bin/bash

if [ -n "$BW_USER" ]; then
    if [ -n "$BW_PASSWORD" ]; then
        echo "$BW_USER:$BW_PASSWORD" > $HOME/.envwarden
    else
        echo "$BW_USER" > $HOME/.envwarden
    fi
fi

exec "$@"
