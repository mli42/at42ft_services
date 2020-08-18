FROM ft_services

WORKDIR /tmp/

# Prerequisites
RUN apk update && \
	apk add grafana --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

COPY ./grafana.ini /usr/share/grafana/conf/custom.ini

EXPOSE 3000

# SUPERVISOR
COPY ./supervisord.conf /etc/
RUN mkdir -p /var/log/supervisor/

COPY ./entrypoint.sh ./
ENTRYPOINT ./entrypoint.sh
