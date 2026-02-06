-- MySQL dump 10.13  Distrib 8.0.31, for macos12 (arm64)
--
-- Host: 127.0.0.1    Database: app_pln
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audits`
--

DROP TABLE IF EXISTS `audits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audits` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `user_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `event` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `auditable_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `auditable_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `old_values` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `new_values` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `url` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `ip_address` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `user_agent` varchar(1023) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tags` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `audits_user_id_user_type_index` (`user_id`,`user_type`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audits`
--

LOCK TABLES `audits` WRITE;
/*!40000 ALTER TABLE `audits` DISABLE KEYS */;
INSERT INTO `audits` VALUES (1,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kby5c4rjckcaycwh3eccam09','App\\Models\\User','[]','{\"name\":\"awaar\",\"email\":\"hanafi@gmail.com\",\"password\":\"$2y$12$63XY4mGCr0p9P7nk6skVE.Sfaqxsw9E5Zax7.w2twrXyiIU9zr3OG\",\"force_password_change\":false,\"id\":\"01kby5c4rjckcaycwh3eccam09\",\"user_slug\":\"user-PR1Qr75atd5P\"}','http://127.0.0.1:8000/admin/users','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-12-07 21:01:30','2025-12-07 21:01:30',NULL),(2,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','updated','01kby5c4rjckcaycwh3eccam09','App\\Models\\User','{\"name\":\"awaar\"}','{\"name\":\"awaarqqq\"}','http://127.0.0.1:8000/admin/users/01kby5c4rjckcaycwh3eccam09','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2025-12-07 21:02:58','2025-12-07 21:02:58',NULL),(3,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','updated','01kbxxrnf3g087v0rrqeztn3q9','App\\Models\\User','{\"unit_id\":null}','{\"unit_id\":1}','http://127.0.0.1:8000/admin/users/01kbxxrnf3g087v0rrqeztn3q9','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2025-12-14 18:18:38','2025-12-14 18:18:38',NULL),(4,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','updated','01kbxxrmfnq2m19fmenn91q4qt','App\\Models\\User','{\"unit_id\":null}','{\"unit_id\":2}','http://127.0.0.1:8000/admin/users/01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2025-12-14 18:18:57','2025-12-14 18:18:57',NULL),(5,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kcfwxam07aw8fh5v5zq5sz6e','App\\Models\\User','[]','{\"name\":\"Testing\",\"email\":\"user@gmail.com\",\"password\":\"$2y$12$Va4ATjQav0jeQNkxyY8fyOaG\\/l0\\/upTqXlCE6\\/0lEq\\/FweeAhC6Ua\",\"unit_id\":1,\"force_password_change\":false,\"id\":\"01kcfwxam07aw8fh5v5zq5sz6e\",\"user_slug\":\"user-qicplSNkzsan\"}','http://127.0.0.1:8000/admin/users','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2025-12-14 18:19:56','2025-12-14 18:19:56',NULL),(6,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','updated','01kcfwxam07aw8fh5v5zq5sz6e','App\\Models\\User','{\"unit_id\":1}','{\"unit_id\":2}','http://127.0.0.1:8000/admin/users/01kcfwxam07aw8fh5v5zq5sz6e','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2025-12-21 22:19:57','2025-12-21 22:19:57',NULL),(7,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','updated','01kcfwxam07aw8fh5v5zq5sz6e','App\\Models\\User','{\"unit_id\":2}','{\"unit_id\":1}','http://127.0.0.1:8000/admin/users/01kcfwxam07aw8fh5v5zq5sz6e','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2025-12-23 09:04:24','2025-12-23 09:04:24',NULL),(8,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','deleted','01kcfwxam07aw8fh5v5zq5sz6e','App\\Models\\User','{\"id\":\"01kcfwxam07aw8fh5v5zq5sz6e\",\"name\":\"Testing\",\"user_slug\":\"user-qicplSNkzsan\",\"email\":\"user@gmail.com\",\"unit_id\":1,\"email_verified_at\":null,\"password\":\"$2y$12$Va4ATjQav0jeQNkxyY8fyOaG\\/l0\\/upTqXlCE6\\/0lEq\\/FweeAhC6Ua\",\"two_factor_secret\":null,\"two_factor_recovery_codes\":null,\"location\":null,\"force_password_change\":0,\"disable_account\":0,\"profile_image_type\":\"avatar\",\"locale\":\"en\",\"last_login_at\":null,\"last_login_ip\":null,\"password_changed_at\":null,\"password_expiry_at\":null,\"remember_token\":null}','[]','http://127.0.0.1:8000/admin/users/01kcfwxam07aw8fh5v5zq5sz6e','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2026-01-06 05:25:42','2026-01-06 05:25:42',NULL),(9,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','deleted','01kbxxrnf3g087v0rrqeztn3q9','App\\Models\\User','{\"id\":\"01kbxxrnf3g087v0rrqeztn3q9\",\"name\":\"Regular User\",\"user_slug\":\"user-XiJgIQy0uIvy\",\"email\":\"user@example.com\",\"unit_id\":1,\"email_verified_at\":\"2025-12-08 02:48:32\",\"password\":\"$2y$12$Ys9EBIvFx\\/tBEw\\/jz.YCcegA8w4Sc4eI3j.5Rl\\/lwFTZkyhWdHkLm\",\"two_factor_secret\":null,\"two_factor_recovery_codes\":null,\"location\":null,\"force_password_change\":0,\"disable_account\":0,\"profile_image_type\":\"avatar\",\"locale\":\"en\",\"last_login_at\":null,\"last_login_ip\":null,\"password_changed_at\":null,\"password_expiry_at\":null,\"remember_token\":null}','[]','http://127.0.0.1:8000/admin/users/01kbxxrnf3g087v0rrqeztn3q9','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2026-01-06 05:25:52','2026-01-06 05:25:52',NULL),(10,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','updated','01kbxxrmfnq2m19fmenn91q4qt','App\\Models\\User','{\"name\":\"Ota\",\"email\":\"ota@example.com\"}','{\"name\":\"Super Admin\",\"email\":\"super@admin.com\"}','http://127.0.0.1:8000/admin/users/01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2026-01-13 05:16:56','2026-01-13 05:16:56',NULL),(11,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','updated','01kbxxrmfnq2m19fmenn91q4qt','App\\Models\\User','{\"unit_id\":2}','{\"unit_id\":null}','http://127.0.0.1:8000/admin/users/01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2026-01-13 05:35:39','2026-01-13 05:35:39',NULL),(12,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01ketxs5xa2h42hchznxzv5302','App\\Models\\User','[]','{\"name\":\"Perencanaan Kalimantan\",\"email\":\"perencanaan@example.com\",\"password\":\"$2y$12$ZjsebT9KASgXY1DAIv7cbuUyZ20ZAXQtBt01\\/MIlImyYuucl.i5vy\",\"unit_id\":1,\"force_password_change\":false,\"id\":\"01ketxs5xa2h42hchznxzv5302\",\"user_slug\":\"user-gaYy3hXdPYIL\"}','http://127.0.0.1:8000/admin/users','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2026-01-13 05:38:11','2026-01-13 05:38:11',NULL),(13,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','deleted','01ketxs5xa2h42hchznxzv5302','App\\Models\\User','{\"id\":\"01ketxs5xa2h42hchznxzv5302\",\"name\":\"Perencanaan Kalimantan\",\"user_slug\":\"user-gaYy3hXdPYIL\",\"email\":\"perencanaan@example.com\",\"unit_id\":1,\"email_verified_at\":null,\"password\":\"$2y$12$ZjsebT9KASgXY1DAIv7cbuUyZ20ZAXQtBt01\\/MIlImyYuucl.i5vy\",\"two_factor_secret\":null,\"two_factor_recovery_codes\":null,\"location\":null,\"force_password_change\":0,\"disable_account\":0,\"profile_image_type\":\"avatar\",\"locale\":\"en\",\"last_login_at\":null,\"last_login_ip\":null,\"password_changed_at\":null,\"password_expiry_at\":null,\"remember_token\":null}','[]','https://pln.hanafiah.my.id/admin/users/01ketxs5xa2h42hchznxzv5302','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',NULL,'2026-01-14 17:49:45','2026-01-14 17:49:45',NULL),(14,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezhvcqx766hwnxq837g5h8g','App\\Models\\User','[]','{\"name\":\"REN-UP2BKTKU\",\"email\":\"ren.up2bktku@test.com\",\"password\":\"$2y$12$bYKUAOUgP\\/5sMVD2OIoWmu9NkOIdDf.yfV3AhRlKotOi4DjYjPpJa\",\"unit_id\":8,\"force_password_change\":false,\"id\":\"01kezhvcqx766hwnxq837g5h8g\",\"user_slug\":\"user-nphf2IRzcTlf\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 08:45:53','2026-01-15 08:45:53',NULL),(15,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezhxspjyjzx07f7brb4kved','App\\Models\\User','[]','{\"name\":\"DAN-UP2BKTKU\",\"email\":\"dan.up2bktku@test.com\",\"password\":\"$2y$12$t0cw40TDJ\\/6GOdv9QmYwdu9DnvG5c1A3XwhidfLpS0stP0Sl6WMye\",\"unit_id\":8,\"force_password_change\":false,\"id\":\"01kezhxspjyjzx07f7brb4kved\",\"user_slug\":\"user-WpL0EsMDoAuE\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 08:47:12','2026-01-15 08:47:12',NULL),(16,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezhz9k93epjv47dw5fmr5gm','App\\Models\\User','[]','{\"name\":\"KON-UP2BKTKU\",\"email\":\"kon.up2bktku@test.com\",\"password\":\"$2y$12$SdYW06qYCzMFc\\/XNbP36Xeu60qFljlso8rFhMMIvScUUpNMGV19dO\",\"unit_id\":8,\"force_password_change\":false,\"id\":\"01kezhz9k93epjv47dw5fmr5gm\",\"user_slug\":\"user-ushUYwmrG1I0\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 08:48:01','2026-01-15 08:48:01',NULL),(17,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezj0a8q6nyqqa8xyc8vj7fp','App\\Models\\User','[]','{\"name\":\"KEU-UP2BKTKU\",\"email\":\"keu.up2bktku@test.com\",\"password\":\"$2y$12$NSBVwGe0r1OHztQuN\\/g93.i\\/FliCyxHGkU86IzHNk0s0Pn7EvKB.O\",\"unit_id\":8,\"force_password_change\":false,\"id\":\"01kezj0a8q6nyqqa8xyc8vj7fp\",\"user_slug\":\"user-AaBNM3YF8OUJ\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 08:48:34','2026-01-15 08:48:34',NULL),(18,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezj74wpsw485qe09tdrcrzc','App\\Models\\User','[]','{\"name\":\"REN-UP2BKB\",\"email\":\"ren.up2bkb@test.com\",\"password\":\"$2y$12$GJhZWGwpbkfIRntOHgRjSO0TUqRcVip9T7A93pRsrrFmRILP7quGa\",\"unit_id\":7,\"force_password_change\":false,\"id\":\"01kezj74wpsw485qe09tdrcrzc\",\"user_slug\":\"user-4eban9Ytn7jU\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 08:52:18','2026-01-15 08:52:18',NULL),(19,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezj89bg6mppyvhscjdwqxmc','App\\Models\\User','[]','{\"name\":\"DAN-UP2BKB\",\"email\":\"dan.up2bkb@test.com\",\"password\":\"$2y$12$kmDL2EVh0dp\\/Heg4YUosKuJnw9vv4b\\/U7Hp3n1etrybChzam9k2.2\",\"unit_id\":7,\"force_password_change\":false,\"id\":\"01kezj89bg6mppyvhscjdwqxmc\",\"user_slug\":\"user-qd1JDejFOO7s\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 08:52:55','2026-01-15 08:52:55',NULL),(20,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezj96ztmfb7tyd22kqhhxh8','App\\Models\\User','[]','{\"name\":\"KEU-UP2BKB\",\"email\":\"keu.up2bkb@test.com\",\"password\":\"$2y$12$0jFDTfI\\/IIiqQSZbJzN65OjoaOs2n3UuoepDBRRECRMeUR0hIGDg.\",\"unit_id\":7,\"force_password_change\":false,\"id\":\"01kezj96ztmfb7tyd22kqhhxh8\",\"user_slug\":\"user-NIBi1E8Q3dbf\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 08:53:26','2026-01-15 08:53:26',NULL),(21,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezja5y9v6qkghstzbqpwv6z','App\\Models\\User','[]','{\"name\":\"KON-UP2BKB\",\"email\":\"kon.up2bkb@test.com\",\"password\":\"$2y$12$V3fFDkQuSEJt2ovfGXb9CegwfhcMKcBpA5LPAiA432olbDDqc916q\",\"unit_id\":7,\"force_password_change\":false,\"id\":\"01kezja5y9v6qkghstzbqpwv6z\",\"user_slug\":\"user-VqUKh1upb5Yh\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 08:53:57','2026-01-15 08:53:57',NULL),(22,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezjsesbastjpkm2m8tjcaxt','App\\Models\\User','[]','{\"name\":\"REN-UP2BKSKT\",\"email\":\"ren.up2bkskt@test.com\",\"password\":\"$2y$12$A3NuXzvJWA6BBODLkPIwQej1KkOrYaUibfOgNDis8fNMj5iWMbdDO\",\"unit_id\":5,\"force_password_change\":false,\"id\":\"01kezjsesbastjpkm2m8tjcaxt\",\"user_slug\":\"user-OCZwumORpCfG\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:02:18','2026-01-15 09:02:18',NULL),(23,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezjtjvm61z3fcxbckp602te','App\\Models\\User','[]','{\"name\":\"DAN-UP2BKSKT\",\"email\":\"dan.up2bkskt@test.com\",\"password\":\"$2y$12$LlgdzVHu15q8Ig7qpzoJ0uZdBzhKPKcLh3zf\\/rad9d\\/.au\\/fLWkoW\",\"unit_id\":5,\"force_password_change\":false,\"id\":\"01kezjtjvm61z3fcxbckp602te\",\"user_slug\":\"user-mTAtFqfqmxVy\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:02:55','2026-01-15 09:02:55',NULL),(24,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezjvt84577398xsybfnnzkf','App\\Models\\User','[]','{\"name\":\"KON-UP2BKSKT\",\"email\":\"kon.up2bkskt@test.com\",\"password\":\"$2y$12$ajRQF.y1C971NGSzn4FB.urKVde05UiCyyYjBZydiU9O82\\/Q7uOam\",\"unit_id\":5,\"force_password_change\":false,\"id\":\"01kezjvt84577398xsybfnnzkf\",\"user_slug\":\"user-bQSYgObOf8cr\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:03:35','2026-01-15 09:03:35',NULL),(25,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezjwsbq3djm1vankbj7vqh7','App\\Models\\User','[]','{\"name\":\"KEU-UP2BKSKT\",\"email\":\"keu.up2bkskt@test.com\",\"password\":\"$2y$12$\\/TfPkCqveEBX9wBVcFQLAeb27Iq0z7myoehf9oivE9hz.zJ3Z1Dqm\",\"unit_id\":5,\"force_password_change\":false,\"id\":\"01kezjwsbq3djm1vankbj7vqh7\",\"user_slug\":\"user-TjjGwRCovc1p\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:04:07','2026-01-15 09:04:07',NULL),(26,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezjxvba0z2dr7vnttbwnr4f','App\\Models\\User','[]','{\"name\":\"REN-UPTBJB\",\"email\":\"ren.uptbjb@test.com\",\"password\":\"$2y$12$74MGSN.nevyHcdzcbCk\\/ouQCcY\\/2C\\/KLorgNa0KWKE3ekU3NSBN2a\",\"unit_id\":3,\"force_password_change\":false,\"id\":\"01kezjxvba0z2dr7vnttbwnr4f\",\"user_slug\":\"user-oUsRba1gnZKQ\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:04:42','2026-01-15 09:04:42',NULL),(27,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezjysw4ghp9nawfme1605c5','App\\Models\\User','[]','{\"name\":\"DAN-UPTBJB\",\"email\":\"dan.uptbjb@test.com\",\"password\":\"$2y$12$nKTYqr0wOA5aVtwNTiVyMuC83STP\\/xxfitYqsBiO6FqC.W7Z23GR.\",\"unit_id\":3,\"force_password_change\":false,\"id\":\"01kezjysw4ghp9nawfme1605c5\",\"user_slug\":\"user-6U8sIupRPqCp\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:05:13','2026-01-15 09:05:13',NULL),(28,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezjzrvegnszp5qsyhy78v6q','App\\Models\\User','[]','{\"name\":\"KON-UPTBJB\",\"email\":\"kon.uptbjb@test.com\",\"password\":\"$2y$12$qj7UJ0NkUHSQKbQPfP7ua.EChpCwupMNoEYpE.Of0sme406HK.O5q\",\"unit_id\":3,\"force_password_change\":false,\"id\":\"01kezjzrvegnszp5qsyhy78v6q\",\"user_slug\":\"user-HbFLagjpkas8\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:05:45','2026-01-15 09:05:45',NULL),(29,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezk0n2d15y17gjfmxct5twk','App\\Models\\User','[]','{\"name\":\"KEU-UPTBJB\",\"email\":\"keu.uptbjb@test.com\",\"password\":\"$2y$12$EMe9jtjgG1BGEAQtb3Zl7ej8Jvkff3acQgrosxBysmpJUifMgoFJm\",\"unit_id\":3,\"force_password_change\":false,\"id\":\"01kezk0n2d15y17gjfmxct5twk\",\"user_slug\":\"user-kf24S8oBBWJZ\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:06:14','2026-01-15 09:06:14',NULL),(30,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezk1v1tvgr4cm49c2x3e1t9','App\\Models\\User','[]','{\"name\":\"REN-UPTBPP\",\"email\":\"ren.uptbpp@test.com\",\"password\":\"$2y$12$khKm.Te7gvCtjeTEBtmmSOQF\\/\\/k8IjfDoh7VfMIjizOcTiB2ZPbbO\",\"unit_id\":4,\"force_password_change\":false,\"id\":\"01kezk1v1tvgr4cm49c2x3e1t9\",\"user_slug\":\"user-So7VMBM22uqz\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:06:53','2026-01-15 09:06:53',NULL),(31,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezk2x42qs2ggfw7t16nvmmb','App\\Models\\User','[]','{\"name\":\"DAN-UPTBPP\",\"email\":\"dan.uptbpp@test.com\",\"password\":\"$2y$12$FN0Oya7O367bB5yF1PIohO9F6XPMEW3mKpjLH9jiXOW4G7eUiySs.\",\"unit_id\":4,\"force_password_change\":false,\"id\":\"01kezk2x42qs2ggfw7t16nvmmb\",\"user_slug\":\"user-0e172xtYM9pI\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:07:28','2026-01-15 09:07:28',NULL),(32,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezk3xxekfxdw5h2yy1s1wab','App\\Models\\User','[]','{\"name\":\"KON-UPTBPP\",\"email\":\"kon.uptbpp@test.com\",\"password\":\"$2y$12$3fK\\/GCCgICCJQcj0gxdQy.Bly2RlgNO7Sfjb2dSQyw6Mg2DquYrPi\",\"unit_id\":4,\"force_password_change\":false,\"id\":\"01kezk3xxekfxdw5h2yy1s1wab\",\"user_slug\":\"user-0BwEXhJcK4C2\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:08:01','2026-01-15 09:08:01',NULL),(33,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezk4xf7ht2jt48ca2yece7j','App\\Models\\User','[]','{\"name\":\"KEU-UPTBPP\",\"email\":\"keu.uptbpp@test.com\",\"password\":\"$2y$12$XQmErQRM0X1KuGpRwarpp.J2pRiCr5UEqxV4YpLukP6DmFIgayewy\",\"unit_id\":4,\"force_password_change\":false,\"id\":\"01kezk4xf7ht2jt48ca2yece7j\",\"user_slug\":\"user-GJ4v1s9fbxf9\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:08:33','2026-01-15 09:08:33',NULL),(34,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezk6807bn877xs70t5rp77x','App\\Models\\User','[]','{\"name\":\"REN-UPTPTK\",\"email\":\"ren.uptptk@test.com\",\"password\":\"$2y$12$Gbbji4SMan4Ai6eA247Z8.SkMO9hNvZVr0NYiQcUy2\\/G5vpgzelL6\",\"unit_id\":2,\"force_password_change\":false,\"id\":\"01kezk6807bn877xs70t5rp77x\",\"user_slug\":\"user-ZwYJvuMf1fxT\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:09:17','2026-01-15 09:09:17',NULL),(35,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezk7ccmxygxd29gjjv4y0q4','App\\Models\\User','[]','{\"name\":\"DAN-UPTPTK\",\"email\":\"dan.uptptk@test.com\",\"password\":\"$2y$12$SFdbJkxZg\\/7Vs2oSZ81y1.OAeyWCGsvIkTCf5IaReUSMXgudqIH7i\",\"unit_id\":2,\"force_password_change\":false,\"id\":\"01kezk7ccmxygxd29gjjv4y0q4\",\"user_slug\":\"user-34XcN3BtvB6o\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:09:54','2026-01-15 09:09:54',NULL),(36,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezk8c53zcd35qz5nd1g8ttp','App\\Models\\User','[]','{\"name\":\"KON-UPTPTK\",\"email\":\"kon.uptptk@test.com\",\"password\":\"$2y$12$6oL30OG9TpDTUNvOYDaCr.rQMkW5RvqcAPeV2e7PrICrEEerAcPmu\",\"unit_id\":2,\"force_password_change\":false,\"id\":\"01kezk8c53zcd35qz5nd1g8ttp\",\"user_slug\":\"user-iEXnhU8Ooe0c\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:10:27','2026-01-15 09:10:27',NULL),(37,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezk9kb9b0fdx79tdkkdg0r6','App\\Models\\User','[]','{\"name\":\"KEU-UPTPTK\",\"email\":\"keu.uptptk@test.com\",\"password\":\"$2y$12$a8as4cy58nMyAjYq\\/Y\\/1i.AR.oteVFvdfqdgTzWXIq1\\/gUZXu4Pt.\",\"unit_id\":2,\"force_password_change\":false,\"id\":\"01kezk9kb9b0fdx79tdkkdg0r6\",\"user_slug\":\"user-Tijvy9k7XxkQ\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:11:07','2026-01-15 09:11:07',NULL),(38,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezkanzs4ajbyft0d4n0sv04','App\\Models\\User','[]','{\"name\":\"REN-UPTPKY\",\"email\":\"ren.uptpky@test.com\",\"password\":\"$2y$12$LXzsnAAi4TAbkAF38dNzXeHyZnM2m1lxvongHA.esy75YRHMiUcay\",\"unit_id\":6,\"force_password_change\":false,\"id\":\"01kezkanzs4ajbyft0d4n0sv04\",\"user_slug\":\"user-Uw4kJKK4OTju\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:11:42','2026-01-15 09:11:42',NULL),(39,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezkbq1p90av2e3a49ddegfv','App\\Models\\User','[]','{\"name\":\"DAN-UPTPKY\",\"email\":\"dan.uptpky@test.com\",\"password\":\"$2y$12$0Qt\\/FI3ExYK\\/4qB5g86GNO7A5.1uoMDmR\\/gZWyMansJgHI2.lSSXi\",\"unit_id\":6,\"force_password_change\":false,\"id\":\"01kezkbq1p90av2e3a49ddegfv\",\"user_slug\":\"user-u5KYkPT06dHJ\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:12:16','2026-01-15 09:12:16',NULL),(40,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezkcmfx5nknbt72jgkn2gsr','App\\Models\\User','[]','{\"name\":\"KON-UPTPKY\",\"email\":\"kon.uptpky@test.com\",\"password\":\"$2y$12$wLE\\/bLotxPIvrKr0KdMLzeqFlPEUiGsZ7eDhsK7.M.mSNQ3DTLra.\",\"unit_id\":6,\"force_password_change\":false,\"id\":\"01kezkcmfx5nknbt72jgkn2gsr\",\"user_slug\":\"user-5a7hWmQE0maV\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:12:46','2026-01-15 09:12:46',NULL),(41,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezkdhjhqpmmh1e2vazxpq3d','App\\Models\\User','[]','{\"name\":\"KEU-UPTPKY\",\"email\":\"keu.uptpky@test.com\",\"password\":\"$2y$12$gedShBDGR1D3hAdHSu8oM.BccRLBNTQMamebGTXxSJrd.iQRyQbSG\",\"unit_id\":6,\"force_password_change\":false,\"id\":\"01kezkdhjhqpmmh1e2vazxpq3d\",\"user_slug\":\"user-Nc4RKkG5Xjqu\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:13:16','2026-01-15 09:13:16',NULL),(42,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezkygchwmgr282ree6fnnxn','App\\Models\\User','[]','{\"name\":\"MAN-UP2BKTKU\",\"email\":\"man.up2bktku@test.com\",\"password\":\"$2y$12$fpWp0qYfv6e5wGE\\/PUoDQeY8RFR1Ct\\/xe3ITd2SW49xkfhObRWDOm\",\"unit_id\":8,\"force_password_change\":false,\"id\":\"01kezkygchwmgr282ree6fnnxn\",\"user_slug\":\"user-RAcjIMXk8VCW\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:22:32','2026-01-15 09:22:32',NULL),(43,'App\\Models\\User','01kezkygchwmgr282ree6fnnxn','deleted','01kezkygchwmgr282ree6fnnxn','App\\Models\\User','{\"id\":\"01kezkygchwmgr282ree6fnnxn\",\"name\":\"MAN-UP2BKTKU\",\"user_slug\":\"user-RAcjIMXk8VCW\",\"email\":\"man.up2bktku@test.com\",\"unit_id\":8,\"email_verified_at\":null,\"password\":\"$2y$12$fpWp0qYfv6e5wGE\\/PUoDQeY8RFR1Ct\\/xe3ITd2SW49xkfhObRWDOm\",\"two_factor_secret\":null,\"two_factor_recovery_codes\":null,\"location\":null,\"force_password_change\":0,\"disable_account\":0,\"profile_image_type\":\"avatar\",\"locale\":\"en\",\"last_login_at\":null,\"last_login_ip\":null,\"password_changed_at\":null,\"password_expiry_at\":null,\"remember_token\":null}','[]','https://pln.hanafiah.my.id/user/account/delete','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:33:10','2026-01-15 09:33:10',NULL),(44,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezmke2eas43dmhys57gxw3s','App\\Models\\User','[]','{\"name\":\"REN-UIP3BKAL\",\"email\":\"ren.uip3bkal@test.com\",\"password\":\"$2y$12$j9\\/mmj6AEVoH3PqXTmB5pegVNzUiHpfukb75jJsn1oQvy3qIJgdt.\",\"unit_id\":1,\"force_password_change\":false,\"id\":\"01kezmke2eas43dmhys57gxw3s\",\"user_slug\":\"user-tcvoyUsSmwue\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:33:58','2026-01-15 09:33:58',NULL),(45,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezmmnecmpv0gsaq5cw9w2aq','App\\Models\\User','[]','{\"name\":\"DAN-UIP3BKAL\",\"email\":\"dan.uip3bkal@test.com\",\"password\":\"$2y$12$wi\\/s.aD9aNK2DKoAFPaKEeWa9PsUeGX5D4rO\\/O5Llt46OuMUwh1aC\",\"unit_id\":1,\"force_password_change\":false,\"id\":\"01kezmmnecmpv0gsaq5cw9w2aq\",\"user_slug\":\"user-XQ2UccFGNnE3\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:34:38','2026-01-15 09:34:38',NULL),(46,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezmns4w2k9knmg0b4w5f060','App\\Models\\User','[]','{\"name\":\"KON-UIP3BKAL\",\"email\":\"kon.uip3bkal@test.com\",\"password\":\"$2y$12$DCFCKNoRFVkpJde4rsSO0e3uKz5VX6Tvrg\\/q9DFdHXnyxf0hCyV3i\",\"unit_id\":1,\"force_password_change\":false,\"id\":\"01kezmns4w2k9knmg0b4w5f060\",\"user_slug\":\"user-S5U5ePlomhgn\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:35:15','2026-01-15 09:35:15',NULL),(47,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kezmpschgtg7hhb28gc1hzsh','App\\Models\\User','[]','{\"name\":\"KEU-UIP3BKAL\",\"email\":\"keu.uip3bkal@test.com\",\"password\":\"$2y$12$F8kzVVlddDrcvQ481nz7heQ3wCVHWy0uwM9QMiO5HqXsQ\\/wY1sXYO\",\"unit_id\":1,\"force_password_change\":false,\"id\":\"01kezmpschgtg7hhb28gc1hzsh\",\"user_slug\":\"user-u2j5oELXyToq\"}','https://pln.hanafiah.my.id/admin/users','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-15 09:35:48','2026-01-15 09:35:48',NULL),(48,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kf2ha6kdp9cng1796n5eqm4f','App\\Models\\User','[]','{\"name\":\"Manager\",\"email\":\"test@manager.com\",\"password\":\"$2y$12$0n99xIXnc4zXa7QxbjD\\/e.IZiD9RjIvURGzzETMtLStiztl1HX3.2\",\"unit_id\":7,\"force_password_change\":false,\"id\":\"01kf2ha6kdp9cng1796n5eqm4f\",\"user_slug\":\"user-dbdeCXcZ8vds\"}','https://pln.hanafiah.my.id/admin/users','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',NULL,'2026-01-16 12:34:13','2026-01-16 12:34:13',NULL),(49,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','deleted','01kf2ha6kdp9cng1796n5eqm4f','App\\Models\\User','{\"id\":\"01kf2ha6kdp9cng1796n5eqm4f\",\"name\":\"Manager\",\"user_slug\":\"user-dbdeCXcZ8vds\",\"email\":\"test@manager.com\",\"unit_id\":7,\"email_verified_at\":null,\"password\":\"$2y$12$0n99xIXnc4zXa7QxbjD\\/e.IZiD9RjIvURGzzETMtLStiztl1HX3.2\",\"two_factor_secret\":null,\"two_factor_recovery_codes\":null,\"location\":null,\"force_password_change\":0,\"disable_account\":0,\"profile_image_type\":\"avatar\",\"locale\":\"en\",\"last_login_at\":null,\"last_login_ip\":null,\"password_changed_at\":null,\"password_expiry_at\":null,\"remember_token\":null}','[]','https://pln.hanafiah.my.id/admin/users/01kf2ha6kdp9cng1796n5eqm4f','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',NULL,'2026-01-16 12:40:42','2026-01-16 12:40:42',NULL),(50,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kf64r74v8fc6kngvppnmeftk','App\\Models\\User','[]','{\"name\":\"sayyid\",\"email\":\"sayyid@gmail.com\",\"password\":\"$2y$12$0.qdMWjkN1Je8QDa.8rPY.DuvBnZivPT\\/OHwmUxbZta1crK0bbQa2\",\"unit_id\":6,\"force_password_change\":false,\"id\":\"01kf64r74v8fc6kngvppnmeftk\",\"user_slug\":\"user-vHrLFDKgcHKj\"}','https://pln.hanafiah.my.id/admin/users','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2026-01-17 22:11:38','2026-01-17 22:11:38',NULL),(51,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kf653w5j4bj951pa0mpk6x5x','App\\Models\\User','[]','{\"name\":\"sayyid2\",\"email\":\"tes@tes.com\",\"password\":\"$2y$12$DNZXHFk2Em2e89gBSoHGQulMiw\\/rJz8F6GdFaJl6QtrJD.P29a7VS\",\"unit_id\":3,\"force_password_change\":false,\"id\":\"01kf653w5j4bj951pa0mpk6x5x\",\"user_slug\":\"user-XLO5zbQfOkUj\"}','https://pln.hanafiah.my.id/admin/users','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2026-01-17 22:18:00','2026-01-17 22:18:00',NULL),(52,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','deleted','01kf653w5j4bj951pa0mpk6x5x','App\\Models\\User','{\"id\":\"01kf653w5j4bj951pa0mpk6x5x\",\"name\":\"sayyid2\",\"user_slug\":\"user-XLO5zbQfOkUj\",\"email\":\"tes@tes.com\",\"unit_id\":3,\"email_verified_at\":null,\"password\":\"$2y$12$DNZXHFk2Em2e89gBSoHGQulMiw\\/rJz8F6GdFaJl6QtrJD.P29a7VS\",\"two_factor_secret\":null,\"two_factor_recovery_codes\":null,\"location\":null,\"force_password_change\":0,\"disable_account\":0,\"profile_image_type\":\"avatar\",\"locale\":\"en\",\"last_login_at\":null,\"last_login_ip\":null,\"password_changed_at\":null,\"password_expiry_at\":null,\"remember_token\":null}','[]','https://pln.hanafiah.my.id/admin/users/01kf653w5j4bj951pa0mpk6x5x','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',NULL,'2026-01-17 22:19:38','2026-01-17 22:19:38',NULL),(53,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kf84am833kpphvp3g9ztssq3','App\\Models\\User','[]','{\"name\":\"MAN-UP2BKSKT\",\"email\":\"man.up2bkskt@test.com\",\"password\":\"$2y$12$uTqI8MlmfNtN0YzzgxaflufQk7GNsxLPqGnFcygAEwLEE7EE.HlnS\",\"unit_id\":7,\"force_password_change\":false,\"id\":\"01kf84am833kpphvp3g9ztssq3\",\"user_slug\":\"user-wDwGgDzdCQgk\"}','https://pln.hanafiah.my.id/admin/users','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-18 16:42:42','2026-01-18 16:42:42',NULL),(54,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','updated','01kf84am833kpphvp3g9ztssq3','App\\Models\\User','{\"unit_id\":7}','{\"unit_id\":5}','https://pln.hanafiah.my.id/admin/users/01kf84am833kpphvp3g9ztssq3','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-18 16:44:15','2026-01-18 16:44:15',NULL),(55,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kf84eefz509rz60j6xsyhgmf','App\\Models\\User','[]','{\"name\":\"MAN-UP2BKB\",\"email\":\"man.up2bkb@test.com\",\"password\":\"$2y$12$\\/uSSoUDZ\\/Ee0hQA82ZZJ0eUIeYc5tJe\\/rkLCv0ZnCm5zRdTYp3FgW\",\"unit_id\":7,\"force_password_change\":false,\"id\":\"01kf84eefz509rz60j6xsyhgmf\",\"user_slug\":\"user-1Yaqk2F9t6Kg\"}','https://pln.hanafiah.my.id/admin/users','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-18 16:44:47','2026-01-18 16:44:47',NULL),(56,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kf84fgpxfwy40h1a3mmk502n','App\\Models\\User','[]','{\"name\":\"MAN-UPTBPP\",\"email\":\"man.uptbpp@test.com\",\"password\":\"$2y$12$d.H.rwIZpXFRvPW0BrHorucQ5V\\/GzL0xCIZEu4KjnZBujGLarj3GC\",\"unit_id\":4,\"force_password_change\":false,\"id\":\"01kf84fgpxfwy40h1a3mmk502n\",\"user_slug\":\"user-7xofEscwLUpw\"}','https://pln.hanafiah.my.id/admin/users','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-18 16:45:22','2026-01-18 16:45:22',NULL),(57,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kf84gsxf2h44hb0zpkvv59we','App\\Models\\User','[]','{\"name\":\"MAN-UPTBJB\",\"email\":\"man.uptbjb@test.com\",\"password\":\"$2y$12$GZOU59fBc7S4uD8S0g00Z.vK1JRhwejB85atc.GZupHZqobgw14.e\",\"unit_id\":3,\"force_password_change\":false,\"id\":\"01kf84gsxf2h44hb0zpkvv59we\",\"user_slug\":\"user-ITP6MVpMhUNh\"}','https://pln.hanafiah.my.id/admin/users','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-18 16:46:04','2026-01-18 16:46:04',NULL),(58,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kf84j703y7pwtm4hgf41pdf6','App\\Models\\User','[]','{\"name\":\"MAN-UPTPTK\",\"email\":\"man.uptptk@test.com\",\"password\":\"$2y$12$nnab3M1uZmt5wK08K9DvX.SYIyYGsw17h8JyfDweoedwXHyEhpeja\",\"unit_id\":2,\"force_password_change\":false,\"id\":\"01kf84j703y7pwtm4hgf41pdf6\",\"user_slug\":\"user-rpSG2FczrbBm\"}','https://pln.hanafiah.my.id/admin/users','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-18 16:46:50','2026-01-18 16:46:50',NULL),(59,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kf84k65h2h0a5gcseyacp55w','App\\Models\\User','[]','{\"name\":\"MAN-UPTPKY\",\"email\":\"man.uptpky@test.com\",\"password\":\"$2y$12$ufW8Di9vRwJsb08ewZPf5.fTcFrgMG19J7VEh37cFRm4GwasR18SW\",\"unit_id\":6,\"force_password_change\":false,\"id\":\"01kf84k65h2h0a5gcseyacp55w\",\"user_slug\":\"user-pebLrdsDsnex\"}','https://pln.hanafiah.my.id/admin/users','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',NULL,'2026-01-18 16:47:22','2026-01-18 16:47:22',NULL),(60,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','created','01kg1qz9q704r260cfm7d3npr7','App\\Models\\User','[]','{\"name\":\"tes prk\",\"email\":\"tesuser\",\"password\":\"$2y$12$VlqlrZU\\/oKUoOHJPfVi5QOXDSb3b\\/xoXB6ZNTCE3u4PhfIX1c3wHi\",\"unit_id\":1,\"force_password_change\":false,\"id\":\"01kg1qz9q704r260cfm7d3npr7\",\"user_slug\":\"user-m984SapvB0H4\"}','https://pln.hanafiah.my.id/admin/users','114.122.212.199','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',NULL,'2026-01-28 15:27:03','2026-01-28 15:27:03',NULL),(61,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','deleted','01kg1qz9q704r260cfm7d3npr7','App\\Models\\User','{\"id\":\"01kg1qz9q704r260cfm7d3npr7\",\"name\":\"tes prk\",\"user_slug\":\"user-m984SapvB0H4\",\"email\":\"tesuser\",\"unit_id\":1,\"email_verified_at\":null,\"password\":\"$2y$12$VlqlrZU\\/oKUoOHJPfVi5QOXDSb3b\\/xoXB6ZNTCE3u4PhfIX1c3wHi\",\"two_factor_secret\":null,\"two_factor_recovery_codes\":null,\"location\":null,\"force_password_change\":0,\"disable_account\":0,\"profile_image_type\":\"avatar\",\"locale\":\"en\",\"last_login_at\":null,\"last_login_ip\":null,\"password_changed_at\":null,\"password_expiry_at\":null,\"remember_token\":null}','[]','https://pln.hanafiah.my.id/admin/users/01kg1qz9q704r260cfm7d3npr7','114.122.212.199','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',NULL,'2026-01-28 15:48:01','2026-01-28 15:48:01',NULL);
/*!40000 ALTER TABLE `audits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bidangs`
--

DROP TABLE IF EXISTS `bidangs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bidangs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bidangs_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bidangs`
--

LOCK TABLES `bidangs` WRITE;
/*!40000 ALTER TABLE `bidangs` DISABLE KEYS */;
INSERT INTO `bidangs` VALUES (1,'Transmisi','2025-12-15 02:27:21',NULL),(2,'⁠Operasi Sistem','2025-12-15 02:27:21',NULL),(3,'Perencanaan','2026-01-13 03:47:10',NULL),(4,'KKU','2026-01-13 03:47:10',NULL),(5,'K3L & Keamanan','2026-01-13 03:47:47',NULL);
/*!40000 ALTER TABLE `bidangs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enjinirings`
--

DROP TABLE IF EXISTS `enjinirings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enjinirings` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `paket_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `target_survey` date DEFAULT NULL,
  `realisasi_survey` date DEFAULT NULL,
  `file_survey` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dokumen_survey` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `target_dokumen_enjiniring` date DEFAULT NULL,
  `realisasi_dokumen_enjiniring` date DEFAULT NULL,
  `file_rab` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dokumen_rab` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rab` decimal(15,2) DEFAULT NULL,
  `file_tor` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dokumen_tor` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `keterangan` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `enjinirings_paket_id_foreign` (`paket_id`),
  CONSTRAINT `enjinirings_paket_id_foreign` FOREIGN KEY (`paket_id`) REFERENCES `pakets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enjinirings`
--

LOCK TABLES `enjinirings` WRITE;
/*!40000 ALTER TABLE `enjinirings` DISABLE KEYS */;
INSERT INTO `enjinirings` VALUES ('01kg69rsjd6sbehb242r363wsw','01kg66gpw2syj44yf7tvmts4ry','2025-12-19',NULL,NULL,NULL,'2026-01-18',NULL,NULL,NULL,0.00,NULL,NULL,NULL,'2026-01-30 09:55:02','2026-01-30 09:55:02'),('01kg69wdnq94mv2kvnakm94exf','01kg66k2whsyfttxe125wgg4m7','2025-12-19',NULL,NULL,NULL,'2026-01-18',NULL,NULL,NULL,0.00,NULL,NULL,NULL,'2026-01-30 09:57:01','2026-01-30 09:57:01'),('01kg69yzdcyq0244wpn6cynz06','01kg66pkfrwbtn18nzmv95zvzj','2025-12-19',NULL,NULL,NULL,'2026-01-18',NULL,NULL,NULL,0.00,NULL,NULL,NULL,'2026-01-30 09:58:24','2026-01-30 09:58:24'),('01kg6a3b5s3yb942saabj3p31m','01kg69jaqeab1mn3q56cek69t1','2025-12-23',NULL,NULL,NULL,'2026-01-22',NULL,NULL,NULL,0.00,NULL,NULL,NULL,'2026-01-30 10:00:48','2026-01-30 10:00:48'),('01kg6a3zs6jq9jft3jhd80t1pj','01kg69f4r00dmtbg6c2hfk53jb','2025-12-23',NULL,NULL,NULL,'2026-01-22',NULL,NULL,NULL,0.00,NULL,NULL,NULL,'2026-01-30 10:01:09','2026-01-30 10:01:09'),('01kg6a4jydd08vg2enx5q0se5z','01kg684dg5ntpy382dtyg11zc9','2025-12-23',NULL,NULL,NULL,'2026-01-22',NULL,NULL,NULL,0.00,NULL,NULL,NULL,'2026-01-30 10:01:28','2026-01-30 10:01:28'),('01kg6bnt77xkpq79pf9n85et74','01kg6bmhgyrq8g7xq0er3bp0e9','2025-12-13','2025-12-14','https://pln.hanafiah.my.id/storage/files/tes file.pdf',NULL,'2026-01-12','2026-01-13','https://pln.hanafiah.my.id/storage/files/tes file.pdf',NULL,1875900000.00,'https://pln.hanafiah.my.id/storage/files/tes file.pdf',NULL,NULL,'2026-01-30 10:28:21','2026-01-30 10:31:21');
/*!40000 ALTER TABLE `enjinirings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financial_metrics`
--

DROP TABLE IF EXISTS `financial_metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financial_metrics` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `category` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financial_metrics`
--

LOCK TABLES `financial_metrics` WRITE;
/*!40000 ALTER TABLE `financial_metrics` DISABLE KEYS */;
INSERT INTO `financial_metrics` VALUES ('01kbxxrnfrtr0a3re4ngeq7txv','2025-08-30','marketing',25838.91,'expense','Qui sunt explicabo iusto quae.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnftm78f5hgjt92rv1by','2025-08-31','investment',94893.33,'income','Ex iure dolor unde ut sint inventore ut fugit.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnfvjwqf3vv6591ntt6a','2025-09-01','sales',93932.28,'expense','Qui soluta numquam voluptatem aperiam aut aut.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnfwxbmyvmxd3bthzq62','2025-09-02','marketing',11407.65,'income','Nemo sit impedit libero eos nulla.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnfx3kbhvra5cv30gscf','2025-09-03','investment',75399.25,'expense','Voluptatibus accusantium dolor molestias velit maiores nesciunt.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnfywysqp1rw54e30b47','2025-09-04','operations',49355.13,'expense','Repellat quia officia inventore voluptatibus dolores sunt.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnfz2ppx2t0d0e3gk52a','2025-09-05','sales',69199.39,'income','Aut dolores non ea aut aut est.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng0emrg04dwk012trdt','2025-09-06','investment',55900.03,'expense','Ducimus quaerat iste ipsa sunt.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng0emrg04dwk012trdv','2025-09-07','marketing',64118.00,'expense','Sapiente blanditiis quia ut ut et.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng159f4m6kz0jxazztt','2025-09-08','investment',45756.31,'income','Maiores perspiciatis aut et voluptate voluptatem ex repudiandae.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng2mynsbzafhyyegncc','2025-09-09','sales',79129.77,'expense','Velit sit repellat architecto non possimus culpa.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng3x3yrxtk4mcn5rt56','2025-09-10','marketing',91821.80,'expense','Quas error voluptatum quia ducimus eaque quaerat ut.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng40k524y1shchwa722','2025-09-11','sales',16231.90,'income','Incidunt accusamus quasi et dolores voluptatem veritatis dicta non.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng40k524y1shchwa723','2025-09-12','investment',71360.83,'expense','Et ipsam dolores velit quae numquam ab voluptatem.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng5qbksd6z4q67gj7sf','2025-09-13','investment',88826.75,'income','Quasi qui voluptates quis.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng6fcvf25tq78ketmre','2025-09-14','operations',25561.13,'income','Provident excepturi deserunt porro deserunt.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng7sdy5p4qj5nf76h1d','2025-09-15','operations',76538.16,'expense','Consequatur dolore impedit dolores facere quia.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng7sdy5p4qj5nf76h1e','2025-09-16','operations',71968.24,'income','Rem corrupti nulla veniam saepe.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng8dmrazaj77aejkyqr','2025-09-17','investment',76103.33,'income','Ut corporis atque illo labore non autem.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrng9afchkxk2pbmt9whf','2025-09-18','operations',32761.82,'expense','Ipsam vel quo quibusdam omnis laborum aut alias ad.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngaexejxv997e01xg6x','2025-09-19','operations',31220.92,'income','Error temporibus deserunt similique et commodi pariatur voluptas.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngaexejxv997e01xg6y','2025-09-20','marketing',37552.89,'expense','Voluptatem mollitia consequatur necessitatibus et esse.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngbrezth9vddr61z07h','2025-09-21','operations',38619.88,'income','Quod debitis adipisci voluptatem quia.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngc8p209spcxxcy1k6r','2025-09-22','operations',33519.18,'income','Nihil quos ea nostrum optio.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngdppk17275hgsfc58j','2025-09-23','marketing',98024.14,'expense','Placeat voluptas est modi dicta sit ipsum aperiam.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngdppk17275hgsfc58k','2025-09-24','marketing',46409.60,'expense','Distinctio ut neque dicta impedit nulla molestiae.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnge0d9tf63x9h0ad55v','2025-09-25','sales',52099.65,'income','Rerum aut rerum reiciendis aspernatur nam in sed.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngf1e3gszf61nbtv35a','2025-09-26','marketing',50748.60,'income','Autem porro aspernatur ea non ea qui corrupti et.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngf1e3gszf61nbtv35b','2025-09-27','investment',37944.00,'income','Facilis est nam ab non.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnggj0m8w9f4gqj997tj','2025-09-28','marketing',16701.61,'income','Similique voluptatem id laborum illum.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnghxc1em3mrkyvkh06p','2025-09-29','marketing',22638.16,'income','Dolorem occaecati at fuga iure eum facilis.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnghxc1em3mrkyvkh06q','2025-09-30','investment',6684.79,'income','Architecto nesciunt molestiae neque temporibus ipsa.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngjy3r6wh21bf5n5hk7','2025-10-01','sales',78992.78,'income','Quia esse ducimus molestiae natus ipsam.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngk7xsaj5v088fxhdxc','2025-10-02','sales',20900.72,'expense','Ad nemo quo sed distinctio consequatur.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngk7xsaj5v088fxhdxd','2025-10-03','marketing',32013.34,'expense','Nemo magnam a commodi.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngmpk7r1mvxs1dxjm2b','2025-10-04','marketing',90765.55,'income','Iusto ut aut quae aliquid laborum impedit.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngnbge2j2k7btf2dvjn','2025-10-05','marketing',41747.40,'expense','Atque et quo sequi sapiente est.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngphg2w0qvgepqgq131','2025-10-06','marketing',99951.44,'income','Ipsum sint aperiam atque perferendis optio debitis rem.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngphg2w0qvgepqgq132','2025-10-07','marketing',47358.43,'expense','Veniam placeat sint est dolor rem recusandae facilis.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngq5vesadkt40xefssx','2025-10-08','operations',4462.82,'income','Et enim cum eum maxime est vitae.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngq5vesadkt40xefssy','2025-10-09','sales',61628.46,'expense','Eius qui velit animi doloremque at.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngr3d5gsd3bs0natpfj','2025-10-10','operations',45563.40,'income','Ut suscipit eius eum dolores ut.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngsd3xxwe5jr37aevvk','2025-10-11','investment',96930.70,'expense','Amet inventore ut recusandae.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngsd3xxwe5jr37aevvm','2025-10-12','investment',25453.31,'income','Qui ratione distinctio consequatur laborum aliquam inventore vitae consequuntur.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngt9qvt2y5whcwtvnxj','2025-10-13','operations',44400.02,'income','Qui eius harum hic ea pariatur.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngvqgwnpc0rr597pcz9','2025-10-14','operations',14475.62,'income','Ex assumenda eius aut suscipit.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngvqgwnpc0rr597pcza','2025-10-15','operations',2900.83,'income','Illum assumenda omnis ea nisi id.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngwwdrjxdpf0bfedzt8','2025-10-16','operations',51857.10,'income','Ut enim praesentium placeat alias sed.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngxsfnzvqw9k1q246hq','2025-10-17','marketing',56225.90,'income','Ea et officiis explicabo nisi corrupti necessitatibus.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngxsfnzvqw9k1q246hr','2025-10-18','sales',94408.34,'income','Quaerat dolorum error sit.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngy1hf0qvd3hx4ateax','2025-10-19','marketing',14909.29,'income','Quidem ea odio voluptas non quae sint.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngz094af2jvzt1gdkv4','2025-10-20','operations',37903.30,'expense','Doloribus nemo ullam ut porro perspiciatis incidunt neque.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrngz094af2jvzt1gdkv5','2025-10-21','operations',35158.58,'expense','Magni voluptatem molestiae dolore quia.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh0rwt1at5g2f68e7kc','2025-10-22','investment',29823.65,'income','Voluptatem fuga sunt omnis voluptatem odit pariatur voluptatibus hic.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh1vavypgtn8hm31xe8','2025-10-23','sales',15098.95,'income','Delectus odit hic molestiae perspiciatis.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh1vavypgtn8hm31xe9','2025-10-24','investment',47538.92,'expense','Rerum aut officia id laborum.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh2vqk4qa34n6ren78j','2025-10-25','investment',27982.19,'expense','Ratione officia et voluptatem architecto fugit accusamus temporibus.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh2vqk4qa34n6ren78k','2025-10-26','investment',20066.81,'expense','Qui nemo in ea velit magnam quia sunt.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh3kp4htkf35kjh16j7','2025-10-27','operations',74553.49,'expense','Molestiae voluptatem ipsam quasi incidunt est.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh44xg6ejczje9zjxn9','2025-10-28','investment',62065.73,'income','Et aut magnam est adipisci et sit consequatur.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh44xg6ejczje9zjxna','2025-10-29','investment',39277.77,'expense','Eos enim quo occaecati voluptas ipsum inventore et.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh57knwf7psjqve00zf','2025-10-30','marketing',35443.64,'expense','Fuga voluptas nostrum doloribus ullam veniam.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh6ayhhzxzmjcdb8xd3','2025-10-31','investment',74467.63,'expense','Ducimus asperiores occaecati et earum eveniet sint praesentium.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh6ayhhzxzmjcdb8xd4','2025-11-01','marketing',28776.76,'income','Maiores modi deserunt et.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh7mbgev9v3wr7as59r','2025-11-02','operations',43168.95,'expense','Facilis sunt officiis tempore sint autem molestiae id.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh8g688qc36a39e5t77','2025-11-03','sales',39111.24,'income','Quod molestiae et delectus.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh8g688qc36a39e5t78','2025-11-04','marketing',89084.21,'income','Molestias fugit beatae incidunt non iure veniam.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnh9dx8zn6571yqfjt6c','2025-11-05','operations',3161.30,'income','Error amet in consectetur maiores dignissimos vel.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhamwabwsepdeqnbg9q','2025-11-06','operations',56533.07,'expense','Accusantium aut et voluptatem et minima impedit.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhamwabwsepdeqnbg9r','2025-11-07','sales',41518.34,'income','Quia eveniet quidem aut sunt consectetur.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhbe3sj2e5fqxbqqke9','2025-11-08','investment',7661.81,'income','Explicabo qui perferendis nihil saepe eligendi id.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhccs2qdpage2jbqm0r','2025-11-09','operations',16930.51,'income','Quidem animi et quae eaque.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhccs2qdpage2jbqm0s','2025-11-10','marketing',47602.50,'income','Eaque molestias omnis illo maiores qui laboriosam.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhdy54gesmfjgypystr','2025-11-11','sales',13597.03,'expense','Animi consequatur molestias qui.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnheg9swy75k5ytj8w5y','2025-11-12','operations',88281.76,'expense','Odit repellat voluptatibus animi aut accusamus illum voluptatum.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnheg9swy75k5ytj8w5z','2025-11-13','sales',2134.89,'income','Quisquam tenetur veniam quis necessitatibus eligendi est qui.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhf4b4wecwyts6jjdv6','2025-11-14','sales',43162.23,'expense','Suscipit autem necessitatibus veniam officia laudantium necessitatibus repellendus.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhf4b4wecwyts6jjdv7','2025-11-15','operations',55149.38,'income','Laborum et magnam eveniet praesentium facilis dicta.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhg14jxfc1h9de35fs0','2025-11-16','operations',30612.46,'income','Natus delectus omnis sed inventore reprehenderit.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhh0ytqg5wd2fkb1zkh','2025-11-17','operations',44030.73,'income','Ratione quos perferendis eveniet quia soluta.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhh0ytqg5wd2fkb1zkj','2025-11-18','sales',1322.21,'income','Tempore quis blanditiis eveniet ad quaerat id in.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhjvd883kff3p7w5z6q','2025-11-19','investment',31527.69,'income','Iure tempora dicta laudantium quibusdam quia excepturi facilis.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhkqj68q57x0sx37wq0','2025-11-20','marketing',11216.17,'expense','Qui consequatur et rerum sunt.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhkqj68q57x0sx37wq1','2025-11-21','investment',18386.43,'income','Aliquid id ut et sit voluptatibus.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhm0vg34fzn0zr9r908','2025-11-22','investment',72475.32,'expense','Dolor reprehenderit voluptas sit quia.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhm0vg34fzn0zr9r909','2025-11-23','investment',53163.58,'income','Nobis temporibus ut eaque veritatis.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhnqcsjbasb4tcqx0g3','2025-11-24','operations',54719.09,'income','Deserunt dolor est error magni facilis inventore at.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhprvxva6edxtcb6eew','2025-11-25','sales',61563.69,'expense','Ut qui quibusdam non incidunt sint repellendus iure.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhprvxva6edxtcb6eex','2025-11-26','sales',52548.43,'expense','Nemo non sunt doloribus doloremque voluptatum tempora quis.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhq4n396e03hfs4m6tw','2025-11-27','operations',36472.80,'income','Et magni dolores delectus consequuntur quia dolor.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhry6tvc5e2471xmh32','2025-11-28','investment',31557.18,'expense','Minus eius enim placeat excepturi iste.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhry6tvc5e2471xmh33','2025-11-29','investment',75198.85,'income','Modi quos a provident autem.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhsdzzb2nj9rabcyp4d','2025-11-30','investment',71310.08,'expense','Quas sint harum ea ea.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhtesnbm7g972h16a7k','2025-12-01','sales',6012.84,'income','Delectus nihil soluta ut consectetur aut.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhtesnbm7g972h16a7m','2025-12-02','sales',75240.01,'expense','Corporis dolor qui veritatis qui.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhvwpxd3qxs6mg87mgr','2025-12-03','marketing',76196.73,'income','Illum ducimus debitis a ullam accusantium.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhw34avftqs3k6t5e2j','2025-12-04','marketing',24290.30,'expense','Consequuntur repudiandae eum architecto sunt.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhw34avftqs3k6t5e2k','2025-12-05','marketing',5294.09,'expense','Enim placeat dolore itaque et.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhx2gnps97dp19kadg1','2025-12-06','operations',41617.68,'income','Quia alias qui ipsa accusamus.','2025-12-07 18:48:32','2025-12-07 18:48:32'),('01kbxxrnhykg04cxp6ndfcvtp0','2025-12-07','investment',15545.00,'expense','Explicabo reiciendis excepturi explicabo.','2025-12-07 18:48:32','2025-12-07 18:48:32');
/*!40000 ALTER TABLE `financial_metrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_check_result_history_items`
--

DROP TABLE IF EXISTS `health_check_result_history_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_check_result_history_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `check_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `check_label` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `notification_message` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `short_summary` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `meta` json NOT NULL,
  `ended_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `batch` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `health_check_result_history_items_created_at_index` (`created_at`),
  KEY `health_check_result_history_items_batch_index` (`batch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_check_result_history_items`
--

LOCK TABLES `health_check_result_history_items` WRITE;
/*!40000 ALTER TABLE `health_check_result_history_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `health_check_result_history_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kontraks`
--

DROP TABLE IF EXISTS `kontraks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kontraks` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `lakdan_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `rencana_tanggal_perjanjian` date DEFAULT NULL,
  `realisasi_tanggal_perjanjian` date DEFAULT NULL,
  `tanggal_efektif` date DEFAULT NULL,
  `dokumen_perjanjian` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Path file dokumen',
  `dokumen_perjanjian_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Nama asli file dokumen',
  `nomor_perjanjian` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `nilai_perjanjian_ppn` decimal(15,2) DEFAULT NULL,
  `nilai_perjanjian_sebelum_ppn` decimal(15,2) DEFAULT NULL,
  `penyedia_barang_jasa` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `jenis_perjanjian` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `masa_pelaksanaan` smallint unsigned NOT NULL COMMENT 'Durasi masa pelaksanaan dalam hari',
  `tanggal_berakhir` date DEFAULT NULL,
  `durasi_pengadaan` smallint unsigned NOT NULL COMMENT 'Durasi total pengadaan dalam hari',
  `status_proses` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `rencana_jaminan_pelaksanaan` date DEFAULT NULL,
  `realisasi_jaminan_pelaksanaan` date DEFAULT NULL,
  `dokumen_jaminan_pelaksanaan` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Path file dokumen',
  `dokumen_jaminan_pelaksanaan_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Nama asli file dokumen',
  `nomor_jaminan_pelaksanaan` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `nilai_jaminan_pelaksanaan` decimal(15,2) DEFAULT NULL,
  `bank_pemberi_jaminan` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tingkat_risiko_csms` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tkdn` decimal(5,2) DEFAULT NULL COMMENT 'Tingkat Komponen Dalam Negeri (Format 5.00 untuk 5%)',
  `efisiensi_thd_hps` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'Disimpan sebagai string untuk menjaga format persentase (Cth: "1,36%")',
  `keterangan` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kontraks_nomor_perjanjian_unique` (`nomor_perjanjian`),
  KEY `kontraks_lakdan_id_foreign` (`lakdan_id`),
  CONSTRAINT `kontraks_lakdan_id_foreign` FOREIGN KEY (`lakdan_id`) REFERENCES `lakdans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kontraks`
--

LOCK TABLES `kontraks` WRITE;
/*!40000 ALTER TABLE `kontraks` DISABLE KEYS */;
INSERT INTO `kontraks` VALUES ('01kg8v1p4swczaxnn0nvcrc77k','01kg8tyh6xfx8cxr688fkk49zz','2026-01-19','2026-01-20','2026-01-21','https://pln.hanafiah.my.id/storage/files/tes file.pdf',NULL,'123',200000000.00,190000000.00,'PT tes','HARGA SATUAN',30,'2026-02-20',10,'TERKONTRAK','2026-01-21','2026-01-22','https://pln.hanafiah.my.id/storage/files/tes file.pdf',NULL,'123',10000000.00,'Mandiri','Sedang',80.00,NULL,NULL,'2026-01-31 09:35:28','2026-01-31 09:36:59');
/*!40000 ALTER TABLE `kontraks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lakdans`
--

DROP TABLE IF EXISTS `lakdans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lakdans` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `rendan_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `pic` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `proses_pengadaan` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `metode_pengadaan` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_tanggal_hps` date DEFAULT NULL,
  `realisasi_tanggal_hps` date DEFAULT NULL,
  `dokumen_hps` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `nomor_hps` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `nilai_hps` decimal(15,4) DEFAULT NULL,
  `rencana_pengumuman_lelang` date DEFAULT NULL,
  `realisasi_pengumuman_lelang` date DEFAULT NULL,
  `nomor_pengumuman_lelang` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dokumen_penunjukan_pemenang` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_penunjukan_pemenang` date DEFAULT NULL,
  `realisasi_penunjukan_pemenang` date DEFAULT NULL,
  `nomor_penunjukan_pemenang` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `rencana_persiapan_pengadaan` date DEFAULT NULL,
  `realisasi_persiapan_pengadaan` date DEFAULT NULL,
  `persiapan_pengadaan` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_pengumuman_pengadaan` date DEFAULT NULL,
  `realisasi_pengumuman_pengadaan` date DEFAULT NULL,
  `pengumuman_pengadaan` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_pendaftaran_ambil_dokumen` date DEFAULT NULL,
  `realisasi_pendaftaran_ambil_dokumen` date DEFAULT NULL,
  `pendaftaran_ambil_dokumen` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_aanwijzing` date DEFAULT NULL,
  `realisasi_aanwijzing` date DEFAULT NULL,
  `aanwijzing` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_pemasukan_penawaran` date DEFAULT NULL,
  `realisasi_pemasukan_penawaran` date DEFAULT NULL,
  `pemasukan_penawaran` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_pembukaan_evaluasi` date DEFAULT NULL,
  `realisasi_pembukaan_evaluasi` date DEFAULT NULL,
  `pembukaan_evaluasi` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_klarifikasi_negosiasi` date DEFAULT NULL,
  `realisasi_klarifikasi_negosiasi` date DEFAULT NULL,
  `klarifikasi_negosiasi` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_usulan_penetapan_pemenang` date DEFAULT NULL,
  `realisasi_usulan_penetapan_pemenang` date DEFAULT NULL,
  `usulan_penetapan_pemenang` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_izin_prinsip_kontrak` date DEFAULT NULL,
  `realisasi_izin_prinsip_kontrak` date DEFAULT NULL,
  `izin_prinsip_kontrak` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_penetapan_pengumuman_pemenang` date DEFAULT NULL,
  `realisasi_penetapan_pengumuman_pemenang` date DEFAULT NULL,
  `penetapan_pengumuman_pemenang` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_sanggah` date DEFAULT NULL,
  `realisasi_sanggah` date DEFAULT NULL,
  `sanggah` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_penunjukan_penyedia` date DEFAULT NULL,
  `realisasi_penunjukan_penyedia` date DEFAULT NULL,
  `penunjukan_penyedia` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dokumen_penunjukan_penyedia` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_cda` date DEFAULT NULL,
  `realisasi_cda` date DEFAULT NULL,
  `cda` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lakdans_rendan_id_foreign` (`rendan_id`),
  CONSTRAINT `lakdans_rendan_id_foreign` FOREIGN KEY (`rendan_id`) REFERENCES `rendans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lakdans`
--

LOCK TABLES `lakdans` WRITE;
/*!40000 ALTER TABLE `lakdans` DISABLE KEYS */;
INSERT INTO `lakdans` VALUES ('01kg8tyh6xfx8cxr688fkk49zz','01kg6c673xw1743pehbvqa4vv9',NULL,NULL,NULL,'2026-01-01','2026-01-02','https://pln.hanafiah.my.id/storage/files/tes file.pdf','123',2390688000.0000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-31 09:33:45','2026-01-31 09:33:45','2026-01-05','2026-01-06',NULL,'2026-01-06','2026-01-07',NULL,'2026-01-07','2026-01-08',NULL,'2026-01-08','2026-01-09',NULL,'2026-01-09','2026-01-10',NULL,'2026-01-10','2026-01-11',NULL,'2026-01-11','2026-01-12',NULL,'2026-01-12','2026-01-13',NULL,'2026-01-13','2026-01-14',NULL,'2026-01-14','2026-01-14',NULL,'2026-01-15','2026-01-15',NULL,'2026-01-16','2026-01-16',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `lakdans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_history`
--

DROP TABLE IF EXISTS `login_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `ip_address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `login_successful` tinyint(1) NOT NULL DEFAULT '0',
  `login_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `logout_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `login_history_user_type_user_id_index` (`user_type`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_history`
--

LOCK TABLES `login_history` WRITE;
/*!40000 ALTER TABLE `login_history` DISABLE KEYS */;
INSERT INTO `login_history` VALUES (1,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2025-12-07 18:49:03',NULL,'2025-12-07 18:49:03','2025-12-07 18:49:03'),(2,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-07 18:50:41',NULL,'2025-12-07 18:50:41','2025-12-07 18:50:41'),(3,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2025-12-07 19:09:46',NULL,'2025-12-07 19:09:46','2025-12-07 19:09:46'),(4,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-07 21:04:01',NULL,'2025-12-07 21:04:01','2025-12-07 21:04:01'),(5,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-07 21:14:44',NULL,'2025-12-07 21:14:44','2025-12-07 21:14:44'),(6,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2025-12-07 22:25:21',NULL,'2025-12-07 22:25:21','2025-12-07 22:25:21'),(7,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2025-12-08 18:03:54',NULL,'2025-12-08 18:03:54','2025-12-08 18:03:54'),(8,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-08 18:04:14',NULL,'2025-12-08 18:04:14','2025-12-08 18:04:14'),(9,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2025-12-08 23:35:59',NULL,'2025-12-08 23:35:59','2025-12-08 23:35:59'),(10,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-08 23:54:02',NULL,'2025-12-08 23:54:02','2025-12-08 23:54:02'),(11,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-08 23:54:16',NULL,'2025-12-08 23:54:16','2025-12-08 23:54:16'),(12,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-09 00:17:14',NULL,'2025-12-09 00:17:14','2025-12-09 00:17:14'),(13,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2025-12-09 00:22:07',NULL,'2025-12-09 00:22:07','2025-12-09 00:22:07'),(14,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-09 00:23:51',NULL,'2025-12-09 00:23:51','2025-12-09 00:23:51'),(15,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2025-12-09 00:29:27',NULL,'2025-12-09 00:29:27','2025-12-09 00:29:27'),(16,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2025-12-09 00:34:32',NULL,'2025-12-09 00:34:32','2025-12-09 00:34:32'),(17,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-09 00:35:18',NULL,'2025-12-09 00:35:18','2025-12-09 00:35:18'),(18,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-09 01:25:26',NULL,'2025-12-09 01:25:26','2025-12-09 01:25:26'),(19,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-09 21:39:55',NULL,'2025-12-09 21:39:55','2025-12-09 21:39:55'),(20,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-09 22:09:32',NULL,'2025-12-09 22:09:32','2025-12-09 22:09:32'),(21,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-09 22:44:10',NULL,'2025-12-09 22:44:10','2025-12-09 22:44:10'),(22,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2025-12-10 18:54:49',NULL,'2025-12-10 18:54:49','2025-12-10 18:54:49'),(23,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:145.0) Gecko/20100101 Firefox/145.0',1,'2025-12-10 18:55:00',NULL,'2025-12-10 18:55:00','2025-12-10 18:55:00'),(24,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2025-12-10 19:16:47',NULL,'2025-12-10 19:16:47','2025-12-10 19:16:47'),(25,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-14 17:23:06',NULL,'2025-12-14 17:23:06','2025-12-14 17:23:06'),(26,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-16 17:27:49',NULL,'2025-12-16 17:27:49','2025-12-16 17:27:49'),(27,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-17 00:01:01',NULL,'2025-12-17 00:01:01','2025-12-17 00:01:01'),(28,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-17 17:42:36',NULL,'2025-12-17 17:42:36','2025-12-17 17:42:36'),(29,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-17 22:41:58',NULL,'2025-12-17 22:41:58','2025-12-17 22:41:58'),(30,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-18 18:15:40',NULL,'2025-12-18 18:15:40','2025-12-18 18:15:40'),(31,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-21 21:22:49',NULL,'2025-12-21 21:22:49','2025-12-21 21:22:49'),(32,'App\\Models\\User','01kcfwxam07aw8fh5v5zq5sz6e','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-21 22:18:52',NULL,'2025-12-21 22:18:52','2025-12-21 22:18:52'),(33,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-21 22:19:42',NULL,'2025-12-21 22:19:42','2025-12-21 22:19:42'),(34,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-22 18:03:10',NULL,'2025-12-22 18:03:10','2025-12-22 18:03:10'),(35,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-22 22:16:16',NULL,'2025-12-22 22:16:16','2025-12-22 22:16:16'),(36,'App\\Models\\User','01kcfwxam07aw8fh5v5zq5sz6e','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-23 09:03:33',NULL,'2025-12-23 09:03:33','2025-12-23 09:03:33'),(37,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-23 09:04:11',NULL,'2025-12-23 09:04:11','2025-12-23 09:04:11'),(38,'App\\Models\\User','01kcfwxam07aw8fh5v5zq5sz6e','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2025-12-23 09:04:39',NULL,'2025-12-23 09:04:39','2025-12-23 09:04:39'),(39,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-05 01:38:18',NULL,'2026-01-05 01:38:18','2026-01-05 01:38:18'),(40,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-05 06:14:08',NULL,'2026-01-05 06:14:08','2026-01-05 06:14:08'),(41,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-05 11:44:07',NULL,'2026-01-05 11:44:07','2026-01-05 11:44:07'),(42,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-06 01:08:32',NULL,'2026-01-06 01:08:32','2026-01-06 01:08:32'),(43,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-06 05:04:10',NULL,'2026-01-06 05:04:10','2026-01-06 05:04:10'),(44,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2026-01-07 06:27:17',NULL,'2026-01-07 06:27:17','2026-01-07 06:27:17'),(45,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-07 06:31:59',NULL,'2026-01-07 06:31:59','2026-01-07 06:31:59'),(46,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-08 01:56:51',NULL,'2026-01-08 01:56:51','2026-01-08 01:56:51'),(47,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-12 02:03:39',NULL,'2026-01-12 02:03:39','2026-01-12 02:03:39'),(48,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-12 05:06:08',NULL,'2026-01-12 05:06:08','2026-01-12 05:06:08'),(49,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-13 01:21:28',NULL,'2026-01-13 01:21:28','2026-01-13 01:21:28'),(50,'App\\Models\\User','01ketxs5xa2h42hchznxzv5302','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-13 05:38:27',NULL,'2026-01-13 05:38:27','2026-01-13 05:38:27'),(51,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-13 06:04:33',NULL,'2026-01-13 06:04:33','2026-01-13 06:04:33'),(52,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-13 08:13:12',NULL,'2026-01-13 08:13:12','2026-01-13 08:13:12'),(53,'App\\Models\\User','01ketxs5xa2h42hchznxzv5302','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-13 08:27:07',NULL,'2026-01-13 08:27:07','2026-01-13 08:27:07'),(54,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','127.0.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-13 08:33:46',NULL,'2026-01-13 08:33:46','2026-01-13 08:33:46'),(55,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2026-01-13 17:00:25',NULL,'2026-01-13 17:00:25','2026-01-13 17:00:25'),(56,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.10.143.55','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2026-01-13 17:52:38',NULL,'2026-01-13 17:52:38','2026-01-13 17:52:38'),(57,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.10.143.55','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2026-01-13 17:52:54',NULL,'2026-01-13 17:52:54','2026-01-13 17:52:54'),(58,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.174.13.231','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2026-01-14 14:37:09',NULL,'2026-01-14 14:37:09','2026-01-14 14:37:09'),(59,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.210.125','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-14 15:52:30',NULL,'2026-01-14 15:52:30','2026-01-14 15:52:30'),(60,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.174.13.231','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2026-01-14 16:59:21',NULL,'2026-01-14 16:59:21','2026-01-14 16:59:21'),(61,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2026-01-14 17:39:15',NULL,'2026-01-14 17:39:15','2026-01-14 17:39:15'),(62,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-14 20:03:16',NULL,'2026-01-14 20:03:16','2026-01-14 20:03:16'),(63,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 07:45:23',NULL,'2026-01-15 07:45:23','2026-01-15 07:45:23'),(64,'App\\Models\\User','01kezhvcqx766hwnxq837g5h8g','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 08:49:10',NULL,'2026-01-15 08:49:10','2026-01-15 08:49:10'),(65,'App\\Models\\User','01kezhxspjyjzx07f7brb4kved','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 08:50:44',NULL,'2026-01-15 08:50:44','2026-01-15 08:50:44'),(66,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 08:51:17',NULL,'2026-01-15 08:51:17','2026-01-15 08:51:17'),(67,'App\\Models\\User','01kezj74wpsw485qe09tdrcrzc','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 08:54:13',NULL,'2026-01-15 08:54:13','2026-01-15 08:54:13'),(68,'App\\Models\\User','01kezj89bg6mppyvhscjdwqxmc','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 08:55:23',NULL,'2026-01-15 08:55:23','2026-01-15 08:55:23'),(69,'App\\Models\\User','01kezja5y9v6qkghstzbqpwv6z','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 08:59:11',NULL,'2026-01-15 08:59:11','2026-01-15 08:59:11'),(70,'App\\Models\\User','01kezj96ztmfb7tyd22kqhhxh8','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 08:59:47',NULL,'2026-01-15 08:59:47','2026-01-15 08:59:47'),(71,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:00:47',NULL,'2026-01-15 09:00:47','2026-01-15 09:00:47'),(72,'App\\Models\\User','01kezhvcqx766hwnxq837g5h8g','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:13:31',NULL,'2026-01-15 09:13:31','2026-01-15 09:13:31'),(73,'App\\Models\\User','01kezk0n2d15y17gjfmxct5twk','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:14:31',NULL,'2026-01-15 09:14:31','2026-01-15 09:14:31'),(74,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:21:01',NULL,'2026-01-15 09:21:01','2026-01-15 09:21:01'),(75,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.174.13.231','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2026-01-15 09:22:30',NULL,'2026-01-15 09:22:30','2026-01-15 09:22:30'),(76,'App\\Models\\User','01kezkygchwmgr282ree6fnnxn','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:22:52',NULL,'2026-01-15 09:22:52','2026-01-15 09:22:52'),(77,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.174.13.231','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',1,'2026-01-15 09:31:08',NULL,'2026-01-15 09:31:08','2026-01-15 09:31:08'),(78,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:31:28',NULL,'2026-01-15 09:31:28','2026-01-15 09:31:28'),(79,'App\\Models\\User','01kezkygchwmgr282ree6fnnxn','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:32:46',NULL,'2026-01-15 09:32:46','2026-01-15 09:32:46'),(80,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:33:14',NULL,'2026-01-15 09:33:14','2026-01-15 09:33:14'),(81,'App\\Models\\User','01kezmke2eas43dmhys57gxw3s','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:36:06',NULL,'2026-01-15 09:36:06','2026-01-15 09:36:06'),(82,'App\\Models\\User','01kezmmnecmpv0gsaq5cw9w2aq','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:38:10',NULL,'2026-01-15 09:38:10','2026-01-15 09:38:10'),(83,'App\\Models\\User','01kezmpschgtg7hhb28gc1hzsh','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:39:20',NULL,'2026-01-15 09:39:20','2026-01-15 09:39:20'),(84,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 09:44:00',NULL,'2026-01-15 09:44:00','2026-01-15 09:44:00'),(85,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 14:40:52',NULL,'2026-01-15 14:40:52','2026-01-15 14:40:52'),(86,'App\\Models\\User','01kezk6807bn877xs70t5rp77x','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 14:58:13',NULL,'2026-01-15 14:58:13','2026-01-15 14:58:13'),(87,'App\\Models\\User','01kezkanzs4ajbyft0d4n0sv04','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 14:59:35',NULL,'2026-01-15 14:59:35','2026-01-15 14:59:35'),(88,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.75.51.198','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-15 15:15:50',NULL,'2026-01-15 15:15:50','2026-01-15 15:15:50'),(89,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.10.142.168','Mozilla/5.0 (iPhone; CPU iPhone OS 26_0_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/143.0.7499.151 Mobile/15E148 Safari/604.1',1,'2026-01-15 19:46:12',NULL,'2026-01-15 19:46:12','2026-01-15 19:46:12'),(90,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.10.143.56','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 10:26:35',NULL,'2026-01-16 10:26:35','2026-01-16 10:26:35'),(91,'App\\Models\\User','01kezj89bg6mppyvhscjdwqxmc','114.10.143.56','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 10:30:57',NULL,'2026-01-16 10:30:57','2026-01-16 10:30:57'),(92,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.10.143.56','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 10:32:50',NULL,'2026-01-16 10:32:50','2026-01-16 10:32:50'),(93,'App\\Models\\User','01kezj89bg6mppyvhscjdwqxmc','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 10:38:23',NULL,'2026-01-16 10:38:23','2026-01-16 10:38:23'),(94,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 11:26:16',NULL,'2026-01-16 11:26:16','2026-01-16 11:26:16'),(95,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 12:29:48',NULL,'2026-01-16 12:29:48','2026-01-16 12:29:48'),(96,'App\\Models\\User','01kf2ha6kdp9cng1796n5eqm4f','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 12:34:25',NULL,'2026-01-16 12:34:25','2026-01-16 12:34:25'),(97,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 12:40:34',NULL,'2026-01-16 12:40:34','2026-01-16 12:40:34'),(98,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 18:22:31',NULL,'2026-01-16 18:22:31','2026-01-16 18:22:31'),(99,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 23:50:04',NULL,'2026-01-16 23:50:04','2026-01-16 23:50:04'),(100,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 23:50:21',NULL,'2026-01-16 23:50:21','2026-01-16 23:50:21'),(101,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 23:51:52',NULL,'2026-01-16 23:51:52','2026-01-16 23:51:52'),(102,'App\\Models\\User','01kezj89bg6mppyvhscjdwqxmc','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 23:53:57',NULL,'2026-01-16 23:53:57','2026-01-16 23:53:57'),(103,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-16 23:58:13',NULL,'2026-01-16 23:58:13','2026-01-16 23:58:13'),(104,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-17 22:04:04',NULL,'2026-01-17 22:04:04','2026-01-17 22:04:04'),(105,'App\\Models\\User','01kf64r74v8fc6kngvppnmeftk','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-17 22:11:59',NULL,'2026-01-17 22:11:59','2026-01-17 22:11:59'),(106,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-17 22:12:25',NULL,'2026-01-17 22:12:25','2026-01-17 22:12:25'),(107,'App\\Models\\User','01kf64r74v8fc6kngvppnmeftk','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-17 22:12:49',NULL,'2026-01-17 22:12:49','2026-01-17 22:12:49'),(108,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-17 22:16:33',NULL,'2026-01-17 22:16:33','2026-01-17 22:16:33'),(109,'App\\Models\\User','01kf653w5j4bj951pa0mpk6x5x','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-17 22:18:19',NULL,'2026-01-17 22:18:19','2026-01-17 22:18:19'),(110,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.211.249','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0',1,'2026-01-17 22:18:45',NULL,'2026-01-17 22:18:45','2026-01-17 22:18:45'),(111,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 16:30:13',NULL,'2026-01-18 16:30:13','2026-01-18 16:30:13'),(112,'App\\Models\\User','01kezk0n2d15y17gjfmxct5twk','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 16:35:19',NULL,'2026-01-18 16:35:19','2026-01-18 16:35:19'),(113,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 16:37:45',NULL,'2026-01-18 16:37:45','2026-01-18 16:37:45'),(114,'App\\Models\\User','01kezhvcqx766hwnxq837g5h8g','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 16:38:18',NULL,'2026-01-18 16:38:18','2026-01-18 16:38:18'),(115,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 16:39:04',NULL,'2026-01-18 16:39:04','2026-01-18 16:39:04'),(116,'App\\Models\\User','01kf84am833kpphvp3g9ztssq3','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 16:43:00',NULL,'2026-01-18 16:43:00','2026-01-18 16:43:00'),(117,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 16:43:47',NULL,'2026-01-18 16:43:47','2026-01-18 16:43:47'),(118,'App\\Models\\User','01kf84k65h2h0a5gcseyacp55w','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 16:47:40',NULL,'2026-01-18 16:47:40','2026-01-18 16:47:40'),(119,'App\\Models\\User','01kezj74wpsw485qe09tdrcrzc','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 16:48:40',NULL,'2026-01-18 16:48:40','2026-01-18 16:48:40'),(120,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','182.2.102.157','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 16:51:12',NULL,'2026-01-18 16:51:12','2026-01-18 16:51:12'),(121,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','39.194.5.177','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-18 20:44:53',NULL,'2026-01-18 20:44:53','2026-01-18 20:44:53'),(122,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-19 09:00:34',NULL,'2026-01-19 09:00:34','2026-01-19 09:00:34'),(123,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.210.125','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-19 11:55:46',NULL,'2026-01-19 11:55:46','2026-01-19 11:55:46'),(124,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-19 11:56:38',NULL,'2026-01-19 11:56:38','2026-01-19 11:56:38'),(125,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','140.213.204.234','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36',1,'2026-01-19 11:59:23',NULL,'2026-01-19 11:59:23','2026-01-19 11:59:23'),(126,'App\\Models\\User','01kf84am833kpphvp3g9ztssq3','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-19 12:08:53',NULL,'2026-01-19 12:08:53','2026-01-19 12:08:53'),(127,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-19 15:23:19',NULL,'2026-01-19 15:23:19','2026-01-19 15:23:19'),(128,'App\\Models\\User','01kf84am833kpphvp3g9ztssq3','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-19 15:58:50',NULL,'2026-01-19 15:58:50','2026-01-19 15:58:50'),(129,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-19 16:04:50',NULL,'2026-01-19 16:04:50','2026-01-19 16:04:50'),(130,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','140.213.10.189','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-20 08:56:11',NULL,'2026-01-20 08:56:11','2026-01-20 08:56:11'),(131,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','140.213.10.189','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-20 11:29:40',NULL,'2026-01-20 11:29:40','2026-01-20 11:29:40'),(132,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36',1,'2026-01-21 07:34:53',NULL,'2026-01-21 07:34:53','2026-01-21 07:34:53'),(133,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-21 08:54:00',NULL,'2026-01-21 08:54:00','2026-01-21 08:54:00'),(134,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36',1,'2026-01-21 11:52:16',NULL,'2026-01-21 11:52:16','2026-01-21 11:52:16'),(135,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 OPR/125.0.0.0',1,'2026-01-21 13:56:18',NULL,'2026-01-21 13:56:18','2026-01-21 13:56:18'),(136,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.10.143.22','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-21 17:44:49',NULL,'2026-01-21 17:44:49','2026-01-21 17:44:49'),(137,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-22 07:59:00',NULL,'2026-01-22 07:59:00','2026-01-22 07:59:00'),(138,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-22 08:09:29',NULL,'2026-01-22 08:09:29','2026-01-22 08:09:29'),(139,'App\\Models\\User','01kezj74wpsw485qe09tdrcrzc','36.82.255.103','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-22 10:00:48',NULL,'2026-01-22 10:00:48','2026-01-22 10:00:48'),(140,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.255.103','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-22 10:02:02',NULL,'2026-01-22 10:02:02','2026-01-22 10:02:02'),(141,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.244.33','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-22 13:49:26',NULL,'2026-01-22 13:49:26','2026-01-22 13:49:26'),(142,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.248.134','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-23 09:11:30',NULL,'2026-01-23 09:11:30','2026-01-23 09:11:30'),(143,'App\\Models\\User','01kezk6807bn877xs70t5rp77x','36.82.248.134','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-23 09:42:44',NULL,'2026-01-23 09:42:44','2026-01-23 09:42:44'),(144,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.248.134','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-23 09:46:37',NULL,'2026-01-23 09:46:37','2026-01-23 09:46:37'),(145,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.10.142.187','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-25 17:20:13',NULL,'2026-01-25 17:20:13','2026-01-25 17:20:13'),(146,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.223','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-25 20:05:47',NULL,'2026-01-25 20:05:47','2026-01-25 20:05:47'),(147,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36',1,'2026-01-25 22:35:53',NULL,'2026-01-25 22:35:53','2026-01-25 22:35:53'),(148,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.248.134','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-26 08:19:35',NULL,'2026-01-26 08:19:35','2026-01-26 08:19:35'),(149,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.67','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-26 08:31:03',NULL,'2026-01-26 08:31:03','2026-01-26 08:31:03'),(150,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.248.134','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36',1,'2026-01-26 11:03:35',NULL,'2026-01-26 11:03:35','2026-01-26 11:03:35'),(151,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.87','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-26 11:05:47',NULL,'2026-01-26 11:05:47','2026-01-26 11:05:47'),(152,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','182.8.131.108','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-26 15:11:23',NULL,'2026-01-26 15:11:23','2026-01-26 15:11:23'),(153,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.213.207','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-26 17:49:42',NULL,'2026-01-26 17:49:42','2026-01-26 17:49:42'),(154,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.125.196.22','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-26 19:19:47',NULL,'2026-01-26 19:19:47','2026-01-26 19:19:47'),(155,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.114.50.18','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36',1,'2026-01-26 20:00:33',NULL,'2026-01-26 20:00:33','2026-01-26 20:00:33'),(156,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','180.251.159.243','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-27 08:14:26',NULL,'2026-01-27 08:14:26','2026-01-27 08:14:26'),(157,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','119.252.162.10','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-28 13:49:52',NULL,'2026-01-28 13:49:52','2026-01-28 13:49:52'),(158,'App\\Models\\User','01kezmke2eas43dmhys57gxw3s','119.252.162.10','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-28 13:50:11',NULL,'2026-01-28 13:50:11','2026-01-28 13:50:11'),(159,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','119.252.162.10','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-28 13:52:30',NULL,'2026-01-28 13:52:30','2026-01-28 13:52:30'),(160,'App\\Models\\User','01kezmmnecmpv0gsaq5cw9w2aq','119.252.162.10','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-28 13:53:03',NULL,'2026-01-28 13:53:03','2026-01-28 13:53:03'),(161,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','119.252.162.10','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-28 13:54:24',NULL,'2026-01-28 13:54:24','2026-01-28 13:54:24'),(162,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.199','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-28 15:09:09',NULL,'2026-01-28 15:09:09','2026-01-28 15:09:09'),(163,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.199','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-28 15:13:30',NULL,'2026-01-28 15:13:30','2026-01-28 15:13:30'),(164,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.174.13.231','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1,'2026-01-28 15:14:08',NULL,'2026-01-28 15:14:08','2026-01-28 15:14:08'),(165,'App\\Models\\User','01kg1qz9q704r260cfm7d3npr7','114.122.212.199','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-28 15:27:14',NULL,'2026-01-28 15:27:14','2026-01-28 15:27:14'),(166,'App\\Models\\User','01kg1qz9q704r260cfm7d3npr7','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1,'2026-01-28 15:34:39',NULL,'2026-01-28 15:34:39','2026-01-28 15:34:39'),(167,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1,'2026-01-28 15:37:30',NULL,'2026-01-28 15:37:30','2026-01-28 15:37:30'),(168,'App\\Models\\User','01kg1qz9q704r260cfm7d3npr7','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1,'2026-01-28 15:37:58',NULL,'2026-01-28 15:37:58','2026-01-28 15:37:58'),(169,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1,'2026-01-28 15:38:24',NULL,'2026-01-28 15:38:24','2026-01-28 15:38:24'),(170,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.199','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-28 15:41:46',NULL,'2026-01-28 15:41:46','2026-01-28 15:41:46'),(171,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','180.251.159.243','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1,'2026-01-28 16:00:09',NULL,'2026-01-28 16:00:09','2026-01-28 16:00:09'),(172,'App\\Models\\User','01kezmke2eas43dmhys57gxw3s','180.251.159.243','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1,'2026-01-28 16:00:45',NULL,'2026-01-28 16:00:45','2026-01-28 16:00:45'),(173,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.82.248.14','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-30 07:50:57',NULL,'2026-01-30 07:50:57','2026-01-30 07:50:57'),(174,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','182.8.158.236','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-31 09:18:35',NULL,'2026-01-31 09:18:35','2026-01-31 09:18:35'),(175,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.87','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-31 13:35:23',NULL,'2026-01-31 13:35:23','2026-01-31 13:35:23'),(176,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.91','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-31 16:03:39',NULL,'2026-01-31 16:03:39','2026-01-31 16:03:39'),(177,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.91','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-31 16:10:36',NULL,'2026-01-31 16:10:36','2026-01-31 16:10:36'),(178,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','182.8.158.236','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-01-31 19:44:18',NULL,'2026-01-31 19:44:18','2026-01-31 19:44:18'),(179,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.213.207','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-01-31 19:44:54',NULL,'2026-01-31 19:44:54','2026-01-31 19:44:54'),(180,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.199','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-02-01 11:28:15',NULL,'2026-02-01 11:28:15','2026-02-01 11:28:15'),(181,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','114.122.212.223','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0',1,'2026-02-01 14:45:23',NULL,'2026-02-01 14:45:23','2026-02-01 14:45:23'),(182,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','36.75.55.138','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 OPR/126.0.0.0',1,'2026-02-05 08:52:04',NULL,'2026-02-05 08:52:04','2026-02-05 08:52:04'),(183,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt','103.174.13.231','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36',1,'2026-02-06 10:18:04',NULL,'2026-02-06 10:18:04','2026-02-06 10:18:04');
/*!40000 ALTER TABLE `login_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2014_10_12_000000_create_users_table',1),(2,'2014_10_12_100000_create_password_reset_tokens_table',1),(3,'2014_10_12_200000_add_two_factor_columns_to_users_table',1),(4,'2019_08_19_000000_create_failed_jobs_table',1),(5,'2019_12_14_000001_create_personal_access_tokens_table',1),(6,'2024_10_22_135648_create_permission_tables',1),(7,'2024_10_24_123202_create_audits_table',1),(8,'2025_02_02_183354_create_personalisations_table',1),(9,'2025_02_02_205811_create_settings_table',1),(10,'2025_02_24_161810_create_login_history_table',1),(11,'2025_04_26_181756_create_sessions_table',1),(12,'2025_06_16_075701_create_financial_metrics_table',1),(13,'2025_06_26_082925_create_health_tables',1),(14,'2025_07_06_171547_create_system_notices_table',1),(15,'2025_11_27_122645_update_users_table_with_core_settings',1),(21,'2025_12_09_042416_create_paket_lakdans_table',6),(22,'2025_12_09_044047_create_kontraks_table',7),(23,'2025_12_09_045719_create_purchase_orders_table',8),(24,'2025_12_09_051837_create_pembayarans_table',9),(26,'2025_12_08_041600_create_prks_table',11),(27,'2025_12_09_021036_create_pakets_table',11),(28,'2025_12_15_014711_create_units_table',11),(29,'2025_12_15_014751_create_bidangs_table',11),(31,'2025_12_15_015629_add_unit_id_to_users_table',12),(32,'2025_12_15_015940_add_kode_to_units_table',13),(33,'2025_12_09_025131_create_paket_enjinirings_table',14),(34,'2025_12_09_040118_create_paket_rendans_table',15),(35,'2025_12_23_082158_add_pic_to_lakdans_table',16),(36,'2026_01_05_094723_add_document_columns_to_prks_table',17),(37,'2026_01_05_142101_add_document_files_to_enjinirings_table',18),(38,'2026_01_05_144525_add_ba_pembayaran_to_purchase_orders_table',19),(39,'2026_01_07_153238_add_tracking_columns_to_lakdans_table',20),(40,'2026_01_13_132451_add_uraian_paket_to_pakets_table',21),(41,'2026_01_14_162010_add_unit_id_to_pakets_table',22),(42,'2026_01_16_105720_add_rab_to_enjinirings_table',23),(43,'2026_01_22_180400_add_hpe_and_target_rks_to_rendans_table',24),(44,'2026_01_22_201316_add_bulan_tahun_akb_to_pembayarans_table',24),(45,'2026_01_22_210410_add_tanggal_efektif_to_kontraks_table',24),(46,'2026_01_22_211756_add_progress_terkini_to_purchase_orders_table',24);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_permissions`
--

DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `model_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_permissions`
--

LOCK TABLES `model_has_permissions` WRITE;
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_roles`
--

DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `model_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_roles`
--

LOCK TABLES `model_has_roles` WRITE;
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
INSERT INTO `model_has_roles` VALUES (2,'App\\Models\\User','01kbxxrmfnq2m19fmenn91q4qt'),(3,'App\\Models\\User','01ketxs5xa2h42hchznxzv5302'),(3,'App\\Models\\User','01kezhvcqx766hwnxq837g5h8g'),(4,'App\\Models\\User','01kezhxspjyjzx07f7brb4kved'),(5,'App\\Models\\User','01kezhz9k93epjv47dw5fmr5gm'),(6,'App\\Models\\User','01kezj0a8q6nyqqa8xyc8vj7fp'),(3,'App\\Models\\User','01kezj74wpsw485qe09tdrcrzc'),(4,'App\\Models\\User','01kezj89bg6mppyvhscjdwqxmc'),(6,'App\\Models\\User','01kezj96ztmfb7tyd22kqhhxh8'),(5,'App\\Models\\User','01kezja5y9v6qkghstzbqpwv6z'),(3,'App\\Models\\User','01kezjsesbastjpkm2m8tjcaxt'),(4,'App\\Models\\User','01kezjtjvm61z3fcxbckp602te'),(5,'App\\Models\\User','01kezjvt84577398xsybfnnzkf'),(6,'App\\Models\\User','01kezjwsbq3djm1vankbj7vqh7'),(3,'App\\Models\\User','01kezjxvba0z2dr7vnttbwnr4f'),(4,'App\\Models\\User','01kezjysw4ghp9nawfme1605c5'),(5,'App\\Models\\User','01kezjzrvegnszp5qsyhy78v6q'),(6,'App\\Models\\User','01kezk0n2d15y17gjfmxct5twk'),(3,'App\\Models\\User','01kezk1v1tvgr4cm49c2x3e1t9'),(4,'App\\Models\\User','01kezk2x42qs2ggfw7t16nvmmb'),(5,'App\\Models\\User','01kezk3xxekfxdw5h2yy1s1wab'),(6,'App\\Models\\User','01kezk4xf7ht2jt48ca2yece7j'),(3,'App\\Models\\User','01kezk6807bn877xs70t5rp77x'),(4,'App\\Models\\User','01kezk7ccmxygxd29gjjv4y0q4'),(5,'App\\Models\\User','01kezk8c53zcd35qz5nd1g8ttp'),(6,'App\\Models\\User','01kezk9kb9b0fdx79tdkkdg0r6'),(3,'App\\Models\\User','01kezkanzs4ajbyft0d4n0sv04'),(4,'App\\Models\\User','01kezkbq1p90av2e3a49ddegfv'),(5,'App\\Models\\User','01kezkcmfx5nknbt72jgkn2gsr'),(6,'App\\Models\\User','01kezkdhjhqpmmh1e2vazxpq3d'),(2,'App\\Models\\User','01kezkygchwmgr282ree6fnnxn'),(3,'App\\Models\\User','01kezmke2eas43dmhys57gxw3s'),(4,'App\\Models\\User','01kezmmnecmpv0gsaq5cw9w2aq'),(5,'App\\Models\\User','01kezmns4w2k9knmg0b4w5f060'),(6,'App\\Models\\User','01kezmpschgtg7hhb28gc1hzsh'),(7,'App\\Models\\User','01kf2ha6kdp9cng1796n5eqm4f'),(2,'App\\Models\\User','01kf64r74v8fc6kngvppnmeftk'),(3,'App\\Models\\User','01kf653w5j4bj951pa0mpk6x5x'),(7,'App\\Models\\User','01kf84am833kpphvp3g9ztssq3'),(7,'App\\Models\\User','01kf84eefz509rz60j6xsyhgmf'),(7,'App\\Models\\User','01kf84fgpxfwy40h1a3mmk502n'),(7,'App\\Models\\User','01kf84gsxf2h44hb0zpkvv59we'),(7,'App\\Models\\User','01kf84j703y7pwtm4hgf41pdf6'),(7,'App\\Models\\User','01kf84k65h2h0a5gcseyacp55w'),(3,'App\\Models\\User','01kg1qz9q704r260cfm7d3npr7');
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pakets`
--

DROP TABLE IF EXISTS `pakets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pakets` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `prk_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `unit_id` bigint unsigned DEFAULT NULL,
  `uraian_paket` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `tahun` int DEFAULT NULL,
  `dokumen_skk` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `nomor_skk` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tanggal_skk` date DEFAULT NULL,
  `nilai_skk` double DEFAULT NULL,
  `status_paket` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pakets_nomor_skk_unique` (`nomor_skk`),
  KEY `pakets_prk_id_foreign` (`prk_id`),
  KEY `pakets_unit_id_foreign` (`unit_id`),
  CONSTRAINT `pakets_prk_id_foreign` FOREIGN KEY (`prk_id`) REFERENCES `prks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pakets_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pakets`
--

LOCK TABLES `pakets` WRITE;
/*!40000 ALTER TABLE `pakets` DISABLE KEYS */;
INSERT INTO `pakets` VALUES ('01kg66gpw2syj44yf7tvmts4ry','01kg66ax43x87m3mca2vgnegpv',8,'Penguatan Defence Scheme Kalimantan Timur dan Utara',2026,'https://pln.hanafiah.my.id/storage/files/2411/4072_KEU.01.08_F48000000_2025-R.pdf','32/R/AI-OPSIS/I/UIP3B.KAL/2026/UP2BKTKU','2025-11-19',2258285680,'Indikatif','2026-01-30 08:58:11','2026-01-30 09:03:05'),('01kg66k2whsyfttxe125wgg4m7','01kg66ax43x87m3mca2vgnegpv',5,'Penguatan Defence Scheme Kalimantan Selatan dan Tengah',2026,'https://pln.hanafiah.my.id/storage/files/2411/4070_KEU.01.08_F48000000_2025-R.pdf','30/R/AI-OPSIS/I/UIP3B.KAL/2026/UP2BKSKT','2025-11-19',951888000,'Indikatif','2026-01-30 08:59:29','2026-01-30 09:02:36'),('01kg66pkfrwbtn18nzmv95zvzj','01kg66ax43x87m3mca2vgnegpv',7,'Penguatan Defence Scheme Kalimantan Barat',2026,'https://pln.hanafiah.my.id/storage/files/2411/4071_KEU.01.08_F48000000_2025-R.pdf','31/R/AI-OPSIS/I/UIP3B.KAL/2026/UP2BKB','2025-11-19',1680409920,'Indikatif','2026-01-30 09:01:24','2026-01-30 09:01:24'),('01kg684dg5ntpy382dtyg11zc9','01kg681bv32q42pm1x17prekek',1,'Pengadaan dan Pemasangan Transmission Lightning Arrester (TLA) UPT Balikpapan',2026,NULL,'47/R/AI-TRANS/I/UIP3B.KAL/2026','2025-12-19',9999360000,'Indikatif','2026-01-30 09:26:26','2026-01-30 10:06:25'),('01kg69f4r00dmtbg6c2hfk53jb','01kg67y24f6nr3hdbxgv458ybe',1,'Pengadaan dan Pemasangan Transmission Lightning Arrester (TLA) UPT Pontianak',2026,NULL,'50/R/AI-TRANS/I/UIP3B.KAL/2026','2025-12-19',2690688000,'Indikatif','2026-01-30 09:49:46','2026-01-30 10:06:17'),('01kg69jaqeab1mn3q56cek69t1','01kg67wbtsk75pdxh59wnw8et8',1,'Pengadaan dan Pemasangan Transmission Lightning Arrester (TLA) UPT Banjarbaru',2026,NULL,'52/R/AI-TRANS/I/UIP3B.KAL/2026','2025-12-19',2558075520,'Indikatif','2026-01-30 09:51:30','2026-01-30 10:06:08'),('01kg69mm0s0kd7jnnaxpgqdkzh','01kg67tk2c45qeth9p1aemxwzy',1,'Pengadaan dan Pemasangan Transmission Lightning Arrester (TLA) UPT Palangkaraya',2026,NULL,'54/R/AI-TRANS/I/UIP3B.KAL/2026','2025-12-19',4852323168,'Indikatif','2026-01-30 09:52:45','2026-01-30 10:05:59'),('01kg6bmhgyrq8g7xq0er3bp0e9','01kg6bj9mderw5x3eqmsw1xc79',6,'Penggantian Relay MPU BPU Trafo UPT Palangkaraya',2026,NULL,'029/R/AI-TRANS/I/UIP3B.KAL/2026/UPTPKY','2025-11-13',1906240000,'Indikatif','2026-01-30 10:27:40','2026-01-30 10:27:40'),('01kg8tc02hg5jtbbj7zqnrt1m4','01kg8tac17fehcj3r0ts6m4ft7',2,'Penggantian PMT 275 KV GITET Bengkayang (Jasa)',2026,NULL,'003/R/AI-TRANS/I/UIP3B.KAL/2026/UPTPTK','2025-11-10',229171595,'Indikatif','2026-01-31 09:23:37','2026-01-31 09:23:37'),('01kg8tjfjb5h6wbp9anxzbce3b','01kg8tgzxv7q2kr57zfdb4xzrv',3,'Penggantian MTU P0 UPT Banjarbaru (Jasa)',2026,NULL,'59/R/AI-TRANS/I/UIP3B.KAL/2026/UPTBJB','2025-12-23',1732168583,'Indikatif','2026-01-31 09:27:10','2026-01-31 09:27:10'),('01kg8trg9k0zpqjnr1tv2s2gz9','01kg8tpjw8dxbhqh0aa151p1pb',4,'Pengadaan dan Pemasangan Isolator Polimer UPT Balikpapan',2026,NULL,'012/R/AI-TRANS/I/UIP3B.KAL/2026/UPTBPP','2025-11-10',894600000,'Indikatif','2026-01-31 09:30:27','2026-01-31 09:30:27');
/*!40000 ALTER TABLE `pakets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pembayarans`
--

DROP TABLE IF EXISTS `pembayarans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pembayarans` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `kontrak_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `termin_pembayaran` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `denda` decimal(15,2) DEFAULT NULL,
  `nilai_tagihan` decimal(15,2) DEFAULT NULL,
  `nilai_akb` decimal(15,2) DEFAULT NULL,
  `bulan_tahun_akb` date DEFAULT NULL,
  `nilai_ppn` decimal(15,2) DEFAULT NULL,
  `nilai_pph` decimal(15,2) DEFAULT NULL,
  `nilai_bayar_vendor` decimal(15,2) DEFAULT NULL,
  `nilai_bayar_pajak` decimal(15,2) DEFAULT NULL,
  `rencana_bayar` date DEFAULT NULL,
  `realisasi_bayar` date DEFAULT NULL,
  `rencana_bayar_pajak` date DEFAULT NULL,
  `realisasi_bayar_pajak` date DEFAULT NULL,
  `sub_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `berkas` tinyint(1) NOT NULL DEFAULT '0',
  `vendor_upload_vip` tinyint(1) NOT NULL DEFAULT '0',
  `maker` tinyint(1) NOT NULL DEFAULT '0',
  `checker` tinyint(1) NOT NULL DEFAULT '0',
  `tax` tinyint(1) NOT NULL DEFAULT '0',
  `sptjp` tinyint(1) NOT NULL DEFAULT '0',
  `ira_irs` tinyint(1) NOT NULL DEFAULT '0',
  `verifikator_pusat` tinyint(1) NOT NULL DEFAULT '0',
  `lunas_vendor` tinyint(1) NOT NULL DEFAULT '0',
  `lunas_pajak` tinyint(1) NOT NULL DEFAULT '0',
  `keterangan` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pembayarans_kontrak_id_foreign` (`kontrak_id`),
  CONSTRAINT `pembayarans_kontrak_id_foreign` FOREIGN KEY (`kontrak_id`) REFERENCES `kontraks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pembayarans`
--

LOCK TABLES `pembayarans` WRITE;
/*!40000 ALTER TABLE `pembayarans` DISABLE KEYS */;
INSERT INTO `pembayarans` VALUES ('01kg8v9p5wjfb0xdd22wqyyss2','01kg8v1p4swczaxnn0nvcrc77k','1',0.00,50000000.00,50000000.00,'2026-01-01',5000000.00,500000.00,44500000.00,5500000.00,'2026-01-30','2026-01-31','2026-01-31',NULL,NULL,1,1,1,1,1,1,1,1,1,0,NULL,'2026-01-31 09:39:50','2026-01-31 09:39:50');
/*!40000 ALTER TABLE `pembayarans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'manage-users','web','Manage user accounts','2025-12-07 18:48:30','2025-12-07 18:48:30'),(2,'view-users','web','View user accounts','2025-12-07 18:48:30','2025-12-07 18:48:30'),(3,'edit-profile','web','Edit own profile','2025-12-07 18:48:30','2025-12-07 18:48:30'),(4,'ban-users','web','Ban/suspend user accounts','2025-12-07 18:48:30','2025-12-07 18:48:30'),(5,'access-dashboard','web','Access admin dashboard','2025-12-07 18:48:30','2025-12-07 18:48:30'),(6,'manage-settings','web','Manage system settings','2025-12-07 18:48:30','2025-12-07 18:48:30'),(7,'manage-security-settings','web','Manage system security settings','2025-12-07 18:48:30','2025-12-07 18:48:30'),(8,'view-audits','web','View system audit logs','2025-12-07 18:48:30','2025-12-07 18:48:30'),(9,'manage-backups','web','Create and manage system backups','2025-12-07 18:48:30','2025-12-07 18:48:30'),(10,'manage-personalization','web','Manage system appearance and branding','2025-12-07 18:48:30','2025-12-07 18:48:30'),(11,'manage-roles','web','Manage user roles','2025-12-07 18:48:30','2025-12-07 18:48:30'),(12,'manage-permissions','web','Manage user permissions','2025-12-07 18:48:30','2025-12-07 18:48:30'),(13,'view-permissions-roles','web','View permissions and roles','2025-12-07 18:48:30','2025-12-07 18:48:30'),(14,'view-login-history','web','View user login history','2025-12-07 18:48:30','2025-12-07 18:48:30'),(15,'manage-prk','web','-','2026-01-13 04:22:14','2026-01-13 04:49:19'),(16,'manage-paket','web','-','2026-01-13 04:22:34','2026-01-13 04:49:48'),(17,'manage-enjiniring','web','-','2026-01-13 04:22:55','2026-01-13 04:49:52'),(18,'access-perencanaan','web','-','2026-01-13 04:29:03','2026-01-13 04:49:57'),(19,'access-pengadaan','web','-','2026-01-13 04:42:33','2026-01-13 04:50:01'),(20,'manage-rendan','web','-','2026-01-13 04:42:50','2026-01-13 04:50:06'),(21,'manage-lakdan','web','-','2026-01-13 04:42:59','2026-01-13 04:50:13'),(22,'manage-kontrak','web','-','2026-01-13 04:43:11','2026-01-13 04:50:19'),(23,'manage-konstruksi','web','-','2026-01-13 04:45:25','2026-01-13 04:50:24'),(24,'manage-pembayaran','web','-','2026-01-13 04:45:38','2026-01-13 04:50:31'),(25,'access-system-settings','web','-','2026-01-13 04:46:46','2026-01-13 04:50:36'),(26,'manage-monitoring','web','-','2026-01-16 11:56:13','2026-01-16 11:56:13'),(27,'access-manager','web','-','2026-01-16 11:56:55','2026-01-16 11:56:55');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personalisations`
--

DROP TABLE IF EXISTS `personalisations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personalisations` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `app_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `app_logo` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `app_logo_dark` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `favicon` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `copyright_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personalisations`
--

LOCK TABLES `personalisations` WRITE;
/*!40000 ALTER TABLE `personalisations` DISABLE KEYS */;
INSERT INTO `personalisations` VALUES ('01kc10yc9vpp7nwtqmqdm7vhwn','Monitoring','personalisation/1768294844_Logo_PLN.png',NULL,NULL,NULL,'2025-12-08 23:41:48','2026-01-13 17:00:44');
/*!40000 ALTER TABLE `personalisations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prks`
--

DROP TABLE IF EXISTS `prks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prks` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `tahun` year DEFAULT NULL,
  `prk` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `fungsi` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `uraian` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `user_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `unit_id` bigint unsigned DEFAULT NULL,
  `bidang_id` bigint unsigned DEFAULT NULL,
  `ai_rupiah` decimal(16,4) DEFAULT NULL,
  `dokumen_kkp` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tanggal_kkp` date DEFAULT NULL,
  `file_kkp` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ulasan_kajian_risiko` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tanggal_ulasan_kajian_risiko` date DEFAULT NULL,
  `file_kajian_risiko` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dokumen_grc` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tanggal_dokumen_grc` date DEFAULT NULL,
  `file_grc` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tanggal_tvv` date DEFAULT NULL,
  `status_persetujuan_tvv` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dokumen_tvv` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `file_tvv` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dokumen_skai` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `nomor_skai` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tanggal_skai` date DEFAULT NULL,
  `nilai_skai` decimal(16,4) DEFAULT NULL,
  `jumlah_paket` smallint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prks_prk_unique` (`prk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prks`
--

LOCK TABLES `prks` WRITE;
/*!40000 ALTER TABLE `prks` DISABLE KEYS */;
INSERT INTO `prks` VALUES ('01kg66ax43x87m3mca2vgnegpv',2026,'2026.P3BK.4.002','Gardu Induk','Penguatan Defense Scheme Kalimantan','Murni','01kbxxrmfnq2m19fmenn91q4qt',NULL,2,4890584.0000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Disetujui',NULL,NULL,NULL,NULL,NULL,NULL,3,'2026-01-30 08:55:01','2026-01-30 08:55:01'),('01kg67tk2c45qeth9p1aemxwzy',2026,'2026.P3BK.1.010','Transmisi','Pengadaan dan Pemasangan Transmission Lightning Arrester (TLA) UPT Palangkaraya','Murni','01kbxxrmfnq2m19fmenn91q4qt',NULL,1,4852323.0000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Disetujui',NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-01-30 09:21:04','2026-01-30 09:21:04'),('01kg67wbtsk75pdxh59wnw8et8',2026,'2026.P3BK.1.012','Transmisi','Pengadaan dan Pemasangan Transmission Lightning Arrester (TLA) UPT Banjarbaru','Murni','01kbxxrmfnq2m19fmenn91q4qt',NULL,1,2558076.0000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Disetujui',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-30 09:22:02','2026-01-30 09:22:02'),('01kg67y24f6nr3hdbxgv458ybe',2026,'2026.P3BK.1.014','Transmisi','Pengadaan dan Pemasangan Transmission Lightning  Arrester (TLA) UPT Pontianak','Murni','01kbxxrmfnq2m19fmenn91q4qt',NULL,1,2690688.0000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Disetujui',NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-01-30 09:22:57','2026-01-30 09:22:57'),('01kg681bv32q42pm1x17prekek',2026,'2026.P3BK.1.018','Transmisi','Pengadaan dan Pemasangan Transmission Lightning Arrester (TLA) UPT Balikpapan','Murni','01kbxxrmfnq2m19fmenn91q4qt',NULL,1,9999360.0000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Disetujui',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-30 09:24:46','2026-01-30 09:24:46'),('01kg6bj9mderw5x3eqmsw1xc79',2026,'2026.P3BK.4.014','Gardu Induk','Penggantian Relay MPU BPU Trafo UPT Palangkaraya','Murni','01kbxxrmfnq2m19fmenn91q4qt',NULL,1,1906240.0000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Disetujui',NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-01-30 10:26:26','2026-01-30 10:26:26'),('01kg8tac17fehcj3r0ts6m4ft7',2026,'2026.P3BK.4.035','Gardu Induk','Penggantian PMT 275 KV GITET Bengkayang','Murni','01kbxxrmfnq2m19fmenn91q4qt',NULL,1,4379374.0000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Disetujui',NULL,NULL,NULL,NULL,NULL,NULL,2,'2026-01-31 09:22:44','2026-01-31 09:22:44'),('01kg8tgzxv7q2kr57zfdb4xzrv',2026,'2026.P3BK.4.013','Gardu Induk','Penggantian MTU P0 UPT Banjarbaru','Murni','01kbxxrmfnq2m19fmenn91q4qt',NULL,1,8924489.0000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Disetujui',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-31 09:26:21','2026-01-31 09:26:21'),('01kg8tpjw8dxbhqh0aa151p1pb',2026,'2026.P3BK.1.017','Transmisi','Pengadaan dan Pemasangan Isolator Polimer UPT Balikpapan','Murni','01kbxxrmfnq2m19fmenn91q4qt',NULL,1,894600000.0000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Disetujui',NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-01-31 09:29:24','2026-01-31 09:29:24');
/*!40000 ALTER TABLE `prks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_orders`
--

DROP TABLE IF EXISTS `purchase_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_orders` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `kontrak_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `rencana_po` date DEFAULT NULL,
  `realisasi_po` date DEFAULT NULL,
  `dokumen_po` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_mos` date DEFAULT NULL,
  `realisasi_mos` date DEFAULT NULL,
  `dokumen_pemeriksaan_mos` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `rencana_progress_25` date DEFAULT NULL,
  `realisasi_progress_25` date DEFAULT NULL,
  `ba_pemeriksaan_25` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ba_pembayaran_25` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'BA Pembayaran Progress 25%',
  `rencana_progress_50` date DEFAULT NULL,
  `realisasi_progress_50` date DEFAULT NULL,
  `ba_pemeriksaan_50` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ba_pembayaran_50` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'BA Pembayaran Progress 50%',
  `rencana_progress_75` date DEFAULT NULL,
  `realisasi_progress_75` date DEFAULT NULL,
  `ba_pemeriksaan_75` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ba_pembayaran_75` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT 'BA Pembayaran Progress 75%',
  `rencana_cod` date DEFAULT NULL,
  `realisasi_cod` date DEFAULT NULL,
  `ba_stp` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ba_stap` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `progress_terkini` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT 'Progress dalam persen (Cth: 25.50)',
  `keterangan` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_orders_kontrak_id_foreign` (`kontrak_id`),
  CONSTRAINT `purchase_orders_kontrak_id_foreign` FOREIGN KEY (`kontrak_id`) REFERENCES `kontraks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_orders`
--

LOCK TABLES `purchase_orders` WRITE;
/*!40000 ALTER TABLE `purchase_orders` DISABLE KEYS */;
INSERT INTO `purchase_orders` VALUES ('01kg8v7e6mmq26x97beazh0147','01kg8v1p4swczaxnn0nvcrc77k','2026-01-26','2026-01-28',NULL,'2026-01-28','2026-01-30',NULL,'2026-01-30','2026-01-31',NULL,NULL,'2026-02-06',NULL,NULL,NULL,'2026-02-13',NULL,NULL,NULL,'2026-02-20',NULL,NULL,NULL,25.00,NULL,'2026-01-31 09:38:36','2026-01-31 09:38:36');
/*!40000 ALTER TABLE `purchase_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rendans`
--

DROP TABLE IF EXISTS `rendans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rendans` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `enjiniring_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `dokumen_nd_user` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `nomor_nd_user` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tanggal_nd_user` date DEFAULT NULL,
  `rab` decimal(16,4) DEFAULT NULL,
  `nilai_hpe` decimal(15,2) DEFAULT NULL,
  `dokumen_hpe` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dokumen_rks` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `nomor_rks` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `tanggal_rks` date DEFAULT NULL,
  `target_tanggal_rks` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rendans_enjiniring_id_index` (`enjiniring_id`),
  CONSTRAINT `rendans_enjiniring_id_foreign` FOREIGN KEY (`enjiniring_id`) REFERENCES `enjinirings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rendans`
--

LOCK TABLES `rendans` WRITE;
/*!40000 ALTER TABLE `rendans` DISABLE KEYS */;
INSERT INTO `rendans` VALUES ('01kg6c673xw1743pehbvqa4vv9','01kg6bnt77xkpq79pf9n85et74','https://pln.hanafiah.my.id/storage/files/tes file.pdf','0027/TRS.01.03/SM REN/2026','2026-01-08',NULL,1847777342.00,'https://pln.hanafiah.my.id/storage/files/tes file.pdf','https://pln.hanafiah.my.id/storage/files/tes file.pdf',NULL,'2026-01-13','2026-01-22','2026-01-30 10:37:19','2026-01-30 10:37:19');
/*!40000 ALTER TABLE `rendans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_has_permissions`
--

DROP TABLE IF EXISTS `role_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_has_permissions`
--

LOCK TABLES `role_has_permissions` WRITE;
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
INSERT INTO `role_has_permissions` VALUES (1,2),(2,2),(3,2),(4,2),(5,2),(6,2),(7,2),(8,2),(9,2),(10,2),(11,2),(12,2),(13,2),(14,2),(15,2),(16,2),(17,2),(18,2),(19,2),(20,2),(21,2),(22,2),(23,2),(24,2),(25,2),(26,2),(27,2),(15,3),(16,3),(17,3),(18,3),(19,4),(20,4),(21,4),(22,4),(23,5),(24,6),(26,7),(27,7);
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (2,'superuser','web','Superuser with full system access','2025-12-07 18:48:30','2025-12-07 18:48:30'),(3,'Perencanaan','web',NULL,'2026-01-13 04:14:14','2026-01-13 04:14:14'),(4,'Pengadaan','web',NULL,'2026-01-13 04:14:49','2026-01-13 04:14:49'),(5,'Konstruksi','web',NULL,'2026-01-13 04:15:29','2026-01-13 04:15:29'),(6,'Pembayaran','web',NULL,'2026-01-13 04:15:48','2026-01-13 04:15:48'),(7,'Manager','web',NULL,'2026-01-16 11:55:53','2026-01-16 11:55:53');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('5YWgiTweYriPGfILclAwCxsMNicB3l7RChvmUkiB',NULL,'103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiNTh6VTRhS2UzaUpZVVJZcWl5OUNWRjJOUWhrcmI2cTl3ZWhiNnVTbCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzI6Imh0dHBzOi8vcGxuLmhhbmFmaWFoLm15LmlkL2xvZ2luIjtzOjU6InJvdXRlIjtzOjU6ImxvZ2luIjt9czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czoyNjoiaHR0cHM6Ly9wbG4uaGFuYWZpYWgubXkuaWQiO319',1770345876),('k6YoUILM6Hio8AVrr3ExbYFaTKelEEw9mfuDYKru',NULL,'103.170.89.253','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoidkFpamV3elprNkpXU0NEbUd6Q09GQ2U1eFJ2TGk4dlFJczU4V3E4QiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czoyNjoiaHR0cHM6Ly9wbG4uaGFuYWZpYWgubXkuaWQiO31zOjk6Il9wcmV2aW91cyI7YToyOntzOjM6InVybCI7czozMjoiaHR0cHM6Ly9wbG4uaGFuYWZpYWgubXkuaWQvbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1770345884);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `password_expiry` tinyint(1) NOT NULL DEFAULT '0',
  `passwordless_login` tinyint(1) NOT NULL DEFAULT '0',
  `two_factor_authentication` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES ('01kbxxrkf27p1ncvvgj0y8mdxh',0,0,0,'2025-12-07 18:48:30','2025-12-07 18:48:30');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_notices`
--

DROP TABLE IF EXISTS `system_notices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_notices` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_dismissible` tinyint(1) NOT NULL DEFAULT '0',
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'info',
  `visible_from` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_by` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `system_notices_created_by_foreign` (`created_by`),
  CONSTRAINT `system_notices_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_notices`
--

LOCK TABLES `system_notices` WRITE;
/*!40000 ALTER TABLE `system_notices` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_notices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `units` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `name` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `units_name_unique` (`name`),
  UNIQUE KEY `units_kode_unique` (`kode`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,'2401','UIP3B Kalimantan','2025-12-15 02:00:12',NULL),(2,'2411','UPT Pontianak','2025-12-15 02:00:12',NULL),(3,'2412','UPT Banjarbaru','2026-01-13 03:44:17',NULL),(4,'2413','UPT Balikpapan','2026-01-13 03:44:17',NULL),(5,'2421','UP2B Kalselteng','2026-01-13 03:45:29',NULL),(6,'2425','UPT Palangkaraya','2026-01-13 03:45:29',NULL),(7,'2426','UP2B Kalbar','2026-01-13 03:46:07',NULL),(8,'2427','UP2B Kaltimra','2026-01-13 03:46:07',NULL);
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(26) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_slug` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `unit_id` bigint unsigned DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `two_factor_secret` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `two_factor_recovery_codes` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `force_password_change` tinyint(1) NOT NULL DEFAULT '0',
  `disable_account` tinyint(1) NOT NULL DEFAULT '0',
  `profile_image_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT 'avatar',
  `locale` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'en',
  `last_login_at` timestamp NULL DEFAULT NULL,
  `last_login_ip` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `password_changed_at` timestamp NULL DEFAULT NULL,
  `password_expiry_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_user_slug_unique` (`user_slug`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_unit_id_foreign` (`unit_id`),
  CONSTRAINT `users_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('01kbxxrmfnq2m19fmenn91q4qt','Super Admin','user-WtAnZjactq4f','super@admin.com',NULL,'2025-12-07 18:48:31','$2y$12$65uouXmeWRt8Af2GbvxaPulcuxg1kK.zXJ3OZEdmFM1Tu9wSs40UK',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-07 18:48:31','2026-01-13 05:35:39'),('01ketxs5xa2h42hchznxzv5302','Perencanaan Kalimantan','user-gaYy3hXdPYIL','perencanaan@example.com',1,NULL,'$2y$12$ZjsebT9KASgXY1DAIv7cbuUyZ20ZAXQtBt01/MIlImyYuucl.i5vy',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,'2026-01-14 17:49:45','2026-01-13 05:38:11','2026-01-14 17:49:45'),('01kezhvcqx766hwnxq837g5h8g','REN-UP2BKTKU','user-nphf2IRzcTlf','ren.up2bktku@test.com',8,NULL,'$2y$12$bYKUAOUgP/5sMVD2OIoWmu9NkOIdDf.yfV3AhRlKotOi4DjYjPpJa',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 08:45:53','2026-01-15 08:45:53'),('01kezhxspjyjzx07f7brb4kved','DAN-UP2BKTKU','user-WpL0EsMDoAuE','dan.up2bktku@test.com',8,NULL,'$2y$12$t0cw40TDJ/6GOdv9QmYwdu9DnvG5c1A3XwhidfLpS0stP0Sl6WMye',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 08:47:12','2026-01-15 08:47:12'),('01kezhz9k93epjv47dw5fmr5gm','KON-UP2BKTKU','user-ushUYwmrG1I0','kon.up2bktku@test.com',8,NULL,'$2y$12$SdYW06qYCzMFc/XNbP36Xeu60qFljlso8rFhMMIvScUUpNMGV19dO',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 08:48:01','2026-01-15 08:48:01'),('01kezj0a8q6nyqqa8xyc8vj7fp','KEU-UP2BKTKU','user-AaBNM3YF8OUJ','keu.up2bktku@test.com',8,NULL,'$2y$12$NSBVwGe0r1OHztQuN/g93.i/FliCyxHGkU86IzHNk0s0Pn7EvKB.O',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 08:48:34','2026-01-15 08:48:34'),('01kezj74wpsw485qe09tdrcrzc','REN-UP2BKB','user-4eban9Ytn7jU','ren.up2bkb@test.com',7,NULL,'$2y$12$GJhZWGwpbkfIRntOHgRjSO0TUqRcVip9T7A93pRsrrFmRILP7quGa',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 08:52:18','2026-01-15 08:52:18'),('01kezj89bg6mppyvhscjdwqxmc','DAN-UP2BKB','user-qd1JDejFOO7s','dan.up2bkb@test.com',7,NULL,'$2y$12$kmDL2EVh0dp/Heg4YUosKuJnw9vv4b/U7Hp3n1etrybChzam9k2.2',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 08:52:55','2026-01-15 08:52:55'),('01kezj96ztmfb7tyd22kqhhxh8','KEU-UP2BKB','user-NIBi1E8Q3dbf','keu.up2bkb@test.com',7,NULL,'$2y$12$0jFDTfI/IIiqQSZbJzN65OjoaOs2n3UuoepDBRRECRMeUR0hIGDg.',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 08:53:26','2026-01-15 08:53:26'),('01kezja5y9v6qkghstzbqpwv6z','KON-UP2BKB','user-VqUKh1upb5Yh','kon.up2bkb@test.com',7,NULL,'$2y$12$V3fFDkQuSEJt2ovfGXb9CegwfhcMKcBpA5LPAiA432olbDDqc916q',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 08:53:57','2026-01-15 08:53:57'),('01kezjsesbastjpkm2m8tjcaxt','REN-UP2BKSKT','user-OCZwumORpCfG','ren.up2bkskt@test.com',5,NULL,'$2y$12$A3NuXzvJWA6BBODLkPIwQej1KkOrYaUibfOgNDis8fNMj5iWMbdDO',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:02:18','2026-01-15 09:02:18'),('01kezjtjvm61z3fcxbckp602te','DAN-UP2BKSKT','user-mTAtFqfqmxVy','dan.up2bkskt@test.com',5,NULL,'$2y$12$LlgdzVHu15q8Ig7qpzoJ0uZdBzhKPKcLh3zf/rad9d/.au/fLWkoW',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:02:55','2026-01-15 09:02:55'),('01kezjvt84577398xsybfnnzkf','KON-UP2BKSKT','user-bQSYgObOf8cr','kon.up2bkskt@test.com',5,NULL,'$2y$12$ajRQF.y1C971NGSzn4FB.urKVde05UiCyyYjBZydiU9O82/Q7uOam',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:03:35','2026-01-15 09:03:35'),('01kezjwsbq3djm1vankbj7vqh7','KEU-UP2BKSKT','user-TjjGwRCovc1p','keu.up2bkskt@test.com',5,NULL,'$2y$12$/TfPkCqveEBX9wBVcFQLAeb27Iq0z7myoehf9oivE9hz.zJ3Z1Dqm',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:04:07','2026-01-15 09:04:07'),('01kezjxvba0z2dr7vnttbwnr4f','REN-UPTBJB','user-oUsRba1gnZKQ','ren.uptbjb@test.com',3,NULL,'$2y$12$74MGSN.nevyHcdzcbCk/ouQCcY/2C/KLorgNa0KWKE3ekU3NSBN2a',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:04:42','2026-01-15 09:04:42'),('01kezjysw4ghp9nawfme1605c5','DAN-UPTBJB','user-6U8sIupRPqCp','dan.uptbjb@test.com',3,NULL,'$2y$12$nKTYqr0wOA5aVtwNTiVyMuC83STP/xxfitYqsBiO6FqC.W7Z23GR.',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:05:13','2026-01-15 09:05:13'),('01kezjzrvegnszp5qsyhy78v6q','KON-UPTBJB','user-HbFLagjpkas8','kon.uptbjb@test.com',3,NULL,'$2y$12$qj7UJ0NkUHSQKbQPfP7ua.EChpCwupMNoEYpE.Of0sme406HK.O5q',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:05:45','2026-01-15 09:05:45'),('01kezk0n2d15y17gjfmxct5twk','KEU-UPTBJB','user-kf24S8oBBWJZ','keu.uptbjb@test.com',3,NULL,'$2y$12$EMe9jtjgG1BGEAQtb3Zl7ej8Jvkff3acQgrosxBysmpJUifMgoFJm',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:06:14','2026-01-15 09:06:14'),('01kezk1v1tvgr4cm49c2x3e1t9','REN-UPTBPP','user-So7VMBM22uqz','ren.uptbpp@test.com',4,NULL,'$2y$12$khKm.Te7gvCtjeTEBtmmSOQF//k8IjfDoh7VfMIjizOcTiB2ZPbbO',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:06:53','2026-01-15 09:06:53'),('01kezk2x42qs2ggfw7t16nvmmb','DAN-UPTBPP','user-0e172xtYM9pI','dan.uptbpp@test.com',4,NULL,'$2y$12$FN0Oya7O367bB5yF1PIohO9F6XPMEW3mKpjLH9jiXOW4G7eUiySs.',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:07:28','2026-01-15 09:07:28'),('01kezk3xxekfxdw5h2yy1s1wab','KON-UPTBPP','user-0BwEXhJcK4C2','kon.uptbpp@test.com',4,NULL,'$2y$12$3fK/GCCgICCJQcj0gxdQy.Bly2RlgNO7Sfjb2dSQyw6Mg2DquYrPi',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:08:01','2026-01-15 09:08:01'),('01kezk4xf7ht2jt48ca2yece7j','KEU-UPTBPP','user-GJ4v1s9fbxf9','keu.uptbpp@test.com',4,NULL,'$2y$12$XQmErQRM0X1KuGpRwarpp.J2pRiCr5UEqxV4YpLukP6DmFIgayewy',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:08:33','2026-01-15 09:08:33'),('01kezk6807bn877xs70t5rp77x','REN-UPTPTK','user-ZwYJvuMf1fxT','ren.uptptk@test.com',2,NULL,'$2y$12$Gbbji4SMan4Ai6eA247Z8.SkMO9hNvZVr0NYiQcUy2/G5vpgzelL6',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:09:17','2026-01-15 09:09:17'),('01kezk7ccmxygxd29gjjv4y0q4','DAN-UPTPTK','user-34XcN3BtvB6o','dan.uptptk@test.com',2,NULL,'$2y$12$SFdbJkxZg/7Vs2oSZ81y1.OAeyWCGsvIkTCf5IaReUSMXgudqIH7i',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:09:54','2026-01-15 09:09:54'),('01kezk8c53zcd35qz5nd1g8ttp','KON-UPTPTK','user-iEXnhU8Ooe0c','kon.uptptk@test.com',2,NULL,'$2y$12$6oL30OG9TpDTUNvOYDaCr.rQMkW5RvqcAPeV2e7PrICrEEerAcPmu',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:10:27','2026-01-15 09:10:27'),('01kezk9kb9b0fdx79tdkkdg0r6','KEU-UPTPTK','user-Tijvy9k7XxkQ','keu.uptptk@test.com',2,NULL,'$2y$12$a8as4cy58nMyAjYq/Y/1i.AR.oteVFvdfqdgTzWXIq1/gUZXu4Pt.',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:11:07','2026-01-15 09:11:07'),('01kezkanzs4ajbyft0d4n0sv04','REN-UPTPKY','user-Uw4kJKK4OTju','ren.uptpky@test.com',6,NULL,'$2y$12$LXzsnAAi4TAbkAF38dNzXeHyZnM2m1lxvongHA.esy75YRHMiUcay',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:11:42','2026-01-15 09:11:42'),('01kezkbq1p90av2e3a49ddegfv','DAN-UPTPKY','user-u5KYkPT06dHJ','dan.uptpky@test.com',6,NULL,'$2y$12$0Qt/FI3ExYK/4qB5g86GNO7A5.1uoMDmR/gZWyMansJgHI2.lSSXi',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:12:16','2026-01-15 09:12:16'),('01kezkcmfx5nknbt72jgkn2gsr','KON-UPTPKY','user-5a7hWmQE0maV','kon.uptpky@test.com',6,NULL,'$2y$12$wLE/bLotxPIvrKr0KdMLzeqFlPEUiGsZ7eDhsK7.M.mSNQ3DTLra.',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:12:46','2026-01-15 09:12:46'),('01kezkdhjhqpmmh1e2vazxpq3d','KEU-UPTPKY','user-Nc4RKkG5Xjqu','keu.uptpky@test.com',6,NULL,'$2y$12$gedShBDGR1D3hAdHSu8oM.BccRLBNTQMamebGTXxSJrd.iQRyQbSG',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:13:16','2026-01-15 09:13:16'),('01kezkygchwmgr282ree6fnnxn','MAN-UP2BKTKU','user-RAcjIMXk8VCW','man.up2bktku@test.com',8,NULL,'$2y$12$fpWp0qYfv6e5wGE/PUoDQeY8RFR1Ct/xe3ITd2SW49xkfhObRWDOm',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:33:10','2026-01-15 09:22:32','2026-01-15 09:33:10'),('01kezmke2eas43dmhys57gxw3s','REN-UIP3BKAL','user-tcvoyUsSmwue','ren.uip3bkal@test.com',1,NULL,'$2y$12$j9/mmj6AEVoH3PqXTmB5pegVNzUiHpfukb75jJsn1oQvy3qIJgdt.',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:33:58','2026-01-15 09:33:58'),('01kezmmnecmpv0gsaq5cw9w2aq','DAN-UIP3BKAL','user-XQ2UccFGNnE3','dan.uip3bkal@test.com',1,NULL,'$2y$12$wi/s.aD9aNK2DKoAFPaKEeWa9PsUeGX5D4rO/O5Llt46OuMUwh1aC',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:34:38','2026-01-15 09:34:38'),('01kezmns4w2k9knmg0b4w5f060','KON-UIP3BKAL','user-S5U5ePlomhgn','kon.uip3bkal@test.com',1,NULL,'$2y$12$DCFCKNoRFVkpJde4rsSO0e3uKz5VX6Tvrg/q9DFdHXnyxf0hCyV3i',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:35:15','2026-01-15 09:35:15'),('01kezmpschgtg7hhb28gc1hzsh','KEU-UIP3BKAL','user-u2j5oELXyToq','keu.uip3bkal@test.com',1,NULL,'$2y$12$F8kzVVlddDrcvQ481nz7heQ3wCVHWy0uwM9QMiO5HqXsQ/wY1sXYO',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-15 09:35:48','2026-01-15 09:35:48'),('01kf2ha6kdp9cng1796n5eqm4f','Manager','user-dbdeCXcZ8vds','test@manager.com',7,NULL,'$2y$12$0n99xIXnc4zXa7QxbjD/e.IZiD9RjIvURGzzETMtLStiztl1HX3.2',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,'2026-01-16 12:40:42','2026-01-16 12:34:13','2026-01-16 12:40:42'),('01kf64r74v8fc6kngvppnmeftk','sayyid','user-vHrLFDKgcHKj','sayyid@gmail.com',6,NULL,'$2y$12$0.qdMWjkN1Je8QDa.8rPY.DuvBnZivPT/OHwmUxbZta1crK0bbQa2',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-17 22:11:38','2026-01-17 22:11:38'),('01kf653w5j4bj951pa0mpk6x5x','sayyid2','user-XLO5zbQfOkUj','tes@tes.com',3,NULL,'$2y$12$DNZXHFk2Em2e89gBSoHGQulMiw/rJz8F6GdFaJl6QtrJD.P29a7VS',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,'2026-01-17 22:19:38','2026-01-17 22:18:00','2026-01-17 22:19:38'),('01kf84am833kpphvp3g9ztssq3','MAN-UP2BKSKT','user-wDwGgDzdCQgk','man.up2bkskt@test.com',5,NULL,'$2y$12$uTqI8MlmfNtN0YzzgxaflufQk7GNsxLPqGnFcygAEwLEE7EE.HlnS',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-18 16:42:42','2026-01-18 16:44:15'),('01kf84eefz509rz60j6xsyhgmf','MAN-UP2BKB','user-1Yaqk2F9t6Kg','man.up2bkb@test.com',7,NULL,'$2y$12$/uSSoUDZ/Ee0hQA82ZZJ0eUIeYc5tJe/rkLCv0ZnCm5zRdTYp3FgW',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-18 16:44:47','2026-01-18 16:44:47'),('01kf84fgpxfwy40h1a3mmk502n','MAN-UPTBPP','user-7xofEscwLUpw','man.uptbpp@test.com',4,NULL,'$2y$12$d.H.rwIZpXFRvPW0BrHorucQ5V/GzL0xCIZEu4KjnZBujGLarj3GC',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-18 16:45:22','2026-01-18 16:45:22'),('01kf84gsxf2h44hb0zpkvv59we','MAN-UPTBJB','user-ITP6MVpMhUNh','man.uptbjb@test.com',3,NULL,'$2y$12$GZOU59fBc7S4uD8S0g00Z.vK1JRhwejB85atc.GZupHZqobgw14.e',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-18 16:46:04','2026-01-18 16:46:04'),('01kf84j703y7pwtm4hgf41pdf6','MAN-UPTPTK','user-rpSG2FczrbBm','man.uptptk@test.com',2,NULL,'$2y$12$nnab3M1uZmt5wK08K9DvX.SYIyYGsw17h8JyfDweoedwXHyEhpeja',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-18 16:46:50','2026-01-18 16:46:50'),('01kf84k65h2h0a5gcseyacp55w','MAN-UPTPKY','user-pebLrdsDsnex','man.uptpky@test.com',6,NULL,'$2y$12$ufW8Di9vRwJsb08ewZPf5.fTcFrgMG19J7VEh37cFRm4GwasR18SW',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-18 16:47:22','2026-01-18 16:47:22'),('01kg1qz9q704r260cfm7d3npr7','tes prk','user-m984SapvB0H4','tesuser',1,NULL,'$2y$12$VlqlrZU/oKUoOHJPfVi5QOXDSb3b/xoXB6ZNTCE3u4PhfIX1c3wHi',NULL,NULL,NULL,0,0,'avatar','en',NULL,NULL,NULL,NULL,NULL,'2026-01-28 15:48:01','2026-01-28 15:27:03','2026-01-28 15:48:01');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'app_pln'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-06 14:05:43
