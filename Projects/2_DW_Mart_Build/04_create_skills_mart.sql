-- Step 4: Mart - Create skills demand mart (dimensional mart)

-- Drop existing mart schema if it exists (for idempotency)
DROP SCHEMA IF EXISTS skills_mart CASCADE;

-- Step 1: Create the mart schema
CREATE SCHEMA skills_mart;

-- Step 2: Create dimension tables

-- 1. Skills dimension
CREATE TABLE skills_mart.dim_skill (
    skill_id INTEGER PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);

INSERT INTO skills_mart.dim_skill (skill_id, skills, type)
SELECT
    skill_id,
    skills,
    type
FROM skills_dim;

-- 2. Month-level date dimension (enhanced with quarter and other attributes)
CREATE TABLE skills_mart.dim_date_month (
    month_start_date DATE PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    quarter_name VARCHAR,
    year_quarter VARCHAR
);

INSERT INTO skills_mart.dim_date_month (
    month_start_date,
    year,
    month,
    quarter,
    quarter_name,
    year_quarter
)
SELECT DISTINCT
    DATE_TRUNC('month', job_posted_date)::DATE AS month_start_date,
    EXTRACT(year FROM job_posted_date) AS year,
    EXTRACT(month FROM job_posted_date) AS month,
    EXTRACT(quarter FROM job_posted_date) AS quarter,
    -- Quarter name
    'Q' || CAST(EXTRACT(quarter FROM job_posted_date) AS VARCHAR) AS quarter_name,
    -- Year-Quarter combination for easy filtering
    CAST(EXTRACT(year FROM job_posted_date) AS VARCHAR) || '-Q' || 
    CAST(EXTRACT(quarter FROM job_posted_date) AS VARCHAR) AS year_quarter
FROM job_postings_fact
WHERE job_posted_date IS NOT NULL;

