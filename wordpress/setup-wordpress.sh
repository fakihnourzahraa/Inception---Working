#!/bin/bash
set -e

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
until mysqladmin ping -h"$DB_HOST" --silent; do
    sleep 1
done
echo "MariaDB is ready"

# Only install WordPress if not already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    echo "Creating additional user..."
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root

    echo "WordPress setup complete"
else
    echo "WordPress already installed, skipping setup"
fi

# Start PHP-FPM in foreground (PID 1 friendly)
exec php-fpm8.2 -F