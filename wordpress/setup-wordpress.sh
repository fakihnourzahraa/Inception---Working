
while ! mysqladmin ping -h"$DB_HOST" ; do
    sleep 1
done
echo "MariaDB is ready"
