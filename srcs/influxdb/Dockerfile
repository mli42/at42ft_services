FROM ft_services

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add influxdb

RUN mkdir -p /etc/influxdb
COPY ./influxdb.conf /etc/influxdb/influxdb.conf

EXPOSE 8086

# SUPERVISOR
COPY ./supervisord.conf /etc/
RUN mkdir -p /var/log/supervisor/

COPY ./entrypoint.sh ./
ENTRYPOINT ./entrypoint.sh
