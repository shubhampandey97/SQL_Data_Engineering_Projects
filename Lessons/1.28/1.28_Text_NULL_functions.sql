-- TEXT

-- LENGTH & COUNT
SELECT LENGTH('SQL');
SELECT CHAR_LENGTH('SQL');

-- Case Conversion
SELECT LOWER('SQL');
SELECT UPPER('sql');

-- Substring/Extraction
SELECT LEFT('SQL', 2);
SELECT RIGHT('SQL', 2);
SELECT SUBSTRING('SQL', 2, 1);

-- Concatenation
SELECT CONCAT('SQL', '-', 'Functions');
SELECT 'SQL' || '-' || 'Functions';

-- Trimming
SELECT TRIM(' SQL ');
SELECT LTRIM(' SQL');
SELECT RTRIM('SQL ');

-- Replacement
SELECT REPLACE('SQL', 'Q', '_');
SELECT REGEXP_REPLACE('data.xyz@gmail.com', '^.*(@)', '\1');




-- Example
WITH title_lower AS(
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)

SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%' 
        AND job_title_clean LIKE '%analyst%'  THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%' 
        AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        WHEN job_title_clean LIKE '%data%' 
        AND job_title_clean LIKE '%scientist%'THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 20;
/*
┌────────────────────────────────────────────────────────────────────┬────────────────────┐
│                             job_title                              │ job_title_category │
│                              varchar                               │      varchar       │
├────────────────────────────────────────────────────────────────────┼────────────────────┤
│ Data Scientist Duurzaamheid                                        │ Data Scientist     │
│ Early Career Talent: 2023 Data Science Associate                   │ Other              │
│ Data Scientist, Operations AI at Adyen                             │ Data Scientist     │
│ Senior Machine Learning Engineer                                   │ Other              │
│ Senior DevOps Engineer - Data Infrastructure                       │ Data Engineer      │
│ Data Engineer - MetaData                                           │ Data Engineer      │
│ Data Analyst                                                       │ Data Analyst       │
│ Software Engineer                                                  │ Other              │
│ Data Scientist                                                     │ Data Scientist     │
│ Big Data Engineer (Various Levels) - Only W2 & One Man Corp for... │ Data Engineer      │
│ Data Modeler                                                       │ Other              │
│ Data Engineer - Business Intelligence                              │ Data Engineer      │
│ Principal Data Engineer                                            │ Data Engineer      │
│ Data scientist (H/F)                                               │ Data Scientist     │
│ Bioinformatics Data Scientist                                      │ Data Scientist     │
│ Experienced Data Engineer in Super AI                              │ Data Engineer      │
│ senior data scientist                                              │ Data Scientist     │
│ Voice and Data Communications Analyst with Security Clearance      │ Data Analyst       │
│ Project Information & Analytics Engineer                           │ Other              │
│ Data Scientist Dataïku                                             │ Data Scientist     │
├────────────────────────────────────────────────────────────────────┴────────────────────┤
│ 20 rows                                                                       2 columns │
└─────────────────────────────────────────────────────────────────────────────────────────┘
*/



-- NULL

-- NULLIF
SELECT NULLIF(10, 10);
/*
┌──────────────────┐
│ "nullif"(10, 10) │
│      int32       │
├──────────────────┤
│       NULL       │
└──────────────────┘
*/


SELECT
    MEDIAN(NULLIF(salary_year_avg, 0)),
    MEDIAN(NULLIF(salary_hour_avg, 0))
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;


-- SELECT
--     salary_year_avg,
--     salary_hour_avg
-- FROM
--     job_postings_fact
-- WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
-- ORDER BY salary_hour_avg
-- LIMIT 10;


-- SELECT
--     salary_year_avg,
--     salary_hour_avg
-- FROM
--     job_postings_fact
-- WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
-- ORDER BY salary_year_avg
-- LIMIT 10;



-- COALESCE

SELECT COALESCE(0, 1, 2);
/*
┌───────────────────┐
│ COALESCE(0, 1, 2) │
│       int32       │
├───────────────────┤
│         0         │
└───────────────────┘
*/

SELECT COALESCE(NULL, 1, 2);
/*
┌──────────────────────┐
│ COALESCE(NULL, 1, 2) │
│        int32         │
├──────────────────────┤
│          1           │
└──────────────────────┘
*/

