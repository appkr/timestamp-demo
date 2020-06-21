CREATE USER IF NOT EXISTS 'homestead'@'%' IDENTIFIED BY 'secret';

CREATE DATABASE IF NOT EXISTS `timestamp_demo` DEFAULT CHARACTER SET = utf8mb4 DEFAULT COLLATE = utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON `timestamp_demo`.* TO 'homestead'@'%';
FLUSH PRIVILEGES;

