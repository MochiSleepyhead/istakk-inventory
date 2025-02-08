-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 08, 2025 at 02:45 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shop_inventory`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_inventory_metrics` ()   BEGIN
    UPDATE `inventory_metrics` im
    JOIN `item` i ON im.productID = i.productID
    SET 
        im.eoq = SQRT((2 * i.demand * i.ordering_cost) / i.holding_cost),
        im.rop = ((i.demand / 365) * i.lead_time) + i.safety_stock;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customerID` int(11) NOT NULL,
  `fullName` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `mobile` int(11) NOT NULL,
  `phone2` int(11) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `district` varchar(30) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'Active',
  `createdOn` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerID`, `fullName`, `email`, `mobile`, `phone2`, `address`, `address2`, `city`, `district`, `status`, `createdOn`) VALUES
(47, 'Joel Garcia', '', 2147483647, 0, 'San Antonio Sto. Tomas', 'Sto. Tomas', NULL, '', 'Active', '2025-02-06 18:54:27'),
(48, 'Aldrin Calinao', '', 2147483647, 2147483647, 'San Miguel Sto. Tomas', '', NULL, '', 'Active', '2025-02-06 18:55:47'),
(49, 'Mario Galicia', '', 2147483647, 0, 'Brgy. Santiago Sto. Tomas', 'TInurik, Tanauan', NULL, '', 'Active', '2025-02-06 19:02:34'),
(50, 'Jose Cruz', '', 2147483647, 0, 'Brgy. Santiago Sto. Tomas', '', NULL, '', 'Active', '2025-02-06 19:03:28'),
(51, 'Isabel Trambulo', '', 2147483647, 0, 'San Antonio Sto. Tomas', 'San Felix Sto. Tomas', NULL, '', 'Active', '2025-02-06 19:07:25'),
(52, 'Mariano Geronimo ', '', 2147483647, 2147483647, 'Primavera Homes Darasa, Tanauan', 'Bagumbayan, Tanauan', NULL, '', 'Active', '2025-02-06 19:09:43');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_metrics`
--

CREATE TABLE `inventory_metrics` (
  `productID` int(11) NOT NULL,
  `eoq` float NOT NULL,
  `rop` float NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `applied_rop_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_metrics`
--

INSERT INTO `inventory_metrics` (`productID`, `eoq`, `rop`, `last_updated`, `applied_rop_date`) VALUES
(63, 40, 31.9178, '2025-02-06 17:10:50', NULL),
(64, 37.9473, 28.726, '2025-02-06 17:13:33', NULL),
(65, 24.4949, 15.6849, '2025-02-06 17:14:39', NULL),
(66, 21.9089, 12.5479, '2025-02-06 17:15:56', NULL),
(67, 24.4949, 15.6849, '2025-02-06 17:16:54', NULL),
(68, 40, 61.6438, '2025-02-06 17:17:49', NULL),
(69, 15.4919, 9.24658, '2025-02-06 17:19:39', NULL),
(70, 24.4949, 45.8219, '2025-02-06 17:20:38', NULL),
(71, 24.4949, 45.411, '2025-02-06 17:21:30', NULL),
(72, 4.6188, 12.2192, '2025-02-06 17:22:21', NULL),
(73, 3.70328, 9.16438, '2025-02-06 17:23:33', NULL),
(74, 18.9737, 13.3699, '2025-02-06 17:25:20', NULL),
(75, 34.641, 31.3699, '2025-02-06 17:26:37', NULL),
(76, 14.1421, 7.06849, '2025-02-06 17:27:39', NULL),
(77, 8.94427, 6.05479, '2025-02-06 17:28:19', NULL),
(78, 23.6643, 42.3836, '2025-02-06 17:29:12', NULL),
(79, 10, 7.06849, '2025-02-06 17:31:03', NULL),
(80, 5.65685, 9.16438, '2025-02-06 17:32:22', NULL),
(81, 39.4968, 40.7808, '2025-02-06 17:34:44', NULL),
(82, 36.3318, 34.5069, '2025-02-06 17:35:39', NULL),
(83, 20, 30.5479, '2025-02-06 17:36:29', NULL),
(84, 17.8885, 24.4384, '2025-02-06 17:38:44', NULL),
(85, 20, 15.6849, '2025-02-06 17:39:53', NULL),
(86, 20, 15.6849, '2025-02-06 17:40:36', NULL),
(87, 8, 12.3288, '2025-02-06 17:41:27', NULL),
(88, 31.6228, 29.7945, '2025-02-07 03:11:42', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `productID` int(11) NOT NULL,
  `itemNumber` varchar(255) NOT NULL,
  `itemName` varchar(255) NOT NULL,
  `discount` float NOT NULL DEFAULT 0,
  `stock` int(11) NOT NULL DEFAULT 0,
  `unitPrice` float NOT NULL DEFAULT 0,
  `imageURL` varchar(255) NOT NULL DEFAULT 'imageNotAvailable.jpg',
  `status` varchar(255) NOT NULL DEFAULT 'Active',
  `description` text NOT NULL,
  `demand` int(11) NOT NULL DEFAULT 0,
  `ordering_cost` float NOT NULL DEFAULT 0,
  `holding_cost` float NOT NULL DEFAULT 0,
  `lead_time` int(11) NOT NULL DEFAULT 0,
  `safety_stock` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`productID`, `itemNumber`, `itemName`, `discount`, `stock`, `unitPrice`, `imageURL`, `status`, `description`, `demand`, `ordering_cost`, `holding_cost`, `lead_time`, `safety_stock`) VALUES
(63, '1', 'Reading Glass', 10, 32, 50, '1738865550_readingglasses.png', 'Active', 'Eyewear with graded lenses.\n', 100, 40, 5, 7, 30),
(64, '2', 'Sunglasses', 2, 23, 100, '1738865567_sunglasses.png', 'Active', 'Eyewear with dimmed lenses.\n', 0, 0, 0, 0, 0),
(65, '3', 'Remote', 5, 10, 120, '1738865632_universalremote.png', 'Active', 'Universal Remote for different brands of TV.\n', 50, 30, 5, 5, 15),
(66, '4', 'Flashlight', 10, 10, 100, '1738865646_flashlight.png', 'Active', 'A portable source of light that can be recharged thru power outlets.\n\n', 40, 30, 5, 5, 12),
(67, '5', 'Calculator', 10, 5, 150, '1738865657_calculator.png', 'Active', 'An electronic calculator of the KENKO brand.\n\n\n', 50, 30, 5, 5, 15),
(68, '6', 'Butane', 0, 11, 80, '1738865675_butanegas.png', 'Active', 'A refillable LPG canister.\n\n\n\n', 200, 20, 5, 3, 60),
(69, '7', 'Flame Gun', 10, 5, 150, '1738865706_flamegun.png', 'Active', 'A tool that can produce flames when attached to a butane canister.\n', 30, 20, 5, 3, 9),
(70, '8', 'Data Cable Type-C', 10, 7, 150, '1738865721_datacabletypec.png', 'Active', 'Fast-charging data cable for Type-C ports.\n', 150, 10, 5, 2, 45),
(71, '9', 'Earphones', 0, 38, 150, '1738865841_headset.png', 'Active', 'An audio device with headphones and a microphone, used for calls, gaming, or listening to music.\n', 150, 10, 5, 1, 45),
(72, '10', 'Lip Tint', 0, 16, 90, '1738865749_liptint.png', 'Active', 'A cosmetic product used to add color to lips and sometimes cheeks, offering a lightweight and natural look.\n', 40, 8, 30, 2, 12),
(73, '11', 'Petroleum Jelly ', 0, 1, 60, '1738865761_vaselinepetroleumjelly.png', 'Active', 'A versatile skin-care product used for moisturizing, healing dry skin, and protecting minor cuts or burns.\n', 30, 8, 35, 2, 9),
(74, '12', 'Cap', 5, 13, 150, '1738865770_cap.png', 'Active', 'A headwear accessory that provides shade from the sun and adds a stylish touch to an outfit.\n\n', 45, 20, 5, 3, 13),
(75, '13', 'Extension', 5, 35, 200, '1738865780_extension.png', 'Active', 'A power strip with multiple sockets, allowing multiple devices to be plugged in at once.\n\n\n', 100, 30, 5, 5, 30),
(76, '14', 'Watch', 10, 7, 450, '1738865789_watch.png', 'Active', 'A timekeeping device worn on the wrist, available in analog or digital versions.\n\n\n\n', 25, 20, 5, 1, 7),
(77, '15', 'Headset', 10, 2, 400, '1738865865_earphones.png', 'Active', 'An audio device with headphones and a microphone, used for calls, gaming, or listening to music.\n\n\n\n', 20, 10, 5, 1, 6),
(78, '16', 'Batteries', 0, 16, 20, '1738865876_batteries.png', 'Active', 'Portable energy storage devices that power electronic devices like remotes, clocks, and flashlights.\n\n\n\n', 140, 10, 5, 1, 42),
(79, '17', 'Mouse', 5, 4, 250, '1738865887_mouse.png', 'Active', 'A computer peripheral that allows users to navigate and control on-screen actions with ease\n', 25, 10, 5, 1, 7),
(80, '18', 'Deodorant', 0, 3, 80, '1738870156_deodorant.png', 'Active', 'A personal care product that helps prevent body odor and keeps underarms fresh.\n', 30, 8, 15, 2, 9),
(81, '19', 'Flourescent Bulb ', 0, 24, 50, '1738865899_flourescentbulb.png', 'Active', 'An energy-efficient light source that emits bright, cool-toned light.\n', 130, 30, 5, 5, 39),
(82, '20', 'LED Bulb', 0, 40, 90, '1738865911_ledbulb.png', 'Active', 'A modern light bulb that is energy-efficient, long-lasting, and provides bright illumination.\n', 110, 30, 5, 5, 33),
(83, '21', 'Lanyard', 0, 26, 35, '1738865925_lanyard.png', 'Active', 'A cord or strap worn often strapped to a phone, often used with other accessories.\n\n', 100, 10, 5, 2, 30),
(84, '22', 'Type C Phone Charger', 10, 7, 250, '1738865945_phonecharger.png', 'Active', 'A fast-charging cable with a reversible USB-C connector, used for charging modern smartphones and devices.\n\n\n', 80, 10, 5, 2, 24),
(85, '23', 'AV Cable', 0, 10, 100, '1738865955_avcable.png', 'Active', 'A cable used to transmit audio and video signals between devices like TVs, DVD players, and speakers.\n\n\n', 50, 20, 5, 5, 15),
(86, '24', 'HDMI Cable', 0, 7, 150, '1738865971_hdmicable.png', 'Active', 'A high-definition multimedia cable used to transmit video and audio signals between devices such as TVs, gaming consoles, and laptops.\n\n\n\n', 50, 20, 5, 5, 15),
(87, '25', 'Insecticide Spray', 0, 4, 100, '1738865981_insecticidespray.png', 'Active', 'A chemical spray designed to kill or repel insects like mosquitoes, cockroaches, and ants.\n\n\n', 40, 20, 25, 3, 12),
(88, '26', 'Chalk', 0, 35, 50, 'imageNotAvailable.jpg', 'Active', '', 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `purchase`
--

CREATE TABLE `purchase` (
  `purchaseID` int(11) NOT NULL,
  `itemNumber` varchar(255) NOT NULL,
  `purchaseDate` date NOT NULL,
  `itemName` varchar(255) NOT NULL,
  `unitPrice` float NOT NULL DEFAULT 0,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `vendorName` varchar(255) NOT NULL DEFAULT 'Test Vendor',
  `vendorID` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sale`