SELECT COALESCE(NULL, NULL, 2);
/*
┌─────────────────────────┐
│ COALESCE(NULL, NULL, 2) │
│          int32          │
├─────────────────────────┤
│            2            │
└─────────────────────────┘
*/




SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080)
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;






SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 75_000 THEN 'Low'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 150_000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;
/*
┌───────────────────────────┬─────────────────┬─────────────────┬─────────────────────┬───────────────┐
│      job_title_short      │ salary_year_avg │ salary_hour_avg │ standardized_salary │ salary_bucket │
│          varchar          │     double      │     double      │       double        │    varchar    │
├───────────────────────────┼─────────────────┼─────────────────┼─────────────────────┼───────────────┤
│ Data Scientist            │        960000.0 │            NULL │            960000.0 │ High          │
│ Data Scientist            │        920000.0 │            NULL │            920000.0 │ High          │
│ Senior Data Scientist     │        890000.0 │            NULL │            890000.0 │ High          │
│ Machine Learning Engineer │        875000.0 │            NULL │            875000.0 │ High          │
│ Data Scientist            │        870000.0 │            NULL │            870000.0 │ High          │
│ Data Scientist            │        850000.0 │            NULL │            850000.0 │ High          │
│ Data Analyst              │            NULL │           391.0 │            813280.0 │ High          │
│ Machine Learning Engineer │        800000.0 │            NULL │            800000.0 │ High          │
│ Senior Data Engineer      │        800000.0 │            NULL │            800000.0 │ High          │
│ Data Scientist            │        680000.0 │            NULL │            680000.0 │ High          │
│ Data Analyst              │        650000.0 │            NULL │            650000.0 │ High          │
│ Data Engineer             │        640000.0 │            NULL │            640000.0 │ High          │
│ Data Scientist            │        640000.0 │            NULL │            640000.0 │ High          │
│ Data Scientist            │        585000.0 │            NULL │            585000.0 │ High          │
│ Data Scientist            │        550000.0 │            NULL │            550000.0 │ High          │
│ Data Engineer             │        525000.0 │            NULL │            525000.0 │ High          │
│ Data Scientist            │        525000.0 │            NULL │            525000.0 │ High          │
│ Data Scientist            │            NULL │           250.0 │            520000.0 │ High          │
│ Data Analyst              │            NULL │           242.5 │            504400.0 │ High          │
│ Data Scientist            │            NULL │           237.5 │            494000.0 │ High          │
│       ·                   │              ·  │              ·  │                  ·  │  ·            │
│       ·                   │              ·  │              ·  │                  ·  │  ·            │
│       ·                   │              ·  │              ·  │                  ·  │  ·            │
│ Senior Data Scientist     │            NULL │            NULL │                NULL │ Missing       │
│ Data Analyst              │            NULL │            NULL │                NULL │ Missing       │
│ Software Engineer         │            NULL │            NULL │                NULL │ Missing       │
│ Business Analyst          │            NULL │            NULL │                NULL │ Missing       │
│ Data Analyst              │            NULL │            NULL │                NULL │ Missing       │
│ Data Engineer             │            NULL │            NULL │                NULL │ Missing       │
│ Senior Data Engineer      │            NULL │            NULL │                NULL │ Missing       │
│ Software Engineer         │            NULL │            NULL │                NULL │ Missing       │
│ Data Engineer             │            NULL │            NULL │                NULL │ Missing       │
│ Data Engineer             │            NULL │            NULL │                NULL │ Missing       │
│ Machine Learning Engineer │            NULL │            NULL │                NULL │ Missing       │
│ Data Engineer             │            NULL │            NULL │                NULL │ Missing       │
│ Data Engineer             │            NULL │            NULL │                NULL │ Missing       │
│ Data Engineer             │            NULL │            NULL │                NULL │ Missing       │
│ Senior Data Scientist     │            NULL │            NULL │                NULL │ Missing       │
│ Data Analyst              │            NULL │            NULL │                NULL │ Missing       │
│ Data Analyst              │            NULL │            NULL │                NULL │ Missing       │
│ Data Engineer             │            NULL │            NULL │                NULL │ Missing       │
│ Data Analyst              │            NULL │            NULL │                NULL │ Missing       │
│ Data Engineer             │            NULL │            NULL │                NULL │ Missing       │
├───────────────────────────┴─────────────────┴─────────────────┴─────────────────────┴───────────────┤
│ 1615930 rows (1.62 million rows, 40 shown)                                                5 columns │
└─────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/