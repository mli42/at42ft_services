#!/bin/sh

export FTP_USERNAME=42user;
export FTP_PASSWORD=42pass;

adduser -h /home/ftps -D ${FTP_USERNAME};
echo "${FTP_USERNAME}:${FTP_PASSWORD}" | chpasswd

if [ ! -f /home/ftps/hello ]; then
	echo "hello world!" > /home/ftps/hello
fi

supervisord
