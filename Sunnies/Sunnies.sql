-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3308
-- Generation Time: Nov 21, 2020 at 05:37 AM
-- Server version: 8.0.18
-- PHP Version: 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sunnies`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE IF NOT EXISTS `admin` (
  `adminId` int(10) UNSIGNED NOT NULL,
  `name` varchar(30) NOT NULL,
  `loginId` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`adminId`),
  KEY `fk_loginid_admin` (`loginId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`adminId`, `name`, `loginId`) VALUES
(1, 'Tony Henson', 'test2'),
(2, 'Anne Pod', 'test3');

-- --------------------------------------------------------

--
-- Table structure for table `cardinfo`
--

DROP TABLE IF EXISTS `cardinfo`;
CREATE TABLE IF NOT EXISTS `cardinfo` (
  `cardInfoId` int(10) UNSIGNED NOT NULL,
  `cardtype` varchar(10) NOT NULL,
  `cardNo` varchar(16) DEFAULT NULL,
  `expireDate` date NOT NULL,
  PRIMARY KEY (`cardInfoId`),
  UNIQUE KEY `cardNo` (`cardNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `cardinfo`
--

INSERT INTO `cardinfo` (`cardInfoId`, `cardtype`, `cardNo`, `expireDate`) VALUES
(1, 'visa', '1111222233334444', '2023-01-01'),
(2, 'visa', '4444222233334444', '2023-01-01'),
(3, 'master', '3333222233334444', '2023-01-01');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `categoryId` int(4) UNSIGNED NOT NULL,
  `category` varchar(10) NOT NULL,
  `season` varchar(10) NOT NULL,
  PRIMARY KEY (`categoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`categoryId`, `category`, `season`) VALUES
(1, 'sport', 'winter'),
(2, 'sport', 'summer'),
(3, 'sport', 'all');

-- --------------------------------------------------------

--
-- Table structure for table `checkagecountries`
--

DROP TABLE IF EXISTS `checkagecountries`;
CREATE TABLE IF NOT EXISTS `checkagecountries` (
  `countryId` int(5) UNSIGNED NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`countryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `checkagecountries`
--

INSERT INTO `checkagecountries` (`countryId`, `name`) VALUES
(1, 'France'),
(2, 'Spain');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
CREATE TABLE IF NOT EXISTS `customer` (
  `customerId` int(10) UNSIGNED NOT NULL,
  `memberFlag` varchar(10) NOT NULL,
  `title` varchar(4) DEFAULT NULL,
  `firstName` varchar(20) NOT NULL,
  `lastName` varchar(20) NOT NULL,
  `phoneNo` varchar(12) NOT NULL,
  `email` varchar(50) NOT NULL,
  `address` varchar(30) NOT NULL,
  `postLocalId` int(10) UNSIGNED DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `loginId` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`customerId`),
  KEY `fk_postlocalid_customer` (`postLocalId`),
  KEY `fk_loginid_customer` (`loginId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerId`, `memberFlag`, `title`, `firstName`, `lastName`, `phoneNo`, `email`, `address`, `postLocalId`, `dateOfBirth`, `loginId`) VALUES
(1, 'member', 'Mr', 'Peter', 'Last', '0101222333', 'ttt@email.com', '5 moy street', 3, '2002-11-18', 'test1'),
(2, 'member', 'Ms', 'Mary', 'First', '0101222333', 'ttt@email.com', '5 moy street', 3, '2002-11-22', 'cust1'),
(3, 'member', 'Ms', 'Mary', 'First', '0101222333', 'ttt@email.com', '5 moy street', 3, '2002-11-22', 'cust2'),
(4, 'guest', 'Ms', 'Tiny', 'Tony', '0101222333', 'ttt@email.com', '5 moy street', 3, '2002-11-22', NULL);

--
-- Triggers `customer`
--
DROP TRIGGER IF EXISTS `check_customerage`;
DELIMITER $$
CREATE TRIGGER `check_customerage` BEFORE INSERT ON `customer` FOR EACH ROW BEGIN 
    DECLARE msg varchar(255);
    DECLARE v_num int(5);
    
    SET v_num = 0;
    SELECT count(g.country) INTO v_num
    FROM PostLocal l INNER JOIN PostGlobal g 
    ON l.postGlobalId = g.postGlobalID
    WHERE NEW.postLocalId = l.postLocalId 
    AND g.country in (SELECT name FROM CheckAgeCountries); 

    IF ( v_num > 0 ) THEN 
        IF ( NEW.dateOfBirth >  (curdate() - INTERVAL 18 YEAR)) THEN 
            SET msg = "You can register if only your are over 18 years old."; 
            signal SQLSTATE "45000" set MESSAGE_TEXT = msg;
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
CREATE TABLE IF NOT EXISTS `login` (
  `loginId` varchar(15) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`loginId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`loginId`, `password`) VALUES
('cust1', 'cust1'),
('cust2', 'cust2'),
('test1', 'test1'),
('test2', 'test2'),
('test3', 'test3');

-- --------------------------------------------------------

--
-- Table structure for table `material`
--

DROP TABLE IF EXISTS `material`;
CREATE TABLE IF NOT EXISTS `material` (
  `materialId` int(4) UNSIGNED NOT NULL,
  `material` varchar(10) NOT NULL,
  `colour` varchar(10) NOT NULL,
  PRIMARY KEY (`materialId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `material`
--

INSERT INTO `material` (`materialId`, `material`, `colour`) VALUES
(11, 'plastic', 'red'),
(12, 'plastic', 'yellow'),
(21, 'metal', 'gold'),
(22, 'metal', 'silver');

-- --------------------------------------------------------

--
-- Table structure for table `model`
--

DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `modelId` int(5) UNSIGNED NOT NULL,
  `model` varchar(20) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `providerId` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`modelId`),
  KEY `fk_providerid_model` (`providerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `model`
--

INSERT INTO `model` (`modelId`, `model`, `description`, `providerId`) VALUES
(1, 'A1111', 'sport sport', 2),
(2, 'BBBB', 'sport sport', 2),
(3, 'CCCC', 'sport sport', 2);

-- --------------------------------------------------------

--
-- Table structure for table `ordercart`
--

DROP TABLE IF EXISTS `ordercart`;
CREATE TABLE IF NOT EXISTS `ordercart` (
  `orderCartID` int(10) UNSIGNED NOT NULL,
  `orderId` int(10) UNSIGNED DEFAULT NULL,
  `shopCartId` int(5) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`orderCartID`),
  KEY `fk_orderId_ordercart` (`orderId`),
  KEY `fk_shopCartId_ordercart` (`shopCartId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ordercart`
--

INSERT INTO `ordercart` (`orderCartID`, `orderId`, `shopCartId`) VALUES
(1, 1, 111),
(2, 1, 112),
(3, 2, 113),
(4, 2, 114);

-- --------------------------------------------------------

--
-- Table structure for table `orderdetail`
--

DROP TABLE IF EXISTS `orderdetail`;
CREATE TABLE IF NOT EXISTS `orderdetail` (
  `orderDetailId` int(10) UNSIGNED NOT NULL,
  `productId` int(10) UNSIGNED DEFAULT NULL,
  `orderId` int(10) UNSIGNED DEFAULT NULL,
  `quantity` int(5) NOT NULL,
  `paidPrice` decimal(13,4) DEFAULT NULL,
  PRIMARY KEY (`orderDetailId`),
  KEY `fk_productid_orderdetail` (`productId`),
  KEY `fk_orderid_orderdetail` (`orderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orderdetail`
--

INSERT INTO `orderdetail` (`orderDetailId`, `productId`, `orderId`, `quantity`, `paidPrice`) VALUES
(11, 1, 1, 1, '85.0000'),
(12, 2, 1, 1, '170.0000'),
(13, 3, 4, 1, '85.0000'),
(14, 4, 4, 1, '170.0000'),
(15, 3, 2, 1, '85.0000'),
(16, 4, 2, 1, '170.0000');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `orderId` int(10) UNSIGNED NOT NULL,
  `customerId` int(10) UNSIGNED DEFAULT NULL,
  `memberFlag` varchar(10) NOT NULL,
  `orderDate` date NOT NULL,
  `shippedDate` date DEFAULT NULL,
  `paymentId` int(10) UNSIGNED DEFAULT NULL,
  `comment` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`orderId`),
  KEY `fk_customerid_order` (`customerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`orderId`, `customerId`, `memberFlag`, `orderDate`, `shippedDate`, `paymentId`, `comment`) VALUES
(1, 1, 'member', '2020-11-11', '2020-11-14', 1, NULL),
(2, 4, 'guest', '2020-11-15', NULL, 2, NULL),
(3, 4, 'guest', '2020-11-16', NULL, 3, NULL),
(4, 1, 'member', '2020-11-02', '2020-11-12', 5, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
CREATE TABLE IF NOT EXISTS `payment` (
  `paymentId` int(10) UNSIGNED NOT NULL,
  `paymentType` varchar(10) DEFAULT NULL,
  `paidDate` date DEFAULT NULL,
  `cardInfoId` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`paymentId`),
  KEY `fk_cardinfoid_payment` (`cardInfoId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`paymentId`, `paymentType`, `paidDate`, `cardInfoId`) VALUES
(1, 'card', '2020-11-15', 1),
(2, 'cash', '2020-11-20', NULL),
(3, 'card', '2020-11-15', 2),
(5, 'card', '2020-11-02', 1);

-- --------------------------------------------------------

--
-- Table structure for table `postglobal`
--

DROP TABLE IF EXISTS `postglobal`;
CREATE TABLE IF NOT EXISTS `postglobal` (
  `postGlobalId` int(5) UNSIGNED NOT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`postGlobalId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `postglobal`
--

INSERT INTO `postglobal` (`postGlobalId`, `city`, `state`, `country`) VALUES
(11, 'Brisbane', 'Queensland', 'Australia'),
(12, 'Sydney', 'New South Wales', 'Australia'),
(13, 'Paris', NULL, 'France');

-- --------------------------------------------------------

--
-- Table structure for table `postlocal`
--

DROP TABLE IF EXISTS `postlocal`;
CREATE TABLE IF NOT EXISTS `postlocal` (
  `postLocalId` int(10) UNSIGNED NOT NULL,
  `postcode` varchar(10) NOT NULL,
  `suburb` varchar(20) NOT NULL,
  `postGlobalId` int(5) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`postLocalId`),
  KEY `fk_globalId_postlocal` (`postGlobalId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `postlocal`
--

INSERT INTO `postlocal` (`postLocalId`, `postcode`, `suburb`, `postGlobalId`) VALUES
(1, '4068', 'Indooroopilly', 11),
(2, '4000', 'South Brisbane', 11),
(3, '20001', 'Maree', 13),
(4, '2000', 'Opera', 12);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `productId` int(10) UNSIGNED NOT NULL,
  `modelId` int(5) UNSIGNED DEFAULT NULL,
  `categoryId` int(4) UNSIGNED DEFAULT NULL,
  `materialId` int(4) UNSIGNED DEFAULT NULL,
  `price` decimal(13,4) DEFAULT NULL,
  `stock` int(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`productId`),
  KEY `fk_modelid_product` (`modelId`),
  KEY `fk_categoryid_product` (`categoryId`),
  KEY `fk_materialid_product` (`materialId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`productId`, `modelId`, `categoryId`, `materialId`, `price`, `stock`) VALUES
(1, 1, 1, 11, '100.0000', 35),
(2, 1, 1, 22, '200.0000', 10),
(3, 2, 2, 22, '300.0000', 21),
(4, 2, 2, 22, '250.0000', 21),
(5, 2, 2, 22, '250.0000', 21);

-- --------------------------------------------------------

--
-- Table structure for table `productphoto`
--

DROP TABLE IF EXISTS `productphoto`;
CREATE TABLE IF NOT EXISTS `productphoto` (
  `photoId` int(11) UNSIGNED NOT NULL,
  `productId` int(10) UNSIGNED DEFAULT NULL,
  `filepath` varchar(100) NOT NULL,
  PRIMARY KEY (`photoId`),
  KEY `fk_productid_productphoto` (`productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `productphoto`
--

INSERT INTO `productphoto` (`photoId`, `productId`, `filepath`) VALUES
(1, 1, 'img/sunglass_model _A1111.jpg'),
(2, 2, 'img/sunglass_model _234.jpg'),
(3, 3, 'img/sunglass_model _234.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `provider`
--

DROP TABLE IF EXISTS `provider`;
CREATE TABLE IF NOT EXISTS `provider` (
  `providerId` int(10) UNSIGNED NOT NULL,
  `name` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phoneNo` varchar(12) NOT NULL,
  `address` varchar(30) NOT NULL,
  `postLocalId` int(10) UNSIGNED DEFAULT NULL,
  `division` varchar(20) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`providerId`),
  KEY `fk_postlocalid_provider` (`postLocalId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `provider`
--

INSERT INTO `provider` (`providerId`, `name`, `email`, `phoneNo`, `address`, `postLocalId`, `division`, `description`) VALUES
(1, 'Dupon', 'admin@dupon.com.au', '0401000111', 'song street', 4, 'head office', NULL),
(2, 'New Glasses', 'service@email.com.au', '0401000111', 'peter street', 4, 'head office', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `shoppingcart`
--

DROP TABLE IF EXISTS `shoppingcart`;
CREATE TABLE IF NOT EXISTS `shoppingcart` (
  `shopCartId` int(5) UNSIGNED NOT NULL,
  `productID` int(10) UNSIGNED DEFAULT NULL,
  `quantity` int(5) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`shopCartId`),
  KEY `fk_productid_shoppingcart` (`productID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `shoppingcart`
--

INSERT INTO `shoppingcart` (`shopCartId`, `productID`, `quantity`) VALUES
(111, 1, 1),
(112, 2, 1),
(113, 3, 1),
(114, 4, 1);

--
-- Triggers `shoppingcart`
--
DROP TRIGGER IF EXISTS `check_quantity`;
DELIMITER $$
CREATE TRIGGER `check_quantity` BEFORE INSERT ON `shoppingcart` FOR EACH ROW BEGIN 
    DECLARE msg varchar(255);
    DECLARE v_num int(5);
    
    SET v_num = 3;
 
    IF ( NEW.quantity > v_num  ) THEN 
        SET msg = "The number of one time purchase per each item is limited to 3"; 
        signal SQLSTATE "45000" set MESSAGE_TEXT = msg;

    END IF;
END
$$
DELIMITER ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `fk_loginid_admin` FOREIGN KEY (`loginId`) REFERENCES `login` (`loginId`);

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `fk_loginid_customer` FOREIGN KEY (`loginId`) REFERENCES `login` (`loginId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_postlocalid_customer` FOREIGN KEY (`postLocalId`) REFERENCES `postlocal` (`postLocalId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `model`
--
ALTER TABLE `model`
  ADD CONSTRAINT `fk_providerid_model` FOREIGN KEY (`providerId`) REFERENCES `provider` (`providerId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `ordercart`
--
ALTER TABLE `ordercart`
  ADD CONSTRAINT `fk_orderId_ordercart` FOREIGN KEY (`orderId`) REFERENCES `orders` (`orderId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_shopCartId_ordercart` FOREIGN KEY (`shopCartId`) REFERENCES `shoppingcart` (`shopCartId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `orderdetail`
--
ALTER TABLE `orderdetail`
  ADD CONSTRAINT `fk_orderid_orderdetail` FOREIGN KEY (`orderId`) REFERENCES `orders` (`orderId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_productid_orderdetail` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_customerid_order` FOREIGN KEY (`customerId`) REFERENCES `customer` (`customerId`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `fk_cardinfoid_payment` FOREIGN KEY (`cardInfoId`) REFERENCES `cardinfo` (`cardInfoId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `postlocal`
--
ALTER TABLE `postlocal`
  ADD CONSTRAINT `fk_globalId_postlocal` FOREIGN KEY (`postGlobalId`) REFERENCES `postglobal` (`postGlobalId`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `fk_categoryid_product` FOREIGN KEY (`categoryId`) REFERENCES `category` (`categoryId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_materialid_product` FOREIGN KEY (`materialId`) REFERENCES `material` (`materialId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_modelid_product` FOREIGN KEY (`modelId`) REFERENCES `model` (`modelId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `productphoto`
--
ALTER TABLE `productphoto`
  ADD CONSTRAINT `fk_productid_productphoto` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `provider`
--
ALTER TABLE `provider`
  ADD CONSTRAINT `fk_postlocalid_provider` FOREIGN KEY (`postLocalId`) REFERENCES `postlocal` (`postLocalId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `shoppingcart`
--
ALTER TABLE `shoppingcart`
  ADD CONSTRAINT `fk_productid_shoppingcart` FOREIGN KEY (`productID`) REFERENCES `product` (`productId`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
