CREATE TABLE IF NOT EXISTS constructors (
  constructorId INT NOT NULL,
  constructorRef VARCHAR(45) NULL,
  `name` VARCHAR(45) NULL,
  nationality VARCHAR(45) NULL,
  url TEXT(45) NULL,
  PRIMARY KEY (constructorId),
  CONSTRAINT constructorId
    FOREIGN KEY (constructorId)
    REFERENCES constructor_standings (constructorStandingsId)
)