-- Subquery

SELECT *
FROM(
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
) AS valid_salaries
LIMIT 10;
/*
┌────────┬────────────┬──────────────────┬───┬─────────────────┬─────────────────┐
│ job_id │ company_id │ job_title_short  │ . │ salary_year_avg │ salary_hour_avg │
│ int32  │   int32    │     varchar      │   │     double      │     double      │
├────────┼────────────┼──────────────────┼───┼─────────────────┼─────────────────┤
│   4610 │       4610 │ Data Analyst     │ . │            NULL │            20.0 │
│   4651 │       4651 │ Data Scientist   │ . │        110000.0 │            NULL │
│   4699 │       4699 │ Data Engineer    │ . │         65000.0 │            NULL │
│   4804 │       4804 │ Business Analyst │ . │         90000.0 │            NULL │
│   4810 │       4810 │ Data Analyst     │ . │         55000.0 │            NULL │
│   4828 │       4828 │ Data Scientist   │ . │            NULL │            20.0 │
│   4833 │       4833 │ Data Scientist   │ . │        120531.0 │            NULL │
│   4846 │       4846 │ Data Engineer    │ . │        300000.0 │            NULL │
│   5089 │       5089 │ Data Analyst     │ . │         51000.0 │            NULL │
│   5123 │       5123 │ Data Scientist   │ . │        133500.0 │            NULL │
├────────┴────────────┴──────────────────┴───┴─────────────────┴─────────────────┤
│ 10 rows                                                   16 columns (5 shown) │
└────────────────────────────────────────────────────────────────────────────────┘
*/


-- Scenario1 - Subquery in 'SELECT'
-- Show each job's salary next to the overall market median:

SELECT
    job_title_short,
    salary_year_avg,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
    ) AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;
/*
┌──────────────────┬─────────────────┬──────────────────────┐
│ job_title_short  │ salary_year_avg │ market_median_salary │
│     varchar      │     double      │        double        │
├──────────────────┼─────────────────┼──────────────────────┤
│ Data Scientist   │        110000.0 │             116950.0 │
│ Data Engineer    │         65000.0 │             116950.0 │
│ Business Analyst │         90000.0 │             116950.0 │
│ Data Analyst     │         55000.0 │             116950.0 │
│ Data Scientist   │        120531.0 │             116950.0 │
│ Data Engineer    │        300000.0 │             116950.0 │
│ Data Analyst     │         51000.0 │             116950.0 │
│ Data Scientist   │        133500.0 │             116950.0 │
│ Data Analyst     │         77500.0 │             116950.0 │
│ Data Scientist   │        125000.0 │             116950.0 │
├──────────────────┴─────────────────┴──────────────────────┤
│ 10 rows                                         3 columns │
└───────────────────────────────────────────────────────────┘
*/



-- Scenario2 - Subquery in FROM
-- Stage only jobs that are remote before aggregating:

SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)   AS clean_jobs
GROUP BY job_title_short
LIMIT 10;
/*
┌───────────────────────────┬───────────────┬─────────────────────────────┐
│      job_title_short      │ median_salary │ market_remote_median_salary │
│          varchar          │    double     │           double            │
├───────────────────────────┼───────────────┼─────────────────────────────┤
│ Senior Data Analyst       │      105000.0 │                    130000.0 │
│ Cloud Engineer            │      132000.0 │                    130000.0 │
│ Machine Learning Engineer │      138433.5 │                    130000.0 │
│ Senior Data Engineer      │      145000.0 │                    130000.0 │
│ Data Engineer             │      135000.0 │                    130000.0 │
│ Data Scientist            │      132500.0 │                    130000.0 │
│ Business Analyst          │       90000.0 │                    130000.0 │
│ Senior Data Scientist     │      160000.0 │                    130000.0 │
│ Software Engineer         │      180000.0 │                    130000.0 │
│ Data Analyst              │       87500.0 │                    130000.0 │
├───────────────────────────┴───────────────┴─────────────────────────────┤
│ 10 rows                                                       3 columns │
└─────────────────────────────────────────────────────────────────────────┘
*/



