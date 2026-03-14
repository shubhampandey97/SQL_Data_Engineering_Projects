-- Array Intro

SELECT [1, 2, 3];
/*
┌──────────────────────────┐
│ main.list_value(1, 2, 3) │
│         int32[]          │
├──────────────────────────┤
│ [1, 2, 3]                │
└──────────────────────────┘
*/

SELECT ['python', 'sql', 'r'] AS skills_array;
/*
┌───────────────────────────────────────┐
│ main.list_value('python', 'sql', 'r') │
│               varchar[]               │
├───────────────────────────────────────┤
│ [python, sql, r]                      │
└───────────────────────────────────────┘
*/

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
)
SELECT ARRAY_AGG(skill) AS skills_array
FROM skills;
/*
┌──────────────────┐
│   skills_array   │
│    varchar[]     │
├──────────────────┤
│ [python, r, sql] │
└──────────────────┘
*/

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
)
SELECT LIST(skill) AS skills_array
FROM skills;
/*
┌──────────────────┐
│   skills_array   │
│    varchar[]     │
├──────────────────┤
│ [python, r, sql] │
└──────────────────┘
*/

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT skills
FROM skills_array;
/*
┌──────────────────┐
│      skills      │
│    varchar[]     │
├──────────────────┤
│ [r, python, sql] │
└──────────────────┘
*/

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT skills[1] AS first_skill
FROM skills_array;
/*
┌─────────────┐
│ first_skill │
│   varchar   │
├─────────────┤
│ sql         │
└─────────────┘

┌─────────────┐
│ first_skill │
│   varchar   │
├─────────────┤
│ python      │
└─────────────┘

┌─────────────┐
│ first_skill │
│   varchar   │
├─────────────┤
│ r           │
└─────────────┘
*/


WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skills
)
SELECT 
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill
FROM skills_array;
/*
┌─────────────┬──────────────┬─────────────┐
│ first_skill │ second_skill │ third_skill │
│   varchar   │   varchar    │   varchar   │
├─────────────┼──────────────┼─────────────┤
│ python      │ r            │ sql         │
└─────────────┴──────────────┴─────────────┘
*/



-- STRUCT

SELECT {skill:'pyhton', type:'programming'} AS skill_struct;
/*
┌────────────────────────────────────────┐
│              skill_struct              │
│ struct(skill varchar, "type" varchar)  │
├────────────────────────────────────────┤
│ {'skill': pyhton, 'type': programming} │
└────────────────────────────────────────┘
*/

SELECT
    STRUCT_PACK(
        skill := 'python',
        type := 'programming'
    ) AS s;
/*
┌────────────────────────────────────────┐
│                   s                    │
│ struct(skill varchar, "type" varchar)  │
├────────────────────────────────────────┤
│ {'skill': python, 'type': programming} │
└────────────────────────────────────────┘
*/

WITH skill_struct AS (
    SELECT STRUCT_PACK(
        skill := 'python',
        type := 'programming'
    ) AS s
)
SELECT
    S.skill,
    s.type
FROM skill_struct;
/*
┌─────────┬─────────────┐
│  skill  │    type     │
│ varchar │   varchar   │
├─────────┼─────────────┤
│ python  │ programming │
└─────────┴─────────────┘
*/


WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
)
SELECT STRUCT_PACK(
    skill := skills,
    type := types
)
FROM skill_table;
/*
┌─────────────────────────────────────────────────┐
│ struct_pack(skill := skills, "type" := "types") │
│      struct(skill varchar, "type" varchar)      │
├─────────────────────────────────────────────────┤
│ {'skill': python, 'type': programming}          │
│ {'skill': sql, 'type': query_language}          │
│ {'skill': r, 'type': programming}               │
└─────────────────────────────────────────────────┘
*/



-- ARRAY OF STRUCTS

