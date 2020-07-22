FROM alpine:3.12.0

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add nginx openssl

# Configure nginx
COPY ./srcs/nginx.conf /etc/nginx/

# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=FR/ST=75/L=Paris/O=42/CN=mli" \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt

EXPOSE 80 443 22

ENTRYPOINT nginx -g "daemon off;"
