
-- -----------------------------------------------------
-- Schema `AhlAlQuranAcademy`
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `AhlAlQuranAcademy` ;
USE `AhlAlQuranAcademy` ;

-- -----------------------------------------------------
-- Table `AhlAlQuranAcademy`.`Level`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AhlAlQuranAcademy`.`Level` (
  `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `Name` NVARCHAR(50) NOT NULL,
  `Discription` NVARCHAR(250) NULL,
  `Capacity` INT(4) NOT NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AhlAlQuranAcademy`.`Student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AhlAlQuranAcademy`.`Student` (
  `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `FirstName` NVARCHAR(50) NOT NULL,
  `LastName` NVARCHAR(50) NOT NULL,
  `Telegram` VARCHAR(25) NOT NULL,
  `Email` VARCHAR(250) NOT NULL UNIQUE,
  `RedFlag` INT(1) NOT NULL DEFAULT 0,
  `Passwoed` VARCHAR(250) NOT NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AhlAlQuranAcademy`.`StudentLevel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AhlAlQuranAcademy`.`StudentLevel` (
  `LevelId` INT NOT NULL,
  `StudentId` INT NOT NULL,
  `Score` INT NOT NULL,
  PRIMARY KEY (`LevelId`, `StudentId`),
  CONSTRAINT `FK_StudentLevel_Level`
    FOREIGN KEY (`LevelId`)
    REFERENCES `AhlAlQuranAcademy`.`Level` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_StudentLevel_Student`
    FOREIGN KEY (`StudentId`)
    REFERENCES `AhlAlQuranAcademy`.`Student` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AhlAlQuranAcademy`.`Sheikh`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AhlAlQuranAcademy`.`Sheikh` (
  `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `FirstName` NVARCHAR(50) NOT NULL,
  `LastName` NVARCHAR(50) NOT NULL,
  `Email` VARCHAR(250) NOT NULL UNIQUE,
  `Telegram` VARCHAR(25) NOT NULL UNIQUE,
  `Policy` VARCHAR(3) NOT NULL,
  `Rate` DECIMAL(1,1) NOT NULL DEFAULT 0)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AhlAlQuranAcademy`.`Room`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AhlAlQuranAcademy`.`Room` (
  `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `Name` NVARCHAR(50) NOT NULL,
  `Discription` NVARCHAR(250) NULL,
  `Capacity` INT(2) NOT NULL DEFAULT 5,
  `Type` INT(1) NOT NULL,
  `SheikhId` INT NOT NULL,
  CONSTRAINT `FK_Room_Sheikh`
    FOREIGN KEY (`SheikhId`)
    REFERENCES `AhlAlQuranAcademy`.`Sheikh` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AhlAlQuranAcademy`.`StudentRoom`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AhlAlQuranAcademy`.`StudentRoom` (
  `StudentId` INT NOT NULL,
  `RoomId` INT NOT NULL,
  PRIMARY KEY (`StudentId`, `RoomId`),
  CONSTRAINT `FK_StudentRoom_Student`
    FOREIGN KEY (`StudentId`)
    REFERENCES `AhlAlQuranAcademy`.`Student` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_StudentRoom_Room`
    FOREIGN KEY (`RoomId`)
    REFERENCES `AhlAlQuranAcademy`.`Room` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AhlAlQuranAcademy`.`Lesson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AhlAlQuranAcademy`.`Lesson` (
  `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `Name` NVARCHAR(50) NULL,
  `Content` NVARCHAR(250) NULL,
  `LevelId` INT NOT NULL,
  `SheikhId` INT NOT NULL,
  CONSTRAINT `FK_lesson_Level`
    FOREIGN KEY (`LevelId`)
    REFERENCES `AhlAlQuranAcademy`.`Level` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Lesson_Sheikh`
    FOREIGN KEY (`SheikhId`)
    REFERENCES `AhlAlQuranAcademy`.`Sheikh` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AhlAlQuranAcademy`.`TempSheikh`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AhlAlQuranAcademy`.`TempSheikh` (
  `SheikhId` INT NOT NULL PRIMARY KEY,
  `FirstName` NVARCHAR(50) NOT NULL,
  `LastName` NVARCHAR(50) NOT NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AhlAlQuranAcademy`.`News`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AhlAlQuranAcademy`.`News` (
  `Id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `Title` NVARCHAR(50) NOT NULL,
  `ContentPath` VARCHAR(45) NOT NULL,
  `TimeStamp` DATETIME NOT NULL,
  `Edited` TINYINT NOT NULL DEFAULT 0,
  `SheikhId` INT NOT NULL,
  CONSTRAINT `FK_News_Sheikh`
    FOREIGN KEY (`SheikhId`)
    REFERENCES `AhlAlQuranAcademy`.`Sheikh` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;
