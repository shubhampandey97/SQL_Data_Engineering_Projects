-- COUNT rows - Aggregation Only
SELECT COUNT(*)
FROM job_postings_fact;


-- Count Rows - Window Function
SELECT
    job_id,
    COUNT(*) OVER ()
FROM job_postings_fact;



-- PARTITION BY - Find hourly salary
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG (salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ) AS as_hourly_by_title
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY RANDOM()
LIMIT 10;
/*
┌─────────┬───────────────────────┬────────────────────┬────────────────────┐
│ job_id  │    job_title_short    │  salary_hour_avg   │ as_hourly_by_title │
│  int32  │        varchar        │       double       │       double       │
├─────────┼───────────────────────┼────────────────────┼────────────────────┤
│  244845 │ Data Analyst          │  75.00499725341797 │  37.28122352950212 │
│ 1607383 │ Data Engineer         │               67.5 │  56.68925185621045 │
│  309631 │ Data Analyst          │ 18.189998626708984 │  37.28122352950212 │
│ 1191970 │ Data Analyst          │               52.5 │  37.28122352950212 │
│ 1213341 │ Data Scientist        │ 41.505001068115234 │  49.80564666039103 │
│ 1225590 │ Data Analyst          │              28.25 │  37.28122352950212 │
│  598649 │ Senior Data Scientist │  37.85499954223633 │  56.96220155410907 │
│ 1356130 │ Data Analyst          │               22.5 │  37.28122352950212 │
│  616953 │ Data Engineer         │               52.5 │  56.68925185621045 │
│  613956 │ Data Analyst          │ 27.979999542236328 │  37.28122352950212 │
├─────────┴───────────────────────┴────────────────────┴────────────────────┤
│ 10 rows                                                         4 columns │
└───────────────────────────────────────────────────────────────────────────┘
*/


SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG (salary_hour_avg) OVER (
        PARTITION BY job_title_short, company_id
        )
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY RANDOM()
LIMIT 10;
/*
┌─────────┬───────────────────────────┬────────────┬────────────────────┬──────────────────────────────────────────────────────────────────────┐
│ job_id  │      job_title_short      │ company_id │  salary_hour_avg   │ avg(salary_hour_avg) OVER (PARTITION BY job_title_short, company_id) │
│  int32  │          varchar          │   int32    │       double       │                                double                                │
├─────────┼───────────────────────────┼────────────┼────────────────────┼──────────────────────────────────────────────────────────────────────┤
│  656452 │ Machine Learning Engineer │       8637 │               10.0 │                                                   49.166666666666664 │
│ 1114747 │ Data Analyst              │      37324 │               50.0 │                                                    49.79586542569674 │
│ 1607488 │ Senior Data Scientist     │    1607488 │               89.5 │                                                                 89.5 │
│  292031 │ Data Analyst              │      36364 │               35.0 │                                                                 42.0 │
│   12694 │ Data Scientist            │      12685 │               24.0 │                                                                 24.0 │
│  292017 │ Data Analyst              │      28548 │               62.5 │                                                    49.44318181818182 │
│ 1166322 │ Data Analyst              │       5419 │  23.94499969482422 │                                                   23.769242113286797 │
│  847833 │ Data Scientist            │     132993 │ 31.270000457763672 │                                                    38.66388871934679 │
│ 1209418 │ Data Analyst              │     759230 │   25.2400016784668 │                                                    20.60941281038172 │
│ 1532133 │ Data Engineer             │      12462 │               61.5 │                                                    74.92454528808594 │
├─────────┴───────────────────────────┴────────────┴────────────────────┴──────────────────────────────────────────────────────────────────────┤
│ 10 rows                                                                                                                            5 columns │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


-- ORDER BY - Ranking hourly salary
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        ORDER BY salary_hour_avg DESC
        ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY salary_hour_avg DESC
LIMIT 10;
/*
┌─────────┬───────────────────────────┬─────────────────┬────────────────────┐
│ job_id  │      job_title_short      │ salary_hour_avg │ rank_hourly_salary │
│  int32  │          varchar          │     double      │       int64        │
├─────────┼───────────────────────────┼─────────────────┼────────────────────┤
│  256566 │ Data Analyst              │           391.0 │                  1 │
│ 1004296 │ Data Scientist            │           250.0 │                  2 │
│  110897 │ Data Analyst              │           242.5 │                  3 │
│  646328 │ Data Scientist            │           237.5 │                  4 │
│  210821 │ Data Scientist            │           225.0 │                  5 │
│ 1203880 │ Data Engineer             │           221.0 │                  6 │
│ 1056728 │ Machine Learning Engineer │           220.0 │                  7 │
│  193693 │ Data Analyst              │           210.0 │                  8 │
│  452720 │ Data Analyst              │           200.0 │                  9 │
│  839232 │ Data Scientist            │           200.0 │                  9 │
├─────────┴───────────────────────────┴─────────────────┴────────────────────┤
│ 10 rows                                                          4 columns │
└────────────────────────────────────────────────────────────────────────────┘
*/


