-- .read Lessons/1.22/1.22_DDL_DML_Pt2.sql
/*
100% ?██████████████████████████████████████? (00:00:03.63 elapsed)     
┌─────────┬──────────────────────┬──────────────────────┬──────────────────────┬──────────────────────┬───┬─────────────┬─────────────────┬───────────────────┬───────────────┬──────────────────────┐
│ job_id  │   job_title_short    │      job_title       │     job_location     │       job_via        │ . │ salary_rate │ salary_year_avg │  salary_hour_avg  │ cd_company_id │     company_link     │
│  int32  │       varchar        │       varchar        │       varchar        │       varchar        │   │   varchar   │     double      │      double       │     int32     │       varchar        │
├─────────┼──────────────────────┼──────────────────────┼──────────────────────┼──────────────────────┼───┼─────────────┼─────────────────┼───────────────────┼───────────────┼──────────────────────┤
│ 1575803 │ Data Engineer        │ Palantir Data Engi.  │ Jacksonville, FL     │ Indeed               │ . │ hour        │            NULL │ 52.76000213623047 │       1454874 │ Global Technology .  │
│ 1575804 │ Software Engineer    │ Developer - Softwa.  │ Chantilly, VA        │ Security Clearance.  │ . │ NULL        │            NULL │              NULL │       1575804 │ Agile Business Con.  │
│ 1575805 │ Data Engineer        │ Data Engineer/SQL .  │ Festus, MO           │ LinkedIn             │ . │ year        │         90000.0 │              NULL │         54942 │ Concero              │
│ 1575806 │ Data Engineer        │ Big Data Developer   │ Mountain View, CA    │ LinkedIn             │ . │ NULL        │            NULL │              NULL │         16323 │ Net2Source Inc.      │
│ 1575807 │ Data Engineer        │ Azure Data Enginee.  │ Jersey City, NJ      │ Dice                 │ . │ NULL        │            NULL │              NULL │        309494 │ HYR Global Source .  │
│ 1575808 │ Data Engineer        │ Sr. Data Engineer .  │ Cleveland, OH        │ Indeed               │ . │ year        │        120000.0 │              NULL │       1563262 │ Brillfy Technology   │
│ 1575809 │ Senior Data Engineer │ Sr Data Architect    │ Marysville, OH       │ LinkedIn             │ . │ hour        │            NULL │              58.5 │          6069 │ Insight Global       │
│ 1575810 │ Data Engineer        │ Data Engineer, Dig.  │ Maharashtra, India   │ Indeed               │ . │ NULL        │            NULL │              NULL │         27952 │ General Mills        │
│ 1575811 │ Senior Data Engineer │ Senior Data Engine.  │ Karnataka, India     │ Indeed               │ . │ NULL        │            NULL │              NULL │          5133 │ DXC Technology       │
│ 1575812 │ Data Engineer        │ Lead Data Engineer   │ Vadodara, Gujarat,.  │ SimplyHired          │ . │ NULL        │            NULL │              NULL │        308468 │ Wiser Solutions      │
├─────────┴──────────────────────┴──────────────────────┴──────────────────────┴──────────────────────┴───┴─────────────┴─────────────────┴───────────────────┴───────────────┴──────────────────────┤
│ 10 rows                                                                                                                                                                      17 columns (10 shown) │
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
100% ?██████████████████████████████████████? (00:00:04.05 elapsed)     
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    483252    │
└──────────────┘
┌──────────────────────┬───────────┐
│   job_title_short    │ job_count │
│       varchar        │   int64   │
├──────────────────────┼───────────┤
│ Data Engineer        │    391957 │
│ Senior Data Engineer │     91295 │
└──────────────────────┴───────────┘
*/



-- CTAS – CREATE TABLE AS SELECT

CREATE OR REPLACE TABLE staging.job_postings_flat AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.company_id       AS cd_company_id,
    cd.name            AS company_link
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim   AS cd
       ON jpf.company_id = cd.company_id;


