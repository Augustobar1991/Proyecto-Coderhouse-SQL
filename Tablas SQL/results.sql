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
)

ALTER TABLE results
	ADD CONSTRAINT driverId2
    FOREIGN KEY (driverId)
    REFERENCES driver (driverId)

ALTER TABLE results
	ADD CONSTRAINT raceId
    FOREIGN KEY (raceId)
    REFERENCES races (raceId)    