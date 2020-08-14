FROM ft_services

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add openssl openrc vsftpd --no-cache
RUN openrc; touch /run/openrc/softlevel; # Or rc-thing just won't work...

# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=FR/ST=75/L=Paris/O=42/CN=mli" \
	-keyout /etc/ssl/private/vsftpd.key \
	-out /etc/ssl/certs/vsftpd.crt

COPY ./vsftpd.conf /etc/vsftpd/

EXPOSE 21 30000

# SUPERVISOR
COPY ./supervisord.conf /etc/supervisord.conf

COPY ./entrypoint.sh .
ENTRYPOINT ./entrypoint.sh
