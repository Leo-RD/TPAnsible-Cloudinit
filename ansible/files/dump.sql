-- MySQL dump 9.11
--
-- Host: localhost    Database: pdns
-- ------------------------------------------------------
-- Server version	4.0.23_Debian-7-log

--
-- Table structure for table `domains`
--

CREATE TABLE `domains` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `master` varchar(20) default NULL,
  `last_check` int(11) default NULL,
  `type` varchar(6) NOT NULL default '',
  `notified_serial` int(11) default NULL,
  `account` varchar(40) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name_index` (`name`)
) TYPE=InnoDB;

--
-- Dumping data for table `domains`
--

INSERT INTO `domains` VALUES (1,'test.com',NULL,NULL,'NATIVE',NULL,NULL);
INSERT INTO `domains` VALUES (2,'ouvameuh.net',NULL,NULL,'NATIVE',NULL,NULL);

--
-- Table structure for table `records`
--

CREATE TABLE `records` (
  `id` int(11) NOT NULL auto_increment,
  `domain_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `type` varchar(6) default NULL,
  `content` varchar(255) default NULL,
  `ttl` int(11) default NULL,
  `prio` int(11) default NULL,
  `change_date` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `rec_name_index` (`name`),
  KEY `nametype_index` (`name`,`type`),
  KEY `domain_id` (`domain_id`)
) TYPE=InnoDB;

--
-- Dumping data for table `records`
--

INSERT INTO `records` VALUES (1,1,'test.com','SOA','localhost ahu@ds9a.nl 1',86400,NULL,NULL);
INSERT INTO `records` VALUES (2,1,'test.com','NS','dns-us1.powerdns.net',86400,NULL,NULL);
INSERT INTO `records` VALUES (3,1,'test.com','NS','dns-eu1.powerdns.net',86400,NULL,NULL);
INSERT INTO `records` VALUES (4,1,'www.test.com','A','199.198.197.196',120,NULL,NULL);
INSERT INTO `records` VALUES (5,1,'mail.test.com','A','195.194.193.192',120,NULL,NULL);
INSERT INTO `records` VALUES (6,1,'localhost.test.com','A','127.0.0.1',120,NULL,NULL);
INSERT INTO `records` VALUES (7,1,'test.com','MX','mail.test.com',120,25,NULL);
INSERT INTO `records` VALUES (8,1,'test.com','MX','mx1.tuxfamily.net',120,24,NULL);
INSERT INTO `records` VALUES (9,1,'cname.test.com','CNAME','eloise.ouvaton.net',120,NULL,NULL);
INSERT INTO `records` VALUES (10,2,'ouvameuh.net','SOA','localhost meuh@ouvaton.net 2005030901',3600,NULL,NULL);
INSERT INTO `records` VALUES (11,2,'ouvameuh.net','NS','localhost',3600,NULL,NULL);
INSERT INTO `records` VALUES (12,2,'localhost.ouvameuh.net','A','127.0.0.1',3600,NULL,NULL);
INSERT INTO `records` VALUES (13,2,'cname.ouvameuh.net','CNAME','eloise.ouvaton.net',3600,NULL,NULL);

--
-- Table structure for table `supermasters`
--

CREATE TABLE `supermasters` (
  `ip` varchar(25) NOT NULL default '',
  `nameserver` varchar(255) NOT NULL default '',
  `account` varchar(40) default NULL
) TYPE=MyISAM;

--
-- Dumping data for table `supermasters`
--


