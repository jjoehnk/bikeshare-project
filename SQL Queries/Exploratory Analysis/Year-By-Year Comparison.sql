-- exploratory year-by-year comparison of bluebike activity --

--creating a beast of a union!!!---

SELECT bb_year, hour_of_day, qty_rides, pct_total_rides
	FROM (
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
			date_part('hour', start_time) as hour_of_day,
			count(bike_id) as qty_rides,
			round(((count(bike_id)::numeric/1767806.00)*100),2) as pct_total_rides
		FROM bluebike2018
		GROUP BY date_part('hour', start_time))
	UNION
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
			date_part('hour', start_time) as hour_of_day,
			count(bike_id) as qty_rides,
			round(((count(bike_id)::numeric/2522537.00)*100),2) as pct_total_rides
		FROM bluebike2019
		GROUP BY date_part('hour', start_time))
	UNION
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
			date_part('hour', start_time) as hour_of_day,
			count(bike_id) as qty_rides,
			round(((count(bike_id)::numeric/2073448.00)*100),2) as pct_total_rides
		FROM bluebike2020
		GROUP BY date_part('hour', start_time))
	UNION
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
			date_part('hour', start_time) as hour_of_day,
			count(bike_id) as qty_rides,
			round(((count(bike_id)::numeric/2934378.00)*100),2) as pct_total_rides
		FROM bluebike2021
		GROUP BY date_part('hour', start_time))
	UNION
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
			date_part('hour', start_time) as hour_of_day,
			count(bike_id) as qty_rides,
			round(((count(bike_id)::numeric/3757281.00)*100),2) as pct_total_rides
		FROM bluebike2022
		GROUP BY date_part('hour', start_time))
	UNION
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
			date_part('hour', start_time) as hour,
			count(bike_id) as qty_rides,
			round(((count(bike_id)::numeric/492318.00)*100),2) as pct_total_rides
		FROM bluebike2023
		GROUP BY date_part('hour', start_time))) as bluebike_yearbyyear;
		

---- baby union of total rides per year 

SELECT bb_year, total_rides
	FROM (
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
		 	count(bike_id) as total_rides,
		 	
		FROM bluebike2018)
	UNION
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
			count(bike_id) as qty_rides
		FROM bluebike2019)
	UNION
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
			count(bike_id) as qty_rides
		FROM bluebike2020)
	UNION
		(SELECT 
		 	min(date_part('year', start_time)) as bb_year,
			count(bike_id) as qty_rides
		FROM bluebike2021)
	UNION
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
			count(bike_id) as qty_rides
		FROM bluebike2022)
	UNION
		(SELECT 
		 	max(date_part('year', start_time)) as bb_year,
			count(bike_id) as qty_rides
		FROM bluebike2023)) as sum_stats_yearbyyear
ORDER BY bb_year;


--- trying out creating a view!! ******** USE TEMP VIEW ******* put pre/post covid in union, but case in 2020 


CREATE VIEW bluebikerides AS

SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, user_birth_year, user_gender, NULL as user_postal_code, 'pre-covid' as covid_classification
	FROM bluebike2018
	UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, user_birth_year, user_gender, NULL as user_postal_code 
	FROM bluebike2019
	UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, user_birth_year, user_gender, user_postal_code 
	FROM bluebike2020
	UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, NULL as user_birth_year, NULL as user_gender, user_postal_code 
	FROM bluebike2021
	UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, NULL as user_birth_year, NULL as user_gender, user_postal_code 
	FROM bluebike2022
	UNION ALL
SELECT bike_id, start_time, end_time, start_station_id, end_station_id, user_type, NULL as user_birth_year, NULL as user_gender, user_postal_code 
	FROM bluebike2022
	UNION ALL;

--- select *, null as XX..... *, null as, user_

-- testing create a view!!
SELECT
	min(start_time),
	max(start_time),
	count(bike_id)
FROM bluebikerides;
--- total rides 13,547,768


-- change over time query -- test 1

SELECT date_part('month', start_time), qty_rides
	FROM (
		SELECT count(bike_id) as qty_rides,
			CASE
				WHEN start_time < to_char(2020-03-10,'YYYYMMDD') THEN pre_covid
				ELSE post_covid
			END AS period_of_time
		FROM bluebikerides) as covid_rip
GROUP BY date_part('month', start_time)
ORDER BY date_part('month', start_time);


---- test 2

SELECT date_part('month', start_time), qty_rides
	FROM (
		SELECT count(bike_id) as qty_rides,
			CASE
				WHEN date_part('year', start_time) in (2018, 2019, 2020) THEN 'pre_covid'
				ELSE 'post_covid'
			END AS period_of_time
		FROM bluebikerides) as covid_rip;

---- test 3

SELECT date_part('month', start_time) AS month, period_of_time, SUM(qty_rides) AS total_rides
	FROM (
   		SELECT start_time, count(bike_id) AS qty_rides,
           	CASE
               	WHEN start_time < '2020-03-10'::timestamp THEN 'pre_covid'
               	ELSE 'post_covid'
           	END AS period_of_time
    	FROM bluebikerides
    	GROUP BY start_time
	) AS covid_rip
