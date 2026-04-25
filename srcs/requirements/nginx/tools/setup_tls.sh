#!/bin/sh
set -e

CERT=/etc/nginx/ssl/nginx.crt
KEY=/etc/nginx/ssl/nginx.key

if [ -z "$DOMAIN_NAME" ]; then
    echo "DOMAIN_NAME is not set"
    exit 1
fi

if [ ! -f "$CERT" ]; then
    echo "Generating TLS certificate..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout "$KEY" \
        -out "$CERT" \
        -subj "/CN=${DOMAIN_NAME}"
fi

# Render only DOMAIN_NAME and keep nginx runtime vars like $uri untouched.
envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf > /tmp/nginx.conf
mv /tmp/nginx.conf /etc/nginx/nginx.conf

exec nginx -g "daemon off;"