-- Step 3: Create fact table - fact_skill_demand_monthly
-- Grain: skill_id + month_start_date + job_title_short
-- All measures are additive (counts and sums) - safe to re-aggregate
CREATE TABLE skills_mart.fact_skill_demand_monthly (
    skill_id INTEGER,
    month_start_date DATE,
    job_title_short VARCHAR,
    postings_count INTEGER,
    remote_postings_count INTEGER,
    health_insurance_postings_count INTEGER,
    no_degree_mention_count INTEGER,
    PRIMARY KEY (skill_id, month_start_date, job_title_short),
    FOREIGN KEY (skill_id) REFERENCES skills_mart.dim_skill(skill_id),
    FOREIGN KEY (month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);

INSERT INTO skills_mart.fact_skill_demand_monthly (
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_postings_count,
    health_insurance_postings_count,
    no_degree_mention_count
)
WITH job_postings_prepared AS (
    SELECT
        sj.skill_id,
        DATE_TRUNC('month', jp.job_posted_date)::DATE AS month_start_date,
        jp.job_title_short,
        -- Convert boolean flags to numeric values (1 or 0)
        CASE WHEN jp.job_work_from_home = TRUE THEN 1 ELSE 0 END AS is_remote,
        CASE WHEN jp.job_health_insurance = TRUE THEN 1 ELSE 0 END AS has_health_insurance,
        CASE WHEN jp.job_no_degree_mention = TRUE THEN 1 ELSE 0 END AS no_degree_mention
    FROM
        job_postings_fact jp
    INNER JOIN
        skills_job_dim sj
        ON jp.job_id = sj.job_id
    WHERE
        jp.job_posted_date IS NOT NULL
)
SELECT
    skill_id,
    month_start_date,
    job_title_short,

    -- Additive counts
    COUNT(*) AS postings_count,

    -- Remote / benefits / degree flags (additive counts)
    SUM(is_remote) AS remote_postings_count,
    SUM(has_health_insurance) AS health_insurance_postings_count,
    SUM(no_degree_mention) AS no_degree_mention_count
FROM
    job_postings_prepared
GROUP BY
    skill_id,
    month_start_date,
    job_title_short;


-- Verify mart was created
SELECT 'Skill Dimension' AS table_name, COUNT(*) as record_count FROM skills_mart.dim_skill
UNION ALL
SELECT 'Date Month Dimension', COUNT(*) FROM skills_mart.dim_date_month
UNION ALL
SELECT 'Skill Demand Fact', COUNT(*) FROM skills_mart.fact_skill_demand_monthly;

-- Show sample data from each table
SELECT '=== Skill Dimension Sample ===' AS info;
SELECT * FROM skills_mart.dim_skill LIMIT 10;

SELECT '=== Date Month Dimension Sample ===' AS info;
SELECT * FROM skills_mart.dim_date_month ORDER BY month_start_date DESC LIMIT 10;

SELECT '=== Skill Demand Fact Sample ===' AS info;
SELECT 
    fdsm.skill_id,
    ds.skills,
    ds.type AS skill_type,
    fdsm.job_title_short,
    fdsm.month_start_date,
    fdsm.postings_count,
    fdsm.remote_postings_count,
    fdsm.health_insurance_postings_count,
    fdsm.no_degree_mention_count,
    -- Calculate derived metrics (ratios) from additive measures
    CASE 
        WHEN fdsm.postings_count > 0 
        THEN fdsm.remote_postings_count::DOUBLE / fdsm.postings_count 
        ELSE 0.0 
    END AS remote_share
FROM skills_mart.fact_skill_demand_monthly fdsm
JOIN skills_mart.dim_skill ds ON fdsm.skill_id = ds.skill_id
ORDER BY fdsm.postings_count DESC, fdsm.month_start_date DESC
LIMIT 10;
/*
┌──────────────────────┬──────────────┐
│      table_name      │ record_count │
│       varchar        │    int64     │
├──────────────────────┼──────────────┤
│ Skill Dimension      │          262 │
│ Date Month Dimension │           30 │
│ Skill Demand Fact    │        52520 │
└──────────────────────┴──────────────┘
┌────────────────────────────────┐
│              info              │
│            varchar             │
├────────────────────────────────┤
│ === Skill Dimension Sample === │
└────────────────────────────────┘
┌──────────┬────────────┬─────────────┐
│ skill_id │   skills   │    type     │
│  int32   │  varchar   │   varchar   │
├──────────┼────────────┼─────────────┤
│        0 │ sql        │ programming │
│        1 │ python     │ programming │
│        2 │ r          │ programming │
│        3 │ go         │ programming │
│        4 │ matlab     │ programming │
│        5 │ crystal    │ programming │
│        6 │ javascript │ programming │
│        7 │ scala      │ programming │
│        8 │ sas        │ programming │
│        9 │ nosql      │ programming │
├──────────┴────────────┴─────────────┤
│ 10 rows                   3 columns │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│                info                 │
│               varchar               │
├─────────────────────────────────────┤
│ === Date Month Dimension Sample === │
└─────────────────────────────────────┘
┌──────────────────┬───────┬───────┬─────────┬──────────────┬──────────────┐
│ month_start_date │ year  │ month │ quarter │ quarter_name │ year_quarter │  
│       date       │ int32 │ int32 │  int32  │   varchar    │   varchar    │
├──────────────────┼───────┼───────┼─────────┼──────────────┼──────────────┤  
│ 2025-06-01       │  2025 │     6 │       2 │ Q2           │ 2025-Q2      │
│ 2025-05-01       │  2025 │     5 │       2 │ Q2           │ 2025-Q2      │  
│ 2025-04-01       │  2025 │     4 │       2 │ Q2           │ 2025-Q2      │  
│ 2025-03-01       │  2025 │     3 │       1 │ Q1           │ 2025-Q1      │
│ 2025-02-01       │  2025 │     2 │       1 │ Q1           │ 2025-Q1      │  
│ 2025-01-01       │  2025 │     1 │       1 │ Q1           │ 2025-Q1      │  
│ 2024-12-01       │  2024 │    12 │       4 │ Q4           │ 2024-Q4      │
│ 2024-11-01       │  2024 │    11 │       4 │ Q4           │ 2024-Q4      │  
│ 2024-10-01       │  2024 │    10 │       4 │ Q4           │ 2024-Q4      │  
│ 2024-09-01       │  2024 │     9 │       3 │ Q3           │ 2024-Q3      │
├──────────────────┴───────┴───────┴─────────┴──────────────┴──────────────┤  
│ 10 rows                                                        6 columns │  
└──────────────────────────────────────────────────────────────────────────┘  
┌──────────────────────────────────┐
│               info               │
│             varchar              │
├──────────────────────────────────┤
│ === Skill Demand Fact Sample === │
└──────────────────────────────────┘
┌──────────┬─────────┬───┬──────────────────────┬─────────────────────┐
│ skill_id │ skills  │ . │ no_degree_mention_.  │    remote_share     │
│  int32   │ varchar │   │        int32         │       double        │
├──────────┼─────────┼───┼──────────────────────┼─────────────────────┤
│        1 │ python  │ . │                  350 │  0.0914001421464108 │
│        0 │ sql     │ . │                 5331 │ 0.10128728898481462 │
│        1 │ python  │ . │                 4882 │ 0.10430729668916747 │
│        0 │ sql     │ . │                 3912 │ 0.07914050756035017 │
│        1 │ python  │ . │                  264 │ 0.06467795395503001 │
│        0 │ sql     │ . │                  443 │ 0.09546974764366069 │
│        0 │ sql     │ . │                 3693 │ 0.12168613509395633 │
│        0 │ sql     │ . │                 3726 │  0.1091002044989775 │
│        0 │ sql     │ . │                 3267 │ 0.12353425221147912 │
│        0 │ sql     │ . │                 3980 │ 0.09839650145772595 │
├──────────┴─────────┴───┴──────────────────────┴─────────────────────┤
│ 10 rows                                        10 columns (4 shown) │
└─────────────────────────────────────────────────────────────────────┘
*/