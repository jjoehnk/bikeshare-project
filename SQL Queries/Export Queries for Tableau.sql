--- Export Queries for Tableau



-- Grouped Ride Qty by Time for Radial Vis -- 
CREATE VIEW radialrides AS
SELECT
	date_trunc('day',start_time) ride_day,
	count(user_type) qty_rides
FROM bbrides2018to2022
GROUP BY 1
ORDER BY 1;



--- Grouped Ride Qty by Time with Station Info for Spider Vis --- 


SELECT 
	date_trunc('month',b.start_time) ride_date,
	b.start_station_id start_station_id,
	b.end_station_id end_station_id,
	stst.station_name start_station_name,
	stst.district start_district,
	stst.latitude start_latitude,
	stst.longitude start_longitude,
	endst.station_name end_station_name,
	endst.district end_district,
	endst.latitude end_latitude,
	endst.longitude end_longitude,
	count(bike_id) qty_rides
FROM bbrides b
	JOIN stations_all stst 
		ON b.start_station_id = stst.id
	JOIN stations_all endst
		ON b.end_station_id = endst.id
WHERE date_part('year',b.start_time) != 2023
GROUP BY 1,2,3,4,5,6,7,8,9,10,11
ORDER BY 1;



--- spine chart - user type by years


SELECT
	date_part('year',start_time) ride_year,
	user_type, 
	count(user_type) qty_riders
FROM bbrides2018to2022
GROUP BY 1,2
ORDER BY 1;



--- main data set for tableau

CREATE VIEW bbridestab AS

SELECT
	date_trunc('day',b.start_time) ride_start_time,
	b.user_type,
	b.start_station_id,
	st.station_name start_station,
	st.district start_district,
	st.deployment_year start_deployment_year,
	st.total_docks start_total_docks,
	st.latitude start_lat,
	st.longitude start_long,
	b.end_station_id,
	en.station_name end_station,
	en.district end_district,
	en.deployment_year end_deployment_year,
	en.total_docks end_total_docks,
	en.latitude end_lat,
	en.longitude end_long,
	count(*) qty_rides
FROM bbrides2018to2022 b
	JOIN stations_all st
		ON st.id = b.start_station_id
	JOIN stations_all en
		ON en.id = b.end_station_id
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16;