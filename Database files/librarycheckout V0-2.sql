-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3307
-- Generation Time: Apr 17, 2019 at 07:20 PM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.1.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `librarycheckout`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetKitName` ()  NO SQL
SELECT KitName, KitID FROM Kit$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewItem` (IN `_ItemID` VARCHAR(13), IN `_TypeName` VARCHAR(45), IN `_Listed` INT)  NO SQL
INSERT INTO item (itemID, itemTypeid, ItemStatus, listed)
VALUES (_ItemID, (SELECT itemTypeID FROM itemtype WHERE TypeName = _TypeName LIMIT 1), 1, _Listed)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewItemType` (IN `_Name` VARCHAR(45), IN `_Desc` VARCHAR(255), IN `_Media` INT, IN `_Subject` INT(45), IN `_Listed` BOOLEAN)  NO SQL
    COMMENT 'In Progress'
BEGIN
INSERT INTO itemtype (TypeName, description, media, TypeSubject) 
VALUES (_Name, _Desc, _Media, _Subject); 

INSERT INTO item (itemTypeID, listed) 
VALUES ((SELECT itemTypeID 
         FROM itemtype 
         WHERE description = _Desc), _Listed);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewKit` (IN `_KitName` VARCHAR(45))  NO SQL
INSERT INTO Kit (KitName)
VALUES (_KitName)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewKitRelation` (IN `_KitID` INT, IN `_TypeName` VARCHAR(45))  NO SQL
INSERT INTO kitrelation (KitID, ItemTypeID)
VALUES (_KitID, (SELECT itemTypeID FROM itemType WHERE TypeName = _TypeName))$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewReceipt` ()  NO SQL
    SQL SECURITY INVOKER
    COMMENT 'Create new Receipt'
INSERT INTO receipt(CheckoutRequest)
VALUE (CURRENT_TIMESTAMP)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewUser` (IN `_Username` VARCHAR(45), IN `_UserPass` VARCHAR(40), IN `_Email` VARCHAR(45), IN `_FName` VARCHAR(45), IN `_LName` VARCHAR(45), IN `_Phone` VARCHAR(25), IN `_County` INT UNSIGNED, IN `_Address` VARCHAR(100), IN `_City` VARCHAR(45), IN `_Zip` VARCHAR(20), IN `_Organization` VARCHAR(100))  NO SQL
    COMMENT 'Creates new Non-Admin User'
BEGIN
INSERT INTO UserTable(username, Email, UserPass)
VALUES (_Username, _Email, PASSWORD(_UserPass));

INSERT INTO Userinfo
VALUES ((SELECT userid FROM usertable
WHERE Email = _Email), _FName, _LName, _Phone, _County, _Address, _City, _Zip, _Organization, false);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `itemID` varchar(15) NOT NULL,
  `itemtypeid` int(11) NOT NULL,
  `Library` enum('KS','KSC') NOT NULL,
  `ItemStatus` enum('available','unavailable') DEFAULT NULL,
  `listed` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `itemtype`
--

CREATE TABLE `itemtype` (
  `itemTypeID` int(11) NOT NULL,
  `TypeName` varchar(45) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `media` enum('book','poster','hands on','audio') DEFAULT NULL,
  `TypeSubject` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `kit`
--

CREATE TABLE `kit` (
  `KitID` int(11) NOT NULL,
  `KitName` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `kitrelation`
--

CREATE TABLE `kitrelation` (
  `kitid` int(11) NOT NULL,
  `itemtypeid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `receipt`
--

