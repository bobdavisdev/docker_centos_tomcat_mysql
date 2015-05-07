#!/bin/bash

if [ "$INITDB" == true ]; then
	service mysqld start & sleep 10
	mysql -u root -e "CREATE DATABASE testdb;"
	mysql -u root -e "set password for 'root'@'%' = PASSWORD('password');"
	mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password';"
else
	echo "DB started"
fi


