#!/bin/sh

mkdir -p /var/ftp
export FTP_USERNAME=username;
export FTP_PASSWORD=password;

adduser -h /var/ftp -D ${FTP_USERNAME};
echo "${FTP_USERNAME}:${FTP_PASSWORD}" | chpasswd

supervisord
