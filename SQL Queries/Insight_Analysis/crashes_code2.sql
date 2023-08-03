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
	count(mode_type) qty_incidents
FROM crashes
WHERE mode_type ilike 'bike'
GROUP BY 1
ORDER BY 1;

-- by year and month
SELECT
	date_part('year', dispatch_time) crsh_yr,
	date_part('month', dispatch_time) crsh_mth,
	count(mode_type) qty_incidents
FROM crashes
WHERE mode_type ilike 'bike'
GROUP BY 1,2
ORDER BY 1,2;
	--bike incidents decreasing year-over-year!!

------

SELECT fac_type
FROM bike_facilities
GROUP BY 1;

-----
SELECT
	dispatch_time
FROM crashes
WHERE mode_type ilike 'bike'
ORDER BY 1 DESC
LIMIT 1;

CREATE SEQUENCE crsh_seq START WITH 71232093840;


ALTER TABLE crashes ADD incident_ref serial;

---- cry cry cry --- updated SRID for bike_facilities to match crashes SRID

select UpdateGeometrySRID('public', 'crashes', 'geom', 4326) 

------ can I calculate some distances SOS -----

SELECT
    ST_ShortestLine(b.geom::geometry, cr.geom::geometry),
    cr.incident_ref cr_id,
    b.id AS b_id,
    ST_Length(ST_ShortestLine(b.geom::geometry, cr.geom::geometry)) AS distance
FROM
   crashes cr, bike_facilities b
WHERE (b.open_date not ilike '%2019%' 
	or b.open_date not ilike '%2020%' 
	or b.open_date not ilike '%2021%'
	or b.open_date not ilike '%2022%'
	or b.open_date not ilike '%2023%')
	and date_part('year',cr.dispatch_time::date) = 2018
GROUP BY
    cr.incident_ref, 3,1
ORDER BY
    MIN(ST_Length(ST_ShortestLine(b.geom::geometry, cr.geom::geometry)));
	
	
------------------- try 2 --------------
CREATE VIEW crashlane_2018 AS


--- calculating the shortest distance between each bicycle crash and any bike lane point for crashes in 2018 and bike lanes opened before or on that year
SELECT 
	cr.incident_ref cr_id,  -- crash id
	cr.geom cr_geom, -- crash geometry
	b_id, -- bike facility id
	b_geom, -- bike geometry
	distance -- (???) shortest distance
FROM crashes cr CROSS JOIN LATERAL (
	SELECT
		b.geom b_geom,
		b.id b_id,
		ST_DistanceSpheroid(b.geom, cr.geom) distance
	FROM bike_facilities b
	WHERE (b.open_date not ilike '%2019%' ---- their bike open date column is a mess of just years, mm/dd/yyyy, SEASON-yyyy, so I had to go for a quirky filter
	or b.open_date not ilike '%2020%' 		--- yes now as I troubleshoot in part 2, I'll fix up this messy messy section 
	or b.open_date not ilike '%2021%'
	or b.open_date not ilike '%2022%'
	or b.open_date not ilike '%2023%')
	and date_part('year',cr.dispatch_time::date) = 2018
	ORDER BY min(ST_Distance(b.geom, cr.geom))
	LIMIT 1
) calc
ORDER BY 5 ASC;

-----------------------

CREATE VIEW crashlane_2023 AS

SELECT 
	cr.incident_ref cr_id,
	cr.geom cr_geom,
	b_id,
	b_geom,
	distance
FROM crashes cr CROSS JOIN LATERAL (
	SELECT
		b.geom b_geom,
		b.id b_id,
		((b.geom) <-> (cr.geom)) distance
	FROM bike_facilities b
	WHERE date_part('year',cr.dispatch_time::date) = 2023
	ORDER BY ((b.geom) <-> (cr.geom))
	LIMIT 1
) calc;

----------------------- another attempt
	
SELECT 
	cr.incident_ref cr_id,  -- crash id
	b_id, -- bike facility id
	b_fac_type,
	distance -- (???) shortest distance
FROM crashes cr CROSS JOIN LATERAL (
	SELECT
		b.geom b_geom,
		b.fac_type b_fac_type,
		b.id b_id,
		ST_Contains(b.geom, cr.geom) distance
	FROM bike_facilities b
	WHERE (b.open_date not ilike '%2019%' ---- their bike open date column is a mess of just years, mm/dd/yyyy, SEASON-yyyy, so I had to go for a quirky filter
	or b.open_date not ilike '%2020%' 
	or b.open_date not ilike '%2021%'
	or b.open_date not ilike '%2022%'
	or b.open_date not ilike '%2023%')
	and date_part('year',cr.dispatch_time::date) = 2018
) calc
ORDER BY 4 ASC;
---------------------------- 


SELECT 
	cr.incident_ref cr_id,
	b.id b_id,
	b.fac_type,
	
	
