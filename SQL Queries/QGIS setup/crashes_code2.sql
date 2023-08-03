ALTER TABLE crashes
ADD COLUMN geom geometry(point,4326);


UPDATE crashes
SET geom = ST_SetSRID(ST_MakePoint(longitude,latitude),4326);

---- bike crash exploratory analysis --- 


-- breakdown by type of crash
SELECT
	mode_type,
	count(mode_type) qty_incidents
FROM crashes
GROUP BY 1;

/*
"mode_type"	"qty_incidents"
"mv"		22141
"ped"		4399
"bike"		2415
*/

-- bike crash by date


SELECT
	date_part('year', dispatch_time) crsh_yr,
	date_part('month', dispatch_time) crsh_mth,
	count(mode_type) qty_incidents
FROM crashes
WHERE mode_type ilike 'bike'
GROUP BY 1,2
ORDER BY 1,2;
	--bike incidents decreasing year-over-year!!
	


ALTER TABLE crashes ADD COLUMN incident_ref serial;

ALTER TABLE crashes ALTER COLUMN incident_ref row_number() OVER (ORDER BY dispatch_time) +5093982409302948;