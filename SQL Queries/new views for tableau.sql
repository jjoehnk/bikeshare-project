CREATE VIEW bbrides2018to2022 AS

SELECT
	start_time, end_time, start_station_id, end_station_id, user_type
FROM bluebike2018
UNION 
SELECT
	start_time, end_time, start_station_id, end_station_id, user_type
FROM bluebike2019
UNION 
SELECT
	start_time, end_time, start_station_id, end_station_id, user_type
FROM bluebike2020
UNION 
SELECT
	start_time, end_time, start_station_id, end_station_id, user_type
FROM bluebike2021
UNION 
SELECT
	start_time, end_time, start_station_id, end_station_id, user_type
FROM bluebike2022;




CREATE VIEW bbridesstartdatetrunc AS

SELECT
	date_trunc('hour',start_time) ride_date,
	start_station_id,
	user_type
FROM bbrides2018to2022;