#!/bin/sh

php-fpm7 --nodaemonize &
nginx -g "daemon off;"
