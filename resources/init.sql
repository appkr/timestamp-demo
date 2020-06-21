CREATE USER IF NOT EXISTS 'homestead'@'%' IDENTIFIED BY 'secret';

CREATE DATABASE IF NOT EXISTS `timestamp_demo` DEFAULT CHARACTER SET = utf8mb4 DEFAULT COLLATE = utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON `timestamp_demo`.* TO 'homestead'@'%';
FLUSH PRIVILEGES;

CREATE TABLE `timestamp_demo`.`posts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp(3) NULL DEFAULT NULL,
  `updated_at` timestamp(3) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

