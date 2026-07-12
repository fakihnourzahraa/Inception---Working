#!/bin/bash

#tells mariadb to listen on all networks, not just inside the container
echo "[mysqld]
bind-address = 0.0.0.0" > /etc/mysql/mariadb.conf.d/99-custom.cnf

if [ ! -d /var/lib/mysql/mysql ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe & MYSQL_PID=$!
# my sql is a server, meaning it runs forever, so the & is to intialize the rest of the script

echo "Waiting for MariaDB to start..."
until mysqladmin ping -u root --silent 2>/dev/null; do
    sleep 1
done
echo "MariaDB is ready"

# dev null to erase errors

if ! mysql -u root -p"$DB_ROOT_PASSWORD" -e "USE $DB_NAME;" 2>/dev/null; then
    echo "Setting up database..."

    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

    echo "Database complete"
fi

mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown
wait $MYSQL_PID

exec mysqld --user=mysql --console
#becoming pid 1