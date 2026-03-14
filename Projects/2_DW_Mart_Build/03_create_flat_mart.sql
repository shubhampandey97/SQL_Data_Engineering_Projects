-- Step 3: Mart - Create flat mart table (denormalized data warehouse)

-- Drop existing flat mart schema if it exists (for idempotency)
DROP SCHEMA IF EXISTS flat_mart CASCADE;

-- Create the flat mart schema
CREATE SCHEMA flat_mart;

SELECT '=== loading Flat Mart ===' AS info;
CREATE TABLE flat_mart.job_postings AS
SELECT
    -- Fact table fields
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
    -- Company dimension fields
    cd.company_id,
    cd.name AS company_name,
    -- Aggregate skills into an array of structs
    ARRAY_AGG(
      STRUCT_PACK(
        type := sd.type,
        name := sd.skills
      )
    ) AS skills_and_types
FROM
    job_postings_fact AS jpf
    LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
    LEFT JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
GROUP BY ALL;


-- Verify flat mart was created
SELECT 'Flat Mart Job Postings' AS table_name, COUNT(*) as record_count FROM flat_mart.job_postings;

-- Show sample data
SELECT '=== Flat Mart Sample ===' AS info;
SELECT 
    job_id,
    company_name,
    job_title_short,
    job_location,
    job_country,
    salary_year_avg,
    job_work_from_home,
    skills_and_types
FROM flat_mart.job_postings 
LIMIT 10;

/*
┌───────────────────────────┐
│           info            │
│          varchar          │
├───────────────────────────┤
│ === loading Flat Mart === │
└───────────────────────────┘
100% ?██████████████████████████████████████? (00:00:08.08 elapsed)     
┌────────────────────────┬──────────────┐
│       table_name       │ record_count │
│        varchar         │    int64     │
├────────────────────────┼──────────────┤
│ Flat Mart Job Postings │   1615930    │
└────────────────────────┴──────────────┘
┌──────────────────────────┐
│           info           │
│         varchar          │
├──────────────────────────┤
│ === Flat Mart Sample === │
└──────────────────────────┘
┌────────┬──────────────────────┬───┬──────────────────────┐
│ job_id │     company_name     │ . │   skills_and_types   │
│ int32  │       varchar        │   │ struct("type" varc.  │
├────────┼──────────────────────┼───┼──────────────────────┤
│ 127487 │ Randstad Portugal    │ . │ [{'type': analyst_.  │
│ 127504 │ Turing               │ . │ [{'type': analyst_.  │
│ 127538 │ MSA Data Analytics.  │ . │ [{'type': analyst_.  │
│ 127652 │ Hexagone Digitale    │ . │ [{'type': other, '.  │
│ 127739 │ Visa                 │ . │ [{'type': database.  │
│ 127780 │ LTS Resourcing       │ . │ [{'type': database.  │
│ 127789 │ TechWolf             │ . │ [{'type': other, '.  │
│ 127889 │ Ursus, Inc.          │ . │ [{'type': programm.  │
│ 128059 │ Hays                 │ . │ [{'type': database.  │
│ 128221 │ Visa                 │ . │ [{'type': other, '.  │
├────────┴──────────────────────┴───┴──────────────────────┤
│ 10 rows                              8 columns (3 shown) │
└──────────────────────────────────────────────────────────┘
*/