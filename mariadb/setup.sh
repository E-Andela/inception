#!/bin/bash

# Start MariaDB service temporarily to initialize the database
service mariadb start

# Wait for MariaDB to be ready
while ! mysqladmin ping -hlocalhost -uroot &> /dev/null; do
  sleep 1
done

$DB_PASSWORD=$(cat /run/secrets/db_password)

# Create database and user
mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Update bind address to allow connections from other containers
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Stop the temporary service and run mysqld as the foreground process
service mariadb stop

exec mysqld --user=mysql