--

CREATE TABLE `sale` (
  `saleID` int(11) NOT NULL,
  `itemNumber` varchar(255) NOT NULL,
  `customerID` int(11) NOT NULL,
  `customerName` varchar(255) NOT NULL,
  `itemName` varchar(255) NOT NULL,
  `saleDate` date NOT NULL,
  `discount` float NOT NULL DEFAULT 0,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `unitPrice` float(10,0) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `sale`
--

INSERT INTO `sale` (`saleID`, `itemNumber`, `customerID`, `customerName`, `itemName`, `saleDate`, `discount`, `quantity`, `unitPrice`) VALUES
(18, '16', 49, 'Mario Galicia', '', '2025-02-03', 0, 2, 20),
(19, '3', 49, 'Mario Galicia', 'Remote', '2025-02-03', 5, 1, 120),
(20, '24', 47, 'Joel Garcia', 'HDMI Cable', '2025-02-02', 0, 1, 150),
(21, '25', 51, 'Isabel Trambulo', 'Insecticide Spray', '2025-02-03', 0, 1, 100),
(22, '6', 48, 'Aldrin Calinao', 'Butane', '2025-02-04', 5, 3, 80),
(23, '6', 49, 'Mario Galicia', 'Butane', '2025-02-04', 5, 2, 80),
(24, '7', 50, 'Jose Cruz', 'Flame Gun', '2025-02-06', 10, 1, 150),
(25, '8', 50, 'Jose Cruz', 'Data Cable Type-C', '2025-02-06', 10, 1, 150),
(26, '11', 52, 'Mariano Geronimo ', 'Petroleum Jelly ', '2025-02-06', 0, 1, 60),
(27, '18', 52, 'Mariano Geronimo ', 'Deodorant', '2025-02-06', 0, 2, 80);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userID` int(11) NOT NULL,
  `fullName` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userID`, `fullName`, `username`, `password`, `status`) VALUES
