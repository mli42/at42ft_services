FROM alpine:3.12.0

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add vim wget mysql mysql-client

COPY ./my.cnf ~/.my.cnf
VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

COPY ./entrypoint.sh ./
ENTRYPOINT ./entrypoint.sh
