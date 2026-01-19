#!/bin/bash
set -e

# # Minimal validation to avoid partial/invalid initialization
# : "${MARIA_DB_DATABASE:?MARIA_DB_DATABASE is required}"
# : "${MARIA_DB_USER:?MARIA_DB_USER is required}"
# : "${MARIA_DB_PASSWORD:?MARIA_DB_PASSWORD is required}"
# : "${MARIA_DB_ROOT_PASSWORD:?MARIA_DB_ROOT_PASSWORD is required}"

# Initialize database if not present
if [ ! -d "/var/lib/mysql/${MARIA_DB_DATABASE}" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Quote identifiers to avoid breakage if names contain special characters
    DB_NAME_ESCAPED="${MARIA_DB_DATABASE//\`/\`\`}" 
    DB_USER_ESCAPED="${MARIA_DB_USER//\`/\`\`}" 

    mysqld --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${DB_NAME_ESCAPED}\`;
CREATE USER IF NOT EXISTS '${MARIA_DB_USER}'@'%' IDENTIFIED BY '${MARIA_DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME_ESCAPED}\`.* TO '${MARIA_DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIA_DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
fi

exec "$@"
