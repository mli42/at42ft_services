FROM ft_services

WORKDIR /tmp/

# Prerequisites
RUN apk update && apk add nginx openssl openssh-server openrc --no-cache

RUN openrc; touch /run/openrc/softlevel; # Or rc-thing just won't work...
#RUN rc-update add nginx && rc-service nginx start;
RUN rc-update add sshd;
RUN mkdir -p /run/nginx/ # Or nginx won't work...

COPY ./nginx.conf /etc/nginx/
COPY ./index-mli.html /var/www/localhost/htdocs/index.html
COPY ./sshd_config /etc/ssh/

# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=FR/ST=75/L=Paris/O=42/CN=mli" \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt

# SSH
VOLUME [ "/sys/fs/cgroup" ]

EXPOSE 80 443 22

# SUPERVISOR
COPY ./supervisord.conf /etc/supervisord.conf

COPY ./entrypoint.sh .
ENTRYPOINT ./entrypoint.sh
