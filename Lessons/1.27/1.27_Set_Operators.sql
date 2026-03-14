SELECT [1, 1, 1, 2];
/*
┌─────────────────────────────┐
│ main.list_value(1, 1, 1, 2) │
│           int32[]           │
├─────────────────────────────┤
│ [1, 1, 1, 2]                │
└─────────────────────────────┘
*/
SELECT UNNEST([1, 1, 1, 2]);
/*
┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                                   1 │
│                                   1 │
│                                   1 │
│                                   2 │
└─────────────────────────────────────┘
*/

-- UNION

SELECT UNNEST([1, 1, 1, 2])
UNION
SELECT UNNEST([1, 1, 3]);
/*
┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                                   3 │
│                                   1 │
│                                   2 │
└─────────────────────────────────────┘
*/


SELECT UNNEST([1, 1, 1, 2])
UNION ALL
SELECT UNNEST([1, 1, 3]);
/*
┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                                   1 │
│                                   1 │
│                                   1 │
│                                   2 │
│                                   1 │
│                                   1 │
│                                   3 │
└─────────────────────────────────────┘
*/




-- INTERSECT

SELECT UNNEST([1, 1, 1, 2])
INTERSECT
SELECT UNNEST([1, 1, 3]);
/*
┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                  1                  │
└─────────────────────────────────────┘
*/

SELECT UNNEST([1, 1, 1, 2])
INTERSECT ALL
SELECT UNNEST([1, 1, 3]); 
/*
┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                                   1 │
│                                   1 │
└─────────────────────────────────────┘
*/



-- EXCEPT
SELECT UNNEST([1, 1, 1, 2])
EXCEPT
SELECT UNNEST([1, 1, 3]); 
/*
┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                  2                  │
└─────────────────────────────────────┘
*/

SELECT UNNEST([1, 1, 1, 2])
EXCEPT ALL
SELECT UNNEST([1, 1, 3]); 
/*
┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                                   2 │
│                                   1 │
└─────────────────────────────────────┘
*/



CREATE OR REPLACE TEMP TABLE jobs_2023 AS
SELECT                
    company_id,          
    job_title_short,       
    job_title,             
    job_location,          
    job_via,               
    job_schedule_type,     
    job_work_from_home,    
    search_location,       
    job_no_degree_mention, 
    job_health_insurance,  
    job_country,           
    salary_rate,          
    salary_year_avg,       
    salary_hour_avg      
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

