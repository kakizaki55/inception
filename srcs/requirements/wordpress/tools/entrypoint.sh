#!/bin/bash
set -e

# Minimal validation (fails fast instead of looping forever on empty vars)
# : "${MARIA_DB_HOSTNAME:?MARIA_DB_HOSTNAME is required}"
# : "${MARIA_DB_USER:?MARIA_DB_USER is required}"
# : "${MARIA_DB_PASSWORD:?MARIA_DB_PASSWORD is required}"
# : "${MARIA_DB_DATABASE:?MARIA_DB_DATABASE is required}"
# : "${DOMAIN_NAME:?DOMAIN_NAME is required}"
# : "${WP_ADMIN:?WP_ADMIN is required}"
# : "${WP_ADMIN_PASSWORD:?WP_ADMIN_PASSWORD is required}"
# : "${WP_ADMIN_EMAIL:?WP_ADMIN_EMAIL is required}"
# : "${WP_USER:?WP_USER is required}"
# : "${WP_USER_EMAIL:?WP_USER_EMAIL is required}"
# : "${WP_USER_PASSWORD:?WP_USER_PASSWORD is required}"

#  Wait for MariaDB to be ready (bounded, no infinite loop)
i=0
until MYSQL_PWD="${MARIA_DB_PASSWORD}" mysqladmin ping -h"${MARIA_DB_HOSTNAME}" -u"${MARIA_DB_USER}" --silent; do
  i=$((i+1))
  if [ "$i" -ge 30 ]; then
    echo "MariaDB not reachable after 30 tries; exiting."
    exit 1
  fi
  sleep 1
done

cd /var/www/html

# Download WordPress if not present
if [ ! -f wp-config.php ]; then
    wp core download --allow-root

    wp config create \
        --dbname="${MARIA_DB_DATABASE}" \
        --dbuser="${MARIA_DB_USER}" \
        --dbpass="${MARIA_DB_PASSWORD}" \
        --dbhost="${MARIA_DB_HOSTNAME}" \
        --allow-root

    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=editor \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    chown -R www-data:www-data /var/www/html
fi

# Configure php-fpm to listen on port 9000
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

exec "$@"