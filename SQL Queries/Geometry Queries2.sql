------ Bike Lanes and Crashes. Geometry Queries -----

ALTER TABLE crashes_2
ADD COLUMN geom geometry;


UPDATE crashes_2
SET geom = ST_SetSRID(St_MakePoint(longitude,latitude),26986);


ALTER TABLE crashes_2
ADD COLUMN incident_ref serial;

select UpdateGeometrySRID('public','crashes_2', 'geom', 26986) 

------

create index on crashes_2 using gist (geom);
create index on public."Existing_Bike_Network_2023" using gist (geom);


---------
SELECT 
	cr.incident_ref cr_id,  -- crash id
	cr.geom cr_geom, -- crash geometry
	b_id, -- bike facility id
	b_geom, -- bike geometry
	distance -- (???) shortest distance
FROM crashes_2 cr CROSS JOIN LATERAL (
	SELECT
		b.geom b_geom,
		b.id b_id,
		ST_Distance(cr.geom, b.geom) distance
	FROM public."Existing_Bike_Network_2023" b
	WHERE b.installdat::integer <= 2018
	and date_part('year',cr.dispatch_time::date) = 2018
	GROUP BY 1,2
	ORDER BY min(ST_Distance(cr.geom, b.geom))
	LIMIT 1
) calc
ORDER BY 5 ASC;

--------

SELECT 
	cr.incident_ref cr_id,  -- crash id
	cr.geom cr_geom, -- crash geometry
	b_id, -- bike facility id
	b_geom, -- bike geometry
	distance -- (???) shortest distance
FROM crashes_2 cr 
JOIN LATERAL (
	SELECT
		b.geom b_geom,
		b.id b_id,
		st_distance(cr.geom,b.geom) distance
	FROM public."Existing_Bike_Network_2023" b
	WHERE b.installdat::integer <= 2018
		and date_part('year',cr.dispatch_time::date) = 2018
	ORDER BY cr.geom <-> b.geom
	LIMIT 1) t1
	ON true
;



-----------------

SELECT 
	s.id,
	s.geom
FROM stations_all s
	LEFT JOIN bike_facilities b ON ST_DWithin(s.geom,st_geomfromtext(b.shape),1000)
ORDER BY s.id;


______

SELECT
	st_makeline(shape_leng::text,shape_length::text)
FROM bike_facilities;



------ stations built in or before 2018 ----

CREATE VIEW bbstations2018 AS
SELECT
	id,
	station_name,
	district,
	deployment_year,
	total_docks,
	latitude,
	longitude,
	geom
FROM stations_all
WHERE deployment_year <= 2018
	AND district ilike 'boston';



----- check relative activity levels for bike stations built in 2018 by year


SELECT
	date_part('year',ride_start_time) ride_yr,
	start_station_id,
	sum(qty_rides) total_rides
FROM bbridestab
WHERE start_deployment_year <=2018
GROUP BY 1,2
ORDER BY 1;
	
	

----

SELECT
	st.id,
	st.station_name,
	st.district,
	st.deployment_year,
	st.latitude,
	st.longitude,
	count(bb.user_type) total_rides
FROM bbrides2018to2022 bb
	JOIN stations_all st
		ON bb.start_station_id = st.id
GROUP BY 1,2,3,4,5,6
ORDER BY 1;



---
SELECT
	id
FROM stations_all
WHERE deployment_year <= 2018
	AND district ilike 'boston'
ORDER BY id;


--- excluding 368,360,259 as it opened at the end of 2018
SELECT
	*
FROM bbrides
WHERE start_station_id = 32
	AND date_part('year',start_time) = 2020
ORDER BY start_time;
	
SELECT
	id
FROM stations_all
WHERE district ilike 'boston';