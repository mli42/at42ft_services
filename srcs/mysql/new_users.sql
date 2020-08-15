USE wordpress;

-- Create wpuser1:wpuser1pass (Author)
INSERT INTO `wp_users` (`ID`, `user_login`, `user_pass`, `user_nicename`, `user_email`, `user_status`, `display_name`)
VALUES (2, 'wpuser1', MD5('wpuser1pass'), 'wpUser1', 'wpuser1@example.com', '0', 'wpUserOne')
ON DUPLICATE KEY UPDATE ID=ID;

INSERT INTO `wp_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`)
VALUES (19, 2, 'wp_capabilities', 'a:1:{s:6:"author";b:1;}')
ON DUPLICATE KEY UPDATE user_id=user_id;

INSERT INTO `wp_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`)
VALUES (20, 2, 'wp_user_level', '2')
ON DUPLICATE KEY UPDATE user_id=user_id;

-- Create wpuser2:wpuser2pass (Subscriber)
INSERT INTO `wp_users` (`ID`, `user_login`, `user_pass`, `user_nicename`, `user_email`, `user_status`, `display_name`)
VALUES (3, 'wpuser2', MD5('wpuser2pass'), 'wpUser2', 'wpuser2@example.com', '0', 'wpUserTwo')
ON DUPLICATE KEY UPDATE ID=ID;

INSERT INTO `wp_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`)
VALUES (21, 3, 'wp_capabilities', 'a:1:{s:10:"subscriber";b:1;}')
ON DUPLICATE KEY UPDATE user_id=user_id;

INSERT INTO `wp_usermeta` (`umeta_id`, `user_id`, `meta_key`, `meta_value`)
VALUES (22, 3, 'wp_user_level', '0')
ON DUPLICATE KEY UPDATE user_id=user_id;
----
