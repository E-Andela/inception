#!/bin/bash

# Start MariaDB service temporarily to initialize the database
service mariadb start

# Wait for MariaDB to be ready
while ! mysqladmin ping -hlocalhost -uroot &> /dev/null; do
  sleep 1
done

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MARIADB_PORT=${MARIADB_PORT:-3306}

# Check if database is already initialized
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then

  mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
  mysql -uroot -e "FLUSH PRIVILEGES;"
  
  # Create database and user
  mysql -uroot -p${DB_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
  mysql -uroot -p${DB_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
  mysql -uroot -p${DB_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
  mysql -uroot -p${DB_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
fi

# Update bind address and port to allow connections from other containers
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i '/^\[mysqld\]/a port = '${MARIADB_PORT:-3306} /etc/mysql/mariadb.conf.d/50-server.cnf

# Stop the temporary service using mysqladmin with credentials
mysqladmin -uroot -p${DB_ROOT_PASSWORD} shutdown

exec mysqld --user=mysql
