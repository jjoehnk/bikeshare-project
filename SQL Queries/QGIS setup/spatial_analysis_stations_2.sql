CREATE VIEW rd_ct_date_geom AS

SELECT
	row_number() over (ORDER BY ride_yr,ride_mth,starting_geom) +13208207 date_station_id,
	ride_yr,
	ride_mth,
	starting_geom,
	ride_qty
FROM (
	SELECT 
		date_part('year', start_time) ride_yr,
		date_part('month', start_time) ride_mth,
		starting_geom,
		count(bike_id) ride_qty
	FROM rides_geometry
	GROUP BY 1,2,3
	ORDER BY 1,2) t1
ORDER BY 1;


--- summary stats of rides per month in new table format ---


SELECT 
	date_part('month', date) ride_mth,
	starting_geom,
	min(ride_qty),
	max(ride_qty),
	avg(ride_qty),
	stddev(ride_qty)
FROM rd_ct_date_geom
GROUP BY 2,1
ORDER BY 1 DESC; 

---- max rides a month

SELECT
	avg(total_rides)
FROM(
SELECT
		date_part('month', date) ride_mth,
		max(ride_qty) total_rides
	FROM rd_ct_date_geom
	GROUP BY 1) t1;

---- quartiles each month

SELECT 
	avg(quartile1) avgq1,
	avg(quartile2) avgq2,
	avg(quartile3) avgq3
FROM(
SELECT
	ride_mth,
	round((sum(total_rides)*.25),0) quartile1,
	round((sum(total_rides)*.50),0) quartile2,
	round((sum(total_rides)*.75),0) quartile3
FROM (	
	SELECT
		date_part('month', date) ride_mth,
		max(ride_qty) total_rides
	FROM rd_ct_date_geom
	GROUP BY 1) t1
GROUP BY 1) t2;

/*
"avgq1"	"avgq2"	"avgq3"
1841.3333333333333333	3682.5833333333333333	5523.7500000000000000*/


