USE wordpress;

-- Create wpuser1:wpuser1pass (Author)
INSERT INTO `wp_users` (`ID`, `user_login`, `user_pass`, `user_nicename`, `user_email`, `user_status`, `display_name`)
VALUES (NULL, 'wpuser1', MD5('wpuser1pass'), 'wpUser1', 'wpuser1@example.com', '0', 'wpUserOne');

INSERT INTO `wp_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`)
VALUES (NULL, (SELECT max(ID) from wp_users), 'wp_capabilities', 'a:1:{s:6:"author";b:1;}');

INSERT INTO `wp_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`)
VALUES (NULL, (SELECT max(ID) from wp_users), 'wp_user_level', '2');

-- Create wpuser2:wpuser2pass (Subscriber)
INSERT INTO `wp_users` (`ID`, `user_login`, `user_pass`, `user_nicename`, `user_email`, `user_status`, `display_name`)
VALUES (NULL, 'wpuser2', MD5('wpuser2pass'), 'wpUser2', 'wpuser2@example.com', '0', 'wpUserTwo');

INSERT INTO `wp_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`)
VALUES (NULL, (SELECT max(ID) from wp_users), 'wp_capabilities', 'a:1:{s:10:"subscriber";b:1;}');

INSERT INTO `wp_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`)
VALUES (NULL, (SELECT max(ID) from wp_users), 'wp_user_level', '0');
----
