---- Part 2 bikeshare project ----



--- Testing bike lanes and crashes further



SELECT cr.*
FROM crashes cr, bike_facilities b
WHERE cr.mode_type ilike 'bike'
	and st_intersects(st_transform(cr.geom,4326),st_transform(b.geom,4326));
	
	
	
SELECT DISTINCT ON (cr.incident_ref)
	cr.geom, 
	b.geom,
	cr.dispatch_time, 
	b.open_date,
	b.id,
	st_distance(cr.geom,b.geom) as distance
FROM crashes cr
	LEFT JOIN bike_facilities b
	ON st_dwithin(cr.geom,b.geom,10000)
ORDER BY cr.incident_ref,distance;