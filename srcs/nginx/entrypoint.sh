#!/bin/sh

export SSH_USERNAME=username;
export SSH_PASSWORD=;

adduser -D ${SSH_USERNAME};
echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd

ssh-keygen -A
/usr/sbin/sshd -D &

nginx -g "daemon off;"