SELECT [
    {skill: 'python', type:'programming'},
    {skill: 'sql', type:'query_language'}
] AS skills_array_of_structs;
/*
┌──────────────────────────────────────────────────────────────────────────────────┐
│                             skills_array_of_structs                              │
│                     struct(skill varchar, "type" varchar)[]                      │
├──────────────────────────────────────────────────────────────────────────────────┤
│ [{'skill': python, 'type': programming}, {'skill': sql, 'type': query_language}] │
└──────────────────────────────────────────────────────────────────────────────────┘
*/


WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
)
SELECT
    ARRAY_AGG (
        STRUCT_PACK(
        skill := skills,
        type := types
    ) 
)
FROM skill_table;
/*
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             array_agg(struct_pack(skill := skills, "type" := "types"))                              │
│                                       struct(skill varchar, "type" varchar)[]                                       │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ [{'skill': python, 'type': programming}, {'skill': sql, 'type': query_language}, {'skill': r, 'type': programming}] │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
), skill_array_struct AS (
    SELECT
        ARRAY_AGG (
            STRUCT_PACK(
            skill := skills,
            type := types
        ) 
    ) AS array_struct
    FROM skill_table
)
SELECT 
    array_struct[1],
    array_struct[2],
    array_struct[3]
FROM skill_array_struct;
/*
┌────────────────────────────────────────┬────────────────────────────────────────┬───────────────────────────────────────┐
│            array_struct[1]             │            array_struct[2]             │            array_struct[3]            │
│ struct(skill varchar, "type" varchar)  │ struct(skill varchar, "type" varchar)  │ struct(skill varchar, "type" varchar) │
├────────────────────────────────────────┼────────────────────────────────────────┼───────────────────────────────────────┤
│ {'skill': python, 'type': programming} │ {'skill': sql, 'type': query_language} │ {'skill': r, 'type': programming}     │
└────────────────────────────────────────┴────────────────────────────────────────┴───────────────────────────────────────┘
*/

WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
), skill_array_struct AS (
    SELECT
        ARRAY_AGG (
            STRUCT_PACK(
            skill := skills,
            type := types
        ) 
    ) AS array_struct
    FROM skill_table
)
SELECT 
    array_struct[1].skill,
    array_struct[2].type,
    array_struct[3]
FROM skill_array_struct;
/*
┌─────────────────────────┬──────────────────────────┬───────────────────────────────────────┐
│ (array_struct[1]).skill │ (array_struct[2])."type" │            array_struct[3]            │
│         varchar         │         varchar          │ struct(skill varchar, "type" varchar) │
├─────────────────────────┼──────────────────────────┼───────────────────────────────────────┤
│ python                  │ query_language           │ {'skill': r, 'type': programming}     │
└─────────────────────────┴──────────────────────────┴───────────────────────────────────────┘
*/



-- MAP
WITH skill_map AS (
    SELECT MAP{'skill':'python', 'type':'programming'} AS skill_type
)
SELECT 
    skill_type['skill'],
    skill_type['type']
FROM skill_map;
/*
┌─────────────────────┬────────────────────┐
│ skill_type['skill'] │ skill_type['type'] │
│       varchar       │      varchar       │
├─────────────────────┼────────────────────┤
│ python              │ programming        │
└─────────────────────┴────────────────────┘
*/



-- JSON
-- SELECT
--     TO_JSON('{"skill":"python", "type":"programming"}') AS skill_json;
WITH raw_skill_json AS (
    SELECT
    CAST('{"skill":"python", "type":"programming"}' AS JSON) AS skill_json
)
SELECT 
    skill_json
FROM raw_skill_json;
/*
┌──────────────────────────────────────────┐
│                skill_json                │
│                   json                   │
├──────────────────────────────────────────┤
│ {"skill":"python", "type":"programming"} │
└──────────────────────────────────────────┘
*/

