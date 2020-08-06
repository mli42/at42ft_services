FROM alpine:3.12.0

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add vim wget mariadb mariadb-common mariadb-client openrc --no-cache

COPY ./my.cnf /etc/my.cnf.d/mariadb-server.cnf
VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

COPY ./entrypoint.sh ./
ENTRYPOINT ./entrypoint.sh
