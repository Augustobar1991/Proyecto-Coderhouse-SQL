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
  PRIMARY KEY (resultId),
  CONSTRAINT raceId1
    FOREIGN KEY (raceId)
    REFERENCES races (raceId),
  CONSTRAINT driverId3
    FOREIGN KEY (driverId)
    REFERENCES driver (driverId)
)
