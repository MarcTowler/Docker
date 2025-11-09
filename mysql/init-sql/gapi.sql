-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 29, 2025 at 11:07 PM
-- Server version: 10.5.29-MariaDB-cll-lve
-- PHP Version: 8.3.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `marctowl_gapi`
--
CREATE DATABASE IF NOT EXISTS `marctowl_gapi` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `marctowl_gapi`;

-- --------------------------------------------------------

--
-- Table structure for table `armour`
--
DROP TABLE IF EXISTS `armour`;
CREATE TABLE IF NOT EXISTS `armour` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `iid` int(11) DEFAULT NULL,
  `hp_mod` int(11) NOT NULL DEFAULT 0,
  `ap_mod` int(11) NOT NULL DEFAULT 0,
  `str_mod` int(11) NOT NULL DEFAULT 0,
  `def_mod` int(11) NOT NULL DEFAULT 0,
  `dex_mod` int(11) NOT NULL DEFAULT 0,
  `spd_mod` int(11) NOT NULL DEFAULT 0,
  `fit_position` enum('Head','Chest','Arms','Legs','Feet') NOT NULL,
  `defense_msg` varchar(255) NOT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `iid` (`iid`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `armour`
--

INSERT INTO `armour` (`aid`, `iid`, `hp_mod`, `ap_mod`, `str_mod`, `def_mod`, `dex_mod`, `spd_mod`, `fit_position`, `defense_msg`) VALUES
(1, 3, 0, 0, 1, 0, 0, 0, 'Head', ''),
(2, 4, 0, 0, 0, 0, 0, 0, 'Chest', ''),
(3, 5, 0, 0, 0, 0, 0, 0, 'Legs', ''),
(4, 6, 0, 0, 0, 0, 0, 0, 'Feet', ''),
(5, 8, 0, 0, -1, 5, 0, -1, 'Chest', 'the scaly protection on their chest'),
(6, 20, 0, 0, 0, 1, 0, -1, 'Chest', 'being slowed down from wondering where the scream came from'),
(7, 21, 0, 0, 0, 2, -1, -1, 'Head', 'the thickness of the metal'),
(8, 25, 0, 0, 0, 1, 0, 0, 'Feet', ''),
(9, 26, 0, 0, 0, 1, 0, 0, 'Legs', ''),
(10, 27, 0, 0, 0, 1, 0, 0, 'Chest', ''),
(11, 28, 0, 0, 0, 1, 0, 0, 'Head', ''),
(12, 30, 2, 1, -2, 3, 2, 2, 'Head', ''),
(13, 31, 2, 1, -1, 1, 2, 2, 'Chest', ''),
(14, 32, 1, 1, 0, 1, 1, 1, 'Legs', ''),
(15, 33, -2, -1, 1, 2, 1, 1, 'Feet', '');

-- --------------------------------------------------------

--
-- Table structure for table `auction`
--
DROP TABLE IF EXISTS `auction`;
CREATE TABLE IF NOT EXISTS `auction` (
  `aid` int(3) NOT NULL,
  `iid` int(3) NOT NULL,
  `uid` int(3) NOT NULL,
  `min_bid` int(10) DEFAULT 0,
  `start_time` datetime DEFAULT current_timestamp(),
  `end_time` datetime NOT NULL,
  `active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auction_bids`
--
DROP TABLE IF EXISTS `auction_bids`;
CREATE TABLE IF NOT EXISTS `auction_bids` (
  `bid` int(10) NOT NULL,
  `aid` int(3) NOT NULL,
  `uid` int(3) NOT NULL,
  `amount` int(10) NOT NULL,
  `top` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_token`
--
DROP TABLE IF EXISTS `auth_token`;
CREATE TABLE IF NOT EXISTS `auth_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `token` varchar(255) NOT NULL,
  `level` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `auth_token`
--

INSERT INTO `auth_token` (`id`, `name`, `token`, `level`) VALUES
(1, 'discord_bot', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiZGlzY29yZF9ib3QiLCJsZXZlbCI6NH0.QzeOwIJPvCh6DHJ5MFyTaz9H1TOOawB-mcblfFqKuIs', 4);

-- --------------------------------------------------------

--
-- Table structure for table `bank`
--
DROP TABLE IF EXISTS `bank`;
CREATE TABLE IF NOT EXISTS `bank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `balance` int(11) DEFAULT NULL,
  `protected` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `bank`
--

INSERT INTO `bank` (`id`, `uid`, `balance`, `protected`) VALUES
(1, 1, 3145, 0),
(2, 858, 1037, 0),
(3, 34, 1910, 0),
(4, 39, 304, 0),
(5, 35, 725, 0);

-- --------------------------------------------------------

--
-- Table structure for table `class`
--
DROP TABLE IF EXISTS `class`;
CREATE TABLE IF NOT EXISTS `class` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `level_req` int(11) DEFAULT NULL,
  `class_req` int(11) NOT NULL DEFAULT 1,
  `str_mod` int(11) NOT NULL DEFAULT 0,
  `def_mod` int(11) NOT NULL DEFAULT 0,
  `dex_mod` int(11) NOT NULL DEFAULT 0,
  `spd_mod` int(11) NOT NULL DEFAULT 0,
  `hp_mod` int(11) NOT NULL DEFAULT 0,
  `ap_mod` int(11) NOT NULL DEFAULT 0,
  `active` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=68 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `class`
--

INSERT INTO `class` (`id`, `name`, `level_req`, `class_req`, `str_mod`, `def_mod`, `dex_mod`, `spd_mod`, `hp_mod`, `ap_mod`, `active`) VALUES
(1, 'No Class', 1, 1, 0, 0, 0, 0, 0, 0, 1),
(2, 'Squire', 5, 1, 0, 0, 0, 0, 0, 0, 0),
(3, 'Apprentice', 5, 1, 0, 0, 0, 0, 0, 0, 0),
(4, 'Savant', 5, 1, 0, 0, 0, 0, 0, 0, 0),
(5, 'Messenger', 5, 1, 0, 0, 0, 0, 0, 0, 0),
(6, 'Pikeman', 15, 1, 0, 0, 0, 0, 0, 0, 0),
(7, 'Swordsman', 15, 1, 0, 0, 0, 0, 0, 0, 0),
(8, 'Militia', 15, 1, 0, 0, 0, 0, 0, 0, 0),
(9, 'Scout', 15, 1, 0, 0, 0, 0, 0, 0, 0),
(10, 'acolyte', 15, 1, 0, 0, 0, 0, 0, 0, 0),
(11, 'scribe', 15, 1, 0, 0, 0, 0, 0, 0, 0),
(12, 'Halberdier', 25, 1, 0, 0, 0, 0, 0, 0, 0),
(13, 'Soldier', 25, 1, 0, 0, 0, 0, 0, 0, 0),
(14, 'Fencer', 25, 1, 0, 0, 0, 0, 0, 0, 0),
(15, 'Gallant', 25, 1, 0, 0, 0, 0, 0, 0, 0),
(16, 'Guardian', 25, 1, 0, 0, 0, 0, 0, 0, 0),
(17, 'Archer', 25, 1, 0, 0, 0, 0, 0, 0, 0),
(18, 'Friar', 25, 1, 0, 0, 0, 0, 0, 0, 0),
(19, 'Disciple', 25, 1, 0, 0, 0, 0, 0, 0, 0),
(20, 'Apothecary', 25, 1, 0, 0, 0, 0, 0, 0, 0),
(21, 'Sorcerer', 25, 1, 0, 0, 0, 0, 0, 0, 0),
(22, 'Cavalier', 35, 1, 0, 0, 0, 0, 0, 0, 0),
(23, 'Hoplite', 35, 1, 0, 0, 0, 0, 0, 0, 0),
(24, 'Paladin', 35, 1, 0, 0, 0, 0, 0, 0, 0),
(25, 'Samurai', 35, 1, 0, 0, 0, 0, 0, 0, 0),
(26, 'Lancer', 35, 1, 0, 0, 0, 0, 0, 0, 0),
(27, 'Marksman', 35, 1, 0, 0, 0, 0, 0, 0, 0),
(28, 'Monk', 35, 1, 0, 0, 0, 0, 0, 0, 0),
(29, 'Seer', 35, 1, 0, 0, 0, 0, 0, 0, 0),
(30, 'Chemist', 35, 1, 0, 0, 0, 0, 0, 0, 0),
(31, 'Mage', 35, 1, 0, 0, 0, 0, 0, 0, 0),
(32, 'Champion', 45, 1, 0, 0, 0, 0, 0, 0, 0),
(33, 'Phalanx', 45, 1, 0, 0, 0, 0, 0, 0, 0),
(34, 'Holy Knight', 45, 1, 0, 0, 0, 0, 0, 0, 0),
(35, 'Sensei', 45, 1, 0, 0, 0, 0, 0, 0, 0),
(36, 'Sentinel', 45, 1, 0, 0, 0, 0, 0, 0, 0),
(37, 'Ranger', 45, 1, 0, 0, 0, 0, 0, 0, 0),
(38, 'Mystic', 45, 1, 0, 0, 0, 0, 0, 0, 0),
(39, 'Sage', 45, 1, 0, 0, 0, 0, 0, 0, 0),
(40, 'Alchemist', 45, 1, 0, 0, 0, 0, 0, 0, 0),
(41, 'Magus', 45, 1, 0, 0, 0, 0, 0, 0, 0),
(42, 'Crusader', 55, 1, 0, 0, 0, 0, 0, 0, 0),
(43, 'Praetorian', 55, 1, 0, 0, 0, 0, 0, 0, 0),
(44, 'Temple Knight', 55, 1, 0, 0, 0, 0, 0, 0, 0),
(45, 'Transcendent', 55, 1, 0, 0, 0, 0, 0, 0, 0),
(46, 'Dragoon', 55, 1, 0, 0, 0, 0, 0, 0, 0),
(47, 'Valewalker', 55, 1, 0, 0, 0, 0, 0, 0, 0),
(48, 'Priest', 55, 1, 0, 0, 0, 0, 0, 0, 0),
(49, 'Time Mage', 55, 1, 0, 0, 0, 0, 0, 0, 0),
(50, 'Transmuter', 55, 1, 0, 0, 0, 0, 0, 0, 0),
(51, 'Elementalist', 55, 1, 0, 0, 0, 0, 0, 0, 0),
(52, 'Angel', 65, 1, 0, 0, 0, 0, 0, 0, 0),
(53, 'Praefectus', 65, 1, 0, 0, 0, 0, 0, 0, 0),
(54, 'Templar', 65, 1, 0, 0, 0, 0, 0, 0, 0),
(55, 'Hyrmidon', 65, 1, 0, 0, 0, 0, 0, 0, 0),
(56, 'Kaiser', 65, 1, 0, 0, 0, 0, 0, 0, 0),
(57, 'Vinewalker', 65, 1, 0, 0, 0, 0, 0, 0, 0),
(58, 'Preserver', 65, 1, 0, 0, 0, 0, 0, 0, 0),
(59, 'Vicar', 65, 1, 0, 0, 0, 0, 0, 0, 0),
(60, 'Archmage', 65, 1, 0, 0, 0, 0, 0, 0, 0),
(61, 'Wizard', 65, 1, 0, 0, 0, 0, 0, 0, 0),
(62, 'Celestial', 80, 1, 0, 0, 0, 0, 0, 0, 0),
(63, 'Archangel', 80, 1, 0, 0, 0, 0, 0, 0, 0),
(64, 'Lightblade', 80, 1, 0, 0, 0, 0, 0, 0, 0),
(65, 'Diviner', 80, 1, 0, 0, 0, 0, 0, 0, 0),
(66, 'Devout', 80, 1, 0, 0, 0, 0, 0, 0, 0),
(67, 'Archmagus', 80, 1, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `event`
--
DROP TABLE IF EXISTS `event`;
CREATE TABLE IF NOT EXISTS `event` (
  `eid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(180) NOT NULL,
  `description` text NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `min_level` int(11) NOT NULL,
  `max_level` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `active` int(11) NOT NULL,
  PRIMARY KEY (`eid`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `event`
--

INSERT INTO `event` (`eid`, `name`, `description`, `start_date`, `end_date`, `min_level`, `max_level`, `created_by`, `active`) VALUES
(1, 'The Valetime', 'A celebration of remembrance of when the planet would be ravaged by ethereal creatures from a alternative gravitational plane (that is only accessible only once per year when the planets of the system align to create a gravitational soft spot between worlds) the creatures, becoming known as “Vale tredders” sought other sentient life to feed of their active neurons. The only way to defeated vale tredder is to remove its heart. Each tredder can only feed of a limited number of people specific to each tredder. It became tradition during the the vale time to kill the tredder destined for the person you fancied, and then present the person you liked with the heart of the tredder that was coming for them. That person then knew they would be safe for this season.', '2020-02-12 12:00:00', '2020-02-19 19:00:00', 0, 100, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `items`
--
DROP TABLE IF EXISTS `items`;
CREATE TABLE IF NOT EXISTS `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` enum('Healing','Key Item','Weapon','Armour','Other','Ingrediant') DEFAULT NULL,
  `material` enum('Pot','Cloth','Leather','Scale','Wood','Glass','Iron','Steel','Chainmail','Fur','Bronze','Raw Mining','Other') NOT NULL,
  `description` text NOT NULL,
  `lore` text NOT NULL,
  `level_req` int(11) NOT NULL,
  `modifier` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `available` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `name`, `type`, `material`, `description`, `lore`, `level_req`, `modifier`, `price`, `qty`, `available`) VALUES
(1, 'Potion', 'Healing', 'Pot', 'A small healing vial for +20 health', '', 0, '{\"cur_hp\": \"+20\"}', 30, 0, 1),
(2, 'Hi-Potion', 'Healing', 'Pot', 'A medium sized healing pot for +100 health', '', 0, '{\"cur_hp\": \"+100\"}', 150, 85, 1),
(3, 'Cloth Hat', 'Armour', 'Cloth', 'A thin cloth hat to cover your head', '', 0, NULL, 16, 85, 1),
(4, 'Cloth Tunic', 'Armour', 'Cloth', 'A sack like cloth with holes cut into it to be fashioned as torso clothing', '', 0, NULL, 16, 85, 1),
(5, 'Torn trousers', 'Armour', 'Cloth', 'Shaggy looking trousers with weird stains on it', '', 0, NULL, 16, 85, 1),
(6, 'Cloth Shoes', 'Armour', 'Cloth', 'A pair of badly worn cloth shoes that look like they are being held together with dirt', '', 0, NULL, 16, 85, 1),
(7, 'Yurko\'s Broadsword', 'Weapon', 'Iron', 'An exceptionally large sword.... like really large', 'A man of great stature once wielded this blade and vanquished great horrors with it.The weapon is named after that man\'s best friend, of whom was corrupted by a walking whale merchant after he completed a few quest for him. Nobody knows what happened to the large man after his many adventures.... I mean he\'s so big you\'d think it would be easy enough to find him!', 15, NULL, 800, 100, 0),
(8, 'Nemberg scalemail', 'Armour', 'Scale', 'The scales of a nemberg make for great protection from all sorts of weapons.', 'The scales of a nemberg make for great protection from all sorts of weapons. Now if only we could find a way to cook their flesh', 4, NULL, 300, 100, 1),
(9, 'Tree Limb', 'Weapon', 'Wood', 'I guess it is meant to be a sword...', '\"Hey give that back!\" - The 3 limbed Tree', 5, NULL, 100, 10, 1),
(10, 'Uncut Diamond', 'Other', 'Raw Mining', '', '', 0, NULL, 600, 0, 1),
(11, 'Wooden Sword', 'Weapon', 'Wood', 'A batterd piece of wood, crudely shaped into a sword', '', 0, NULL, 6, 0, 1),
(12, 'Herb', 'Ingrediant', 'Other', 'An ingrediant to make basic health potions', '', 0, NULL, 10, 0, 1),
(13, 'Quality Herb', 'Ingrediant', 'Other', 'A better quality ingrediant to make potions', '', 0, NULL, 20, 15, 0),
(14, 'Supreme Herb', 'Ingrediant', 'Other', 'A better quality ingrediant to make potions', '', 0, NULL, 100, 15, 0),
(15, 'Finest Herb', 'Ingrediant', 'Other', 'Best quality herbs for making potions', '', 0, NULL, 500, 15, 0),
(16, 'Short Sword', 'Weapon', 'Iron', 'A short sword that is idea for using indoors, lacks range to keep your enemies away', '', 0, NULL, 200, 0, 1),
(17, 'Rapier', 'Weapon', 'Steel', 'A light and thin blade used for technical swordmanship', '', 0, NULL, 300, 0, 1),
(18, 'Frankenstein\'s bolts', 'Weapon', 'Other', 'Apparently the neck bolts from Frankenstein\'s monster fashioned into a dagger', '', 1, NULL, 200, 0, 1),
(19, 'Blessed Crossbow', 'Weapon', 'Wood', 'A crossbow rumoured to be blessed by Van Helsing himself', '', 1, NULL, 200, 0, 1),
(20, 'Terror Tunic', 'Armour', 'Cloth', 'A jacket that sounds like it screams when it is near a non-human', '', 1, NULL, 150, 0, 1),
(21, 'Helm of the Goblin Helmet', 'Armour', 'Steel', 'The helmet rumoured to belong to a famous Goblin Hunter', '', 1, NULL, 150, 0, 1),
(22, 'Long Sword', 'Weapon', 'Iron', 'A long sword usually carried by knights of the realm', '', 4, NULL, 500, 0, 1),
(23, 'Dagger', 'Weapon', 'Iron', 'A short dagger that is easy to conceal', '', 4, NULL, 250, 0, 1),
(24, 'Axe', 'Weapon', 'Steel', 'Battleaxes are one of the more powerful weapons but it comes with its drawbacks', '', 4, NULL, 200, 0, 1),
(25, 'Leather boots', 'Armour', 'Leather', 'Simple pieces of leather fashoned into shoes', '', 3, NULL, 100, 15, 1),
(26, 'Leather Trousers', 'Armour', 'Leather', 'Simple leather trousers', '', 3, NULL, 100, 15, 1),
(27, 'Leather Shirt', 'Armour', 'Leather', 'Simple pieces of leather fashoned into a shirt', '', 3, NULL, 100, 15, 1),
(28, 'Leather hat', 'Armour', 'Leather', 'Simple leather fashioned into a hat', '', 3, NULL, 100, 15, 1),
(29, 'Tiny Potion', 'Healing', 'Pot', 'Tiny potion that restores +10 health', '', 1, '{\"cur_hp\": \"+10\" }', 18, 0, 1),
(30, 'Candy Helmet', 'Armour', 'Other', 'A helmet made entirely from candy cane, infused with magic to withstand blows', '', 1, NULL, 0, 0, 1),
(31, 'Candy Chest Plate', 'Armour', 'Other', 'A chest plate made entirely from candy cane, infused with magic to withstand blows', '', 1, NULL, 0, 0, 1),
(32, 'Candy Leggings', 'Armour', 'Other', 'A pair of trousers made entirely from candy cane, infused with magic to withstand blows', '', 1, NULL, 0, 0, 1),
(33, 'Candy Boots', 'Armour', 'Other', 'A pair of boots made entirely from candy cane, infused with magic to withstand blows', '', 1, NULL, 0, 0, 1),
(34, 'Vale Heart', 'Key Item', 'Other', 'A heart torn from the chest of a Vale monster', '', 0, NULL, 0, 0, 1),
(35, 'Candy Heart', 'Healing', 'Other', 'A candied Vale Heart. Rumours have it that you can gain a significant amount of HP if you eat one but they are super rare', '', 0, '{\"cur_hp\": \"+100\"}', 300, 0, 1),
(36, 'Wolf Fur', 'Other', 'Fur', '', '', 1, NULL, 75, 100, 1),
(37, 'White Fang', 'Other', 'Other', '', '', 1, NULL, 100, 100, 1),
(38, 'Twitching Bird', 'Other', 'Other', '', '', 1, NULL, 1, 100, 1),
(39, 'Trident', 'Other', 'Other', '', '', 1, NULL, 350, 100, 1),
(40, 'Steel Feathers', 'Other', 'Other', '', '', 1, NULL, 30, 100, 1),
(41, 'Star Ruby', 'Other', 'Other', '', '', 1, NULL, 400, 100, 1),
(42, 'Spider\'s Silk', 'Other', 'Other', '', '', 1, NULL, 175, 100, 1),
(43, 'Smile of Metal', 'Other', 'Other', '', '', 1, NULL, 30, 100, 1),
(44, 'Slime Jelly', 'Other', 'Other', '', '', 1, NULL, 2, 100, 1);

-- --------------------------------------------------------

--
-- Table structure for table `item_owned`
--
DROP TABLE IF EXISTS `item_owned`;
CREATE TABLE IF NOT EXISTS `item_owned` (
  `iid` int(11) NOT NULL,
  `oid` int(11) NOT NULL,
  `equipped` int(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `item_owned`
--

INSERT INTO `item_owned` (`iid`, `oid`, `equipped`) VALUES
(11, 1, 1),
(3, 1, 1),
(4, 1, 1),
(5, 1, 1),
(11, 34, 0),
(6, 1, 1),
(3, 34, 0),
(4, 34, 0),
(5, 34, 0),
(6, 34, 0),
(11, 858, 1),
(25, 9, 0),
(26, 9, 1),
(27, 9, 1),
(28, 9, 1),
(25, 9, 0),
(26, 9, 1),
(27, 9, 1),
(28, 9, 1),
(25, 34, 1),
(26, 34, 1),
(27, 34, 1),
(28, 34, 1),
(3, 858, 1),
(11, 39, 1),
(11, 39, 1),
(11, 9, 1),
(25, 858, 1),
(26, 858, 1),
(27, 858, 1),
(3, 35, 0),
(4, 35, 0),
(5, 35, 0),
(6, 35, 0),
(1, 34, 0),
(1, 34, 0),
(1, 34, 0),
(28, 35, 1),
(29, 9, 0),
(11, 96, 1),
(3, 96, 1),
(25, 96, 1),
(26, 96, 1),
(27, 96, 1),
(28, 96, 0),
(1, 34, 0),
(1, 96, 0),
(29, 96, 0),
(27, 35, 1),
(1, 34, 0),
(1, 34, 0),
(1, 34, 0),
(26, 35, 1),
(1, 34, 0),
(25, 35, 1),
(17, 34, 1),
(29, 858, 0),
(28, 39, 1),
(29, 39, 0),
(29, 39, 0),
(26, 39, 1),
(27, 39, 1),
(29, 858, 0),
(29, 858, 0),
(29, 858, 0),
(29, 39, 0),
(29, 39, 0),
(29, 39, 0),
(29, 9, 0),
(1, 34, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0),
(29, 9, 0);

-- --------------------------------------------------------

--
-- Table structure for table `level_xp`
--
DROP TABLE IF EXISTS `level_xp`;
CREATE TABLE IF NOT EXISTS `level_xp` (
  `level` int(11) NOT NULL AUTO_INCREMENT,
  `xp_needed` float NOT NULL,
  PRIMARY KEY (`level`),
  UNIQUE KEY `xp_needed` (`xp_needed`)
) ENGINE=MyISAM AUTO_INCREMENT=42 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `level_xp`
--

INSERT INTO `level_xp` (`level`, `xp_needed`) VALUES
(1, 0),
(2, 101.27),
(3, 210.12),
(4, 334.16),
(5, 480.96),
(6, 658.13),
(7, 873.24),
(8, 1133.9),
(9, 1447.68),
(10, 1822.19),
(11, 2265),
(12, 2783.72),
(13, 3385.92),
(14, 4079.21),
(15, 4871.16),
(16, 5769.38),
(17, 6781.44),
(18, 7914.95),
(19, 9177.48),
(20, 10576.6),
(21, 12120),
(22, 13815.2),
(23, 15669.7),
(24, 17691.3),
(25, 19887.4),
(26, 22265.6),
(27, 24883.6),
(28, 27599),
(29, 30569.3),
(30, 33752.1),
(31, 37155),
(32, 40785.6),
(33, 44651.5),
(34, 48760.3),
(35, 53119.6),
(36, 57736.9),
(37, 62619.8),
(38, 67776),
(39, 73213.1),
(40, 78938.5),
(41, 84960);

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--
DROP TABLE IF EXISTS `locations`;
CREATE TABLE IF NOT EXISTS `locations` (
  `lid` int(2) UNSIGNED NOT NULL,
  `name` varchar(60) NOT NULL,
  `type` enum('Dungeon','Village','Town','City','Castle') NOT NULL,
  `min_level` int(2) NOT NULL DEFAULT 1,
  `active` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`lid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`lid`, `name`, `type`, `min_level`, `active`) VALUES
(1, 'Vas Aven', 'City', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `location_connections`
--
DROP TABLE IF EXISTS `location_connections`;
CREATE TABLE IF NOT EXISTS `location_connections` (
  `con_id` int(2) UNSIGNED NOT NULL,
  `lid` int(2) NOT NULL,
  `connects_to` int(2) NOT NULL,
  PRIMARY KEY (`con_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mon_drops`
--
DROP TABLE IF EXISTS `mon_drops`;
CREATE TABLE IF NOT EXISTS `mon_drops` (
  `did` int(11) NOT NULL AUTO_INCREMENT,
  `mid` int(11) NOT NULL,
  `iid` int(11) NOT NULL,
  `eid` int(11) NOT NULL,
  `msg` text NOT NULL,
  `rate` float NOT NULL,
  `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`did`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `mon_drops`
--

INSERT INTO `mon_drops` (`did`, `mid`, `iid`, `eid`, `msg`, `rate`, `active`) VALUES
(1, 45, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(2, 46, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(3, 47, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(4, 48, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(5, 49, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(6, 50, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(7, 51, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(8, 52, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(9, 53, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(10, 54, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(11, 55, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(12, 56, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(13, 57, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(14, 58, 34, 1, 'The heart of a Vale monster', 0.5, 1),
(15, 2, 44, 0, '', 0.3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `npc`
--
DROP TABLE IF EXISTS `npc`;
CREATE TABLE IF NOT EXISTS `npc` (
  `nid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` enum('Monster','Friendly','Quest Giver') DEFAULT NULL,
  `hp` int(11) NOT NULL,
  `str` int(11) NOT NULL,
  `def` int(11) NOT NULL,
  `dex` int(11) NOT NULL,
  `spd` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `image` text NOT NULL,
  `lore` text NOT NULL,
  `attack_msg` varchar(255) NOT NULL,
  `defense_msg` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `drop` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`nid`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=66 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `npc`
--

INSERT INTO `npc` (`nid`, `name`, `type`, `hp`, `str`, `def`, `dex`, `spd`, `level`, `image`, `lore`, `attack_msg`, `defense_msg`, `active`, `drop`) VALUES
(1, 'test', 'Monster', 100, 1, 1, 1, 1, 1, '', '', '', '', 0, 2),
(2, 'Baby Slime', 'Monster', 6, 2, 1, 1, 1, 1, '', 'A tiny little glob of gel, the slime is the bottom feeder of the monster world', 'a spit of acidic slime', 'its liquidated body', 1, 2),
(3, 'Goblin', 'Monster', 16, 3, 2, 1, 1, 2, '', '', 'its broken sword', 'its shield made from human bones', 1, 3),
(4, 'bat', 'Monster', 10, 2, 1, 1, 1, 1, '', '', 'its vamperic teeth', 'its extra thick fur like hair', 1, 2),
(5, 'Wight', 'Monster', 17, 4, 2, 2, 2, 3, '', '', 'its Longsword', 'its amour made from bone', 1, 4),
(6, 'Krigen', 'Monster', 65, 20, 15, 0, 0, 10, '', 'part of a long line of ancient rock people, every 100 years they elect a champion to defend them from attackers. This phase is Krigen\'s turn. His people mastered the art of regrowth and use that as a weapon, you are the first outsider he has met, but he has heard stories from his people\'s history of the atrocities committed by the outsiders', 'his torn off arm that was thrown', 'a weakened arm', 1, 35),
(7, 'Nutzlos', 'Monster', 17, 2, 1, 1, 0, 2, '', 'Slugs that had their nest filled with radioactive material to make them mutate, but like they can\'t really do much anyways', 'a bite from a surprising amount of teeth', 'curling into a fetal position', 1, 3),
(8, 'Kevin', 'Monster', 27, 17, 9, 5, 2, 10, '', 'A Kevin is a shape shifter, but likes to take the form of Gerry the Onion Farmer ', 'an Elemental breath attack', 'turning into your childhood friend, making you hesitate', 1, 22),
(9, 'Xanores the many', 'Monster', 95, 31, 65, 12, 21, 45, '', 'Nobody knows where Xanores came from. But they remember the day it did. Thousands died and three cities were leveled by the creature. It now resides in the ruins of Vas-havenath. A once blooming garden city home to 8000 ', 'multiple heads chomping at your body', 'putting an expendable head in the path of the attack, then regrowing it', 1, 94),
(10, 'Shade', 'Monster', 18, 27, 10, 28, 16, 7, '', 'The Shades are a mysterious race of beings from the land mass north west of Fellglade. They are the creatures responsible for the killing of Aesons dragon and countless other Fellglade rangers (and dragons) at the battle of arrowhead. They represent a threat so great they caused Xanores the Many to flee its native land. The origin of these creatures is unknown, they kill everything they touch and consume it, adding to their form. They are without mercy. They remain contained behind the Border Mountains in an area known as Shadesland for while alsmot unkillable, extremes of temperature do have an effect, thus the hight of the mountains and the fire of Fellglade dragons help contain the shades. On occasion one entity has been known to make it through the mountains and wreak havok on a village. But this is a rare occourance as after the battle of arrow head, they were believed eradicated. ', 'Organic reduction and consumption. It picks you apart cell by cell after impaling you with etheric spines', 'turning into a vapourous cloud', 1, 31),
(11, 'C1 Droid', 'Monster', 27, 4, 25, 4, 5, 11, '', 'A weird golem type creature with flashing lights on it', 'a beam of light from its extremities', 'its metal exterior', 1, 12),
(12, 'snivlio', 'Monster', 15, 2, 1, 1, 0, 1, '', 'snivlio come to life out of boredom from the small spark of magic that dwells within the triangle inlaid in their hands they then proceed to ramble on about anything and everything till their hapless foe falls asleep one this happens they move onto the next foe.', 'your own weapon as their rambling made you feel too drowzy to hold it properly', 'its ceramic exterior', 1, 2),
(13, 'smitirs', 'Monster', 14, 11, 8, 0, 0, 5, '', 'smitirs were created when a wizard attempting to gain an advantage for his troops on the battlefield tried to enchant a set of armour to assist knights when fighting while out numbered.However when he was casting his spell he sneezed and instead of casting over the armour he struck the weapons stand the weapons flew to life and began duplicating out of control the wizard and his men attempted to wrangle and destroy all the creations however many escaped and continue to duplicate and fight at will when discovered.', 'its sword', 'a shield parrying your attack', 1, 6),
(14, 'Spungus', 'Friendly', 10, 1, 1, 1, 1, 1, '', 'This whale was once part of a great family of salespeople, then his family was murdered and he was the only survivor. he now roams the world selling stuff to people in hopes he\'ll find someone worthy enough to get revenge for him. (possible quest line in the future)', 'none', 'none', 1, 0),
(15, 'Cockatrice', 'Monster', 27, 4, 5, 12, 7, 6, '', 'similar to the basilisk in origin and powers, the cockatrice is a dangerous creature with a lizard body, snake tail, dragon wings and the head and legs of a rooster. A cockatrice is born when a rooster lays an egg that is hatched by a toad or serpent. Whereas a basilisk is born from a toad or snake egg hatched by a rooster. Some tales say that the rooster has to be seven years old and lay it under a full moon and the toad or serpent has to hatch it for nine years. The first description of a cockatrice appeared in the late twelfth century and was written by Alexander Neckam.', 'a bite', 'its large fangs', 1, 15),
(16, 'Boar', 'Monster', 13, 7, 2, 4, 7, 5, '', '', 'its tusk whilst charging', 'its thick tusks', 1, 6),
(17, 'Feral Cat', 'Monster', 9, 1, 1, 8, 5, 2, '', 'A feral black cat that was neglected by its owner', 'its claws', 'its tail', 1, 3),
(18, 'Death Dog', 'Monster', 34, 15, 12, 8, 6, 7, '', 'A death dog is an ugly two-headed hound that roams plains, and deserts. Hate burns in a death dog’s heart, and a taste for humanoid flesh drives it to Attack travelers and explorers. Death dog saliva carries a foul disease that causes a victim’s flesh to slowly rot off the bone.', 'rapid biting by both heads', 'its giant paws', 1, 100),
(19, 'Diseased Rat', 'Monster', 11, 8, 4, 2, 2, 3, '', 'A sewer rat that oozes a black sludgy substance', 'a sludgebomb', 'its giant teeth', 1, 4),
(20, 'Frost Giant', 'Monster', 143, 29, 21, 9, 4, 30, '', 'Frost giants, called isejotunen in their own language,were large giants that lived in caverns or castles in cold, mountainous environments. Almost always evil creatures, these giants stood 20\' (6.4 m) tall and weighed around 2800 lbs (1270 kg). They had white skin and either blue or dirty yellow hair and wore skins or pelts, along with jewelry they owned. Their eye color usually matched their hair color.', 'its greataxe that came crashing down', 'a rock it threw in your path', 1, 800),
(21, 'Harpy', 'Monster', 18, 6, 4, 1, 1, 4, '', 'A harpy had the upper body of a female humanoid and the lower body of an reptilian creature, with scaly legs, clawed feet, and clawed hands with knotty fingers. Harpies had coal-black eyes in faces like cruel old women, with hair that was filthy, tangled, and crusted with old dry blood. They possessed powerful leathery wings with which they could fly and carry away their victims.', 'its knobbly club', 'the gust of its wings', 1, 5),
(44, 'Drummers drumming', 'Monster', 30, 2, 1, 0, 0, 5, '', '12 drummers, with drums.', 'their beat of Here comes the bells increasing in volume disorientating you', 'spinning in their circle of 12', 0, 20),
(25, 'Haunted Pumpkin', 'Monster', 10, 10, 0, 0, 5, 1, '', '', 'pumpkin seeds spat at high speed', '', 0, 15),
(26, 'Toilet Paper Mummy', 'Monster', 15, 3, 2, 0, 2, 1, '', '', 'throwing diseased toilet paper', '', 0, 1),
(22, 'Hobgoblin', 'Monster', 11, 13, 18, 6, 6, 3, '', '', 'an arrow fired from its longbow', 'its steel shield', 1, 50),
(23, 'Quipper', 'Monster', 6, 2, 0, 8, 5, 1, '', 'A quipper is a carnivorous fish with sharp teeth. Quippers can adapt to any aquatic Environment, including cold subterranean lakes. They frequently gather in swarms', 'a bite like movement', 'a splash of water in your face', 1, 2),
(24, 'Giant Purple Worm', 'Monster', 266, 28, 22, 4, 3, 45, '', 'As its name implied, the purple worm was deep purple in color, with a pale yellow underbelly. Separating its yellow part from its purple part were hard crests going down its sides. It was well-armored and segmented. One end of the purple worm terminated in a large, toothed mouth, with slit-like eyes set above the mouth and dragon\'s ear-like limbs at the sides of the \"head\". While many that encountered the purple worm worried about falling into the worm’s mouth, they commonly forgot about the creature’s tail, which was capped by a poisonous paralytic stinger. The purple worm was often depicted as bursting out of the ground and arching itself in a distinctive pose. Purple worms were not able to speak', 'its giant tail stinger', 'its thick carcass', 1, 810),
(27, 'Frankenstein Baby', 'Monster', 5, 10, 0, 0, 1, 1, '', '', 'an overpowered fist', '', 0, 1),
(28, 'Thug dressed as Dracula', 'Monster', 20, 1, 2, 0, 2, 1, '', '', 'fake vampire bite', '', 0, 1),
(29, 'Olga Tombend', 'Friendly', 0, 0, 0, 0, 0, 0, '', '', '', '', 0, 0),
(30, 'Niecks the Lustful', 'Friendly', 0, 0, 0, 0, 0, 0, '', '', '', '', 1, 0),
(31, 'Trainee Assasin', 'Monster', 8, 6, 8, 16, 4, 3, '', 'A trainee from the Brotherhood', 'thrown shurikens', 'their katana', 1, 5),
(32, 'The Head Elf', 'Friendly', 0, 0, 0, 0, 0, 0, '', '', '', '', 0, 0),
(33, 'Partridge Controlled Ent', 'Monster', 20, 2, 1, 0, 0, 2, '', 'An Ent that was hollowed out by evil Partridges and is now used as a control tower for the partridge', 'launched sour pears that insides are filled with a pear flavored acid that burns through armour', 'a thick piece of bark', 0, 10),
(34, '2 Kamikazi Turtle Doves', 'Monster', 15, 3, 3, 0, 0, 2, '', 'Turtle doves that have gained a hardened shell over their body causing a protective layer that has caused them to dive at their enemies, retracting into their shell', 'a dive bomb', 'retracting into its shell', 0, 12),
(35, 'Fearful Hen', 'Monster', 22, 4, 4, 0, 0, 2, '', '3 hens that fear everything, They attack with their backs to their enemy as they are too cowardly to look their enemies in the eye.', 'garlic filled eggs fired from the place where eggs come from.', 'flapping in the air', 0, 14),
(36, 'Insulting Birds', 'Monster', 18, 2, 2, 0, 0, 2, '', '4 birds who just insult you to the point of insanity when they then peck you death, one sensory organ at a time. ', 'a verbal barrage of insults', 'a large screech disorientating you', 0, 16),
(37, 'Ring Wraith', 'Monster', 20, 7, 6, 0, 0, 4, '', '5 Ring Wraiths after all the golden rings they can find', 'an etheric blade that plunged deep into your very soul', 'phased out of this reality', 0, 5),
(38, 'Geese', 'Monster', 15, 8, 3, 0, 0, 2, '', 'A flock of angry geese... Enough said really', 'evil honk and jab with their beaks', 'flapping their wings', 0, 20),
(39, 'Mutated Swan', 'Monster', 25, 5, 3, 0, 0, 2, '', '7 swans of unusual size.', 'its long silky smooth neck', 'flapping their wings', 0, 22),
(40, 'P**sed off Milk Maids', 'Monster', 40, 2, 0, 0, 0, 2, '', '8 p**sed of maids who just beat you with milking stools for scaring the cows away', 'milk stools', 'the cows they hid behind', 0, 22),
(41, 'Hypnotic Dancer', 'Monster', 22, 6, 1, 0, 0, 1, '', '9 spectral ladies who hypnotise you with their dancing before cutting your throat', 'razer sharp boots whilst spinning', 'by slowing down your movement with hypnotism', 0, 24),
(42, 'Leaping Spider Lords', 'Monster', 20, 3, 2, 22, 8, 1, '', '10 Lords who have been bitten by poison jumping spiders and now have their reflexes', 'venom spat from their mouths', 'a shot out spider web', 0, 24),
(43, 'Plumbers a-piping', 'Monster', 15, 2, 8, 1, 1, 1, '', '11 plumbers who beat you with lengths of copper pipe ', 'a copper pipe', 'a copper pipe', 0, 10),
(51, 'Ethereal chrysalis', 'Monster', 10, 3, 3, 0, 0, 8, '', '', '', '', 0, 16),
(45, 'Infant Tredder', 'Monster', 10, 3, 3, 2, 2, 1, '', '', 'razor sharp claws', 'its boney exo-skeleton', 0, 5),
(46, 'Tredders Familiar', 'Monster', 15, 3, 4, 2, 2, 5, '', '', 'razor sharp claws', 'its boney exo-skeleton', 0, 10),
(47, 'Juvenile Tredder', 'Monster', 20, 4, 4, 2, 2, 5, '', '', 'razor sharp claws', 'its boney exo-skeleton', 0, 15),
(48, 'Adult Tredder', 'Monster', 30, 5, 5, 2, 2, 5, '', '', 'razor sharp claws', 'its boney exo-skeleton', 0, 10),
(49, 'Ethereal Worm', 'Monster', 12, 6, 1, 0, 0, 5, '', '', 'Razor Sharp teeth', 'thick skin', 0, 10),
(50, 'Heart Seeker', 'Monster', 20, 5, 4, 0, 0, 5, '', '', 'Razor Sharp teeth', 'thick skin', 0, 15),
(52, 'Ethereal flyer', 'Monster', 40, 2, 2, 0, 0, 5, '', '', '', '', 0, 10),
(53, 'Heart finder demon', 'Monster', 100, 1, 3, 0, 0, 5, '', '', '', '', 0, 16),
(54, 'Aged tredder', 'Monster', 100, 1, 1, 0, 0, 5, '', '', '', '', 0, 10),
(55, 'Heart eater devil', 'Monster', 110, 1, 3, 0, 0, 5, '', '', '', '', 0, 16),
(56, 'Lustfull cockatrice', 'Monster', 100, 5, 1, 0, 0, 5, '', '', '', '', 0, 10),
(57, 'Ascendent tredder', 'Monster', 110, 1, 3, 0, 0, 5, '', '', '', '', 0, 16),
(58, 'Heart ravager demon', 'Monster', 100, 5, 1, 0, 0, 5, '', '', '', '', 0, 10),
(59, 'Auctioneer', 'Friendly', 0, 0, 0, 0, 0, 1, '', '', '', '', 1, 0),
(60, 'Farmery', 'Friendly', 0, 0, 0, 0, 0, 0, 'n/a', 'n/a', 'n/a', 'n/a', 1, 0),
(61, 'Leeches', 'Monster', 15, 2, 2, 0, 2, 2, '', '', '', '', 1, 3),
(62, 'Sea Goat', 'Monster', 16, 2, 3, 1, 3, 3, '', '', '', '', 1, 4),
(63, 'Flan', 'Monster', 25, 2, 0, 0, 0, 3, '', '', '', '', 1, 4),
(64, 'Imp', 'Monster', 13, 8, 8, 2, 2, 4, '', '', '', '', 1, 5),
(65, 'Dryad', 'Monster', 18, 6, 7, 0, 2, 4, '', '', '', '', 1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `npc_fight_stats`
--
DROP TABLE IF EXISTS `npc_fight_stats`;
CREATE TABLE IF NOT EXISTS `npc_fight_stats` (
  `npc_id` int(11) NOT NULL,
  `win` int(11) NOT NULL DEFAULT 0,
  `loss` int(11) NOT NULL DEFAULT 0,
  UNIQUE KEY `npc_id` (`npc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `npc_fight_stats`
--

INSERT INTO `npc_fight_stats` (`npc_id`, `win`, `loss`) VALUES
(17, 10, 66),
(19, 6, 4),
(62, 4, 9),
(13, 12, 0),
(63, 1, 12),
(11, 1, 0),
(61, 3, 27),
(2, 6, 76),
(5, 3, 10),
(4, 18, 61),
(12, 4, 10),
(64, 10, 1),
(65, 10, 2),
(31, 21, 8),
(3, 2, 12),
(16, 6, 6),
(23, 6, 60),
(7, 3, 6),
(22, 10, 0),
(21, 1, 4);

-- --------------------------------------------------------

--
-- Table structure for table `player_vs_monster`
--
DROP TABLE IF EXISTS `player_vs_monster`;
CREATE TABLE IF NOT EXISTS `player_vs_monster` (
  `cid` int(11) NOT NULL,
  `mid` int(11) NOT NULL,
  `win` int(11) NOT NULL DEFAULT 0,
  `loss` int(11) NOT NULL DEFAULT 0,
  UNIQUE KEY `cid` (`cid`,`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `player_vs_monster`
--

INSERT INTO `player_vs_monster` (`cid`, `mid`, `win`, `loss`) VALUES
(858, 2, 28, 0),
(34, 13, 0, 7),
(34, 63, 5, 1),
(34, 61, 14, 0),
(1, 11, 0, 1),
(1, 61, 3, 2),
(34, 2, 9, 1),
(9, 5, 0, 2),
(34, 4, 7, 1),
(858, 4, 29, 3),
(35, 4, 0, 2),
(9, 62, 0, 2),
(1, 19, 0, 3),
(1, 17, 7, 1),
(34, 19, 4, 1),
(39, 4, 9, 3),
(1, 12, 4, 0),
(34, 64, 1, 5),
(1, 13, 0, 2),
(34, 65, 0, 7),
(34, 31, 6, 4),
(34, 3, 9, 0),
(34, 17, 9, 0),
(34, 16, 4, 2),
(39, 2, 11, 1),
(39, 23, 8, 0),
(96, 17, 1, 0),
(96, 7, 1, 1),
(9, 12, 0, 2),
(9, 4, 9, 7),
(1, 4, 6, 1),
(1, 23, 5, 1),
(1, 31, 2, 3),
(1, 7, 2, 0),
(1, 63, 6, 0),
(1, 16, 2, 0),
(1, 22, 0, 3),
(1, 65, 2, 1),
(1, 64, 0, 2),
(39, 31, 0, 5),
(9, 23, 22, 3),
(9, 17, 16, 6),
(1, 2, 6, 0),
(34, 23, 8, 0),
(34, 5, 10, 1),
(34, 62, 6, 0),
(34, 12, 5, 1),
(1, 62, 0, 1),
(34, 22, 0, 3),
(858, 16, 0, 3),
(96, 12, 0, 1),
(96, 4, 1, 1),
(35, 61, 1, 0),
(35, 17, 1, 1),
(858, 31, 0, 3),
(96, 23, 0, 2),
(39, 12, 1, 0),
(858, 17, 29, 1),
(9, 31, 0, 3),
(35, 64, 0, 1),
(35, 65, 0, 1),
(34, 7, 3, 0),
(858, 61, 9, 1),
(39, 63, 1, 0),
(39, 16, 0, 1),
(35, 3, 0, 2),
(96, 65, 0, 1),
(96, 31, 0, 2),
(9, 7, 0, 1),
(39, 62, 0, 1),
(39, 22, 0, 1),
(34, 21, 4, 1),
(39, 7, 0, 1),
(35, 31, 0, 1),
(9, 2, 18, 3),
(35, 2, 3, 1),
(858, 3, 2, 0),
(858, 19, 0, 2),
(858, 23, 17, 0),
(858, 62, 3, 0),
(96, 13, 0, 1),
(858, 22, 0, 3),
(858, 13, 0, 2),
(39, 17, 3, 1),
(858, 64, 0, 2),
(1, 3, 1, 0),
(96, 2, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `play_fight_stats`
--
DROP TABLE IF EXISTS `play_fight_stats`;
CREATE TABLE IF NOT EXISTS `play_fight_stats` (
  `character_id` int(11) NOT NULL,
  `mon_win` int(11) NOT NULL DEFAULT 0,
  `mon_lose` int(11) NOT NULL DEFAULT 0,
  `play_win` int(11) NOT NULL DEFAULT 0,
  `play_lose` int(11) NOT NULL DEFAULT 0,
  UNIQUE KEY `character_id` (`character_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `play_fight_stats`
--

INSERT INTO `play_fight_stats` (`character_id`, `mon_win`, `mon_lose`, `play_win`, `play_lose`) VALUES
(35, 5, 9, 0, 0),
(858, 117, 20, 0, 0),
(34, 104, 35, 0, 0),
(9, 65, 29, 0, 0),
(1, 46, 21, 0, 0),
(39, 33, 14, 0, 0),
(96, 4, 9, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `race`
--
DROP TABLE IF EXISTS `race`;
CREATE TABLE IF NOT EXISTS `race` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `str_mod` int(11) NOT NULL DEFAULT 0,
  `def_mod` int(11) NOT NULL DEFAULT 0,
  `dex_mod` int(11) NOT NULL DEFAULT 0,
  `spd_mod` int(11) NOT NULL DEFAULT 0,
  `hp_mod` int(11) NOT NULL DEFAULT 0,
  `ap_mod` int(11) NOT NULL DEFAULT 0,
  `active` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `race`
--

INSERT INTO `race` (`id`, `name`, `str_mod`, `def_mod`, `dex_mod`, `spd_mod`, `hp_mod`, `ap_mod`, `active`) VALUES
(1, 'Human', 0, 0, 1, 0, -1, -1, 1),
(2, 'Xi\'al', -1, 1, -1, 2, -1, 0, 1),
(3, 'Gormons', 2, -2, -1, -1, 2, 0, 1),
(4, 'Soreshi', -3, -1, 1, 1, 1, 2, 1),
(5, 'Skalli', 2, 2, -1, -2, 0, -1, 1),
(6, 'Fixies', 0, 0, 1, -2, 0, 1, 1),
(7, 'Helason', 1, -1, -3, 0, 1, 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `season_xp`
--
DROP TABLE IF EXISTS `season_xp`;
CREATE TABLE IF NOT EXISTS `season_xp` (
  `sid` int(3) NOT NULL,
  `cid` int(3) NOT NULL,
  `xp` float NOT NULL,
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shop`
--
DROP TABLE IF EXISTS `shop`;
CREATE TABLE IF NOT EXISTS `shop` (
  `sid` int(11) NOT NULL AUTO_INCREMENT,
  `nid` int(11) NOT NULL COMMENT 'npc id',
  `name` varchar(60) NOT NULL,
  `min_level` int(11) NOT NULL,
  `balance` int(11) NOT NULL DEFAULT 1000,
  `open` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`sid`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `nid` (`nid`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `shop`
--

INSERT INTO `shop` (`sid`, `nid`, `name`, `min_level`, `balance`, `open`) VALUES
(1, 14, 'Dockside Shop', 1, 7288, 1),
(2, 29, 'Mysterious Shop', 1, 1000, 0),
(3, 30, 'Nieck\'s War Shop', 4, 1300, 1),
(4, 32, 'Santa\'s Grotto', 1, 1000, 0),
(5, 59, 'Auction House', 5, 0, 0),
(6, 60, 'Farmerys Armoury', 5, 1000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `shop_items`
--
DROP TABLE IF EXISTS `shop_items`;
CREATE TABLE IF NOT EXISTS `shop_items` (
  `sid` int(11) NOT NULL,
  `iid` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `ranged` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `shop_items`
--

INSERT INTO `shop_items` (`sid`, `iid`, `qty`, `ranged`) VALUES
(1, 1, 990, 1),
(1, 2, 3, 1),
(1, 3, 4, 1),
(1, 4, 8, 1),
(1, 5, 7, 1),
(1, 6, 8, 1),
(0, 11, 15, 1),
(1, 11, 0, 1),
(2, 18, 13, 1),
(2, 19, 9, 1),
(2, 20, 12, 1),
(2, 21, 12, 1),
(2, 1, 1000, 0),
(1, 9, 0, 0),
(2, 8, 0, 0),
(1, 8, 0, 0),
(2, 7, 0, 0),
(1, 7, 0, 0),
(2, 6, 0, 0),
(2, 5, 0, 0),
(2, 4, 0, 0),
(2, 3, 0, 0),
(2, 2, 0, 0),
(2, 9, 0, 0),
(1, 10, 0, 0),
(2, 10, 0, 0),
(2, 11, 1, 0),
(1, 12, 0, 1),
(2, 12, 0, 0),
(1, 13, 0, 0),
(2, 13, 0, 0),
(1, 14, 0, 0),
(2, 14, 0, 0),
(1, 15, 0, 0),
(2, 15, 0, 0),
(1, 16, 0, 0),
(2, 16, 0, 0),
(1, 17, 0, 0),
(2, 17, 0, 0),
(1, 18, 0, 0),
(1, 19, 0, 0),
(1, 20, 0, 0),
(1, 21, 0, 0),
(1, 22, 0, 0),
(2, 22, 0, 0),
(1, 23, 0, 0),
(2, 23, 0, 0),
(1, 24, 0, 0),
(2, 24, 0, 0),
(3, 2, 0, 0),
(3, 24, 14, 1),
(3, 3, 0, 0),
(3, 4, 0, 0),
(3, 5, 1, 0),
(3, 6, 1, 0),
(3, 7, 0, 0),
(3, 8, 11, 1),
(3, 9, 15, 1),
(3, 1, 1000, 0),
(3, 10, 0, 0),
(3, 11, 1, 0),
(3, 12, 0, 0),
(3, 13, 0, 0),
(3, 14, 0, 0),
(3, 15, 0, 0),
(3, 16, 14, 1),
(3, 17, 12, 1),
(3, 18, 6, 0),
(3, 19, 2, 0),
(3, 20, 0, 0),
(3, 21, 0, 0),
(3, 22, 14, 1),
(3, 23, 14, 1),
(1, 25, 3, 1),
(1, 26, 0, 1),
(1, 27, 2, 1),
(1, 28, 6, 1),
(2, 25, 0, 0),
(2, 26, 0, 0),
(2, 27, 0, 0),
(2, 28, 0, 0),
(4, 1, 1000, 0),
(4, 2, 0, 0),
(4, 3, 0, 0),
(4, 4, 0, 0),
(4, 5, 0, 0),
(4, 6, 0, 0),
(4, 7, 0, 0),
(4, 8, 0, 0),
(4, 9, 0, 0),
(4, 10, 0, 0),
(4, 11, 0, 0),
(4, 12, 0, 0),
(4, 13, 0, 0),
(4, 14, 0, 0),
(4, 15, 0, 0),
(4, 16, 0, 0),
(4, 17, 0, 0),
(4, 18, 0, 0),
(4, 19, 0, 0),
(4, 20, 0, 0),
(4, 21, 0, 0),
(4, 22, 0, 0),
(4, 23, 0, 0),
(4, 24, 0, 0),
(4, 25, 0, 0),
(4, 26, 0, 0),
(4, 27, 0, 0),
(4, 28, 0, 0),
(1, 29, 995, 1),
(2, 29, 1000, 0),
(3, 29, 1000, 0),
(4, 29, 1000, 0),
(5, 29, 1000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `twitch_id` bigint(20) DEFAULT NULL,
  `discord_id` bigint(20) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `follower` tinyint(1) DEFAULT 0,
  `subscriber` tinyint(1) DEFAULT 0,
  `vip` tinyint(1) DEFAULT 0,
  `staff` tinyint(1) DEFAULT 0,
  `first_seen` datetime NOT NULL DEFAULT current_timestamp(),
  `class` int(2) NOT NULL DEFAULT 1,
  `race` int(2) NOT NULL,
  `level` int(2) NOT NULL DEFAULT 1,
  `xp` float NOT NULL DEFAULT 0,
  `cur_hp` int(2) NOT NULL,
  `max_hp` int(2) NOT NULL,
  `cur_ap` int(2) NOT NULL,
  `max_ap` int(2) NOT NULL,
  `str` int(2) NOT NULL,
  `def` int(2) NOT NULL,
  `dex` int(2) NOT NULL,
  `spd` int(2) NOT NULL,
  `pouch` int(2) NOT NULL DEFAULT 0,
  `gender` int(2) NOT NULL DEFAULT 1,
  `location` int(2) NOT NULL DEFAULT 1,
  `gathering` tinyint(1) NOT NULL DEFAULT 0,
  `travelling` tinyint(1) NOT NULL DEFAULT 0,
  `registered` int(2) NOT NULL DEFAULT 0,
  `alpha_tester` tinyint(1) NOT NULL DEFAULT 0,
  `beta_tester` tinyint(1) NOT NULL DEFAULT 0,
  `reroll_count` int(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `discord_id` (`discord_id`),
  UNIQUE KEY `twitch_id` (`twitch_id`)
) ENGINE=MyISAM AUTO_INCREMENT=868 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`uid`, `twitch_id`, `discord_id`, `username`, `follower`, `subscriber`, `vip`, `staff`, `first_seen`, `class`, `race`, `level`, `xp`, `cur_hp`, `max_hp`, `cur_ap`, `max_ap`, `str`, `def`, `dex`, `spd`, `pouch`, `gender`, `location`, `gathering`, `travelling`, `registered`, `alpha_tester`, `beta_tester`, `reroll_count`) VALUES
(1, 57026834, 131526937364529152, 'Marc', 1, 1, 1, 1, '2019-06-05 19:45:22', 1, 4, 3, 245.083, 0, 22, 5, 3, 3, 3, 3, 1, 2746, 0, 1, 0, 0, 1, 1, 1, 0),
(2, 132383768, 126147416490639362, 'UnholyBiscuits', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(3, 118695358, 195494511164653569, 'South', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(4, 161505573, 341174556813426699, 'mikles123', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(5, NULL, 139132976234627072, 'Sammy', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(6, 72271205, 227467912988852224, 'greeny', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 718, 1, 1, 0, 0, 0, 1, 1, 0),
(7, 56632053, 135737565482450944, 'Ninbinz', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(8, 408751734, 168867005447929859, 'XoR-UK', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(9, 83523590, 150674115869671425, 'C_rex101', 1, 1, 0, 0, '2019-06-05 19:45:22', 1, 5, 2, 142.25, 14, 14, 3, 3, 1, 6, 1, 1, 2051, 1, 1, 0, 0, 1, 1, 1, 0),
(10, 141806998, 550062421851766799, 'Oniramensama', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(11, 68996523, 318206790976274432, 'averyxstream', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(12, 57538657, 175968809595699201, 'Barnabees', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(13, 165181181, 256558300777283584, 'BarbieBrittany', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(14, 41733547, 301759256351211523, 'StayFrosty', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(15, NULL, 159020223033245697, 'kolkonos', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(16, 401543549, 518632719828385823, 'SslapShots', 1, 1, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 400, 1, 1, 0, 0, 0, 0, 0, 0),
(17, 68525264, 157381881963347968, 'OneClick', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(18, NULL, 345418201795919882, 'DEMIG0D_SHRIMP', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(19, 26159970, 128988808346599424, 'Nick', 1, 0, 0, 0, '2015-05-24 12:30:44', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(20, 116279195, 142523474756370433, 'PizzaxDealer', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(21, 114686644, 293214940771385344, 'GamingMusume', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(22, 245506636, 261697017296715787, 'titansrage91', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(23, NULL, 192841690027917312, 'Azele', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(24, NULL, 183682747561148417, 'Onii', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(25, 31022369, 150473412911955969, 'beastkilla98', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(26, NULL, 300681564902129664, 'Kuro', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(27, 134428077, 218179945111748608, 'Cakten', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(28, 41652227, 130452600804868096, 'King Diddy', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(29, 88088334, 136658562179923968, 'U.P.S', 1, 1, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 400, 1, 1, 0, 0, 0, 1, 1, 0),
(30, 174952093, 295291293461118986, 'GreenLeader06', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 515, 1, 1, 0, 0, 0, 0, 0, 0),
(31, 115643550, 173968972671090698, 'Sig_Shezza', 1, 1, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 400, 1, 1, 0, 0, 0, 0, 0, 0),
(32, 163234697, 433179221792260104, 'thumpersfriend', 1, 1, 1, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 420, 1, 1, 0, 0, 0, 0, 0, 0),
(33, 38593267, 296714564391665665, 'Numno', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(34, 64561697, 131526180313628672, 'clarebedo', 1, 0, 0, 1, '2019-06-05 19:45:22', 1, 3, 4, 377.083, 23, 21, 7, 7, 7, 5, 4, 5, 2628, 1, 1, 1, 0, 1, 1, 1, 0),
(35, 149513502, 336624040682979330, 'Aszod', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 7, 1, 16.75, 0, 7, 8, 6, 1, 2, 3, 3, 1359, 1, 1, 0, 0, 1, 1, 1, 0),
(36, NULL, 333028780002246681, 'TheBlueHeeler72', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(311, 248741683, NULL, '0_applebadapple_0', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(38, 85730445, 262923746380218368, 'Joeh92400', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(39, 90603019, 131718614536421376, 'Pyrolily', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 4, 1, 86.75, 13, 12, 6, 4, 1, 2, 2, 3, 330, 1, 1, 0, 0, 1, 0, 1, 0),
(40, NULL, 341370138563706902, 'TheShroomeyOne', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(41, NULL, 224260367696658432, 'Jaaack', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(43, 42301342, 178197579509661696, 'InzeNL', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(44, NULL, 467714753293320198, 'Kodey', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(45, 90333937, 310963918119895040, 'FrostyDaHomeboy', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(46, 57241134, NULL, 'SevenDeadlyCyns', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(47, 110153674, NULL, 'projectpbr', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(48, 430213017, NULL, 'ssaction', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(49, 119305997, NULL, 'bringdaking', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(50, 275529915, NULL, 'LANPlanet', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(51, 69499384, NULL, 'Deadscargg', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(52, 138675457, NULL, 'KageNoTsuma', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(53, 49638712, NULL, 'marioeraclio', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(54, 110947021, NULL, 'sidneylopsides', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(55, 53242452, NULL, 'Shockdoc51', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(56, 414870, NULL, 'minustheward', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(57, 172800208, NULL, 'Relentless_Iron', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(58, 57367628, NULL, 'shadowxclone', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(59, 100512779, NULL, 'JRobles44', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(60, 61897405, NULL, 'Lunchbauks', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(61, 137376166, NULL, 'SycoCell', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(62, 73016851, NULL, 'Hanstaur', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(63, 232330943, NULL, 'unnikoo', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(64, 188691270, NULL, 'Fortnite_Bomb', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(65, 142765323, NULL, 'hmdmrr', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(66, 237756449, NULL, 'Chef_Pecten', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(67, 97327712, NULL, 'SnarkyJay', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(68, 192239658, NULL, 'TX_Rocker', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(69, 83604483, NULL, 'lvl_4_mew', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(70, 108615203, NULL, 'citRa', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(71, 51663379, NULL, 'AmeetUK', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(73, 64697598, NULL, 'Alejo_47', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(88, 420449069, NULL, 'literallambda', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(89, 149339308, NULL, 'unseen_nrg', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(90, 150920392, NULL, 'TsarSec', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(91, 36669274, NULL, 'queuetowin', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(92, 115403387, NULL, 'whatshisname00', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(93, 414879028, NULL, 'Gravitty000', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(94, 110701259, NULL, 'jackzeys', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(95, 135205752, NULL, 'twikeluul', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(96, 116259367, 153550000155131904, 'P_Rigz', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 2, 1, 13.75, 0, 7, 3, 3, 5, 1, 4, 4, 132, 1, 1, 0, 0, 1, 1, 1, 0),
(98, 268618678, NULL, 'ynkx', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(99, 23354190, NULL, 'Warcried', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(100, 169377571, NULL, 'sencooos', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(101, 41174089, NULL, 'remth', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(102, 109735450, NULL, 'Niix', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(103, 113036865, NULL, 'wyporsky', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(104, 97074445, NULL, 'Banufong_Jnr', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(105, 278096963, NULL, 'SquidJS', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(106, 77656059, NULL, 'MisterJTattoo', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(107, 127687542, NULL, 'thacken5', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(109, 36480316, NULL, 'JoelB83', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(110, 95847872, NULL, 'Phenomenal_Jay', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(112, 24669051, NULL, 'Ruxomar', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(113, 145695834, 551053155652206602, 'ItsDLCBot', 1, 1, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2852, 1, 1, 0, 0, 0, 0, 0, 0),
(114, 85946140, NULL, 'Daleasomemine34', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(115, 278719678, NULL, 'thespeakerbottest', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(117, 279357095, NULL, 'testclarebedo', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(118, 207425364, NULL, 'foxygamer755', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(119, 278700340, NULL, 'itslittanytest', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(120, 86395171, NULL, 'PleasantlyTwstd', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(121, 27225596, NULL, 'JavaMonkey_', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(122, 42520302, NULL, 'Cerus13', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(123, 138905979, NULL, 'GuardiansForGuardians', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(124, 50115551, 154500955407122432, 'HitorieUK', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(125, 238393505, NULL, 'JoltenGames', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(368, 173551477, NULL, 'CaRnAgE420Gaming', 1, 0, 0, 0, '2019-06-07 23:43:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(127, 99963315, NULL, 'realvstargaming', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(128, 65833588, NULL, 'MopGarden', 1, 0, 1, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(129, 114749401, NULL, 'tabletop_twitch', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(130, 158120569, NULL, 'Brunswicker', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(131, 37272873, NULL, 'opp_enigma', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(132, 211071291, NULL, 'LittleHomerG', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(133, 193093772, NULL, 'ColonelGravy', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(134, 86037616, NULL, 'Homeless_bishs', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(135, 53090518, NULL, 'Jruiz007', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(136, 71281461, NULL, 'LittleAl', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(137, 164038221, NULL, 'SmokeyJoe9893', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(138, 224411461, NULL, 'icewallow_come12342', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(139, 47709367, NULL, 'BadHairGaming', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(140, 219925665, NULL, 'deathdragon780', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(141, 59262584, NULL, 'lNightsidel', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(142, 62755209, NULL, 'Angani_Giza', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(143, 78936539, NULL, 'GuanoMaestro', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(144, 74872188, NULL, 'Wrigglemania', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(145, 154508743, NULL, 'Romangoddess86', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(146, 27203940, NULL, 'milosbeli', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(147, 215637424, NULL, 'kammiller0402', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(148, 190871870, NULL, 'buddah329', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(149, 187271404, NULL, 'awoken_queeb_', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(150, 42738948, NULL, 'WelshSkipper', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(151, 36999648, NULL, 'the_lightling', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(152, 68394758, NULL, 'RBT9202', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(153, 213603201, NULL, 'ChickenessChan', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(154, 185087142, NULL, 'iZZi12341', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(155, 64617357, NULL, 'thedwnwrdspiral', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(156, 109482775, NULL, 'dripthedm', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(157, 22015430, NULL, 'Raishiwi', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(158, 211604048, NULL, '2xgangs', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(159, 141972488, NULL, 'Sennen_', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(160, 193805184, NULL, 'crystal0845', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(161, 119099544, NULL, 'Flurpy1', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(162, 209718597, NULL, 'hullean', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(163, 54966532, NULL, 'Balsy_GG', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(164, 140535178, NULL, 'thefantasticflygon', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(165, 144353440, NULL, 'BritishNerdNetwork', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(166, 201089718, NULL, 'madilyncobb4585', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(167, 193754669, NULL, 'CaptainBangers', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(168, 149658524, NULL, 'ysuede12', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(169, 80314097, NULL, 'Repotsirkay', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(170, 186769878, NULL, 'xXMajorFortniteXx', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(171, 72427463, NULL, 'Nicholasmythwizard', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(172, 115768719, NULL, 'savvyatgamecafe', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(173, 185359655, NULL, 'fastattack537', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(174, 188659898, NULL, 'LilTobasco', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(175, 131755649, NULL, 'TheAlakazamKing', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(176, 155774039, NULL, 'iPsyop', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(177, 126741564, NULL, 'hobbithedder', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(178, 53992580, NULL, 'BWalker8732', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(179, 121913285, NULL, 'FancySadFace', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(180, 127576802, NULL, 'CovexGames', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(181, 76138561, NULL, 'Czardd', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(182, 100297916, NULL, 'RainbowQuantum', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(183, 82563641, NULL, 'Skyypilot05', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(184, 42362566, NULL, 'SubLovesFood', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(185, 136196238, NULL, 'sinthes_', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(186, 142284296, NULL, 'Angelthetic', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(187, 87168840, NULL, 'CrimsonGreen', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(188, 133574795, NULL, 'desync_tv', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(189, 173210290, NULL, 'AceVaPoRR', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(190, 146921945, NULL, 'starrkaleb615', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(191, 144366639, NULL, 'soxygamer', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(192, 109165783, NULL, 'LuwNah', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(193, 60028617, NULL, 'Hearty_Valor', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(194, 119128431, NULL, 'marlon19', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(195, 163184183, NULL, 'Jube_Law', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(196, 134886133, NULL, 'RedSA', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(197, 96937665, NULL, 'Lolthulhu', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(198, 56646612, NULL, 'Wiztek', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(199, 89072169, NULL, 'Blade_iii', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 116, 1, 1, 0, 0, 0, 0, 0, 0),
(200, 116647895, NULL, 'TheRealWolluf', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(201, 170533641, NULL, 'Ace_Trainer_Spin', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(202, 133330726, NULL, 'Godsixa', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(203, 121487626, NULL, 'Eye95', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(204, 165482670, NULL, 'Virtual_Turtle_', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(205, 158568501, NULL, 'krigaren_maze', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(206, 92140902, NULL, 'kdogracing', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(207, 144792878, NULL, 'CounterBaron', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(208, 102257533, NULL, '128393', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(209, 130749260, NULL, 'grzzl_bear', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(210, 134847944, NULL, 'ringlord54', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(211, 161881235, NULL, 'seventwofifty', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(212, 146362345, NULL, 'adir478', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(213, 166136409, NULL, 'mikles111', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(214, 123616230, NULL, 'Univarseman', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(215, 165391359, NULL, 'SBS_Girl', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(216, 164832692, NULL, 'Pokestar34', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(217, 41858064, NULL, 'DarkZekrom9898', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(218, 119832502, NULL, 'kyle021sii', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(219, 7853751, NULL, 'PocketX', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(220, 129138256, NULL, 'ameslia', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(221, 90484478, NULL, 'BADBULL', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(222, 112015013, NULL, 'bambamsnoops', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(223, 121397692, NULL, 'xGoldShinobi', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(224, 103722277, NULL, 'Chris2Hottie4Thottyz', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(225, 99443433, NULL, 'Thegoldkamehameha', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(226, 129376605, NULL, 'morgeyislive', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(227, 103449416, NULL, 'Ijesusjuice', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(228, 87670695, NULL, 'pyrolilyx', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(229, 48948644, NULL, 'Evo2587', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(230, 45081569, NULL, 'dRaGGin_loW', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(231, 87760104, NULL, 'CrashKoeck', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(232, 156046276, NULL, 'JediGeneralFox', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(233, 77033782, NULL, 'PrrpleGrl', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(234, 38448737, NULL, 'unicornhorn1212', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(235, 155399097, NULL, 'prevtheperv', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(236, 98223991, NULL, 'Rileylakin01', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(237, 114736558, NULL, 'MorganWheelwright', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(238, 108707754, NULL, 'ckay10', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(239, 132549024, NULL, 'coast_freezy', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(240, 96711765, NULL, 'Thatonedude1000', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(241, 153249230, NULL, 'nuclearjigglypuff', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(242, 147575243, NULL, 'veedohtv', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(243, 81751872, NULL, 'Fastshooter114', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(244, 117566187, NULL, 'MysteryMitry', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(245, 45081784, NULL, 'TheChaozMaster', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(246, 65272630, NULL, 'Sylar_08', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(247, 99283892, NULL, 'YaShAwHiTeTiGeR', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(248, 129252220, NULL, 'Evertone', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(249, 46765736, NULL, 'TheMagicPanch', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(250, 148159852, NULL, 'loserforriverphoenix', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(251, 139155624, NULL, 'davidduck2222', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(252, 119981907, NULL, 'trissix1802', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(253, 139206250, NULL, 'melbs22', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(254, 112605120, NULL, 'Dachaosbringergaming', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(255, 132387701, NULL, 'MissNinetales', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(256, 134513734, NULL, 'kingmunchlax123', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(257, 140208943, NULL, 'thedanksnorlax', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(258, 139614094, NULL, 'SaManiatic', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(259, 92446921, NULL, 'Masterchiefv86', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(260, 63262456, NULL, 'ACGC_Gaming', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(261, 53182772, NULL, 'NRaGED', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(262, 91351445, NULL, 'egg931', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(263, 126357253, NULL, 'XeZeroMods', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(264, 147213559, NULL, 'aian234', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(265, 98814106, NULL, 'WildieBear', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(266, 109661977, NULL, 'Fawkes90', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(267, 97146786, NULL, 'soulserfer_', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(268, 146397571, NULL, 'xxsickskillerxx', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(269, 77464323, NULL, 'ohDrippy', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(270, 54440210, NULL, 'Hyperchucks', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(271, 143954172, NULL, 'AtOneWithNothing', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(272, 132428642, NULL, 'divorcedgaming', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(273, 128264561, NULL, 'DVFD1412', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(274, 139900179, NULL, 'styluss', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(275, 96881118, NULL, 'Apimpnamedstein', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(276, 37985448, NULL, 'H42Y', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(277, 94144113, NULL, 'SmokedMist', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(278, 112494246, NULL, 'TJayy25', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(279, 94198163, NULL, 'shotgun_andy', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(280, 119717882, NULL, 'newkidhd20', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(281, 86796540, NULL, 'finessin101tv', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(282, 89846579, NULL, 'Mini_psyco', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(283, 138575283, NULL, 'HypnoticAngel99', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(284, 66675029, NULL, 'slangille', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(285, 36018029, NULL, 'WoefulDragon', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(286, 52761443, NULL, 'kazu_uk', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(287, 143130769, NULL, 'kuldude111', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(288, 118798947, NULL, 'MamaT118', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(289, 145329025, NULL, 'iqhoudini', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(290, 111317817, NULL, 'Miss_Val', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(291, 115333511, NULL, 'johneeeee5', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(292, 144067153, NULL, 'Icedtea901', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(293, 37872378, NULL, 'Luigibx', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(294, 103332720, NULL, 'Dennis_jammes', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(295, 112684730, NULL, 'danfinity', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(296, 134760880, NULL, 'prettyboycali', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(297, 51120087, NULL, 'Loldarian', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(298, 39948454, NULL, 'wildRiot', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(299, 69749377, NULL, 'NirvashTypeMQ', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(37, 127501457, 139558424261296128, 'synxiec', 1, 1, 1, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 426, 1, 1, 0, 0, 0, 0, 0, 0),
(301, 36967210, NULL, 'FlawlessMethod', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(302, 99782688, NULL, 'Xxxmlgrazorxxx', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(303, 86918377, NULL, 'hollywood_walton15', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(304, 51464000, NULL, 'HuskerGirl_KC', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(305, 83045939, NULL, 'Babygoogie1', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(306, 90915593, NULL, 'Johnnycage_10', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(307, 37007131, NULL, '09ghost90', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(308, 76446492, NULL, 'stormyways13', 1, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(309, 91395389, NULL, 'lrrrn', 1, 0, 0, 0, '2015-05-25 08:14:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(310, 21287178, NULL, 'leoknighted', 1, 0, 0, 0, '2015-05-18 20:49:41', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(312, 162076870, NULL, 'streamerinsights', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(313, 73764126, NULL, 'cyclemotion', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(314, 100135110, NULL, 'streamelements', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 876, 1, 1, 0, 0, 0, 0, 0, 0),
(315, 233740941, NULL, 'lurkernetwork', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(316, 19264788, NULL, 'nightbot', 0, 0, 0, 0, '2019-06-05 19:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(317, 252248316, NULL, 'lurxx', 0, 0, 0, 0, '2019-06-05 20:29:11', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 1, 1, 0, 0, 0, 0, 0, 0),
(318, 54219279, NULL, 'bgrising', 0, 0, 0, 0, '2019-06-05 20:40:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(319, 250165298, NULL, 'backwoodsgamen', 0, 0, 0, 0, '2019-06-05 20:41:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(320, 136979261, NULL, 'kaskadetwitch', 1, 0, 0, 0, '2019-06-05 20:42:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(321, 175839982, NULL, 'drunkncanuck', 0, 0, 0, 0, '2019-06-05 20:43:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(322, 139243940, NULL, 'kbdadragon', 0, 0, 0, 0, '2019-06-05 20:44:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(323, 117729006, NULL, 'golfdoggaming', 0, 0, 0, 0, '2019-06-05 20:44:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(324, 411103920, NULL, 'chevis007', 0, 0, 0, 0, '2019-06-05 20:45:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(325, 153690706, NULL, 'xxsytherxxgaming', 1, 0, 0, 0, '2019-06-05 20:45:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(326, 49678204, NULL, 'balderov', 0, 0, 0, 0, '2019-06-05 20:45:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(327, 173303583, NULL, 'mysteriousgirl', 0, 0, 0, 0, '2019-06-05 20:45:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(328, 96980887, NULL, 'flarknesstv', 0, 0, 0, 0, '2019-06-05 20:47:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(329, 233019940, NULL, 'drpn808', 0, 0, 0, 0, '2019-06-05 20:47:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(330, 55982597, NULL, 'viciouswolf', 0, 0, 0, 0, '2019-06-05 20:47:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(331, 200338036, NULL, 'smarmytank', 0, 0, 0, 0, '2019-06-05 20:48:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(332, 230882088, NULL, 'verdicus81', 1, 0, 0, 0, '2019-06-05 20:48:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(333, 146794355, NULL, 'tickleslip', 1, 0, 0, 0, '2019-06-05 20:48:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(334, 205052173, NULL, 'freddyybot', 0, 0, 0, 0, '2019-06-05 20:49:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(335, 227202086, NULL, 'v_and_k', 0, 0, 0, 0, '2019-06-05 20:50:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(336, 41222043, NULL, 'darkpenx', 0, 0, 0, 0, '2019-06-05 20:50:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(337, 126732100, NULL, 'virgoproz', 0, 0, 0, 0, '2019-06-05 20:51:44', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(338, 410250281, NULL, 'cachebear', 0, 0, 0, 0, '2019-06-05 20:52:52', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(339, 25681094, NULL, 'commanderroot', 0, 0, 0, 0, '2019-06-05 20:52:52', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56, 1, 1, 0, 0, 0, 0, 0, 0),
(340, 83961569, NULL, 'twistednj', 0, 0, 0, 0, '2019-06-05 20:52:52', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(341, 439352037, NULL, 'angeloflight', 0, 0, 0, 0, '2019-06-05 20:57:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(342, 101905203, NULL, 's1faka', 0, 0, 0, 0, '2019-06-05 20:57:58', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(343, 180340140, NULL, 'unorthodoxmlnd', 0, 0, 0, 0, '2019-06-05 21:02:24', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(344, 155773026, NULL, 'jopawrites', 0, 0, 0, 0, '2019-06-05 21:24:44', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(345, 81524934, NULL, 'chefanthony', 0, 0, 0, 0, '2019-06-05 21:39:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(346, 111797219, NULL, 'fietsfreakske', 0, 0, 0, 0, '2019-06-05 21:46:07', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(347, 43148905, NULL, 'xatang', 0, 0, 0, 0, '2019-06-05 21:49:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(348, 175993635, NULL, 'jodja1337', 0, 0, 0, 0, '2019-06-05 22:13:58', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(349, 198236322, NULL, 'electricallongboard', 0, 0, 0, 0, '2019-06-05 22:26:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 1, 0, 0, 0, 0, 0, 0),
(350, 85232987, NULL, 'fatefulhunterd', 0, 0, 0, 0, '2019-06-05 22:26:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(351, 264246119, NULL, 'p0lizei_', 0, 0, 0, 0, '2019-06-05 22:36:38', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(352, 127472266, NULL, 'suicidethatyap', 1, 0, 0, 0, '2019-06-05 22:53:40', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(353, 139588619, NULL, 'matttheotter', 1, 1, 0, 0, '2019-06-05 22:56:52', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 400, 1, 1, 0, 0, 0, 0, 0, 0),
(354, 129738771, NULL, 'jobi_essen', 0, 0, 0, 0, '2019-06-05 23:17:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(355, 187099894, NULL, 'stellaseafoam', 0, 0, 0, 0, '2019-06-05 23:35:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(356, 129114217, NULL, 'laf21', 0, 0, 0, 0, '2019-06-06 20:01:11', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(357, 429006004, NULL, 'headshotz112', 0, 0, 0, 0, '2019-06-06 20:13:40', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(358, 249378946, NULL, 'konkky', 0, 0, 0, 0, '2019-06-06 20:13:40', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(359, 187897516, NULL, 'taynesworld', 0, 0, 0, 0, '2019-06-06 20:13:40', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(360, 64355917, NULL, 'thenotoriousbgk', 0, 0, 0, 0, '2019-06-06 20:14:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(361, 237762273, NULL, 'ownage_everyday', 0, 0, 0, 0, '2019-06-06 20:21:12', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(362, 21586476, NULL, 'indyfind', 0, 0, 0, 0, '2019-06-06 20:22:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(363, 76665945, NULL, 'daylights', 0, 0, 0, 0, '2019-06-06 20:24:26', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(364, 133379879, NULL, 'hadoukengaming', 0, 0, 0, 0, '2019-06-06 20:47:38', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(365, 136289399, NULL, 'drunkprisoncat', 1, 0, 0, 0, '2019-06-06 20:49:42', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(366, 146201042, NULL, 'triixx_sh', 0, 0, 0, 0, '2019-06-06 21:16:15', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(367, 440198391, NULL, 'speedyclapper', 0, 0, 0, 0, '2019-06-06 22:20:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(369, 440601531, NULL, 'kiroszlolksm', 1, 0, 0, 0, '2019-06-08 21:54:16', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(370, 24124163, NULL, 'dorkasauras', 0, 0, 0, 0, '2019-06-12 20:25:04', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(371, 256459127, NULL, 'the8bitdee', 0, 0, 0, 0, '2019-06-12 20:25:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(372, 98791531, NULL, 'rebelztv_', 0, 0, 0, 0, '2019-06-12 20:25:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(373, 135904588, NULL, 'grav3digga', 0, 0, 0, 0, '2019-06-12 20:26:04', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(374, 187371798, NULL, 'dirtyhobbits', 0, 0, 0, 0, '2019-06-12 20:28:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(375, 425732389, NULL, 'maverick_xr', 0, 0, 0, 0, '2019-06-12 20:28:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(376, 406576975, NULL, 'anotherttvviewer', 0, 0, 0, 0, '2019-06-12 20:59:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(377, 130851094, NULL, 'cynicaltrash15', 0, 0, 0, 0, '2019-06-12 21:03:00', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(378, 157264230, NULL, 'slocool', 0, 0, 0, 0, '2019-06-14 19:54:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(379, 190734066, NULL, 'handzdown630', 0, 0, 0, 0, '2019-06-14 20:02:47', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(380, 138908379, NULL, 'guardianvirus', 0, 0, 0, 0, '2019-06-14 20:20:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(381, 176923813, NULL, 'tatertoast', 0, 0, 0, 0, '2019-06-14 20:24:32', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(382, 123464118, NULL, 'freakey', 0, 0, 0, 0, '2019-06-14 20:36:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(383, 161668062, NULL, 'nekrovim', 0, 0, 0, 0, '2019-06-14 20:48:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0);
INSERT INTO `users` (`uid`, `twitch_id`, `discord_id`, `username`, `follower`, `subscriber`, `vip`, `staff`, `first_seen`, `class`, `race`, `level`, `xp`, `cur_hp`, `max_hp`, `cur_ap`, `max_ap`, `str`, `def`, `dex`, `spd`, `pouch`, `gender`, `location`, `gathering`, `travelling`, `registered`, `alpha_tester`, `beta_tester`, `reroll_count`) VALUES
(384, 179693632, NULL, 'technoproblems', 0, 0, 0, 0, '2019-06-18 21:18:38', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(385, 139640006, NULL, 'artimis_entrrerii', 0, 0, 0, 0, '2019-06-18 21:28:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(386, 243547061, NULL, 'merssene557', 0, 0, 0, 0, '2019-06-18 21:35:48', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(387, 198809547, NULL, 'stumblingpirate', 0, 0, 0, 0, '2019-06-18 21:37:49', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(388, 404299009, NULL, 'vulkanfuz', 0, 0, 0, 0, '2019-06-18 21:38:49', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(389, 184313820, NULL, 'tonymontano666', 0, 0, 0, 0, '2019-06-18 21:40:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(390, 224503908, NULL, 'vampsontwitch', 1, 0, 0, 0, '2019-06-18 21:43:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(391, 79928526, NULL, 'impulsiveaxe', 0, 0, 0, 0, '2019-06-18 21:46:26', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(392, 164585527, NULL, 'kryptonite_spg', 0, 0, 0, 0, '2019-06-18 22:00:13', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(393, 215295753, NULL, 'boombah12254', 1, 0, 0, 0, '2019-06-18 22:01:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(394, 409692639, NULL, 'sbudnik1', 0, 0, 0, 0, '2019-06-18 22:23:12', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(395, 193110594, NULL, 'vvexilevv', 0, 0, 0, 0, '2019-06-18 22:29:33', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(396, 430183700, NULL, 'acolite24', 0, 0, 0, 0, '2019-06-20 21:30:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(397, 429365996, NULL, 'torottorot', 0, 0, 0, 0, '2019-06-20 21:34:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(398, 2943, NULL, 'teyyd', 0, 0, 0, 0, '2019-06-20 21:36:32', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(399, 48574894, NULL, 'jaystone812', 0, 0, 0, 0, '2019-06-20 21:50:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(400, 100531594, NULL, 'danime_sama', 0, 0, 0, 0, '2019-06-20 21:50:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(401, 43284547, NULL, 'calloz', 0, 0, 0, 0, '2019-06-20 21:50:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(402, 183846920, 344941950761304064, 'brains31325', 1, 0, 0, 0, '2019-06-20 22:16:13', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(403, 246993285, NULL, 'miggeth', 0, 0, 0, 0, '2019-06-25 21:02:14', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(404, 68933671, NULL, 'grand_a', 0, 0, 0, 0, '2019-06-25 21:05:20', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(405, 192355356, NULL, 'rpjohn', 0, 0, 0, 0, '2019-06-25 21:08:20', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(406, 262316191, NULL, 'monaliza355', 0, 0, 0, 0, '2019-06-25 21:12:34', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(407, 45985242, NULL, 'cosmiccx', 0, 0, 0, 0, '2019-06-25 21:12:34', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(408, 199084735, NULL, 'seasonedbeginner', 0, 0, 0, 0, '2019-06-25 21:13:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(409, 191894092, NULL, 'decentlp', 0, 0, 0, 0, '2019-06-25 21:21:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(410, 228428906, NULL, 'ikanos37', 0, 0, 0, 0, '2019-06-25 21:28:33', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(411, 415598926, NULL, 'brainboxdotcc', 1, 0, 0, 0, '2019-06-25 21:28:33', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(412, 78500946, NULL, 'jaycaulls', 0, 0, 0, 0, '2019-06-25 21:51:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(413, 69142710, NULL, 'unixchat', 0, 0, 0, 0, '2019-06-25 22:08:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(414, 118237507, NULL, 'mraygaming', 0, 0, 0, 0, '2019-06-28 21:13:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(415, 180678432, NULL, 'thatsmoothjazz', 0, 0, 0, 0, '2019-06-28 21:13:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(416, 72850883, NULL, 'drums213', 0, 0, 0, 0, '2019-06-28 21:13:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(417, 274640951, NULL, 'kingsnips1992', 0, 0, 0, 0, '2019-06-28 21:13:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(418, 194960801, NULL, 'xlifeordeathx', 0, 0, 0, 0, '2019-06-28 21:16:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(419, 210019022, NULL, 'provoidey', 0, 0, 0, 0, '2019-06-28 21:16:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(420, 188723036, NULL, 'tacoofthepocket', 0, 0, 0, 0, '2019-06-28 21:16:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(421, 82712347, NULL, 'lvt_', 0, 0, 0, 0, '2019-06-28 21:37:41', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(422, 416543141, NULL, 'lilyhazel', 0, 0, 0, 0, '2019-06-28 21:37:41', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(423, 77799426, NULL, 'brantok', 0, 0, 0, 0, '2019-06-28 21:46:07', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(424, 192146741, NULL, 'gigelfroneomg', 0, 0, 0, 0, '2019-06-28 21:54:04', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(425, 82259863, NULL, 'hroark1', 0, 0, 0, 0, '2019-06-28 22:02:24', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(426, 254694139, NULL, 'zou285289134', 0, 0, 0, 0, '2019-06-28 22:10:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(427, 37637018, NULL, 'lesssugar', 0, 0, 0, 0, '2019-06-28 22:13:12', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(428, 61989285, NULL, 'szczy_pior', 0, 0, 0, 0, '2019-06-28 22:20:36', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(429, 54915706, NULL, 'italian_pandax', 0, 0, 0, 0, '2019-06-28 22:27:41', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(430, 25797479, NULL, 'libranoys', 0, 0, 0, 0, '2019-06-28 22:39:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(431, 26439690, NULL, 'flunkyboast', 0, 0, 0, 0, '2019-06-28 22:40:13', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(432, 102373653, NULL, 'c9papu', 0, 0, 0, 0, '2019-06-28 22:41:18', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(433, 69545274, NULL, 'dan_it_is', 0, 0, 0, 0, '2019-06-28 22:43:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(434, 118413337, NULL, 'notcactus_', 0, 0, 0, 0, '2019-06-28 22:43:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(435, 274982870, NULL, 'spydas02', 0, 0, 0, 0, '2019-06-28 22:45:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(436, 261321038, NULL, 'utry_li0', 0, 0, 0, 0, '2019-06-28 22:54:47', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(437, 46190506, NULL, 'theevil_potato', 0, 0, 0, 0, '2019-06-28 22:55:46', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(438, 185178125, NULL, 'mini8901', 0, 0, 0, 0, '2019-06-28 22:57:52', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(439, 126701832, NULL, 'david46ms', 0, 0, 0, 0, '2019-06-28 22:57:52', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(440, 169979228, NULL, 'jarmishc', 0, 0, 0, 0, '2019-06-28 22:59:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(441, 444677888, NULL, 'sophiesch0ll', 0, 0, 0, 0, '2019-06-28 23:04:00', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(442, 112375357, NULL, 'Lana_Lux', 1, 0, 0, 0, '2019-06-28 23:49:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(443, 61934898, NULL, 'benthemeech', 0, 0, 0, 0, '2019-06-28 23:50:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(444, 29242911, NULL, 'ancilangeli', 0, 0, 0, 0, '2019-07-10 21:09:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(445, 157901721, NULL, 'sandyz', 0, 0, 0, 0, '2019-07-10 21:09:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(446, 440722148, NULL, 'critical_uprise1', 0, 0, 0, 0, '2019-07-10 21:09:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(447, 154383187, NULL, 'lady_art3mis', 0, 0, 0, 0, '2019-07-10 21:09:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(448, 71364293, NULL, 'morbidion', 0, 0, 0, 0, '2019-07-10 21:09:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(449, 45630272, NULL, 'crowd3ontrol', 0, 0, 0, 0, '2019-07-10 21:11:46', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(450, 141687281, NULL, 'iamteebot', 0, 0, 0, 0, '2019-07-10 21:14:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(451, 263445097, NULL, 'astalkingbot', 0, 0, 0, 0, '2019-07-10 21:19:20', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(452, 15709954, NULL, 'luxx01', 0, 0, 0, 0, '2019-07-10 21:20:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(453, 9919945, NULL, 'cesarwk', 0, 0, 0, 0, '2019-07-10 21:26:02', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(454, 1529526, NULL, 'kamelpaj', 0, 0, 0, 0, '2019-07-10 21:26:02', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(455, 41320374, NULL, 'pienopakis', 0, 0, 0, 0, '2019-07-10 21:34:16', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(456, 45762150, NULL, 'nerdrays', 0, 0, 0, 0, '2019-07-10 21:36:20', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(457, 120375526, NULL, 'liberlina', 0, 0, 0, 0, '2019-07-10 21:39:18', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(458, 30128214, NULL, 'daxude', 0, 0, 0, 0, '2019-07-10 21:43:21', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(459, 106158070, NULL, 'stevanoxlive', 0, 0, 0, 0, '2019-07-10 21:45:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(460, 54782976, NULL, 'craftbeards', 1, 0, 0, 0, '2019-07-10 21:49:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(461, 123203963, NULL, 'xgaben_', 0, 0, 0, 0, '2019-07-10 21:51:54', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(462, 23348052, NULL, 'slmidnight', 0, 0, 0, 0, '2019-07-10 21:56:02', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(463, 156351486, NULL, 'thexnc', 0, 0, 0, 0, '2019-07-10 21:58:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(464, 65618713, NULL, 'bellatortr', 0, 0, 0, 0, '2019-07-10 22:00:04', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(465, 64753410, NULL, 'itsvodoo', 0, 0, 0, 0, '2019-07-10 22:03:02', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(466, 28759652, NULL, 'luxmui', 0, 0, 0, 0, '2019-07-10 22:04:09', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(467, 53453031, NULL, 'ghassanpl', 0, 0, 0, 0, '2019-07-10 22:06:16', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(468, 125086753, NULL, 'toniburda', 0, 0, 0, 0, '2019-07-10 22:07:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(469, 63317356, NULL, 'komegga', 0, 0, 0, 0, '2019-07-10 22:08:23', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(470, 51181237, NULL, 'boywithanafro', 1, 0, 0, 0, '2019-07-10 22:09:20', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(471, 183860850, NULL, 'SpongeJr78', 1, 0, 0, 0, '2019-07-15 08:09:03', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(472, 97693368, NULL, 'connorwrightkappa', 0, 0, 0, 0, '2019-07-24 21:26:49', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(473, 59172433, NULL, 'skinnyseahorse', 0, 0, 0, 0, '2019-07-24 21:26:49', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(474, 14251568, NULL, 'vyorrel', 0, 0, 0, 0, '2019-07-24 21:31:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(475, 47784522, NULL, 'onesunrise', 0, 0, 0, 0, '2019-07-24 21:31:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(476, 40862016, NULL, 'salvationdms', 0, 0, 0, 0, '2019-07-24 21:33:15', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(477, 33390095, NULL, 'kappa_kid_', 0, 0, 0, 0, '2019-07-24 21:36:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(478, 7744493, NULL, 'chewtoy', 0, 0, 0, 0, '2019-07-24 21:42:50', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(479, 187337812, NULL, 'smilesandtea', 0, 0, 0, 0, '2019-07-24 22:02:12', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(480, 20700950, NULL, 'limbon2', 0, 0, 0, 0, '2019-07-24 22:04:24', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(481, 113080658, NULL, 'dizidentu', 0, 0, 0, 0, '2019-07-24 22:04:24', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(482, 90129899, NULL, 'cartoonz_s', 0, 0, 0, 0, '2019-07-24 22:05:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(483, 115511150, NULL, 'brtt9', 0, 0, 0, 0, '2019-07-24 22:08:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(484, 137171131, NULL, 'tdusk', 0, 0, 0, 0, '2019-07-24 22:16:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(485, 66277323, NULL, 'hiddensquid776', 0, 0, 0, 0, '2019-07-25 03:35:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(486, 447255272, NULL, 'mopolimopol', 0, 0, 0, 0, '2019-07-29 21:27:54', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(487, 233208809, NULL, 'communityshowcase', 0, 0, 0, 0, '2019-07-29 21:31:02', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(488, 435559314, NULL, 'icedemon2019', 0, 0, 0, 0, '2019-07-29 21:42:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(489, 24900234, NULL, 'bloodlustr', 0, 0, 0, 0, '2019-07-29 22:06:48', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(490, 410730760, NULL, 'legithuntsman', 0, 0, 0, 0, '2019-08-02 21:03:55', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(491, 244834039, NULL, 'naughtynurse80', 0, 0, 0, 0, '2019-08-02 21:03:55', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(492, 258231744, NULL, 'tsdevilishdj', 0, 0, 0, 0, '2019-08-02 21:04:54', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(493, 85538598, NULL, 'berserk_rex', 0, 0, 0, 0, '2019-08-02 21:04:54', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(494, 32320373, NULL, 'invert_tec', 0, 0, 0, 0, '2019-08-02 21:07:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(495, 79241114, NULL, 'rigorandvice', 0, 0, 0, 0, '2019-08-02 21:07:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(496, 39640434, NULL, 'tef42', 0, 0, 0, 0, '2019-08-02 21:10:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(497, 38042144, NULL, 'justcalltre', 0, 0, 0, 0, '2019-08-02 21:10:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(498, 133892869, NULL, 'disloyal80', 0, 0, 0, 0, '2019-08-02 21:11:58', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(499, 147897186, NULL, 'xightx123', 0, 0, 0, 0, '2019-08-02 21:14:03', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(500, 402950065, NULL, 'sworanislive', 0, 0, 0, 0, '2019-08-02 21:20:24', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(501, 253414852, NULL, 'redwoodttv', 0, 0, 0, 0, '2019-08-02 21:24:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(502, 450766827, NULL, 'sorceressus', 0, 0, 0, 0, '2019-08-02 21:40:14', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(503, 209715008, NULL, 'winsock', 0, 0, 0, 0, '2019-08-05 21:09:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(504, 47043788, NULL, 'atoldiago', 0, 0, 0, 0, '2019-08-05 21:15:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(505, 166396273, NULL, 'semioticweapon', 0, 0, 0, 0, '2019-08-05 21:15:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(506, 157761439, NULL, 'kiwiray78', 0, 0, 0, 0, '2019-08-05 21:15:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(507, 52320400, NULL, 'drunkenball_z', 1, 0, 0, 0, '2019-08-05 21:15:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(508, 99713215, NULL, 'redbeard02', 0, 0, 0, 0, '2019-08-05 21:15:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(509, 121918687, NULL, 'liberalideas', 0, 0, 0, 0, '2019-08-05 21:16:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(510, 205169813, NULL, '818curlz', 0, 0, 0, 0, '2019-08-05 21:16:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(511, 42032468, NULL, 'jubbass', 0, 0, 0, 0, '2019-08-05 21:16:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(512, 1246395, NULL, 'dreamerttd', 0, 0, 0, 0, '2019-08-05 21:16:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(513, 82510310, NULL, 'kittd101', 0, 0, 0, 0, '2019-08-05 21:16:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(514, 194461332, NULL, 'yeomanjoey', 0, 0, 0, 0, '2019-08-05 21:16:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(515, 31256595, NULL, 'swiftx90', 0, 0, 0, 0, '2019-08-05 21:51:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(516, 450508240, NULL, 'slackley', 0, 0, 0, 0, '2019-08-05 21:56:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(517, 181850555, NULL, 'knoxmortis', 0, 0, 0, 0, '2019-08-05 21:57:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(518, 118764369, NULL, 'c_rex10101', 1, 0, 0, 0, '2019-08-05 22:33:00', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(519, 54768083, NULL, 'cyndoughquil', 0, 0, 0, 0, '2019-08-05 22:53:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(520, 123353873, NULL, 'miss_cyn', 0, 0, 0, 0, '2019-08-05 22:53:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(521, 161545684, NULL, 'bigbadbrad_', 0, 0, 0, 0, '2019-08-06 13:21:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(522, 52984996, NULL, 'error2147483647', 0, 0, 0, 0, '2019-08-06 13:36:40', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(523, 176079288, NULL, 'radiation_ghoul', 0, 0, 0, 0, '2019-08-06 13:41:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(524, 4663189, NULL, 'valije', 0, 0, 0, 0, '2019-08-06 13:53:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(525, 88330981, NULL, 'metalrocker88', 0, 0, 0, 0, '2019-08-06 14:00:11', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(526, 51953230, NULL, 'daddio66', 0, 0, 0, 0, '2019-08-06 14:07:23', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(527, 42951232, NULL, 'jonespilot', 0, 0, 0, 0, '2019-08-06 14:07:23', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(528, 172951305, NULL, 'steve_shaw', 0, 0, 0, 0, '2019-08-06 14:15:50', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(529, 161680995, NULL, 'running_sloth', 0, 0, 0, 0, '2019-08-06 14:19:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(530, 105974436, 142506979053666304, 'wahnald', 1, 0, 0, 0, '2019-08-06 14:46:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(531, 100294738, NULL, 'shot1kill1', 0, 0, 0, 0, '2019-08-06 14:50:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(532, 90978930, NULL, 'eddiemcmc', 0, 0, 0, 0, '2019-08-06 14:58:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(533, 38152578, NULL, 'blizzoire', 0, 0, 0, 0, '2019-08-06 14:58:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(534, 227155818, NULL, 'flukezzzzz', 0, 0, 0, 0, '2019-08-06 14:58:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(535, 142519649, NULL, 'thesecondaxeman', 0, 0, 0, 0, '2019-08-06 15:12:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(536, 177459598, NULL, 'bl4cksp4rrow', 0, 0, 0, 0, '2019-08-06 15:12:23', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(537, 161093847, NULL, 'evil_0tt0', 0, 0, 0, 0, '2019-08-06 15:25:47', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(538, 66535736, NULL, 'father_bill', 0, 0, 0, 0, '2019-08-06 15:26:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(539, 31982535, NULL, 'sneakylunchbox', 0, 0, 0, 0, '2019-08-06 15:26:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(540, 43981561, NULL, 'blacksheepkitty', 0, 0, 0, 0, '2019-08-06 15:26:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(541, 39218777, NULL, 'yeytixd', 0, 0, 0, 0, '2019-08-06 15:26:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(542, 60667191, NULL, 'kirov_099', 0, 0, 0, 0, '2019-08-06 15:26:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(543, 111622989, NULL, 'thecheatingjehova', 0, 0, 0, 0, '2019-08-06 15:26:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(544, 81954914, NULL, 'chocobond007', 0, 0, 0, 0, '2019-08-06 15:26:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(545, 117179999, NULL, 'oldfatgamer', 0, 0, 0, 0, '2019-08-06 15:26:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(546, 418317030, NULL, 'killatyme1992', 0, 0, 0, 0, '2019-08-06 15:26:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(547, 436223818, NULL, 'akzolux1', 0, 0, 0, 0, '2019-08-06 15:26:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(548, 44907085, NULL, 'coobiexd', 0, 0, 0, 0, '2019-08-06 15:28:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(549, 95339956, NULL, 'v_dark_knight_v', 0, 0, 0, 0, '2019-08-06 15:40:23', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(550, 230772263, NULL, 'paigeharvey_frontierdev', 0, 0, 0, 0, '2019-08-06 15:43:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(551, 110622427, NULL, 'pulloutking6317', 0, 0, 0, 0, '2019-08-06 15:51:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(552, 39999558, NULL, 'abraxocleaner', 0, 0, 0, 0, '2019-08-06 15:57:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(553, 54601876, NULL, '0x4c554b49', 0, 0, 0, 0, '2019-08-06 15:57:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(554, 403326697, NULL, 'pocrevocrednu', 0, 0, 0, 0, '2019-08-06 16:03:33', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(555, 272672902, NULL, 'luki4fun_bot_master', 0, 0, 0, 0, '2019-08-06 16:05:32', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(556, 452714404, NULL, 'quesoats', 0, 0, 0, 0, '2019-08-06 20:23:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(557, 78539763, NULL, 'marincel', 0, 0, 0, 0, '2019-08-06 20:40:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(558, 54642384, NULL, 'sidfallon', 0, 0, 0, 0, '2019-08-06 20:47:48', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(559, 162238289, 608738956552699917, 'gorfic_starshadow', 1, 0, 0, 0, '2019-08-06 20:49:55', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(560, 242093174, NULL, 'anteludus_monk', 0, 0, 0, 0, '2019-08-06 21:04:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(561, 64446957, NULL, 'shedimusprime', 0, 0, 0, 0, '2019-08-06 21:10:47', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(562, 39078189, NULL, 'ninasuavee', 0, 0, 0, 0, '2019-08-06 21:12:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(563, 104666798, NULL, 'gghaz', 0, 0, 0, 0, '2019-08-06 21:12:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(564, 124027765, NULL, 'bcgaming__', 0, 0, 0, 0, '2019-08-06 21:12:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(565, 130000029, NULL, 'xlilmissvixenx', 0, 0, 0, 0, '2019-08-06 21:12:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(566, 133755092, NULL, 'kindofalycan', 0, 0, 0, 0, '2019-08-06 21:12:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(567, 152629913, NULL, 'orthuk', 0, 0, 0, 0, '2019-08-06 21:12:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(568, 185412655, NULL, 'pinktaco', 0, 0, 0, 0, '2019-08-06 21:12:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(569, 32123002, NULL, 'incredible_sausage', 0, 0, 0, 0, '2019-08-06 21:12:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(570, 139090862, NULL, 'quincae', 0, 0, 0, 0, '2019-08-06 21:12:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(571, 40666394, NULL, 'nell_gwyn', 0, 0, 0, 0, '2019-08-06 21:12:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(572, 89422892, NULL, 'freefallclash', 0, 0, 0, 0, '2019-08-06 21:13:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(573, 147399561, NULL, 'euphemismsandoneliners', 0, 0, 0, 0, '2019-08-06 21:13:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(574, 85610951, NULL, 'n3td3v', 0, 0, 0, 0, '2019-08-06 21:13:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(575, 130406252, NULL, 'souls_goated', 0, 0, 0, 0, '2019-08-06 21:13:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(576, 31694636, NULL, 'onaga236', 0, 0, 0, 0, '2019-08-06 21:13:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(577, 30420146, NULL, 'sokolas', 0, 0, 0, 0, '2019-08-06 21:18:18', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(578, 249988979, NULL, 'panda_kun_fu', 0, 0, 0, 0, '2019-08-06 21:19:16', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(579, 162983079, NULL, 'abusloadofkiddies', 0, 0, 0, 0, '2019-08-06 21:21:21', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(580, 44318854, NULL, 'radman404', 0, 0, 0, 0, '2019-08-06 21:27:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(581, 79542627, NULL, 'z3r05k1ll', 0, 0, 0, 0, '2019-08-06 21:39:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(582, 68348317, NULL, 'mrbishb0sh', 0, 0, 0, 0, '2019-08-06 21:41:03', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(583, 87271769, NULL, 'kadbee', 0, 0, 0, 0, '2019-08-06 21:48:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(584, 46748773, NULL, 'tabxdarknez', 0, 0, 0, 0, '2019-08-06 22:12:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(585, 30435041, NULL, 'arshesney', 0, 0, 0, 0, '2019-08-06 22:17:09', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(586, 71268100, NULL, 't0nydamage', 0, 0, 0, 0, '2019-08-06 22:18:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(587, 254402512, NULL, 'wolfgangbang1986', 0, 0, 0, 0, '2019-08-06 22:24:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(588, 52610360, NULL, 'foosty1', 0, 0, 0, 0, '2019-08-06 22:27:32', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(589, 108880211, NULL, 'plaidunicorn', 0, 0, 0, 0, '2019-08-06 22:27:32', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(590, 451185971, NULL, 'sentimentbot_', 0, 0, 0, 0, '2019-08-06 22:34:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(591, 209587679, NULL, 'tani009', 0, 0, 0, 0, '2019-08-06 22:34:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(592, 58357050, NULL, 're7rix', 0, 0, 0, 0, '2019-08-06 22:36:04', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(593, 24846760, NULL, 'pyn4pp3l', 0, 0, 0, 0, '2019-08-06 22:48:12', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(594, 74994312, NULL, 'sadcheetos', 0, 0, 0, 0, '2019-08-06 22:48:12', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(595, 266730340, NULL, 'cmdrtianfang', 0, 0, 0, 0, '2019-08-06 22:55:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(596, 113062929, NULL, 'zeraus90', 0, 0, 0, 0, '2019-08-06 23:08:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(597, 74862078, NULL, 'deutscheseuche', 0, 0, 0, 0, '2019-08-06 23:11:03', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(598, 130507804, NULL, 'grungy_ferret', 0, 0, 0, 0, '2019-08-10 22:10:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(599, 401408615, NULL, 'ricky_and_thebrain', 0, 0, 0, 0, '2019-08-10 22:28:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(600, 87325649, NULL, 'moneyktv', 0, 0, 0, 0, '2019-08-10 23:33:47', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(601, 41706513, NULL, 'ocordyo', 0, 0, 0, 0, '2019-08-10 23:36:56', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(602, 95056185, NULL, 'sneakyado', 0, 0, 0, 0, '2019-08-11 00:30:52', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(603, 23927271, 173796130688204800, 'gingernutts', 0, 0, 0, 0, '2019-08-11 23:23:00', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(604, 73160173, NULL, 'reload__', 0, 0, 0, 0, '2019-08-11 23:26:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(605, 136950243, NULL, 'sai_jager', 0, 0, 0, 0, '2019-08-12 00:09:21', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(606, 52684458, NULL, 'wastedbonzai', 0, 0, 0, 0, '2019-08-12 00:19:37', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(607, 72188283, NULL, 'khalburgo', 0, 0, 0, 0, '2019-08-13 21:51:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(608, 272197979, NULL, 'fwasnake', 0, 0, 0, 0, '2019-08-13 22:18:09', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(609, 51869792, NULL, 'changomike', 0, 0, 0, 0, '2019-08-13 22:20:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(610, 171288270, NULL, 'feainya', 0, 0, 0, 0, '2019-08-15 21:20:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(611, 41449164, NULL, 'dzuvan', 0, 0, 0, 0, '2019-08-15 21:20:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(612, 445837521, NULL, 'abjuui', 0, 0, 0, 0, '2019-08-15 21:27:03', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(613, 141575403, NULL, 'sinodaur', 0, 0, 0, 0, '2019-08-15 21:42:24', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(614, 56283130, NULL, 'kr1llzz', 0, 0, 0, 0, '2019-08-15 21:45:31', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(615, 91437113, NULL, 'mrdem4n', 0, 0, 0, 0, '2019-08-15 21:47:26', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(616, 79734734, NULL, 'matq007', 0, 0, 0, 0, '2019-08-15 21:50:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(617, 200719462, NULL, 'audeoboy', 0, 0, 0, 0, '2019-08-15 21:56:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(618, 69821703, NULL, 'admiralkheir', 0, 0, 0, 0, '2019-08-15 22:16:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(619, 87690089, NULL, 'urban1702', 0, 0, 0, 0, '2019-08-15 22:18:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(620, 32122115, NULL, 'alurith_tv', 0, 0, 0, 0, '2019-08-15 22:18:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(621, 75469976, NULL, '06_badges', 0, 0, 0, 0, '2019-08-15 22:24:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(622, 268955422, NULL, 'nitekgd', 0, 0, 0, 0, '2019-08-15 22:24:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(623, 102806943, NULL, 'lolhorse', 0, 0, 0, 0, '2019-08-15 22:27:24', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(624, 191883934, NULL, 'de3euk', 0, 0, 0, 0, '2019-08-15 22:28:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(625, 212079007, NULL, 'crate_z', 0, 0, 0, 0, '2019-08-15 22:28:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(626, 113153039, NULL, 'mubbirum', 0, 0, 0, 0, '2019-08-15 22:35:50', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(627, 58712231, NULL, 'sabreerbas', 0, 0, 0, 0, '2019-08-15 22:35:50', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(628, 188516378, NULL, 'metafiles', 0, 0, 0, 0, '2019-08-15 22:38:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(629, 81009574, NULL, 'vanyapavlovich', 0, 0, 0, 0, '2019-08-15 22:43:18', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(630, 162307702, NULL, 'poenitus92', 0, 0, 0, 0, '2019-08-15 22:44:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(631, 83701906, NULL, 'ohsnapitsryanm', 0, 0, 0, 0, '2019-08-15 22:44:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(632, 82158047, NULL, 'm0ose666', 0, 0, 0, 0, '2019-08-15 22:45:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(633, 44910037, NULL, 'themightysardine', 0, 0, 0, 0, '2019-08-15 22:45:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(634, 108770947, NULL, 'docteurgui', 0, 0, 0, 0, '2019-08-15 22:45:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(635, 427699281, NULL, 'mant3z', 0, 0, 0, 0, '2019-08-15 22:47:16', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(636, 77316591, NULL, 'cmdr_liella', 0, 0, 0, 0, '2019-08-15 22:49:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(637, 122181479, NULL, 'i_am_w1ll', 0, 0, 0, 0, '2019-08-15 22:53:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(638, 172556461, NULL, 'w4lkingde4d332', 0, 0, 0, 0, '2019-08-15 23:01:49', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(639, 56828731, NULL, 'undeadprometheus', 0, 0, 0, 0, '2019-08-15 23:01:49', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(640, 454881622, NULL, 'sucz_pula', 0, 0, 0, 0, '2019-08-15 23:05:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(641, 235826138, NULL, 'mountainsyde', 0, 0, 0, 0, '2019-08-15 23:11:09', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(642, 225765986, NULL, 'llllleika', 0, 0, 0, 0, '2019-08-15 23:14:07', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(643, 76147603, NULL, 'cmdrchambers', 0, 0, 0, 0, '2019-08-15 23:41:24', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(644, 43074021, NULL, 'reoneas', 0, 0, 0, 0, '2019-08-15 23:42:23', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(645, 245024426, NULL, 'sqweeno', 0, 0, 0, 0, '2019-08-15 23:49:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(646, 179859108, NULL, 'samus502', 0, 0, 0, 0, '2019-08-15 23:52:09', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(647, 198837572, NULL, 'javitoplay82', 0, 0, 0, 0, '2019-08-15 23:54:18', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(648, 116959144, NULL, 'auto54', 0, 0, 0, 0, '2019-08-16 00:00:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(649, 106383264, NULL, 'rancidecay', 0, 0, 0, 0, '2019-08-16 00:03:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(650, 79788574, NULL, 'kaineshadory', 0, 0, 0, 0, '2019-08-16 00:05:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(651, 38426063, NULL, 'olmill', 0, 0, 0, 0, '2019-08-16 00:21:44', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(652, 418120959, NULL, 'dret_one', 0, 0, 0, 0, '2019-08-18 21:20:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(653, 173670260, NULL, 'moty_l', 0, 0, 0, 0, '2019-08-18 21:25:42', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(654, 103765149, NULL, 'replicator', 0, 0, 0, 0, '2019-08-18 21:29:46', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(655, 105275191, NULL, 'moro_lg', 0, 0, 0, 0, '2019-08-18 21:29:46', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(656, 448312358, NULL, 'jbugra', 0, 0, 0, 0, '2019-08-18 21:39:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(657, 120672006, NULL, 'cmdr_tony_curtis', 0, 0, 0, 0, '2019-08-18 21:46:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(658, 172307381, NULL, 'kstak', 0, 0, 0, 0, '2019-08-18 22:16:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(659, 167522437, NULL, 'dippy_lippy', 0, 0, 0, 0, '2019-08-18 22:20:42', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(660, 81536843, NULL, 'scottfreeezy', 0, 0, 0, 0, '2019-08-18 22:21:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(661, 432337703, NULL, 'lazza41', 0, 0, 0, 0, '2019-08-18 22:27:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(662, 189115157, NULL, 'dumpsterttv', 0, 0, 0, 0, '2019-08-18 22:29:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(663, 36199197, NULL, 'duivel94', 0, 0, 0, 0, '2019-08-18 22:31:11', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(664, 150636969, NULL, 'sirbuckshot', 0, 0, 0, 0, '2019-08-18 22:35:13', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(665, 133868206, NULL, 'dankcook', 0, 0, 0, 0, '2019-08-18 22:44:47', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(666, 148129710, NULL, 'blaham1', 0, 0, 0, 0, '2019-08-18 22:48:53', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(667, 103972195, NULL, 'papabearaz', 0, 0, 0, 0, '2019-08-18 22:50:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(668, 67362236, NULL, 'matt2e1cpc', 0, 0, 0, 0, '2019-08-18 22:50:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(669, 26308683, NULL, 'hououin_zerion', 0, 0, 0, 0, '2019-08-18 22:57:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(670, 75645098, NULL, 'blasmlive', 0, 0, 0, 0, '2019-08-18 23:00:37', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(671, 449445522, NULL, '000polo000', 0, 0, 0, 0, '2019-08-18 23:02:37', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(672, 115229067, NULL, 'grymborn', 0, 0, 0, 0, '2019-08-18 23:02:37', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(673, 96196140, NULL, 'schulz433', 0, 0, 0, 0, '2019-08-18 23:03:33', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(674, 14091613, NULL, 'hello_im_pawel', 0, 0, 0, 0, '2019-08-18 23:03:33', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(675, 103442410, NULL, 'peryhelium', 0, 0, 0, 0, '2019-08-18 23:04:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(676, 56722182, NULL, 'auty91', 0, 0, 0, 0, '2019-08-18 23:06:50', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(677, 182032005, NULL, 'nithko', 0, 0, 0, 0, '2019-08-18 23:07:54', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(678, 111472313, NULL, 'munumum', 0, 0, 0, 0, '2019-08-18 23:12:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(679, 196321754, NULL, 'sloopbdoop', 0, 0, 0, 0, '2019-08-18 23:17:18', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(680, 409280618, NULL, 'lancechristian7', 0, 0, 0, 0, '2019-08-18 23:18:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(681, 48559373, NULL, 'thewelshotaku', 0, 0, 0, 0, '2019-08-18 23:31:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(682, 95088337, NULL, 'nocplay', 0, 0, 0, 0, '2019-08-18 23:36:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(683, 177632581, NULL, 'reeoats', 0, 0, 0, 0, '2019-08-18 23:38:34', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(684, 96695071, NULL, 'captin_pelley', 0, 0, 0, 0, '2019-08-18 23:41:32', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(685, 72999709, NULL, 'the3rdletter', 0, 0, 0, 0, '2019-08-18 23:43:38', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(686, 66914419, NULL, 'carrumba', 0, 0, 0, 0, '2019-08-18 23:50:12', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(687, 75704808, NULL, 'cmdr_nutter', 0, 0, 0, 0, '2019-08-18 23:56:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(688, 63797661, NULL, 'thelchemis', 0, 0, 0, 0, '2019-08-18 23:58:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(689, 74668269, NULL, 'raceq', 0, 0, 0, 0, '2019-08-19 00:00:37', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(690, 52763420, NULL, 'yt0ne', 0, 0, 0, 0, '2019-08-19 00:01:41', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(691, 177262495, NULL, 'dreamreaper', 0, 0, 0, 0, '2019-08-19 00:03:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(692, 36048598, NULL, 'twofacedd', 0, 0, 0, 0, '2019-08-19 00:11:12', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(693, 161622725, NULL, 'dagraytest', 0, 0, 0, 0, '2019-08-19 00:24:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(694, 107793840, NULL, 'herohas', 0, 0, 0, 0, '2019-08-19 00:25:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(695, 121597681, NULL, 'jonesing87', 0, 0, 0, 0, '2019-08-19 00:27:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(696, 42463958, NULL, 'kcknight23', 0, 0, 0, 0, '2019-08-19 00:35:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(697, 92877429, NULL, 'sleekred', 0, 0, 0, 0, '2019-08-19 00:37:16', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(698, 137560042, NULL, 'cre4t0rgaming', 0, 0, 0, 0, '2019-08-19 00:37:16', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(699, 63720154, NULL, 'tongoz', 0, 0, 0, 0, '2019-08-19 00:40:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(700, 417524835, NULL, 'zipripper', 0, 0, 0, 0, '2019-08-19 00:43:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(701, 154498924, NULL, 'apeseven5', 0, 0, 0, 0, '2019-08-19 00:52:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(702, 135702167, NULL, 'avaton', 0, 0, 0, 0, '2019-08-19 00:52:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(703, 57135394, NULL, 'deathgear2195', 0, 0, 0, 0, '2019-08-19 00:54:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(704, 90965879, NULL, 'jojolamoustache', 0, 0, 0, 0, '2019-08-19 00:54:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(705, 178644023, NULL, 'lfisil', 0, 0, 0, 0, '2019-08-19 00:54:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(706, 151966810, NULL, 'jauss', 0, 0, 0, 0, '2019-08-19 01:00:36', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(707, 89157179, NULL, 'slochy_kt', 0, 0, 0, 0, '2019-08-19 01:14:36', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(708, 61718258, NULL, 'myfunkyself', 0, 0, 0, 0, '2019-08-19 01:14:36', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(709, 194118303, NULL, 'ragingrudytv', 0, 0, 0, 0, '2019-08-19 01:16:38', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(710, 66187712, NULL, 'spammetm', 0, 0, 0, 0, '2019-08-19 01:19:41', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(711, 246267529, NULL, 'undefined_ninja', 0, 0, 0, 0, '2019-08-21 20:03:03', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(712, 182134756, NULL, 'castaway_gaming_au', 0, 0, 0, 0, '2019-08-21 20:08:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(713, 137160778, NULL, 'callmeethan', 0, 0, 0, 0, '2019-08-21 20:09:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(714, 270525540, NULL, 'major_bacon7', 0, 0, 0, 0, '2019-08-21 20:11:37', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(715, 110521865, NULL, 'tortugasanta', 0, 0, 0, 0, '2019-08-21 20:33:52', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(716, 456258744, NULL, 'doubledamage266', 0, 0, 0, 0, '2019-08-21 20:49:47', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(717, 90581413, NULL, 'xfrez23', 0, 0, 0, 0, '2019-08-21 20:54:02', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(718, 456265043, NULL, 'terrydatickler', 0, 0, 0, 0, '2019-08-21 21:21:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(719, 456269121, NULL, 'redstorm99', 0, 0, 0, 0, '2019-08-21 21:38:21', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(720, 456274372, NULL, 'taterth0tos', 0, 0, 0, 0, '2019-08-21 22:05:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(721, 456274191, NULL, 'rokasv3', 0, 0, 0, 0, '2019-08-21 22:05:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(722, 456277567, NULL, 'litbrick2007', 0, 0, 0, 0, '2019-08-21 22:22:13', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(723, 271765044, NULL, 'pops_place', 1, 0, 0, 0, '2019-08-21 22:33:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(724, 94683142, NULL, 'xonar_3', 1, 0, 0, 0, '2019-08-21 22:58:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(725, 456285000, NULL, 'kacperkosy1', 0, 0, 0, 0, '2019-08-21 23:00:20', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(726, 456059941, NULL, 'xs1ddx', 0, 0, 0, 0, '2019-08-23 21:52:42', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(727, 134784651, NULL, 'epoch5555', 0, 0, 0, 0, '2019-08-23 21:52:42', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(728, 148988167, NULL, 'swe_critter', 0, 0, 0, 0, '2019-08-23 21:59:02', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(729, 53414141, NULL, 'nerdforcetv', 0, 0, 0, 0, '2019-08-23 22:13:18', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(730, 53895763, NULL, 'skottiboy', 0, 0, 0, 0, '2019-08-23 22:27:07', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(731, 37188024, NULL, 'datphl', 0, 0, 0, 0, '2019-08-23 22:38:42', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(732, 67568841, NULL, 't3mpest1', 0, 0, 0, 0, '2019-08-23 22:46:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(733, 83894469, NULL, 'jdsplicettv', 0, 0, 0, 0, '2019-08-23 22:51:04', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(734, 177753943, NULL, 'lokiwolff12', 0, 0, 0, 0, '2019-08-23 23:30:07', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(735, 149222792, NULL, 'ginge3690', 0, 0, 0, 0, '2019-08-23 23:43:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(736, 66753852, NULL, 'tennoren', 0, 0, 0, 0, '2019-09-02 21:08:00', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(737, 84407411, NULL, 'bstone_15', 0, 0, 0, 0, '2019-09-02 21:08:00', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(738, 40328343, NULL, 'gamingchamptv', 0, 0, 0, 0, '2019-09-02 21:12:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(739, 445116451, NULL, 'lu77gamer', 0, 0, 0, 0, '2019-09-02 21:13:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(740, 140779317, NULL, 'scomttv', 0, 0, 0, 0, '2019-09-02 21:17:32', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(741, 446417517, NULL, 'justinmon', 0, 0, 0, 0, '2019-09-02 21:18:40', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(742, 45694753, NULL, 'solus_d_erebus', 0, 0, 0, 0, '2019-09-02 21:31:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(743, 143044475, NULL, 'absorbance', 0, 0, 0, 0, '2019-09-02 21:32:55', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(744, 438238903, NULL, 'jjhalcon', 0, 0, 0, 0, '2019-09-02 21:35:03', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(745, 41825538, NULL, 'darthmullins', 0, 0, 0, 0, '2019-09-02 21:40:13', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(746, 60475690, NULL, 'croffy', 0, 0, 0, 0, '2019-09-02 21:59:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(747, 157080959, NULL, 'chrischan1504', 0, 0, 0, 0, '2019-09-02 22:07:26', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(748, 99734520, NULL, 'quick_toes', 0, 0, 0, 0, '2019-09-02 22:11:33', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(749, 69857893, NULL, 'zanekyber', 0, 0, 0, 0, '2019-09-02 22:17:46', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(750, 428416048, NULL, 'dank401', 0, 0, 0, 0, '2019-09-04 11:47:03', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(751, 459666451, NULL, 'denchik725', 0, 0, 0, 0, '2019-09-04 11:48:09', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(752, 205476805, NULL, 'britishbeefbot', 0, 0, 0, 0, '2019-09-04 11:51:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(753, 189224644, NULL, 'skywolf1423', 0, 0, 0, 0, '2019-09-04 11:51:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0);
INSERT INTO `users` (`uid`, `twitch_id`, `discord_id`, `username`, `follower`, `subscriber`, `vip`, `staff`, `first_seen`, `class`, `race`, `level`, `xp`, `cur_hp`, `max_hp`, `cur_ap`, `max_ap`, `str`, `def`, `dex`, `spd`, `pouch`, `gender`, `location`, `gathering`, `travelling`, `registered`, `alpha_tester`, `beta_tester`, `reroll_count`) VALUES
(754, 38179242, NULL, 'marcus_decimus', 0, 0, 0, 0, '2019-09-04 11:51:26', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(755, 404331801, NULL, 'thesteelmushroom', 0, 0, 0, 0, '2019-09-04 11:55:33', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(756, 158618234, NULL, 'quazica1', 0, 0, 0, 0, '2019-09-04 11:57:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(757, 66141229, NULL, 'unknownguardiantv', 0, 0, 0, 0, '2019-09-04 11:59:34', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(758, 219020854, NULL, 'hallidaypickard', 0, 0, 0, 0, '2019-09-04 12:00:41', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(759, 103343845, NULL, 'happisak', 0, 0, 0, 0, '2019-09-04 12:01:44', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(760, 119098213, NULL, 'deep5', 0, 0, 0, 0, '2019-09-04 12:03:55', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(761, 88691354, NULL, 'akiboxer', 0, 0, 0, 0, '2019-09-04 12:03:55', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(762, 101103305, NULL, 'thehoneythief', 0, 0, 0, 0, '2019-09-04 12:03:55', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(763, 43488578, NULL, 'bigstan352', 0, 0, 0, 0, '2019-09-04 12:07:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(764, 69865017, NULL, 'vonmetal', 0, 0, 0, 0, '2019-09-04 12:10:27', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(765, 105609271, NULL, 'iganybloodwind', 0, 0, 0, 0, '2019-09-04 12:11:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(766, 195183380, NULL, 'mrgcrest', 0, 0, 0, 0, '2019-09-04 12:17:40', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(767, 205311484, NULL, 'cmdrguru951', 0, 0, 0, 0, '2019-09-04 12:17:40', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(768, 43111791, NULL, 'coldron', 0, 0, 0, 0, '2019-09-04 12:19:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(769, 410043873, NULL, 'millietg', 0, 0, 0, 0, '2019-09-04 12:21:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(770, 103881192, NULL, 'bjornessen', 0, 0, 0, 0, '2019-09-04 12:21:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(771, 75374155, NULL, 'morkel73', 0, 0, 0, 0, '2019-09-04 12:21:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(772, 39180034, NULL, 'panomanium', 0, 0, 0, 0, '2019-09-04 12:28:16', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(773, 53311823, NULL, 'unknowncobra', 0, 0, 0, 0, '2019-09-04 12:42:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(774, 41371504, NULL, 'furoan', 0, 0, 0, 0, '2019-09-04 13:01:11', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(775, 222320327, NULL, 'bad_pappy', 0, 0, 0, 0, '2019-09-04 13:10:14', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(776, 124051122, NULL, 'aeien_ttv', 0, 0, 0, 0, '2019-09-04 13:13:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(777, 97747906, NULL, 'igromand', 0, 0, 0, 0, '2019-09-04 13:22:00', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(778, 54050425, NULL, 'macabrecutsman', 0, 0, 0, 0, '2019-09-04 13:27:21', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(779, 442641918, NULL, 'epic212', 0, 0, 0, 0, '2019-09-04 13:28:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(780, 443619081, NULL, 'apostolol67', 0, 0, 0, 0, '2019-09-04 13:28:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(781, 219555684, NULL, 'solera977', 0, 0, 0, 0, '2019-09-04 13:28:22', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(782, 260981, NULL, 'cyborgmatt', 0, 0, 0, 0, '2019-09-04 13:38:45', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(783, 190776234, NULL, 'dorco_pio_', 0, 0, 0, 0, '2019-09-04 13:45:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(784, 456524355, NULL, 'definitlynotancil', 0, 0, 0, 0, '2019-09-04 13:47:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(785, 66794498, NULL, 'casual_joker', 0, 0, 0, 0, '2019-09-04 13:49:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(786, 156822412, NULL, 'og_landshark', 0, 0, 0, 0, '2019-09-04 13:51:50', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(787, 114439614, NULL, 'reocreed', 0, 0, 0, 0, '2019-09-04 13:57:54', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(788, 136236413, NULL, 'bluemozen', 0, 0, 0, 0, '2019-09-04 14:00:09', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(789, 88966149, NULL, 'routon_fang', 0, 0, 0, 0, '2019-09-04 14:01:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(790, 410123306, NULL, 'g1ngerfury', 0, 0, 0, 0, '2019-09-06 21:05:40', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(791, 265542646, NULL, 'l2k_snake', 0, 0, 0, 0, '2019-09-06 21:30:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(792, 53007967, NULL, 'newsumo', 0, 0, 0, 0, '2019-09-06 21:30:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(793, 149016588, NULL, 'shuk20', 0, 0, 0, 0, '2019-09-06 21:30:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(794, 188655263, NULL, 'alfredjudokus817', 0, 0, 0, 0, '2019-09-06 21:30:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(795, 163335698, NULL, 'snake_bllisken', 0, 0, 0, 0, '2019-09-06 21:38:23', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(796, 412706121, NULL, 'spookedghost', 0, 0, 0, 0, '2019-09-06 21:38:23', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(797, 52788870, NULL, 'kyaireblackraven', 0, 0, 0, 0, '2019-09-06 21:38:23', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(798, 164689286, NULL, 'alexma83', 0, 0, 0, 0, '2019-09-06 21:50:07', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(799, 24932692, NULL, 'macelster', 0, 0, 0, 0, '2019-09-06 22:05:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(800, 118480596, NULL, 'grandodin', 0, 0, 0, 0, '2019-09-06 22:06:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(801, 51323122, NULL, 'cafias', 0, 0, 0, 0, '2019-09-06 22:06:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(802, 175804956, NULL, 'primitive_trash', 0, 0, 0, 0, '2019-09-06 22:08:07', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(803, 59630551, NULL, 'fyfe73', 0, 0, 0, 0, '2019-09-06 22:12:38', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(804, 90469935, NULL, 'zisso23', 0, 0, 0, 0, '2019-09-06 22:23:06', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(805, 31761314, NULL, 'oldcrowexpress', 0, 0, 0, 0, '2019-09-10 13:23:14', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(806, 75304688, NULL, 'crulen', 0, 0, 0, 0, '2019-09-10 13:24:11', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(807, 194432821, NULL, 'nitrogearzz', 0, 0, 0, 0, '2019-09-10 13:27:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(808, 79071983, NULL, 'vagiclean2_0', 1, 0, 0, 0, '2019-09-10 13:28:13', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(809, 423162501, NULL, 'st_amy', 0, 0, 0, 0, '2019-09-10 13:34:41', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(810, 37055467, NULL, 'bekido', 0, 0, 0, 0, '2019-09-10 13:34:41', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(811, 149506194, NULL, 'thmimic', 0, 0, 0, 0, '2019-09-10 13:43:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(812, 42109752, NULL, 'minidan54', 0, 0, 0, 0, '2019-09-10 13:54:25', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(813, 82654548, NULL, 'fdl_117', 0, 0, 0, 0, '2019-09-10 14:01:39', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(814, 122000637, NULL, 'crazysmurfs', 0, 0, 0, 0, '2019-09-10 14:09:11', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(815, 146159817, NULL, 'jai_b312', 0, 0, 0, 0, '2019-09-10 14:15:14', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(816, 76919496, NULL, 'fabo', 0, 0, 0, 0, '2019-09-10 14:19:13', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(817, 406616039, NULL, 'squishynipples', 0, 0, 0, 0, '2019-09-10 14:32:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(818, 125447108, NULL, 'vodkagta', 0, 0, 0, 0, '2019-09-10 14:32:29', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(819, 27723089, NULL, 'zzzwolfe', 0, 0, 0, 0, '2019-09-10 14:34:28', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(820, 42520282, NULL, 'thevirg01', 0, 0, 0, 0, '2019-09-10 14:51:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(821, 76050012, NULL, 'sotchi123', 0, 0, 0, 0, '2019-09-10 14:52:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(822, 253871547, NULL, 'admriker', 0, 0, 0, 0, '2019-09-10 14:52:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(823, 63819752, NULL, 'wingflux', 0, 0, 0, 0, '2019-09-10 14:58:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(824, 114978653, NULL, 'trickyrunr', 0, 0, 0, 0, '2019-09-10 15:03:48', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(825, 195587604, NULL, 'gig4_alex', 0, 0, 0, 0, '2019-09-10 15:12:23', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(826, 37611275, NULL, 'kestalkayden', 0, 0, 0, 0, '2019-09-18 19:10:58', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(827, 61261534, NULL, 'haughtsauce', 0, 0, 0, 0, '2019-09-20 20:17:33', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(828, 32327737, NULL, 'kkez', 0, 0, 0, 0, '2019-09-20 20:23:43', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(829, 78366977, NULL, 'davvon_', 0, 0, 0, 0, '2019-09-20 20:25:57', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(830, 93061130, NULL, 'cll0ck', 0, 0, 0, 0, '2019-09-20 20:46:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(831, 113880809, NULL, 'rowge', 0, 0, 0, 0, '2019-09-20 20:57:37', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(832, 22720497, NULL, 'txtoast', 1, 0, 0, 0, '2019-09-25 14:24:41', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(833, 113073538, NULL, 'the_ironhammer', 0, 0, 0, 0, '2019-09-25 14:30:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(834, 464018272, NULL, 'bluemanpack', 0, 0, 0, 0, '2019-09-25 14:45:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(835, 464024518, NULL, 'drummel', 0, 0, 0, 0, '2019-09-25 14:49:04', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(836, 462289432, NULL, 'kluflamton', 0, 0, 0, 0, '2019-09-25 15:07:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(837, 464023764, NULL, 'bfuffta', 0, 0, 0, 0, '2019-09-25 15:07:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(838, 95433479, NULL, 'north_station', 0, 0, 0, 0, '2019-09-25 15:37:12', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(839, 464016623, NULL, 'superjis', 0, 0, 0, 0, '2019-09-25 15:39:17', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(840, 447407561, NULL, 'sl33pytim3s', 0, 0, 0, 0, '2019-09-25 15:55:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(841, 464133296, NULL, 'username_already_tekken', 0, 0, 0, 0, '2019-09-25 16:29:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(842, 22339299, NULL, 'marthicus87', 0, 0, 0, 0, '2019-10-01 18:25:44', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(843, 180557273, NULL, 'sourcecodewill', 0, 0, 0, 0, '2019-10-01 18:27:50', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(844, 198277414, NULL, 'hobbitlova', 0, 0, 0, 0, '2019-10-01 18:32:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(845, 131574977, NULL, 'heikargaming', 0, 0, 0, 0, '2019-10-01 18:56:35', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(846, 77512022, NULL, 'destiny_cjm1985', 0, 0, 0, 0, '2019-10-01 19:52:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(847, 140876262, NULL, 'shaz794', 0, 0, 0, 0, '2019-10-01 19:52:01', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(848, 160222142, NULL, 'wowbyevi', 0, 0, 0, 0, '2019-10-01 20:07:52', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(849, 188604220, NULL, 'ammandalovee', 0, 0, 0, 0, '2019-10-02 20:25:05', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(850, 51367386, NULL, 'americanblood', 0, 0, 0, 0, '2019-10-03 20:20:10', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(851, 246746858, NULL, 'spray_n_prayttv', 0, 0, 0, 0, '2019-10-07 21:21:09', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(852, 139452281, NULL, 'witchface77', 0, 0, 0, 0, '2019-10-07 21:45:49', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(853, 71941241, NULL, 'sonsofsobek', 0, 0, 0, 0, '2019-10-07 22:01:30', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(854, 70601117, NULL, 'caramio_on', 0, 0, 0, 0, '2019-10-07 22:07:42', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(855, 117270286, NULL, 'mrcatfish', 0, 0, 0, 0, '2019-10-07 22:15:09', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(856, NULL, 308949254225920001, 'ZombieGoo', 0, 0, 0, 0, '2019-11-02 19:30:36', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0),
(857, NULL, 131528832330104832, 'lrrn', 0, 0, 0, 0, '2019-11-20 00:59:11', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0),
(858, 24604465, 139131826198282240, 'Bill', 1, 0, 0, 0, '2019-12-06 00:53:18', 1, 5, 3, 205.917, 15, 15, 10, 10, 4, 5, 5, 2, 286, 1, 1, 0, 0, 1, 0, 0, 0),
(859, 151923551, 285157896960999425, 'AtomikJaye', 1, 0, 0, 0, '2020-03-04 20:00:59', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 104, 1, 1, 0, 0, 0, 0, 1, 0),
(860, 54115315, NULL, 'dafalconpunch', 1, 0, 0, 0, '2020-03-27 04:50:54', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(861, 498667199, NULL, 'thelivecoders', 1, 0, 0, 0, '2020-03-23 19:12:12', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(862, 228810542, NULL, 'matkoder', 1, 0, 0, 0, '2020-03-22 00:19:51', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(863, 104803870, NULL, 'lordtriux', 1, 0, 0, 0, '2020-03-04 20:01:07', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(864, 121187582, NULL, 'mrshadowluc', 1, 0, 0, 0, '2020-02-29 18:20:24', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(865, 492922339, NULL, 'drhabits', 1, 0, 0, 0, '2020-02-28 21:45:08', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(866, 172742164, NULL, 'the_jondar', 1, 0, 0, 0, '2020-01-19 18:39:46', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0),
(867, 255265543, NULL, 'Firestorm360Official', 1, 0, 0, 0, '2019-12-31 12:52:19', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `weapons`
--
DROP TABLE IF EXISTS `weapons`;
CREATE TABLE IF NOT EXISTS `weapons` (
  `wid` int(11) NOT NULL AUTO_INCREMENT,
  `iid` int(11) DEFAULT NULL,
  `hp_mod` int(11) NOT NULL DEFAULT 0,
  `ap_mod` int(11) NOT NULL DEFAULT 0,
  `str_mod` int(11) NOT NULL,
  `def_mod` int(11) NOT NULL,
  `dex_mod` int(11) NOT NULL,
  `spd_mod` int(11) NOT NULL,
  `attack_msg` varchar(255) NOT NULL,
  PRIMARY KEY (`wid`),
  UNIQUE KEY `iid` (`iid`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `weapons`
--

INSERT INTO `weapons` (`wid`, `iid`, `hp_mod`, `ap_mod`, `str_mod`, `def_mod`, `dex_mod`, `spd_mod`, `attack_msg`) VALUES
(1, 7, 0, 0, 6, 1, -1, -3, 'swung the giant sword at'),
(2, 9, 0, 0, 3, 1, 1, -2, 'swung the limb'),
(3, 11, 0, 0, 1, 0, 0, 0, 'swung the wooden sword at'),
(4, 18, 0, 0, 1, -1, 0, 1, 'lunged with the pointy end of the bolts'),
(5, 19, 0, 0, 1, 0, 0, 0, 'shot a bolt at'),
(6, 16, 0, 0, 2, 1, 0, 0, 'swung the sword at'),
(7, 17, 0, 0, 2, 0, 2, 0, 'lunged with the blade at'),
(8, 22, 0, 0, 3, 2, -2, -3, 'swung the giant sword at'),
(9, 23, 0, 0, 2, 0, 2, 2, 'slashed at'),
(10, 24, 0, 0, 5, 2, -10, -5, 'spung with both hands at');
COMMIT;

GRANT ALL PRIVILEGES
ON marctowl_gapi.*
TO 'marctowl_api'@'%'
WITH GRANT OPTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
