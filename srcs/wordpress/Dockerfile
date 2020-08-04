FROM alpine:3.12.0

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add nginx vim wget php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl

RUN mkdir -p /run/nginx/ # Or nginx won't work...

# Install WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
	tar -xf latest.tar.gz && \
	mv wordpress /var/www/

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY ./wp-config.php /var/www/wordpress/

EXPOSE 5050

COPY ./entrypoint.sh .
ENTRYPOINT ./entrypoint.sh
