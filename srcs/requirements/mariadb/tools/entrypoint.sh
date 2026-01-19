#!/bin/bash
set -e

# Initialize database if not present
if [ ! -d "/var/lib/mysql/${MARIA_DB_DATABASE}" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    mysqld --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MARIA_DB_DATABASE};
CREATE USER IF NOT EXISTS '${MARIA_DB_USER}'@'%' IDENTIFIED BY '${MARIA_DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MARIA_DB_DATABASE}.* TO '${MARIA_DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIA_DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
fi

exec "$@"