-- PARTITION BY & ORDER BY - Running Average Hourly Salary
SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG (salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ORDER BY job_posted_date
        ) AS running_avg_hourly_by_title
FROM job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL AND
    job_title_short = 'Data Engineer'
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 10;


-- Partition by & ORDER BY - Ranking by job_title_short
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        Partition BY job_title_short
        ORDER BY salary_hour_avg DESC
        ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC,
    job_title_short
LIMIT 10;
/*
┌─────────┬───────────────────────────┬─────────────────┬────────────────────┐
│ job_id  │      job_title_short      │ salary_hour_avg │ rank_hourly_salary │
│  int32  │          varchar          │     double      │       int64        │
├─────────┼───────────────────────────┼─────────────────┼────────────────────┤
│  256566 │ Data Analyst              │           391.0 │                  1 │
│ 1004296 │ Data Scientist            │           250.0 │                  1 │
│  110897 │ Data Analyst              │           242.5 │                  2 │
│  646328 │ Data Scientist            │           237.5 │                  2 │
│  210821 │ Data Scientist            │           225.0 │                  3 │
│ 1203880 │ Data Engineer             │           221.0 │                  1 │
│ 1056728 │ Machine Learning Engineer │           220.0 │                  1 │
│  193693 │ Data Analyst              │           210.0 │                  3 │
│  452720 │ Data Analyst              │           200.0 │                  4 │
│  835548 │ Data Scientist            │           200.0 │                  4 │
├─────────┴───────────────────────────┴─────────────────┴────────────────────┤
│ 10 rows                                                          4 columns │
└────────────────────────────────────────────────────────────────────────────┘
*/


SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    -- MIN (salary_hour_avg) OVER (
    -- MAX (salary_hour_avg) OVER (
    SUM (salary_hour_avg) OVER (
        PARTITION BY job_title_short
        -- ORDER BY job_posted_date
        ) AS running_avg_hourly_by_title
FROM job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL AND
    job_title_short = 'Data Engineer'
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 10;


SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    SUM (salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ORDER BY job_posted_date
        ) AS running_avg_hourly_by_title
FROM job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL AND
    job_title_short = 'Data Engineer'
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 10;


-- Ranking Function -RANK() vs DEASE_RANK
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        ORDER BY salary_hour_avg DESC
        ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY salary_hour_avg DESC
LIMIT 140;
/*
┌─────────┬───────────────────────────┬─────────────────┬────────────────────┐
│ job_id  │      job_title_short      │ salary_hour_avg │ rank_hourly_salary │
│  int32  │          varchar          │     double      │       int64        │
├─────────┼───────────────────────────┼─────────────────┼────────────────────┤
│  256566 │ Data Analyst              │           391.0 │                  1 │
│ 1004296 │ Data Scientist            │           250.0 │                  2 │
│  110897 │ Data Analyst              │           242.5 │                  3 │
│  646328 │ Data Scientist            │           237.5 │                  4 │
│  210821 │ Data Scientist            │           225.0 │                  5 │
│ 1203880 │ Data Engineer             │           221.0 │                  6 │
│ 1056728 │ Machine Learning Engineer │           220.0 │                  7 │
│  193693 │ Data Analyst              │           210.0 │                  8 │
│  852238 │ Data Scientist            │           200.0 │                  9 │
│  839416 │ Data Scientist            │           200.0 │                  9 │
│  847695 │ Data Scientist            │           200.0 │                  9 │
│  843071 │ Senior Data Scientist     │           200.0 │                  9 │
│  839410 │ Data Scientist            │           200.0 │                  9 │
│  839247 │ Data Scientist            │           200.0 │                  9 │
│  835746 │ Data Scientist            │           200.0 │                  9 │
│  835678 │ Senior Data Scientist     │           200.0 │                  9 │
│  839214 │ Senior Data Scientist     │           200.0 │                  9 │
│  835635 │ Data Scientist            │           200.0 │                  9 │
│  835545 │ Senior Data Scientist     │           200.0 │                  9 │
│  847826 │ Data Scientist            │           200.0 │                  9 │
│     ·   │       ·                   │             ·   │                  · │
│     ·   │       ·                   │             ·   │                  · │
│     ·   │       ·                   │             ·   │                  · │
│  993851 │ Data Scientist            │           200.0 │                  9 │
│  891879 │ Senior Data Scientist     │           200.0 │                  9 │
│  835489 │ Data Scientist            │           200.0 │                  9 │
│  874361 │ Data Scientist            │           200.0 │                  9 │
│ 1133917 │ Data Scientist            │           200.0 │                  9 │
│  856692 │ Data Scientist            │           200.0 │                  9 │
│ 1139796 │ Data Scientist            │           200.0 │                  9 │
│ 1141823 │ Data Scientist            │           200.0 │                  9 │
│ 1143799 │ Data Scientist            │           200.0 │                  9 │
│  873992 │ Senior Data Scientist     │           200.0 │                  9 │
│ 1155051 │ Data Scientist            │           200.0 │                  9 │
│ 1156892 │ Data Scientist            │           200.0 │                  9 │
│ 1131796 │ Data Scientist            │           200.0 │                  9 │
│  852183 │ Senior Data Scientist     │           200.0 │                  9 │
│ 1167300 │ Data Scientist            │           200.0 │                  9 │
│ 1149517 │ Data Scientist            │           200.0 │                  9 │
│ 1172117 │ Data Scientist            │           200.0 │                  9 │
│  873933 │ Senior Data Scientist     │           200.0 │                  9 │
│ 1240360 │ Data Engineer             │           195.0 │                139 │
│  307062 │ Data Scientist            │           187.5 │                140 │
├─────────┴───────────────────────────┴─────────────────┴────────────────────┤
│ 140 rows (40 shown)                                              4 columns │
└────────────────────────────────────────────────────────────────────────────┘
*/

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    DENSE_RANK() OVER (
        ORDER BY salary_hour_avg DESC
        ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY salary_hour_avg DESC
LIMIT 140;
/*
┌─────────┬───────────────────────────┬─────────────────┬────────────────────┐
│ job_id  │      job_title_short      │ salary_hour_avg │ rank_hourly_salary │
│  int32  │          varchar          │     double      │       int64        │
├─────────┼───────────────────────────┼─────────────────┼────────────────────┤
│  256566 │ Data Analyst              │           391.0 │                  1 │
│ 1004296 │ Data Scientist            │           250.0 │                  2 │
│  110897 │ Data Analyst              │           242.5 │                  3 │
│  646328 │ Data Scientist            │           237.5 │                  4 │
│  210821 │ Data Scientist            │           225.0 │                  5 │
│ 1203880 │ Data Engineer             │           221.0 │                  6 │
│ 1056728 │ Machine Learning Engineer │           220.0 │                  7 │
│  193693 │ Data Analyst              │           210.0 │                  8 │
│  865630 │ Senior Data Scientist     │           200.0 │                  9 │
│  865851 │ Senior Data Scientist     │           200.0 │                  9 │
│  862008 │ Senior Data Scientist     │           200.0 │                  9 │
│  835671 │ Data Scientist            │           200.0 │                  9 │
│  865635 │ Data Scientist            │           200.0 │                  9 │
│  861339 │ Data Scientist            │           200.0 │                  9 │
│  835497 │ Senior Data Scientist     │           200.0 │                  9 │
│ 1172117 │ Data Scientist            │           200.0 │                  9 │
│  839214 │ Senior Data Scientist     │           200.0 │                  9 │
│  887558 │ Senior Data Scientist     │           200.0 │                  9 │
│  882364 │ Senior Data Scientist     │           200.0 │                  9 │
│  852185 │ Data Scientist            │           200.0 │                  9 │
│     ·   │       ·                   │             ·   │                  · │
│     ·   │       ·                   │             ·   │                  · │
│     ·   │       ·                   │             ·   │                  · │
│  848127 │ Senior Data Scientist     │           200.0 │                  9 │
│  873933 │ Senior Data Scientist     │           200.0 │                  9 │
│  865694 │ Data Scientist            │           200.0 │                  9 │
│ 1141823 │ Data Scientist            │           200.0 │                  9 │
│  856692 │ Data Scientist            │           200.0 │                  9 │
│ 1149517 │ Data Scientist            │           200.0 │                  9 │
│  835489 │ Data Scientist            │           200.0 │                  9 │
│  848264 │ Data Scientist            │           200.0 │                  9 │
│  835678 │ Senior Data Scientist     │           200.0 │                  9 │
│  835652 │ Senior Data Scientist     │           200.0 │                  9 │
│  865553 │ Senior Data Scientist     │           200.0 │                  9 │
│  865567 │ Data Scientist            │           200.0 │                  9 │
│ 1151299 │ Data Scientist            │           200.0 │                  9 │
│  865847 │ Data Scientist            │           200.0 │                  9 │
│  852238 │ Data Scientist            │           200.0 │                  9 │
│  861820 │ Senior Data Scientist     │           200.0 │                  9 │
│  839506 │ Data Scientist            │           200.0 │                  9 │
│  847695 │ Data Scientist            │           200.0 │                  9 │
│ 1240360 │ Data Engineer             │           195.0 │                 10 │
│  307062 │ Data Scientist            │           187.5 │                 11 │
├─────────┴───────────────────────────┴─────────────────┴────────────────────┤
│ 140 rows (40 shown)                                              4 columns │
└────────────────────────────────────────────────────────────────────────────┘
*/


-- ROW NUMBER() - Providing a new job_id
SELECT 
    *,
    ROW_NUMBER() OVER (
        ORDER BY job_posted_date
    )
FROM job_postings_fact
ORDER BY job_posted_date
LIMIT 20;
/*
┌────────┬────────────┬───┬─────────────────┬─────────────────┬──────────────────────┐
│ job_id │ company_id │ . │ salary_year_avg │ salary_hour_avg │ row_number() OVER .  │
│ int32  │   int32    │   │     double      │     double      │        int64         │
├────────┼────────────┼───┼─────────────────┼─────────────────┼──────────────────────┤
│   4593 │       4593 │ . │            NULL │            NULL │                    1 │
│   4594 │       4594 │ . │            NULL │            NULL │                    2 │
│   4595 │       4595 │ . │            NULL │            NULL │                    3 │
│   4596 │       4596 │ . │            NULL │            NULL │                    4 │
│   4598 │       4598 │ . │            NULL │            NULL │                    6 │
│   4597 │       4597 │ . │            NULL │            NULL │                    5 │
│   4599 │       4599 │ . │            NULL │            NULL │                    7 │
│   4600 │       4600 │ . │            NULL │            NULL │                    8 │
│   4602 │       4602 │ . │            NULL │            NULL │                   10 │
│   4601 │       4601 │ . │            NULL │            NULL │                    9 │
│   4603 │       4603 │ . │            NULL │            NULL │                   11 │
│   4604 │       4604 │ . │            NULL │            NULL │                   12 │
│   4605 │       4605 │ . │            NULL │            NULL │                   13 │
│   4606 │       4606 │ . │            NULL │            NULL │                   14 │
│   4607 │       4607 │ . │            NULL │            NULL │                   15 │
│   4608 │       4608 │ . │            NULL │            NULL │                   16 │
│   4609 │       4609 │ . │            NULL │            NULL │                   17 │
│   4611 │       4611 │ . │            NULL │            NULL │                   19 │
│   4612 │       4612 │ . │            NULL │            NULL │                   20 │
│   4610 │       4610 │ . │            NULL │            20.0 │                   18 │
├────────┴────────────┴───┴─────────────────┴─────────────────┴──────────────────────┤
│ 20 rows                                                       17 columns (5 shown) │
└────────────────────────────────────────────────────────────────────────────────────┘
*/


-- LAG() - Time Based Comparision of Company Yearly Salary
SELECT 
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_posting_salary,
    salary_year_avg - LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM job_postings_fact
WHERE   salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;
/*
┌─────────┬────────────┬───────────────────────────────────────────────────────────────────┬───────────────────────┬─────────────────────┬─────────────────┬─────────────────────────┬───────────────┐
│ job_id  │ company_id │                             job_title                             │    job_title_short    │   job_posted_date   │ salary_year_avg │ previous_posting_salary │ salary_change │   
│  int32  │   int32    │                              varchar                              │        varchar        │      timestamp      │     double      │         double          │    double     │   
├─────────┼────────────┼───────────────────────────────────────────────────────────────────┼───────────────────────┼─────────────────────┼─────────────────┼─────────────────────────┼───────────────┤
│  842003 │       4593 │ Data Scientist                                                    │ Data Scientist        │ 2024-01-30 14:28:11 │         75000.0 │                    NULL │          NULL │   
│  995381 │       4593 │ Lead Data Engineer                                                │ Data Engineer         │ 2024-05-02 16:08:57 │        150000.0 │                 75000.0 │       75000.0 │   
│  128388 │       4594 │ Data Scientist                                                    │ Data Scientist        │ 2023-02-14 06:02:22 │         90000.0 │                    NULL │          NULL │   
│  134272 │       4594 │ AI/ML Health Data Scientist - Senior Consultant                   │ Senior Data Scientist │ 2023-02-16 11:06:48 │        112450.0 │                 90000.0 │       22450.0 │
│  143916 │       4594 │ Data Scientist                                                    │ Data Scientist        │ 2023-02-21 07:23:56 │         90000.0 │                112450.0 │      -22450.0 │   
│  159423 │       4594 │ Data Scientist - Analyst                                          │ Data Scientist        │ 2023-02-28 10:52:05 │         90000.0 │                 90000.0 │           0.0 │   
│  164436 │       4594 │ Data Scientist - Senior Consultant                                │ Data Scientist        │ 2023-03-02 09:49:47 │         90000.0 │                 90000.0 │           0.0 │   
│  167525 │       4594 │ AI/ML Health Data Scientist - Senior Consultant                   │ Senior Data Scientist │ 2023-03-03 11:03:16 │        115000.0 │                 90000.0 │       25000.0 │   
│  179599 │       4594 │ Data Analyst - Business Intelligence                              │ Data Analyst          │ 2023-03-09 09:00:18 │        129050.0 │                115000.0 │       14050.0 │
│  235865 │       4594 │ Cleared Data Scientist                                            │ Data Scientist        │ 2023-04-06 09:57:40 │        115000.0 │                129050.0 │      -14050.0 │   
│  320213 │       4594 │ Data Scientist, Senior Consultant                                 │ Data Scientist        │ 2023-05-16 12:40:22 │         90000.0 │                115000.0 │      -25000.0 │   
│  324613 │       4594 │ AI/ML Health Data Scientist - Senior Consultant                   │ Senior Data Scientist │ 2023-05-24 09:04:38 │        112450.0 │                 90000.0 │       22450.0 │   
│  327941 │       4594 │ AI/ML Health Data Scientist - Senior Consultant                   │ Senior Data Scientist │ 2023-05-25 18:04:36 │        112450.0 │                112450.0 │           0.0 │   
│  361103 │       4594 │ AI/ML Health Data Science Managing Consultant                     │ Data Scientist        │ 2023-06-12 03:04:10 │        142550.0 │                112450.0 │       30100.0 │
│  363685 │       4594 │ Database and Data Analyst                                         │ Data Analyst          │ 2023-06-13 08:00:03 │        115000.0 │                142550.0 │      -27550.0 │   
│  372043 │       4594 │ Database and Data Analyst                                         │ Data Analyst          │ 2023-06-16 22:00:13 │        116250.0 │                115000.0 │        1250.0 │   
│  372044 │       4594 │ Database and Data Analyst                                         │ Data Analyst          │ 2023-06-16 22:00:21 │        116250.0 │                116250.0 │           0.0 │   
│  378568 │       4594 │ Cleared Data Scientist - Data Mining/Analytics/Data Visualization │ Data Scientist        │ 2023-06-20 15:02:44 │         84800.0 │                116250.0 │      -31450.0 │   
│  390355 │       4594 │ Cleared Data Scientist - Data Mining/Analytics/Data Visualization │ Data Scientist        │ 2023-06-26 08:02:57 │         84800.0 │                 84800.0 │           0.0 │
│  390367 │       4594 │ Financial Data Science, Senior Consultant                         │ Senior Data Scientist │ 2023-06-26 08:05:17 │        112450.0 │                 84800.0 │       27650.0 │   
│     ·   │         ·  │            ·                                                      │       ·               │          ·          │            ·    │                    ·    │          ·    │   
│     ·   │         ·  │            ·                                                      │       ·               │          ·          │            ·    │                    ·    │          ·    │   
│     ·   │         ·  │            ·                                                      │       ·               │          ·          │            ·    │                    ·    │          ·    │
│  781700 │       4594 │ Data Science Consultant                                           │ Data Scientist        │ 2023-12-25 09:01:40 │        100000.0 │                 72000.0 │       28000.0 │   
│  801450 │       4594 │ Big Data Analyst                                                  │ Data Analyst          │ 2024-01-06 08:00:50 │         80000.0 │                100000.0 │      -20000.0 │   
│  840111 │       4594 │ Data Scientist                                                    │ Data Scientist        │ 2024-01-29 15:38:00 │         75000.0 │                 80000.0 │       -5000.0 │   
│  865929 │       4594 │ Data Scientist                                                    │ Data Scientist        │ 2024-02-12 11:12:23 │         75000.0 │                 75000.0 │           0.0 │   
│  865934 │       4594 │ Data Science                                                      │ Data Scientist        │ 2024-02-12 11:12:45 │        100000.0 │                 75000.0 │       25000.0 │
│  879740 │       4594 │ Data Science Consultant                                           │ Data Scientist        │ 2024-02-19 16:12:09 │        100000.0 │                100000.0 │           0.0 │   
│  896270 │       4594 │ Senior Consultant (full time) - Fraud Data Analyst                │ Data Analyst          │ 2024-02-28 07:50:55 │        136500.0 │                100000.0 │       36500.0 │   
│  898520 │       4594 │ Senior Consultant (full time) - Fraud Data Analyst                │ Data Analyst          │ 2024-02-29 08:00:14 │        136500.0 │                136500.0 │           0.0 │   
│  899932 │       4594 │ Data Scientist                                                    │ Data Scientist        │ 2024-02-29 19:02:36 │        100000.0 │                136500.0 │      -36500.0 │   
│ 1211909 │       4594 │ Consultant Manager-Pharma Biotech Data Scientist                  │ Data Scientist        │ 2024-10-05 12:01:10 │        136500.0 │                100000.0 │       36500.0 │
│ 1212494 │       4594 │ Associate Director, Data Analytics                                │ Data Analyst          │ 2024-10-06 11:00:35 │        151782.0 │                136500.0 │       15282.0 │   
│ 1337452 │       4594 │ Business Intelligence Analyst                                     │ Business Analyst      │ 2025-01-29 21:00:16 │        130500.0 │                151782.0 │      -21282.0 │   
│ 1608236 │       4594 │ Lead Analyst, People Analytics                                    │ Data Scientist        │ 2025-06-18 17:00:11 │        150500.0 │                130500.0 │       20000.0 │   
│  142923 │       4598 │ Senior Analyst Planning, Forecasting & Reporting                  │ Business Analyst      │ 2023-02-20 17:00:10 │         85000.0 │                    NULL │          NULL │
│  586669 │       4598 │ Analytics Supervisor                                              │ Senior Data Analyst   │ 2023-09-22 16:02:56 │         78500.0 │                 85000.0 │       -6500.0 │   
│ 1097057 │       4598 │ Data Scientist                                                    │ Data Scientist        │ 2024-07-11 18:04:11 │        135000.0 │                 78500.0 │       56500.0 │   
│ 1610710 │       4598 │ Marketing Analyst                                                 │ Business Analyst      │ 2025-06-20 22:00:59 │        128000.0 │                135000.0 │       -7000.0 │   
│    9006 │       4599 │ Data Analyst, Reporting                                           │ Data Analyst          │ 2023-01-02 08:29:05 │        111202.0 │                    NULL │          NULL │   
│   76921 │       4599 │ Senior People Analytics Analyst (San Francisco, CA)               │ Data Scientist        │ 2023-01-25 07:01:04 │        185000.0 │                111202.0 │       73798.0 │   
│   79945 │       4599 │ Data Analyst, Developer Relations                                 │ Data Analyst          │ 2023-01-26 03:04:13 │        111175.0 │                185000.0 │      -73825.0 │   
├─────────┴────────────┴───────────────────────────────────────────────────────────────────┴───────────────────────┴─────────────────────┴─────────────────┴─────────────────────────┴───────────────┤
│ 60 rows (40 shown)                                                                                                                                                                       8 columns │   
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


SELECT 
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS next_posting_salary,
    salary_year_avg - LEAD(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM job_postings_fact
WHERE   salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;
/*
┌─────────┬────────────┬───────────────────────────────────────────────────────────────────┬───────────────────────┬─────────────────────┬─────────────────┬─────────────────────┬───────────────┐
│ job_id  │ company_id │                             job_title                             │    job_title_short    │   job_posted_date   │ salary_year_avg │ next_posting_salary │ salary_change │       
│  int32  │   int32    │                              varchar                              │        varchar        │      timestamp      │     double      │       double        │    double     │
├─────────┼────────────┼───────────────────────────────────────────────────────────────────┼───────────────────────┼─────────────────────┼─────────────────┼─────────────────────┼───────────────┤
│  842003 │       4593 │ Data Scientist                                                    │ Data Scientist        │ 2024-01-30 14:28:11 │         75000.0 │            150000.0 │      -75000.0 │
│  995381 │       4593 │ Lead Data Engineer                                                │ Data Engineer         │ 2024-05-02 16:08:57 │        150000.0 │                NULL │          NULL │       
│  128388 │       4594 │ Data Scientist                                                    │ Data Scientist        │ 2023-02-14 06:02:22 │         90000.0 │            112450.0 │      -22450.0 │       
│  134272 │       4594 │ AI/ML Health Data Scientist - Senior Consultant                   │ Senior Data Scientist │ 2023-02-16 11:06:48 │        112450.0 │             90000.0 │       22450.0 │
│  143916 │       4594 │ Data Scientist                                                    │ Data Scientist        │ 2023-02-21 07:23:56 │         90000.0 │             90000.0 │           0.0 │       
│  159423 │       4594 │ Data Scientist - Analyst                                          │ Data Scientist        │ 2023-02-28 10:52:05 │         90000.0 │             90000.0 │           0.0 │       
│  164436 │       4594 │ Data Scientist - Senior Consultant                                │ Data Scientist        │ 2023-03-02 09:49:47 │         90000.0 │            115000.0 │      -25000.0 │
│  167525 │       4594 │ AI/ML Health Data Scientist - Senior Consultant                   │ Senior Data Scientist │ 2023-03-03 11:03:16 │        115000.0 │            129050.0 │      -14050.0 │       
│  179599 │       4594 │ Data Analyst - Business Intelligence                              │ Data Analyst          │ 2023-03-09 09:00:18 │        129050.0 │            115000.0 │       14050.0 │       
│  235865 │       4594 │ Cleared Data Scientist                                            │ Data Scientist        │ 2023-04-06 09:57:40 │        115000.0 │             90000.0 │       25000.0 │
│  320213 │       4594 │ Data Scientist, Senior Consultant                                 │ Data Scientist        │ 2023-05-16 12:40:22 │         90000.0 │            112450.0 │      -22450.0 │       
│  324613 │       4594 │ AI/ML Health Data Scientist - Senior Consultant                   │ Senior Data Scientist │ 2023-05-24 09:04:38 │        112450.0 │            112450.0 │           0.0 │       
│  327941 │       4594 │ AI/ML Health Data Scientist - Senior Consultant                   │ Senior Data Scientist │ 2023-05-25 18:04:36 │        112450.0 │            142550.0 │      -30100.0 │       
│  361103 │       4594 │ AI/ML Health Data Science Managing Consultant                     │ Data Scientist        │ 2023-06-12 03:04:10 │        142550.0 │            115000.0 │       27550.0 │       
│  363685 │       4594 │ Database and Data Analyst                                         │ Data Analyst          │ 2023-06-13 08:00:03 │        115000.0 │            116250.0 │       -1250.0 │       
│  372043 │       4594 │ Database and Data Analyst                                         │ Data Analyst          │ 2023-06-16 22:00:13 │        116250.0 │            116250.0 │           0.0 │
│  372044 │       4594 │ Database and Data Analyst                                         │ Data Analyst          │ 2023-06-16 22:00:21 │        116250.0 │             84800.0 │       31450.0 │       
│  378568 │       4594 │ Cleared Data Scientist - Data Mining/Analytics/Data Visualization │ Data Scientist        │ 2023-06-20 15:02:44 │         84800.0 │             84800.0 │           0.0 │       
│  390355 │       4594 │ Cleared Data Scientist - Data Mining/Analytics/Data Visualization │ Data Scientist        │ 2023-06-26 08:02:57 │         84800.0 │            112450.0 │      -27650.0 │       
│  390367 │       4594 │ Financial Data Science, Senior Consultant                         │ Senior Data Scientist │ 2023-06-26 08:05:17 │        112450.0 │             90000.0 │       22450.0 │       
│     ·   │         ·  │            ·                                                      │       ·               │          ·          │            ·    │                ·    │          ·    │
│     ·   │         ·  │            ·                                                      │       ·               │          ·          │            ·    │                ·    │          ·    │       
│     ·   │         ·  │            ·                                                      │       ·               │          ·          │            ·    │                ·    │          ·    │       
│  781700 │       4594 │ Data Science Consultant                                           │ Data Scientist        │ 2023-12-25 09:01:40 │        100000.0 │             80000.0 │       20000.0 │       
│  801450 │       4594 │ Big Data Analyst                                                  │ Data Analyst          │ 2024-01-06 08:00:50 │         80000.0 │             75000.0 │        5000.0 │
│  840111 │       4594 │ Data Scientist                                                    │ Data Scientist        │ 2024-01-29 15:38:00 │         75000.0 │             75000.0 │           0.0 │       
│  865929 │       4594 │ Data Scientist                                                    │ Data Scientist        │ 2024-02-12 11:12:23 │         75000.0 │            100000.0 │      -25000.0 │       
│  865934 │       4594 │ Data Science                                                      │ Data Scientist        │ 2024-02-12 11:12:45 │        100000.0 │            100000.0 │           0.0 │       
│  879740 │       4594 │ Data Science Consultant                                           │ Data Scientist        │ 2024-02-19 16:12:09 │        100000.0 │            136500.0 │      -36500.0 │       
│  896270 │       4594 │ Senior Consultant (full time) - Fraud Data Analyst                │ Data Analyst          │ 2024-02-28 07:50:55 │        136500.0 │            136500.0 │           0.0 │
│  898520 │       4594 │ Senior Consultant (full time) - Fraud Data Analyst                │ Data Analyst          │ 2024-02-29 08:00:14 │        136500.0 │            100000.0 │       36500.0 │       
│  899932 │       4594 │ Data Scientist                                                    │ Data Scientist        │ 2024-02-29 19:02:36 │        100000.0 │            136500.0 │      -36500.0 │       
│ 1211909 │       4594 │ Consultant Manager-Pharma Biotech Data Scientist                  │ Data Scientist        │ 2024-10-05 12:01:10 │        136500.0 │            151782.0 │      -15282.0 │       
│ 1212494 │       4594 │ Associate Director, Data Analytics                                │ Data Analyst          │ 2024-10-06 11:00:35 │        151782.0 │            130500.0 │       21282.0 │       
│ 1337452 │       4594 │ Business Intelligence Analyst                                     │ Business Analyst      │ 2025-01-29 21:00:16 │        130500.0 │            150500.0 │      -20000.0 │
│ 1608236 │       4594 │ Lead Analyst, People Analytics                                    │ Data Scientist        │ 2025-06-18 17:00:11 │        150500.0 │                NULL │          NULL │       
│  142923 │       4598 │ Senior Analyst Planning, Forecasting & Reporting                  │ Business Analyst      │ 2023-02-20 17:00:10 │         85000.0 │             78500.0 │        6500.0 │       
│  586669 │       4598 │ Analytics Supervisor                                              │ Senior Data Analyst   │ 2023-09-22 16:02:56 │         78500.0 │            135000.0 │      -56500.0 │       
│ 1097057 │       4598 │ Data Scientist                                                    │ Data Scientist        │ 2024-07-11 18:04:11 │        135000.0 │            128000.0 │        7000.0 │       
│ 1610710 │       4598 │ Marketing Analyst                                                 │ Business Analyst      │ 2025-06-20 22:00:59 │        128000.0 │                NULL │          NULL │
│    9006 │       4599 │ Data Analyst, Reporting                                           │ Data Analyst          │ 2023-01-02 08:29:05 │        111202.0 │            185000.0 │      -73798.0 │       
│   76921 │       4599 │ Senior People Analytics Analyst (San Francisco, CA)               │ Data Scientist        │ 2023-01-25 07:01:04 │        185000.0 │            111175.0 │       73825.0 │       
│   79945 │       4599 │ Data Analyst, Developer Relations                                 │ Data Analyst          │ 2023-01-26 03:04:13 │        111175.0 │            166000.0 │      -54825.0 │       
├─────────┴────────────┴───────────────────────────────────────────────────────────────────┴───────────────────────┴─────────────────────┴─────────────────┴─────────────────────┴───────────────┤
│ 60 rows (40 shown)                                                                                                                                                                   8 columns │       
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/