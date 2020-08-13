FROM ft_services

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add mariadb mariadb-common mariadb-client openrc --no-cache

COPY ./my.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY ./new_users.sql ./
COPY ./wordpress.sql ./

RUN rmdir /var/lib/mysql

# COPY ./my.cnf /etc/my.cnf
# COPY ./my.cnf /etc/mysql/my.cnf
# COPY ./my.cnf ${HOME}/.my.cnf
#
# VOLUME ["/var/lib/mysql"]
# RUN mkdir -p /run/mysqld

EXPOSE 3306

COPY ./entrypoint.sh ./
ENTRYPOINT ./entrypoint.sh
