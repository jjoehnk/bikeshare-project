---- exploratory analysis with station reference information!!!! 


--- first new table view of all years combined


CREATE VIEW bbrides AS

SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, 'pre-covid' as covid_classification
FROM bluebike2018
	UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, 'pre-covid' as covid_classification
FROM bluebike2019
	UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type,
	CASE
		WHEN start_time < '2020-03-10'::timestamp THEN 'pre-covid'
        ELSE 'covid'
    END AS covid_classification
FROM bluebike2020
	UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, 
	CASE
		WHEN start_time < '2021-05-29'::timestamp THEN 'covid'
        ELSE 'post-covid'
    END AS covid_classification
FROM bluebike2021
	UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, 'post-covid' as covid_classification
FROM bluebike2022
	UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, 'post-covid' as covid_classification
FROM public."bluebike2023_toMarch";


------------------ Day of the Week

SELECT
	CASE
		WHEN dow = 0 THEN 'Sun'
		WHEN dow = 1 THEN 'Mon'
		WHEN dow = 2 THEN 'Tues'
		WHEN dow = 3 THEN 'Wed'
		WHEN dow = 4 THEN 'Thurs'
		WHEN dow = 5 THEN 'Fri'
		WHEN dow = 6 THEN 'Sat'
	END AS day_of_week,
	covid_classification,
	round(avg(ride_qty),0) avg_rides_per_day
FROM (
	SELECT
		extract('DOW' FROM start_time) as dow,
		covid_classification,
		count(bike_id) ride_qty
		FROM bbrides
		GROUP BY 1,2
	) as t1
GROUP BY 1,2
ORDER BY 3 DESC;

/* 
"day_of_week"	"covid_classification"	"avg_rides_per_day"
"Sat"			"post-covid"			984197
"Fri"			"post-covid"			960322
"Wed"			"post-covid"			951744
"Thurs"			"post-covid"			947801
"Tues"			"post-covid"			894451
"Sun"			"post-covid"			889912
"Mon"			"post-covid"			836144
"Wed"			"pre-covid"				731868
"Thurs"			"pre-covid"				716517
"Fri"			"pre-covid"				708570
"Tues"			"pre-covid"				698565
"Mon"			"pre-covid"				681965
"Sat"			"pre-covid"				556220
"Sun"			"pre-covid"				509752
"Sat"			"covid"					435845
"Fri"			"covid"					368064
"Sun"			"covid"					365016
"Wed"			"covid"					338490
"Thurs"			"covid"					335830
"Tues"			"covid"					333796
"Mon"			"covid"					302699
*/


------- Finding most frequented stations -------

CREATE VIEW top50stations AS
SELECT
	start_station_id,
	count(bike_id)
FROM bbrides
GROUP BY 1
ORDER BY 2 DESC
LIMIT 50;

--------------- Station Location and Rides

/* WIREFRAME

--tables?
	-ref_station
	-bbrides
--columns?
	- bike_id
	- covid_classification	
	- user_type
	- start_station_id
	- start_station_lat
	- start_station_long
	- start_district
	- end_station_id
	- end_station_lat
	- end_station_long
	- end_district
--key?
	-station_id, old_id
--strat? 
	-inner join, multi
*/

SELECT
	bb.bike_id,
	bb.covid_classification,
	bb.user_type,
	bb.start_station_id,
	stst.latitude start_station_lat,
	stst.longitude start_station_long,
	stst.district start_district,
	bb.end_station_id,
	endst.latitude end_station_lat,
	endst.longitude end_station_long,
	endst.district end_district
FROM bbrides bb
	JOIN ref_station stst ON bb.start_station_id = stst.old_id 
	JOIN ref_station endst ON bb.end_station_id = endst.old_id
WHERE start_station_id IN(select start_station_id from topprecovidstations)


--- try 2 - getting avg rides by top stations 

SELECT
	tbb.covid_classification,
	tbb.start_station_id,
	tbb.latitude start_station_lat,
	tbb.longitude start_station_long,
	tbb.district start_district,
	round(avg(ride_qty),0) avg_rides
FROM (
	SELECT
		bb.covid_classification,
		bb.start_station_id,
		stst.latitude,
		stst.longitude,
		stst.district,
		count(bike_id) ride_qty
		FROM bbrides bb
			JOIN ref_station stst ON bb.start_station_id = stst.old_id 
		WHERE start_station_id IN(select start_station_id from topprecovidstations)
		GROUP BY 1,2,3,4,5
	) as tbb
GROUP BY 2,1,3,4,5

-- try 3

--start stations

SELECT
	bb.bike_id,
	bb.covid_classification,
	bb.user_type,
	bb.start_station_id,
	stst.latitude start_station_lat,
	stst.longitude start_station_long
FROM bbrides bb
	JOIN ref_station stst ON bb.start_station_id = stst.old_id 
WHERE start_station_id IN(select top50stations.start_station_id from top50stations);

--end stations

SELECT
	bb.bike_id,
	bb.covid_classification,
	bb.user_type,
	bb.end_station_id,
	endst.latitude end_station_lat,
	endst.longitude end_station_long
FROM bbrides bb
	JOIN ref_station endst ON bb.end_station_id = endst.old_id
WHERE start_station_id IN(select top50endstations.end_station_id from top50endstations);



---- going for a DIFFERENT THING AGAIN 

SELECT
	bb.bike_id,
	bb.start_time,
	bb.user_type,
	bb.start_station_id,
	bb.covid_classification,
	stst.latitude start_station_lat,
	stst.longitude start_station_long
FROM bbrides bb
	JOIN ref_station stst ON bb.start_station_id = stst.old_id 
WHERE start_station_id IN(select top50stations.start_station_id from top50stations);



---- AND ANOTHER ONE

SELECT
	bb.start_station_id,
	count(bb.bike_id),
	bb.start_time::date,
	bb.user_type,
	stst.latitude start_station_lat,
	stst.longitude start_station_long
FROM bbrides bb
	JOIN ref_station stst ON bb.start_station_id = stst.old_id
GROUP BY 3,1,4,5,6
ORDER BY 2 DESC;

CREATE VIEW rides_geometry AS
SELECT
	t1.ride_id,
	t1.bike_id,
	t1.covid_classification,
	t1.user_type,
	t1.start_station_id,
	t1.start_time,
	stst.geom starting_geom,
	t1.end_station_id,
	t1.end_time,
	endst.geom ending_geom
FROM (
SELECT
	row_number() OVER (ORDER BY bike_id) as ride_id,
	bb.bike_id,
	bb.covid_classification,
	bb.user_type,
	bb.start_station_id,
	bb.start_time,
	bb.end_station_id,
	bb.end_time
FROM bbrides bb) t1
	JOIN stations_all stst ON t1.start_station_id = stst.id 
	JOIN stations_all endst ON t1.end_station_id = endst.id;
	
	
	
	
select min(deployment_year), max(deployment_year)
from stations_all;