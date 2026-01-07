#!/bin/sh
set -e

CERT=/etc/nginx/ssl/nginx.crt
KEY=/etc/nginx/ssl/nginx.key

if [ ! -f "$CERT" ]; then
    echo "Generating TLS certificate..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout "$KEY" \
        -out "$CERT" \
        -subj "/CN=${DOMAIN_NAME}"
fi

exec nginx -g "daemon off;"
