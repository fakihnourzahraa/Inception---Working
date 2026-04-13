#!/bin/bash
set -e

# Initialize database if not already done
if [ ! -d /var/lib/mysql/mysql ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in background temporarily for setup
mysqld_safe --skip-syslog &
MYSQL_PID=$!

# Wait for MariaDB to be ready (no password yet on first run)
echo "Waiting for MariaDB to start..."
until mysqladmin ping -u root --silent 2>/dev/null || mysqladmin ping -u root -p"$DB_ROOT_PASSWORD" --silent 2>/dev/null; do
    sleep 1
done
echo "MariaDB is ready"

# Only run setup if the wordpress database doesn't exist yet
if ! mysql -u root -p"$DB_ROOT_PASSWORD" -e "USE $DB_NAME;" 2>/dev/null; then
    echo "Running first-time database setup..."

    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

    echo "Database setup complete"
fi

# Stop the background mysqld and restart as PID 1 in foreground
mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown
wait $MYSQL_PID

exec mysqld --user=mysql --console