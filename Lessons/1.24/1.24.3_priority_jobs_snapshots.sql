-- .read Lessons/1.24/1.24.3_priority_jobs_snapshots.sql



-- CREATE TEMP TABLE

CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    pr.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at,
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles AS pr
    ON jpf.job_title_short = pr.role_name;



-- -- UPDATE statement

-- UPDATE main.prority_jobs_snapshot AS tgt
-- SET
--     priority_lvl = src.priority_lvl,
--     updated_at = src.updated_at
-- FROM src_priority_jobs AS src
-- WHERE tgt.job_id = src.job_id
--     AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;



-- -- INSERT statement

-- INSERT INTO main.prority_jobs_snapshot (
--     job_id,
--     job_title_short,
--     company_name,
--     job_posted_date,
--     salary_year_avg,
--     priority_lvl,
--     updated_at
-- )
-- SELECT
--     src.job_id,
--     src.job_title_short,
--     src.company_name,
--     src.job_posted_date,
--     src.salary_year_avg,
--     src.priority_lvl,
--     src.updated_at
-- FROM src_priority_jobs AS src
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM main.prority_jobs_snapshot AS tgt
--     WHERE tgt.job_id = src.job_id
-- );



-- -- DELETE statement

-- DELETE FROM main.prority_jobs_snapshot AS tgt
-- WHERE NOt EXISTS(
--     SELECT 1
--     FROM src_priority_jobs AS src
--     WHERE src.job_id = tgt.job_id
-- );



-- MERGE

MERGE INTO main.prority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at

WHEN NOT MATCHED THEN
    INSERT  (
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )
    VALUES(
        src.job_id,
        src.job_title_short,
        src.company_name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    )

WHEN NOT MATCHED BY SOURCE THEN DELETE;


-- final check query
SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM prority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;
/*
┌──────────────────────┬───────────┬──────────────┬────────────────────────────┐
│   job_title_short    │ job_count │ priority_lvl │         updated_at         │
│       varchar        │   int64   │    int32     │         timestamp          │
├──────────────────────┼───────────┼──────────────┼────────────────────────────┤
│ Data Engineer        │    391957 │            1 │ 2026-02-21 21:33:51.676748 │
│ Software Engineer    │     92271 │            3 │ 2026-02-21 21:33:51.676748 │
│ Senior Data Engineer │     91295 │            1 │ 2026-02-21 21:33:51.676748 │
└──────────────────────┴───────────┴──────────────┴────────────────────────────┘
*/

/*
┌──────────────────────┬───────────┬──────────────┬────────────────────────────┐
│   job_title_short    │ job_count │ priority_lvl │         updated_at         │
│       varchar        │   int64   │    int32     │         timestamp          │
├──────────────────────┼───────────┼──────────────┼────────────────────────────┤
│ Data Engineer        │    391957 │            2 │ 2026-02-22 00:04:51.123813 │
│ Software Engineer    │     92271 │            3 │ 2026-02-21 21:33:51.676748 │
│ Senior Data Engineer │     91295 │            1 │ 2026-02-21 21:33:51.676748 │
└──────────────────────┴───────────┴──────────────┴────────────────────────────┘
*/