SELECT * FROM jobs_2023;
/*
┌────────────┬──────────────────────┬──────────────────────┬──────────────────────┬──────────────────────┬───┬──────────────────────┬───────────────┬─────────────┬─────────────────┬─────────────────┐
│ company_id │   job_title_short    │      job_title       │     job_location     │       job_via        │ . │ job_health_insurance │  job_country  │ salary_rate │ salary_year_avg │ salary_hour_avg │
│   int32    │       varchar        │       varchar        │       varchar        │       varchar        │   │       boolean        │    varchar    │   varchar   │     double      │     double      │  
├────────────┼──────────────────────┼──────────────────────┼──────────────────────┼──────────────────────┼───┼──────────────────────┼───────────────┼─────────────┼─────────────────┼─────────────────┤
│       4593 │ Data Analyst         │ Data Analyst         │ New York, NY         │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │  
│       4594 │ Data Analyst         │ Data Analyst         │ Washington, DC       │ via CareerBuilder    │ . │ true                 │ United States │ NULL        │            NULL │            NULL │  
│       4595 │ Data Analyst         │ Data Analyst         │ Fairfax, VA          │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│       4596 │ Senior Data Analyst  │ Senior Data Analys.  │ Worcester, MA        │ via LinkedIn         │ . │ true                 │ United States │ NULL        │            NULL │            NULL │  
│       4597 │ Data Analyst         │ Data Analyst         │ Sunnyvale, CA        │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│       4598 │ Data Analyst         │ Jr. Data Analyst     │ Torrance, CA         │ via Recruit.net      │ . │ false                │ United States │ NULL        │            NULL │            NULL │  
│       4599 │ Data Analyst         │ Data Analyst         │ San Francisco, CA    │ via Jora             │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│       4600 │ Data Analyst         │ Loyalty Data Analy.  │ Pleasanton, CA       │ via Recruit.net      │ . │ false                │ United States │ NULL        │            NULL │            NULL │  
│       4601 │ Senior Data Analyst  │ Senior data analyst  │ Rosemead, CA         │ via Talent.com       │ . │ true                 │ United States │ NULL        │            NULL │            NULL │  
│       4602 │ Business Analyst     │ Business Analyst -.  │ Thousand Oaks, CA    │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│       4603 │ Data Analyst         │ Technical Data Ana.  │ Vandenberg AFB, CA   │ via Tarta.ai         │ . │ true                 │ United States │ NULL        │            NULL │            NULL │  
│       4604 │ Data Analyst         │ Neuroscience Resea.  │ Stanford, CA         │ via Recruit.net      │ . │ true                 │ United States │ NULL        │            NULL │            NULL │  
│       4605 │ Data Analyst         │ Data Analyst         │ Irvine, CA           │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│       4606 │ Data Analyst         │ BI Data Analyst      │ San Jose, CA         │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │  
│       4607 │ Data Analyst         │ EDI Data Analyst     │ Fullerton, CA        │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│       4608 │ Data Analyst         │ Data Analyst for M.  │ Pasadena, CA         │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │  
│       4609 │ Data Analyst         │ BI Data Analyst      │ Santa Clara, CA      │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │  
│       4610 │ Data Analyst         │ Data Analyst, Part.  │ San Francisco, CA    │ via RectDuty         │ . │ false                │ United States │ hour        │            NULL │            20.0 │  
│       4611 │ Data Analyst         │ Guidewire Policy D.  │ Sunnyvale, CA        │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│       4612 │ Data Analyst         │ Sr. Data Analyst     │ Los Angeles, CA      │ via CareerBuilder    │ . │ false                │ United States │ NULL        │            NULL │            NULL │  
│         ·  │      ·               │        ·             │    ·                 │       ·              │ · │   ·                  │   ·           │  ·          │              ·  │              ·  │
│         ·  │      ·               │        ·             │    ·                 │       ·              │ · │   ·                  │   ·           │  ·          │              ·  │              ·  │  
│         ·  │      ·               │        ·             │    ·                 │       ·              │ · │   ·                  │   ·           │  ·          │              ·  │              ·  │
│       6069 │ Data Engineer        │ Data engineer remote │ Anywhere             │ via Talent.com       │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │  
│      22457 │ Data Engineer        │ Data Engineer - Ma.  │ Hartford, CT         │ via Monster          │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │  
│      20455 │ Senior Data Engineer │ Senior data engineer │ Dallas, TX           │ via Talent.com       │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │
│      10582 │ Data Engineer        │ Data Engineer-Supe.  │ Fremont, CA          │ via ClimateTechList  │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │  
│      20455 │ Senior Data Engineer │ Senior data engineer │ Dallas, TX           │ via Talent.com       │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │
│       4640 │ Data Engineer        │ Azure data engineer  │ Austin, TX           │ via Talent.com       │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │  
│       6778 │ Data Scientist       │ Data scientist       │ Dallas, TX           │ via Talent.com       │ . │ true                 │ Sudan         │ year        │        162500.0 │            NULL │  
│       4640 │ Data Engineer        │ Azure data engineer  │ Austin, TX           │ via Talent.com       │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │  
│       6778 │ Data Scientist       │ Data scientist       │ Dallas, TX           │ via Talent.com       │ . │ true                 │ Sudan         │ year        │        162500.0 │            NULL │  
│      23597 │ Data Engineer        │ Data Engineer        │ Las Vegas, NV        │ via Mogul            │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │
│     627979 │ Data Engineer        │ Data engineer        │ Sunnyvale, CA        │ via Talent.com       │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │  
│     791940 │ Data Engineer        │ Data engineer        │ San Francisco, CA    │ via Talent.com       │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │  
│     791940 │ Data Engineer        │ Data engineer        │ San Francisco, CA    │ via Talent.com       │ . │ false                │ Sudan         │ NULL        │            NULL │            NULL │
│      28572 │ Data Engineer        │ Data Engineer - Vi.  │ New York, NY         │ via Monster          │ . │ true                 │ Sudan         │ NULL        │            NULL │            NULL │  
│     624711 │ Data Engineer        │ Staff engineer data  │ Southfield, MI       │ via Talent.com       │ . │ false                │ Sudan         │ year        │        140000.0 │            NULL │  
│     624711 │ Data Engineer        │ Staff engineer data  │ Southfield, MI       │ via Talent.com       │ . │ false                │ Sudan         │ year        │        140000.0 │            NULL │  
│       6531 │ Senior Data Analyst  │ Marketing Data & A.  │ Boston, MA  (+1 ot.  │ via Boston Consult.  │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│      12414 │ Machine Learning E.  │ Intelligence analyst │ Boston, MA           │ via Talent.com       │ . │ false                │ United States │ NULL        │            NULL │            NULL │  
│       6531 │ Senior Data Analyst  │ Marketing Data & A.  │ Boston, MA  (+1 ot.  │ via Boston Consult.  │ . │ false                │ United States │ NULL        │            NULL │            NULL │  
│      12414 │ Machine Learning E.  │ Intelligence analyst │ Boston, MA           │ via Talent.com       │ . │ false                │ United States │ NULL        │            NULL │            NULL │
├────────────┴──────────────────────┴──────────────────────┴──────────────────────┴──────────────────────┴───┴──────────────────────┴───────────────┴─────────────┴─────────────────┴─────────────────┤
│ 787356 rows (40 shown)                                                                                                                                                        14 columns (10 shown) │  
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


CREATE OR REPLACE TEMP TABLE jobs_2024 AS
SELECT                
    company_id,          
    job_title_short,       
    job_title,             
    job_location,          
    job_via,               
    job_schedule_type,     
    job_work_from_home,    
    search_location,       
    job_no_degree_mention, 
    job_health_insurance,  
    job_country,           
    salary_rate,          
    salary_year_avg,       
    salary_hour_avg      
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

SELECT * FROM jobs_2024;
/*
┌────────────┬──────────────────────┬──────────────────────┬─────────────────────┬──────────────────────┬───┬──────────────────────┬───────────────┬─────────────┬─────────────────┬─────────────────┐
│ company_id │   job_title_short    │      job_title       │    job_location     │       job_via        │ . │ job_health_insurance │  job_country  │ salary_rate │ salary_year_avg │ salary_hour_avg │
│   int32    │       varchar        │       varchar        │       varchar       │       varchar        │   │       boolean        │    varchar    │   varchar   │     double      │     double      │
├────────────┼──────────────────────┼──────────────────────┼─────────────────────┼──────────────────────┼───┼──────────────────────┼───────────────┼─────────────┼─────────────────┼─────────────────┤   
│      10437 │ Data Analyst         │ Summer Internship .  │ Marlborough, MA     │ via Boatingreveale.  │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
│      10437 │ Data Analyst         │ Summer Internship .  │ Marlborough, MA     │ via Boatingreveale.  │ . │ true                 │ United States │ NULL        │            NULL │            NULL │   
│      10582 │ Data Analyst         │ Staff Data Analyst.  │ Fremont, CA         │ via ClimateTechList  │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│      10582 │ Data Analyst         │ Staff Data Analyst.  │ Fremont, CA         │ via ClimateTechList  │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│     542643 │ Data Analyst         │ Junior Data Analys.  │ Waco, TX            │ via ZipRecruiter     │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│     542643 │ Data Analyst         │ Junior Data Analys.  │ Waco, TX            │ via ZipRecruiter     │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│      10582 │ Data Analyst         │ Data Analyst/Engin.  │ Austin, TX          │ via ClimateTechList  │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│      10582 │ Data Analyst         │ Data Analyst/Engin.  │ Austin, TX          │ via ClimateTechList  │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│      12414 │ Data Scientist       │ It analyst           │ Tampa, FL           │ via Talent.com       │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│      12414 │ Data Scientist       │ It analyst           │ Tampa, FL           │ via Talent.com       │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│      15281 │ Senior Data Scient.  │ Senior Data Scient.  │ Anywhere            │ via ZipRecruiter     │ . │ true                 │ United States │ NULL        │            NULL │            NULL │   
│      15281 │ Senior Data Scient.  │ Senior Data Scient.  │ Anywhere            │ via ZipRecruiter     │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
│      10582 │ Data Scientist       │ Data Scientist       │ Fremont, CA         │ via ClimateTechList  │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│      12661 │ Machine Learning E.  │ Machine Learning S.  │ San Ramon, CA       │ via Monster          │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│      12661 │ Machine Learning E.  │ Associate Machine .  │ Menlo Park, CA      │ via Monster          │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│      12661 │ Machine Learning E.  │ Associate Machine .  │ Menlo Park, CA      │ via Monster          │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│      12661 │ Machine Learning E.  │ Machine Learning S.  │ San Ramon, CA       │ via Monster          │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│     166400 │ Senior Data Analyst  │ Senior Data Analyst  │ United States       │ via BeBee            │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│     166400 │ Senior Data Analyst  │ Senior Data Analyst  │ United States       │ via BeBee            │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│      12414 │ Data Scientist       │ Director data scie.  │ Norcross, GA        │ via Talent.com       │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│        ·   │      ·               │          ·           │      ·              │  ·                   │ · │   ·                  │   ·           │  ·          │              ·  │              ·  │   
│        ·   │      ·               │          ·           │      ·              │  ·                   │ · │   ·                  │   ·           │  ·          │              ·  │              ·  │   
│        ·   │      ·               │          ·           │      ·              │  ·                   │ · │   ·                  │   ·           │  ·          │              ·  │              ·  │
│    1248180 │ Data Analyst         │ Abnormal data anal.  │ Kitwe, Zambia       │ Jobs                 │ . │ false                │ Zambia        │ month       │            NULL │            NULL │   
│    1248180 │ Data Analyst         │ Abnormal data anal.  │ Kitwe, Zambia       │ Jobs                 │ . │ false                │ Zambia        │ NULL        │            NULL │            NULL │   
│    1275890 │ Data Scientist       │ ????? Data Scienti.  │ Casablanca, Morocco │ ?????                │ . │ false                │ Morocco       │ a           │            NULL │            NULL │
│    1275890 │ Data Scientist       │ ????? Data Scienti.  │ Casablanca, Morocco │ ?????                │ . │ false                │ Morocco       │ NULL        │            NULL │            NULL │   
│      26915 │ Senior Data Scient.  │ Senior Data Scient.  │ Dublin, Ireland     │ EBay Jobs - EBay I.  │ . │ false                │ Ireland       │ NULL        │            NULL │            NULL │
│     701395 │ Data Analyst         │ Commercial data an.  │ Puerto Rico         │ Sercanto             │ . │ false                │ Puerto Rico   │ NULL        │            NULL │            NULL │   
│      61923 │ Data Engineer        │ Data engineer fina.  │ Puerto Rico         │ Sercanto             │ . │ false                │ Puerto Rico   │ NULL        │            NULL │            NULL │   
│      61923 │ Data Engineer        │ Data engineer fina.  │ Puerto Rico         │ Sercanto             │ . │ false                │ Puerto Rico   │ NULL        │            NULL │            NULL │
│     587365 │ Data Engineer        │ Database Engineer .  │ Lagos, Nigeria      │ IKrut                │ . │ false                │ Nigeria       │ NULL        │            NULL │            NULL │   
│     587365 │ Data Engineer        │ Database Engineer .  │ Lagos, Nigeria      │ IKrut                │ . │ false                │ Nigeria       │ NULL        │            NULL │            NULL │   
│    1275898 │ Data Scientist       │ Data Scientist ???.  │ Ar-Rayyan, Qatar    │ ?????                │ . │ false                │ Qatar         │ NULL        │            NULL │            NULL │   
│    1275898 │ Data Scientist       │ Data Scientist ???.  │ Ar-Rayyan, Qatar    │ ?????                │ . │ false                │ Qatar         │ a           │            NULL │            NULL │   
│      61544 │ Data Scientist       │ ????? ????? ??????.  │ Israel              │ Mploy ??????         │ . │ false                │ Israel        │ NULL        │            NULL │            NULL │   
│      61544 │ Data Scientist       │ ????? ????? ??????.  │ Israel              │ Mploy ??????         │ . │ false                │ Israel        │ NULL        │            NULL │            NULL │
│    1114220 │ Data Analyst         │ Business Data Anal.  │ Columbia, SC        │ LinkedIn             │ . │ false                │ United States │ NULL        │            NULL │            NULL │   
│    1114220 │ Data Analyst         │ Business Data Anal.  │ Columbia, SC        │ LinkedIn             │ . │ false                │ United States │ NULL        │            NULL │            NULL │
│      45358 │ Data Engineer        │ Machine Learning O.  │ Valley Falls, SC    │ WhatJobs             │ . │ true                 │ United States │ NULL        │            NULL │            NULL │   
│     518831 │ Machine Learning E.  │ Vice President, Ar.  │ Bellflower, CA      │ Careers At The Rea.  │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
│     518831 │ Machine Learning E.  │ Vice President, Ar.  │ Bellflower, CA      │ Careers At The Rea.  │ . │ true                 │ United States │ NULL        │            NULL │            NULL │   
│      45358 │ Data Engineer        │ Machine Learning O.  │ Cumberland, IN      │ WhatJobs             │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
├────────────┴──────────────────────┴──────────────────────┴─────────────────────┴──────────────────────┴───┴──────────────────────┴───────────────┴─────────────┴─────────────────┴─────────────────┤
│ 483959 rows (40 shown)                                                                                                                                                       14 columns (10 shown) │   
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


-- Which unique job postings appeared in either 2023 or 2024?
SELECT 
    'jobs_2023' AS table_name,
    COUNT(*) AS record_count
FROM jobs_2023
UNION
SELECT 
    'jobs_2024' AS table_name,
    COUNT(*) 
FROM jobs_2024;
/*
┌────────────┬──────────────┐
│ table_name │ record_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ jobs_2024  │       483959 │
│ jobs_2023  │       787356 │
└────────────┴──────────────┘
*/

SELECT * FROM jobs_2023
UNION
SELECT * FROM jobs_2024;


-- Which job postings appeared across both years, counting duplicates?
SELECT * FROM jobs_2023
UNION ALL
SELECT * FROM jobs_2024;

-- Which job postings appeared in both 2023 and 2024?
SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;

-- Which job postings appeared in both years, preserving duplicate counts?
SELECT * FROM jobs_2023
INTERSECT ALL
SELECT * FROM jobs_2024;

-- Which job postings appeared in 2023 but not in 2024?
SELECT 
    'jobs_2023' AS table_name,
    COUNT(*) AS record_count
FROM jobs_2023
EXCEPT
SELECT 
    'jobs_2024' AS table_name,
    COUNT(*) 
FROM jobs_2024;
/*
┌────────────┬──────────────┐
│ table_name │ record_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ jobs_2023  │    787356    │
└────────────┴──────────────┘
*/

SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

-- Which job postings from 2023 remain after substracting matching 2024 posting, one-for-one?
SELECT * FROM jobs_2023
EXCEPT ALL
SELECT * FROM jobs_2024;

-- Which job postings appeared more times in 2023 than 2024, one-for-one?

