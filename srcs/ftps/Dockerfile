FROM ft_services

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add openssl vsftpd

# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=FR/ST=75/L=Paris/O=42/CN=192.168.99.101" \
	-keyout /etc/ssl/private/vsftpd.key \
	-out /etc/ssl/certs/vsftpd.crt

COPY ./vsftpd.conf /etc/vsftpd/

EXPOSE 21 30000

# SUPERVISOR
COPY ./supervisord.conf /etc/supervisord.conf

VOLUME /mnt/ftps-data

COPY ./entrypoint.sh .
ENTRYPOINT ./entrypoint.sh
