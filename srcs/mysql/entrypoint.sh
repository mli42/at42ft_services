#!/bin/sh

red="\e[91m"
green="\e[92m"
yellow="\e[93m"
dblue="\e[94m"
purple="\e[95m"
blue="\e[96m"
eoc="\e[0m"

mysql_install_db --user=${DB_USER} --ldata=/var/lib/mysql

printf "${red}RED${eoc}\n"

chown -R mysql:mysql /var/lib/mysql

printf "${green}GREEN${eoc}\n"

# /usr/bin/mysqld_safe &

printf "${blue}BLUE${eoc}\n"

sleep 5

printf "${purple}PURPLE${eoc}\n"


# mysqladmin -u ${DB_USER} password '${DB_PASSWORD}'
echo >/tmp/init_sql \
"CREATE DATABASE IF NOT EXISTS ${DB_NAME}; \
SET PASSWORD FOR '${DB_USER}'@'localhost'=PASSWORD('${DB_PASSWORD}'); \
GRANT ALL ON *.* TO '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASSWORD}' WITH GRANT OPTION; \
GRANT ALL ON *.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}' WITH GRANT OPTION; \
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}'; \
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}; \
GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}' WITH GRANT OPTION; \
FLUSH PRIVILEGES;"
# select user, host FROM mysql.user;


printf "${red}RED${eoc}\n"

# killall mysqld

printf "${dblue}D BLUE${eoc}\n"

printf "${green}GREEN${eoc}\n"

# /usr/share/mariadb/mysql.server stop

/usr/bin/mysqld_safe --user=${DB_USER} --console --init_file=/tmp/init_sql

# tail -f /dev/null
