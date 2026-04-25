#!/bin/sh
set -e

if [ ! -f /run/secrets/db_user ]; then
    echo "Missing required secret file: /run/secrets/db_user"
    exit 1
fi

if [ ! -f /run/secrets/wp_admin ]; then
    echo "Missing required secret file: /run/secrets/wp_admin"
    exit 1
fi

if [ ! -f /run/secrets/wp_user ]; then
    echo "Missing required secret file: /run/secrets/wp_user"
    exit 1
fi

DB_USER_PASS="$(cat /run/secrets/db_user)"
WP_ADMIN_PASS="$(cat /run/secrets/wp_admin)"
WP_USER_PASSWORD="$(cat /run/secrets/wp_user)"

if [ -z "$DB_USER_PASS" ] || [ -z "$WP_ADMIN_PASS" ] || [ -z "$WP_USER_PASSWORD" ]; then
    echo "Missing required credentials values in Docker secrets"
    exit 1
fi

admin_lower=$(printf '%s' "$WP_ADMIN_USER" | tr '[:upper:]' '[:lower:]')
case "$admin_lower" in
    *admin*)
        echo "WP_ADMIN_USER must not contain 'admin' or 'administrator'"
        exit 1
        ;;
esac

if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz --strip-components=1
    rm latest.tar.gz

    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
    sed -i "s/password_here/${DB_USER_PASS}/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
fi

until mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"${DB_USER_PASS}" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

if ! wp core is-installed --allow-root >/dev/null 2>&1; then
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
fi

if ! wp user get "${WP_USER}" --field=ID --allow-root >/dev/null 2>&1; then
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=subscriber \
        --allow-root
fi

chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F
