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

-- creacion de la vista de las estadisticas de los pilotos en cada escuderia que devulve el id del piloto, carrera, constructor y qualify, 
-- fecha y nombre del circuito corrido, apellido del piloto, nombre y nacionalidad de la escuderia, numero del piloto, posicion puntos y qualify 
-- usan las tablas driver/races/lap_times
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

-- creacion de la vista de los resultados por cada carrera del piloto que devulve el id del piloto y de la carrera, apellido, fecha, nombre del circuito, vuelta, las posiciones y y tiempo de vuelta 
-- usan las tablas driver/races/lap_times
CREATE OR REPLACE VIEW `resultados_por_carrera_del_piloto` AS
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

-- creacion de la vista que devulve el id, apellido, grilla, posicion, puntos, vuelta, tiempo mejor vuelta, ranking, tiempo de la mejor vuelta y la velocidad maxima por vuelta de los pilotos
-- usan las tablas driver/result
CREATE OR REPLACE VIEW `mejores_resultados_del_piloto` AS 
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

-- creacion de la vista que devulve el id, año, fecha, hora, locacion, pais y datos de tiempos de las carreras
-- usan las tablas circuits/races
CREATE OR REPLACE VIEW `temporada` AS
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

-- creacion de la vista que devulve el id, nombre, nacionalidad, suma de puntos y la cantidad de veces que fueron ganadores los constructores/escuderias
-- usan las tablas constructor_standings/constructors
CREATE OR REPLACE VIEW `estadistica_escuderia` AS  
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
 
 

-- CREACION DE STORED PROCEDURE

-- agrega la columna age (edad) en la tabla driver, luego ejecuta un SP (sp_add_allrows) para actualizar el campo age 
-- por ultimo crea la vista (datos_del_piloto) con o sin el campo age dependiendo que se desea eligir 
-- esto se que no se debe hacer, pero es para fines didacticos
DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_add_year_old`$$
CREATE PROCEDURE `sp_add_year_old` (IN addage bool)
READS SQL DATA
BEGIN    
    IF (addage=1) THEN
		ALTER TABLE driver ADD COLUMN age int AFTER dob;
		call f1.sp_add_allrows();
		CREATE OR REPLACE VIEW `datos_del_piloto` AS 
			select  
				d.driverId, 
				full_name(d.driverId) as Nombre_Piloto,
				d.nationality as Nacionalidad,
				d.`code` as Codigo,  
				d.dob as Fecha_Nacimiento,
				d.age as Edad,
				q.constructorId,
				c.`name` as Nombre_Escuderia,
				c.nationality as Nacionalidad_Escuderia
			from driver d
			left join qualifying q on q.driverId=d.driverId
			left join constructors c on c.constructorId=q.constructorId
			group by driverId;
	ELSEIF (addage=0) THEN
		ALTER TABLE driver DROP COLUMN age;
		CREATE OR REPLACE VIEW `datos_del_piloto` AS
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
	end if;
END$$
DELIMITER ;

call f1.sp_add_year_old(0); -- si es 0 dropea la columna age de la tabla driver y no se ve en la vista datos_del_piloto
call f1.sp_add_year_old(1); -- si es 1 agrega la columna age de la tabla driver y se ve en la vista datos_del_piloto
select * from datos_del_piloto;
SELECT * FROM driver.new_driver;

-- updatea la columna age (edad) de la tabla driver con un loop while
-- que hace un call de la Stored Procedure anterior haciendo que muestre la edad de cada piloto de la columna age 
DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_add_allrows`$$
CREATE PROCEDURE `sp_add_allrows` ()
READS SQL DATA
BEGIN    
    DECLARE lastRows INT DEFAULT 0;
    DECLARE startRows INT DEFAULT 0;
    SELECT COUNT(*) FROM driver INTO lastRows;
    SET startRows=1;
    WHILE startRows <lastRows DO
	UPDATE driver SET age = TIMESTAMPDIFF(YEAR, dob , CURDATE()) where driverId = startRows ;
    	SET startRows= startRows+1;
    END WHILE;
END$$
DELIMITER ;

