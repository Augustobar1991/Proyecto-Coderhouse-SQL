CREATE TABLE IF NOT EXISTS lap_times (
  raceId INT NOT NULL,
  driverId INT NOT NULL,
  lap VARCHAR(45) NULL,
  position VARCHAR(45) NULL,
  time TIME NULL,
  milliseconds INT NULL,
  PRIMARY KEY (raceId)
)

ALTER TABLE lap_times
	ADD CONSTRAINT driverId
	FOREIGN KEY (driverId)
    REFERENCES driver (driverId);