CREATE TABLE `receipt` (
  `receiptid` int(11) NOT NULL,
  `checkoutrequest` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `reserveid` int(11) NOT NULL,
  `itemid` varchar(15) NOT NULL,
  `ReceiptID` int(11) NOT NULL,
  `itemOut` tinyint(1) DEFAULT '1',
  `checkout` date NOT NULL,
  `checkin` date NOT NULL,
  `pickup` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `userinfo`
--

CREATE TABLE `userinfo` (
  `UserID` int(11) NOT NULL,
  `FirstName` varchar(45) NOT NULL,
  `LastName` varchar(45) NOT NULL,
  `Phone` varchar(25) NOT NULL,
  `County` enum('Allen','Anderson','Atchison','Barber','Barton','Bourbon','Brown','Butler','Chase','Chautauqua','Cherokee','Cheyenne','Clark','Clay','Cloud','Coffey','Comanche','Cowley','Crawford','Decatur','Dickinson','Doniphan','Douglas','Edwards','Elk','Ellis','Ellsworth','Finney','Ford','Franklin','Geary','Gove','Graham','Grant','Gray','Greeley','Greenwood','Hamilton','Harper','Harvey','Haskell','Hodgeman','Jackson','Jefferson','Jewell','Johnson','Kearny','Kingman','Kiowa','Labette','Lane','Leavenworth','Lincoln','Linn','Logan','Lyon','Marion','Marshall','McPherson','Meade','Miami','Mitchell','Montgomery','Morris','Morton','Nemaha','Neosho','Ness','Norton','Osage','Osborne','Ottawa','Pawnee','Phillips','Pottawatomie','Pratt','Rawlins','Reno','Republic','Rice','Riley','Rooks','Rush','Russell','Saline','Scott','Sedgwick','Seward','Shawnee','Sheridan','Sherman','Smith','Stafford','Stanton','Stevens','Sumner','Thomas','Trego','Wabaunsee','Wallace','Washington','Wichita','Wilson','Woodson','Wyandotte') NOT NULL,
  `Address` varchar(100) NOT NULL,
  `City` varchar(45) NOT NULL,
  `Zip` varchar(20) NOT NULL,
  `Organization` varchar(100) NOT NULL,
  `IsAdmin` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userinfo`
--

INSERT INTO `userinfo` (`UserID`, `FirstName`, `LastName`, `Phone`, `County`, `Address`, `City`, `Zip`, `Organization`, `IsAdmin`) VALUES
(1, 'Philip', 'McLane', '913-555-5545', 'Johnson', '1234 Some Pl', 'Olathe', '66061', 'Project Alpha', 1);

-- --------------------------------------------------------

--
-- Table structure for table `usertable`
--

CREATE TABLE `usertable` (
  `UserID` int(11) NOT NULL,
  `Username` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `UserPass` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `usertable`
--

INSERT INTO `usertable` (`UserID`, `Username`, `Email`, `UserPass`) VALUES
(1, 'admin', 'admin@email.com', '*81F5E21E35407D884A6CD4A731AEBFB6AF209E1');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`itemID`),
  ADD KEY `itemtypeid` (`itemtypeid`),
  ADD KEY `ItemStatus` (`ItemStatus`),
  ADD KEY `Library` (`Library`,`listed`);

--
-- Indexes for table `itemtype`
--
ALTER TABLE `itemtype`
  ADD PRIMARY KEY (`itemTypeID`);

--
-- Indexes for table `kit`
--
ALTER TABLE `kit`
  ADD PRIMARY KEY (`KitID`),
  ADD UNIQUE KEY `KitName` (`KitName`);

--
-- Indexes for table `kitrelation`
--
ALTER TABLE `kitrelation`
  ADD PRIMARY KEY (`kitid`,`itemtypeid`),
  ADD KEY `itemtypeid` (`itemtypeid`);

--
-- Indexes for table `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`receiptid`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`reserveid`),
  ADD KEY `ReceiptID` (`ReceiptID`),
  ADD KEY `itemid` (`itemid`);

--
-- Indexes for table `userinfo`
--
ALTER TABLE `userinfo`
  ADD PRIMARY KEY (`UserID`);

--
-- Indexes for table `usertable`
--
ALTER TABLE `usertable`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `itemtype`
--
ALTER TABLE `itemtype`
  MODIFY `itemTypeID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kit`
--
ALTER TABLE `kit`
  MODIFY `KitID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `receipt`
--
ALTER TABLE `receipt`
  MODIFY `receiptid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `reserveid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `usertable`
--
ALTER TABLE `usertable`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kitrelation`
--
ALTER TABLE `kitrelation`
  ADD CONSTRAINT `kitrelation_ibfk_1` FOREIGN KEY (`itemtypeid`) REFERENCES `itemtype` (`itemTypeID`),
  ADD CONSTRAINT `kitrelation_ibfk_2` FOREIGN KEY (`kitid`) REFERENCES `kit` (`KitID`);

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`ReceiptID`) REFERENCES `receipt` (`receiptid`),
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`itemid`) REFERENCES `item` (`itemID`);

--
-- Constraints for table `userinfo`
--
ALTER TABLE `userinfo`
  ADD CONSTRAINT `userinfo_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `usertable` (`UserID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
