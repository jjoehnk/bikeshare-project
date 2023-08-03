-- bluebike summary statistics --> 2022

SELECT count(bike_id)
FROM bluebike2022;
	-- 3,757,281 rides 

	
SELECT 
	date_part('month', start_time) as month,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/3757281.00)*100),2) as pct_total_rides
FROM bluebike2022
GROUP BY date_part('month', start_time);

/*
"month"	"qty_rides"	"pct_total_rides"
1		81613		2.17
2		110460		2.94
3		182421		4.86
4		274264		7.30
5		350660		9.33
6		388531		10.34
7		430585		11.46
8		487201		12.97
9		601049		16.00
10		416964		11.10
11		290621		7.73
12		142912		3.80
*/

SELECT 
	date_part('hour', start_time) as hour_of_day,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/3757281.00)*100),2) as pct_total_rides
FROM bluebike2022
GROUP BY date_part('hour', start_time);

/*
"hour"	"qty_rides"	"pct_total_rides"
0		139946		3.72
1		104398		2.78
2		85036		2.26
3		63759		1.70
4		45461		1.21
5		40676		1.08
6		24712		0.66
7		9222		0.25
8		6307		0.17
9		13796		0.37
10		36784		0.98
11		81600		2.17
12		142266		3.79
13		139538		3.71
14		130882		3.48
15		146126		3.89
16		171800		4.57
17		179491		4.78
18		187814		5.00
19		202199		5.38
20		231935		6.17
21		283789		7.55
22		264691		7.04
23		202150		5.38
*/