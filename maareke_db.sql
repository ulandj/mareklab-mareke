-- phpMyAdmin SQL Dump
-- version 4.1.6
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Июн 14 2014 г., 11:36
-- Версия сервера: 5.6.16
-- Версия PHP: 5.5.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `maareke_db`
--

DELIMITER $$
--
-- Функции
--
CREATE DEFINER=`root`@`localhost` FUNCTION `GetParents`(GivenID INT) RETURNS varchar(1024) CHARSET utf8
    DETERMINISTIC
BEGIN
    DECLARE rv VARCHAR(1024);
    DECLARE cm CHAR(1);
    DECLARE ch INT;

    SET rv = '';
    SET cm = '';
    SET ch = GivenID;
    WHILE ch > 0 DO
        SELECT IFNULL(parent_id,-1) INTO ch FROM
        (SELECT parent_id FROM region WHERE id = ch) A;
        IF ch > 0 THEN
            SET rv = CONCAT(rv,cm,ch);
            SET cm = ',';
        END IF;
    END WHILE;
    RETURN rv;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `action_type`
--

CREATE TABLE IF NOT EXISTS `action_type` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `action_type`
--

INSERT INTO `action_type` (`id`, `title`) VALUES
(1, 'post'),
(2, 'photo'),
(3, 'video'),
(4, 'comment'),
(5, 'applause');

-- --------------------------------------------------------

--
-- Структура таблицы `album`
--

CREATE TABLE IF NOT EXISTS `album` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `title` varchar(100) DEFAULT 'My Album',
  `description` text,
  `datetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `applause_count` int(11) DEFAULT '0',
  `maareke_id` int(11) DEFAULT NULL,
  `album_type` int(11) NOT NULL COMMENT '0 default, 1 users',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Дамп данных таблицы `album`
--

INSERT INTO `album` (`id`, `owner_id`, `title`, `description`, `datetime`, `applause_count`, `maareke_id`, `album_type`) VALUES
(2, 18, 'My Album', NULL, '2014-05-15 06:44:29', 0, NULL, 0),
(3, 25, 'My Album', NULL, '2014-06-02 12:27:47', 0, NULL, 0),
(4, 28, 'My Album', NULL, '2014-06-04 04:34:01', 0, NULL, 0),
(5, 29, 'My Album', NULL, '2014-06-11 14:08:41', 0, NULL, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `applause`
--

CREATE TABLE IF NOT EXISTS `applause` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_user` int(11) NOT NULL,
  `to_user` int(11) NOT NULL,
  `object_id` int(11) NOT NULL,
  `object_type` int(11) NOT NULL,
  `datetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Дамп данных таблицы `applause`
--

INSERT INTO `applause` (`id`, `from_user`, `to_user`, `object_id`, `object_type`, `datetime`) VALUES
(1, 28, 28, 33, 5, '2014-06-05 05:55:35'),
(2, 28, 28, 31, 5, '2014-06-05 05:55:35'),
(3, 28, 28, 32, 5, '2014-06-05 05:55:35'),
(4, 28, 28, 30, 5, '2014-06-05 07:03:48'),
(5, 28, 28, 29, 5, '2014-06-05 07:03:48'),
(6, 28, 28, 28, 5, '2014-06-05 07:03:48'),
(7, 28, 28, 36, 5, '2014-06-06 05:28:53'),
(8, 30, 30, 1, 3, '2014-06-11 12:37:26');

-- --------------------------------------------------------

--
-- Структура таблицы `attendence`
--

CREATE TABLE IF NOT EXISTS `attendence` (
  `id` int(11) NOT NULL,
  `maareke_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `auth_group`
--

CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `auth_group_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_5f412f9a` (`group_id`),
  KEY `auth_group_permissions_83d7f98b` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `auth_permission`
--

CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_37ef4eb4` (`content_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=94 ;

--
-- Дамп данных таблицы `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can add permission', 2, 'add_permission'),
(5, 'Can change permission', 2, 'change_permission'),
(6, 'Can delete permission', 2, 'delete_permission'),
(7, 'Can add group', 3, 'add_group'),
(8, 'Can change group', 3, 'change_group'),
(9, 'Can delete group', 3, 'delete_group'),
(10, 'Can add user', 4, 'add_user'),
(11, 'Can change user', 4, 'change_user'),
(12, 'Can delete user', 4, 'delete_user'),
(13, 'Can add content type', 5, 'add_contenttype'),
(14, 'Can change content type', 5, 'change_contenttype'),
(15, 'Can delete content type', 5, 'delete_contenttype'),
(16, 'Can add session', 6, 'add_session'),
(17, 'Can change session', 6, 'change_session'),
(18, 'Can delete session', 6, 'delete_session'),
(19, 'Can add albums', 7, 'add_albums'),
(20, 'Can change albums', 7, 'change_albums'),
(21, 'Can delete albums', 7, 'delete_albums'),
(22, 'Can add applause', 8, 'add_applause'),
(23, 'Can change applause', 8, 'change_applause'),
(24, 'Can delete applause', 8, 'delete_applause'),
(25, 'Can add attendence', 9, 'add_attendence'),
(26, 'Can change attendence', 9, 'change_attendence'),
(27, 'Can delete attendence', 9, 'delete_attendence'),
(28, 'Can add comment', 10, 'add_comment'),
(29, 'Can change comment', 10, 'change_comment'),
(30, 'Can delete comment', 10, 'delete_comment'),
(31, 'Can add django session', 11, 'add_djangosession'),
(32, 'Can change django session', 11, 'change_djangosession'),
(33, 'Can delete django session', 11, 'delete_djangosession'),
(34, 'Can add friends', 12, 'add_friends'),
(35, 'Can change friends', 12, 'change_friends'),
(36, 'Can delete friends', 12, 'delete_friends'),
(37, 'Can add maareke', 13, 'add_maareke'),
(38, 'Can change maareke', 13, 'change_maareke'),
(39, 'Can delete maareke', 13, 'delete_maareke'),
(40, 'Can add page', 14, 'add_page'),
(41, 'Can change page', 14, 'change_page'),
(42, 'Can delete page', 14, 'delete_page'),
(43, 'Can add photo', 15, 'add_photo'),
(44, 'Can change photo', 15, 'change_photo'),
(45, 'Can delete photo', 15, 'delete_photo'),
(46, 'Can add post', 16, 'add_post'),
(47, 'Can change post', 16, 'change_post'),
(48, 'Can delete post', 16, 'delete_post'),
(52, 'Can add video', 18, 'add_video'),
(53, 'Can change video', 18, 'change_video'),
(54, 'Can delete video', 18, 'delete_video'),
(55, 'Can add auth group', 19, 'add_authgroup'),
(56, 'Can change auth group', 19, 'change_authgroup'),
(57, 'Can delete auth group', 19, 'delete_authgroup'),
(58, 'Can add auth group permissions', 20, 'add_authgrouppermissions'),
(59, 'Can change auth group permissions', 20, 'change_authgrouppermissions'),
(60, 'Can delete auth group permissions', 20, 'delete_authgrouppermissions'),
(61, 'Can add auth permission', 21, 'add_authpermission'),
(62, 'Can change auth permission', 21, 'change_authpermission'),
(63, 'Can delete auth permission', 21, 'delete_authpermission'),
(64, 'Can add auth user', 22, 'add_authuser'),
(65, 'Can change auth user', 22, 'change_authuser'),
(66, 'Can delete auth user', 22, 'delete_authuser'),
(67, 'Can add auth user groups', 23, 'add_authusergroups'),
(68, 'Can change auth user groups', 23, 'change_authusergroups'),
(69, 'Can delete auth user groups', 23, 'delete_authusergroups'),
(70, 'Can add auth user user permissions', 24, 'add_authuseruserpermissions'),
(71, 'Can change auth user user permissions', 24, 'change_authuseruserpermissions'),
(72, 'Can delete auth user user permissions', 24, 'delete_authuseruserpermissions'),
(73, 'Can add django admin log', 25, 'add_djangoadminlog'),
(74, 'Can change django admin log', 25, 'change_djangoadminlog'),
(75, 'Can delete django admin log', 25, 'delete_djangoadminlog'),
(76, 'Can add django content type', 26, 'add_djangocontenttype'),
(77, 'Can change django content type', 26, 'change_djangocontenttype'),
(78, 'Can delete django content type', 26, 'delete_djangocontenttype'),
(79, 'Can add kv store', 27, 'add_kvstore'),
(80, 'Can change kv store', 27, 'change_kvstore'),
(81, 'Can delete kv store', 27, 'delete_kvstore'),
(82, 'Can add page type', 28, 'add_pagetype'),
(83, 'Can change page type', 28, 'change_pagetype'),
(84, 'Can delete page type', 28, 'delete_pagetype'),
(85, 'Can add region', 29, 'add_region'),
(86, 'Can change region', 29, 'change_region'),
(87, 'Can delete region', 29, 'delete_region'),
(88, 'Can add region type', 30, 'add_regiontype'),
(89, 'Can change region type', 30, 'change_regiontype'),
(90, 'Can delete region type', 30, 'delete_regiontype'),
(91, 'Can add message', 31, 'add_message'),
(92, 'Can change message', 31, 'change_message'),
(93, 'Can delete message', 31, 'delete_message');

-- --------------------------------------------------------

--
-- Структура таблицы `auth_user`
--

CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fb_id` bigint(20) DEFAULT NULL,
  `email` varchar(75) DEFAULT NULL,
  `password` varchar(128) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `country` int(11) DEFAULT NULL,
  `region` int(11) DEFAULT NULL,
  `gender` tinyint(4) DEFAULT NULL,
  `marital_status` int(11) DEFAULT NULL,
  `avatar` int(11) DEFAULT NULL,
  `wallpaper` int(11) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `activation_code` varchar(255) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `date_joined` datetime DEFAULT CURRENT_TIMESTAMP,
  `username` varchar(30) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `user_channel` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `page_type` int(11) DEFAULT NULL,
  `address` text,
  `description` text,
  `phone` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=33 ;

