﻿--onatario population
DROP TABLE IF EXISTS ontario_synthetic_population_long;

CREATE TABLE ontario_synthetic_population_long (
	rowid integer primary key, 
	hhid integer,
	taz integer,
	hhinc integer,
	dtype integer,
	zone_id integer,
	num_pp integer);

COPY ontario_synthetic_population_long from 'C:/mto_longDistanceTravel/syntheticPopulation/households_qt.csv' csv header;

--ontario employment

DROP TABLE IF EXISTS ontario_employment;

CREATE TABLE ontario_employment(
zone_id integer,
naics_11 integer,
naics_21 integer,
naics_22 integer,
naics_23 integer,
naics_31 integer,
naics_41 integer,
naics_44 integer,
naics_48 integer,
naics_51 integer,
naics_52 integer,
naics_53 integer,
naics_54 integer,
naics_55 integer,
naics_56 integer,
naics_61 integer,
naics_62 integer,
naics_71 integer,
naics_72 integer,
naics_81 integer,
naics_91 integer);

COPY ontario_employment from 'C:/mto_longDistanceTravel/SocioeconomicData/Jobs_QT_Ontario_wide.csv' csv header;

DROP TABLE IF EXISTS pop_jobs_data_ontario;

--move employment data to a new table that can also hold population
SELECT zone_id, 0 as population, naics_11,naics_21,naics_22,naics_23,naics_31,naics_41,
naics_44,naics_48,naics_51,naics_52,naics_53,naics_54,naics_55,naics_56,naics_61,naics_62,naics_71,naics_72,naics_81,naics_91, (naics_11+naics_21+naics_22+naics_23+naics_31+naics_41+
naics_44+naics_48+naics_51+naics_52+naics_53+naics_54+naics_55+naics_56+naics_61+naics_62+naics_71+naics_72+naics_81+naics_91) as total_employment
INTO pop_jobs_data_ontario
FROM ontario_employment;

--drop the old table
DROP TABLE IF EXISTS ontario_employment;

UPDATE pop_jobs_data_ontario as a
SET population = p.population
from (
		SELECT zone_id, sum(num_pp) as population
		FROM ontario_synthetic_population_long
		GROUP BY zone_id
	) as p
WHERE a.zone_id = p.zone_id

--canada population and employment
DROP TABLE IF EXISTS pop_jobs_data_canada;

CREATE TABLE pop_jobs_data_canada(
id integer,
cma_pr_code integer PRIMARY KEY,
population integer,
naics_99 integer,
naics_11 integer,
naics_21 integer,
naics_22 integer,
naics_23 integer,
naics_31 integer,
naics_41 integer,
naics_44 integer,
naics_48 integer,
naics_51 integer,
naics_52 integer,
naics_53 integer,
naics_54 integer,
naics_55 integer,
naics_56 integer,
naics_61 integer,
naics_62 integer,
naics_71 integer,
naics_72 integer,
naics_81 integer,
naics_91 integer,
zone_id integer);

COPY pop_jobs_data_canada FROM 'C:/mto_longDistanceTravel/SocioeconomicData/JobsPop_Canada_coded.csv' csv header;

alter table pop_jobs_data_canada ADD COLUMN total_employment integer;
update pop_jobs_data_canada set total_employment = (naics_99 + naics_11 + naics_21 + naics_22 + naics_23 + 
	naics_31 + naics_41 + naics_44 + naics_48 + naics_51 + naics_52 + naics_53 + naics_54 + 
	naics_55 + naics_56 + naics_61 + naics_62 + naics_71 + naics_72 + naics_81 + naics_91);

--us population and employment
DROP TABLE IF EXISTS pop_jobs_data_us;

CREATE TABLE pop_jobs_data_us(
f4z integer,
zone_id integer,
naics_11 integer,
naics_21 integer,
naics_22 integer,
naics_23 integer,
naics_31 integer,
naics_42 integer,
naics_44 integer,
naics_48 integer,
naics_51 integer,
naics_52 integer,
naics_53 integer,
naics_54 integer,
naics_55 integer,
naics_56 integer,
naics_61 integer,
naics_62 integer,
naics_71 integer,
naics_72 integer,
naics_81 integer,
naics_99 integer,
population integer);

COPY pop_jobs_data_us FROM 'C:/mto_longDistanceTravel/SocioeconomicData/JobsPop_US.csv' csv header;

alter table pop_jobs_data_us ADD COLUMN total_employment integer;
update pop_jobs_data_us set total_employment = (naics_99 + naics_11 + naics_21 + naics_22 + naics_23 + 
	naics_31 + naics_42 + naics_44 + naics_48 + naics_51 + naics_52 + naics_53 + naics_54 + 
	naics_55 + naics_56 + naics_61 + naics_62 + naics_71 + naics_72 + naics_81);

	--zones_pop_emp_type
	--internal_external_zone_aggregation
