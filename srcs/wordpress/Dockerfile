FROM ft_services

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add --no-cache nginx \
	php7-fpm php7-mcrypt php7-session php7-soap php7-openssl php7-gmp \
	php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli \
	php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc \
	php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader \
	php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype \
	php7-opcache php7-zlib mysql-client

RUN mkdir -p /run/nginx/ # Or nginx won't work...

# Install WordPress
# COPY ./wordpress.tar.gz ./
ARG VERSION="wordpress-5.5"
ARG WP_FILE="${VERSION}.tar.gz"
RUN wget https://wordpress.org/${WP_FILE} && \
	tar -xf ${WP_FILE} && \
	mv wordpress /var/www/ && \
	rm -rf ${WP_FILE}

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY ./wp-config.php /var/www/wordpress/

EXPOSE 5050

# SUPERVISOR
COPY ./supervisord.conf /etc/

COPY ./entrypoint.sh .
ENTRYPOINT ./entrypoint.sh
