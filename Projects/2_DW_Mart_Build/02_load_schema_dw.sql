-- Step 2: DW - Load data from CSV files into star schema tables (Data Warehouse)

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