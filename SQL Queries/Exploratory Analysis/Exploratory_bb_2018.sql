-- bluebike summary statistics --> 2018

SELECT count(bike_id)
FROM bluebike2018;
	-- 1,767,806 rides 

	
SELECT 
	date_part('month', start_time) as month,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/1767806)*100),2) as pct_total_rides
FROM bluebike2018
GROUP BY date_part('month', start_time);

/*
"month"	"qty_rides"	"pct_total_rides"
1		40932		2.32
2		62817		3.55
3		62985		3.56
4		98194		5.55
5		178865		10.12
6		205359		11.62
7		242916		13.74
8		236076		13.35
9		236182		13.36
10		200100		11.32
11		121419		6.87
12		81961		4.64
*/

SELECT 
	date_part('hour', start_time) as hour_of_day,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/1767806)*100),2) as pct_total_rides
FROM bluebike2018
GROUP BY date_part('hour', start_time);

/*
"hour"	"qty_rides"	"pct_total_rides"
0		14381		0.81
1		9333		0.53
2		5968		0.34
3		2217		0.13
4		2339		0.13
5		10571		0.60
6		35046		1.98
7		96792		5.48
8		167768		9.49
9		98617		5.58
10		72210		4.08
11		79697		4.51
12		93262		5.28
13		92421		5.23
14		91282		5.16
15		104081		5.89
16		153387		8.68
17		201799		11.42
18		147780		8.36
19		102336		5.79
20		70877		4.01
21		52345		2.96
22		38650		2.19
23		24647		1.39
*/