GROUP BY date_part('month', start_time), period_of_time
ORDER BY date_part('month', start_time), period_of_time DESC;

-- subquery

SELECT 
    count(bike_id) AS qty_rides,
       CASE
              WHEN start_time < '2020-03-10'::timestamp THEN 'pre_covid'
               ELSE 'post_covid'
           END AS period_of_time
    FROM bluebikerides
    GROUP BY period_of_time
	
-- getting percentage of totals for comparison -- test 1

SELECT date_part('month', start_time) AS month, period_of_time, SUM(qty_rides) AS total_rides, pct_total_rides
	FROM (
		SELECT round(count(qty_rides)/sum(qty_rides)*100,2) as pct_total_rides
			FROM (
   				SELECT start_time, count(bike_id) AS qty_rides,
           			CASE
               			WHEN start_time < '2020-03-10'::timestamp THEN 'pre_covid'
               			ELSE 'post_covid'
           			END AS period_of_time
    			FROM bluebikerides
    			GROUP BY start_time
			) AS covid_rip
		GROUP BY period_of_time
	) AS pct_count
GROUP BY date_part('month', start_time), period_of_time
ORDER BY date_part('month', start_time);


--- test 2 ---- AVG BOOLEAN CASE!!!! DO THAT INSTEAD!!! 

SELECT month, covid_classifier, round(count(qty_rides)/sum(qty_rides)*100,2) as pct_total_rides
	FROM (
		SELECT qty_rides, date_part('month', start_time) AS month, covid_classifier, SUM(qty_rides) AS total_rides
			FROM (
   				SELECT start_time, count(bike_id) AS qty_rides,
           			CASE
               			WHEN start_time < '2020-03-10'::timestamp THEN 'pre_covid'
               			ELSE 'post_covid'
           			END AS covid_classifier
    			FROM bluebikerides
    			GROUP BY start_time
			) AS covid_rip
		GROUP BY date_part('month', start_time), covid_classifier, qty_rides
	) AS covid_rip_two_electric_boogaloo
GROUP BY date_part('month', start_time), covid_classifier
ORDER BY date_part('month', start_time), covid_classifier DESC;









---- #### Take Two on Setting up Union of all Bluebike Years and Descriptive Statistics #### -----


CREATE VIEW bluebikerides AS

SELECT *, NULL as user_postal_code, 'pre-covid' as covid_classification
FROM bluebike2018
	UNION ALL
SELECT *, NULL as user_postal_code, 'pre-covid' as covid_classification
FROM bluebike2019
	UNION ALL
SELECT *,
	CASE
		WHEN start_time < '2020-03-10'::timestamp THEN 'pre_covid'
        ELSE 'post_covid'
    END AS covid_classification
FROM bluebike2020
	UNION ALL
SELECT *, NULL as user_birth_year, NULL as user_gender, 'post-covid' as covid_classification
FROM bluebike2021
	UNION ALL
SELECT *, NULL as user_birth_year, NULL as user_gender, 'post-covid' as covid_classification
FROM bluebike2022
	UNION ALL
SELECT *, NULL as user_birth_year, NULL as user_gender, 'post-covid' as covid_classification
FROM bluebike2023;


-- descriptive statistics on bluebike --

--#PreCOVID

--total rides pre-covid
SELECT count(bike_id)
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid';
	-- 4,290,343
	
--avg rides per day pre-covid
SELECT count(*)/count(distinct date(start_time)) as avg_rides_per_day
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid';
	--5893

--avg rides per day pre-covid grouped by month
SELECT 
	date_part('month', start_time) as month, 
	count(*)/count(distinct date(start_time)) as avg_rides_per_day
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid'
GROUP BY 1;
/*
"month"	"avg_rides_per_day"
1		1816
2		2558
3		2710
4		4414
5		6483
6		7989
7		9029
8		9250
9		9989
10		8154
11		5202
12		2809
*/


--top starting stations pre-covid	
SELECT start_station_id, 
	count(bike_id)
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid'
GROUP BY start_station_id
ORDER BY 2 DESC
LIMIT 10;
	
/*
"start_station_id"	"count"
67					114902
80					88756
68					88342
22					80769
189					65375
190					65236
178					64371
107					61736
74					61095
179					53387
*/

--top ending stations pre-covid	
SELECT end_station_id, 
	count(bike_id)
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid'
GROUP BY end_station_id
ORDER BY 2 DESC
LIMIT 10;

/*
"end_station_id"	"count"
67					106621
68					88712
80					88197
190					84104
22					74756
107					69555
74					62772
178					60404
189					59139
36					51670
*/

-- user type breakdown pre-covid
SELECT 
	count(bike_id),
	user_type
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid'
GROUP BY 2;
	-- 865199 customers
	-- 3425144 subscribers 