-- SELECT COUNT(*)
-- FROM staging.job_postings_flat;
/*
┌────────────────┐
│  count_star()  │
│     int64      │
├────────────────┤
│    1615930     │
│ (1.62 million) │
└────────────────┘
*/


SELECT *
FROM staging.job_postings_flat
LIMIT 10;
/*
┌─────────┬──────────────────────┬──────────────────────┬──────────────────────┬──────────────────────┬───┬─────────────┬─────────────────┬───────────────────┬───────────────┬──────────────────────┐
│ job_id  │   job_title_short    │      job_title       │     job_location     │       job_via        │ . │ salary_rate │ salary_year_avg │  salary_hour_avg  │ cd_company_id │     company_link     │   
│  int32  │       varchar        │       varchar        │       varchar        │       varchar        │   │   varchar   │     double      │      double       │     int32     │       varchar        │   
├─────────┼──────────────────────┼──────────────────────┼──────────────────────┼──────────────────────┼───┼─────────────┼─────────────────┼───────────────────┼───────────────┼──────────────────────┤
│ 1575803 │ Data Engineer        │ Palantir Data Engi.  │ Jacksonville, FL     │ Indeed               │ . │ hour        │            NULL │ 52.76000213623047 │       1454874 │ Global Technology .  │
│ 1575804 │ Software Engineer    │ Developer - Softwa.  │ Chantilly, VA        │ Security Clearance.  │ . │ NULL        │            NULL │              NULL │       1575804 │ Agile Business Con.  │   
│ 1575805 │ Data Engineer        │ Data Engineer/SQL .  │ Festus, MO           │ LinkedIn             │ . │ year        │         90000.0 │              NULL │         54942 │ Concero              │   
│ 1575806 │ Data Engineer        │ Big Data Developer   │ Mountain View, CA    │ LinkedIn             │ . │ NULL        │            NULL │              NULL │         16323 │ Net2Source Inc.      │   
│ 1575807 │ Data Engineer        │ Azure Data Enginee.  │ Jersey City, NJ      │ Dice                 │ . │ NULL        │            NULL │              NULL │        309494 │ HYR Global Source .  │   
│ 1575808 │ Data Engineer        │ Sr. Data Engineer .  │ Cleveland, OH        │ Indeed               │ . │ year        │        120000.0 │              NULL │       1563262 │ Brillfy Technology   │   
│ 1575809 │ Senior Data Engineer │ Sr Data Architect    │ Marysville, OH       │ LinkedIn             │ . │ hour        │            NULL │              58.5 │          6069 │ Insight Global       │   
│ 1575810 │ Data Engineer        │ Data Engineer, Dig.  │ Maharashtra, India   │ Indeed               │ . │ NULL        │            NULL │              NULL │         27952 │ General Mills        │   
│ 1575811 │ Senior Data Engineer │ Senior Data Engine.  │ Karnataka, India     │ Indeed               │ . │ NULL        │            NULL │              NULL │          5133 │ DXC Technology       │   
│ 1575812 │ Data Engineer        │ Lead Data Engineer   │ Vadodara, Gujarat,.  │ SimplyHired          │ . │ NULL        │            NULL │              NULL │        308468 │ Wiser Solutions      │   
├─────────┴──────────────────────┴──────────────────────┴──────────────────────┴──────────────────────┴───┴─────────────┴─────────────────┴───────────────────┴───────────────┴──────────────────────┤   
│ 10 rows                                                                                                                                                                      17 columns (10 shown) │   
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/





-- CREATE VIEW
CREATE OR REPLACE VIEW staging.priority_jobs_flat_view AS 
SELECT 
    jpf.*
FROM staging.job_postings_flat AS jpf
JOIN staging.priority_roles AS pr
    ON jpf.job_title_short = pr.role_name
WHERE pr.priority_lvl = 1;

SELECT COUNT(*)
FROM staging.priority_jobs_flat_view;
/*
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    483252    │
└──────────────┘
*/

SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM staging.priority_jobs_flat_view
GROUP BY job_title_short
ORDER BY job_count DESC;
/*
┌──────────────────────┬───────────┐
│   job_title_short    │ job_count │
│       varchar        │   int64   │
├──────────────────────┼───────────┤
│ Data Engineer        │    391957 │
│ Senior Data Engineer │     91295 │
└──────────────────────┴───────────┘
*/




-- CREATE TEMP TABLE

CREATE TEMPORARY TABLE senior_jobs_flat_temp AS
SELECT *
FROM staging.priority_jobs_flat_view
WHERE job_title_short = 'Senior Data Engineer';


SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM senior_jobs_flat_temp
GROUP BY job_title_short
ORDER BY job_count DESC;
/*
┌──────────────────────┬───────────┐
│   job_title_short    │ job_count │
│       varchar        │   int64   │
├──────────────────────┼───────────┤
│ Senior Data Engineer │   91295   │
└──────────────────────┴───────────┘
*/





-- DELETE

SELECT COUNT(*) FROM staging.job_postings_flat;
/*
┌────────────────┐
│  count_star()  │
│     int64      │
├────────────────┤
│    1615930     │
│ (1.62 million) │
└────────────────┘
*/
SELECT COUNT(*) FROM staging.priority_jobs_flat_view;
/*
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    483252    │
└──────────────┘
*/
SELECT COUNT(*) FROM senior_jobs_flat_temp;
/*
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    91295     │
└──────────────┘
*/


DELETE FROM staging.job_postings_flat
WHERE job_posted_date < '2024-01-01';


SELECT COUNT(*) FROM staging.job_postings_flat;
/*
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    828574    │
└──────────────┘
*/

SELECT COUNT(*) FROM staging.priority_jobs_flat_view;
/*
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    251946    │
└──────────────┘
*/

SELECT COUNT(*) FROM senior_jobs_flat_temp;
/*
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    91295     │
└──────────────┘
*/




-- TRUNCATE

CREATE OR REPLACE TABLE staging.job_postings_flat AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.company_id       AS cd_company_id,
    cd.name            AS company_link
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim   AS cd
       ON jpf.company_id = cd.company_id;

-- SELECT COUNT(*) FROM staging.job_postings_flat;
/*
┌────────────────┐
│  count_star()  │
│     int64      │
├────────────────┤
│    1615930     │
│ (1.62 million) │
└────────────────┘
*/


TRUNCATE TABLE staging.job_postings_flat;


SELECT COUNT(*) FROM staging.job_postings_flat;
/*
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│      0       │
└──────────────┘
*/

SELECT * FROM staging.job_postings_flat;
/*
┌────────┬─────────────────┬───────────┬──────────────┬─────────┬───────────────────┬───┬─────────────┬─────────────┬─────────────────┬─────────────────┬───────────────┬──────────────┐
│ job_id │ job_title_short │ job_title │ job_location │ job_via │ job_schedule_type │ . │ job_country │ salary_rate │ salary_year_avg │ salary_hour_avg │ cd_company_id │ company_link │
│ int32  │     varchar     │  varchar  │   varchar    │ varchar │      varchar      │   │   varchar   │   varchar   │     double      │     double      │     int32     │   varchar    │
├────────┴─────────────────┴───────────┴──────────────┴─────────┴───────────────────┴───┴─────────────┴─────────────┴─────────────────┴─────────────────┴───────────────┴──────────────┤
│                                                                                        0 rows                                                                                        │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


INSERT INTO staging.job_postings_flat
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.company_id       AS cd_company_id,
    cd.name            AS company_link
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim   AS cd
       ON jpf.company_id = cd.company_id
WHERE job_posted_date >= '2024-01-01';


SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.priority_jobs_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;

/*
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    828574    │
└──────────────┘
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    251946    │
└──────────────┘
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    91295     │
└──────────────┘
*/
