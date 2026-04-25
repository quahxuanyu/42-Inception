#!/bin/sh
set -e

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
    sed -i "s/password_here/${MYSQL_PASSWORD}/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
fi

until mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

if ! wp core is-installed --allow-root >/dev/null 2>&1; then
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
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
