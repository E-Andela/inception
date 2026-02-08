#!/bin/bash

set -e

# Wait for MariaDB using a TCP connection test
TIMEOUT=60
ELAPSED=0
while ! bash -c "echo > /dev/tcp/$DB_HOST/3306" 2>/dev/null; do
  ELAPSED=$((ELAPSED + 1))
  if [ $ELAPSED -gt $TIMEOUT ]; then
    echo "Database connection timeout after ${TIMEOUT}s"
    exit 1
  fi
  echo "Waiting for database (${ELAPSED}s)..."
  sleep 1
done

chown -R www-data:www-data /var/www/html

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

if [ ! -f /var/www/html/wp-config.php ]; then
	wp core download --locale=en_US --allow-root
	wp config create \
	--dbname=$DB_NAME \
	--dbuser=$DB_USER \
	--dbpass=$DB_PASSWORD \
	--dbhost=$DB_HOST \
	--allow-root

	wp core install \
	--url="https://eandela.42.fr" \
	--title="Inception WordPress" \
	--admin_user="$WP_ADMIN_USER" \
	--admin_password="$WP_ADMIN_PASSWORD" \
	--admin_email="$WP_ADMIN_EMAIL" \
	--allow-root

	wp user create \
	"$WP_USER" \
	"$WP_USER_EMAIL" \
	--role=author \
	--user_pass="$WP_USER_PASSWORD" \
	--allow-root
fi

exec php-fpm8.2 -F