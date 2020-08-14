#!/bin/sh

# sed s/__DB_USER__/$DB_USER/g /var/www/phpmyadmin/config.inc.php -i
# sed s/__DB_PASSWORD__/$DB_PASSWORD/g /var/www/phpmyadmin/config.inc.php -i
sed s/__DB_HOST__/$DB_HOST/g /var/www/phpmyadmin/config.inc.php -i

supervisord