(5, 'Guest', 'guest', '81dc9bdb52d04dc20036dbd8313ed055', 'Active'),
(6, 'a', 'a', '0cc175b9c0f1b6a831c399e269772661', 'Active'),
(7, 'admin', 'admin', '21232f297a57a5a743894a0e4a801fc3', 'Active'),
(8, 'hello', 'hello', '5f4dcc3b5aa765d61d8327deb882cf99', 'Active'),
(10, 'istakk', 'istakk1', '33bcea61ff7edac1e6c777b5d6607076', 'Active'),
(11, 'athena', 'athena1', '33bcea61ff7edac1e6c777b5d6607076', 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `vendor`
--

CREATE TABLE `vendor` (
  `vendorID` int(11) NOT NULL,
  `fullName` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobile` int(11) NOT NULL,
  `phone2` int(11) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `district` varchar(30) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'Active',
  `createdOn` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customerID`);

--
-- Indexes for table `inventory_metrics`
--
ALTER TABLE `inventory_metrics`
  ADD PRIMARY KEY (`productID`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`productID`);

--
-- Indexes for table `purchase`
--
ALTER TABLE `purchase`
  ADD PRIMARY KEY (`purchaseID`);

--
-- Indexes for table `sale`
--
ALTER TABLE `sale`
  ADD PRIMARY KEY (`saleID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userID`);

--
-- Indexes for table `vendor`
--
ALTER TABLE `vendor`
  ADD PRIMARY KEY (`vendorID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `productID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `purchase`
--
ALTER TABLE `purchase`
  MODIFY `purchaseID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `sale`
--
ALTER TABLE `sale`
  MODIFY `saleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `vendor`
--
ALTER TABLE `vendor`
  MODIFY `vendorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `inventory_metrics`
--
ALTER TABLE `inventory_metrics`
  ADD CONSTRAINT `inventory_metrics_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `item` (`productID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
