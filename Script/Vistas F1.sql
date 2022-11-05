CREATE OR REPLACE VIEW `datos_del_piloto` AS  -- driver qualifying constructos
select  d.driverId, 
		d.surname as Apellido, 
	    d.forename as Nombre, 
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

CREATE OR REPLACE VIEW `estadistica_del_piloto_escuderia` AS  -- driver qualifying constructos constructor_standings races
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

CREATE OR REPLACE VIEW `mejores_vuelta_del_piloto` AS  -- driver races lap_times
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

select * from mejores_vuelta_del_piloto;

CREATE OR REPLACE VIEW `mejores_resultados_del_piloto` AS  -- driver qualifying constructos
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

CREATE OR REPLACE VIEW `temporada` AS  -- circuits/races
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




