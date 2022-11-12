-- Creamos la base de datos F1
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




-- CREAR RELACIONES FK 

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
    

  
-- CREACION DE VISTAS
  
CREATE OR REPLACE VIEW `datos_del_piloto` AS  -- usan tablas driver/qualifying/constructos
select  
		d.driverId, 
		full_name(d.driverId) as Nombre_Piloto,
        d.nationality as Nacionalidad,
		d.`code` as Codigo,  
		d.dob as Fecha_Nacimiento,
        q.constructorId,
        c.`name` as Nombre_Escuderia,
        c.nationality as Nacionalidad_Escuderia
from driver d
left join qualifying q on q.driverId=d.driverId
left join constructors c on c.constructorId=q.constructorId
group by driverId;

select * from datos_del_piloto;

CREATE OR REPLACE VIEW `estadistica_del_piloto_escuderia` AS  -- usan tablas driver/qualifying/constructos/constructor_standings/races
select  d.driverId, 
		q.raceId,
		q.constructorId,
        q.qualifyId,
        r.date as Fecha,
        r.name as Nombre_Circuito,
		d.surname as Piloto,  
        c.`name` as Nombre_Escuderia,
        c.nationality as Nacionalidad_Escuderia,
		q.`number` as Numero_Piloto,
		q.position as Posicion,
        cs.points as Puntos,
		q.q1 as Cuali_1,
		q.q2 as Cuali_2,
		q.q3 as Cuali_3
from driver d
left join qualifying q on q.driverId=d.driverId
left join constructors c on c.constructorId=q.constructorId
left join constructor_standings cs on cs.constructorId=q.constructorId
left join races r on r.raceId=q.raceId
group by q.raceId;
select * from estadistica_del_piloto_escuderia;

CREATE OR REPLACE VIEW `resultados_por_carrera_del_piloto` AS  -- usan tablas driver/races/lap_times
select  d.driverId, 
		l.raceId,
		d.surname as Apellido, 
		r.date as Fecha,
        r.name as Nombre_Circuito,
        max(l.lap) as Vuelta,
        l.position as Posicion,
        l.time as Tiempo
from driver d
left join lap_times l on l.driverId=d.driverId
left join races r on r.raceId=l.raceId
group by  raceId;

select * from resultados_por_carrera_del_piloto;

CREATE OR REPLACE VIEW `mejores_resultados_del_piloto` AS  -- usan tablas driver/result
select    d.driverId, 
		  d.surname as Apellido, 
		  r.grid as Grilla,
		  r.position as Posicion,
		  r.points as Puntos,
		  r.laps as Vuelta,
		  r.`time` as Tiempo,
		  r.fastestLap as Mejor_Vuelta,
		  r.`rank` as Ranking,
		  r.fastestLapTime as Tiempo_Mejor_Vuelta,
		  r.fastestLapSpeed as Velocidad_Maxima_Vuelta
from driver d
left join results r on r.driverId=d.driverId;

select * from mejores_resultados_del_piloto;

CREATE OR REPLACE VIEW `temporada` AS  -- usan tablas circuits/races
select    r.raceId,
		  r.`year` as Año,
		  r.`name` as Nombre_circuito,
		  r.`date` as Fecha_Carrera,
		  r.`time` as Hora,
		  c.location as Locacion,
		  c.country as Pais,
		  r.fp1_date,
		  r.fp1_time,
		  r.fp2_date,
		  r.fp2_time,
		  r.fp3_date,
		  r.fp3_time,
		  r.quali_date,
		  r.quali_time,
		  r.sprint_date,
		  r.sprint_time
from circuits c
left join races r on c.circuitId=r.circuitId
order by r.`year` DESC;

select * from temporada;

CREATE OR REPLACE VIEW `estadistica_escuderia` AS  -- usan tablas constructor_standings/constructors
SELECT  c.constructorId,
        c.name as Nombre_escuderia,
        c.nationality as Nacionalidad,
        sum(cs.points) as Suma_de_puntos,
        constructor_wins(c.constructorId) as Cantidad_veces_ganadores
FROM constructor_standings cs
left join constructors c on cs.constructorId = c.constructorId
group by c.constructorId
order by c.constructorId;

select * from estadistica_escuderia;  
  
  


-- CREACION DE FUNCIONES

-- Función para devolver nombre completo de usuario
DELIMITER $$
DROP FUNCTION IF EXISTS `full_name` $$ 
CREATE FUNCTION `full_name` (Iddriver INT)
RETURNS VARCHAR(80)
READS SQL DATA
BEGIN
	DECLARE firstName VARCHAR(40);
    DECLARE lastName VARCHAR(40);
    DECLARE fullName VARCHAR(80);
    SET firstName = (SELECT forename FROM driver WHERE Iddriver = driverId);
    SET lastName = (SELECT surname FROM driver WHERE Iddriver = driverId);
    SET fullName = concat(firstName, ' ', lastName);
    RETURN fullName;
END $$

-- Función para devolver la suma de victorias del constructor
DELIMITER $$
DROP FUNCTION IF EXISTS `constructor_wins` $$
CREATE FUNCTION `constructor_wins` (constructor INT)
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE suma_victorias int;
    SET suma_victorias = (SELECT sum(wins) FROM constructor_standings WHERE constructorId = constructor);
    RETURN suma_victorias;
END$$
DELIMITER ;  
  
  


-- CREACION DE Store Procedure

  