-- Muestra en 3 columnas año, constructor y posicion del campeonato de constructores
-- Se debe elegir que constructor se quiere ver, de los cuales son 214
DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_constructor_result_by_year`$$
CREATE PROCEDURE `sp_constructor_result_by_year` (IN constructor int)
READS SQL DATA
BEGIN
select last_race.year as Año, constructors.name as Constructor, position as Posicion from constructor_standings
	join (select year, raceId from races
			where year between 1950 and 2022
			group by year
			having max(round)) as last_race
			on constructor_standings.raceId = last_race.raceId
	join constructors on constructors.constructorId = constructor_standings.constructorId
where constructors.constructorId = constructor
order by last_race.year;
END$$
DELIMITER ;

call f1.sp_constructor_result_by_year(1); -- 1=Mclaren, 2=BMW Sauber, 3=Williams, 4=Renault, 5=Toro Rosso, 6=Ferrari, 7=Toyota, 8=Super Aguri, 9=Red Bull, 10=Force india, ...



-- CREACION DE TRIGGER

-- TRIGGER (1)
-- se crea el trigger tr_add_user_at_driver que disparara cuando los datos son insertados en la tabla driver y los guarda en una tabla driver_new
-- DROP TRIGGER `tr_add_user_at_driver`;

CREATE TRIGGER `tr_add_user_at_driver`
AFTER INSERT ON `driver`
FOR EACH ROW
INSERT INTO `driver_new`
VALUES (id,NEW.driverId, NEW.forename, NEW.surname, DATABASE(), 'Insert into', 'AFTER' ,USER(), SESSION_USER(), CURRENT_TIMESTAMP);

-- se crea la nueva tabla new_driver que albergara los datos del trigger
CREATE TABLE IF NOT EXISTS `driver_new`
( 
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	driverId INT, 
	forename VARCHAR(50),
    surname VARCHAR(50),
    data_base VARCHAR(50),
    event VARCHAR(30),
    timing VARCHAR(10),
    user VARCHAR(50),
    session_user VARCHAR(50),
    fecha_hora VARCHAR(50)
);

-- para testear se agregan filas
INSERT INTO driver VALUES
(856, 'hamilton', 44, 'HAM', 'Lewis', 'Hamilton', '1985-01-07', 37, 'British', 'http://en.wikipedia.org/wiki/Lewis_Hamilton')
,(857, 'heidfeld', 'NULL', 'HEI', 'Nick', 'Heidfeld', '1977-05-10', 45, 'German', 'http://en.wikipedia.org/wiki/Nick_Heidfeld');
-- se verifica que se encuentre funcionando el trigger
SELECT * FROM driver;
SELECT * FROM driver_new;

-- TRIGGER (2)
-- se crea el trigger tr_delete_user_at_driver que disparara cuando los datos son eliminados de la tabla driver y los guarda en una tabla driver_new
-- DROP TRIGGER `tr_delete_user_at_driver`;

CREATE TRIGGER `tr_delete_user_at_driver`
BEFORE DELETE ON `driver`
FOR EACH ROW
INSERT INTO `driver_new`
VALUES (id, old.driverId, old.forename, old.surname, DATABASE(), 'Delete', 'BEFORE' ,USER(), SESSION_USER(), CURRENT_TIMESTAMP);

-- para testear se borran filas
DELETE FROM driver WHERE driverId BETWEEN 856 and 857;
-- se verifica que se encuentre funcionando el trigger
SELECT * FROM driver;
SELECT * FROM driver_new;

-- TRIGGER (3)
-- se crea el trigger tr_update_user_at_driver que disparara cuando se hace un update de los datos de la tabla driver y los guarda en una tabla driver_new
-- DROP TRIGGER `tr_update_user_at_driver`;

CREATE TRIGGER `tr_update_user_at_driver`
AFTER UPDATE ON `driver`
FOR EACH ROW
INSERT INTO `driver_new`
VALUES (id, old.driverId, old.forename, old.surname, DATABASE(), 'Update', 'AFTER' ,USER(), SESSION_USER(), CURRENT_TIMESTAMP);

-- para testear se hace un update de un valor
UPDATE driver SET dob = ("1985-01-07") where driverId = 1;
-- se verifica que se encuentre funcionando el trigger
SELECT * FROM driver;
SELECT * FROM driver_new;