WITH raw_skill_json AS (
    SELECT
    CAST('{"skill":"python", "type":"programming"}' AS JSON) AS skill_json
)
SELECT 
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
FROM raw_skill_json;
/*
┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ struct_pack(skill := json_extract_string(skill_json, '$.skill'), "type" := json_extract_string(skill_json, '$.type')) │
│                                         struct(skill varchar, "type" varchar)                                         │
├───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ {'skill': python, 'type': programming}                                                                                │
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/



-- JSON to array of Structs
WITH raw_json AS (
    SELECT
    '[
        {"skill":"python", "type":"programming"},
        {"skill":"sql", "type":"query_language"},
        {"skill":"r", "type":"programming"}
    ]' :: JSON AS skillS_json
)
SELECT 
    ARRAY_AGG(
        STRUCT_PACK(
            skill := json_extract_string(e.value, '$.skill'),
            type := json_extract_string(e.value, '$.type')
        )
        ORDER BY json_extract_string(e.value, '$.skill')
    )   AS skills 
FROM raw_json, json_each(skills_json) AS e;
/*
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                       skills                                                        │
│                                       struct(skill varchar, "type" varchar)[]                                       │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ [{'skill': python, 'type': programming}, {'skill': r, 'type': programming}, {'skill': sql, 'type': query_language}] │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/





-- Arrays - final Example
-- Build a flat skill table for co-workers to access job titles, salary info, and skills in one table.
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL
LIMIT 10;
/*
┌────────┬───────────────────────────┬─────────────────┬────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ job_id │      job_title_short      │ salary_year_avg │                                              skills_array                                              │
│ int32  │          varchar          │     double      │                                               varchar[]                                                │
├────────┼───────────────────────────┼─────────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 258369 │ Senior Data Engineer      │            NULL │ [go, flow]                                                                                             │
│ 258451 │ Cloud Engineer            │            NULL │ [go, confluence, jira, atlassian]                                                                      │
│ 258489 │ Machine Learning Engineer │         89100.0 │ [python, linux, spark, airflow, docker, kubernetes]                                                    │
│ 258568 │ Data Engineer             │            NULL │ [python, sql, aws, redshift, postgresql, mysql, jira, airflow, github]                                 │
│ 258592 │ Data Engineer             │            NULL │ [sql, python, azure, databricks, snowflake, power bi, ssrs, tableau]                                   │
│ 258616 │ Data Analyst              │            NULL │ [sql, python, bigquery, snowflake, aws, redshift, power bi]                                            │
│ 258631 │ Data Engineer             │            NULL │ [python, snowflake, oracle, aws, dynamodb]                                                             │
│ 258745 │ Machine Learning Engineer │            NULL │ [python, gcp, tensorflow, pytorch, scikit-learn, matplotlib, seaborn, plotly, docker, kubernetes, git] │
│ 258805 │ Business Analyst          │            NULL │ [c, sql, python, r, tableau]                                                                           │
│ 258818 │ Data Scientist            │            NULL │ [python, r, sas, sas, scala, azure, gcp, scikit-learn, pyspark]                                        │
├────────┴───────────────────────────┴─────────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 10 rows                                                                                                                                             4 columns │
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/



CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- From representative of a Data Analyst, analyze the median salary per skill
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_array) AS skill
FROM
    job_skills_array
LIMIT 10;
/*
┌────────┬─────────────────┬─────────────────┬────────────┐
│ job_id │ job_title_short │ salary_year_avg │   skill    │
│ int32  │     varchar     │     double      │  varchar   │
├────────┼─────────────────┼─────────────────┼────────────┤
│ 812095 │ Data Engineer   │            NULL │ python     │
│ 812095 │ Data Engineer   │            NULL │ sql        │
│ 812095 │ Data Engineer   │            NULL │ pyspark    │
│ 812095 │ Data Engineer   │            NULL │ kafka      │
│ 812095 │ Data Engineer   │            NULL │ kubernetes │
│ 812095 │ Data Engineer   │            NULL │ docker     │
│ 812095 │ Data Engineer   │            NULL │ jenkins    │
│ 812095 │ Data Engineer   │            NULL │ aws        │
│ 812095 │ Data Engineer   │            NULL │ databricks │
│ 812151 │ Data Scientist  │            NULL │ python     │
├────────┴─────────────────┴─────────────────┴────────────┤
│ 10 rows                                       4 columns │
└─────────────────────────────────────────────────────────┘
*/

