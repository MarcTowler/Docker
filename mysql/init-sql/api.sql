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
-- Database: `marctowl_itslitapi`
--
CREATE DATABASE IF NOT EXISTS `marctowl_itslitapi` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `marctowl_itslitapi`;

-- --------------------------------------------------------

--
-- Table structure for table `activation`
--

CREATE TABLE IF NOT EXISTS `activation` (
  `name` varchar(60) NOT NULL,
  `act_key` varchar(255) NOT NULL,
  `expires` date NOT NULL,
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Table structure for table `api_users`
--

CREATE TABLE IF NOT EXISTS `api_users` (
  `id` tinyint(2) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `channel` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `SL_access_token` varchar(255) NOT NULL,
  `SL_token_expires` datetime NOT NULL,
  `ip` varchar(15) NOT NULL,
  `last_access` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `SE_token` varchar(100) NOT NULL,
  `SL_name` varchar(255) NOT NULL,
  `twitch_id` int(18) NOT NULL,
  `twitch_icon` text NOT NULL,
  `SL_refresh_token` varchar(255) NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=2;

--
-- Dumping data for table `api_users`
--

INSERT INTO `api_users` (`id`, `username`, `channel`, `email`, `SL_access_token`, `SL_token_expires`, `ip`, `last_access`, `SE_token`, `SL_name`, `twitch_id`, `twitch_icon`, `SL_refresh_token`, `approved`) VALUES
(1, 'ItsLittany', 'itslittany', '', 'akJm4HCqVq2x0w70tgpJqemJ2cQuAO0BSiS6T4Qj', '2018-04-04 02:16:57', '86.140.156.37', '2018-04-04 00:16:57', '', 'ItsLittany', 57026834, 'https://static-cdn.jtvnw.net/jtv_user_pictures/c8089f6b1f7d75d4-profile_image-300x300.png', 'N221CpHVLstcigRP1NFhaiqvIMw16WBhIt6NDspR', 0);

-- --------------------------------------------------------

--
-- Table structure for table `auth_token`
--

CREATE TABLE IF NOT EXISTS `auth_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `token` varchar(255) NOT NULL,
  `level` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2;

--
-- Dumping data for table `auth_token`
--

INSERT INTO `auth_token` (`id`, `name`, `token`, `level`) VALUES
(1, 'discord_bot', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiZGlzY29yZF9ib3QiLCJsZXZlbCI6NH0.QzeOwIJPvCh6DHJ5MFyTaz9H1TOOawB-mcblfFqKuIs', 4);

-- --------------------------------------------------------

--
-- Table structure for table `blog_comments`
--

CREATE TABLE IF NOT EXISTS `blog_comments` (
  `id` int NOT NULL AUTO_INCREMENT, 
  `bid` int NOT NULL, 
  `response_id` int NOT NULL DEFAULT '0', 
  `display_name` varchar(45) NOT NULL, 
  `email` varchar(100) NOT NULL, 
  `comment` mediumtext, 
  `posted_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  `approved` tinyint NOT NULL DEFAULT '0', 
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

--
-- Table structure for table `blog_post`
--

CREATE TABLE IF NOT EXISTS `blog_post` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL,
  `slug` varchar(45) NOT NULL,
  `summary` varchar(100) NOT NULL,
  `content` longtext NOT NULL,
  `featured_image_url` varchar(100) DEFAULT NULL,
  `published_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `published` tinyint DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `title_UNIQUE` (`title`), 
  UNIQUE KEY `slug_UNIQUE` (`slug`)
) ENGINE=InnoDB;

--
-- Table structure for table `blog_tags`
--

CREATE TABLE IF NOT EXISTS `blog_tags` (
  `post_id` int NOT NULL, 
  `tag_name` varchar(60) NOT NULL,
  UNIQUE KEY `post_id_UNIQUE` (`post_id`)
) ENGINE=InnoDB;

--
-- Table structure for table `codes`
--

CREATE TABLE IF NOT EXISTS `codes` (
  `id` tinyint(2) NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `code` varchar(40) NOT NULL,
  `platform` enum('Playstation','XBOX','Steam','GoG','Other') NOT NULL,
  `expiration` date NOT NULL,
  `redeemed_by` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Table structure for table `lists`
--

CREATE TABLE IF NOT EXISTS `lists` (
  `lid` int(11) NOT NULL AUTO_INCREMENT,
  `list_name` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  PRIMARY KEY (`lid`)
) ENGINE=InnoDB AUTO_INCREMENT=11;

--
-- Dumping data for table `lists`
--

INSERT INTO `lists` (`lid`, `list_name`, `owner`) VALUES
(1, 'anime', 'ItsLittany'),
(2, 'games', 'ItsLittany'),
(5, 'jokes', 'synxiec'),
(6, 'quotes', 'G4G'),
(7, 'quotes', 'synxiec'),
(8, 'items', 'synxiec'),
(9, 'suggestedgames', 'itslittany'),
(10, 'joke', 'itslittany');

-- --------------------------------------------------------

--
-- Table structure for table `list_items`
--

CREATE TABLE IF NOT EXISTS `list_items` (
  `iid` int(11) NOT NULL AUTO_INCREMENT,
  `lid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `info` text NOT NULL,
  PRIMARY KEY (`iid`)
) ENGINE=InnoDB AUTO_INCREMENT=290;

--
-- Dumping data for table `list_items`
--

INSERT INTO `list_items` (`iid`, `lid`, `name`, `info`) VALUES
(2, 1, 'sousei no aquarion', 'http://otakustream.tv/anime/sousei-no-aquarion/'),
(9, 1, 'attack on titan', 'https://otakustream.tv/anime/shingeki-no-kyojin/'),
(4, 1, 'Death Note', 'https://otakustream.tv/anime/death-note/'),
(5, 1, 'Shangri-La', 'https://otakustream.tv/anime/Shangri-La/'),
(6, 1, 'seven deadly sins', 'nothing'),
(7, 1, 'full metal alchemist', 'https://otakustream.tv/anime/fullmetal-alchemist/'),
(8, 1, 'adventures of sinbad', 'nothing'),
(10, 1, 're:zero', 'https://otakustream.tv/anime/rezero-kara-hajimeru-isekai-seikatsu/'),
(11, 1, 'Takunomi', 'https://otakustream.tv/anime/takunomi/'),
(12, 1, 'Ramen Daisuki Koizumi-san', 'nothing'),
(13, 1, 'wagnaria', 'nothing'),
(14, 1, 'Heroic Age', 'nothing'),
(15, 1, 'sound of the sky', 'nothing'),
(16, 1, 'high school of the dead', 'nothing'),
(17, 1, 'Eureka seven', 'nothing'),
(21, 1, 'Konosuba', 'nothing'),
(19, 1, 'Death March kara Hajimaru Isekai Kyousoukyoku', 'nothing'),
(20, 1, 'psyco pass', 'nothing'),
(22, 1, 'stuck in another world with my smartphone', 'nothing'),
(23, 1, 'Dog Days', 'nothing'),
(24, 1, 'No Game No Life', 'nothing'),
(25, 2, 'Fortnite: Save The World', 'Playstation'),
(26, 2, 'Fortnite: Battle Royale', 'Playstation'),
(27, 2, 'Elite Dangerous', 'Playstation'),
(28, 2, 'Watch Dogs', 'Playstation'),
(29, 2, 'Watch Dogs 2', 'Playstation'),
(30, 2, 'Call of Duty WWII', 'Playstation'),
(31, 2, 'The Division', 'Playstation'),
(32, 2, 'Rainbow Six: Siege', 'Playstation'),
(33, 2, 'League of Legends', 'PC'),
(34, 2, 'Prison Architect', 'PC'),
(35, 2, 'Overwatch', 'Playstation'),
(36, 2, 'The Elder Scrolls Online', 'Playstation'),
(37, 2, 'FF XIV', 'Playstation'),
(38, 2, 'No Mans Sky', 'Playstation'),
(39, 2, 'Crash Bandicoot', 'Playstation'),
(40, 2, 'Final Fantasy IX', 'Playstation'),
(41, 2, 'Hogs of War', 'Playstation'),
(42, 2, 'Destiny', 'Playstation'),
(43, 2, 'Sword Art Online Re: Hollow Fragment', 'Playstation'),
(44, 2, 'RiME', 'Playstation'),
(45, 2, 'Sword Art Online: Lost Song', 'Playstation'),
(46, 2, 'Skyrim', 'Playstation'),
(47, 2, 'Aven Colony', 'Playstation'),
(48, 2, 'Psycho-Pass Mandatory Happiness', 'Playstation'),
(49, 2, 'Knack', 'Playstation'),
(50, 2, 'ARK: Survival Evolved', 'Playstation'),
(51, 2, 'Amnesia Collection', 'Playstation'),
(52, 2, 'Hue', 'Playstation'),
(53, 2, 'Kung Fu Panda: Showdown of Legendary Legends', 'Playstation'),
(54, 2, 'Metal Gear Solid V: The Phantom Pain', 'Playstation'),
(55, 2, 'Nebula Realms', 'Playstation'),
(56, 2, 'Worms Battlegrounds', 'Playstation'),
(57, 2, 'Grand Kingdom', 'Playstation'),
(58, 2, 'StarBlood Arena', 'Playstation'),
(59, 2, 'Deus Ex: Mankind Divided', 'Playstation'),
(60, 2, 'Darksiders II Deathinitive Edition', 'Playstation'),
(61, 2, 'GWENT: The Witcher Card Game', 'Playstation'),
(62, 2, 'Dungeon Punks', 'Playstation'),
(63, 2, 'Until Dawn: Rush of Blood', 'Playstation'),
(64, 2, 'Bound', 'Playstation'),
(65, 2, 'Sky Force Anniversary', 'Playstation'),
(66, 2, 'Hatoful Boyfriend', 'Playstation'),
(67, 2, 'Child of Light', 'Playstation'),
(68, 2, 'RIGS Mechanized Combat League', 'Playstation'),
(69, 2, 'inFAMOUS Second Son', 'Playstation'),
(70, 2, 'Downwell', 'Playstation'),
(71, 2, 'Dont Die Mr Robot', 'Playstation'),
(72, 2, 'Until Dawn', 'Playstation'),
(73, 2, 'Loadout', 'Playstation'),
(74, 2, 'Onigiri', 'Playstation'),
(75, 2, 'Indivisible Prototype', 'Playstation'),
(76, 2, 'Skyforge', 'Playstation'),
(77, 2, 'The Tomorrow Children', 'Playstation'),
(78, 2, 'Life is Strange', 'Playstation'),
(79, 2, 'Neon Chrome', 'Playstation'),
(80, 2, 'Killing Floor 2', 'Playstation'),
(81, 2, 'Minecraft Story Mode', 'Playstation'),
(82, 2, 'Paladins', 'Playstation'),
(83, 2, 'Laser Disco Defenders', 'Playstation'),
(84, 2, 'Tales from the Borderlands', 'Playstation'),
(85, 2, 'Alienation', 'Playstation'),
(86, 2, 'Lovers in a Dangerous Spacetime', 'Playstation'),
(87, 2, 'Curses N Chaos', 'Playstation'),
(88, 2, '10 Second Ninja X', 'Playstation'),
(89, 2, 'Tearaway Unfolded', 'Playstation'),
(90, 2, 'TorqueL', 'Playstation'),
(91, 2, 'Ninja Senki DX', 'Playstation'),
(92, 2, 'LittleBigPlanet 3', 'Playstation'),
(93, 2, 'Starwhal', 'Playstation'),
(94, 2, 'This War of Mine: The Little Ones', 'Playstation'),
(95, 2, 'The Swindle', 'Playstation'),
(96, 2, 'Azkend 2', 'Playstation'),
(97, 2, 'Day of the Tentacle Remastered', 'Playstation'),
(98, 2, 'Invisible, Inc. Console Edition', 'Playstation'),
(99, 2, 'Stories: The Path of Destinies', 'Playstation'),
(100, 2, 'Tiny Troopers Joint Ops', 'Playstation'),
(101, 2, 'Hyper Void', 'Playstation'),
(102, 2, 'The Deadly Tower of Monsters', 'Playstation'),
(103, 2, 'Everybodys Gone To The Rapture', 'Playstation'),
(104, 2, 'Letter Quest Remastered', 'Playstation'),
(105, 2, 'Pumped BMX', 'Playstation'),
(106, 2, 'Lords of the Fallen', 'Playstation'),
(107, 2, 'Badland: Game of the Year Edition', 'Playstation'),
(108, 2, 'Tricky Towers', 'Playstation'),
(109, 2, 'Furi', 'Playstation'),
(110, 2, 'Saints Row: Gat out of Hell', 'Playstation'),
(111, 2, 'Paragon', 'Playstation'),
(112, 2, 'Valiant Hearts: The Great War', 'Playstation'),
(113, 2, 'Grow Home', 'Playstation'),
(114, 2, 'Kings Quest', 'Playstation'),
(115, 2, 'Lara Croft and the Temple of Osiris', 'Playstation'),
(116, 2, 'Road Not Taken', 'Playstation'),
(117, 2, 'Pix The Cat', 'Playstation'),
(118, 2, 'Apontheon', 'Playstation'),
(119, 2, 'Dust: An Elysian Tail', 'Playstation'),
(120, 2, 'Table Top Racing: World Tour', 'Playstation'),
(121, 2, 'Sound Shapes', 'Playstation'),
(122, 2, 'Dead Nation: Apocalypse Edition', 'Playstation'),
(123, 2, 'inFAMOUS First Light', 'Playstation'),
(124, 2, 'Skulls of the Shogun', 'Playstation'),
(125, 2, 'Hardware: Rivals', 'Playstation'),
(126, 2, 'Entwined', 'Playstation'),
(127, 2, 'Never Alone', 'Playstation'),
(128, 2, 'Resogun', 'Playstation'),
(129, 2, 'Escape Plan', 'Playstation'),
(130, 2, 'Teslagrad', 'Playstation'),
(131, 2, 'Strider', 'Playstation'),
(132, 2, 'Zombi', 'Playstation'),
(133, 2, 'Rebel Galaxy', 'Playstation'),
(134, 2, 'Ultratron', 'Playstation'),
(135, 2, 'Injustice: Gods Amoung Us', 'Playstation'),
(136, 2, 'Gauntlet', 'Playstation'),
(137, 2, 'Dead Star', 'Playstation'),
(138, 2, 'Rocket League', 'Playstation'),
(139, 1, 'AICO', 'nothing'),
(140, 1, 'Gakuen Alice', 'nothing'),
(141, 1, 'Seiken Tsukai no World Break', 'nothing'),
(142, 1, 'The Kings Avatar', 'nothing'),
(143, 1, 'Slow Start', 'nothing'),
(145, 1, 'Miss kobayashi dragon maid', 'nothing'),
(146, 1, 'Shokugeki no Soma', 'nothing'),
(148, 1, 'Shikabane Hime Aka', 'nothing'),
(149, 1, 'Violet Evergarden', 'nothing'),
(210, 1, 'Manaria%20Friends', 'nothing'),
(211, 1, 'Toshokan%20Sensou', 'nothing'),
(212, 1, 'cory%20in%20the%20house', 'nothing'),
(213, 1, 'Revisions', 'nothing'),
(224, 6, 'Putting%20%22it%22%20off%20until%20tomorrow%20only%20delays%20the%20inevitable.%20Doing%20it%20today%20could%20solve%20the%20impossible', 'nothing'),
(219, 6, 'distractions%20are%20a%20test%20of%20your%20own%20determination', 'nothing'),
(220, 6, '%22Do%20you%20like%20it%20better%20when%20Lord%20Saladin%20oversees%20these%20matches?%20Do%20I%20look%20like%20I%20care?%20Get%20back%20in%20there!%22', 'nothing'),
(150, 1, 'Blend S', 'nothing'),
(151, 1, 'Kamisama no Inai Nichiyoubi', 'nothing'),
(152, 1, 'Kamakura Tansaku ni Go', 'nothing'),
(153, 1, 'Citrus', 'nothing'),
(154, 1, 'K-on', 'nothing'),
(156, 1, 'Yuuki Yuuna wa Yuusha de Aru Washio Sumi no Shou', 'nothing'),
(157, 1, 'Kenka Banchou Otome Girl Beats Boys', 'nothing'),
(158, 1, 'Animegataris', 'nothing'),
(159, 1, 'Toji no Miko', 'nothing'),
(160, 1, 'Gamers', 'nothing'),
(161, 1, 'Akuma no Riddle', 'nothing'),
(162, 1, 'momokuri', 'nothing'),
(163, 1, 'Flying Witch', 'nothing'),
(166, 1, 'Last Period Owarinaki Rasen no Monogatari', 'nothing'),
(165, 1, 'Hisone to Maso-tan', 'nothing'),
(167, 1, 'toshokan sensou', 'nothing'),
(168, 1, 'Isekai Maou to Shoukan Shoujo no Dorei Majutsu', 'nothing'),
(169, 1, 'high score girl', 'nothing'),
(170, 1, 'Amanchu!', 'nothing'),
(171, 1, 'Handa Kun', 'nothing'),
(172, 1, '$msg', 'nothing'),
(173, 1, 'Tonari no Kyuuketsuki-san', 'nothing'),
(174, 1, 'Joukamachi no Dandelion', 'nothing'),
(175, 1, 'Sansha Sanyou', 'nothing'),
(176, 1, 'Akanesasu Shoujo', 'nothing'),
(177, 1, 'Shiyan Pin Jiating', 'nothing'),
(178, 1, 'Otona no Bouguya san', 'nothing'),
(179, 1, 'Ken En Ken Aoki Kagayaki', 'nothing'),
(180, 1, 'Yamada-kun to 7-nin no Majo', 'nothing'),
(181, 1, 'Tensei shitara Slime Datta Ken', 'nothing'),
(182, 1, 'accel world', 'nothing'),
(186, 1, 'Uchi no Maid ga Uzasugiru', 'nothing'),
(184, 1, 'zombieland saga', 'nothing'),
(185, 1, 'Tonari no Kyuuketsuki-san', 'nothing'),
(187, 1, 'toaru-majutsu-no-index', 'nothing'),
(188, 1, 'Tensei shitara Slime Datta Ken', 'nothing'),
(189, 1, ' Marchen Madchen', 'nothing'),
(190, 1, 'Valkyrie drive', 'nothing'),
(191, 1, 'Beelzebub-jou no Okinimesu mama', 'nothing'),
(196, 1, 'world trigger', 'nothing'),
(197, 1, 'The Silver Guardian', 'nothing'),
(198, 1, 'Sansha Sanyou', 'nothing'),
(199, 1, 'Gamers', 'nothing'),
(200, 1, 'new game', 'nothing'),
(201, 1, 'Knights & Magic', 'nothing'),
(202, 1, 'Comic Girls', 'nothing'),
(203, 1, 'yuru yuri', 'nothing'),
(204, 1, 'Gi(a)rlish Number', 'nothing'),
(205, 1, 'Flying Witch', 'nothing'),
(206, 1, 'Urara Meirochou', 'nothing'),
(207, 1, 'Assassination Classroom', 'nothing'),
(208, 1, 'Boku dake ga Inai Machi', 'nothing'),
(209, 7, 'HEAL YOU RECKLESS MISCREANT!', 'nothing'),
(221, 6, '%22WHAT%20DO%20YOU%20MEAN%20YOU%20CAN%27T%20CONCENTRATE%20WHEN%20I%27M%20YELLING?!%20RELAX!!%22', 'nothing'),
(222, 6, '%22Is%20that%20a%20rhetorical%20question!%22', 'nothing'),
(223, 6, 'Kayowin%3Eperm%20council%3Etemp%20council%3Eofficer%3Emember%20-%20shez...%20Rest%20of%20Council..%20Shez%20stop%20making%20up%20your%20own%20rules.', 'nothing'),
(225, 6, '%22I%20need%20a%20drink!%20Someone%20pass%20me%20a%20drink%22', 'nothing'),
(226, 6, 'Thats%20Nice!!!', 'nothing'),
(227, 6, 'I%20now%20pronounce%20you%20%3C@153689235927465985%3E%20%20First%20Kumar%20of%20the%20Pigeon%20Kingdom.%20-%20%3C@163201826441789441%3E', 'nothing'),
(228, 6, 'Scrub, behave.....', 'nothing'),
(229, 6, 'Alert!!! SCRUB just requested a quote....', 'nothing'),
(230, 6, 'Sig_shezza is **Not** the clan mascot', 'nothing'),
(231, 6, 'youre a wizard sig!', 'nothing'),
(232, 6, 'Bad move lol never trust anyone with killer or auzzie in there name especially both names put together', 'nothing'),
(233, 6, 'Queen Kayowin is the oldest in the land - shezza', 'nothing'),
(234, 6, 'You sir are a legend, no i dont mean a leg-end i mean a __\"legend\"__', 'nothing'),
(235, 6, 'no one can help you sig..... you are dooomed doooooomed i tell theeeee! - Redous', 'nothing'),
(236, 1, 'Pumpkin Scissors', 'nothing'),
(237, 6, 'I believe it will - <@163201826441789441> 2019', 'nothing'),
(238, 1, 'Ichiban Ushiro no Daimaou', 'nothing'),
(239, 1, 'Noragami', 'nothing'),
(240, 1, 'shield hero', 'nothing'),
(243, 9, 'test', 'nothing'),
(242, 1, 'Toaru Majutsu no Index', 'nothing'),
(244, 9, 'the division 2', 'nothing'),
(245, 9, 'uno', 'nothing'),
(246, 9, 'sky factory 4', 'nothing'),
(247, 9, 'Halo Master Chief Collection', 'nothing'),
(248, 9, 'Borderland 2   the pre sequel', 'nothing'),
(249, 9, 'forager', 'nothing'),
(250, 9, 'enter the gungeon', 'nothing'),
(251, 9, 'sevtech ages', 'nothing'),
(252, 1, 'Assassination Classroom', 'nothing'),
(253, 9, 'hitman 2', 'nothing'),
(254, 9, 'overwatch', 'nothing'),
(255, 9, 'SCP@SL', 'nothing'),
(256, 9, 'spelunky', 'nothing'),
(257, 9, 'Clone Drone in the danger zone', 'nothing'),
(258, 9, 'town of salem', 'nothing'),
(259, 9, 'Stick Fight: The game', 'nothing'),
(260, 9, 'UNO', 'nothing'),
(261, 9, 'spore', 'nothing'),
(262, 9, 'Battlefront 2', 'nothing'),
(263, 1, 'Seiken Tsukai no World Break', 'nothing'),
(264, 9, 'portal 2', 'nothing'),
(265, 9, 'portal', 'nothing'),
(266, 9, 'keep talking and nobody explodes (play with clare for ultimate enjoyment)', 'nothing'),
(267, 9, 'rime', 'nothing'),
(268, 1, 'Kenja no Mago', 'nothing'),
(269, 1, 'Rinne no Lagrange', 'nothing'),
(270, 1, 'yuuki yuuna wa yuusha de aru washio sumi no shou', 'nothing'),
(271, 1, 'azumanga daioh', 'nothing'),
(272, 1, 'black cat', 'nothing'),
(273, 1, 'Quanzhi Fashi', 'nothing'),
(274, 1, 'Another', 'nothing'),
(275, 1, 'Arifureta Shokugyou de Sekai Saikyou', 'nothing'),
(276, 1, 'iseaki cheat magician', 'nothing'),
(277, 1, 'divine gate', 'nothing'),
(278, 1, 'High Score Girl', 'nothing'),
(279, 1, 'cory in the house', 'nothing'),
(280, 1, 'shinsekai yori', 'nothing'),
(281, 1, 'yugioh gx', 'nothing'),
(282, 1, 'kyokou suiri', 'nothing'),
(283, 1, 'Itai no wa Iya nano de Bougyoryoku ni Kyokufuri Shitai to Omoimasu.', 'nothing'),
(284, 1, 'Kami no Tou', 'nothing'),
(285, 7, '\"She just gave you the Prima Guide to getting into her pants.\"', 'nothing'),
(286, 1, 'Kami-tachi ni Hirowareta Otoko', 'nothing'),
(287, 1, 'Iwa Kakeru!: Sport Climbing Girls', 'nothing'),
(288, 1, '100-man no Inochi no Ue ni Ore wa Tatteiru', 'nothing');

-- --------------------------------------------------------

--
-- Table structure for table `pkmn_events`
--

CREATE TABLE IF NOT EXISTS `pkmn_events` (
  `guid` varchar(60) NOT NULL,
  `address_guid` varchar(60) NOT NULL,
  `store_name` varchar(200) NOT NULL,
  `address` varchar(200) NOT NULL,
  `city` varchar(100) NOT NULL,
  `postcode` varchar(10) NOT NULL,
  `email` varchar(200) NOT NULL,
  `website` varchar(255) NOT NULL,
  `event_name` varchar(255) NOT NULL,
  `event_datetime` datetime NOT NULL,
  `format` varchar(10) NOT NULL,
  `pkmn_url` varchar(100) NOT NULL,
  `details` text NOT NULL,
  `event_website` varchar(100) NOT NULL,
  `third_party_site` varchar(255) NOT NULL,
  `admission` int(5) NOT NULL,
  `event_type` varchar(20) NOT NULL,
  `date_seen` datetime NOT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE IF NOT EXISTS `questions` (
  `qid` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(25) NOT NULL,
  `user` varchar(25) NOT NULL,
  `question` text NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `flag` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`qid`),
  KEY `channel` (`channel`)
) ENGINE=MyISAM;

--
-- Table structure for table `redemption`
--

CREATE TABLE IF NOT EXISTS `redemption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(25) NOT NULL,
  `user` varchar(60) NOT NULL,
  `reward` int(11) NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  `given` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `rewards`
--

CREATE TABLE IF NOT EXISTS `rewards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(25) NOT NULL,
  `name` varchar(60) NOT NULL,
  `description` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `channel` (`channel`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `ticket`
--

CREATE TABLE IF NOT EXISTS `ticket` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(155) NOT NULL,
  `email` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `submitted_at` datetime NOT NULL,
  `viewed` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `twitch_logs`
--

CREATE TABLE IF NOT EXISTS `twitch_logs` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `channel` varchar(60) NOT NULL,
  `user` varchar(60) NOT NULL,
  `requester` varchar(60) NOT NULL,
  `reason` text NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `type` enum('ban','timeout') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8;

--
-- Dumping data for table `twitch_logs`
--

INSERT INTO `twitch_logs` (`id`, `channel`, `user`, `requester`, `reason`, `date`, `type`) VALUES
(1, 'synxiec', 'thespeakerbottest', 'ItsLittany', '$querystring', '2018-11-27 23:21:07', 'ban'),
(2, 'synxiec', 'thespeakerbottest', 'ItsLittany', 'thespeakerbottest being an asshat', '2018-11-27 23:22:14', 'ban'),
(3, 'synxiec', 'thespeakerbottest', 'ItsLittany', 'being an asshat', '2018-11-27 23:24:49', 'ban'),
(4, 'itslittany', 'thespeakerbottest', 'thespeakerbottest', 'a twat', '2018-11-28 00:13:40', 'ban'),
(5, 'synxiec', 'skinnyseahorse', 'skinnyseahorse', 'today, Satan.', '2018-12-27 00:58:01', 'ban'),
(6, 'synxiec', 'VADIKUS007', 'synxiec', 'no-no words', '2018-12-27 05:20:27', 'ban'),
(7, 'synxiec', 'mosheddy', 'synxiec', 'harassment', '2018-12-28 00:47:11', 'ban');
COMMIT;

GRANT ALL PRIVILEGES
ON marctowl_itslitapi.*
TO 'marctowl_api'@'%'
WITH GRANT OPTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;