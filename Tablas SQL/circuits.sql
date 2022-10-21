CREATE TABLE IF NOT EXISTS circuits(
  CircuitId INT NOT NULL,
  circuitRef VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  location VARCHAR(45) NOT NULL,
  country VARCHAR(45) NOT NULL,
  lat INT NULL,
  lng INT NULL,
  alt INT NULL,
  url TEXT(45) NULL,
  PRIMARY KEY (CircuitId),
  CONSTRAINT CircuitId
    FOREIGN KEY (CircuitId)
    REFERENCES races (raceId)
)