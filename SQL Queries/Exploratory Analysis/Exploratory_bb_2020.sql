-- bluebike summary statistics --> 2020

SELECT count(bike_id)
FROM bluebike2020;
	-- 2.073,448 rides 

	
SELECT 
	date_part('month', start_time) as month,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/2073448.00)*100),2) as pct_total_rides
FROM bluebike2020
GROUP BY date_part('month', start_time)
ORDER BY date_part('month', start_time);

/*
"month"	"qty_rides"	"pct_total_rides"
1		128598		6.20
2		133235		6.43
3		107350		5.18
4		46793		2.26
5		124879		6.02
6		191843		9.25
7		259726		12.53
8		289033		13.94
9		307853		14.85
10		248424		11.98
11		161712		7.80
12		74002		3.57
*/

SELECT 
	date_part('hour', start_time) as hour_of_day,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/2073448.00)*100),2) as pct_total_rides
FROM bluebike2020
GROUP BY date_part('hour', start_time)
ORDER BY date_part('hour', start_time);

/*
"hour"	"qty_rides"	"pct_total_rides"
0		21382		1.03
1		13635		0.66
2		7450		0.36
3		4307		0.21
4		4377		0.21
5		13251		0.64
6		36585		1.76
7		71254		3.44
8		109055		5.26
9		93100		4.49
10		88844		4.28
11		104659		5.05
12		126052		6.08
13		132933		6.41
14		137647		6.64
15		150725		7.27
16		175023		8.44
17		210286		10.14
18		189279		9.13
19		143585		6.92
20		96166		4.64
21		64340		3.10
22		47010		2.27
23		32503		1.57
*/