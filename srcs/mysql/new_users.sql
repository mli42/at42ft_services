USE wordpress;

INSERT INTO `wp_users` (`ID`, `user_login`, `user_pass`, `user_nicename`, `user_email`, `user_status`, `display_name`)
VALUES (NULL, 'tempusereuuuh', MD5('Str0ngPa55!'), 'tempuser', 'support@wpwhitesecurity.com', '0', 'Temp User');

INSERT INTO `wp_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`)
VALUES (NULL, (SELECT max(ID) from wp_users), 'wp_capabilities', 'a:1:{s:13:"administrator";b:1;}');

INSERT INTO `wp_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`)
VALUES (NULL, (SELECT max(ID) from wp_users), 'wp_user_level', '10');
