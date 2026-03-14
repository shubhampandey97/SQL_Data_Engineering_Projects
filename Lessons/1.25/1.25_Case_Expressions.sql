-- Bucket Salaries
-- < 25 = 'Low'
-- 25-50 = 'Medium'
-- > 50 = 'High'

SELECT
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg < 25 THEN 'Low'
        WHEN salary_hour_avg < 50 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;
/*
┌─────────────────┬─────────────────┬─────────────────┐
│ job_title_short │ salary_hour_avg │ salary_category │
│     varchar     │     double      │     varchar     │
├─────────────────┼─────────────────┼─────────────────┤
│ Data Analyst    │            20.0 │ Low             │
│ Data Scientist  │            20.0 │ Low             │
│ Data Analyst    │            15.0 │ Low             │
│ Data Analyst    │           35.75 │ Medium          │
│ Data Analyst    │            36.0 │ Medium          │
│ Data Analyst    │            55.0 │ High            │
│ Data Engineer   │            64.5 │ High            │
│ Data Scientist  │            20.0 │ Low             │
│ Data Scientist  │            20.0 │ Low             │
│ Data Engineer   │            25.5 │ Medium          │
├─────────────────┴─────────────────┴─────────────────┤
│ 10 rows                                   3 columns │
└─────────────────────────────────────────────────────┘
*/




-- Handling Missing Data (Nulls)
-- Filter NULL salary values

SELECT
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg IS NULL THEN 'Missing'
        WHEN salary_hour_avg < 25 THEN 'Low'
        WHEN salary_hour_avg < 50 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM job_postings_fact
LIMIT 10;
/*
┌─────────────────────┬─────────────────┬─────────────────┐
│   job_title_short   │ salary_hour_avg │ salary_category │
│       varchar       │     double      │     varchar     │
├─────────────────────┼─────────────────┼─────────────────┤
│ Data Analyst        │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Senior Data Analyst │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Data Analyst        │            NULL │ Missing         │
│ Senior Data Analyst │            NULL │ Missing         │
│ Business Analyst    │            NULL │ Missing         │
├─────────────────────┴─────────────────┴─────────────────┤
│ 10 rows                                       3 columns │
└─────────────────────────────────────────────────────────┘
*/



-- Categorizing Categorical Values
-- Classify the 'job_title' column values as:
    -- 'Data Analyst'
    -- 'Data Engineer'
    -- 'Data Scientist'

SELECT
    job_title,
    CASE
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Engineer%' THEN 'Data Engineer'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category,
    job_title_short
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 20;