--
-- Дамп данных таблицы `auth_user`
--

INSERT INTO `auth_user` (`id`, `fb_id`, `email`, `password`, `first_name`, `last_name`, `birthday`, `country`, `region`, `gender`, `marital_status`, `avatar`, `wallpaper`, `is_superuser`, `is_staff`, `is_active`, `activation_code`, `last_login`, `date_joined`, `username`, `token`, `user_channel`, `parent_id`, `page_type`, `address`, `description`, `phone`) VALUES
(2, NULL, 'admin@yandex.ru', '!CjuXmkZk3TY0ddYiDwoePUEx8FmCjB6KwdPNi1R8', '', '', NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, NULL, '2014-05-09 05:52:02', '2014-05-09 05:52:02', 'admin@yandex.ru', '1', '', NULL, NULL, NULL, NULL, NULL),
(19, NULL, 'joker1988_88@mail.ru', 'pbkdf2_sha256$12000$zsiBuyRaYzt6$YK6ik2C8Z6Oqxk2cQZixqG6JTf8bJecMuntBiwcBplU=', 'Mutalip', 'Usmanov', '1988-09-17', 1, 2, 0, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-05-18 12:11:51', '2014-05-18 08:16:31', 'joker1988_88@mail.ru', '3', NULL, NULL, NULL, NULL, NULL, NULL),
(20, NULL, 'jumamidin@gmail.com', 'pbkdf2_sha256$12000$96kyUB2KolgD$cKICwjAoT277bHau+yGlTEtjq3G6HNLrkpEs0GmF6yM=', 'Jumamidin', 'Tashaliev', '1985-02-21', 1, 7, 0, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-06-08 11:00:12', '2014-05-18 09:20:52', 'jumamidin@gmail.com', '4', NULL, NULL, NULL, NULL, NULL, NULL),
(21, NULL, 'a.isakuulu@gmail.com', 'pbkdf2_sha256$12000$lwT6Wgann0Fe$+U2A4qO8K/i6ZzOSClFlLwScb7jq5rH0y4slyvhPg34=', 'habib', 'isakuulu', '1986-01-09', 1, 7, 0, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-05-19 13:37:15', '2014-05-18 09:20:52', 'a.isakuulu@gmail.com', '5', NULL, NULL, NULL, NULL, NULL, NULL),
(22, NULL, 'samudinua@gmail.com', 'pbkdf2_sha256$12000$brLjsh5pHnN7$pqzJY+mAqjaYdfxHR2bDbQ7RUij3kRseKkKcXxo2B6g=', 'Asanbek', 'Samudin uulu', '1990-04-25', 1, 6, 0, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-05-18 12:02:28', '2014-05-18 09:20:52', 'samudinua@gmail.com', '6', NULL, NULL, NULL, NULL, NULL, NULL),
(23, NULL, 'rahmanaliev-nurl@mail.ru', 'pbkdf2_sha256$12000$ftFx194HmMsj$5Z5Scfo2Hps+9EXZAAgfWO46xrQE7IbRJWACTif6b0c=', 'nurlan', 'asdadasd', '1996-10-18', 1, 5, 0, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-05-18 12:15:30', '2014-05-18 11:56:11', 'rahmanaliev-nurl@mail.ru', '7', NULL, NULL, NULL, NULL, NULL, NULL),
(24, NULL, 'begali.89kg@mail.ru', 'pbkdf2_sha256$12000$oq6e29bJj4dF$Oc3XYffgbQbxqo5sgsMzNEmcTVKhugnKlLJacIz62wk=', 'begali', 'Sydykov', '1989-08-11', 1, 5, 0, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-05-18 12:34:41', '2014-05-18 11:56:11', 'begali.89kg@mail.ru', '8', NULL, NULL, NULL, NULL, NULL, NULL),
(25, NULL, 'ulandj@yandex.ru', 'pbkdf2_sha256$12000$0OhBPnwHAPdX$dsNLB5AOLCVUt/TUSD0dTznTPWOQwgBShUUjhS7VJgw=', 'Ulan', 'djamanbalaev', '2014-01-01', 1, 4, 0, NULL, NULL, NULL, 0, 1, 1, 'adfaa8aa299c24925f61cf38682a42ba', '2014-06-08 04:55:17', '2014-05-23 05:56:43', 'ulandj@yandex.ru', '9', NULL, NULL, NULL, NULL, NULL, NULL),
(26, NULL, NULL, '', 'Logout test', '', NULL, 1, 4, NULL, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-05-26 13:32:54', '2014-05-26 13:24:13', '', '', '', 18, 1, 'logout test address', 'asdfas', '555 40 40 40'),
(28, 100007862798792, 'udjamanbalaev@gmail.com', 'pbkdf2_sha256$12000$sMRh3WEG0IfZ$unmJn1F4Eap8gIwwUuiwMVTIq2fLp08Ot1cjASoGHwo=', 'Ulan', 'Djamanbalaev', '2011-03-03', 1, 4, 1, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-06-14 06:54:48', '2014-06-03 06:22:56', 'udjamanbalaev@gmail.com', '', '', NULL, NULL, '', '', ''),
(29, NULL, '', '', 'tam', '', NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-06-12 10:28:22', '2014-06-11 08:21:05', '', '', '', 28, 3, 'bishkek', 'bish tamada', '55523423'),
(30, NULL, '', '', 'new page tamada', '', NULL, 1, 3, NULL, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-06-14 06:52:01', '2014-06-11 08:57:17', '', '', '', 28, 3, 'bishkek, center', 'test testtests', '5345346'),
(31, NULL, '', '', 'new page', '', NULL, 1, 3, NULL, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-06-12 05:17:48', '2014-06-12 05:17:39', '', '', '', 30, 3, 'asdfasdfasd', 'asdfasdfsadf', '555555'),
(32, NULL, '', '', 'new ulan page', '', NULL, 1, 3, NULL, NULL, NULL, NULL, 0, 1, 1, NULL, '2014-06-12 06:24:09', '2014-06-12 06:24:01', '', '', '', 28, 3, 'asdfasdfasd', 'asdfasdfasdf', '555555');

-- --------------------------------------------------------

--
-- Структура таблицы `auth_user_groups`
--

CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_6340c63c` (`user_id`),
  KEY `auth_user_groups_5f412f9a` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `auth_user_user_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_6340c63c` (`user_id`),
  KEY `auth_user_user_permissions_83d7f98b` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `comment`
--

CREATE TABLE IF NOT EXISTS `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `text` text NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `object_type` int(11) NOT NULL,
  `object_id` int(11) NOT NULL,
  `applause_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=34 ;

--
-- Дамп данных таблицы `comment`
--

INSERT INTO `comment` (`id`, `owner_id`, `text`, `datetime`, `object_type`, `object_id`, `applause_count`) VALUES
(33, 28, 'test_comment', '2014-06-05 10:57:50', 5, 35, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `data_type`
--

CREATE TABLE IF NOT EXISTS `data_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

--
-- Дамп данных таблицы `data_type`
--

INSERT INTO `data_type` (`id`, `name`) VALUES
(1, 'int'),
(2, 'text'),
(3, 'textarea'),
(4, 'checkbox'),
(5, 'radio'),
(6, 'range'),
(7, 'select'),
(8, 'phone'),
(9, 'photo'),
(10, 'multiselect'),
(11, 'boolean'),
(12, 'optiongroup');

-- --------------------------------------------------------

--
-- Структура таблицы `django_admin_log`
--

CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_6340c63c` (`user_id`),
  KEY `django_admin_log_37ef4eb4` (`content_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `django_content_type`
--

CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=32 ;

--
-- Дамп данных таблицы `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `name`, `app_label`, `model`) VALUES
(1, 'log entry', 'admin', 'logentry'),
(2, 'permission', 'auth', 'permission'),
(3, 'group', 'auth', 'group'),
(4, 'user', 'auth', 'user'),
(5, 'content type', 'contenttypes', 'contenttype'),
(6, 'session', 'sessions', 'session'),
(7, 'albums', 'main_app', 'albums'),
(8, 'applause', 'main_app', 'applause'),
(9, 'attendence', 'main_app', 'attendence'),
(10, 'comment', 'main_app', 'comment'),
(11, 'django session', 'main_app', 'djangosession'),
(12, 'friends', 'main_app', 'friends'),
(13, 'maareke', 'main_app', 'maareke'),
(14, 'page', 'main_app', 'page'),
(15, 'photo', 'main_app', 'photo'),
(16, 'post', 'main_app', 'post'),
(18, 'video', 'main_app', 'video'),
(19, 'auth group', 'main_app', 'authgroup'),
(20, 'auth group permissions', 'main_app', 'authgrouppermissions'),
(21, 'auth permission', 'main_app', 'authpermission'),
(22, 'auth user', 'main_app', 'authuser'),
(23, 'auth user groups', 'main_app', 'authusergroups'),
(24, 'auth user user permissions', 'main_app', 'authuseruserpermissions'),
(25, 'django admin log', 'main_app', 'djangoadminlog'),
(26, 'django content type', 'main_app', 'djangocontenttype'),
(27, 'kv store', 'thumbnail', 'kvstore'),
(28, 'page type', 'main_app', 'pagetype'),
(29, 'region', 'main_app', 'region'),
(30, 'region type', 'main_app', 'regiontype'),
(31, 'message', 'main_app', 'message');

-- --------------------------------------------------------

--
-- Структура таблицы `django_session`
--

CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_b7b81f0c` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('0a8pfl49tu4ycavu0jwjjtovi3vebl1d', 'NDdmMWJhOTNjNTI5MTA2ZjlkYzkxNDNkNzVkMmIxYTQyOTYwNjViZTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyMX0=', '2014-06-01 11:56:48'),
('0tap1mdwta1d4cokyp1qhu6dwwan9ibp', 'MzhkN2FjMjhhMzcxMjBjNmM2NjZmZDUyZjZlYzAwMzMyMThjN2NhYjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyMn0=', '2014-06-01 12:02:28'),
('1e5f5gvuvzpa3oud7h3zwlklihcpcxxp', 'NGI3OGMzMzRiMzcxZjdiZjA4YWZjM2E2MDg2ZjRiYWQ2Y2RhNDE1Nzp7fQ==', '2014-06-09 13:40:57'),
('1v8cx8bcx1f85ba4lhys09p0jkx0bk0z', 'NGI3OGMzMzRiMzcxZjdiZjA4YWZjM2E2MDg2ZjRiYWQ2Y2RhNDE1Nzp7fQ==', '2014-05-26 12:02:23'),
('2flldax0gu8iflbxdvx01lcf9rnb9xih', 'NGI3OGMzMzRiMzcxZjdiZjA4YWZjM2E2MDg2ZjRiYWQ2Y2RhNDE1Nzp7fQ==', '2014-05-24 05:25:39'),
('36ig9v299ym7b9ufkpuzi21zcczdl2qs', 'ZTJlYjMxYTUxOGZhMWMwODQzNGI2ODdmOGM5Y2FlZGM5NjFlNTc0ZTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyNX0=', '2014-06-16 08:22:26'),
('3ymcfy0pxleuk8s0d20g01rkg6vel3id', 'ZmZkOWU4YjBjNWQxZDYyM2E3NGFjNGRmOTQ0MTAzNmU3ODYwZGQ4NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-06-02 12:09:27'),
('4cdza4w0p88s7ief68jgxyn2wexhyny3', 'ZmZkOWU4YjBjNWQxZDYyM2E3NGFjNGRmOTQ0MTAzNmU3ODYwZGQ4NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-06-01 12:28:20'),
('58nzibeglgp862bdfkbzgscgb17w33kp', 'ZTZhYmNjNzllOTMxNjQ3ZDk4MWIyMTU1MjVhNmY1NjM3M2Q4YTZhZjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-06-11 13:53:21'),
('5z4o6h1wfau4lybqqfch9sld0ttzu9os', 'NmMwODg3MWIxZmY3OWUwZjZhZGM2NzY0ZWRhOWFhNTk2NmIyNjA0MDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOX0=', '2014-06-01 12:11:52'),
('634j2qy8vif3v2pmtf6udkhn2oma2fz9', 'NGI3OGMzMzRiMzcxZjdiZjA4YWZjM2E2MDg2ZjRiYWQ2Y2RhNDE1Nzp7fQ==', '2014-06-05 06:13:12'),
('6s50blo1s40r00qycoltf0yc8avsncgk', 'ZTZhYmNjNzllOTMxNjQ3ZDk4MWIyMTU1MjVhNmY1NjM3M2Q4YTZhZjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-06-11 11:59:52'),
('6s73e63w55yrutmf1sz4dqv6a0xv0r9s', 'ZmZkOWU4YjBjNWQxZDYyM2E3NGFjNGRmOTQ0MTAzNmU3ODYwZGQ4NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-05-28 13:31:16'),
('80f9j4yj1xmkwrfaf0jhzymacvkrx8ip', 'MzRmYjBiNTA0N2Q1MGUxY2Y3NWE1YzE2NGE0NzUwNWZiMDhiNzM1NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyOH0=', '2014-06-27 06:57:44'),
('8plh4vkk81ul41e2ewilvby6ysdgs0rn', 'MzRmYjBiNTA0N2Q1MGUxY2Y3NWE1YzE2NGE0NzUwNWZiMDhiNzM1NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyOH0=', '2014-06-22 12:11:17'),
('ameftfl0vkl6phw62e732bmjrd0s0rg7', 'NmMwODg3MWIxZmY3OWUwZjZhZGM2NzY0ZWRhOWFhNTk2NmIyNjA0MDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOX0=', '2014-06-01 12:10:34'),
('e54645qiz1xt4mzrcedf7oxml9f5wjqg', 'YmJhYTdhMTgxMWQ5YzMxMWU3NTA3ODdhODRiYTJlOTk0Y2Y0MDcwZjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLlBhZ2VBdXRoIiwiX2F1dGhfdXNlcl9pZCI6Mjh9', '2014-06-26 09:27:48'),
('ekfss4h2tungd8m9rzbu4etijgc8tiqy', 'ZmZkOWU4YjBjNWQxZDYyM2E3NGFjNGRmOTQ0MTAzNmU3ODYwZGQ4NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-06-01 12:12:50'),
('fm6twpgb9st5x3g42pqas17fnbptv11g', 'NGI3OGMzMzRiMzcxZjdiZjA4YWZjM2E2MDg2ZjRiYWQ2Y2RhNDE1Nzp7fQ==', '2014-06-01 13:32:17'),
('g78dq20qxm8cyfheusfd91sbcs92ywfc', 'ZTZhYmNjNzllOTMxNjQ3ZDk4MWIyMTU1MjVhNmY1NjM3M2Q4YTZhZjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-06-13 10:12:11'),
('gy9l74miekho6gguxwm6fgnhoibmksvk', 'ZmZkOWU4YjBjNWQxZDYyM2E3NGFjNGRmOTQ0MTAzNmU3ODYwZGQ4NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-06-01 12:10:23'),
('hv8x0r9dq1oooynuea16zifgt3n32pkr', 'YmJhYTdhMTgxMWQ5YzMxMWU3NTA3ODdhODRiYTJlOTk0Y2Y0MDcwZjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLlBhZ2VBdXRoIiwiX2F1dGhfdXNlcl9pZCI6Mjh9', '2014-06-26 10:41:22'),
('ieri435e38p7twcjtsf25h0a70p5tap4', 'MzRmYjBiNTA0N2Q1MGUxY2Y3NWE1YzE2NGE0NzUwNWZiMDhiNzM1NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyOH0=', '2014-06-26 04:29:48'),
('jmq2zfjjixegvnb8kxz9lrsd9ragy6fp', 'ZTJlYjMxYTUxOGZhMWMwODQzNGI2ODdmOGM5Y2FlZGM5NjFlNTc0ZTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyNX0=', '2014-06-22 04:55:18'),
('l1ilko54p0zyfdpll96ruuyczqq4jxgu', 'MTQ3ZjQ3NzVjNjIwMWFmMGI2N2M4N2RhMTNmNTZiZTUwYTQwMWY1Mjp7fQ==', '2014-06-11 10:54:18'),
('mus2knu0n4o6z4h4ct0jnmaiiz2ulnlp', 'NGI3OGMzMzRiMzcxZjdiZjA4YWZjM2E2MDg2ZjRiYWQ2Y2RhNDE1Nzp7fQ==', '2014-06-02 13:37:34'),
('nxdj19pwf5lrg1fvqljawzy5qd68jp1h', 'NGI3OGMzMzRiMzcxZjdiZjA4YWZjM2E2MDg2ZjRiYWQ2Y2RhNDE1Nzp7fQ==', '2014-06-06 04:22:12'),
('okac9d8wsv2e8rffx9ymjqcbm7xmuew9', 'OTc4MGFjMTdkYTgzZTQ0ODMxMzVhNTk0NjNjMzA3ZGIzYmU3NmE1ODp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyM30=', '2014-06-01 12:15:30'),
('okcv3hgblg1tkbejru9w1kdmgqjy0gbj', 'ZmZkOWU4YjBjNWQxZDYyM2E3NGFjNGRmOTQ0MTAzNmU3ODYwZGQ4NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-06-06 07:02:27'),
('pu5ctx4dndxeh875s9m0vstc19ys2edm', 'YzE4OWE5MzM5YzRmNjA3MzMxZTUyYTlkMjAyOTFkNzYyZmExOTIwYTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyMH0=', '2014-06-01 11:57:56'),
('pv9lkxrsq6bhk894hnf0tpuyu5jg98l0', 'MzRmYjBiNTA0N2Q1MGUxY2Y3NWE1YzE2NGE0NzUwNWZiMDhiNzM1NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyOH0=', '2014-06-26 04:32:17'),
('pvl5h0ifnrefnoqgccctuqe6rdarauwz', 'MWJlYmI4OWNlMmQ5YjFiMzM4YzU1Y2FmMjg5OGE0OTUxNzVlYTU0Nzp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLlBhZ2VBdXRoIiwiX2F1dGhfdXNlcl9pZCI6MzB9', '2014-06-25 12:31:30'),
('pyixn56ahwz3tvc7sb1o75qg1cgv8nr1', 'MzRmYjBiNTA0N2Q1MGUxY2Y3NWE1YzE2NGE0NzUwNWZiMDhiNzM1NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyOH0=', '2014-06-25 04:47:39'),
('q2c6t7y4dyxglp8l3qotwo71mf7a09y2', 'NGI3OGMzMzRiMzcxZjdiZjA4YWZjM2E2MDg2ZjRiYWQ2Y2RhNDE1Nzp7fQ==', '2014-06-03 05:47:35'),
('repes1qtkw103ny8dpalx15yywy8gdva', 'ZmZkOWU4YjBjNWQxZDYyM2E3NGFjNGRmOTQ0MTAzNmU3ODYwZGQ4NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-05-30 04:36:08'),
('rk3fp09qjnda4yy2vsy7c6wdz78vsp6l', 'MzRmYjBiNTA0N2Q1MGUxY2Y3NWE1YzE2NGE0NzUwNWZiMDhiNzM1NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyOH0=', '2014-06-23 11:19:24'),
('ue3edfn1srzohgefjq85bv3qs62zvtmp', 'MzRmYjBiNTA0N2Q1MGUxY2Y3NWE1YzE2NGE0NzUwNWZiMDhiNzM1NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyOH0=', '2014-06-17 06:27:54'),
('upfgqx6mh6kdzilmkonfsrhonkzdum77', 'YmJhYTdhMTgxMWQ5YzMxMWU3NTA3ODdhODRiYTJlOTk0Y2Y0MDcwZjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLlBhZ2VBdXRoIiwiX2F1dGhfdXNlcl9pZCI6Mjh9', '2014-06-28 06:54:48'),
('vdd254htnld0538y6jrsp5o6qqnw3vek', 'NGRiNDE5MDAzYzg1NzkzNTg0N2FiZThmODA3NWJlZDBlM2IxOGE5MDp7InVkamFtYW5iYWxhZXZAZ21haWwuY29tIjoiQ0FBS0hMRmlrWGU0QkFGWkN3YXZRV3k3YkZENW5VSjc2U0Y3bmZGNVNZVkFMUEJZeDB6UkplR3JFbnFaQlRKdlVQbGdIdjU5cXgyY1B3SkZCWkJmSWd3MzhCdFByWkFkWkE4ZFJraEowRGRjTWV4T2Q2SzAwRFpBRzdFVXhhRkdaQWtaQ1B4T2NZSm1mb3lkN1hJNUZMZmxpQkJneTNJQU9vdjNZUGloZ0IwTldoSGFlQXE4SXJZeW4iLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJiYWNrZW5kcy5BdXRoQmFja2VuZC5GQkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-05-26 10:28:12'),
('vnpohi1u40df5mfy353yox5ee2kjf44f', 'YWY4NmZiNzBlYmZhOWRhOGQ3NDMyYWZiZjQ4NDU5ZTI1NDBjODBkNTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLlBhZ2VBdXRoIiwiX2F1dGhfdXNlcl9pZCI6Mjl9', '2014-06-25 14:06:42'),
('wksuqtbfhuue5wmx7x3f0q83qgc9r2hm', 'ZTZhYmNjNzllOTMxNjQ3ZDk4MWIyMTU1MjVhNmY1NjM3M2Q4YTZhZjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoxOH0=', '2014-06-16 04:48:00'),
('yhxy2s8src5s1hpv1coqk5qerdoymgul', 'MzRmYjBiNTA0N2Q1MGUxY2Y3NWE1YzE2NGE0NzUwNWZiMDhiNzM1NTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImJhY2tlbmRzLkF1dGhCYWNrZW5kLkF1dGgiLCJfYXV0aF91c2VyX2lkIjoyOH0=', '2014-06-20 03:41:58');

-- --------------------------------------------------------

--
-- Структура таблицы `friends`
--

CREATE TABLE IF NOT EXISTS `friends` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT NULL,
  `friend_id` int(11) DEFAULT NULL,
  `datetime` timestamp NULL DEFAULT NULL,
  `request` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `friends`
--

INSERT INTO `friends` (`id`, `owner_id`, `friend_id`, `datetime`, `request`) VALUES
(1, 28, 20, '2014-06-10 14:53:38', 0),
(2, 28, 22, '2014-06-11 14:05:03', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `maareke`
--

CREATE TABLE IF NOT EXISTS `maareke` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `location` text NOT NULL,
  `country` int(11) DEFAULT NULL,
  `region` int(11) DEFAULT NULL,
  `event_date` date DEFAULT NULL,
  `event_time` time DEFAULT NULL,
  `applause_count` int(11) DEFAULT NULL,
  `attend_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `maareke`
--

INSERT INTO `maareke` (`id`, `owner_id`, `title`, `description`, `location`, `country`, `region`, `event_date`, `event_time`, `applause_count`, `attend_count`) VALUES
(1, 28, 'asdfasdf', 'asdfasdfasdf', 'asdfasdf', 1, 4, '2014-06-12', '11:05:00', 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `maareke_objects`
--

CREATE TABLE IF NOT EXISTS `maareke_objects` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `maareke_objects`
--

INSERT INTO `maareke_objects` (`id`, `title`) VALUES
(0, 'user'),
(1, 'page'),
(2, 'maareke'),
(3, 'post'),
(4, 'video'),
(5, 'photo'),
(6, 'comment');

-- --------------------------------------------------------

--
-- Структура таблицы `message`
--

CREATE TABLE IF NOT EXISTS `message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_user` int(11) NOT NULL,
  `to_user` int(11) NOT NULL,
  `text` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_read` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=294 ;

--
-- Дамп данных таблицы `message`
--

INSERT INTO `message` (`id`, `from_user`, `to_user`, `text`, `create_date`, `is_read`) VALUES
(1, 19, 18, 'test', '2014-05-18 08:00:52', 1),
(2, 18, 19, 'test1', '2014-05-18 08:01:19', 1),
(3, 19, 18, 'test2', '2014-05-18 08:01:30', 1),
(4, 18, 19, 'Privet', '2014-05-18 11:17:28', 1),
(5, 18, 19, 'Kaka dela???', '2014-05-18 11:17:46', 1),
(6, 19, 18, 'Horosho ))', '2014-05-18 11:17:55', 1),
(7, 19, 18, 'Kak sam???', '2014-05-18 11:18:02', 1),
(8, 18, 19, 'Joker', '2014-05-18 11:47:06', 1),
(9, 18, 19, 'alskdjfaslkdjfskdfja;lskdfj', '2014-05-18 11:50:36', 1),
(10, 19, 18, 'Apert ', '2014-05-18 11:50:42', 1),
(11, 19, 18, 'mopei ))]', '2014-05-18 11:50:55', 1),
(12, 20, 19, 'sign in', '2014-05-18 11:53:02', 1),
(13, 20, 18, 'sign in', '2014-05-18 11:53:15', 1),
(14, 22, 18, 'hey', '2014-05-18 11:58:18', 1),
(15, 22, 18, 'hey', '2014-05-18 11:58:26', 1),
(16, 22, 18, 'kanday', '2014-05-18 11:58:27', 1),
(17, 21, 18, 'sign', '2014-05-18 11:58:31', 1),
(18, 22, 18, 'jiji', '2014-05-18 11:58:33', 1),
(19, 21, 19, 'sign', '2014-05-18 11:58:43', 1),
(20, 22, 18, 'jffd', '2014-05-18 11:58:48', 1),
(21, 21, 22, 'sign', '2014-05-18 11:58:53', 1),
(22, 22, 18, 'yreyrey', '2014-05-18 11:59:00', 1),
(23, 22, 18, 'sign', '2014-05-18 11:59:04', 1),
(24, 22, 18, 'kanday deym', '2014-05-18 11:59:05', 1),
(25, 22, 19, 'sign', '2014-05-18 11:59:12', 1),
(26, 22, 21, 'sign', '2014-05-18 11:59:25', 1),
(27, 22, 18, 'ghdhfd', '2014-05-18 11:59:49', 1),
(28, 22, 18, 'kanda', '2014-05-18 12:00:17', 1),
(29, 23, 18, 'yahoo', '2014-05-18 12:03:32', 1),
(30, 24, 18, 'hello dude how aare you ? ', '2014-05-18 12:17:13', 1),
(31, 18, 19, 'test', '2014-05-18 12:33:57', 1),
(32, 18, 19, 'skdlkfjasdf', '2014-05-18 12:34:03', 1),
(33, 21, 19, 'kanday', '2014-05-18 12:34:05', 1),
(34, 19, 18, 'Utaae ', '2014-05-18 12:34:08', 1),
(35, 23, 18, 'hello', '2014-05-18 12:34:10', 1),
(36, 21, 18, 'kanday', '2014-05-18 12:34:13', 1),
(37, 19, 18, 'Sen jok eeke', '2014-05-18 12:34:15', 1),
(38, 22, 18, 'yahooo', '2014-05-18 12:34:23', 1),
(39, 19, 21, 'Jkasdfsdfds', '2014-05-18 12:34:28', 1),
(40, 23, 18, 'sadjhaskjhdjasha ', '2014-05-18 12:34:29', 1),
(41, 23, 18, 'hdsakjdhasj d', '2014-05-18 12:34:30', 1),
(42, 23, 18, 'as dasjdjk as', '2014-05-18 12:34:31', 1),
(43, 23, 18, 'sa dashaj ', '2014-05-18 12:34:32', 1),
(44, 21, 22, 'kanday', '2014-05-18 12:34:39', 1),
(45, 18, 22, 'test', '2014-05-18 12:34:45', 1),
(46, 23, 22, 'sgaf', '2014-05-18 12:34:49', 1),
(47, 21, 19, 'asjasj', '2014-05-18 12:34:50', 1),
(48, 23, 22, 'sajfjhaskhkf', '2014-05-18 12:34:51', 1),
(49, 23, 22, 'sahfksjahfjashj', '2014-05-18 12:34:52', 1),
(50, 23, 22, 'safhakjf', '2014-05-18 12:34:53', 1),
(51, 22, 21, 'yahoo', '2014-05-18 12:34:53', 1),
(52, 19, 21, 'Urraaa ', '2014-05-18 12:34:54', 1),
(53, 21, 19, 'kask', '2014-05-18 12:34:59', 1),
(54, 23, 21, 'fjlkjghasfdjaskd', '2014-05-18 12:35:23', 1),
(55, 24, 18, 'I''m not like you', '2014-05-18 12:35:33', 1),
(56, 24, 18, 'Don''t mix', '2014-05-18 12:35:42', 1),
(57, 24, 22, 'Asan', '2014-05-18 12:35:55', 1),
(58, 18, 23, 'sign', '2014-05-18 12:36:02', 1),
(59, 19, 23, 'sign', '2014-05-18 12:36:12', 1),
(60, 20, 23, 'sign', '2014-05-18 12:36:22', 1),
(61, 21, 23, 'sign', '2014-05-18 12:36:29', 1),
(62, 22, 23, 'sign', '2014-05-18 12:36:36', 1),
(63, 22, 23, 'yahoo', '2014-05-18 12:36:43', 1),
(64, 23, 18, 'erghgfgl;khgj', '2014-05-18 12:36:51', 1),
(65, 23, 18, 'fhkl;'';lhdgkjl;lkjhghjkl', '2014-05-18 12:36:54', 1),
(66, 24, 23, 'hello buddy', '2014-05-18 12:36:56', 1),
(67, 23, 22, 'dghjl;khjgfhkjljkhjg', '2014-05-18 12:37:00', 1),
(68, 23, 22, 'gdfhgjkhgjfxhjkhhgf', '2014-05-18 12:37:01', 1),
(69, 23, 22, 'dghjkljdghfhjklkjgfhgkjl', '2014-05-18 12:37:03', 1),
(70, 22, 23, 'iuwergh uiwgtowiug  lwejfi ehfo', '2014-05-18 12:37:05', 1),
(71, 18, 24, 'sign', '2014-05-18 12:37:06', 1),
(72, 22, 23, 'gierhguer hgiuer', '2014-05-18 12:37:07', 1),
(73, 22, 23, 'gmler jguiw e', '2014-05-18 12:37:08', 1),
(74, 23, 22, 'hdhjlj;khjfzdgfxhjklj;kgjdhfzghjklgdfhkljkhfgj;ljhgfdffhkjlhgfdhlhjdgsfhjkgjhfjkjhjdgfjjhfgdfhkhdghkhhgfkljkghjkljhfdgshkhljkghsgfhhljhfdgfkjkjghsgklgdsggfdgfjhj', '2014-05-18 12:37:10', 1),
(75, 19, 24, 'sign', '2014-05-18 12:37:14', 1),
(76, 22, 23, '1323 1 gerg h 6yh76hh gdfg ggthtrh', '2014-05-18 12:37:17', 1),
(77, 24, 22, ',ethm''slzkh''', '2014-05-18 12:37:18', 1),
(78, 22, 23, 'yhklnmuyklnmyul ', '2014-05-18 12:37:19', 1),
(79, 22, 23, '\nyhlktykmhlhytl;jm,lj y', '2014-05-18 12:37:21', 1),
(80, 22, 23, 'ythyhmytlkhmlkyt', '2014-05-18 12:37:22', 1),
(81, 20, 24, 'sign', '2014-05-18 12:37:23', 1),
(82, 22, 23, 'htrkmhlkrthYTythmklytmhklyth', '2014-05-18 12:37:26', 1),
(83, 22, 23, 'trmhkltrmhlktr', '2014-05-18 12:37:27', 1),
(84, 22, 23, 'rhlrtmhkl;myth/', '2014-05-18 12:37:28', 1),
(85, 22, 23, 'ytytmhlyt;mh;yt', '2014-05-18 12:37:29', 1),
(86, 21, 24, 'sign', '2014-05-18 12:37:30', 1),
(87, 22, 23, 'h,tl;rhml;yeth', '2014-05-18 12:37:30', 1),
(88, 22, 23, 'hlyt;mjl;ur', '2014-05-18 12:37:31', 1),
(89, 22, 24, 'sign', '2014-05-18 12:37:36', 1),
(90, 19, 22, 'Asan', '2014-05-18 12:37:39', 1),
(91, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:40', 1),
(92, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:42', 1),
(93, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:42', 1),
(94, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:43', 1),
(95, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:43', 1),
(96, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:43', 1),
(97, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:43', 1),
(98, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:43', 1),
(99, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:44', 1),
(100, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:44', 1),
(101, 23, 22, '', '2014-05-18 12:37:44', 1),
(102, 23, 24, 'sign', '2014-05-18 12:37:44', 1),
(103, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:44', 1),
(104, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:44', 1),
(105, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:44', 1),
(106, 19, 22, 'Masson ))', '2014-05-18 12:37:45', 1),
(107, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:45', 1),
(108, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:45', 1),
(109, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:45', 1),
(110, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:45', 1),
(111, 23, 22, '', '2014-05-18 12:37:45', 1),
(112, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:45', 1),
(113, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:46', 1),
(114, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:46', 1),
(115, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:46', 1),
(116, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:46', 1),
(117, 23, 22, '', '2014-05-18 12:37:46', 1),
(118, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:46', 1),
(119, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:47', 1),
(120, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:47', 1),
(121, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:47', 1),
(122, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:47', 1),
(123, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:47', 1),
(124, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:48', 1),
(125, 23, 22, '', '2014-05-18 12:37:48', 1),
(126, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:48', 1),
(127, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:48', 1),
(128, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:48', 1),
(129, 23, 22, '', '2014-05-18 12:37:48', 1),
(130, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:49', 1),
(131, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:49', 1),
(132, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:49', 1),
(133, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:49', 1),
(134, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:49', 1),
(135, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:49', 1),
(136, 23, 22, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:37:50', 1),
(137, 23, 24, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu', '2014-05-18 12:38:07', 1),
(138, 18, 23, 'askjdflkasjdfasdfasdfas', '2014-05-18 12:38:13', 1);
INSERT INTO `message` (`id`, `from_user`, `to_user`, `text`, `create_date`, `is_read`) VALUES
(139, 22, 23, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\n', '2014-05-18 12:38:18', 1),
(140, 23, 18, 'dghasdgashdasdas', '2014-05-18 12:38:22', 1),
(141, 23, 18, 'dsadasdasd', '2014-05-18 12:38:22', 1),
(142, 23, 18, 'dsad', '2014-05-18 12:38:23', 1),
(143, 23, 18, 'asd', '2014-05-18 12:38:23', 1),
(144, 23, 18, 'asdas', '2014-05-18 12:38:23', 1),
(145, 23, 18, 'das', '2014-05-18 12:38:23', 1),
(146, 23, 18, 'das', '2014-05-18 12:38:24', 1),
(147, 23, 18, 'das', '2014-05-18 12:38:24', 1),
(148, 23, 18, 'asd', '2014-05-18 12:38:24', 1),
(149, 23, 18, 'as', '2014-05-18 12:38:24', 1),
(150, 23, 18, 'dasd', '2014-05-18 12:38:24', 1),
(151, 23, 18, 'asd', '2014-05-18 12:38:24', 1),
(152, 23, 18, 'asd', '2014-05-18 12:38:25', 1),
(153, 23, 18, 'asd', '2014-05-18 12:38:25', 1),
(154, 23, 18, 'asd', '2014-05-18 12:38:25', 1),
(155, 23, 18, 'sa', '2014-05-18 12:38:25', 1),
(156, 23, 18, 'v', '2014-05-18 12:38:25', 1),
(157, 23, 18, 'as', '2014-05-18 12:38:25', 1),
(158, 23, 18, 'ca', '2014-05-18 12:38:26', 1),
(159, 23, 18, 'a', '2014-05-18 12:38:26', 1),
(160, 23, 18, 'cs', '2014-05-18 12:38:26', 1),
(161, 23, 18, 'c', '2014-05-18 12:38:26', 1),
(162, 23, 18, 'as', '2014-05-18 12:38:26', 1),
(163, 23, 18, 'd', '2014-05-18 12:38:26', 1),
(164, 23, 18, 'as', '2014-05-18 12:38:27', 1),
(165, 23, 18, 'c', '2014-05-18 12:38:27', 1),
(166, 23, 18, 'as', '2014-05-18 12:38:27', 1),
(167, 23, 18, 'ac', '2014-05-18 12:38:27', 1),
(168, 23, 18, 'asc', '2014-05-18 12:38:27', 1),
(169, 23, 18, 's', '2014-05-18 12:38:28', 1),
(170, 23, 18, 'csa', '2014-05-18 12:38:28', 1),
(171, 23, 18, 'cas', '2014-05-18 12:38:28', 1),
(172, 23, 18, 'cas', '2014-05-18 12:38:28', 1),
(173, 23, 18, 'cs', '2014-05-18 12:38:28', 1),
(174, 23, 18, 'cd', '2014-05-18 12:38:29', 1),
(175, 23, 18, '', '2014-05-18 12:38:29', 1),
(176, 23, 18, 'v', '2014-05-18 12:38:29', 1);
INSERT INTO `message` (`id`, `from_user`, `to_user`, `text`, `create_date`, `is_read`) VALUES
(177, 22, 23, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nvhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkd', '2014-05-18 12:38:29', 1);
INSERT INTO `message` (`id`, `from_user`, `to_user`, `text`, `create_date`, `is_read`) VALUES
(178, 23, 18, 'va', '2014-05-18 12:38:29', 1),
(179, 23, 18, 'sas', '2014-05-18 12:38:29', 1),
(180, 23, 18, 'v', '2014-05-18 12:38:30', 1),
(181, 23, 18, 'a', '2014-05-18 12:38:30', 1),
(182, 23, 18, 'cs', '2014-05-18 12:38:30', 1),
(183, 23, 18, 'ac', '2014-05-18 12:38:30', 1),
(184, 23, 18, 'ac', '2014-05-18 12:38:30', 1),
(185, 23, 18, 'as', '2014-05-18 12:38:30', 1),
(186, 23, 18, 'cas', '2014-05-18 12:38:31', 1),
(187, 23, 18, 'c', '2014-05-18 12:38:31', 1),
(188, 23, 18, 'asc', '2014-05-18 12:38:31', 1),
(189, 23, 18, 'asc', '2014-05-18 12:38:31', 1),
(190, 23, 18, 'as', '2014-05-18 12:38:31', 1),
(191, 23, 18, 'cas', '2014-05-18 12:38:32', 1),
(192, 23, 18, 'c', '2014-05-18 12:38:32', 1),
(193, 23, 18, 'f', '2014-05-18 12:38:32', 1),
(194, 23, 18, 'fvfd', '2014-05-18 12:38:32', 1),
(195, 23, 18, 'v', '2014-05-18 12:38:33', 1),
(196, 23, 18, 'fd', '2014-05-18 12:38:33', 1),
(197, 23, 18, 'v', '2014-05-18 12:38:33', 1),
(198, 23, 18, 'fd', '2014-05-18 12:38:33', 1),
(199, 23, 18, 'vdf', '2014-05-18 12:38:33', 1),
(200, 23, 18, 'v', '2014-05-18 12:38:34', 1),
(201, 23, 18, 'fd', '2014-05-18 12:38:34', 1),
(202, 23, 18, 'va', '2014-05-18 12:38:34', 1),
(203, 23, 18, '', '2014-05-18 12:38:34', 1),
(204, 23, 18, 'sca', '2014-05-18 12:38:34', 1),
(205, 23, 18, 'das', '2014-05-18 12:38:35', 1),
(206, 23, 18, 'das', '2014-05-18 12:38:35', 1),
(207, 23, 18, 's', '2014-05-18 12:38:39', 1),
(208, 23, 18, 's', '2014-05-18 12:38:40', 1),
(209, 23, 18, '', '2014-05-18 12:38:40', 1),
(210, 23, 18, 's', '2014-05-18 12:38:41', 1),
(211, 23, 18, 's', '2014-05-18 12:38:41', 1),
(212, 23, 18, '', '2014-05-18 12:38:42', 1),
(213, 23, 18, '', '2014-05-18 12:38:42', 1),
(214, 23, 18, '', '2014-05-18 12:38:42', 1),
(215, 23, 18, '', '2014-05-18 12:38:43', 1),
(216, 23, 18, 's', '2014-05-18 12:38:43', 1),
(217, 23, 18, 's', '2014-05-18 12:38:44', 1),
(218, 23, 18, 's', '2014-05-18 12:38:44', 1),
(219, 23, 18, 's', '2014-05-18 12:38:45', 1),
(220, 23, 18, 's', '2014-05-18 12:38:45', 1),
(221, 23, 18, 's', '2014-05-18 12:38:46', 1),
(222, 23, 18, 's', '2014-05-18 12:38:46', 1),
(223, 22, 24, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\n', '2014-05-18 12:39:09', 1),
(224, 22, 23, 'hdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsuhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\nhdaskjhdkjasjajkasjahdjahjdahdjhajhdjsahkdjsahjdahjdhajdhjashdahdkjahskjdhasjdhkjashdkjahjdahdkjahkjdhaskjhdajshdkjashdjahdhashdjashkjdahkjdhasjhdjashdskjahdkjashdkjashdkjashakjhjaskhaskjhdaskjhdkashjdkashdkjashkjdhasjhdaskjhdkjashdaskjhdaskjhdaskjdhakjhdkjahdkjashdkjashadskjhdaskjhdkjashdkjashifgugdsucugsu\n', '2014-05-18 12:39:36', 1),
(225, 22, 18, 'test', '2014-05-18 12:39:57', 1),
(226, 22, 19, 'yahooo', '2014-05-18 12:40:02', 1),
(227, 22, 24, 'yahoooo', '2014-05-18 12:41:55', 1),
(228, 21, 22, 'kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk', '2014-05-18 12:42:06', 1),
(229, 21, 22, 'kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk', '2014-05-18 12:42:18', 1),
(230, 19, 22, 'kanday', '2014-05-18 12:57:44', 1),
(231, 19, 22, 'you', '2014-05-18 12:58:40', 1),
(232, 19, 22, 'jaz', '2014-05-18 12:58:51', 1),
(233, 22, 19, 'test', '2014-05-18 12:59:00', 1),
(234, 23, 22, 'gsjjadsggasdgjasgdjghjaasjddgasjdkashdkhaksdh adhash akh dkashkd a ksakh hakhdkj ahkhkj haskjh jkh kjahjkh kjhjk hj hjhk hjhjka hkj hjh ajkjk sahkjh jaksh dkjas kjashkj dashkjh askjdhaskjkd aj dhjahkdhaskjh dhsah kdaskhdkj ashkhdkjash d', '2014-05-18 13:02:53', 1),
(235, 23, 22, 'kdashdhsahdkj shakjhkjdas hjkdashkjd ashkjdh as da ah das', '2014-05-18 13:02:57', 1),
(236, 23, 22, 'b djkasdjashdhas dahsdjaskjdkasjk jkdasj kjdkjskajd as;jdksajkdshjah', '2014-05-18 13:03:01', 1),
(237, 23, 22, 'dsafhsahfdshjfkdsajhfjdshaf', '2014-05-18 13:03:03', 1),
(238, 23, 22, 'dfsahfkjsahfkjasjfkdsah', '2014-05-18 13:03:04', 1),
(239, 23, 22, 'dsafhdskjahfskjadfadskjf', '2014-05-18 13:03:05', 1),
(240, 23, 22, 'asdhjdfhaskjfhkj]', '2014-05-18 13:03:06', 1),
(241, 18, 19, 'Heee ))', '2014-05-18 13:08:12', 1),
(242, 18, 19, 'Herere erere', '2014-05-18 13:08:24', 1),
(243, 18, 19, 'reterter', '2014-05-18 13:08:27', 1),
(244, 18, 19, 'ertret', '2014-05-18 13:08:28', 1),
(245, 18, 19, 'ertert', '2014-05-18 13:08:29', 1),
(246, 19, 18, 'Heekki', '2014-05-18 13:18:34', 1),
(247, 19, 18, 'erterterter', '2014-05-18 13:18:38', 1),
(248, 19, 18, 'ertertertert', '2014-05-18 13:18:39', 1),
(249, 19, 18, 'erterte', '2014-05-18 13:18:43', 1),
(250, 19, 18, 'ertreter', '2014-05-18 13:18:46', 1),
(251, 19, 24, 'HUurwer', '2014-05-18 13:19:00', 1),
(252, 19, 24, 'werewrewr', '2014-05-18 13:19:03', 1),
(253, 19, 24, 'rwerew', '2014-05-18 13:19:05', 1),
(254, 19, 24, 'ishtedi', '2014-05-18 13:19:09', 1),
(255, 19, 24, '', '2014-05-18 13:19:09', 1),
(256, 24, 19, 'Chyndap elebi?', '2014-05-18 13:19:33', 1),
(257, 24, 23, 'it is naw working', '2014-05-18 13:20:00', 1),
(258, 23, 24, 'ffkl'';lkhhjl;lfgdfghjl', '2014-05-18 13:20:18', 1),
(259, 24, 18, 'klfdznbk''', '2014-05-18 13:20:53', 1),
(260, 24, 18, 'f,nvkl', '2014-05-18 13:20:55', 1),
(261, 18, 24, 'ttrtrtrtrtrt', '2014-05-18 13:21:17', 1),
(262, 24, 19, 'salam', '2014-05-18 13:21:52', 1),
(263, 18, 19, 'hoor', '2014-05-18 13:28:20', 1),
(264, 18, 19, 'frfrfr', '2014-05-18 13:28:22', 1),
(265, 18, 19, 'frfrf', '2014-05-18 13:28:23', 1),
(266, 18, 19, 'jokrt', '2014-05-18 13:28:52', 1),
(267, 18, 19, 'Mokerter', '2014-05-18 13:28:57', 1),
(268, 18, 19, 'fwefewfwef', '2014-05-18 13:29:07', 1),
(269, 18, 19, 'fwefw', '2014-05-18 13:29:08', 1),
(270, 20, 21, 'salam', '2014-05-18 13:33:51', 0),
(271, 20, 19, 'ulaaan', '2014-05-18 13:33:58', 1),
(272, 20, 18, 'ulaaan', '2014-05-18 13:34:12', 1),
(273, 20, 19, 'mutaliip', '2014-05-18 13:34:21', 1),
(274, 20, 23, 'nurlaan', '2014-05-18 13:34:33', 1),
(275, 18, 20, 'sign', '2014-05-18 13:35:02', 1),
(276, 19, 20, 'sign', '2014-05-18 13:35:10', 1),
(277, 21, 20, 'sign', '2014-05-18 13:35:21', 1),
(278, 22, 20, 'sign', '2014-05-18 13:35:32', 1),
(279, 23, 20, 'sign', '2014-05-18 13:35:40', 1),
(280, 18, 20, 'kanday', '2014-05-18 13:36:07', 1),
(281, 18, 20, 'test', '2014-05-18 13:36:09', 1),
(282, 18, 20, 'asdfas', '2014-05-18 13:36:18', 1),
(283, 18, 20, 'asdfsdfasdfa', '2014-05-18 13:36:19', 1),
(284, 18, 20, 'ne jazdyryp atasyng?', '2014-05-18 13:36:28', 1),
(285, 20, 18, 'emi biz jazdik', '2014-05-18 13:36:29', 1),
(286, 18, 20, 'aa', '2014-05-18 13:36:32', 1),
(287, 20, 19, 'aloo', '2014-05-18 13:36:47', 1),
(288, 20, 19, 'vuguvuyvfyu', '2014-05-18 13:36:53', 1),
(289, 20, 19, 'you', '2014-05-18 13:36:56', 1),
(290, 18, 20, 'sdfg', '2014-05-18 13:37:13', 1),
(291, 18, 20, 'sdfg', '2014-05-18 13:37:14', 1),
(292, 18, 20, 'sdfg', '2014-05-18 13:37:14', 1),
(293, 18, 20, 'sdfg', '2014-05-18 13:37:15', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `page_property`
--

CREATE TABLE IF NOT EXISTS `page_property` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL,
  `page_type_property_id` int(11) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Дамп данных таблицы `page_property`
--

INSERT INTO `page_property` (`id`, `page_id`, `page_type_property_id`, `value`) VALUES
(1, 29, 7, '1'),
(2, 30, 7, '1'),
(3, 31, 7, '1'),
(4, 31, 10, '500'),
(5, 32, 7, '1'),
(6, 32, 10, '500');

-- --------------------------------------------------------

--
-- Структура таблицы `page_type`
--

CREATE TABLE IF NOT EXISTS `page_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `sort` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=22 ;

--
-- Дамп данных таблицы `page_type`
--

INSERT INTO `page_type` (`id`, `title`, `sort`) VALUES
(1, 'Cafe&Restaurant', 1),
(2, 'Transport', 6),
(3, 'Tamada', 3),
(4, 'Cameramen', 4),
(5, 'Photographer', 5),
(6, 'Musicians', 13),
(7, 'Singer', 12),
(8, 'Florist', 8),
(9, 'Sweets', 9),
(10, 'Dancer', 14),
(11, 'Wedding salon', 2),
(12, 'Partying', 19),
(13, 'Wedding cards', 10),
(14, 'Show', 15),
(15, 'Humor', 16),
(16, 'Beverage', 18),
(17, 'Food', 17),
(18, 'Decorations', 7),
(19, 'Tourism agancy', 20),
(20, 'Musical equipment', 21),
(21, 'Jewelry', 11);

-- --------------------------------------------------------

--
-- Структура таблицы `page_type_property`
--

CREATE TABLE IF NOT EXISTS `page_type_property` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_type_id` int(11) NOT NULL,
  `data_type_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `default_value` text,
  `required` tinyint(1) NOT NULL DEFAULT '1',
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=52 ;

--
-- Дамп данных таблицы `page_type_property`
--

INSERT INTO `page_type_property` (`id`, `page_type_id`, `data_type_id`, `title`, `default_value`, `required`, `visible`) VALUES
(7, 3, 5, 'gender', '{0: ''Male'', 1: ''Female''}', 1, 1),
(10, 3, 1, 'price', '', 1, 1),
(11, 1, 1, 'price', NULL, 1, 1),
(12, 1, 1, 'place_count', NULL, 1, 1),
(13, 1, 1, 'rooms', NULL, 1, 1),
(14, 11, 1, 'price', NULL, 1, 1),
(15, 4, 1, 'price', NULL, 1, 1),
(16, 5, 1, 'price', NULL, 1, 1),
(17, 2, 7, 'manufacturer', '{0: ''mers'', 1:''bmw'', 2:''hummer''}', 1, 1),
(18, 2, 7, 'model', '{0: ''mers s5'', 1:''bmw x5'', 2:''hummer h5''}', 1, 1),
(19, 2, 1, 'price', '', 1, 1),
(20, 18, 1, 'price', '', 1, 1),
(21, 8, 1, 'price', '', 1, 1),
(22, 9, 1, 'price', '', 1, 1),
(23, 13, 1, 'price', '', 1, 1),
(24, 21, 1, 'price', '', 1, 1),
(25, 21, 7, 'type', '{0:''gold'', 1:''silver''}', 1, 1),
(26, 7, 1, 'price', '', 1, 1),
(27, 7, 5, 'gender', '', 1, 1),
(28, 7, 10, 'genre', '{0:''pop'', 1:''rock'', 2:''national''}', 1, 1),
(29, 6, 1, 'price', '', 1, 1),
(30, 6, 10, 'instrument', '', 1, 1),
(31, 6, 10, 'genre', '{0:''national'', 1:''pop''}', 1, 1),
(32, 10, 1, 'price', '', 1, 1),
(33, 10, 12, 'gender', '{''single'': [male, female], \r\n''band'': [male, female, mixed]\r\n}', 1, 1),
(34, 10, 10, 'type', '{0: ''tango'', 1: ''national'', 2: ''latino'', 3: ''modern''}', 1, 1),
(35, 14, 12, 'gender', '{''single'': [male, female], \r\n''band'': [male, female, mixed]\r\n}', 1, 1),
(36, 14, 1, 'price', '', 1, 1),
(37, 14, 10, 'type', '{0: ''lazer'', 1: ''water'', 2: ''sand''}', 1, 1),
(38, 15, 1, 'price', '', 1, 1),
(39, 15, 12, 'gender', '{''single'': [male, female], \r\n''band'': [male, female, mixed]\r\n}', 1, 1),
(40, 17, 1, 'price', '', 1, 1),
(42, 17, 10, 'type', '{0: ''boorsok'', 1: ''plov''}', 1, 1),
(44, 16, 1, 'price', '', 1, 1),
(45, 16, 10, 'type', '{0: ''national'', 1: ''mineral'', 2: ''natural''}', 1, 1),
(46, 12, 1, 'price', '', 1, 1),
(47, 12, 10, 'type', '{0: ''open'', 1: ''closed'', 2: ''mixed''}', 1, 1),
(48, 19, 1, 'price', '', 1, 1),
(49, 19, 10, 'type', '{0: ''germany'', 1: ''france'', 2: ''us''}', 1, 1),
(50, 20, 1, 'price', '', 1, 1),
(51, 20, 10, 'type', '{0: ''microfon'', 1: ''mixer'', 2: ''kolonka''}', 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `photo`
--

CREATE TABLE IF NOT EXISTS `photo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `album_id` int(11) NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` text NOT NULL,
  `applause_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=42 ;

--
-- Дамп данных таблицы `photo`
--

INSERT INTO `photo` (`id`, `owner_id`, `title`, `album_id`, `datetime`, `description`, `applause_count`) VALUES
(35, 28, 'share_photo_35.png', 4, '2014-06-05 10:23:56', 'test', 0),
(36, 28, 'share_photo_36.png', 4, '2014-06-06 05:19:01', 'asdfasdf', 1),
(37, 28, 'share_photo_37.png', 4, '2014-06-07 11:08:30', 'sdfasdf', 0),
(38, 28, 'share_photo_38.png', 4, '2014-06-07 11:10:04', 'asdfsdf', 0),
(39, 28, 'share_photo_39.png', 4, '2014-06-07 11:10:56', 'asdf', 0),
(40, 28, 'share_photo_40.png', 4, '2014-06-07 11:13:08', 'asdf', 0),
(41, 28, 'share_photo_41.png', 4, '2014-06-07 11:14:38', 'asdf', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `post`
--

CREATE TABLE IF NOT EXISTS `post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `applause_count` int(11) NOT NULL DEFAULT '0',
  `public` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `post`
--

INSERT INTO `post` (`id`, `owner_id`, `description`, `datetime`, `applause_count`, `public`) VALUES
(1, 30, 'jhgkjhgkjhgkjhg', '2014-06-11 12:35:42', 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `region`
--

CREATE TABLE IF NOT EXISTS `region` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Дамп данных таблицы `region`
--

INSERT INTO `region` (`id`, `parent_id`, `title`, `type`) VALUES
(1, NULL, 'Кыргызстан', 0),
(2, 1, 'Ысык-Кол', 1),
(3, 2, 'Туп', 3),
(4, 2, 'Жети-Огуз', 3),
(5, 1, 'Ош', 1),
(6, 5, 'Кара-Суу', 3),
(7, 5, 'Ноокат', 3);

-- --------------------------------------------------------

--
-- Структура таблицы `region_type`
--

CREATE TABLE IF NOT EXISTS `region_type` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `region_type`
--

INSERT INTO `region_type` (`id`, `name`) VALUES
(0, 'страна'),
(1, 'область'),
(2, 'город'),
(3, 'район');

-- --------------------------------------------------------

--
-- Структура таблицы `timeline`
--

CREATE TABLE IF NOT EXISTS `timeline` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `friend_id` int(11) DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `action_type` int(11) NOT NULL,
  `action_id` int(11) DEFAULT NULL,
  `object_type` int(11) NOT NULL,
  `object_id` int(11) NOT NULL,
  `friend_name` varchar(255) DEFAULT NULL,
  `friend_avatar` varchar(255) DEFAULT NULL,
  `owner_name` varchar(255) NOT NULL,
  `owner_avatar` varchar(255) DEFAULT NULL,
  `object_title` varchar(255) DEFAULT NULL,
  `object_description` text,
  `object_datetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `object_file_url` varchar(255) DEFAULT NULL,
  `public` tinyint(4) NOT NULL DEFAULT '0',
  `is_ready_to_show` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=59 ;

--
-- Дамп данных таблицы `timeline`
--

INSERT INTO `timeline` (`id`, `friend_id`, `owner_id`, `datetime`, `action_type`, `action_id`, `object_type`, `object_id`, `friend_name`, `friend_avatar`, `owner_name`, `owner_avatar`, `object_title`, `object_description`, `object_datetime`, `object_file_url`, `public`, `is_ready_to_show`) VALUES
(31, NULL, 28, '2014-06-05 10:23:56', 2, NULL, 5, 35, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'test', '2014-06-05 10:23:56', 'share_photo_35.png', 0, 1),
(34, 28, 28, '2014-06-05 10:57:50', 4, 33, 5, 35, 'Ulan Djamanbalaev', NULL, 'Ulan Djamanbalaev', NULL, NULL, NULL, '2014-06-05 10:57:50', NULL, 0, 1),
(35, NULL, 28, '2014-06-06 05:19:01', 2, NULL, 5, 36, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdfasdf', '2014-06-06 05:19:01', 'share_photo_36.png', 0, 1),
(37, 28, 28, '2014-06-06 05:28:53', 5, 7, 5, 36, 'Ulan Djamanbalaev', NULL, 'Ulan Djamanbalaev', NULL, NULL, NULL, '2014-06-06 05:28:53', NULL, 0, 1),
(38, NULL, 28, '2014-06-07 11:08:30', 2, NULL, 5, 37, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'sdfasdf', '2014-06-07 11:08:30', 'share_photo_37.png', 0, 1),
(39, NULL, 28, '2014-06-07 11:10:04', 2, NULL, 5, 38, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdfsdf', '2014-06-07 11:10:04', 'share_photo_38.png', 0, 1),
(40, NULL, 28, '2014-06-07 11:10:56', 2, NULL, 5, 39, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-07 11:10:56', 'share_photo_39.png', 0, 1),
(41, NULL, 28, '2014-06-07 11:13:08', 2, NULL, 5, 40, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-07 11:13:08', 'share_photo_40.png', 0, 1),
(42, NULL, 28, '2014-06-07 11:14:38', 2, NULL, 5, 41, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-07 11:14:38', 'share_photo_41.png', 0, 1),
(43, NULL, 28, '2014-06-09 01:42:53', 3, NULL, 4, 28, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'xcv', '2014-06-09 01:42:53', 'share_video_1402278173.6.mp4', 0, 0),
(44, NULL, 28, '2014-06-09 01:51:08', 3, NULL, 4, 29, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'sadf', '2014-06-09 01:51:08', 'share_video_1402278668.56.mp4', 0, 0),
(45, NULL, 28, '2014-06-09 01:51:40', 3, NULL, 4, 30, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-09 01:51:40', 'share_video_1402278700.26.mp4', 0, 0),
(46, NULL, 28, '2014-06-09 01:53:42', 3, NULL, 4, 31, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-09 01:53:42', 'share_video_1402278822.42.mp4', 0, 0),
(47, NULL, 28, '2014-06-09 01:54:51', 3, NULL, 4, 32, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-09 01:54:51', 'share_video_1402278854.32.mp4', 0, 0),
(48, NULL, 28, '2014-06-09 01:55:46', 3, NULL, 4, 33, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-09 01:55:46', 'share_video_1402278934.32.mp4', 0, 0),
(49, NULL, 28, '2014-06-09 02:01:53', 3, NULL, 4, 34, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-09 02:01:53', 'share_video_1402279301.51.mp4', 0, 0),
(50, NULL, 28, '2014-06-09 02:25:14', 3, NULL, 4, 35, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'wertw', '2014-06-09 02:25:14', 'share_video_1402280699.26.mp4', 0, 0),
(51, NULL, 28, '2014-06-09 02:35:10', 3, NULL, 4, 36, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-09 02:35:10', 'share_video_1402281310.59.mp4', 0, 0),
(52, NULL, 28, '2014-06-09 02:36:16', 3, NULL, 4, 37, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-09 02:36:16', 'share_video_1402281376.5.mp4', 0, 0),
(53, NULL, 28, '2014-06-09 02:37:08', 3, NULL, 4, 38, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdf', '2014-06-09 02:37:08', 'share_video_1402281428.16.mp4', 0, 0),
(54, NULL, 28, '2014-06-09 03:56:08', 3, NULL, 4, 39, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'dfdgdf', '2014-06-09 03:56:08', 'share_video_1401853989.61', 0, 1),
(56, NULL, 30, '2014-06-11 12:35:42', 1, NULL, 3, 1, NULL, NULL, 'new page tamada', NULL, NULL, 'jhgkjhgkjhgkjhg', '2014-06-11 12:35:42', NULL, 0, 1),
(57, 30, 30, '2014-06-11 12:37:26', 5, 8, 3, 1, 'new page tamada', NULL, 'new page tamada ', NULL, NULL, NULL, '2014-06-11 12:37:26', NULL, 0, 1),
(58, NULL, 28, '2014-06-13 12:50:59', 6, NULL, 7, 1, NULL, NULL, 'Ulan Djamanbalaev', NULL, NULL, 'asdfasdfasdf', '2014-06-13 12:50:59', NULL, 0, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `video`
--

CREATE TABLE IF NOT EXISTS `video` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT NULL,
  `description` text,
  `datetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `applause_count` int(11) DEFAULT '0',
  `maareke_id` int(11) DEFAULT NULL,
  `original_file` varchar(255) DEFAULT NULL,
  `converted_file` varchar(255) NOT NULL,
  `is_converted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=40 ;

--
-- Дамп данных таблицы `video`
--

INSERT INTO `video` (`id`, `owner_id`, `description`, `datetime`, `applause_count`, `maareke_id`, `original_file`, `converted_file`, `is_converted`) VALUES
(28, 28, 'xcv', '2014-06-09 01:42:53', 0, NULL, 'media/share_video_1402278173.6.flv', 'share_video_1402278173.6.mp4', 0),
(29, 28, 'sadf', '2014-06-09 01:51:08', 0, NULL, 'media/share_video_1402278668.56.flv', 'share_video_1402278668.56.mp4', 0),
(30, 28, 'asdf', '2014-06-09 01:51:40', 0, NULL, 'media/share_video_1402278700.26.flv', 'share_video_1402278700.26.mp4', 0),
(31, 28, 'asdf', '2014-06-09 01:53:42', 0, NULL, 'media/share_video_1402278822.42.flv', 'share_video_1402278822.42.mp4', 0),
(32, 28, 'asdf', '2014-06-09 01:54:14', 0, NULL, 'media/share_video_1402278854.32.flv', 'share_video_1402278854.32.mp4', 0),
(33, 28, 'asdf', '2014-06-09 01:55:34', 0, NULL, 'media/share_video_1402278934.32.flv', 'share_video_1402278934.32.mp4', 0),
(34, 28, 'asdf', '2014-06-09 02:01:41', 0, NULL, 'media/share_video_1402279301.51.flv', 'share_video_1402279301.51.mp4', 0),
(35, 28, 'wertw', '2014-06-09 02:24:59', 0, NULL, 'media/share_video_1402280699.26.flv', 'share_video_1402280699.26.mp4', 0),
(36, 28, 'asdf', '2014-06-09 02:35:10', 0, NULL, 'media/share_video_1402281310.59.flv', 'share_video_1402281310.59.mp4', 0),
(37, 28, 'asdf', '2014-06-09 02:36:16', 0, NULL, 'media/share_video_1402281376.5.flv', 'share_video_1402281376.5.mp4', 0),
(38, 28, 'asdf', '2014-06-09 02:37:08', 0, NULL, 'media/share_video_1402281428.16.flv', 'share_video_1402281428.16.mp4', 0),
(39, 28, 'dfdgdf', '2014-06-09 03:55:58', 0, NULL, 'media/share_video_1402286158.71.flv', 'share_video_1402286158.71.mp4', 0);

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `group_id_refs_id_f4b32aac` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `permission_id_refs_id_6ba0f519` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Ограничения внешнего ключа таблицы `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `content_type_id_refs_id_d043b34a` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Ограничения внешнего ключа таблицы `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `group_id_refs_id_274b862c` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `user_id_refs_id_40c41112` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Ограничения внешнего ключа таблицы `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `permission_id_refs_id_35d9ac25` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `user_id_refs_id_4dc23c39` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Ограничения внешнего ключа таблицы `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `content_type_id_refs_id_93d2d1f8` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `user_id_refs_id_c0d12874` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
