#!/bin/sh
set -e

if [ ! -f /run/secrets/db_password ]; then
    echo "Missing required secret file: /run/secrets/db_password"
    exit 1
fi

if [ ! -f /run/secrets/db_root_password ]; then
    echo "Missing required secret file: /run/secrets/db_root_password"
    exit 1
fi

MYSQL_PASSWORD_VALUE="$(cat /run/secrets/db_password)"
MYSQL_ROOT_PASSWORD_VALUE="$(cat /run/secrets/db_root_password)"

if [ -z "$MYSQL_PASSWORD_VALUE" ] || [ -z "$MYSQL_ROOT_PASSWORD_VALUE" ]; then
    echo "Missing required DB password values in Docker secrets"
    exit 1
fi

echo "=====ENTERED INIT DB SCRIPT======"
echo "Contents of /var/lib/mysql: $(ls -A /var/lib/mysql)"

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD_VALUE}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_VALUE}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi

exec mysqld --user=mysql --console