--#PostCOVID
--total rides pre-covid
SELECT count(bike_id)
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid';
	-- 4,290,343
	
--avg rides per day pre-covid
SELECT count(*)/count(distinct date(start_time)) as avg_rides_per_day
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid';
	--5893

--avg rides per day pre-covid grouped by month
SELECT 
	date_part('month', start_time) as month, 
	count(*)/count(distinct date(start_time)) as avg_rides_per_day
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid'
GROUP BY 1;
/*
"month"	"avg_rides_per_day"
1		1816
2		2558
3		2710
4		4414
5		6483
6		7989
7		9029
8		9250
9		9989
10		8154
11		5202
12		2809
*/


--top starting stations pre-covid	
SELECT start_station_id, 
	count(bike_id)
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid'
GROUP BY start_station_id
ORDER BY 2 DESC
LIMIT 10;
	
/*
"start_station_id"	"count"
67					114902
80					88756
68					88342
22					80769
189					65375
190					65236
178					64371
107					61736
74					61095
179					53387
*/

--top ending stations pre-covid	
SELECT end_station_id, 
	count(bike_id)
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid'
GROUP BY end_station_id
ORDER BY 2 DESC
LIMIT 10;

/*
"end_station_id"	"count"
67					106621
68					88712
80					88197
190					84104
22					74756
107					69555
74					62772
178					60404
189					59139
36					51670
*/

-- user type breakdown pre-covid
SELECT 
	count(bike_id),
	user_type
FROM bluebikerides
WHERE covid_classification ilike 'pre-covid'
GROUP BY 2;
	-- 865199 customers
	-- 3425144 subscribers 

--#PostCOVID
--total rides post-covid
SELECT count(bike_id)
FROM bluebikerides
WHERE covid_classification ilike 'post-covid';
	-- 7,183,977

--avg rides per day post-covid
SELECT count(*)/count(distinct date(start_time)) as avg_rides_per_day
FROM bluebikerides
WHERE covid_classification ilike 'post-covid';
	--8771

--avg rides per day post-covid grouped by month
SELECT 
	date_part('month', start_time) as month, 
	count(*)/count(distinct date(start_time)) as avg_rides_per_day
FROM bluebikerides
WHERE covid_classification ilike 'post-covid'
GROUP BY 1;
/*
"month"	"avg_rides_per_day"
1		3193
2		3855
3		5596
4		7701
5		10025
6		11675
7		11935
8		13621
9		17221
10		13163
11		9025
12		4616
*/

--top starting stations post-covid	
SELECT start_station_id, 
	count(bike_id)
FROM bluebikerides
WHERE covid_classification ilike 'post-covid'
GROUP BY start_station_id
ORDER BY 2 DESC
LIMIT 10;
	
/*
"start_station_id"	"count"
67					168177
68					129887
74					107535
60					88230
178					84321
46					76776
107					74804
179					74107
9					68723
55					63580
*/

--top ending stations post-covid	
SELECT end_station_id, 
	count(bike_id)
FROM bluebikerides
WHERE covid_classification ilike 'post-covid'
GROUP BY end_station_id
ORDER BY 2 DESC
LIMIT 10;

/*
"end_station_id"	"count"
67					167974
68					130533
74					110171
60					88594
107					84512
178					80574
46					77397
179					70107
9					68839
55					65044
*/

-- user type breakdown post-covid
SELECT 
	count(bike_id),
	user_type
FROM bluebikerides
WHERE covid_classification ilike 'post-covid'
GROUP BY 2;
	-- 1840066 customers
	-- 5343911 subscribers 


-------------------------------------------------------------

SELECT 
	date_part('year', start_time) as year,
	covid_classification,
	count(bike_id) as qty_rides
FROM bluebikerides
GROUP BY 1,2
ORDER BY 1,2 DESC

/*
"year"	"covid_classification"	"qty_rides"
2018	"pre-covid"				1,767,806
2019	"pre-covid"				2,522,537
2020	"pre_covid"				313,114
2020	"post_covid"			1,760,334
2021	"post-covid"			2,934,377
2022	"post-covid"			3,757,282
2023	"post-covid"			492,318

*/ 
SELECT 
	count(bike_id) as qty_rides
FROM bbrides;

SELECT
	count(incident_ref)
FROM crashes
WHERE mode_type ilike 'bike';


SELECT
	deployment_year,
	count(id)
FROM stations_all
GROUP BY 1
ORDER BY 1;

SELECT 
	date_part('year',dispatch_time),
	count(incident_ref)
FROM crashes
WHERE mode_type ilike 'bike'
GROUP BY 1
ORDER BY 1;



SELECT 
	date_part('year',start_time),
	count(bike_id)
FROM bbrides
GROUP BY 1
ORDER BY 1;


SELECT 
	date_part('year',start_time),
	user_type,
	count(bike_id)
FROM bbrides
GROUP BY 1,2
ORDER BY 1,2;