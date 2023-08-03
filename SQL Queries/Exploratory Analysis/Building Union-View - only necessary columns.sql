--- creating a streamlined union ---
CREATE VIEW bbrides AS

SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, 'pre-covid' as covid_classification
	FROM bluebike2018
UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, 'pre-covid' as covid_classification
	FROM bluebike2019
UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type,
	CASE
		WHEN start_time < '2020-03-10'::timestamp THEN 'pre_covid'
        ELSE 'post_covid'
	END AS covid_classification
	FROM bluebike2020
UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, 'post-covid' as covid_classification
	FROM bluebike2021
UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, 'post-covid' as covid_classification
	FROM bluebike2022
UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, 'post-covid' as covid_classification
	FROM bluebike2023;