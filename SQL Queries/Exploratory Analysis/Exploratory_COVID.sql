-- COVID new cases descriptive statistics -- 

SELECT count(new_covid_cases)
FROM covid_cases; 
	-- 1225
	
SELECT sum(new_covid_cases)
FROM covid_cases; 
	-- 220,267

SELECT avg(new_covid_cases)
FROM covid_cases; 
	-- 179.81
	
SELECT min(new_covid_cases)
FROM covid_cases; 
	-- 0
	
SELECT max(new_covid_cases)
FROM covid_cases;
	-- 4353
	
SELECT stddev(new_covid_cases)
FROM covid_cases;
	-- 346.19


-- COVID emergency visits descriptive statistics -- 

SELECT count(emergency_department_visits)
FROM covid_emergency_visits; 
	-- 1071
	
SELECT sum(emergency_department_visits)
FROM covid_emergency_visits; 
	-- 225,783

SELECT avg(emergency_department_visits)
FROM covid_emergency_visits; 
	-- 179.81
	
SELECT min(emergency_department_visits)
FROM covid_emergency_visits; 
	-- 0
	
SELECT max(emergency_department_visits)
FROM covid_emergency_visits; 
	-- 670
	
SELECT stddev(emergency_department_visits)
FROM covid_emergency_visits; 
	-- 80.02
	
	
-- COVID hospitalizations descriptive statistics -- 

SELECT count(hospitalization_cases)
FROM covid_hospitalizations; 
	-- 1468
	
SELECT sum(hospitalization_cases)
FROM covid_hospitalizations; 
	-- 257,909.86

SELECT avg(hospitalization_cases)
FROM covid_hospitalizations; 
	-- 175.68
	
SELECT min(hospitalization_cases)
FROM covid_hospitalizations; 
	-- 22
	
SELECT max(hospitalization_cases)
FROM covid_hospitalizations; 
	-- 4353
	
SELECT stddev(hospitalization_cases)
FROM covid_hospitalizations; 
	-- 346.19