-- Scenario3 - Subquery in HAVING
-- Keep only job titles whose median salary is above the overall median:

SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)   AS clean_jobs
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) >(
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)
LIMIT 10;
/*
┌───────────────────────────┬───────────────┬─────────────────────────────┐
│      job_title_short      │ median_salary │ market_remote_median_salary │
│          varchar          │    double     │           double            │
├───────────────────────────┼───────────────┼─────────────────────────────┤
│ Software Engineer         │      180000.0 │                    130000.0 │
│ Senior Data Engineer      │      145000.0 │                    130000.0 │
│ Senior Data Scientist     │      160000.0 │                    130000.0 │
│ Cloud Engineer            │      132000.0 │                    130000.0 │
│ Machine Learning Engineer │      138433.5 │                    130000.0 │
│ Data Scientist            │      132500.0 │                    130000.0 │
│ Data Engineer             │      135000.0 │                    130000.0 │
└───────────────────────────┴───────────────┴─────────────────────────────┘
*/




-- Example

SELECT RANGE(3);
/*
┌────────────┐
│ "range"(3) │
│  int64[]   │
├────────────┤
│ [0, 1, 2]  │
└────────────┘
*/


SELECT *
FROM RANGE(3);
/*
┌───────┐
│ range │
│ int64 │
├───────┤
│     0 │
│     1 │
│     2 │
└───────┘
*/


SELECT *
FROM RANGE(3) AS src(key);
/*
┌───────┐
│  key  │
│ int64 │
├───────┤
│     0 │
│     1 │
│     2 │
└───────┘
*/

SELECT *
FROM RANGE(2) AS src(key);
/*
┌───────┐
│  key  │
│ int64 │
├───────┤
│     0 │
│     1 │
└───────┘
*/


SELECT *
FROM RANGE(3) AS src(key)
WHERE EXISTS(
    SELECT 1
    FROM RANGE(2) AS tgt(key)
    WHERE tgt.key = src.key
);
/*
┌───────┐
│  key  │
│ int64 │
├───────┤
│     0 │
│     1 │
└───────┘
*/

SELECT *
FROM RANGE(3) AS src(key)
WHERE NOT EXISTS(
    SELECT 1
    FROM RANGE(2) AS tgt(key)
    WHERE tgt.key = src.key
);
/*
┌───────┐
│  key  │
│ int64 │
├───────┤
│   2   │
└───────┘
*/



-- Identify job postings that have no associated sills before loading them into data mart

SELECT *
FROM job_postings_fact
ORDER BY job_id
LIMIT 10;


SELECT *
FROM skills_job_dim
ORDER BY job_id
LIMIT 40;