WITH flat_skills AS(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM
        job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC;
/*
┌─────────────────┬───────────────┐
│      skill      │ median_salary │
│     varchar     │    double     │
├─────────────────┼───────────────┤
│ fedora          │      182350.0 │
│ mongo           │      173500.0 │
│ debian          │      173000.0 │
│ haskell         │      165000.0 │
│ apl             │      160000.0 │
│ hugging face    │     157956.75 │
│ puppet          │      157500.0 │
│ watson          │     155391.25 │
│ dplyr           │      155000.0 │
│ golang          │      155000.0 │
│ ruby on rails   │      155000.0 │
│ rust            │      155000.0 │
│ node            │      150000.0 │
│ redis           │      150000.0 │
│ theano          │      150000.0 │
│ pytorch         │      150000.0 │
│ cassandra       │      150000.0 │
│ swift           │      147750.0 │
│ scala           │      147500.0 │
│ gatsby          │      147500.0 │
│   ·             │            ·  │
│   ·             │            ·  │
│   ·             │            ·  │
│ rocketchat      │          NULL │
│ tidyr           │          NULL │
│ microsoft lists │          NULL │
│ ember.js        │          NULL │
│ swit            │          NULL │
│ visualbasic     │          NULL │
│ deno            │          NULL │
│ mlpack          │          NULL │
│ msaccess        │          NULL │
│ gtx             │          NULL │
│ sqlserver       │          NULL │
│ dingtalk        │          NULL │
│ linode          │          NULL │
│ f#              │          NULL │
│ shogun          │          NULL │
│ workzone        │          NULL │
│ wimi            │          NULL │
│ capacitor       │          NULL │
│ huggingface     │          NULL │
│ fann            │          NULL │
├─────────────────┴───────────────┤
│ 256 rows (40 shown)   2 columns │
└─────────────────────────────────┘
*/

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skills
)
SELECT 
    UNNEST(skills)
FROM skills_array;
/*
┌────────────────┐
│ unnest(skills) │
│    varchar     │
├────────────────┤
│ python         │
│ r              │
│ sql            │
└────────────────┘
*/



