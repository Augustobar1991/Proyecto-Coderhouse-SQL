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

-- Crea Tabla constructors 
CREATE TABLE IF NOT EXISTS constructors (
  constructorId INT NOT NULL,
  constructorRef VARCHAR(45) NULL,
  `name` VARCHAR(45) NULL,
  nationality VARCHAR(45) NULL,
  url TEXT(45) NULL,
  PRIMARY KEY (constructorId)
);

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
  lap INT NULL,
  position VARCHAR(45) NULL,
  time VARCHAR(45) NULL,
  milliseconds INT NULL,
  PRIMARY KEY (Id, raceId)
);

-- Crea Tabla qualifying
CREATE TABLE IF NOT EXISTS qualifying (
  qualifyId INT NOT NULL,
  raceId INT NOT NULL,
  driverId INT NOT NULL,
  constructorId INT NOT NULL,
  `number` INT NULL,
  position INT NULL,
  q1 VARCHAR(45) NULL,
  q2 VARCHAR(45) NULL,
  q3 VARCHAR(45) NULL,
  PRIMARY KEY (qualifyId)
);

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
  fastestLapTime VARCHAR(45) NULL,
  fastestLapSpeed INT NULL,
  statusId INT NULL,
  PRIMARY KEY (resultId, driverId)
);


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
  `time` VARCHAR(45) NULL,
  milliseconds INT NULL,
  fastestLap INT NULL,
  fastestLapTime VARCHAR(45) NULL,
  statusId INT NULL,
  PRIMARY KEY (resultId)
);

SET FOREIGN_KEY_CHECKS=0;
    
ALTER TABLE constructor_standings 
	ADD CONSTRAINT raceId
    FOREIGN KEY (raceId)
    REFERENCES races (raceId);
    
ALTER TABLE constructors
	ADD CONSTRAINT constructorId
    FOREIGN KEY (constructorId)
    REFERENCES constructor_standings (constructorStandingsId);
    
ALTER TABLE qualifying
	ADD CONSTRAINT driverId1
    FOREIGN KEY (driverId)
    REFERENCES driver (driverId);    
    
ALTER TABLE lap_times
	ADD CONSTRAINT driverId
	FOREIGN KEY (driverId)
    REFERENCES driver (driverId);
    
ALTER TABLE races
	ADD CONSTRAINT CircuitId
	FOREIGN KEY (circuitId)
    REFERENCES circuits (CircuitId); 
    
ALTER TABLE results
	ADD CONSTRAINT raceId2
    FOREIGN KEY (raceId)
    REFERENCES races (raceId);

ALTER TABLE results
	ADD CONSTRAINT driverId2
    FOREIGN KEY (driverId)
    REFERENCES driver (driverId);      
    
ALTER TABLE sprint_results
	ADD CONSTRAINT raceId1
    FOREIGN KEY (raceId)
    REFERENCES races (raceId);
    
ALTER TABLE sprint_results
	ADD CONSTRAINT driverId3
    FOREIGN KEY (driverId)
    REFERENCES driver (driverId);
    
ALTER TABLE constructor_standings 
	DROP CONSTRAINT raceId;
    
ALTER TABLE constructors
	DROP CONSTRAINT constructorId;
    
ALTER TABLE qualifying
	DROP CONSTRAINT driverId1; 
    
ALTER TABLE lap_times
	DROP CONSTRAINT driverId;
    
ALTER TABLE races
	DROP CONSTRAINT CircuitId;    
    
ALTER TABLE results
	DROP CONSTRAINT raceId2;

ALTER TABLE results
	DROP CONSTRAINT driverId2;    
    
ALTER TABLE sprint_results
	DROP FOREIGN KEY raceId1;

ALTER TABLE sprint_results
	DROP FOREIGN KEY driverId3;