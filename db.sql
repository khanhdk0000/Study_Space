-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: test
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedules` (
  `id` int NOT NULL,
  `repetition` int NOT NULL DEFAULT '0',
  `period` int NOT NULL DEFAULT '1',
  `start_date` varchar(45) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_sched_idx` (`user_id`),
  CONSTRAINT `user_sched` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` VALUES (1,0,1,'01/01/2021','19:00:00','21:00:00',1),(2,3,2,'05/12/2021','17:00:00','19:00:00',1),(3,10,7,'04/30/2021','08:00:00','11:30:00',2),(4,10,7,'04/30/2021','14:30:00','16:00:00',2),(5,0,1,'04/30/2021','15:00:00','16:00:00',3),(6,2,3,'06/15/2021','09:00:00','12:00:00',4),(7,3,7,'05/20/2021','02:00:00','04:00:00',5),(8,5,5,'05/12/2021','16:30:00','17:00:00',6),(9,20,7,'03/15/2021','16:30:00','17:00:00',9),(10,0,7,'01/23/2022','19:00:00','21:00:00',10);
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensors`
--

DROP TABLE IF EXISTS `sensors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensors` (
  `id` int NOT NULL,
  `name` varchar(45) NOT NULL,
  `unit` varchar(45) NOT NULL,
  `type` varchar(45) NOT NULL,
  `timestamp` datetime NOT NULL,
  `sess_id` int NOT NULL,
  `sched_id` int NOT NULL,
  `data` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sess_sens_idx` (`sess_id`,`sched_id`),
  CONSTRAINT `sess_sens` FOREIGN KEY (`sess_id`, `sched_id`) REFERENCES `sessions` (`id`, `sched_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensors`
--

LOCK TABLES `sensors` WRITE;
/*!40000 ALTER TABLE `sensors` DISABLE KEYS */;
INSERT INTO `sensors` VALUES (1,'LIGHT1','L1','L','2021-01-01 17:00:56',1,1,'503.6'),(2,'LIGHT1','L1','L','2021-01-01 17:30:33',1,1,'506.8');
/*!40000 ALTER TABLE `sensors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` int NOT NULL,
  `sched_id` int NOT NULL,
  `date` varchar(45) DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status` varchar(45) NOT NULL,
  `title` varchar(45) NOT NULL DEFAULT 'New session',
  PRIMARY KEY (`id`,`sched_id`),
  KEY `sched_sess_idx` (`sched_id`),
  CONSTRAINT `sched_sess` FOREIGN KEY (`sched_id`) REFERENCES `schedules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES (1,1,'01/01/2021','19:00:00','20:00:00','0.93','Math'),(1,2,'05/12/2021','17:00:00','19:00:00',' 0.69','Math'),(1,3,'04/30/2021','08:00:00','10:00:00','1.0','DSA'),(1,5,'04/30/2021','15:00:00','15:30:00','0.8','Art'),(2,1,'01/01/2021','20:00:00','21:00:00','0.52','English'),(2,3,'04/30/2021','10:30:00','11:30:00','0.65','Piano'),(2,5,'04/30/2021','15:35:00','16:00:00','0','New session');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(45) NOT NULL,
  `fname` varchar(45) DEFAULT NULL,
  `lname` varchar(45) DEFAULT NULL,
  `dob` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'user','us','er','01/01/2001'),(2,'nguyenbao','Bao','Nguyen','01/23/2000'),(3,'verided','Verissimus','Dederick','08/15/1970'),(4,'slygg','Sly','Georgijs','12/31/2005'),(5,'AdiaPan2','Panagiota','Adi','09/28/1996'),(6,'lubov444','Lubov','Devaraja','04/04/1994'),(7,'paulaTT','Tawnya','Paula','10/14/1999'),(8,'naz1232','Nazia','Mohan','19/02/1974'),(9,'kasukasu','Nakasu','Kasumi','01/23/2005'),(10,'mckl82','Loretta','McKenzie','04/06/1982');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-13  8:23:06
