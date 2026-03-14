SELECT *
FROM information_schema.columns;


SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';

/*
┌───────────────────┬───────────────────────┬───────────┐
│    table_name     │      column_name      │ data_type │
│      varchar      │        varchar        │  varchar  │
├───────────────────┼───────────────────────┼───────────┤
│ job_postings_fact │ job_id                │ INTEGER   │
│ job_postings_fact │ company_id            │ INTEGER   │
│ job_postings_fact │ job_title_short       │ VARCHAR   │
│ job_postings_fact │ job_title             │ VARCHAR   │
│ job_postings_fact │ job_location          │ VARCHAR   │
│ job_postings_fact │ job_via               │ VARCHAR   │
│ job_postings_fact │ job_schedule_type     │ VARCHAR   │
│ job_postings_fact │ job_work_from_home    │ BOOLEAN   │
│ job_postings_fact │ search_location       │ VARCHAR   │
│ job_postings_fact │ job_posted_date       │ TIMESTAMP │
│ job_postings_fact │ job_no_degree_mention │ BOOLEAN   │
│ job_postings_fact │ job_health_insurance  │ BOOLEAN   │
│ job_postings_fact │ job_country           │ VARCHAR   │
│ job_postings_fact │ salary_rate           │ VARCHAR   │
│ job_postings_fact │ salary_year_avg       │ DOUBLE    │
│ job_postings_fact │ salary_hour_avg       │ DOUBLE    │
├───────────────────┴───────────────────────┴───────────┤
│ 16 rows                                     3 columns │
└───────────────────────────────────────────────────────┘
*/




DESCRIBE job_postings_fact;

/*
┌───────────────────────┬─────────────┬─────────┬─────────┬─────────┬─────────┐
│      column_name      │ column_type │  null   │   key   │ default │  extra  │
│        varchar        │   varchar   │ varchar │ varchar │ varchar │ varchar │
├───────────────────────┼─────────────┼─────────┼─────────┼─────────┼─────────┤
│ job_id                │ INTEGER     │ NO      │ PRI     │ NULL    │ NULL    │
│ company_id            │ INTEGER     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_title_short       │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_title             │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_location          │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_via               │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_schedule_type     │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_work_from_home    │ BOOLEAN     │ YES     │ NULL    │ NULL    │ NULL    │
│ search_location       │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_posted_date       │ TIMESTAMP   │ YES     │ NULL    │ NULL    │ NULL    │
│ job_no_degree_mention │ BOOLEAN     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_health_insurance  │ BOOLEAN     │ YES     │ NULL    │ NULL    │ NULL    │
│ job_country           │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ salary_rate           │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ salary_year_avg       │ DOUBLE      │ YES     │ NULL    │ NULL    │ NULL    │
│ salary_hour_avg       │ DOUBLE      │ YES     │ NULL    │ NULL    │ NULL    │
├───────────────────────┴─────────────┴─────────┴─────────┴─────────┴─────────┤
│ 16 rows                                                           6 columns │
└─────────────────────────────────────────────────────────────────────────────┘
*/


DESCRIBE
SELECT
    job_title_short,
    salary_year_avg
FROM job_postings_fact;

/*
┌─────────────────┬─────────────┬─────────┬─────────┬─────────┬─────────┐
│   column_name   │ column_type │  null   │   key   │ default │  extra  │
│     varchar     │   varchar   │ varchar │ varchar │ varchar │ varchar │
├─────────────────┼─────────────┼─────────┼─────────┼─────────┼─────────┤
│ job_title_short │ VARCHAR     │ YES     │ NULL    │ NULL    │ NULL    │
│ salary_year_avg │ DOUBLE      │ YES     │ NULL    │ NULL    │ NULL    │
└─────────────────┴─────────────┴─────────┴─────────┴─────────┴─────────┘
*/



-- Casting

SELECT CAST(123 AS VARCHAR);


SELECT
    job_id,                 -- "mORE" unique identifier
    job_work_from_home,     -- from boolean to numeric value
    job_posted_date,        -- from timestamp to data only
    salary_year_avg         -- from double to no decimal places
FROM
    job_postings_fact
LIMIT 10;

/*
┌────────┬────────────────────┬─────────────────────┬─────────────────┐
│ job_id │ job_work_from_home │   job_posted_date   │ salary_year_avg │
│ int32  │      boolean       │      timestamp      │     double      │
├────────┼────────────────────┼─────────────────────┼─────────────────┤
│   4593 │ false              │ 2023-01-01 00:00:04 │            NULL │
│   4594 │ false              │ 2023-01-01 00:00:22 │            NULL │
│   4595 │ false              │ 2023-01-01 00:00:24 │            NULL │
│   4596 │ false              │ 2023-01-01 00:00:27 │            NULL │
│   4597 │ false              │ 2023-01-01 00:00:38 │            NULL │
│   4598 │ false              │ 2023-01-01 00:00:38 │            NULL │
│   4599 │ false              │ 2023-01-01 00:00:43 │            NULL │
│   4600 │ false              │ 2023-01-01 00:00:51 │            NULL │
│   4601 │ false              │ 2023-01-01 00:00:57 │            NULL │
│   4602 │ false              │ 2023-01-01 00:00:57 │            NULL │
├────────┴────────────────────┴─────────────────────┴─────────────────┤
│ 10 rows                                                   4 columns │
└─────────────────────────────────────────────────────────────────────┘
*/



SELECT
    CAST(job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR) AS id,   
    CAST(job_work_from_home AS INT) AS job_work_from_home,     
    CAST(job_posted_date AS DATE) AS job_posted_date,       
    CAST(salary_year_avg AS DECIMAL(10, 0)) AS salary_year_avg 
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


/*
┌───────────┬────────────────────┬─────────────────┬─────────────────┐
│    id     │ job_work_from_home │ job_posted_date │ salary_year_avg │
│  varchar  │       int32        │      date       │  decimal(10,0)  │
├───────────┼────────────────────┼─────────────────┼─────────────────┤
│ 4651-4651 │                  0 │ 2023-01-01      │          110000 │
│ 4699-4699 │                  0 │ 2023-01-01      │           65000 │
│ 4804-4804 │                  1 │ 2023-01-01      │           90000 │
│ 4810-4810 │                  0 │ 2023-01-01      │           55000 │
│ 4833-4833 │                  0 │ 2023-01-01      │          120531 │
│ 4846-4846 │                  0 │ 2023-01-01      │          300000 │
│ 5089-5089 │                  0 │ 2023-01-01      │           51000 │
│ 5123-5123 │                  0 │ 2023-01-01      │          133500 │
│ 5321-5321 │                  0 │ 2023-01-01      │           77500 │
│ 5325-5321 │                  0 │ 2023-01-01      │          125000 │
├───────────┴────────────────────┴─────────────────┴─────────────────┤
│ 10 rows                                                  4 columns │
└────────────────────────────────────────────────────────────────────┘
*/