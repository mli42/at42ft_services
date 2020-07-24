FROM alpine:3.12.0

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add nginx openssl openrc --no-cache

RUN openrc; touch /run/openrc/softlevel; # Or rc-thing just won't work...
#RUN rc-update add nginx && rc-service nginx start;
RUN mkdir -p /run/nginx/ # Or nginx won't work...

COPY ./nginx.conf /etc/nginx/
COPY ./index-mli.html /var/www/localhost/htdocs/index.html

# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=FR/ST=75/L=Paris/O=42/CN=mli" \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt

EXPOSE 80 443 22

COPY ./entrypoint.sh .
ENTRYPOINT ./entrypoint.sh
