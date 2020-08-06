#!/bin/sh

mv /var/www/wordpress /var/www/html/wordpress

php-fpm7 --nodaemonize &
nginx -g "daemon off;"
