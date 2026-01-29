#!/bin/bash

service mariadb start

mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mysql -e "CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppass';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"
mysql -e "FLUSH PRIVILEGES;"

sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

service mariadb stop

exec mysqld --user=mysql
