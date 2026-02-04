#!/bin/bash

# Start MariaDB service temporarily to initialize the database
service mariadb start

# Wait for MariaDB to be ready
while ! mysqladmin ping -hlocalhost -uroot &> /dev/null; do
  sleep 1
done

# Create database and user
mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mysql -e "CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppass';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Update bind address to allow connections from other containers
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Stop the temporary service and run mysqld as the foreground process
service mariadb stop

exec mysqld --user=mysql
