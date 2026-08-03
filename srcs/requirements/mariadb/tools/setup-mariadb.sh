#!/bin/bash
set -e

#tells mariadb to listen on all networks
echo "[mysqld]
bind-address = 0.0.0.0" > /etc/mysql/mariadb.conf.d/99-custom.cnf

if [ ! -d /var/lib/mysql/mysql ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --skip-syslog &
MYSQL_PID=$!

echo "Waiting for MariaDB to start..."
until mysqladmin ping -u root --silent 2>/dev/null || mysqladmin ping -u root -p"$(cat /secrets/db_root_password)" --silent 2>/dev/null; do
    sleep 1
done
echo "MariaDB is ready"

if ! mysql -u root -p"$(cat /secrets/db_root_password)" -e "USE $DB_NAME;" 2>/dev/null; then
    echo "Running first-time database setup..."

    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /secrets/db_root_password)';
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$(cat /secrets/db_password)';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

    echo "Database setup complete"
fi

mysqladmin -u root -p"$(cat /secrets/db_root_password)" shutdown
wait $MYSQL_PID

exec mysqld --user=mysql --console