-- Step 2: DW - Load data from CSV files into star schema tables (Data Warehouse)
-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

SELECT '=== lOADING company_dim Table ===' AS info;

-- Load dimension tables first (no FK dependencies)
INSERT INTO company_dim (company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv', 
    AUTO_DETECT=true
);

SELECT '=== lOADING skills_dim Table ===' AS info;

INSERT INTO skills_dim (skill_id, skills, type)
SELECT skill_id, skills, type
FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv', 
    AUTO_DETECT=true
);

SELECT '=== lOADING job_postings_fact Table ===' AS info;

-- Load fact table second (FK references company_dim - must load after dimensions)
INSERT INTO job_postings_fact (
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
)
SELECT 
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv', 
    AUTO_DETECT=true
);

SELECT '=== lOADING skills_job_dim Table ===' AS info;

-- Load bridge table last (FKs reference skills_dim and job_postings_fact)
INSERT INTO skills_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv', 
    AUTO_DETECT=true
);

/*
┌───────────────────┐
│    table_name     │
│      varchar      │
├───────────────────┤
│ company_dim       │
│ job_postings_fact │
│ skills_dim        │
│ skills_job_dim    │
└───────────────────┘
┌───────────────────────────────────┐
│               info                │
│              varchar              │
├───────────────────────────────────┤
│ === lOADING company_dim Table === │
└───────────────────────────────────┘
100% ?██████████████████████████████████████? (00:00:06.27 elapsed)     
┌──────────────────────────────────┐
│               info               │
│             varchar              │
├──────────────────────────────────┤
│ === lOADING skills_dim Table === │
└──────────────────────────────────┘
┌────────────────────────────────────────┐
│                  info                  │
│                varchar                 │
├────────────────────────────────────────┤
│ === lOADING job_posting_fact Table === │
└────────────────────────────────────────┘
100% ?██████████████████████████████████████? (00:01:10.64 elapsed)     
┌──────────────────────────────────────┐
│                 info                 │
│               varchar                │
├──────────────────────────────────────┤
│ === lOADING skills_job_dim Table === │
└──────────────────────────────────────┘
100% ?██████████████████████████████████████? (00:00:28.62 elapsed)
*/


-- Verify data was loaded correctly
SELECT 'Company Dimension' AS table_name, COUNT(*) as record_count FROM company_dim
UNION ALL
SELECT 'Skills Dimension', COUNT(*) FROM skills_dim
UNION ALL
SELECT 'Job Postings Fact', COUNT(*) FROM job_postings_fact
UNION ALL
SELECT 'Skills Job Bridge', COUNT(*) FROM skills_job_dim;

/*
┌───────────────────┬──────────────┐
│    table_name     │ record_count │
│      varchar      │    int64     │
├───────────────────┼──────────────┤
│ Company Dimension │       215940 │
│ Skills Dimension  │          262 │
│ Job Postings Fact │      1615930 │
│ Skills Job Bridge │      7193426 │
└───────────────────┴──────────────┘
*/


-- Show sample data
SELECT '=== Company Dimension Sample ===' AS info;
SELECT * FROM company_dim LIMIT 5;

SELECT '=== Skills Dimension Sample ===' AS info;
SELECT * FROM skills_dim LIMIT 5;

SELECT '=== Job Postings Fact Sample ===' AS info;
SELECT * FROM job_postings_fact LIMIT 5;

SELECT '=== Skills Job Bridge Sample ===' AS info;
SELECT * FROM skills_job_dim LIMIT 5;
/*
┌──────────────────────────────────┐
│               info               │
│             varchar              │
├──────────────────────────────────┤
│ === Company Dimension Sample === │
└──────────────────────────────────┘
┌────────────┬────────────────────────┐
│ company_id │          name          │
│   int32    │        varchar         │
├────────────┼────────────────────────┤
│       4593 │ Metasys Technologies   │
│       4594 │ Guidehouse             │
│       4595 │ Protask                │
│       4596 │ Atria Wealth Solutions │
│       4597 │ ICONMA, LLC            │
└────────────┴────────────────────────┘
┌─────────────────────────────────┐
│              info               │
│             varchar             │
├─────────────────────────────────┤
│ === Skills Dimension Sample === │
└─────────────────────────────────┘
┌──────────┬─────────┬─────────────┐
│ skill_id │ skills  │    type     │
│  int32   │ varchar │   varchar   │
├──────────┼─────────┼─────────────┤
│        0 │ sql     │ programming │
│        1 │ python  │ programming │
│        2 │ r       │ programming │
│        3 │ go      │ programming │
│        4 │ matlab  │ programming │
└──────────┴─────────┴─────────────┘
┌──────────────────────────────────┐
│               info               │
│             varchar              │
├──────────────────────────────────┤
│ === Job Postings Fact Sample === │
└──────────────────────────────────┘
┌────────┬────────────┬───┬─────────────────┬─────────────────┐
│ job_id │ company_id │ . │ salary_year_avg │ salary_hour_avg │
│ int32  │   int32    │   │     double      │     double      │
├────────┼────────────┼───┼─────────────────┼─────────────────┤
│   4593 │       4593 │ . │            NULL │            NULL │
│   4594 │       4594 │ . │            NULL │            NULL │
│   4595 │       4595 │ . │            NULL │            NULL │
│   4596 │       4596 │ . │            NULL │            NULL │
│   4597 │       4597 │ . │            NULL │            NULL │
├────────┴────────────┴───┴─────────────────┴─────────────────┤
│ 5 rows                                 16 columns (4 shown) │
└─────────────────────────────────────────────────────────────┘
┌──────────────────────────────────┐
│               info               │
│             varchar              │
├──────────────────────────────────┤
│ === Skills Job Bridge Sample === │
└──────────────────────────────────┘
┌──────────┬────────┐
│ skill_id │ job_id │
│  int32   │ int32  │
├──────────┼────────┤
│        0 │   4593 │
│        0 │   4594 │
│        1 │   4594 │
│        2 │   4594 │
│        0 │   4595 │
└──────────┴────────┘
*/