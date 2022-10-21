CREATE TABLE IF NOT EXISTS constructor_standings(
  constructorStandingsId INT NOT NULL,
  raceId INT NOT NULL,
  constructorId INT NOT NULL,
  points INT NULL,
  position INT NULL,
  positionText INT NULL,
  wins INT NULL,
  constructor_standingscol VARCHAR(45) NULL,
  PRIMARY KEY (constructorStandingsId),
  CONSTRAINT raceId2
    FOREIGN KEY (raceId)
    REFERENCES races (raceId)
)