#!/bin/sh

export FTP_USERNAME=42user;
export FTP_PASSWORD=42pass;

echo -e "$FTP_PASSWORD\n$FTP_PASSWORD" | adduser -h /mnt/ftp $FTP_USERNAME

if [ ! -f /home/ftps/hello ]; then
	echo "hello world!" > /mnt/ftp/hello
	mkdir -p /mnt/ftp/coucou
	echo "Coucou!" > /mnt/ftp/coucou/coucoufile
fi

supervisord
