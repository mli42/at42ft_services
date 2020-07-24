#!/bin/sh

export SSH_USERNAME=username;
export SSH_PASSWORD=password;

adduser -D ${SSH_USERNAME};
echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd

nginx -g "daemon off;"
