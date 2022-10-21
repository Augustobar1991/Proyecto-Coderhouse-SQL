CREATE TABLE IF NOT EXISTS driver (
  driverId INT NOT NULL,
  driverRef VARCHAR(45) NULL,
  `number` VARCHAR(45) NOT NULL,
  `code` VARCHAR(45) NULL,
  forename VARCHAR(45) NULL,
  surname VARCHAR(45) NULL,
  dob DATETIME(6) NULL,
  nationality VARCHAR(45) NULL,
  url VARCHAR(45) NULL,
  PRIMARY KEY (driverId)
)