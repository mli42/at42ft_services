FROM ft_services

WORKDIR /tmp/

# Prerequisites
RUN apk update && \
	apk add grafana --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

COPY ./grafana.ini /usr/share/grafana/conf/custom.ini
COPY ./influxdb.yaml /usr/share/grafana/conf/provisioning/datasources/
COPY ./dashboard.yaml /usr/share/grafana/conf/provisioning/dashboards/
COPY ./dashboards /var/lib/grafana/dashboards/

EXPOSE 3000

# SUPERVISOR
COPY ./supervisord.conf /etc/
RUN mkdir -p /var/log/supervisor/

COPY ./entrypoint.sh ./
ENTRYPOINT ./entrypoint.sh
