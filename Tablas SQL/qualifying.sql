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
)

ALTER TABLE qualifying
	ADD CONSTRAINT driverId1
    FOREIGN KEY (driverId)
    REFERENCES driver (driverId)