SELECT
    job_title,
    CASE
        WHEN job_title ILIKE '%Data%' AND job_title ILIKE '%Analyst%' THEN 'Data Analyst'
        WHEN job_title ILIKE '%Data%' AND job_title ILIKE '%Engineer%' THEN 'Data Engineer'
        WHEN job_title ILIKE '%Data%' AND job_title ILIKE '%Scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category,
    job_title_short
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 20;
/*
┌─────────────────────────────────────────────────────────────┬────────────────────┬──────────────────────┐
│                          job_title                          │ job_title_category │   job_title_short    │
│                           varchar                           │      varchar       │       varchar        │
├─────────────────────────────────────────────────────────────┼────────────────────┼──────────────────────┤
│ Big Data Analyst                                            │ Data Analyst       │ Data Analyst         │
│ Data Analyst F/H                                            │ Data Analyst       │ Data Analyst         │
│ Data Science Intern                                         │ Other              │ Data Scientist       │
│ Cleared Data Scientist (All Levels) with Security Clearance │ Data Scientist     │ Data Scientist       │
│ Business Analyst - Data in IL                               │ Data Analyst       │ Business Analyst     │
│ Databricks Engineer                                         │ Data Engineer      │ Data Engineer        │
│ Internal Quality Engineer                                   │ Other              │ Software Engineer    │
│ MI Data Analyst                                             │ Data Analyst       │ Data Analyst         │
│ Market Research Data Analyst                                │ Data Analyst       │ Data Analyst         │
│ Senior Data Engineer (Remote- Eligible)                     │ Data Engineer      │ Senior Data Engineer │
│ Health Information Data Scientist Intern                    │ Data Scientist     │ Data Scientist       │
│ Public Healthcare Data Science Consultant                   │ Other              │ Data Scientist       │
│ Reporting Analyst                                           │ Other              │ Business Analyst     │
│ Data Engineer H/F                                           │ Data Engineer      │ Data Engineer        │
│ Data - Data Scientist                                       │ Data Scientist     │ Data Scientist       │
│ Senior Data Engineer (San Francisco, CA or Remote)          │ Data Engineer      │ Senior Data Engineer │
│ Azure Data Platform Engineer                                │ Data Engineer      │ Data Engineer        │
│ Data Scientist                                              │ Data Scientist     │ Data Scientist       │
│ Data Scientist                                              │ Data Scientist     │ Data Scientist       │
│ Online Data Analyst - Dutch (NL)                            │ Data Analyst       │ Data Analyst         │
├─────────────────────────────────────────────────────────────┴────────────────────┴──────────────────────┤
│ 20 rows                                                                                       3 columns │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/



-- Conditional Aggregation
-- Calculate Median Salaries for Different Buckets
    -- < $100K
    -- >= $100K

SELECT
    job_title_short,
    COUNT(*) AS total_postings,
    MEDIAN(
        CASE
            WHEN salary_year_avg < 100_000 THEN salary_year_avg
        END 
    ) AS median_low_salary,
    MEDIAN(
        CASE
            WHEN salary_year_avg >= 100_000 THEN salary_year_avg
        END 
    ) AS median_high_salary
FROM  job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short;
/*
┌───────────────────────────┬────────────────┬───────────────────┬────────────────────┐
│      job_title_short      │ total_postings │ median_low_salary │ median_high_salary │
│          varchar          │     int64      │      double       │       double       │
├───────────────────────────┼────────────────┼───────────────────┼────────────────────┤
│ Cloud Engineer            │            219 │           79200.0 │           135500.0 │
│ Senior Data Analyst       │           2603 │           87500.0 │           120000.0 │
│ Machine Learning Engineer │           1334 │           78261.5 │           166000.0 │
│ Senior Data Engineer      │           3283 │           87179.5 │           150000.0 │
│ Senior Data Scientist     │           3271 │           89100.0 │           157500.0 │
│ Data Analyst              │          13600 │           75000.0 │          114978.25 │
│ Software Engineer         │           1578 │           79200.0 │           174400.0 │
│ Data Scientist            │          12625 │           80000.0 │           140000.0 │
│ Business Analyst          │           1962 │           80000.0 │           125000.0 │
│ Data Engineer             │          10551 │           87500.0 │           140000.0 │
├───────────────────────────┴────────────────┴───────────────────┴────────────────────┤
│ 10 rows                                                                   4 columns │
└─────────────────────────────────────────────────────────────────────────────────────┘
*/



-- Final Example: Conditional Calculations
-- Compute a standardized_salary using yearly salary and adjusted hourly salary (e.g. 2080 hours/year)
-- Categorize salaries into tiers of:
    -- < 75K 'Low'
    -- 75K -150K 'Median'
    -- >= 150K 'High'

WITH salaries AS (
    SELECT
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2080
        END AS standardized_salary
    FROM job_postings_fact
)

SELECT
    *,
    CASE
        WHEN standardized_salary IS NULL THEN 'Missing'
        WHEN standardized_salary < 75_000 THEN 'Low'
        WHEN standardized_salary < 150_000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM salaries
ORDER BY standardized_salary DESC
LIMIT 10;
/*
┌───────────────────────────┬─────────────────┬─────────────────┬─────────────────────┬───────────────┐
│      job_title_short      │ salary_hour_avg │ salary_year_avg │ standardized_salary │ salary_bucket │
│          varchar          │     double      │     double      │       double        │    varchar    │
├───────────────────────────┼─────────────────┼─────────────────┼─────────────────────┼───────────────┤
│ Data Scientist            │            NULL │        960000.0 │            960000.0 │ High          │
│ Data Scientist            │            NULL │        920000.0 │            920000.0 │ High          │
│ Senior Data Scientist     │            NULL │        890000.0 │            890000.0 │ High          │
│ Machine Learning Engineer │            NULL │        875000.0 │            875000.0 │ High          │
│ Data Scientist            │            NULL │        870000.0 │            870000.0 │ High          │
│ Data Scientist            │            NULL │        850000.0 │            850000.0 │ High          │
│ Data Analyst              │           391.0 │            NULL │            813280.0 │ High          │
│ Machine Learning Engineer │            NULL │        800000.0 │            800000.0 │ High          │
│ Senior Data Engineer      │            NULL │        800000.0 │            800000.0 │ High          │
│ Data Scientist            │            NULL │        680000.0 │            680000.0 │ High          │
├───────────────────────────┴─────────────────┴─────────────────┴─────────────────────┴───────────────┤
│ 10 rows                                                                                   5 columns │
└─────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