SELECT *
FROM job_postings_fact AS tgt
WHERE NOT EXISTS(
    SELECT 1
    FROM skills_job_dim AS src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id;
/*
┌─────────┬────────────┬──────────────────────┬──────────────────────┬──────────────────────┬───┬──────────────────────┬───────────────┬─────────────┬─────────────────┬─────────────────┐
│ job_id  │ company_id │   job_title_short    │      job_title       │     job_location     │ . │ job_health_insurance │  job_country  │ salary_rate │ salary_year_avg │ salary_hour_avg │
│  int32  │   int32    │       varchar        │       varchar        │       varchar        │   │       boolean        │    varchar    │   varchar   │     double      │     double      │
├─────────┼────────────┼──────────────────────┼──────────────────────┼──────────────────────┼───┼──────────────────────┼───────────────┼─────────────┼─────────────────┼─────────────────┤
│    4602 │       4602 │ Business Analyst     │ Business Analyst -.  │ Thousand Oaks, CA    │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│    4605 │       4605 │ Data Analyst         │ Data Analyst         │ Irvine, CA           │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│    4608 │       4608 │ Data Analyst         │ Data Analyst for M.  │ Pasadena, CA         │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│    4611 │       4611 │ Data Analyst         │ Guidewire Policy D.  │ Sunnyvale, CA        │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│    4614 │       4611 │ Data Analyst         │ Guidewire Claims C.  │ Sunnyvale, CA        │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│    4619 │       4619 │ Data Analyst         │ Data Analyst         │ Irving, TX           │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│    4620 │       4620 │ Data Analyst         │ Data analyst         │ Irving, TX           │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│    4626 │       4626 │ Data Analyst         │ Data Collector Ana.  │ Austin, TX           │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
│    4636 │       4636 │ Data Analyst         │ Data Analyst         │ Orlando, FL          │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
│    4653 │       4618 │ Data Scientist       │ Associate Partner .  │ San Francisco, CA    │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│    4654 │       4618 │ Data Scientist       │ Data Science Consu.  │ San Francisco, CA    │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│    4666 │       4666 │ Data Engineer        │ Stage : Data Engin.  │ Paris, France        │ . │ false                │ France        │ NULL        │            NULL │            NULL │
│    4674 │       4674 │ Data Analyst         │ Sales data Analyst   │ Pakistan             │ . │ false                │ Pakistan      │ NULL        │            NULL │            NULL │
│    4676 │       4676 │ Data Scientist       │ Principal Data Sci.  │ United States        │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│    4688 │       4688 │ Data Scientist       │ Field Engineer       │ Singapore            │ . │ false                │ Singapore     │ NULL        │            NULL │            NULL │
│    4692 │       4692 │ Data Analyst         │ Data Governance An.  │ Antwerp, Belgium     │ . │ false                │ Belgium       │ NULL        │            NULL │            NULL │
│    4696 │       4696 │ Data Scientist       │ Senior Data Scient.  │ Stockholm, Sweden    │ . │ false                │ Sweden        │ NULL        │            NULL │            NULL │
│    4703 │       4703 │ Data Analyst         │ Data Analyst         │ Madrid, Spain        │ . │ false                │ Spain         │ NULL        │            NULL │            NULL │
│    4705 │       4705 │ Data Analyst         │ Data Entry / Opera.  │ Anywhere             │ . │ false                │ Spain         │ NULL        │            NULL │            NULL │
│    4710 │       4703 │ Business Analyst     │ Customer Service A.  │ Madrid, Spain        │ . │ false                │ Spain         │ NULL        │            NULL │            NULL │
│      ·  │         ·  │        ·             │          ·           │     ·                │ · │   ·                  │   ·           │  ·          │              ·  │              ·  │
│      ·  │         ·  │        ·             │          ·           │     ·                │ · │   ·                  │   ·           │  ·          │              ·  │              ·  │
│      ·  │         ·  │        ·             │          ·           │     ·                │ · │   ·                  │   ·           │  ·          │              ·  │              ·  │
│ 1620374 │     669679 │ Business Analyst     │ Immediate Openings.  │ Singapore            │ . │ false                │ Singapore     │ NULL        │            NULL │            NULL │
│ 1620397 │    1219175 │ Senior Data Analyst  │ Sr Business Data A.  │ Argyle, TX           │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
│ 1620404 │    1365791 │ Senior Data Scient.  │ Senior Data Specia.  │ Milan, GA            │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
│ 1620405 │    1365791 │ Data Scientist       │ Data-Driven Indust.  │ Atlanta, GA          │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│ 1620408 │    1365762 │ Data Scientist       │ Chief Data Insight.  │ Parsippany-Troy Hi.  │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│ 1620425 │    1248032 │ Business Analyst     │ Manufacturing Proc.  │ Sumqayit, Azerbaijan │ . │ false                │ Azerbaijan    │ NULL        │            NULL │            NULL │
│ 1620432 │    1620432 │ Data Analyst         │ Chief Financial Da.  │ Birmingham, AL       │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│ 1620456 │       8243 │ Business Analyst     │ 25061603 Business .  │ Yemen                │ . │ false                │ Yemen         │ NULL        │            NULL │            NULL │
│ 1620458 │       8243 │ Business Analyst     │ ? Aplicar En 3 Min.  │ Yemen                │ . │ false                │ Yemen         │ NULL        │            NULL │            NULL │
│ 1620459 │       8243 │ Business Analyst     │ Business Analyst I.  │ Yemen                │ . │ false                │ Yemen         │ NULL        │            NULL │            NULL │
│ 1620463 │    1365791 │ Data Analyst         │ Unlock Growth: Bec.  │ Irving, TX           │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│ 1620471 │    1610307 │ Senior Data Analyst  │ Senior Data Insigh.  │ Arezzo, Province o.  │ . │ false                │ Italy         │ NULL        │            NULL │            NULL │
│ 1620478 │       6334 │ Data Scientist       │ Data Science Manag.  │ New York, NY         │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│ 1620484 │    1609846 │ Data Analyst         │ Geospatial Data An.  │ Italy                │ . │ false                │ Italy         │ NULL        │            NULL │            NULL │
│ 1620485 │    1457640 │ Data Scientist       │ Unlock the Power o.  │ Naples, Metropolit.  │ . │ false                │ Italy         │ NULL        │            NULL │            NULL │
│ 1620491 │     483305 │ Data Scientist       │ DATA SCIENTIST wit.  │ MAFB GUN ANNX, AL    │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
│ 1620501 │    1457640 │ Data Analyst         │ Advanced Data Anal.  │ Palencia, Spain      │ . │ false                │ Spain         │ NULL        │            NULL │            NULL │
│ 1620510 │     611186 │ Data Engineer        │ Data Engineer        │ Moscow, Russia       │ . │ false                │ Russia        │ NULL        │            NULL │            NULL │
│ 1620515 │    1072204 │ Data Engineer        │ Systems Assurance .  │ Dar es Salaam, Tan.  │ . │ false                │ Tanzania      │ NULL        │            NULL │            NULL │
│ 1620521 │      55308 │ Data Analyst         │ Junior Data Analys.  │ Internatsionalnaya.  │ . │ false                │ Kyrgyzstan    │ NULL        │            NULL │            NULL │
├─────────┴────────────┴──────────────────────┴──────────────────────┴──────────────────────┴───┴──────────────────────┴───────────────┴─────────────┴─────────────────┴─────────────────┤
│ 285375 rows (40 shown)                                                                                                                                           16 columns (10 shown) │
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

SELECT *
FROM job_postings_fact AS tgt
WHERE EXISTS(
    SELECT 1
    FROM skills_job_dim AS src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id;
/*
┌─────────┬────────────┬──────────────────────┬──────────────────────┬──────────────────────┬───┬──────────────────────┬─────────────────────┬─────────────┬─────────────────┬─────────────────┐
│ job_id  │ company_id │   job_title_short    │      job_title       │     job_location     │ . │ job_health_insurance │     job_country     │ salary_rate │ salary_year_avg │ salary_hour_avg │
│  int32  │   int32    │       varchar        │       varchar        │       varchar        │   │       boolean        │       varchar       │   varchar   │     double      │     double      │
├─────────┼────────────┼──────────────────────┼──────────────────────┼──────────────────────┼───┼──────────────────────┼─────────────────────┼─────────────┼─────────────────┼─────────────────┤
│    4593 │       4593 │ Data Analyst         │ Data Analyst         │ New York, NY         │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4594 │       4594 │ Data Analyst         │ Data Analyst         │ Washington, DC       │ . │ true                 │ United States       │ NULL        │            NULL │            NULL │
│    4595 │       4595 │ Data Analyst         │ Data Analyst         │ Fairfax, VA          │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4596 │       4596 │ Senior Data Analyst  │ Senior Data Analys.  │ Worcester, MA        │ . │ true                 │ United States       │ NULL        │            NULL │            NULL │
│    4597 │       4597 │ Data Analyst         │ Data Analyst         │ Sunnyvale, CA        │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4598 │       4598 │ Data Analyst         │ Jr. Data Analyst     │ Torrance, CA         │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4599 │       4599 │ Data Analyst         │ Data Analyst         │ San Francisco, CA    │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4600 │       4600 │ Data Analyst         │ Loyalty Data Analy.  │ Pleasanton, CA       │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4601 │       4601 │ Senior Data Analyst  │ Senior data analyst  │ Rosemead, CA         │ . │ true                 │ United States       │ NULL        │            NULL │            NULL │
│    4603 │       4603 │ Data Analyst         │ Technical Data Ana.  │ Vandenberg AFB, CA   │ . │ true                 │ United States       │ NULL        │            NULL │            NULL │
│    4604 │       4604 │ Data Analyst         │ Neuroscience Resea.  │ Stanford, CA         │ . │ true                 │ United States       │ NULL        │            NULL │            NULL │
│    4606 │       4606 │ Data Analyst         │ BI Data Analyst      │ San Jose, CA         │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4607 │       4607 │ Data Analyst         │ EDI Data Analyst     │ Fullerton, CA        │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4609 │       4609 │ Data Analyst         │ BI Data Analyst      │ Santa Clara, CA      │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4610 │       4610 │ Data Analyst         │ Data Analyst, Part.  │ San Francisco, CA    │ . │ false                │ United States       │ hour        │            NULL │            20.0 │
│    4612 │       4612 │ Data Analyst         │ Sr. Data Analyst     │ Los Angeles, CA      │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4613 │       4613 │ Data Analyst         │ Applications Analy.  │ Fremont, CA          │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4615 │       4615 │ Business Analyst     │ Business Analyst -.  │ Foster City, CA      │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4616 │       4616 │ Data Analyst         │ SAP Data Analyst     │ Dallas, TX           │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│    4617 │       4617 │ Data Analyst         │ Data Analyst II      │ Austin, TX           │ . │ false                │ United States       │ NULL        │            NULL │            NULL │
│      ·  │         ·  │      ·               │        ·             │  ·                   │ · │   ·                  │     ·               │  ·          │              ·  │              ·  │
│      ·  │         ·  │      ·               │        ·             │  ·                   │ · │   ·                  │     ·               │  ·          │              ·  │              ·  │
│      ·  │         ·  │      ·               │        ·             │  ·                   │ · │   ·                  │     ·               │  ·          │              ·  │              ·  │
│ 1620499 │      10462 │ Data Engineer        │ Data Platform Engi.  │ NULL                 │ . │ false                │ Hong Kong           │ NULL        │            NULL │            NULL │
│ 1620500 │    1366092 │ Data Scientist       │ Data Scientist for.  │ Torrejón de Ardoz,.  │ . │ false                │ Spain               │ NULL        │            NULL │            NULL │
│ 1620502 │     949292 │ Data Engineer        │ BI & Data Warehous.  │ Bengaluru, Karnata.  │ . │ false                │ India               │ NULL        │            NULL │            NULL │
│ 1620503 │     426606 │ Software Engineer    │ Full Stack .NET De.  │ Dhaka, Bangladesh    │ . │ false                │ Bangladesh          │ NULL        │            NULL │            NULL │
│ 1620504 │     994657 │ Data Engineer        │ Knowledge Graph Da.  │ Casalecchio di Ren.  │ . │ false                │ Italy               │ NULL        │            NULL │            NULL │
│ 1620505 │      32572 │ Software Engineer    │ Data Software Engi.  │ Milan, Metropolita.  │ . │ false                │ Italy               │ NULL        │            NULL │            NULL │
│ 1620506 │       9224 │ Data Engineer        │ Data Engineer        │ Fes, Morocco         │ . │ false                │ Morocco             │ NULL        │            NULL │            NULL │
│ 1620507 │       4781 │ Data Scientist       │ Data Scientist - Q.  │ Madrid, Spain        │ . │ false                │ Spain               │ NULL        │            NULL │            NULL │
│ 1620508 │    1048741 │ Data Engineer        │ Data Engineer I      │ Sri Lanka            │ . │ false                │ Sri Lanka           │ NULL        │            NULL │            NULL │
│ 1620509 │       5915 │ Senior Data Scient.  │ Senior Data Scient.  │ Anywhere             │ . │ false                │ Ukraine             │ NULL        │            NULL │            NULL │
│ 1620511 │     135599 │ Software Engineer    │ Principal Software.  │ Nepal                │ . │ false                │ Nepal               │ NULL        │            NULL │            NULL │
│ 1620512 │       5236 │ Data Analyst         │ Data Analyst         │ Prague, Czechia      │ . │ false                │ Czechia             │ NULL        │            NULL │            NULL │
│ 1620513 │    1276829 │ Data Analyst         │ Data Analyst/ Comp.  │ Prague, Czechia      │ . │ false                │ Czechia             │ NULL        │            NULL │            NULL │
│ 1620514 │    1620514 │ Data Analyst         │ Data Analyst         │ Olomouc, Czechia     │ . │ false                │ Czechia             │ NULL        │            NULL │            NULL │
│ 1620516 │       5018 │ Senior Data Scient.  │ Senior Data Scient.  │ Luxembourg           │ . │ false                │ Luxembourg          │ NULL        │            NULL │            NULL │
│ 1620517 │     543452 │ Data Scientist       │ Data Science Manager │ Luxembourg           │ . │ false                │ Luxembourg          │ NULL        │            NULL │            NULL │
│ 1620518 │     408389 │ Data Scientist       │ Tutor-Reviewer For.  │ San Salvador, El S.  │ . │ false                │ El Salvador         │ NULL        │            NULL │            NULL │
│ 1620519 │      93285 │ Data Engineer        │ DATA ENGINEER        │ Abidjan, Côte d'Iv.  │ . │ false                │ Côte d'Ivoire       │ NULL        │            NULL │            NULL │
│ 1620520 │     819329 │ Data Analyst         │ Data Analyst - Mol.  │ Anywhere             │ . │ false                │ Moldova             │ NULL        │            NULL │            NULL │
│ 1620522 │      34108 │ Data Scientist       │ Principal Data Sci.  │ Anywhere             │ . │ false                │ U.S. Virgin Islands │ NULL        │            NULL │            NULL │
├─────────┴────────────┴──────────────────────┴──────────────────────┴──────────────────────┴───┴──────────────────────┴─────────────────────┴─────────────┴─────────────────┴─────────────────┤
│ 1330555 rows (1.33 million rows, 40 shown)                                                                                                                             16 columns (10 shown) │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/











-- CTE

WITH valid_salaries AS(
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salaries
LIMIT 10;
/*
┌────────┬────────────┬──────────────────┬──────────────────────┬────────────────────┬───┬──────────────────────┬───────────────┬─────────────┬─────────────────┬─────────────────┐
│ job_id │ company_id │ job_title_short  │      job_title       │    job_location    │ . │ job_health_insurance │  job_country  │ salary_rate │ salary_year_avg │ salary_hour_avg │
│ int32  │   int32    │     varchar      │       varchar        │      varchar       │   │       boolean        │    varchar    │   varchar   │     double      │     double      │
├────────┼────────────┼──────────────────┼──────────────────────┼────────────────────┼───┼──────────────────────┼───────────────┼─────────────┼─────────────────┼─────────────────┤
│   4610 │       4610 │ Data Analyst     │ Data Analyst, Part.  │ San Francisco, CA  │ . │ false                │ United States │ hour        │            NULL │            20.0 │
│   4651 │       4651 │ Data Scientist   │ Data Scientist       │ Calabasas, CA      │ . │ true                 │ United States │ year        │        110000.0 │            NULL │
│   4699 │       4699 │ Data Engineer    │ Data Engineer        │ Argentina          │ . │ false                │ Argentina     │ year        │         65000.0 │            NULL │
│   4804 │       4804 │ Business Analyst │ Hospitality Operat.  │ Anywhere           │ . │ true                 │ United States │ year        │         90000.0 │            NULL │
│   4810 │       4810 │ Data Analyst     │ Data Analytics Pro.  │ Atlanta, GA        │ . │ false                │ United States │ year        │         55000.0 │            NULL │
│   4828 │       4828 │ Data Scientist   │ Data Scientist       │ Reston, VA         │ . │ false                │ United States │ hour        │            NULL │            20.0 │
│   4833 │       4833 │ Data Scientist   │ Lead Data Scientis.  │ Burnsville, MN     │ . │ false                │ United States │ year        │        120531.0 │            NULL │
│   4846 │       4846 │ Data Engineer    │ Data Engineer - Re.  │ Boston, NY         │ . │ true                 │ United States │ year        │        300000.0 │            NULL │
│   5089 │       5089 │ Data Analyst     │ Junior Data Analyst  │ Gland, Switzerland │ . │ false                │ Switzerland   │ year        │         51000.0 │            NULL │
│   5123 │       5123 │ Data Scientist   │ Data Science Manager │ Carnegie, PA       │ . │ true                 │ United States │ year        │        133500.0 │            NULL │
├────────┴────────────┴──────────────────┴──────────────────────┴────────────────────┴───┴──────────────────────┴───────────────┴─────────────┴─────────────────┴─────────────────┤
│ 10 rows                                                                                                                                                   16 columns (10 shown) │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


-- CTE Example
-- Compare how much more (or less) remote roles play compared to onsite roles for each job title
-- Use a CTE the median salary by title and work arrangement, then compare those median

WITH title_median AS(
    SELECT 
    job_title_short,
    job_work_from_home,
    CAST(MEDIAN(salary_year_avg) AS INT) AS median_salary
FROM job_postings_fact
WHERE job_country = 'India'
GROUP BY
    job_title_short,
    job_work_from_home
)


SELECT
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary,
    (r.median_salary - o.median_salary) AS remote_premium 
FROM title_median AS r
INNER JOIN title_median AS o
    ON r.job_title_short = O.job_title_short
WHERE r.job_work_from_home = TRUE
    AND O.job_work_from_home = FALSE
ORDER BY remote_premium DESC;
/*
┌───────────────────────────┬──────────────────────┬──────────────────────┬────────────────┐
│      job_title_short      │ remote_median_salary │ onsite_median_salary │ remote_premium │   
│          varchar          │        int32         │        int32         │     int32      │   
├───────────────────────────┼──────────────────────┼──────────────────────┼────────────────┤
│ Cloud Engineer            │               153985 │                62624 │          91361 │   
│ Software Engineer         │               120000 │                79200 │          40800 │   
│ Business Analyst          │                94500 │                64800 │          29700 │   
│ Senior Data Scientist     │                85000 │                81600 │           3400 │
│ Data Analyst              │                50000 │                79200 │         -29200 │
│ Senior Data Analyst       │                55000 │                89688 │         -34688 │
│ Data Scientist            │                64375 │               114516 │         -50141 │
│ Machine Learning Engineer │                31250 │                85750 │         -54500 │
│ Data Engineer             │                61200 │               131580 │         -70380 │
│ Senior Data Engineer      │                39990 │               147500 │        -107510 │
├───────────────────────────┴──────────────────────┴──────────────────────┴────────────────┤
│ 10 rows                                                                        4 columns │
└──────────────────────────────────────────────────────────────────────────────────────────┘
*/