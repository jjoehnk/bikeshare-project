---- exploratory covid analysis -----


SELECT
	c.date,
	c.new_covid_cases,
	e.emergency_department_visits,
	round(h.hospitalizations,0) hospitalizations
FROM covid_cases c
	JOIN covid_emergency_visits e ON c.date = e.date
	JOIN covid_hospitalizations h ON c.date = h.date;
	
	
---- bike rides per day versus covid spread ----


SELECT
	cc.date cldr_date,
	cc.new_covid_cases qty_covid_cases,
	cev.emergency_department_visits qty_emergency_visits,
	round(ch.hospitalizations,0) qty_hospitalizations,
	count(bb.bike_id) qty_rides
FROM bbrides bb
JOIN covid_cases cc
	ON bb.start_time::date = cc.date
JOIN covid_emergency_visits cev
	ON bb.start_time::date = cev.date
JOIN covid_hospitalizations ch
	ON bb.start_time::date = ch.date
GROUP BY 1,2,3,4
ORDER BY 1;



----- calculating correlation coefficent between bike rides and covid numbers ----
SELECT 
	corr(qty_covid_cases,qty_rides) corr_cases_rides,
	corr(qty_emergency_visits,qty_rides) corr_ev_rides,
	corr(qty_hospitalizations,qty_rides) corr_hosp_rides
FROM (
	SELECT
		cc.date cldr_date,
		cc.new_covid_cases qty_covid_cases,
		cev.emergency_department_visits qty_emergency_visits,
		round(ch.hospitalizations,0) qty_hospitalizations,
		count(bb.bike_id) qty_rides
		FROM bbrides bb
		JOIN covid_cases cc
			ON bb.start_time::date = cc.date
		JOIN covid_emergency_visits cev
			ON bb.start_time::date = cev.date
		JOIN covid_hospitalizations ch
			ON bb.start_time::date = ch.date
		GROUP BY 1,2,3,4
		ORDER BY 1) as t1;		
/*
"corr_cases_rides"			"corr_ev_rides"				"corr_hosp_rides"
-0.24154979964259726		-0.09308436694078108		-0.44246926674527326
*/


---- SARS variants grouping ----

/* main variant strains and common name:

--Omicron - BA.1
--Delta - B.1.617.2
--Delta Plus - AY.4.2
--Beta - B.1.351
--Alpha - B.1.1.7

*/

SELECT
	week_ending,
	variant, 
	sum(share)
FROM public."SARS_variants"
GROUP BY 1,2
HAVING variant ilike 'b.1.617.2'
	OR variant ilike 'b.1.1.7'
	OR variant ilike 'ba.1'
	OR variant ilike 'ay.4.2'
	OR variant ilike 'b.1.351'
ORDER BY 1;


	