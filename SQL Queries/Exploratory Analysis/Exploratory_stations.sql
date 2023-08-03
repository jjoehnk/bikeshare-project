--- exploring station ids over time ---


SELECT 
	count(distinct start_station_id) as qty_start_stations,
	count(distinct end_station_id) as qty_end_stations
FROM bluebike2018;
	-- 315 and 317
SELECT 
	count(distinct start_station_id) as qty_start_stations,
	count(distinct end_station_id) as qty_end_stations
FROM bluebike2019;
	--338 and 339
	
SELECT 
	count(distinct start_station_id) as qty_start_stations,
	count(distinct end_station_id) as qty_end_stations
FROM bluebike2020;
	--386 and 387
	
SELECT 
	count(distinct start_station_id) as qty_start_stations,
	count(distinct end_station_id) as qty_end_stations
FROM bluebike2021;
	--427 and 427

SELECT 
	count(distinct start_station_id) as qty_start_stations,
	count(distinct end_station_id) as qty_end_stations
FROM bluebike2022;
	--458 and 458

SELECT 
	count(distinct start_station_id) as qty_start_stations,
	count(distinct end_station_id) as qty_end_stations
FROM bluebike2023;
	--418 and 418
	
SELECT 
	count(distinct start_station_id) as qty_start_stations,
	count(distinct end_station_id) as qty_end_stations
FROM bluebikerides;
	--523 and 524
	
SELECT 
	count(distinct station_id) as qty_stations
FROM station;
	--460 
	
--524 distinct station ids from 2018 to 2023, and only 460 listed stations in reference table 

SELECT 
	deployment_year,
	count(distinct station_id) as qty_stations
FROM station
GROUP BY deployment_year;
/*
"deployment_year"	"qty_stations"
2011				55
2012				43
2013				22
2014				13
2015				18
2016				32
2017				10
2018				69
2019				62
2020				38
2021				53
2022				32
2023				12
NULL				1
*/



--- joining bike stations to referenced stations --

/* WIREFRAME
-tables?
	-bluebike_YEAR (will first compare each year to station table)
	-station
-columns?
	- s.station_id
	- b.start_station_id
	- b.end_station_id
-keys?
	- station_id
-strat?
	- multiple full join to get a sense of where ids match up
*/

SELECT b.*,
	stst.name as st_name, stst.latitude as st_lat, stst.longitude as st_long,
	endst.name as end_name, endst.latitude as end_lat, endst.longitude as end_long
FROM bluebike2018 b
	JOIN station stst
		ON stst.station_id = b.start_station_id::text
	JOIN station endst
		ON endst.station_id = b.end_station_id::text
LIMIT 10;

--- query returned no matches - next step is to see if we can translate updated station id to old id system 

--2018 start stations used
SELECT 
	start_station_id,
	count(start_station_id)
FROM bluebike2018
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 378 (315 of them used)
	
--2018 end stations used
SELECT 
	end_station_id,
	count(end_station_id)
FROM bluebike2018
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 378 (317 of them used)
	
--2019 start stations used
SELECT 
	start_station_id,
	count(start_station_id)
FROM bluebike2019
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 446 (338 of them used)
	
--2019 end stations used
SELECT 
	end_station_id,
	count(end_station_id)
FROM bluebike2019
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 446 (339 of them used)
	
--2020 start stations used
SELECT 
	start_station_id,
	count(start_station_id)
FROM bluebike2020
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 449 (386 of them used)
	
--2020 end stations used
SELECT 
	end_station_id,
	count(end_station_id)
FROM bluebike2020
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 449 (387 of them used)


--2021 start stations used
SELECT 
	start_station_id,
	count(start_station_id)
FROM bluebike2021
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 554 (427 of them used)
	
--2021 end stations used
SELECT 
	end_station_id,
	count(end_station_id)
FROM bluebike2021
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 554 (427 of them used)
	
	
--2022 start stations used
SELECT 
	start_station_id,
	count(start_station_id)
FROM bluebike2022
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 591 (458 of them used)
	
--2022 end stations used
SELECT 
	end_station_id,
	count(end_station_id)
FROM bluebike2022
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 591 (458 of them used)
	

--2023 start stations used
SELECT 
	start_station_id,
	count(start_station_id)
FROM bluebike2023
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 594 (418 of them used)
	
--2023 end stations used
SELECT 
	end_station_id,
	count(end_station_id)
FROM bluebike2023
GROUP BY 1
ORDER BY 1;
	-- range between 1 and 594 (418 of them used)
	
	
