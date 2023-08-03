--- more over the years comparison ----

SELECT 
	date_part('year',start_time) date_year,
	date_part('month',start_time) date_month,
	date_part('day',start_time) date_day,
	date_part('hour',start_time) date_hour,
	count(bike_id)
FROM bbrides
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4;


----------- station introduction count -------



SELECT
	deployment_year,
	count(*) stations_deployed
FROM stations_all
GROUP BY 1
ORDER BY 1;




---- bike lane introduction count ---- 


SELECT
	CASE
		WHEN open_date ilike '%2018%' then '2018'
		WHEN open_date ilike '%2019%' then '2019'
		WHEN open_date ilike '%2020%' then '2020'
		WHEN open_date ilike '%2021%' then '2021'
		WHEN open_date ilike '%2022%' then '2022'
		WHEN open_date ilike '%2023%' then '2023'
		ELSE 'Before 2018'
	END AS open_lane_date,
	count(id)
FROM bike_facilities
GROUP BY 1
ORDER BY 1;



----

---- *** Analysis of Bike Station Activity around Boston Commons **** -------

SELECT
	id,
	station_name,
	deployment_year,
	total_docks
FROM stations_all
WHERE new_id ilike 'D32017';
	------ 345	"Park Plaza at Charles St S."	2018	19
	------ 42	"Boylston St at Arlington St"	2011	31
	------ 120	"Beacon St at Charles St"		2013	19
	------ 49	"Stuart St at Charles St"		2011	14
	------ 58	"Mugar Way at Beacon St"		2011	19


----- Activity Levels for above 5 stations


SELECT 
	date_part('year', start_time) ride_date,
	count(bike_id)
FROM bbrides
WHERE start_station_id IN(345,42,120,49,58)
GROUP BY 1
ORDER BY 1;


---- *** Analysis of Bike Station Activity around Cambridge St **** -------

SELECT
	id,
	station_name,
	deployment_year,
	total_docks
FROM stations_all
WHERE new_id ilike 'B32056';
	------ 206	"Government Center - Cambridge St at Court St"			2018	35
	------ 23	"Boston City Hall - 28 State St"						2011	25
	------ 529	"One Beacon St"											2021	16
	------ 374	"Tremont St at Hamilton Pl"								2018	19

----- Activity Levels for above 4 stations


SELECT 
	date_part('year', start_time) ride_date,
	count(bike_id)
FROM bbrides
WHERE start_station_id IN(206,23,529,374)
GROUP BY 1
ORDER BY 1;


SELECT 
	date_part('year', start_time) ride_date,
	count(bike_id)
FROM bbrides
GROUP BY 1
ORDER BY 1;



SELECT
	count(id)
FROM stations_all
WHERE deployment_year not in (2019,2020,2021,2022,2023)

	-- 263
	

SELECT
	count(id)
FROM stations_all	

	-- 453