-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3307
-- Generation Time: May 20, 2019 at 06:18 AM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteReserv` (IN `_ReservID` INT)  NO SQL
DELETE FROM reservation
WHERE reservation.reserveid = _ReservID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeliverItem` (IN `_Reserv` INT)  NO SQL
UPDATE reservation
SET reservation.itemOut = 1
WHERE reservation.reserveid = _Reserv$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllReservations` ()  NO SQL
SELECT item.listed as "Listed", 
item.ItemStatus AS "Status",
reservation.reserveid AS 'ResName',
reservation.ReceiptID, 
reservation.checkin AS 'Return_Date',
reservation.checkout AS 'Checkout_Date', 
reservation.itemid AS 'Item_ID', CONCAT(userinfo.lastname, ", ", userinfo.firstname) AS Name, 
CONCAT(userinfo.address, ", ", userinfo.city, ", ", userinfo.zip) AS Address, userinfo.phone AS 'Phone_Number', 
IF(reservation.pickup = 1, 'Yes', 'No') AS 'Pickup',
IF(reservation.itemOut =1, 'Delivered', 'Undelivered') AS 'Delivered'  FROM (((reservation
INNER JOIN Receipt ON receipt.ReceiptID = reservation.ReceiptID)
INNER JOIN Userinfo ON receipt.UserID = userinfo.UserID) 
INNER JOIN item ON item.itemID = reservation.itemid)
ORDER BY reservation.checkout$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAvailItemsByType` (IN `_Type` VARCHAR(45), IN `_Library` VARCHAR(45), IN `_IsAdmin` INT)  NO SQL
BEGIN
SET @ItemTypeID = (SELECT itemtype.itemtypeid FROM itemtype 
                   WHERE _Type = itemtype.TypeName);
