#!/bin/bash
set -e

# Initialize database if not already done
if [ ! -d /var/lib/mysql/mysql ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in background
mysqld_safe &

# Wait for MariaDB to be ready
sleep 5
while ! mysqladmin ping -u root 2>/dev/null; do
    sleep 1
done

echo "MariaDB is ready"

# Set root password
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

# Create database and user
mysql -u root -p$DB_ROOT_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

echo "Database setup complete"

# Keep container running
exec mysqld_safe