-- bluebike summary statistics --> 2019

SELECT count(bike_id)
FROM bluebike2019;
	-- 2.522.537 rides 

	
SELECT 
	date_part('month', start_time) as month,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/2522537.00)*100),2) as pct_total_rides
FROM bluebike2019
GROUP BY date_part('month', start_time)
ORDER BY date_part('month', start_time);

/*
"month"	"qty_rides"	"pct_total_rides"
1		69872		2.77
2		80466		3.19
3		102369		4.06
4		166694		6.61
5		223084		8.84
6		274022		10.86
7		316931		12.56
8		337443		13.38
9		363185		14.40
10		305504		12.11
11		190759		7.56
12		92208		3.66
*/

SELECT 
	date_part('hour', start_time) as hour_of_day,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/2522537.00)*100),2) as pct_total_rides
FROM bluebike2019
GROUP BY date_part('hour', start_time)
ORDER BY date_part('hour', start_time);

/*
"hour"	"qty_rides"	"pct_total_rides"
0		20420		0.81
1		14251		0.56
2		8752		0.35
3		3078		0.12
4		3394		0.13
5		15065		0.60
6		47183		1.87
7		130160		5.16
8		229859		9.11
9		141669		5.62
10		103618		4.11
11		115789		4.59
12		133666		5.30
13		133051		5.27
14		133146		5.28
15		151757		6.02
16		216366		8.58
17		284948		11.30
18		214919		8.52
19		150239		5.96
20		103766		4.11
21		76284		3.02
22		55744		2.21
23		35413		1.40
*/