SELECT item.itemID FROM item
WHERE @ItemTypeID = item.itemtypeid AND item.listed >= _IsAdmin AND item.ItemStatus = 'available' AND item.itemID LIKE CONCAT(_Library, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDeliveryTable` (IN `_Library` VARCHAR(45))  NO SQL
SELECT item.listed as "Listed", 
item.ItemStatus AS "Status",
reservation.reserveid AS 'ResName',
reservation.ReceiptID, 
reservation.checkin AS 'Return_Date',
reservation.checkout AS 'Checkout_Date', 
reservation.itemid AS 'Item_ID', CONCAT(userinfo.lastname, ", ", userinfo.firstname) AS Name, 
CONCAT(userinfo.address, ", ", userinfo.city, ", ", userinfo.zip) AS Address, userinfo.phone AS 'Phone_Number', 
IF(reservation.pickup = 1, 'Yes', 'No') AS 'Pickup',
IF(reservation.itemOut =1, 'Delivered', 'Undelivered') AS 'Delivered' 
FROM (((reservation
INNER JOIN Receipt ON receipt.ReceiptID = reservation.ReceiptID)
INNER JOIN Userinfo ON receipt.UserID = userinfo.UserID)
INNER JOIN Item ON reservation.itemid = item.itemID)
WHERE checkOut <= DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY) AND checkOut > DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY) AND item.itemID LIKE CONCAT(_Library, '%')
ORDER BY reservation.checkin$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetItemsByType` (IN `_Type` VARCHAR(45), IN `_Library` VARCHAR(45))  NO SQL
SELECT * FROM item
WHERE _Type = item.itemtypeid AND item.itemID LIKE CONCAT(_Library, '%')
ORDER BY LENGTH(item.itemID), item.itemID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetItemsDue` (IN `_Library` VARCHAR(45))  NO SQL
SELECT reservation.reserveid AS ResName,
reservation.ReceiptID, reservation.checkIn AS Due_Date, reservation.itemid AS Item_ID, CONCAT(userinfo.lastname, ", ", userinfo.firstname) AS Name, CONCAT(userinfo.address, ", ", userinfo.city, ", ", userinfo.zip) AS Address, userinfo.phone AS 'Phone_Number', usertable.Email FROM ((reservation
INNER JOIN Receipt ON receipt.ReceiptID = reservation.ReceiptID)
INNER JOIN Userinfo ON receipt.UserID = userinfo.UserID
INNER JOIN usertable ON usertable.UserID = userinfo.UserID)
WHERE checkin <= DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY) AND reservation.itemout = 1 AND itemID LIKE CONCAT(_Library, '%')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetItemTypes` ()  NO SQL
SELECT itemtype.TypeName AS "ItemType", itemtype.itemTypeID AS "TypeID" FROM itemtype$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetKitNames` ()  NO SQL
SELECT KitName, KitID FROM Kit$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetLibrary` (IN `_Library` VARCHAR(3))  NO SQL
SELECT DISTINCT ItemType.* FROM ItemType
JOIN item
ON ItemType.itemTypeID = item.itemtypeid
WHERE item.itemID LIKE CONCAT(_Library, '%') AND item.Listed = 1 AND item.itemStatus = 'available'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMediaTypes` ()  NO SQL
SELECT DISTINCT itemtype.media AS media FROM itemtype$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetNewReceipt` (IN `_UserName` VARCHAR(45))  NO SQL
BEGIN 
SET @UserID = (SELECT UserID FROM usertable
      WHERE UserName = _UserName);

INSERT INTO receipt (UserID)
VALUES(@UserID);

SELECT MAX(ReceiptID) FROM receipt
WHERE userID = @UserID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTypeID` (IN `_TypeName` VARCHAR(45))  NO SQL
SELECT itemtype.itemTypeID from itemtype
WHERE itemtype.TypeName = _TypeName$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserItemsDue` (IN `_Library` VARCHAR(45), IN `_UserID` INT)  NO SQL
SELECT reservation.reserveid AS ResName, 
IF(reservation.itemid LIKE 'KSC%', 'Kansas City Library', 'Kansas Library') AS 'Library',
reservation.ReceiptID, reservation.checkIn AS Due_Date, reservation.checkout as 'checkout', reservation.itemid AS Item_ID FROM ((reservation
INNER JOIN Receipt ON receipt.ReceiptID = reservation.ReceiptID)
INNER JOIN Userinfo ON receipt.UserID = userinfo.UserID
INNER JOIN usertable ON usertable.UserID = userinfo.UserID)
WHERE checkin <= CURRENT_DATE AND reservation.itemout = 1 AND itemID LIKE CONCAT(_Library, '%') AND usertable.UserID = _UserID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserOldReserv` (IN `_UserID` INT)  NO SQL
SELECT reservation.reserveid AS ResName, 
IF(reservation.itemid LIKE 'KSC%', 'Kansas City Library', 'Kansas Library') AS 'Library',
reservation.ReceiptID, reservation.checkIn AS Due_Date, reservation.checkout as 'checkout', reservation.itemid AS Item_ID FROM ((reservation
INNER JOIN Receipt ON receipt.ReceiptID = reservation.ReceiptID)
INNER JOIN Userinfo ON receipt.UserID = userinfo.UserID
INNER JOIN usertable ON usertable.UserID = userinfo.UserID)
WHERE checkin < CURRENT_DATE AND reservation.itemout = 0 AND usertable.UserID = _UserID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserReserv` (IN `_User` INT)  NO SQL
SELECT reservation.reserveid AS 'ReservID', reservation.itemid AS 'Item', reservation.checkout AS 'checkout', reservation.checkin AS 'checkin', IF(reservation.pickup = 1, 'Yes', 'No') AS 'pickup' FROM (reservation
INNER JOIN Receipt ON receipt.ReceiptID = reservation.ReceiptID)
WHERE receipt.UserID = _User AND reservation.itemOut = 0 AND reservation.checkout > CURRENT_DATE
ORDER BY reservation.checkout$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemLegalForDate` (IN `_Item` VARCHAR(45), IN `_Out` DATE, IN `_In` DATE)  NO SQL
SELECT
  item.itemID
FROM
  item
WHERE
  itemid = _Item
  AND NOT EXISTS (
    SELECT
      *
    FROM
      reservation
    WHERE
      reservation.itemid = _Item
      AND (
        (
          reservation.checkout BETWEEN DATE_ADD(_Out, INTERVAL -1 DAY)
          AND DATE_ADD(_In, INTERVAL 1 DAY)
        )
        OR (
          reservation.checkin BETWEEN DATE_ADD(_Out, INTERVAL -1 DAY)
          AND DATE_ADD(_In, INTERVAL 1 DAY)
        )
        OR (
          _In BETWEEN DATE_ADD(reservation.checkout, INTERVAL -1 DAY)
          AND DATE_ADD(reservation.checkin, INTERVAL 1 DAY)
        )
      )
  )$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LastItemOfType` (IN `_TypeID` INT, IN `_Library` VARCHAR(45))  NO SQL
SELECT MAX(CAST(REGEXP_SUBSTR(itemID, '[0-9].*') AS INTEGER)) AS 'Last'
FROM item
WHERE _TypeID = item.itemtypeid
      AND item.itemID LIKE CONCAT(_Library, '%')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Login` (IN `_UserName` VARCHAR(45), IN `_Password` VARCHAR(255))  NO SQL
SELECT usertable.UserID, userinfo.IsAdmin, userinfo.FirstName, userinfo.LastName FROM usertable
INNER JOIN userinfo ON usertable.UserID = userinfo.UserID
WHERE Username = _UserName AND UserPass = PASSWORD(_Password)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewItem` (IN `_ItemID` VARCHAR(45), IN `_TypeName` VARCHAR(45), IN `_Listed` INT)  NO SQL
INSERT INTO item (itemID, itemTypeid, ItemStatus, listed)
VALUES (_ItemID, (SELECT itemTypeID FROM itemtype WHERE TypeName = _TypeName LIMIT 1), 1, _Listed)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewItemType` (IN `_Name` VARCHAR(45), IN `_Desc` VARCHAR(255), IN `_Media` VARCHAR(45), IN `_Subject` VARCHAR(45), IN `_Listed` TINYINT)  NO SQL
    COMMENT 'In Progress'
INSERT INTO itemtype (TypeName, description, media, TypeSubject) 
VALUES (_Name, _Desc, _Media, _Subject)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewKit` (IN `_KitName` VARCHAR(45))  NO SQL
INSERT INTO Kit (KitName)
VALUES (_KitName)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewKitRelation` (IN `_KitName` VARCHAR(45), IN `_TypeName` VARCHAR(45))  NO SQL
INSERT INTO kitrelation (KitID, ItemTypeID)
VALUES ((SELECT KitID FROM kit WHERE KitName = _KitName), (SELECT itemTypeID FROM itemType WHERE TypeName = _TypeName))$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewReservation` (IN `_ItemID` VARCHAR(45), IN `_CheckIn` DATE, IN `_CheckOut` DATE, IN `_Pickup` INT, IN `_ReceiptID` INT)  NO SQL
BEGIN
INSERT INTO reservation (ItemID, CheckIn, CheckOut, Pickup, ReceiptID)
VALUES (_ItemID, _CheckIn, _CheckOut, _Pickup, _ReceiptID);

SELECT * FROM reservation
WHERE reservation.ReceiptID = _ReceiptID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NewUser` (IN `_Username` VARCHAR(45), IN `_UserPass` VARCHAR(255), IN `_Email` VARCHAR(45), IN `_FName` VARCHAR(45), IN `_LName` VARCHAR(45), IN `_Phone` VARCHAR(25), IN `_County` INT UNSIGNED, IN `_Address` VARCHAR(100), IN `_City` VARCHAR(45), IN `_Zip` VARCHAR(20), IN `_Organization` VARCHAR(100))  NO SQL
    COMMENT 'Creates new Non-Admin User'
BEGIN
INSERT INTO UserTable(username, Email, UserPass)
VALUES (_Username, _Email, PASSWORD(_UserPass));

INSERT INTO Userinfo
VALUES ((SELECT userid FROM usertable
WHERE Email = _Email), _FName, _LName, _Phone, _County, _Address, _City, _Zip, _Organization, false, CURRENT_TIMESTAMP);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReturnItem` (IN `_Reserved` INT)  NO SQL
UPDATE reservation
SET reservation.itemOut = 0
WHERE reservation.reserveid = _Reserved$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateItem` (IN `_ItemID` VARCHAR(45), IN `_Listed` BOOLEAN, IN `_Avail` BOOLEAN)  NO SQL
UPDATE item
SET item.ItemStatus = IF(_Avail, 1, 0),
	item.listed = IF(_Listed, 1, 0)
WHERE item.itemID = _ItemID$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `itemID` varchar(15) NOT NULL,
  `itemtypeid` int(11) NOT NULL,
  `ItemStatus` enum('available','unavailable') DEFAULT NULL,
  `listed` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`itemID`, `itemtypeid`, `ItemStatus`, `listed`) VALUES
('KSCBearPelt1', 6, 'available', 1),
('KSCBearPelt10', 6, 'available', 1),
('KSCBearPelt11', 6, 'available', 1),
('KSCBearPelt12', 6, 'available', 1),
('KSCBearPelt13', 6, 'available', 1),
('KSCBearPelt14', 6, 'available', 1),
('KSCBearPelt15', 6, 'available', 1),
('KSCBearPelt2', 6, 'available', 1),
('KSCBearPelt3', 6, 'available', 1),
('KSCBearPelt4', 6, 'available', 1),
('KSCBearPelt5', 6, 'available', 1),
('KSCBearPelt6', 6, 'available', 1),
('KSCBearPelt7', 6, 'available', 1),
('KSCBearPelt8', 6, 'available', 1),
('KSCBearPelt9', 6, 'available', 1),
('KSCTestItem2', 1, 'available', 1),
('KSCTestItem3', 1, 'available', 1),
('KSCTestItem4', 1, 'available', 1),
('KSCTestItem42', 3, 'available', 1),
('KSCTestItem43', 3, 'available', 1),
('KSCTestItem444', 3, 'available', 1),
('KSCTestItem445', 3, 'available', 1),
('KSCTestItem446', 3, 'available', 1),
('KSCTestItem447', 3, 'available', 1),
('KSCTestItem448', 3, 'available', 1),
('KSCTestItem5', 1, 'available', 1),
('KSCTestItem6', 1, 'available', 1),
('KSCTestItem7', 1, 'available', 1),
('KSLAbB1', 19, 'available', 1),
('KSLAbB10', 19, 'available', 1),
('KSLAbB11', 19, 'available', 1),
('KSLAbB12', 19, 'available', 1),
('KSLAbB2', 19, 'available', 1),
('KSLAbB3', 19, 'available', 1),
('KSLAbB4', 19, 'available', 1),
('KSLAbB5', 19, 'available', 1),
('KSLAbB6', 19, 'available', 1),
('KSLAbB7', 19, 'available', 1),
('KSLAbB8', 19, 'available', 1),
('KSLAbB9', 19, 'available', 1),
('KSLPenguins1', 18, 'available', 1),
('KSLPenguins10', 18, 'available', 1),
('KSLPenguins11', 18, 'available', 1),
('KSLPenguins12', 18, 'available', 1),
('KSLPenguins2', 18, 'available', 1),
('KSLPenguins3', 18, 'available', 1),
('KSLPenguins4', 18, 'available', 1),
('KSLPenguins5', 18, 'available', 1),
('KSLPenguins6', 18, 'available', 1),
('KSLPenguins7', 18, 'available', 1),
('KSLPenguins8', 18, 'available', 1),
('KSLPenguins9', 18, 'available', 1),
('KSLTestItem1', 1, 'available', 1),
('KSLTestItem181', 5, 'available', 1),
('KSLTestItem41', 3, 'available', 1),
('TestItem8', 1, 'available', 1);

-- --------------------------------------------------------

--
-- Table structure for table `itemtype`
--

CREATE TABLE `itemtype` (
  `itemTypeID` int(11) NOT NULL,
  `TypeName` varchar(45) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `media` varchar(45) DEFAULT NULL,
  `TypeSubject` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `itemtype`
--

INSERT INTO `itemtype` (`itemTypeID`, `TypeName`, `description`, `media`, `TypeSubject`) VALUES
(1, 'TestItem', 'ItemDesc', 'Hands on', 'SubjectHere'),
(2, 'TestItem3', 'ItemDesc', 'Poster', 'SubjectHere'),
(3, 'TestItem4', 'ItemDesc', 'Book', 'SubjectHere'),
(4, 'TestItem5', 'ItemDesc', 'Poster', 'SubjectHere'),
(5, 'TestItem18', 'ItemDesc', 'Hands on', 'SubjectHere'),
(6, 'BearPelt', 'Bear Hide', 'Hands on', 'Mammals');

-- --------------------------------------------------------

--
-- Table structure for table `kit`
--

CREATE TABLE `kit` (
  `KitID` int(11) NOT NULL,
  `KitName` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kit`
--

INSERT INTO `kit` (`KitID`, `KitName`) VALUES
(1, 'FirstTestKit'),
(5, 'TestKit18'),
(2, 'TestKit2'),
(3, 'TestKit3');

-- --------------------------------------------------------

--
-- Table structure for table `kitrelation`
--

CREATE TABLE `kitrelation` (
  `kitid` int(11) NOT NULL,
  `itemtypeid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kitrelation`
--

INSERT INTO `kitrelation` (`kitid`, `itemtypeid`) VALUES
(3, 3),
(5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `receipt`
--

CREATE TABLE `receipt` (
  `receiptid` int(11) NOT NULL,
  `checkoutrequest` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UserID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `receipt`
--

INSERT INTO `receipt` (`receiptid`, `checkoutrequest`, `UserID`) VALUES
(2, '2019-05-06 18:35:47', 1),
(3, '2019-05-12 04:16:46', 1),
(4, '2019-05-12 04:19:29', 1),
(5, '2019-05-12 04:20:15', 1),
(6, '2019-05-12 04:20:31', 1),
(7, '2019-05-13 19:19:30', 10),
(8, '2019-05-13 19:21:15', 10),
(9, '2019-05-13 19:23:13', 10),
(10, '2019-05-13 20:08:00', 10),
(11, '2019-05-13 21:11:47', 10),
(12, '2019-05-13 21:15:20', 10),
(13, '2019-05-13 21:15:45', 10),
(14, '2019-05-13 21:16:12', 10),
(15, '2019-05-13 22:10:58', 11),
(16, '2019-05-14 21:02:47', 12),
(17, '2019-05-14 21:11:58', 12),
(18, '2019-05-16 04:26:15', 10),
(19, '2019-05-16 04:26:24', 10),
(20, '2019-05-16 04:26:36', 10),
(21, '2019-05-16 04:40:20', 10),
(22, '2019-05-17 21:38:01', 10),
(23, '2019-05-17 21:40:04', 10),
(24, '2019-05-17 21:52:01', 10),
(25, '2019-05-18 00:05:53', 10),
(26, '2019-05-18 00:17:51', 10),
(27, '2019-05-19 01:58:38', 10),
(28, '2019-05-20 04:14:30', 10);

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `reserveid` int(11) NOT NULL,
  `itemid` varchar(15) NOT NULL,
  `ReceiptID` int(11) NOT NULL,
  `itemOut` tinyint(4) DEFAULT '0',
  `checkout` date NOT NULL,
  `checkin` date NOT NULL,
  `pickup` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`reserveid`, `itemid`, `ReceiptID`, `itemOut`, `checkout`, `checkin`, `pickup`) VALUES
(3, 'KSCTestItem2', 2, 1, '2019-05-07', '2019-05-30', 0),
(4, 'KSCTestItem2', 9, 1, '2019-12-13', '2019-12-30', 1),
(5, 'KSCTestItem42', 9, 1, '2019-06-15', '2019-07-01', 1),
(6, 'KSCTestItem3', 10, 1, '2019-12-13', '2019-12-30', 1),
(7, 'KSCTestItem43', 10, 1, '2019-06-15', '2019-07-01', 1),
(8, 'KSCTestItem3', 11, 0, '2019-05-08', '2019-05-08', 1),
(9, 'KSCTestItem4', 12, 1, '2019-05-08', '2019-05-08', 1),
(10, 'KSCTestItem5', 13, 1, '2019-05-08', '2019-05-08', 1),
(11, 'KSCTestItem6', 14, 0, '2019-05-08', '2019-05-08', 1),
(12, 'KSCTestItem7', 15, 0, '2019-05-01', '2019-05-30', 1),
(13, 'KSCTestItem42', 15, 0, '2020-12-12', '2020-12-30', 1),
(14, 'KSCTestItem2', 16, 0, '2019-05-17', '0000-00-00', 0),
(15, 'KSCTestItem42', 17, 0, '2019-05-17', '0000-00-00', 1),
(16, 'KSCTestItem3', 18, 0, '2019-05-20', '2019-06-03', 0),
(17, 'KSCTestItem42', 18, 0, '2019-05-28', '2019-06-11', 1),
(18, 'KSCTestItem4', 19, 0, '2019-05-20', '2019-06-03', 0),
(19, 'KSCTestItem43', 19, 0, '2019-05-28', '2019-06-11', 1),
(23, 'KSCTestItem2', 22, 0, '2019-07-04', '2019-07-18', 0),
(24, 'KSCTestItem2', 23, 0, '2019-06-10', '2019-06-24', 1),
(25, 'KSCTestItem7', 24, 0, '2019-06-04', '2019-06-18', 0),
(26, 'KSCTestItem3', 25, 0, '2019-07-09', '2019-07-23', 1),
(28, 'KSCBearPelt1', 27, 0, '2019-05-31', '2019-06-14', 0),
(29, 'KSCBearPelt1', 28, 0, '2019-07-16', '2019-07-30', 0);

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
  `IsAdmin` tinyint(1) DEFAULT '0',
  `Creation_Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userinfo`
--

INSERT INTO `userinfo` (`UserID`, `FirstName`, `LastName`, `Phone`, `County`, `Address`, `City`, `Zip`, `Organization`, `IsAdmin`, `Creation_Date`) VALUES
(2, 'Test', 'User', '3314444444', 'Allen', 'Here', 'There', '66062', 'Lost World', 0, '2019-05-15 12:51:33'),
(3, 'Test', 'User', '3314444444', 'Stevens', 'Here', 'There', '66062', '', 0, '2019-05-15 12:51:33'),
(5, 'Test', 'User', '3314444444', 'Allen', 'Here', 'There', '66062', '', 0, '2019-05-15 12:51:33'),
(6, 'Frank', 'Frank', '123123123', 'Anderson', 'Test', 'Test', '11111', 'Frank', 0, '2019-05-15 12:51:33'),
(7, 'Jennifer', 'McLane', '5555555555', 'Johnson', '123 Some Pl.', 'Olathe', '66063', 'Space...', 0, '2019-05-15 12:51:33'),
(10, 'Paul', 'McLane', '5555555555', 'Chase', '1000 Thyme Square', 'Chase City', '55555', '', 0, '2019-05-15 12:51:33'),
(11, 'Han', 'Solo', '5555555555', 'Chase', '1000 Thyme Square', 'Chase City', '55555', 'Falcon Enterprises', 0, '2019-05-15 12:51:33'),
(12, 'alaine', 'hudlin', '913-209-0207', 'Johnson', '26325 W 135th St', 'Olathe', '66061', 'KDWPT Prairie Center', 1, '2019-05-15 12:51:33'),
(16, 'Test', 'McTest', '555-555-5555', 'Coffey', '1023 Thyme Square', 'Coffey', '55555', '', 0, '2019-05-19 20:59:30');

-- --------------------------------------------------------

--
-- Table structure for table `usertable`
--

CREATE TABLE `usertable` (
  `UserID` int(11) NOT NULL,
  `Username` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `UserPass` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `usertable`
--

INSERT INTO `usertable` (`UserID`, `Username`, `Email`, `UserPass`) VALUES
(1, 'admin', 'admin@email.com', '*81F5E21E35407D884A6CD4A731AEBFB6AF209E1B'),
(2, 'newUser', 'email@email.com', '*81F5E21E35407D884A6CD4A731AEBFB6AF209E1'),
(3, 'root411', 'emaila@email.com', '*94BDCEBE19083CE2A1F959FD02F964C7AF4CFC2'),
(5, 'root6000', 'email@email.coma', '*00E247AC5F9AF26AE0194B41E1E769DEE1429A2'),
(6, 'Frank', 'test@test.com', '*3C6A72D8F593E76DF0C646264B572750E6BD4C2'),
(7, 'jmclane', 'jfrnchorn@mail.com', '*FBA7C2D27C9D05F3FD4C469A1BBAF557114E5594'),
(10, 'pmclane', 'pmclane@mail.com', '*6FC13CAA9F43CA6F74B384A993727632E63AE970'),
(11, 'hansolo', 'hsolo@mail.com', '*6FC13CAA9F43CA6F74B384A993727632E63AE970'),
(12, 'alaine', 'alaine.hudlin@ks.gov', '*03455D846B4414AFFC51C41BB3722FD570EA7473'),
(15, 'testUserAb', 'test@testa.com', '*6FC13CAA9F43CA6F74B384A993727632E63AE970'),
(16, 'BetaMax', 'test@test1a.com', '*6FC13CAA9F43CA6F74B384A993727632E63AE970');

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
  ADD KEY `Library` (`listed`);

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
  ADD PRIMARY KEY (`receiptid`),
  ADD KEY `UserID` (`UserID`);

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
  MODIFY `itemTypeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `kit`
--
ALTER TABLE `kit`
  MODIFY `KitID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `receipt`
--
ALTER TABLE `receipt`
  MODIFY `receiptid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `reserveid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `usertable`
--
ALTER TABLE `usertable`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

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
-- Constraints for table `receipt`
--
ALTER TABLE `receipt`
  ADD CONSTRAINT `UserID_FK` FOREIGN KEY (`UserID`) REFERENCES `usertable` (`UserID`);

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
