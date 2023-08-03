-- bluebike summary statistics --> 2021

SELECT count(bike_id)
FROM bluebike2021;
	-- 2,934,378 rides 

	
SELECT 
	date_part('month', start_time) as month,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/2934378.00)*100),2) as pct_total_rides
FROM bluebike2021
GROUP BY date_part('month', start_time);

/*
"month"	"qty_rides"	"pct_total_rides"
1		71806		2.45
2		60446		2.06
3		139047		4.74
4		187816		6.40
5		270893		9.23
6		311969		10.63
7		309403		10.54
8		357338		12.18
9		432254		14.73
10		399182		13.60
11		250925		8.55
12		143299		4.88
*/

SELECT 
	date_part('hour', start_time) as hour_of_day,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/2934378.00)*100),2) as pct_total_rides
FROM bluebike2021
GROUP BY date_part('hour', start_time);

/*
"hour"	"qty_rides"	"pct_total_rides"
0		139946		4.77
1		104398		3.56
2		85036		2.90
3		63759		2.17
4		45461		1.55
5		40676		1.39
6		24712		0.84
7		9222		0.31
8		6307		0.21
9		13796		0.47
10		36784		1.25
11		81600		2.78
12		142266		4.85
13		139538		4.76
14		130882		4.46
15		146126		4.98
16		171800		5.85
17		179491		6.12
18		187814		6.40
19		202199		6.89
20		231935		7.90
21		283789		9.67
22		264691		9.02
23		202150		6.89
*/