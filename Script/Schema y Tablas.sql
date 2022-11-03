CREATE SCHEMA IF NOT EXISTS F1;
USE F1;

-- Crea Tabla circuits
CREATE TABLE IF NOT EXISTS circuits(
  circuitId INT NOT NULL,
  circuitRef VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  location VARCHAR(45) NOT NULL,
  country VARCHAR(45) NOT NULL,
  lat INT NULL,
  lng INT NULL,
  alt INT NULL,
  url TEXT(45) NULL,
  PRIMARY KEY (CircuitId)
);

-- Crea Tabla constructor_standings
CREATE TABLE IF NOT EXISTS constructor_standings (
  constructorStandingsId INT NOT NULL,
  raceId INT NOT NULL,
  constructorId INT NOT NULL,
  points INT NULL,
  position INT NULL,
  positionText INT NULL,
  wins INT NULL,
  constructor_standingscol VARCHAR(45) NULL,
  PRIMARY KEY (constructorStandingsId, constructorId)
);
ALTER TABLE constructor_standings 
	ADD CONSTRAINT raceId
    FOREIGN KEY (raceId)
    REFERENCES races (raceId)

-- Crea Tabla constructors 
CREATE TABLE IF NOT EXISTS constructors (
  constructorId INT NOT NULL,
  constructorRef VARCHAR(45) NULL,
  `name` VARCHAR(45) NULL,
  nationality VARCHAR(45) NULL,
  url TEXT(45) NULL,
  PRIMARY KEY (constructorId)
);
ALTER TABLE constructors
	ADD CONSTRAINT constructorId
    FOREIGN KEY (constructorId)
    REFERENCES constructor_standings (constructorStandingsId)

-- Crea Tabla driver 
CREATE TABLE IF NOT EXISTS driver (
  driverId INT NOT NULL,
  driverRef VARCHAR(45) NULL,
  `number` VARCHAR(45),
  `code` VARCHAR(45) NULL,
  forename VARCHAR(45) NULL,
  surname VARCHAR(45) NULL,
  dob DATE NULL,
  nationality VARCHAR(45) NULL,
  url VARCHAR(255) NULL,
  PRIMARY KEY (driverId)
);

-- Crea Tabla lap_times y luego la FK
CREATE TABLE IF NOT EXISTS lap_times (
  Id int NOT NULL AUTO_INCREMENT,
  raceId INT NOT NULL,
  driverId INT NOT NULL,
  lap VARCHAR(45) NULL,
  position VARCHAR(45) NULL,
  time TIME NULL,
  milliseconds INT NULL,
  PRIMARY KEY (Id, raceId)
);
ALTER TABLE lap_times
	ADD CONSTRAINT driverId
	FOREIGN KEY (driverId)
    REFERENCES driver (driverId);

-- Crea Tabla qualifying
CREATE TABLE IF NOT EXISTS qualifying (
  qualifyId INT NOT NULL,
  raceId INT NOT NULL,
  driverId INT NOT NULL,
  constructorId INT NOT NULL,
  `number` INT NULL,
  position INT NULL,
  q1 TIME NULL,
  q2 TIME NULL,
  q3 TIME NULL,
  PRIMARY KEY (qualifyId)
);
ALTER TABLE qualifying
	ADD CONSTRAINT driverId1
    FOREIGN KEY (driverId)
    REFERENCES driver (driverId);

-- Crea Tabla races
CREATE TABLE IF NOT EXISTS races(
  raceId INT NOT NULL,
  `year` INT NOT NULL,
  round INT NULL,
  circuitId INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `date` DATE NULL,
  `time` TIME NULL,
  url VARCHAR(255) NULL,
  fp1_date DATE NULL,
  fp1_time TIME NULL,
  fp2_date DATE NULL,
  fp2_time TIME NULL,
  fp3_date DATE NULL,
  fp3_time TIME NULL,
  quali_date DATE NULL,
  quali_time TIME NULL,
  sprint_date DATE NULL,
  sprint_time TIME NULL,
  PRIMARY KEY (raceId, circuitId)
);
-- se corre luego de haber ejecutado todas las tablas
ALTER TABLE races
	ADD CONSTRAINT CircuitId
	FOREIGN KEY (circuitId)
    REFERENCES circuits (CircuitId); 

-- Crea Tabla results y luego crea 2 FK
CREATE TABLE IF NOT EXISTS results(
  resultId INT NOT NULL,
  raceId INT NOT NULL,
  driverId INT NOT NULL,
  constructorId INT NOT NULL,
  `number` INT NOT NULL,
  grid INT NULL,
  position INT NULL,
  positionText VARCHAR(45) NULL,
  positionOrder INT NULL,
  points INT NULL,
  laps INT NULL,
  `time` TIME NULL,
  milliseconds INT NULL,
  fastestLap INT NULL,
  `rank` INT NULL,
  fastestLapTime TIME NULL,
  fastestLapSpeed INT NULL,
  statusId INT NULL,
  PRIMARY KEY (resultId, driverId)
);
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE results
	ADD CONSTRAINT driverId2
    FOREIGN KEY (driverId)
    REFERENCES driver (driverId);

ALTER TABLE results
	ADD CONSTRAINT raceId2
    FOREIGN KEY (raceId)
    REFERENCES races (raceId);

-- Crea Tabla sprint_results
CREATE TABLE IF NOT EXISTS sprint_results(
  resultId INT NOT NULL,
  raceId INT NOT NULL,
  driverId INT NOT NULL,
  constructorId INT NOT NULL,
  `number` INT NOT NULL,
  grid INT NULL,
  position VARCHAR(45) NULL,
  positionText VARCHAR(45) NULL,
  positionOrder INT NULL,
  points INT NULL,
  laps INT NULL,
  `time` TIME NULL,
  milliseconds INT NULL,
  fastestLap INT NULL,
  fastestLapTime TIME NULL,
  statusId INT NULL,
  PRIMARY KEY (resultId)
);
 ALTER TABLE sprint_results
	ADD CONSTRAINT raceId1
    FOREIGN KEY (raceId)
    REFERENCES races (raceId);
    
ALTER TABLE sprint_results
	ADD CONSTRAINT driverId3
    FOREIGN KEY (driverId)
    REFERENCES driver (driverId);