-- Array of structs - Final Example
-- Build a flat skill & type table for co-workers to access job titles, salary info, skills and type in one table.

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skill_type
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- From the perspective of a Data Analyst, analyze the median salary per type of skill
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skill_type)
FROM job_skills_array_struct;
/*
┌────────┬───────────────────────────┬─────────────────┬───────────────────────────────────────────────────────┐
│ job_id │      job_title_short      │ salary_year_avg │                  unnest(skill_type)                   │
│ int32  │          varchar          │     double      │    struct(skill_type varchar, skill_name varchar)     │
├────────┼───────────────────────────┼─────────────────┼───────────────────────────────────────────────────────┤
│   4663 │ Data Scientist            │            NULL │ {'skill_type': programming, 'skill_name': sql}        │
│   4663 │ Data Scientist            │            NULL │ {'skill_type': programming, 'skill_name': python}     │
│   4663 │ Data Scientist            │            NULL │ {'skill_type': programming, 'skill_name': r}          │
│   4663 │ Data Scientist            │            NULL │ {'skill_type': cloud, 'skill_name': redshift}         │
│   4663 │ Data Scientist            │            NULL │ {'skill_type': libraries, 'skill_name': spark}        │
│   4724 │ Data Engineer             │            NULL │ {'skill_type': programming, 'skill_name': python}     │
│   4724 │ Data Engineer             │            NULL │ {'skill_type': programming, 'skill_name': sql}        │
│   4724 │ Data Engineer             │            NULL │ {'skill_type': cloud, 'skill_name': aws}              │
│   4724 │ Data Engineer             │            NULL │ {'skill_type': libraries, 'skill_name': numpy}        │
│   4724 │ Data Engineer             │            NULL │ {'skill_type': libraries, 'skill_name': pandas}       │
│   4801 │ Data Analyst              │            NULL │ {'skill_type': programming, 'skill_name': assembly}   │
│   4824 │ Data Scientist            │            NULL │ {'skill_type': programming, 'skill_name': sql}        │
│   4824 │ Data Scientist            │            NULL │ {'skill_type': programming, 'skill_name': powershell} │
│   4824 │ Data Scientist            │            NULL │ {'skill_type': cloud, 'skill_name': azure}            │
│   4824 │ Data Scientist            │            NULL │ {'skill_type': cloud, 'skill_name': databricks}       │
│   4896 │ Data Scientist            │            NULL │ {'skill_type': programming, 'skill_name': sql}        │
│   4896 │ Data Scientist            │            NULL │ {'skill_type': programming, 'skill_name': python}     │
│   4896 │ Data Scientist            │            NULL │ {'skill_type': analyst_tools, 'skill_name': tableau}  │
│   4990 │ Data Analyst              │            NULL │ {'skill_type': programming, 'skill_name': sql}        │
│   4990 │ Data Analyst              │            NULL │ {'skill_type': programming, 'skill_name': t-sql}      │
│     ·  │      ·                    │              ·  │                    ·                                  │
│     ·  │      ·                    │              ·  │                    ·                                  │
│     ·  │      ·                    │              ·  │                    ·                                  │
│ 914623 │ Business Analyst          │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 920348 │ Data Scientist            │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 924586 │ Senior Data Scientist     │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 935863 │ Senior Data Engineer      │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 958983 │ Cloud Engineer            │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 968314 │ Data Analyst              │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 972105 │ Data Scientist            │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 974763 │ Senior Data Engineer      │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 977582 │ Software Engineer         │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 741017 │ Machine Learning Engineer │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 744240 │ Data Scientist            │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 749048 │ Business Analyst          │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 763753 │ Business Analyst          │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 765282 │ Data Scientist            │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 769891 │ Data Analyst              │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 778933 │ Data Engineer             │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 783184 │ Business Analyst          │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 790550 │ Data Analyst              │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 793687 │ Data Analyst              │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
│ 798546 │ Business Analyst          │            NULL │ {'skill_type': NULL, 'skill_name': NULL}              │
├────────┴───────────────────────────┴─────────────────┴───────────────────────────────────────────────────────┤
│ 7478801 rows (7.48 million rows, 40 shown)                                                         4 columns │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skill_type).skill_type AS skill_type,
    UNNEST(skill_type).skill_name AS skill_name
FROM job_skills_array_struct;
/*
┌────────┬───────────────────────────┬─────────────────┬───────────────┬────────────┐
│ job_id │      job_title_short      │ salary_year_avg │  skill_type   │ skill_name │
│ int32  │          varchar          │     double      │    varchar    │  varchar   │
├────────┼───────────────────────────┼─────────────────┼───────────────┼────────────┤
│   4663 │ Data Scientist            │            NULL │ programming   │ sql        │
│   4663 │ Data Scientist            │            NULL │ programming   │ python     │
│   4663 │ Data Scientist            │            NULL │ programming   │ r          │
│   4663 │ Data Scientist            │            NULL │ cloud         │ redshift   │
│   4663 │ Data Scientist            │            NULL │ libraries     │ spark      │
│   4724 │ Data Engineer             │            NULL │ programming   │ python     │
│   4724 │ Data Engineer             │            NULL │ programming   │ sql        │
│   4724 │ Data Engineer             │            NULL │ cloud         │ aws        │
│   4724 │ Data Engineer             │            NULL │ libraries     │ numpy      │
│   4724 │ Data Engineer             │            NULL │ libraries     │ pandas     │
│   4801 │ Data Analyst              │            NULL │ programming   │ assembly   │
│   4824 │ Data Scientist            │            NULL │ programming   │ sql        │
│   4824 │ Data Scientist            │            NULL │ programming   │ powershell │
│   4824 │ Data Scientist            │            NULL │ cloud         │ azure      │
│   4824 │ Data Scientist            │            NULL │ cloud         │ databricks │
│   4896 │ Data Scientist            │            NULL │ programming   │ sql        │
│   4896 │ Data Scientist            │            NULL │ programming   │ python     │
│   4896 │ Data Scientist            │            NULL │ analyst_tools │ tableau    │
│   4990 │ Data Analyst              │            NULL │ programming   │ sql        │
│   4990 │ Data Analyst              │            NULL │ programming   │ t-sql      │
│     ·  │      ·                    │              ·  │  ·            │  ·         │
│     ·  │      ·                    │              ·  │  ·            │  ·         │
│     ·  │      ·                    │              ·  │  ·            │  ·         │
│ 914623 │ Business Analyst          │            NULL │ NULL          │ NULL       │
│ 920348 │ Data Scientist            │            NULL │ NULL          │ NULL       │
│ 924586 │ Senior Data Scientist     │            NULL │ NULL          │ NULL       │
│ 935863 │ Senior Data Engineer      │            NULL │ NULL          │ NULL       │
│ 958983 │ Cloud Engineer            │            NULL │ NULL          │ NULL       │
│ 968314 │ Data Analyst              │            NULL │ NULL          │ NULL       │
│ 972105 │ Data Scientist            │            NULL │ NULL          │ NULL       │
│ 974763 │ Senior Data Engineer      │            NULL │ NULL          │ NULL       │
│ 977582 │ Software Engineer         │            NULL │ NULL          │ NULL       │
│ 741017 │ Machine Learning Engineer │            NULL │ NULL          │ NULL       │
│ 744240 │ Data Scientist            │            NULL │ NULL          │ NULL       │
│ 749048 │ Business Analyst          │            NULL │ NULL          │ NULL       │
│ 763753 │ Business Analyst          │            NULL │ NULL          │ NULL       │
│ 765282 │ Data Scientist            │            NULL │ NULL          │ NULL       │
│ 769891 │ Data Analyst              │            NULL │ NULL          │ NULL       │
│ 778933 │ Data Engineer             │            NULL │ NULL          │ NULL       │
│ 783184 │ Business Analyst          │            NULL │ NULL          │ NULL       │
│ 790550 │ Data Analyst              │            NULL │ NULL          │ NULL       │
│ 793687 │ Data Analyst              │            NULL │ NULL          │ NULL       │
│ 798546 │ Business Analyst          │            NULL │ NULL          │ NULL       │
├────────┴───────────────────────────┴─────────────────┴───────────────┴────────────┤
│ 7478801 rows (7.48 million rows, 40 shown)                              5 columns │
└───────────────────────────────────────────────────────────────────────────────────┘
*/

WITH flat_skills AS(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skill_type).skill_type AS skill_type,
        UNNEST(skill_type).skill_name AS skill_name
    FROM job_skills_array_struct
)
SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill_type
ORDER BY median_salary DESC;
/*
┌───────────────┬───────────────┐
│  skill_type   │ median_salary │
│    varchar    │    double     │
├───────────────┼───────────────┤
│ libraries     │      140000.0 │
│ cloud         │      132500.0 │
│ other         │      130000.0 │
│ sync          │      125000.0 │
│ databases     │      125000.0 │
│ webframeworks │      125000.0 │
│ programming   │      125000.0 │
│ os            │      122087.0 │
│ async         │      120000.0 │
│ analyst_tools │      103000.0 │
│ NULL          │      100430.0 │
├───────────────┴───────────────┤
│ 11 rows             2 columns │
└───────────────────────────────┘
*/