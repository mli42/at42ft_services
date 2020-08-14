#!/bin/sh

red="\e[1;91m"
green="\e[1;92m"
yellow="\e[1;93m"
dblue="\e[1;94m"
purple="\e[1;95m"
blue="\e[1;96m"
eoc="\e[0m"

mysql_install_db --ldata=/var/lib/mysql

# printf "${red}RED${eoc}\n"

# chown -R mysql:mysql /var/lib/mysql

# printf "${green}GREEN${eoc}\n"

# /usr/bin/mysqld_safe &

# printf "${blue}BLUE${eoc}\n"

sleep 5

# printf "${purple}PURPLE${eoc}\n"

mysqld --default-authentication-plugin=mysql_native_password &

sleep 5

tmpsql="/tmp/init_sql"
# mysqladmin -u ${DB_USER} password '${DB_PASSWORD}'
echo > $tmpsql \
"CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS ${DB_USER} IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASSWORD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}' WITH GRANT OPTION;
FLUSH PRIVILEGES;"

mysql -h localhost -e "$(cat $tmpsql)"
mysql -h localhost -e "$(cat ./wordpress.sql)"
mysql -h localhost -e "$(cat ./new_users.sql)"

rm -f $tmpsql

# SET PASSWORD FOR '${DB_USER}'@'%'=PASSWORD('${DB_PASSWORD}');
# select user, host FROM mysql.user;

# printf "${red}RED${eoc}\n"

# killall mysqld

# printf "${dblue}D BLUE${eoc}\n"

# printf "${green}GREEN${eoc}\n"

/usr/share/mariadb/mysql.server stop

supervisord