--from stations
SELECT *
FROM station
ORDER BY 1;
	-- 460 stations with new alpha-numeric naming system 
	-- no immediately clear way to link the two 



---- trying to join oldstation table to ride data -----
/* WIREFRAME
-tables?
	-old_station
	-bluebike[year]
-columns?
	-b[yr].start_station_id
	-startst.latitude
-key?
	-b[yr].start_station_id = startst.id
-strat?
	-left join to confirm if there are any bike rides with missing referential station data 
*/

--test 2018
SELECT b18.start_station_id, startst.latitude
FROM bluebike2018 b18
	FULL JOIN old_station startst
	ON b18.start_station_id = startst.id
WHERE 2 is NULL;
	-- all linked
	
--test 2019	
SELECT b19.start_station_id, startst.latitude
FROM bluebike2019 b19
	FULL JOIN old_station startst
	ON b19.start_station_id = startst.id
WHERE 2 is NULL;
	-- all linked
	
--test 2020
SELECT b20.start_station_id, startst.latitude
FROM bluebike2020 b20
	FULL JOIN old_station startst
	ON b20.start_station_id = startst.id
WHERE 2 is NULL;
	-- all linked

--test 2021
SELECT b21.start_station_id, startst.latitude
FROM bluebike2021 b21
	FULL JOIN old_station startst
	ON b21.start_station_id = startst.id
WHERE 2 is NULL;
	-- all linked
	
--test 2022
SELECT b22.start_station_id, startst.latitude
FROM bluebike2022 b22
	FULL JOIN old_station startst
	ON b22.start_station_id = startst.id
WHERE 2 is NULL;
	-- all linked

--test 2023
SELECT b23.start_station_id, startst.latitude
FROM public."bluebike2023_toMarch" b23
	FULL JOIN old_station startst
	ON b23.start_station_id = startst.id
WHERE 2 is NULL;
	-- all linked
	
SELECT b23.start_station_id, startst.latitude
FROM public."bluebike2023_toJune" b23
	FULL JOIN station startst
	ON b23.start_station_id = startst.station_id
WHERE 2 is NULL;
	-- all linked
	



------------- comparing old_station to new_station reference ----------------

/* WIREFRAME

goal: see if latitude and longitude can be matched between the two tables
-tables?
	-station
	-old_station
-columns
	-id
	-name
	-lat
	-long
-key
	-latitude
	-longitude
-strat - try all joins 

*/

-- !! 439 Stations that have aligned and can be combined into view for cross-period examination

SELECT 
	s.station_id new_id,
	o.id old_id,
	s.name new_name,
	o.name old_name, 
	s.latitude new_lat,
	o.latitude old_lat,
	s.longitude new_long,
	o.latitude old_long
FROM station s
FULL JOIN old_station o
	USING(latitude)
WHERE o.id IS NULL or s.station_id IS NULL
ORDER BY 3,4;
/* NEW STATIONS WITH NO ID MATCH
"new_id"
"A32055"
"F32005"
"C32067"
"S32007"
"F32004"
"T32016"
"D32061"
"A32032"
"C32053"
"T32017"
"S32011"
"W32005"
"V32009"
"V32003"
"M32085"
"T32018"
"F32006"
"A32019"
"D32007"
"C32066"
"C32008"


OLD STATIONS WITH NO ID MATCH
"old_id"
214
514
308
411
402
369
452
499
453
497
388
494
474
134
420
457
149
470
438
370
496
42
114
412
396
395
450
209
1
451
498
537
389
101
61
366
351
591
31
*/



---- dynamically checking for overlap between station reference tables ---- 
with n as(
SELECT station_id, total_docks, district, latitude, longitude, name, deployment_year
FROM station
WHERE latitude in(select latitude from old_station) AND longitude in(select longitude from old_station)
	OR name in(select name from old_station)
)


explain analyze
select 
	n.station_id,
	o.id,
	n.name,
	n.district,
	n.total_docks,
	n.latitude,
	n.longitude,
	n.deployment_year
FROM station n
	LEFT JOIN old_station o on o.latitude = n.latitude
	LEFT JOIN old_station olong on olong.longitude = n.longitude
	LEFT JOIN old_station oname on oname.name = n.name
ORDER BY n.name;


CREATE VIEW ref_station AS
SELECT
	n.station_id new_id,
	o.id old_id,
	n.name station_name,
	n.district,
	n.deployment_year,
	n.latitude,
	n.longitude
FROM station n
	LEFT JOIN old_station o on o.name = n.name;