#!/usr/bin/env sh
readonly CADDYFILE=/etc/Caddyfile

if [ -f "${CADDYFILE}" ]; then
    exec caddy -conf /etc/Caddyfile
else
    exec caddy
fi
