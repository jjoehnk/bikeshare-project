-- bluebike summary statistics --> 2023

SELECT count(bike_id)
FROM bluebike2023;
	-- 492,318 rides 

	
SELECT 
	date_part('month', start_time) as month,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/492318.00)*100),2) as pct_total_rides
FROM bluebike2023
GROUP BY date_part('month', start_time);

/*
"month"	"qty_rides"	"pct_total_rides"
1		140340		28.51
2		152975		31.07
3		199003		40.42
*/

SELECT 
	date_part('hour', start_time) as hour,
	count(bike_id) as qty_rides,
	round(((count(bike_id)::numeric/492318.00)*100),2) as pct_total_rides
FROM bluebike2023
GROUP BY date_part('hour', start_time)
ORDER BY date_part('hour', start_time);

/*
"hour"	"qty_rides"	"pct_total_rides"
0		4689		0.95
1		3690		0.75
2		2047		0.42
3		803			0.16
4		765			0.16
5		2472		0.50
6		7547		1.53
7		19147		3.89
8		37888		7.70
9		30650		6.23
10		23857		4.85
11		24536		4.98
12		27413		5.57
13		28166		5.72
14		28983		5.89
15		32895		6.68
16		41081		8.34
17		51236		10.41
18		42526		8.64
19		29237		5.94
20		19990		4.06
21		14780		3.00
22		10726		2.18
23		7194		1.46
*/