#!/bin/bash

source .env

# Start the MariaDB service
service mysql start

# Wait for MariaDB to fully start
sleep 5

# Set root password and authentication method
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASS}'; FLUSH PRIVILEGES;"

# Create a new database
mysql -u root -p${DB_PASS} -e "CREATE DATABASE ${DB_NAME};"

# Create a new user and grant permissions
mysql -u root -p${DB_PASS} -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
mysql -u root -p${DB_PASS} -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
mysql -u root -p${DB_PASS} -e "FLUSH PRIVILEGES;"

# Create admin user
mysql -u root -p${DB_PASS} -e "CREATE USER '${ADMIN_USER}'@'%' IDENTIFIED BY '${ADMIN_PASS}';"
mysql -u root -p${DB_PASS} -e "GRANT ALL PRIVILEGES ON *.* TO '${ADMIN_USER}'@'%';"
mysql -u root -p${DB_PASS} -e "FLUSH PRIVILEGES;"
